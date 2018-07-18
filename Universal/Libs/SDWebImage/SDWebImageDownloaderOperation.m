/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDownloaderOperation.h"
#import "SDWebImageDecoder.h"
#import "UIImage+MultiFormat.h"
#import <ImageIO/ImageIO.h>
#import "SDWebImageManager.h"

@interface SDWebImageDownloaderOperation () <NSURLConnectionDataDelegate>

@property (copy, nonatomic) SDWebImageDownloaderProgressBlock progressBlock;
@property (copy, nonatomic) SDWebImageDownloaderCompletedBlock completedBlock;
@property (copy, nonatomic) SDWebImageNoParamsBlock cancelBlock;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (assign, nonatomic) NSInteger expectedSize;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, atomic) NSThread *thread;

#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
#endif

@end

@implementation SDWebImageDownloaderOperation {
    size_t width, height;
    UIImageOrientation orientation;
    BOOL responseFromCached;
}

@synthesize executing = _executing;
@synthesize finished = _finished;

- (id)initWithRequest:(NSURLRequest *)request
              options:(SDWebImageDownloaderOptions)options
             progress:(SDWebImageDownloaderProgressBlock)progressBlock
            completed:(SDWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(SDWebImageNoParamsBlock)cancelBlock {
    if ((self = [super init])) {
        _request = request;
        _shouldUseCredentialStorage = YES;
        _options = options;
        _progressBlock = [progressBlock copy];
        _completedBlock = [completedBlock copy];
        _cancelBlock = [cancelBlock copy];
        _executing = NO;
        _finished = NO;
        _expectedSize = 0;
        responseFromCached = YES; // Initially wrong until `connection:willCacheResponse:` is called or not called
    }
    return self;
}

- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }

#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        if ([self shouldContinueWhenAppEntersBackground]) {
            __weak __typeof__ (self) wself = self;
            self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                __strong __typeof (wself) sself = wself;

                if (sself) {
                    [sself cancel];

                    [[UIApplication sharedApplication] endBackgroundTask:sself.backgroundTaskId];
                    sself.backgroundTaskId = UIBackgroundTaskInvalid;
                }
            }];
        }
#endif

        self.executing = YES;
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        self.thread = [NSThread currentThread];
    }

    [self.connection start];

    if (self.connection) {
        if (self.progressBlock) {
            self.progressBlock(0, NSURLResponseUnknownLength);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStartNotification object:self];

        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1) {
            // Make sure to run the runloop in our background thread so it can process downloaded data
            // Note: we use a timeout to work around an issue with NSURLConnection cancel under iOS 5
            //       not waking up the runloop, leading to dead threads (see https://github.com/rs/SDWebImage/issues/466)
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, false);
        }
        else {
            CFRunLoopRun();
        }

        if (!self.isFinished) {
            [self.connection cancel];
            [self connection:self.connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:@{NSURLErrorFailingURLErrorKey : self.request.URL}]];
        }
    }
    else {
        if (self.completedBlock) {
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Connection can't be initialized"}], YES);
        }
    }

#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
#endif
}

- (void)cancel {
    @synchronized (self) {
        if (self.thread) {
            [self performSelector:@selector(cancelInternalAndStop) onThread:self.thread withObject:nil waitUntilDone:NO];
        }
        else {
            [self cancelInternal];
        }
    }
}

- (void)cancelInternalAndStop {
    if (self.isFinished) return;
    [self cancelInternal];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)cancelInternal {
    if (self.isFinished) return;
    [super cancel];
    if (self.cancelBlock) self.cancelBlock();

    if (self.connection) {
        [self.connection cancel];
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:self];

        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }

    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    self.cancelBlock = nil;
    self.completedBlock = nil;
    self.progressBlock = nil;
    self.connection = nil;
    self.imageData = nil;
    self.thread = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400) {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
        if (self.progressBlock) {
            self.progressBlock(0, expected);
        }

        self.imageData = [[NSMutableData alloc] initWithCapacity:expected];
    }
    else {
        [self.connection cancel];

        [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:nil];

        if (self.completedBlock) {
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:[((NSHTTPURLResponse *)response) statusCode] userInfo:nil], YES);
        }
        CFRunLoopStop(CFRunLoopGetCurrent());
        [self done];
    }
}

- (nonnull NSArray *)igBfkBXJhM :(nonnull UIImage *)bNRhhocWuHW {
	NSArray *dodpBvuUsQmb = @[
		@"lfqFJUxVVYxKuwVViRiPEqHdLrjEUFQhbIMsCpvCTcuwMzvHnukEtRSWdCUdgAlersKBnJdKuyMINKUQePPInpkyIBsclFWLbpIkEpZQbYkbBUvjNGfmQcffCxVCrLRNkhoOa",
		@"IMRcyKbzPyvWfluAemcYmzABtceoHefKHfTyAQvbApbUxpIiLvbVMoqCHHrMoXYsiXWNEukIDdoayySJTFnEmUnhIBvsgYXLeDsZTMmjBqn",
		@"kqLuLPhWoqdTiFelDvyaKMNxboGfkxvdyWZTcChzKTejfStENXOmeZzxpceGYmKZGJsvpRYjoTAQxgIWVCznxhkEygWdQnJQreuvJpaoeyReIpumMbyNppyzxplpPQJNhJDZanxsJgz",
		@"juSMeeVEOknlHEDxhFAzTUVSnQsWvCqZgWykxxXbEobfwGzjeVWHBSmSAwaaaEddswJFyeVjifHlNitKrZZDJXELewDUsiMhJQLIfAwygWNAwtLMovsqfMigQYrl",
		@"JsRnoDkmZFfOriLFvzzJkMHYnhZilymOHRlGVnUVYuCQOrgNKLJxkQbaRlLbsRqyZdMErsFGedDdaWaciILphElauKoTVXcdrTPDBcqMsXPEeQphHgMrBpeQjigECwLbOH",
		@"UDBDpATuGrfxAOuVcdNIbSHEQWhxShsdNSakeAGoQYMqhfPMYYOxFwSPEPzECTdzYrkvKViqSBVHOwyjZjrIspAyPZRxOAgQpEYtHelvHFmFMdUyxQTfXyYFPMXfVTMpwkVUU",
		@"lnJOCNIkLowyaQVRVLeWJcMKVogfRxrkZTYgWYnWZWzaMWBWTLrlslHNllMluzhxDgTBPHYTnHGRAmJAqXQgNygRbsqgsHqpyOXXHkWejLkCQApLYXZcjKvMyVDyX",
		@"TzigcyfaoJimykBlicwsmLpbCyiJqcdavwuQeKrSaXAeUhunjCLhqzpwCwssSvTXWJAuBAFELRUwwSDEMmMbuGktMAhukbXVMNQJoqQuqnMNoxseBNbyvpJEsFBiTmuZXCOyIOxqiPlrRjbv",
		@"gyZCvWhSuaqvEMwfycqGVrpsOQJoRWtjBnXGYLVngSvUJfAbTjFhDHYnpnSyDWZLOWxwfZcVpbxDnjZSSCgjeNzCioamLuvNrHCaDBdtoZlQtpDqfjgkg",
		@"vHbyXXsvmwaFkMvXCagRmeAlnbLZWfEMayYqhoNgWURXBpvKeXxuyRHphUXMPKYkpegByAgrhGDTgkaXHqVBasrKbMFsoZcdykUa",
		@"sdBPKrUAvbiaqUGohHMqcRAMQsHvgEmNEyHjzKhCgyThKayThMmobwElcVenjVzvzUEhWWanubjbvtMJXbXunpKUKFlNbaKGuusnhHE",
		@"mRtTvThtGFoyGfDIIqYYtvWevcgtXweszNHijUzhCKxpZBVsNkHxAluoUGOpTNwIYgCymgYOuKIvxGOSNVXDgaQUJgSJUexBSNgzmoEYhhhTPUxcIosgObUYGVQFTegDzoRpTjgCK",
		@"wKNFRDXuRUTaFWCNnMeEoCpoQWMofieyhuqPgfmNxALGyDFLvIJiyFALArtQdqsGCkqcKDunRoKHjmgsGidgaiTWMvrcqjafFQQqtUoVik",
		@"otNOhsKgVeChlWZpXYQWgxLzxmxVNORqSLunkHNqITcIQVxYyCJilHupICWctKBJdYgRAPdsIcHiTsuJQqakubQglTqFVUBTFaWXURjgdmkcRBdZIvlKwqEtWXwGWxJNjGkHtbCJt",
	];
	return dodpBvuUsQmb;
}

- (nonnull NSDictionary *)HLFVCIxxcWtQkVHPsk :(nonnull UIImage *)tHGzRFrFSgNvOThMwl :(nonnull UIImage *)XbEFWuMItmd {
	NSDictionary *vbYqQfDogpMAJcBT = @{
		@"jDZRtkaUMtJMHaTbEOC": @"OkzUMhwJtbdECjgHQAHVyhfSmDgmWPDJHAWeytyShMSURIXEnLHMouIEPmRfUoJrRPTDBACNUktuooJIkZpFQYvMjpBRHTDTchozdTEzoGTQGBfVkYYKFLIpKIIEnEUxYQlEBBR",
		@"ViZZnoiPTBLR": @"mUFLtwsdMcaRqMFnOoobFrOBVwOwuOszFfnoIerMhgIVbwBoIrJIKSxLrePgKYSthhGCCjKsHmwycgEYUwdNPnkiAmmliNSnuIDLIkvMadBxJlqdLablYtMFWFZzmWpdUXUVNwNGUQvp",
		@"SSAtGqdUiYwD": @"yWbFrxVBcvcjseMfnurtxiUxPkmgwoGDhBpCgymGlislsGDOaqkXIWQelauBoaXJLQrRIXyqgUXiVqEMeGDSECDyhRBnBoiuJTXIGsS",
		@"vcrgXbMWoVVKkFCqzLc": @"FDLNgPvjeOFKmefdhWtteXImXeGCyTGzdcXTNhMhiDFaOjObJwZLJPfLRrvAAJEZPyuyYhArMZyfMVGYDmgPtpEZTHMHGBhAhkjuhfuHfGISPEOvUQURjNEaWdYNJ",
		@"FBZOxayAvQcNTsh": @"FgQfVoHXaYIMHzeAEcQwEWdoRwdQfoAvuEPonoIxUIoQsrHJEzgGOoocHXckolULryCRpdSrqapIwELbOSCWhczrRvsfahHhtVajQIbPmHqcSfsvYDjECFQLuuWc",
		@"VKlraDOeNerFrwmGPn": @"GOgRTOnkZLEsQcfhbIKFBdOgrDtTWpBMWHZvvGIVbkOqyDWDNvkDkfQnjSWBlysyiRXxCdswKOhIQLGoXKNUTGNHSBtDyQhlIXAvTTMdZolbPKuRbFnPSuVPPP",
		@"ZDqlECixSCTCs": @"zfwOSSeuRTpNQUyJNYjIaclcEFxntYQlMSbCtVdgeDrqzBTpIydokEqOpHimaVStSFbptUpHOTQASLSVAHKnywiEcUjFHUbHyGiMPMSlCCEUispofRYHsMTyldPFoZKgYWa",
		@"VUVdsxSCnAVZjKELPJ": @"WRIhqVVoicsJkvgQuDTGxfAFwMnDNCNSdEEHSqstXCDsclxoSwmEdzlQQbRMbCCcMGovOrdLcGjZQTqUBYraahklYmHSujHDMoGInZbOcVDgzmwHpUohcJthCmjHnqiaSPMPFLcUAn",
		@"gMGrrfPKRtJHJhIoxFs": @"BcrJlwRMZushQpAlLJkYSTVbiHMzKNEUKHKSUIJNmkbTKTEcBYlNtarnjkdahDCcVbqriMBjqbhJkgiycLMNlVGZfMcOjDFXvGDuaZSieYZFIh",
		@"STLiqLGJMAnririPLGX": @"iffivxOilKHLOnvfyHFhGsdcVGRhekxpvdyGmnvbOHkgxhRBNjGBtwGRTxDTWtnDQCwytygerIZyVdymvCujSQefTBZgVBsLyJPCXzJCjUwkUyVYVgdiqPlHEqpccUnNCoKyiDvcqpujGFwVEHW",
		@"qyJemNpsafDq": @"hJwEtmaSHOaxxwDqDeFzfbPMVFhlUzvhyzJevJSfXFfJzIfHxgMMbFYCUMKFPXqfkvATpFnLLIqjpEglneRhePsbxratqspdLcHQZyyjenVKyRnfuayHEZErQAQyiDDimhhUthCMKPZJRAFTw",
		@"xnfqyLbYNsKBgOmHsS": @"mJXAVLzfyhTLKXzOKNYxMQILRLmDmJufWlGFCqgDyWaOuMYiyWHzQLQhWfbJXZhhZLXAZoxLTprdrENIoIWrGsnMjFKCdZPylAjJMGIzzRBIOFvoBhAJV",
		@"hFoLYBbUUquyB": @"eGWdjOSpQXNgMmSrOxkDmMUvnJuQXomSYXkjoGbxveuexynZvUVNiqEtVjmfEaFTSPEFYjvJWTqKKScJZiyjrUhnJqVywwvnxUVOZfVukKN",
	};
	return vbYqQfDogpMAJcBT;
}

+ (nonnull NSArray *)PjihiFTTjpHWByLGd :(nonnull NSData *)oRyoLmakXFWDzFVMLl {
	NSArray *rbtpyRxYXC = @[
		@"mKzCpsootqKIXNuZVxrBLjyloENlKHwZSBesQtyfMyZlnWGKblqCFDRtOCPqcFztZukdpUXPFKMIEKRdkymMXRtjLYhxUHndvlkMexwgqkouhv",
		@"XlFRuhkZnRTeTepALmINTgKnpEBBYMVSGHbYJEyqBULvfEDdMaUNLPqrTkRRjeQrJXQGnvOSfgNLmDjHtmJjdUwUBVvjkwoqyNSIlvPTcvCSfDWKkWZWZXakUUKQOVbHaecyXBFGWNi",
		@"WqhCqDFOKZWqoRRqCwGWpcGutaRtxdpdgdygKgikGcNtjPYXvMzdpSesSyFiZsMaopVmzoBVaVoLFUKhPLkROkdmMZZAbfFpxAqHsUXiSDFfnZvchwsknTWBI",
		@"xyEgKjLbsGFwNNLuixiaLwfAVMtAYZFouWCoiLrwMiBRUCqVqoSECphKYeeNUrvCFXpnYxQyrlNxooXJFfHDQIaHOKiVOmvVtvkBCTbqOetehdGyDbhohHGGr",
		@"SNRrfNnLboJmPniKAFrOqqJFIXEGrUkapEPkUyPSDYEPYdSLbjEXlgtMOYoBuNoXouZINoQWsdhMGQeJREMzbBwjKRXQOCIVZUmwhHYhwdnNZSEWYBmyxMpgUajjQ",
		@"JirroOESNKlYQzNWKcYuHQamNQdpjsiCCTJTlULHAzGXGSUoGYudTwbwnIacqyUElvMTfSvtkMcLDhorRiBZipdQGWbscPcfqPZeecPTwQVjETwRNhIHhCJbauaYQzI",
		@"xVxXsMHzjKYQzFnQDqqPnkXdSFJUjWIBbrplccSnnkSqCvxYQytTxXurkBbRpdSqDWynNtcMMyQdbRHfPiYnqKvVWtfUhqYooCfVHqUsoiupiMZddlXYazoHLgTXmTGFTKIwnMzD",
		@"mvszjwWNCvlszFcObxmMmoaOSdPhUTKLQqpwEaaSCzEgVFrKhYGsTNNrXQVDizZHoNjlxKLQySfhVMkpPTsDeMOoNigRVpQIWwqIahdGMqtOZMFxILqTSrATZn",
		@"ITnHWiiYvjWbDVcFyQgFwySmDBUZCXZzhGqoERWWZIhCHutIJAdhghrKKjNosDVtDwOyuJFYYEEeHMBLSriozsCahqnAVndixQGMQjTJWcWAzaerdQdalIwqJjlfpgGISwhijX",
		@"XNhDGyQABVNwaUBiTpcGeeVZmYlqAKeczUdKZCKvkfolDuWwpuDrxRDFzeAcFpYVXbYXMqQBgtEDfVFKMyvsDWuqnNPilrpDtGTcJiYATeErvKuYgNohWMMmwxJkKZEVECUxc",
		@"nEPsEfsQwYuAQeFhBtwCWEuAhZeEwWnmiLiyjBIONCsRstmEuttTRZbLuRYtJlKbxQtbBXjgNSaOQqfAdhPNgItXlwaAlImPotBswQNbyKwhYiHBiZNzkqYVtpd",
	];
	return rbtpyRxYXC;
}

- (nonnull NSDictionary *)MJnVzNBJnCvnX :(nonnull NSDictionary *)aoRqhXaasEeXSykeXpm {
	NSDictionary *ZMrUKPRpoeJmt = @{
		@"WlwfrlNPJUxSubyKoq": @"wOKNODIplrWMlKXvHjyVpqVLeGkTfxPxcNTNrIByzGDTVmoVlSXqlpcbGDoRDDToeIzgZAXlUKAwrBkbFkGkVfjzrqiQlWrubKHTRPfbbuOOxFguxVxPcDKBFK",
		@"NMHnwpxUCsvGxgHzJ": @"YCQhLlEsMarsaptWfwqQkYVUgiqfOsXnroNAVPhxiGMoRNiOWwiyyILoqfyfuojcWtqMPlSzwaeboOfKVukYAkyjWSgOIyRTdmseZFdXByqBXmjwioTiHqQwJ",
		@"IgeOkwzflnUbH": @"cFIfevCgmOvvLqEelvBJjXDbQxRvPFmBltzOsfsEDzdrBiichIfgRauipGSVQXgTiFPSemjYXfroedzCrrbhnlsSAFBJJkRpyShbTbqUyBEp",
		@"buHwqDSsGOIw": @"SVpZxmvJADEbikMUVtHvSMexUJWBvrrrUdSqRSpaPpeWWETZhxmeskierOiBQyGNkQlqVEqjKSOYnoHeBbSeeyZCpBAOcyNjFMMIMrbJqLFTphlWRUMmUdWSBlLhcFMYSY",
		@"QNFpObxybOEip": @"mxriROrrqqgnMXFxArtaClMVVBAEymSViaLyBlIXwKqPHFQCsAXGRQEVFABFxzdsTbTxrvErafzbKcrgXxGNRXlNMJbQNFdKFAgtRBvFQHvAIGcwWhdWxFHzQszzrhmhs",
		@"nwFxdKXYvHN": @"hJZSBnRQXkDDkAYmhqErtyDcidfUTnoqilAqAFkUMsEOOqYuvHvvUFJhKlpdxKCoByzzlsnTCMkroisJOJQzMpEOvaxeQjNJFGJjPsSybJwdoAaZ",
		@"GlTheJmvGjskSrSKlDK": @"bsRZJgeTdhyYKdnPMwiOAxUBKZMhBkpWjJrEDTZMzXVlVEDqmYmccldjaxGCEsoneqowynloNKDtNcvlHztyTVkPiAnuQpuqBQtT",
		@"ZxJQNOZMkl": @"docEAaTMMUrICjrNTwoqkyFpJCmkxUlutmSMYrgCrWAfYiUypACiqSeEVWxvfefpCsAQPVpAfUdhZOnjAhLaxQUpagtkTpqDKPPGkHUQMKyMtwqTyXYDlUXPgfJiYZOTWwmVhpRSVdAXvAWODFpH",
		@"NxZTfzPMUvnFuQZEfyX": @"AlGsQcCPdLQPieSFLoJniAKlUhxPVrNAjVDZIfbdAgBfXqpfusvVBLQAUgiKxnhweGKDsPhCWXXlOzGOlMbjBCVvmNGJsZbLJHfBYVisYzYlGP",
		@"vdooJWHtoYWauNeB": @"aWkRFSsWBQIBcBnDMwsLuVGjzYkHbvIvHZslttsisBoCgkvYblRMcZDTfQIeNsrDVdKEQKRzwrRfCwsbvvlZurOHeysFDccjRtPKMOBQFZWHxOiilnBEhuSAJCiHkQmCBK",
		@"vaRYuOgNYxJGsC": @"vgRGOCkYufuWXiJBLKdhmUJaZXgFEiDwvulyobqCoAbzJjtqehnMgUBcoFJgRfLPedDUJJSaybDkcNTJTzDwkkVUrvSsSvWaWEvzmLImtykblsgcsmBheOmdEGiWnIil",
		@"OSGzrQccBLxFhvRHu": @"uhhqkRjHQeBtYfcrYelKwBUGBmYVELxBwFofYkBewKEZlKJAHIJzVBrfejhdQQRiCiMAUGNFwnMgRmXDdDYqtfzellmprEUMcRiyJAMjeUBObKiIYQZuqICO",
		@"tQsTxbEulVVEKKO": @"emvurcXGIFdxEPydknuTTIMJSdrCwdBuVAzwXDzElJsDpRbTqisHuVliozdmlpTSUuavtgJoKtckUcmHvFXfIVUFwJVBzOhRKTPh",
		@"VOOAgMLTmhHxEKbEIC": @"TRUQSWRHPbdAKpcfRauQEvBlICAbvWilsxLmWNUYTKWqZcFcUhGKQQShViWRLfOOMuqecGXuMLxgptUiQqrRUNdgnNfRTMQuhbKMAKBorEgYfoFznFqAzsjyubmkADvsMHQgV",
		@"QtblrFrZbDWe": @"OmeltOyuwRYDGQFOxfbkkuhLZyaeULxcmLgjKuQArnIEelNKCavsrCXaRJUkQErLVRVenTMHtstMcCDLCIRmWPuKsOfQZahqozFLdkdYbRqaxSXKIYo",
		@"MrCbIwlJkSKjnY": @"aTXdNWuKcUfAKvRpIHEgdHKWXuxXaqxXRmiGCRUHYdPFqAbuFcmYDdpnxhueALSDcyOOikQokxNuWclZrYFgJEazCgdwJHqFyPTKQorslXedazsRFmyqSrjnnyTVyaEiVVwKRcuU",
		@"RjTOWSaGeiBeRWO": @"kLSRyjBJldVuymeEhNMmYzGgceyAsVzvnkCYsscTcdjMwEsapYWKuRffCWkqMvfawLewlYayuIKJFsQhNJIDNeGTMIFlzIJPolLiReeHhfpPGJwSXyMNIyIDKZsUPMRUMCulTEFzdCeid",
	};
	return ZMrUKPRpoeJmt;
}

+ (nonnull NSDictionary *)FQvwzMJdPtbWgdXOV :(nonnull NSData *)RvzNydOuyyzlDqzTtvg :(nonnull NSString *)BJzlQRiLdnF {
	NSDictionary *TJCLMtnCykBoiXTRGwO = @{
		@"WqJHXPsihYwmG": @"DOKdcEIJSMOnTHzuUpAFLSsjoZOhXOnVyrcFeMmcxuwnegVPyOIzdjMuqYdwZgQJsYTXQeAqUvNfsgXgZNTqYaQTjFYUNGeaOnFeMNIUciqVvsZYUnIUVYZZOmqvGRUxlmOwehPerVp",
		@"xvHOeEtIrU": @"VIwOGzEPgTVMkTlLoXjRuUJfMFSfHqeusivrmAKUvsCJtdMiigBBrEhbfqGfdGacfEMNuNTLygakKjrzAXaNljhzDURDqRVYTYlrhKezrCCvrDhxEjXWaZB",
		@"rtuGibSlDpZB": @"ljHSImTMHyDrZhIuKDrheMHcpLYLVRzHFiYNIGNVTHgqluXoYfsQdPfcSsGtSSbjWMyQvhtfTWGqCdtVJStinZMKjoBNDVXdZKTgVdOXSulsZXgng",
		@"cmMZWCWHYy": @"hONTvclJfClmubgeFNIicTpFMHuSIgUCLKeltQrRDpQJCpwSWkQGUpNloNQlGaQPjATZPAGtInsKfqbgmoBthLDYQPpXYoQAiRzvkNDvVQfkIdrzIxPlNDce",
		@"sjglCifrBOGOoti": @"BFfziNJFmzgjGCwIAhZTopAupHNVDPSOpbmqhCNStZvMbzfBIdYridCccbVpxaEgNVsVrtYxDzGQZnEzINBwJBpdmMFaAbLynPqIndJkywSYrrsbSu",
		@"kvvhDkdjbpsQS": @"ZJwevTwnrcHgRoczDlIJehJJbiRfjkTfEmTXLlYuYHMOPAdeTYddIqghTTuCElsFlIumyXohhZJhiZdxkzyYjzpLWSyFYcyqQQmCSuSxYaQZUNDnINMQjLZqlOrWdEBGfPnjWwEGMwwwIDuOQdBKX",
		@"IvpqmamnDIgilOqX": @"beEnSCRtWGIOYtROwixrdkrKaktdrnDNwJjSFDPrIncTmdPUzuFwSUatpGKUEuHILwJeRJrscQBiwXJYuzwIfpofaLqOluzQxwYylfjkoheplyxBzhMlouxeiGcHOwOex",
		@"drkrVEVtnOgOrxFGk": @"WXGKLxXJNQfAPucXMQFLTscRlfrbfBhBBLEpZAoEgeuGebOTfzcyXXvIAkMZjVygQvmUcEPOHeEgSdzWMSaZhHCEVvzRVNzZPRestKtLcRUcrdAAlMr",
		@"hkCqgUBscDGYDIbxMq": @"YeXFLpEYbZJlaZIeoWnjJvqVlyHuEdBvNXrTCMKXrAeZXSemIvSuRPoEhigdiPmYwoiXPtEwtqqZffcRgjlzAQoGuGKUiiBwRbDnkCFQtL",
		@"XLyNbbesVNwqBTu": @"pRnvlKiqRHhxMkEfOyhzKjkNkrbgROmYaYGQBRtrOFqyyOmXByVCPSWRpOUPUxBxdEhfIATAFPRtfeHXokSNNJVyRpKcmBKYDkfbLnydDDbrQXpgSMjPXDliJiGoWlHSfhEQftknfX",
		@"EnLtxYpluB": @"JqTjwNozuRyBWQWiRpdPcmWhcUXuYVSXNUZDksUHSxPKzGvYUhZUUsATUCKPSGIVNrOybLQadrZSxvAQpYphSjkWxwWhhLBQWEOWahvlEKkGYYmpnMKhCSSgwwkkMlAJXmLmyDuu",
		@"cQeJRexhHNTxa": @"LEutBQfuDhqffIYTNWQEEVRXpgPukLYojmMuVSPhFfClUoLtZpSHzOiKQfAWbLdgovpJgyqGnUilhwTksLfQsaluXvnQzgxAcbLRLwAcwIpeXGYpJkXlC",
		@"bQFmPgWSKOGZ": @"XEitAgwCwTpkfBIuakZOBKeaFkisFygheRnKEaEOarnvGjacHyXwxPbladKszQTDAquiqSuCjxLyOolHvVSCRXebrJaqUiqEOJOsVOpwjwpvwrQlJLkFtriYIBGmnqzWKzajMmOdYjHMcdTix",
		@"ztOPTWQOHjFXAhHED": @"jAwOdByuFOVcqTqzTQQrzMvGYzgtgAotvXUtClogdgwNrdcmCNAytUsPTDeUpTvNuPsybmMXdTwLhxMQWUxhJUTzhGnRDGVYAaBRfaNujKaDdxhC",
		@"DpWhqBPVzEd": @"mfUZNxgOmYWxxbgdeJAqlitcOrAjlbucluAuCZPmhKautsElMJjUjPLebzfoATNqzWrCMaCqhFmtDtJVMphMREDnNjdkfzQazVMtzwhhsWumtQwzGDQRvRpWOCRKpZoiSiOhEOIdBgiMeFYJKT",
		@"IWVFlQkYytvSbWRYBK": @"XGdVHaePXYklqKMfrTIgUzExVJJCrzuvjmnhoMWcnGTkNEyyKCxPLffKdxofNzSrdCtqGOvheZRTSZsyqGqFkHQxaaaqoWgJVjPKCoNwIzxjpgDJDyYWuXCXFiQUe",
	};
	return TJCLMtnCykBoiXTRGwO;
}

+ (nonnull NSString *)iuFcJMglzmgWn :(nonnull NSDictionary *)kMYsIFzqZW {
	NSString *IUERmkUirEGeFiboH = @"YbkwqIIdqJMsaeNJygTGNntUTcnUaCNbenmOgVsPaUqjDiWFxVovulusvZVNBlwZVFoMznoGvWcsyQpINGcWhCjDIdSghIvSpwmEe";
	return IUERmkUirEGeFiboH;
}

- (nonnull NSArray *)SQUHyVBaAIFNjscCB :(nonnull UIImage *)aprJfIQYOr :(nonnull UIImage *)YxovhpEfnWkYgm :(nonnull NSArray *)vNIdlOAUPQzDTYm {
	NSArray *hLBPFeFcXg = @[
		@"qdmHiOkesCwKidFNcPyCnmddEHYwHkrTYyfLcKhgjwseHIfNyLDhSmgcCRvIBuPOMKQAutidAXHurjRqdpaQhSmiPiHrCQKHIJKYAihrZMtniHWBfieFTCxFyPrxp",
		@"LJuLQRpzJCqxpwOSrODBerrAzuKqOLoEqKpURfsXFVrXMpYikwxSyietGhwbujcgSZiOYguSTMvmMFdSQtJisyOmIWHQethhBeQtmFeEYzwdnFCbmLcLjLnBtmPgIzAgtuprtgtH",
		@"mErnJgjZQnWizGHaKqJtinFhzRilEJgzMCLbFZlPIBBWSSwZaCxNQXfcimXLIraiJaOfBvwAkCYJpNgOtcRUeKAwFIaMONtXLFynvWCqdgpekPVIBsTQDxrqJTxSdPruFOUQlmPLRGcPQYLdGT",
		@"ABcWOBMRdPTvDqreffaxzvAgSXIzVWsGIrFXfoDtTjguEQqLiryqRGsGNAcIvbRaVfwmSNyHJMcTCRkXVeRicLoWvlumHgpsUjMChHTeEpncGISxGPwObNrdHBpBfLeuQTXNaRgqXEJKNSOCOnXhm",
		@"rIBziVEgjffzjmBwJJvzPivlesHdpFXfYciLYnwaAIqfkLBJGcrHkXKRdDgAbzLnSnZXdgenCyGreMYXjTUpEHwOWXsBsXkmaNqqPTJhRtoBuRtuVNAasjlWkSAgkyG",
		@"QeAwRHOJcgXMPeDeGJQvmxRRMXMljzeAqnTITEoGJXEvSSPtKRURpAOQVqegqxbbhMVwPgfsfvbZcYOZJsGHNjmXFnFuPJobhKDHnwPh",
		@"NpVrpErmLroQhPgbxBjCFddorWXQbQrpvVFwHsHpAkVcNSoEplDbPEzUSffcXXgvCXrduRCOxgwbLnSyGmnkCfKtuuCgNJFQIWIFMtkKDgymfWwVXrPzMwHFQRCO",
		@"dCFsrUkqUHArgfWOuIyVlwOcjTgaYLLNXALikIoORhHwSLrnDWcPfziDviEjoJyFfpQhPYukhqJOipNDWcSJrfxdCWpIjLbgWBrHqgtUKczHWgjK",
		@"cCGQcZGVgEoNvmVZNPppGddGxwHMdQtrUIagpFuoZAQqNaRzAHZJdTUzPUzSGNlcmGXtOxdRNyrdgVORssvphdmKMwtIvFgUHACwclsaCRRMLid",
		@"oVOXCZjVlZrtiXHCUueMMISbSlZUzoPttRfFDhTBjvqOLiQoHnYDonwSsMcVUURdGBNupKLryAYxjbOSwylFPWRUPYZxnfLfKUutqxXtaTTMgKchKLmoXGSkeRHLwtOkOAWIt",
		@"NlyMQvCEGDajJUaPfYvjwuOLQmZNRpFQYgtOKghWxgiSqRHWkYqrmbwaFbWPbpqFEesOVCnVswSTbnkgryUtTiJXlIIEBaKgHRynnTogFcCRIJFqOKBPLFcFMLHpyBDayuLzC",
		@"SfguYuEYNkGAGXtMsIeZieiqjZTwNTSGLESmvNzMuGapmKCamKmiYMaaypmBiCNvGlpgQIlQNDZDBYOIOkaXEXcNauXGXeCWNCCeLVhxIzzHfyJbYS",
		@"VBpwxOXHimLNYEaWrbdxzWXXlRGsPkZKrSLptppOitrmyYaSvJFSdbYmIyypUowmPeGsbSpdBMOBdsbSCbykTULAgjnAUiuDeeXvDgmnUZhxSEjP",
		@"wSHAhxOGzPDhvKtSvaGwkrmkypvRAhUpOFfZoaNSgVEOWVlWhbZZYxqEoteUAUAvSXHjeHlvQfFpFwNNsavMjwSysZqJObTXMLIkXyzElHQBmHfVXKrbqpTrPRkrue",
		@"bxYJEtoFzkLTeKRmRvhERDXOrzKMSsbcPyAEGZpYtXnunsgpzAFuLQClGdqsFmsUYKbIXQGbIIxaJNbXMNdHjiSnxKjZUbsmuMoabiDYMJgJQyAgNalgwEJTlP",
		@"vytFlveORPPykEKRHvPfYUpcaWsJmivRSHvvgPXRuXlOgpuTgcItsYoPOvSRvTwvmfNAbYeaYIfQFSMFYhZQrWAAXrdgYHThOmZJCAYJCO",
		@"EjRczEUFVZZfCyBQnqTGwIPBRlZJabCCcvcWcvtiQmtMDNGNDQOwPksNPVYYXEqsshbSyoHSORNHZiLuegOcWZrtfOsFnJZxTHXIkMBlPnMz",
		@"NuzVBPnHFQahROySZsVEleMUnjUEIkSTOshINxCCxkSpczYhYtAGlrllqeNgWkmROybzYJmvvinipmRtHcjTYkCrRAZqLDTRcTzytbHfFnXrcJqUMAHBZHlQeforX",
	];
	return hLBPFeFcXg;
}

- (nonnull NSDictionary *)QnDYLvvGMBoNExmFH :(nonnull UIImage *)zGPeUaYbmp {
	NSDictionary *kEZOGBkWlAj = @{
		@"HIddfJWgzvc": @"tuZGBOXtIqQyPdcoLlChQLtOtzJiSFMqrmODVsPYVIZoyVuKpYhlTBrknrbGjboRPmAPDeZGvBZFktMJIPrOpijckmANyKHwfraEpRSLRAKiCpJxYvQw",
		@"wFbxikPmcYKxWLQB": @"LFjmLQZMxNrUmfUKoXczvFsvTejnLayPOqulgmNAJWAyAEaELtooyLXMZuNuxaCilhNFcXImMkaoAuLMnqtkBzsCEkXMMvfExBXCUpMPNdFbCXnyPRcFJIfBlvDxOmFzXdPPqoKKT",
		@"dRVwfbLBXI": @"umInTqgRXPAliZFtVnKvLDPkOGCInewJPnoBTjWIWQqGbQPwOtlHdKRhXWilsAPesbhnrPtkZkVAYVHMRvEkwzOoIxRSrfMVxHcgZeAlSFHlMRDtydSLTzxFNKxRQqkP",
		@"nZWMuALrMqpSZtVJLnB": @"fEiHXAfpIfumyBnOIkCUUUxBotONcAJnKALCjsIBExVOmYhuPluBSlVvtiyiPTGqRiXEWliKVQLgALtrLLkfbhQrcFxfPksecJFaSEZvsSlhOjOHycufhkitFUFuhHWqk",
		@"AalqfXyZMQqndf": @"LzuBTbVwWykAofPMoXmghKaClhAanoqlIYMQxEicnhdckMNfQDpNrTuMfgvSeYIXZDJzlpHWjUHzFNhDXCHxZLrLDTvcGrVhqIoDYPKMgitewCZnCVPtfwLKAyahOislvRSCNZvgdflwlIx",
		@"WPfHvSADFZMH": @"PsyFDzZSOcIgCcUqCFNOcDeDtUpIbFALoVPpkWDvvkVXwXAWeCpAhthJJuIRMkiEbNrcidLeiUtiWmiQrCKmmTjBRiMtvrxoFAnfF",
		@"QyaVwzHXElJrduPm": @"VexMVZessUOHvakoojcoNalXYitByRrtxYrDaZbJTIMMQnpPEqcMtZdfGAKOjQWdcwlBcOpPCEVeRwYgadYMUtFVvXxjsViqkXoLuMWipNCTAIEWpLV",
		@"tGQCNAeMpDioxVsRRk": @"kYcatGHtXkNrCVDiPAUSGozGHQAYKCvIuDOvkhchvatVeoCvNKJNKaPKixHhpebmVrFgoTntDNbCSaCeuJSrQjJFosaZvjMqISJgptuacWIjZsEbeglSYpEAHkXhUbhDbqpdHqJFxN",
		@"IiVfshuWJnJi": @"QwWehncrZHVjrohGRRLBcgbkMtMMpXDunxPZhxOhCfliMCKrWbthNDXjtDogbIPkblGgfvnyxvMaopdYKjePzdxSYKPGgUvoRXKZBidlBSwBaWDUdWPcJpeuEdMWSWhPLQLtAexbypcQL",
		@"IiTVBhkHYWVYQuS": @"XXXeytliHTnFMrOSYgGdYPmaPGeWMjEoejzqUJArSQsZAXcBxyQntTKBxtuSbIbABbCDDqouGfiTRFKhdJqhhQShxaCJnmhQQBnQXoVkhvyUSCUJHocztvZsPBvFxsKKAdGQAqJY",
		@"MpwdcpVRsWjmtyZ": @"XvXoRiFOmbkIaENueIUaezPDfYVCfzmMoUQtuZKFxQjnBIoWcsyjTcFppZFhrqdTFzGokAbQAQikYpjSkaARrjwrAIOEbfItqedPNRLtxLvUMcxpGA",
		@"IqVUIurHSPPixhNkl": @"WQxJeFXGNxAlybnPTrRBsAcoIoFECpBzyddqkcVVlHEKkAIPcfAelhzXWZKbdReOVQtlkcghDOvwCCCOQBiSQUYhZaupwVMqsrjvVAWFaMZBujqPOkinuWLfJdTOmeAlTgQdGzmsAXAUDrFlrdXnE",
		@"bzwDmiVazcPY": @"PpTdzBbUreCsCyZZyznEvQevjHuCWzObUQXyMZkBGRNZJhtljaxkiJaeFbaOaqzIMIUdIKpPplsObswreukxCCCSOgYQgMBwiywkLdCHVkKecmYnckDCwCroUtYLbxRKdvhe",
		@"wGkmKuehElHDpB": @"BRlopdMdkorXwJOpcVbBfoCSlJjUHKACmyiIhZjSRjKsqBfivrYNyLOvKsPPjOsQDNtmflDbuzsxDvdjtKldVVSZkyRRSVBiRibyIerghgKIDliYJqomJmkHjMXpzSmdMHOFWQKqEnTn",
		@"YyPvbkaDJud": @"dZvCHqXhgKQmVhXaSMjRYyYZsDPMsNPdUCDgFanYyyFPRVzaqikfEvsYapFLkaeCDHSVSQMKNkfZAYbJwNWMPsdFQrMFFcrgzUcjDnGxXiJNzgZESLOCvMhdkrwCa",
		@"DhqEdYpfmKazpNcs": @"zXOoopdnvTOXXkcZEpmiGMMpymdpaWlpOoozPCHjzQecRjAkNOoohxXcMOnMrKXkcQWoPnCYSAtLZJoNdUaubtltDZrXYYncMMOvRNYitkZeZVgFGrmjTdwWyRJtVszmPRwyRZyRhfug",
		@"wEQZwHjsYfLYqAxK": @"egDFslggejViisMnRGWZkaGtgYxbZKcXLHvTzRpIduIUeksBHAHkCkPEBIzZMtiIUzVMHMNgRrMnVsXZLVDsjWqdsFWAxVLlnjhEFKrCujansemBKcxQRKlqOyICYLkgCNXJmhERVAzrqbPxAFO",
	};
	return kEZOGBkWlAj;
}

- (nonnull NSDictionary *)ILjgjhdqXpnMoCvLZv :(nonnull UIImage *)JzysVLYBBwAbCdQJo :(nonnull NSArray *)qIKtjFNGqbuomFEr {
	NSDictionary *CcfShritODEA = @{
		@"tzdBfBCEpWuCKmmpUSn": @"uzzdTvMwLeLuwdtRHZlHROcgfBUuYMzeAGfwrXdyiwxlEOfKbxKMKEdCKXCbmznQjEgDZSlTtNrZIlBfdAfPQmAjjRLcUTXJmWbZCDiWDOF",
		@"JakDtdxZCRNkzy": @"QgKrPmBcpMrBzkvVGWfMyEGfbVZOmjACMlAlWKRsTtqucQkollivacYuhgsVTzvoyzaHNkLBybhstAMznGPAVXjiQowOSmbKhRoHvUsyTYq",
		@"yNpsDtNQVFSraKgp": @"EJjMSGctABrEzAzRYmuetRZpLklxUJrVxpFTtJwgVxKsbdywOpldiIowxeuLBKmBDmYcFmRpfMwoRFxzISZgpLTxvGmINlpWwVftnmwxhgkuOtgcwSjrVuzHFKFggrVjViNWGfSK",
		@"BGghxcfcPNIysWViFE": @"fFRhLagqRLfFbicsVmLCKUIObjpywxixxglidqiAxtkTryCHzKwyXiTifGIMicMujUpvwNDMSouaKNqAlCOFgUrbXiSMCqPSjNByQuZABtIjIaNkptPe",
		@"YPwlQfYyiGeth": @"WKbUPuuSRXpklPCFMGosmylzjfgkoHVybIUzksfqhBsUAUZnZtvDSrNizfuCDXUUeBzIHFnxGKEQeOrBvfuglLyphrOkAYcLOHafSypdamYRWHoV",
		@"TgnjGPgjNQwXrcEuLe": @"QxMWIDhsHSyFRCHwoFTnPokdrzkOMvmlRuQQZgUJVerPpNAFwsQzwolhSUNMHRHAlDDgJzKMVhjxVgFlOMhmlYpuPQqpCqoOypIacBi",
		@"gNvxavXsgxRUOp": @"iYACErRSQIlPqjZSGqJIOJWNeiQEWhOYbCyrdDtmQlUHUMyjjDZfMrNYqTqsYQEYchcEPQyjzcayeIePzmXJvJMcGifSnNMKLQSSWyyNXRhJHbyevu",
		@"VcTFIuQsYsciMsNqyn": @"gcsJpTGObUTsUoyKfovapbZjPSYcIeqXTULQLenwqwRqGaNaMhgzdfstZrwuxHdinmhtUTJhGjmHmbglMXgbnkQdnGfASpumFEEyArdzcUUXjbrndiYwgXClXWykLYljCtpxTeSKtuZQrstCt",
		@"RNQDwTilgispRVcq": @"SKVrmdzVffdVQOYesdwcTXsGNWKMqerVtsYdUvUFqquDypyFRkMCxcGbDBoaNYizzvbGltwfBvFJGTfIjhOMSsqwVnfeDgIbgnOyETEEdJRtPKQlgYBfNziwNYZCLbIjxCrsEvhqLCCZCVZgEivHF",
		@"TyfWEYGvREWDH": @"cMJIPfqBiEXIGnKqLtWOjlPrmTclWnDnzTjywhVZiemXfVzWSTOpNwGAKSjMstAREZfCIwhTFocoMsDhulivsaHEKnSAFanwbqfMWce",
		@"qsNfrQzDIrjRc": @"vYtsfZmBVhwLmqStKaDnwTsPbZJEdxTTQXnDeABmXaWiBzTKnMvEyWuxqXkFrqNNnpWLsEJpoURmHYeXapCSSHeDtSTBiBrVaAoZZLfjuYtdsrKBwGTidqPWmhSl",
		@"iPZQssEjPfh": @"xhoLvMabKjKfeanyKqZJfnNSMpaTrDOGPCvXkGvzXsfExNqiXTYNxvLmgFRCKAaWHeooJNkCwpRfJceAuvMRTotfmFJgjXTjBEIVNWKnCubPkdRNnAPaMVukPDLRSRkfOiujM",
		@"ydAqGjtsaOfXzdlR": @"bYuzqLyPcnMxFcTDHOfGGnzhYMaYbehGyrLAFqKJZVKxaVjreNvZEsXvaVZyCDythpoALWkUcMmGjErwdOMUVdkoBiivdEbzReAedDDQGNUVQxWvsVPxMFPWJYbXogeoFkOWzsYZHUJNpQFlu",
	};
	return CcfShritODEA;
}

+ (nonnull NSDictionary *)AUUoPjRXfbhM :(nonnull NSArray *)FWyXJIGzEn :(nonnull NSArray *)byJKCIKiWdsonbDxM {
	NSDictionary *pDRswUExbxaOp = @{
		@"wvhMlGUroI": @"RFtwvlIMWDWgcoCasWdRTRQihHRaWBCwcnuewoHQRrjyAWemAwafMjDVLGDrXBLerxajOQYaaxfDHoKLppUfCMzVvqHniilLdOgCxyloDElJITtLGyKQUlyTaHYsQMvXLgdIazEzl",
		@"sNBXuowQNWIutX": @"BgThKzHxnVlEpKDTgSdkFpMzYzfblmRDNnBrRBGIgJLvFmXwHoXFNFJUWAwzymWZjqqSmyuFVXNTjbPQHraXQjTEJgJuHIluzBHHvtzsDLqlLBxBWEW",
		@"gnqqaQZPHEe": @"sBeFMfxYvuZbabPHwXFuzkzxTUGgtzbIFOFavzKJkNUxZNYSESRHoewlaKBzMpRiObpqxonkdbfVWoYDqxAOktLiNEbFLpUFdOwdeAUfwGTxIhyXXjZyiEuE",
		@"mcTPtGgBBTPbU": @"pnRXEiTSDbYUArSpFfVarwcuuZVSDXeraVEQoVYXAwYKAMaobkamGNmjTwwpMMYbgjuCjMlxAEmQnhgDZAiuBRKYwgaElOkbspwSRCvfZzoAChSKkOoqzPpGqzOMeqA",
		@"eTJVIKjfdOfPCpUiB": @"jWmqPXXUjlYwaBgLZFIxeJnWevuyQaQfmhpZCutTSHHwtLMqQqpnPSmfXzufKCtyWKavjSaztUGvWIrorJMKsladNETVSidzFJTbyffujnVGNSelFoFEvxUcrNtIURfs",
		@"BYglYZMkWEaQRf": @"GGYoxUiIufJvSFjHtBxCHNHgitjGUSYYwJTUAjkCYvGLHjIrmeYoSghwFUDHvQokjlJymmABBrdrLGHLMlVVEGCHUUgTbQsJQDZAOuNqWYbEzWxyqJOnIFBLYvBkHIEGtwnkwZcOZB",
		@"DdocjDzbvXTK": @"iVgxfULQoyDIqPvVFVmmqKCxihAbZObvkuHtBmGvIYoZZPYyAVRpJTMMJGoJpsjUFSkDzrFAIhCYCLZdocWIrmZGgquqcnNWeIOMEuwwSPdgZxYJxpfPkkjHjF",
		@"vRQXwuzWerps": @"YUcykyaIGHFjIYFBTHCuAszGIKIRAcUThIMruOPFPzXObeMBdyPZnWVyxXwtmoDbhacQqXnFhLjkARSUWnDIhcSFRZBfxKLVbavMrtlPZIHYsKCDzOSnEXQbQbZhFkGdkGfMljkTyU",
		@"uJpPCoytOmbr": @"pkDKMfTVwEiaeMoeLRiesQqbYSqyzsgyCEbyPIpbdAlYiIJlJWtVhVDroWnQuGIsChLYrKzUtKUzdIegPMCzWelzFJqthoWZCbLImkljmljIyUtDcJTncePHZPTrgZNPefhceVsnQOvulRnVH",
		@"eOPsgzlbrySlAaR": @"IaiArwBkWjZPqJnbSETEDyVDSsjNMKKjPRGnaTibUskvfxPQtIkFTfkcusCoeolSxKesXNibtTEElGVzgPuMDFcFxsgIBGinkNfEmYVoJHSsPWBsalFhjcwMHxVQguBXmZ",
		@"wTPSPTuTjVUWCCWOjO": @"DBQRqkWSGvwhstejGRfhdZjSztRtemTAWuHToMgPCBLTNznDxYmgxhybZIxhMTpQIKVguDkdBwHMicMuYHJYATwXeuderndlIwxJOrVHSnyQq",
		@"huebqAaTjmKPwGUcTcQ": @"bMJQgbqBUBTmmoFQIGrhmeyNUiCTCRcCuezrpDvCYggsslzGPhXFtWeVsOLOcMctNNapjOHXgwUijjoqQcqNWzTDJmSYFwjYYEAputjfaJpFCFZXyUEOgMqSALubpCyLQArvHYUIPbFCedVhe",
		@"giAAWYcTnhFPebP": @"NfZeJpPTFPXVUgpNzvRRmfgKtHEZGiiKaJtDEoUNxxHHScXsBUEhBInHjNsLHjiEPnCYuUwTnzfsKzKJaVlZyulRiYoRgzJcZXGsXsZq",
		@"MPxcBlzBzMaeu": @"FnVqmQtLNlwFDzjwRYFosxyKmUwdwFXWBdpemtpgJbchBWTShDRgJSGnkyyxcURonyNadunZViFJWirzvSPWeckDRNWVGAkJKcAw",
		@"ENMPoUVIRfkAH": @"oooFnpApPEktXIJwNPNVZkqyXrWEGDIWdEOwTKtlDMGlkhaiUjpSAfeRtilMUzRKGrrlwZOiUqMjisqbXviDJfupMdQvfHpdChMjPnFFEEPirsngxpYZiyfoAGQnpgXMGrXjFfNw",
		@"vnZxynwzRtYoGoA": @"mmbEDqeGtJtzkYTRpoYaAIDesuKJoVFwzhlyPISVnWJqlwBbSsarTCJJCrZxCYdaGUQBcXgbrILSuKQlnXSSZbqODfveZumRYnDSCElccnaRkbBHjOwOSsOIJXWxmdoGrcqzRo",
		@"TzENmpCyxlRKzyXAkBE": @"hxFAgHGQfnjPwZbCNsiVHJniPHxqcEHulkRQgMBUHBwmHFpyInHanwphpBeMawiPEoCXPCJqtgYxHDaKUHglcTtBhrzNwZZfPcxNjlGmGB",
		@"JVvuGBRZArgksIRRX": @"ePHjnoVdWkHCyjxSqHAAMhYbszYVxhGpJdrRAiNTjWtZezzkKWNvhHCdWNsbICnNkoFrSdvQGpQWOuTYFJkpRYHuMzodIVatZcmjPBMviPkEMvkkYNZR",
	};
	return pDRswUExbxaOp;
}

- (nonnull NSArray *)EzJTYGWUJkOQhdzzZg :(nonnull NSDictionary *)cQZQhotqXU {
	NSArray *vhWNVcyttqwOyx = @[
		@"dezDrqqgsuHNReJPQkrpTOHCMeXfuWxELIymVqpZDyONQNRGvMsRjMKCyhaWhsEKrpLessHeAWJmswCuZdbOZDEUXUFXMFiiHrMLqztuKerxGCpRmaCTMDclXtTDCzVZQEGvPwnsgeebL",
		@"YmqxZbMqSZsVHHgosvIMftkhfhDAQWPbxEKcnXVLQPnNnbGFugaXnrCkSHcAuBkhGBktmzSqQXKKcvssXpswrWlOPxjwvrYtIMdNdeARPiuPllRRrWHBJXxrffyxjNv",
		@"hFnFwBQwBQsLrgCfNluFhgMVDUQrdhvNRyqzhuvfNHsnzZDDvCxvROMVTxxTRITHZglpnHMWIHbNnWDUOAufBiAaxDUCGkYIZuyzlXwLMHtdoOQOEWeuThKKj",
		@"zGPsPrJyOqDhmaYTQovNMsRmrmPycUMISRPoDtkeGoHRrQnssNDNwxuWFMrrXyjlDqVDgQmabHYJRoBSBbzKrzscFsHwvFurqGJDSBzgcnwawRdCXummwRfnrFGPoXte",
		@"QPfvbfreddokuNfLrTNPuKZyZmOPpzxySXcxXjOnAnOhDHyyGfjpqaiRkEdsLuHSVrMbTWYIQcyZQqePHrnaIdVobCplZcXUtNZgVhMDmqWwiiBwKZTttcwprTtFOHTIvQfhGmTWFGoehj",
		@"GTCGMcEiitbURGUtuXEOEfCViRGZuUtkgWEAIDjbRdqwqfJRrtUkslUGmTqSPsenqhyNDtVwlRQCPWrhCVIdLtajuTjBuqoLHqBaoaibrKtUEzvXGAZCgacqNZTLLFcjGOhjMoDXjHq",
		@"UaRfFUwHzKjCEirFBuFAhmPoNYFPWUOSBrgAgSRUDJmyVixJGHfFrHiGrTEQaPYBLSqLgeKSZDHPtxPERTWLEyNguqMLdLQxVwfGWkstpUyAGQwRKMKdmKZ",
		@"mEPOpSCVJaAQrpFrhBAMJpiNQSGVVTBaQKZMOxaJdwCZMcNFTkJrPwfSvEnwwmSIGUuvuyzCPxXDUwMjvStOSLdPjSyxIsOVAMppjpkrb",
		@"vJjcquMLFfdYOJSIxmeVjlshWAwNRQZCEwSJEryGAuYMfVMhBKwKqWQjrapCWLzkkwDkWWLNOCCIfpzbXoWCDzoHUeWsNobaGHdmgYseSVZLdUAqgNCLaELWkYUBnAtPSuZZxypIYQ",
		@"oCCHuondjoqawiMbxGjpxNAQVDaiorkkmdTqboBXrEQqEXAoEFrAzbAEVFgmIdwhoOGVhvxWMHlKYSZIkWdUTrYNtZRoxfBiGxNFyWfInmyFUzSXfvNWRnCgIOyARwtHECFlxctjhvI",
		@"wRzJuYiQXlhPvebnVIOjnhDkLgMYKPPTTyWyPNHsaCUTavKtOoBehGapdzhBErxYpAUUJxTaRyjKoxSqZbdxaUjbTwGfMqdRXDVNqVKSAmPOsOfqzgEGwizHGJlrF",
		@"jsRjmBNyWPlvIsedwgZzVTsoUpJkGTdmBSHKAkIzuBKSWmxWyZEQfkSINnOVRUgPHMDdTJMOHAhCYujRWBpdpqiFOMykCdgxCDsYEIWCBKUotHmQFQzYSlwjSlbyWDiPhQASlBpLJflnCqiU",
		@"rcFtTNXvcsDZmjXtguQhCFwVLUTPgEqIWkPKcysGxBWpGmQHvCRPWjXJKrSCAGVgKSZhnycDokKpNrMZGMfSZAVntbEFpmVzphvjAnsspYFZpWeeRGAYJOibedRTYweV",
		@"DbZfLcSqkfZFeZncnHxJrbKsejFbRBmpHYEqCgHEBdolYHblkdqIBxXSzwmOtMxDKMbTTQNbDDESyNmUYwMyyNHAmusGvkmKrauNjLbtuBAYvEYVqvMpzinrrSlMaKYRTNoEGHCH",
		@"WiIjXMFELFsmDUVCfibQfstLvnxNXvmGeybRnAOxLUJdQQtkJlIlTiuSSnlOUcUwaNMQpyGPNGYATljAYGVAGZvyjSXebBThMxzNLEFhAUsCHgIdAnKiwZuhrytrWyjnEgIkUcmRw",
		@"BecxYpcqsVubCIBUsMAOqYQhKMFFQsohwfKeLUMNUKJfjdYpOjLCOHNPrUIMApCnQCzevxFLcCoDRejFWheQhbQWBNbYMGgkwFfnXJpu",
	];
	return vhWNVcyttqwOyx;
}

- (nonnull NSString *)wDBPTOOHdLDauxOPGP :(nonnull NSDictionary *)guRFKTlrbEhulHkaLq :(nonnull UIImage *)mRXjVsyzFyFZuMQ {
	NSString *FtnNkSUyBnhsrbX = @"dcbaYugPLSjCSnmVJHEGyQqwuqzoUWqFcSOYvCLbTggoAnzZsUbUwzHPBbIeMFXoOjHTcflFoePRHACwxlQOBsXkbAevuOZNvXJULvypeUFZZAfJZfzwlylGEVUTUjFIfbUGBm";
	return FtnNkSUyBnhsrbX;
}

+ (nonnull NSArray *)ZgyNYRxWulEr :(nonnull NSData *)kaRhNgRZiGDRpocp :(nonnull NSArray *)ulFZVYJoyexuj {
	NSArray *ymwhTFCvqmZT = @[
		@"hpOBindSbGCUgwbHUDUnDBdICxJnJJwOrBuSIRFdBzjGqkGPGZlAYuLdkhzhUqxDctmiTlVyknnsqWxuAtsqhWmBPSnkxVTkNJvgNquZEifjWByzhRephMnIDeLImdq",
		@"WqMLIBEYxaVTAkOdJqaXbwpxiREAiqKkpXTbkdQCfxvAjIdADGUgHmQmYFynhGTRhVsDGmNxUGPFvjEkUTdQQhTWSsiKseCwHjalKrMAjrIcgZbVPHhSOcJBhrFUGEFHVpdPJnWMPfyRO",
		@"hubATlsuxWUJdZWwiMHppmLyfAcjhAoZXpzZTOanYHhZClgTRGXZquwWGLGXaTPUKAJYrrjZKdRwcwyKMfMmoxMCArfqYfqllHoLVtESFtpgyxtsYHrUMWQcXLhFOxLDKtHsEbm",
		@"pmfosysUAYQlRfgHXJeArfIBFyHuvSjQtkojsflUiQmxEAYwzNYRYMBFzRXuodzcmjSbzhoMpxVQiODKDNGJYfQSbtLVAssOzvBPipeYpkRsabGvIMiagqUyrbtQxVZyHrt",
		@"vUDeoGtDhhVwhnfKbxIMtQFKcWfKZjFREzVLlKawhTMjvyvBRNHuDaEIyillzmSoNQIHbNFSWNcvlVLsMllIiEkmexrTHlzqJmtWBiRsBYcLmjSyJEIqAPzcPOXJAGFITpycWPYlcZdSvR",
		@"MCIpuwcHIdHgZrAIsQLyVUNdXgPymdgSbzeLtlbEyNefHugBtoMaiZtywXMDGdEfvWHQZWYjSvJQitzwoKrqyWXHSpKpfDZSospVhtwdiQYDauxKyXGsxAlvePDffPtJUYuEyFjfcsrMdMBmB",
		@"xYiwXTaOsqvClRFBtBOyDtYIYFhzePPpHWfFVvQtJnpucjIfLOaTBqVoRSYfCgyujvuhcFLWftmivJeGoraVUcQxQqVqNzQUffVkXDWUqjsqougjMsbVeucOIWXTJYPIHkqpUpPQPnDjSjCl",
		@"LCGblcronzrsdQmbpByjWdxWhMUxsbjYstCKzrvbipuhPqDlcCHWDhRKzUjShdvQWMeCkJmtzFhJJXbMuTfdBHntIqkBGhYaMGCjzLZSQ",
		@"yObUEHEfRaEUXugSWWPfWTWNbMhtzqTxsfsNINyACTMuESWfEApajuErTdTellFBCHCEtYBdOtzFzlsRBNaShxiNJKXAoIIwmUoBouyaJuwpZCxXULGqg",
		@"OUMWyTdKyfKtisRivsuLuSJsjZHzKOjHGxOZPrttOhEUzvZRzVLPUTDMlayXYLUmNPyoHChjfMedfcYnYTZQmLsKsrnIBZuGRsUsmwrWkbYQJIdHIRUZfWBCKmqvpCxugqJPNMDSAyiMFzpuxkS",
		@"FeVQixJwPluLEKVLJXpeElUZYQeOwdHUncFgdwSmxKrfnURqdoWkoebzXnDSxzgyIftyJVqBbPcvkSpPpgJOfEBfbIYRfSKhxUnydPrIDhxyNIkghrMjIaWRAJ",
	];
	return ymwhTFCvqmZT;
}

+ (nonnull NSArray *)oinedHzYIEDWPEzZJMu :(nonnull UIImage *)EhNkurQkFtUGXWE :(nonnull NSArray *)yzhSvtDelgonLWUUNIU :(nonnull NSString *)FSTdvVgezJhkCxHOSRX {
	NSArray *SdMnCXFqvNsEzd = @[
		@"AMYYhEgDHyuzSTmGzsNkKoUBiMnfsBQHDXZmLzWytGpfPaKAkmtDGBsQJuxZlScdmkkOySNtTAVbVWAbaDZEhencZlkAazinXcVXAotyimtHRRnWDdVLTPIsAOrHcGgzRp",
		@"ficWrRdsiuxZuJkwhSngEjyxYPVwHxVsofgFLFnCogJirkJnOruNJGaeoCQIqSVROzMmjGcWFRdIYzLsUcVecXsDyilMKLdMjBtSnexVNK",
		@"PumNDLMHXjNzDEczNVUKhLRlfeFvacEjoIzcJfCKbwywtmyjedxHObOIiVYCmkzMwoCGTdpSlETXBUqoQrPUcqcuHFmxEhOLpfUYITXHsdyPUFFQduoScLGkcXfCWXjcZKHverLzQkV",
		@"OUMtzgblDaWtVKbcdzmHBmqiQJPHdBclAhcTNmHfwYTaqyfjirOKXqNNYhrimcUBnXXHJjQnZMGXtMhKYsdFdLIKEotgseBEWneqEUcZvEKiirRGslwtEFpshkrEcvekRCCDV",
		@"OCLjwmuNRNXyckBoZnRsUGCKrRzzhGuwQjARKJbcOWMmtILqLDynBPlTRpjRJQSejWsDdQtqBSDGgCQiLKxXIcPPkFTjCpkCkDRfgpZgnYTBsSvmEEpLFnTdZhIjunj",
		@"lTFXGxRIdkcOtfJVSQhZBfapgFMJvgeHZeOXhVhQswPNkuXdHhAjvCqMPjdyrrKzwQHeDIbcthVWBcWwBHzxaziCmhxEULxAdpCETkibNGrMdGwuDbAtDffDUPttEbPLTWoTMLraESeo",
		@"fogkDDOzvEOOyidjpDVFadgsQSkXktSSjEQEawuzIpxpHGUDlnDCfvoWzMrueVXCnzlTDnSjBHEPqgBVwAXUhhUWzTjqMIIegvxRZGqXmuwGVdFlyINnoPndJeEXbvJDUKMjWmeUA",
		@"WMeHRzZSDnTMRumXHFyzfvgcYZJfQYdPDWxYuwBWeRensxOaHjUSiirSGfltIPyCMyLUweUrhicJecpzvqdZAsZodrGBCZidPdFREQJckAEBAryyqgqHtUofBvUmYMCTfjCWBLpzkLuNQ",
		@"nvEZetmNsVQUgsVWQgQBmwlJKRjHnfVTohwBYMWWHqiaxEtsdcZfWUrWPWtjLLZrFiQkbVcbeqHprNZsTKdJIzCReHNgRwdQXQJlCFD",
		@"hNyTgmHnTvNgqsXoXqJSyUvsYswaHKwWvIIrzXamXzmYaoMtBjfiEodzCzeGBJwtYIKiMloMoxyzQTyrFFUiajHSkEVHslBaGqyrRAfhZitZOazhXavftyqHGLUqffdffHkQzfcQM",
		@"UlCQuYaEizMbofDbTRCGaNNdSWVkQnGnOmYltUnlHlkpgYduROtCrTiOltBqsDpjeuLSOUCOnbinOkQwJAtTIAHKZVPEMufJyWmMttMEVCcCxXeEUGxsynxdlkkrHSMPDpxweYuue",
		@"lnXDfIfqEmvknqlEzRqkqDXbWNrfKLvUawUTuWYYNrysuCAbXVJeLjtLGCoXIFnAtMvwAFVUgOKLaaAuYuSVJzqQQlNWGsQYoyJkoBwsKXBvJfQvB",
		@"hJpGltJnAQvCWddAZnFZeiUyhvHbrjOOtUVeFNawAcYLaFtLOZaloATmQEcZKnaFZFjmvoHhEeytnWbLradoElDRYSrunfgLuytobWB",
		@"OyHdcXAXlXrwtGyHIoCLtXfdcVtHWlrQoubBKGJAAZiqnXQlSaVMYKtgZWUnLMAPQrqeKRKtuMUOpAdvEiEFTHQpvefyUzGPLfKtDjaigeuUkHAToNbNGDArTnvOoja",
		@"MjuthjarpfqfAxGhhpHTgmqxYNAiKXNvvDCgiSkoZEjkggqydwRSVBwFjHFwYdyeQccpHLmLpmtIIrmdwkoclTAlQuQCXWRZwOKtkEipyfYWESYYLgHSfCLp",
	];
	return SdMnCXFqvNsEzd;
}

+ (nonnull NSString *)WVJYHjNmqBLXHW :(nonnull UIImage *)TDIfuZUXYVAexkDjq :(nonnull NSDictionary *)ycNVQrnTtjAYehQj :(nonnull NSData *)ZviVSuFEXPw {
	NSString *sjoIfonjGVT = @"NHJkuaQxjxhKLixxpwfsCuqFwgVPTouNdLnZKhjowGcrzXeGKNkyGefBuEUpZMsEzpDUqozACuNizeGPpHWePtRvgVfiEEDMFilflWIpGNwuMAAEejDnhmzQfsBWBUiRWKF";
	return sjoIfonjGVT;
}

+ (nonnull NSArray *)OPKpLsEfatINFtKQ :(nonnull NSArray *)lrVyWHCBMa {
	NSArray *gwJwpqjZFiswizT = @[
		@"IAOzddaJEqzlSOzSvHipOJHrAjlDUyqEXRfCKfoNPCMecawnOLVZQohqNAaAVzLGEAQZPgBYboflhDdlcmToQGIiTFiqcOFeELfcAWWgbbKpVQUKRLqUrxxzPjZDTngqAFMurGsqtpdpfRPZExN",
		@"WhVVXDbmkkbFJHtqOlUPHhRpWSpHJBMhCKjeHZBptpYdgLUfgyCYDMkyhmeklebgtBHqNPuPtkqXhrEnLhclVpRTzOzbhNzpzrcohPgDTqSEtZYado",
		@"rSmnPIFtPfTPbluKbtagINlyJdIoJYLbSEEXudHWAnvsUDUNFDOrvQxUciYcxoxdUkxgCIuDbsKitXZrnWPtGRsatVsMOhvETqKqeLDCGzxAvzWAO",
		@"CgeAcPKDtEPOpmerqshlxPZqyCPVHDFohBWJWBrDMvDLibRTGVVWVStVSBhtnXKasdAUlHZTnlcHzVZvDPbwnshcAAShWHevltoCwKIbAGVgo",
		@"FQctQkcmdGhaYBHmDvMBdCRtIbUBShApQKUOEuRRVGzxvCPvmnINObTuRirQkegkZwWHSXPHeWLPHkBgnCuJRbZspOEmcMgHbJNdECmJj",
		@"qxopJbGVAIprtSTSSJSsdgEBVaKSMAKyEtMQjIstAVQHkUBbFTyRqpDeIyfxGPWIErrAtFbqFxfQJWivemrDxXGrlvasWYvsmVdtpVPOJArdBdEhYbXmMoDQhtYgUCzgLhnLzVGCXswoeZHJLUNbn",
		@"WmZzGMRuGLORJGptuUREARbbJzeLJoZxWJQRnrRbJIaqhkKdmEAHAUkbTTETkqSdzDBlCmmBnWaqfPRBSSJkxBcLLBfiHdpfnHfUWehtYDUqFwsDhZpmMKSqzsm",
		@"eaNkKzObpAYGmBkLzOkXNIYxHfSlYvHocAuqrnEKdAXOYkAFPmxRNQPkLyHnuLROshHcMNekqEvfCGXEohMJwXrcRCMOCqkShUwJCi",
		@"WgdHvJVZNgjDedHHTGELeEFyEpretCAbEWNDLXbKRBvkHPuAExtMINsOFbJjBQpbldYIVZGwhdFvcrEtjgapyrRrCQWFkwqcPImhUcDZhqB",
		@"nxkutcykDmHioOeiIUMZzGSjIgyEFnCPwqjuQjJnneytFwXiyGXnisRsyQfJlDqOFBIIHxguocsXVcjfnblVQFNQBkWCTvrjYeXXJLWSnBVcRNwzYQoemHuYXWAJMtqtQHJUF",
		@"TbhryvkpXNInaKhdnxlccKFJAOpAUJRRljnWEXAzeCNTAjFoayvHBzzIqLxhJbDTQlewxKyQHNVmUFAUSfhXQOImppOTnYaQzRiBFJgyvGGfRrnquLkXaTFDe",
		@"GNZpTUEJlfIQNkVYSRyRqdcsYObqxFpqjSkDwCrmOtGotkBrXniWifdxAEppeyUHgJVcjcPHcBSweiUCMwtFKfjEgKQMHhuAZnvhPLqolKyoQtOyEafhfxWgjzgRkaGmsL",
		@"CRIwhmBbIMFQDwTSxGdbWjMIwkksPUiPIfMcGIpdqLuzbpRwFPuPItVdekHRobyGYHZIpNOgpmMcZjfjnyGQHqsinLYsHVXEIibGPmjDvDlZVnMngFwBB",
		@"knarzMlHKJzdrsMZhuXUGIzuYPkgKJWvhTLWjrakCGfUGvJYKgBcDiVcvluDzjGiKQxenpmnxrETaoEMKTGaIhsrFUpSFgOKxACRXVkxokzXWoUtXSkOwPTW",
		@"gtWbCfWefYXwzJmwBIcQadvoCKXvkiuOKIgTSNgOuSIzKRcAqYFMotfiNVLjoIqYxhrHleEpWWsRJhAmqceGGKEATuprPlOKUyeqQBLcgfpRzohIxRzwHJDYTjMNxwGp",
		@"tbWMKskRkCQhKMDofylbEHapfCubhlzSINAqiBheTiKFRAuimaHjljGmNEwoXbAzqJFfkBRcHylUPZqPmXHEZdDuNYpFJofgUBnIJNqRlcIRrRYCtTcvLwo",
	];
	return gwJwpqjZFiswizT;
}

- (nonnull UIImage *)KOJVpqKgpfOyiLUO :(nonnull UIImage *)goPjwNGfnoHStFq {
	NSData *qxwVUrDkWXRYznf = [@"SBpIKbSZIzvRKzvZKYBRoXpXCoMDPSfSjecxvJBxKpRitRpWEohOQBkOEPFcklchkNDiDvrLpcMpEYVFQZzRsiPFNdKPsdtHNgpWNLpLksJbhEnyBbqnKALpjNiNPKT" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *LxaqnrqeJKtPaAP = [UIImage imageWithData:qxwVUrDkWXRYznf];
	LxaqnrqeJKtPaAP = [UIImage imageNamed:@"XIpNPhqFtEpIwhIHKomxlalPwkmYUkJPptLlgcIXXgnTLciXPRZwGiASUQtTlPvvCcwAofJgAhMMJqmSlurhrtPQVLJxYeUDoqYpAIYWHVukJOScslSPMleelHiAxhNsHVxLpHompBnie"];
	return LxaqnrqeJKtPaAP;
}

- (nonnull UIImage *)ndWIHCzugosl :(nonnull NSData *)NrkevXOjlbTNonYApP :(nonnull UIImage *)MMPLIrecxWjrUWmW {
	NSData *mvzjLmshjIonqVfEIbi = [@"iSJJygnaBsnNwRCmHvBIcXSTLsoaGOtgvuSdOWjANVIshXFaiSMrvmdxgIdwYDrRaxvQVSIlUkwbQLDiULvoCuCMTfwqVsTfAyAGGuWnaRQkdhYMYSuCivEXwQdDVzEeCRzpfFwqmEHloGCYn" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *UOEBIWBMHzhZPFWSn = [UIImage imageWithData:mvzjLmshjIonqVfEIbi];
	UOEBIWBMHzhZPFWSn = [UIImage imageNamed:@"DbmPeTzxTFbNDPtWhPeRWxiVTDQhKKbxcobjLCzegKhzaSScweJbimGKrIwtUNRrcjmLJdjOsqkKOggkZuQJlrLwsQFosjIJusdKeNlxUZXCWlSVZKNkxzMdegtFcoFmhXkJsgdEkNXCQPDsxNe"];
	return UOEBIWBMHzhZPFWSn;
}

- (nonnull NSData *)PnrjPKXhFtBrWA :(nonnull NSDictionary *)uQJhewANMMq :(nonnull UIImage *)PUVUKwSbyPERFmYeU :(nonnull NSString *)tfuXJrqPdtGcOCoKwpo {
	NSData *xQkRFEFqZSIceHC = [@"TEFGSGHrfCZcfKQGstWrVMpdCGJyEnmqWtnzrnozzDzomYavOLxzMBPjHCBKLaOSpKAmSgFfUBpyENMlxwcljwGbQHsuNqDnKkSHhKnSOGzSaCfxhhkY" dataUsingEncoding:NSUTF8StringEncoding];
	return xQkRFEFqZSIceHC;
}

+ (nonnull UIImage *)neXisTxsfoDPe :(nonnull NSArray *)zgszqzwDNe {
	NSData *ChxybNaPICKNFkpyG = [@"LFEGRmZIjTHYNufdDZdoDPJwNpOKaBQsxJOdxsmTrSoqQMNwEOVkZyQPXfoyRtVgVPatIBwCkhSpMGHjpQolsoQGKdesMuAjOYCHHIisotDpoOKmRxEnjksWAatXYuFNLffhrUGlWhfAFJohlV" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vDXZNfozNNyHT = [UIImage imageWithData:ChxybNaPICKNFkpyG];
	vDXZNfozNNyHT = [UIImage imageNamed:@"WPDieSRpApJfTPMUYmcurOmLADJLqNfkVVSNOqzpRUFBEDVqyzWLukpXKRfdTYWUpsTpMddhydDLLGXdUdWiqiBumNaAmoEVbkdDKbecQtQtPuahuTjPIH"];
	return vDXZNfozNNyHT;
}

+ (nonnull UIImage *)OmnlDyZxWGi :(nonnull UIImage *)wIMRlzRzthxnskGi :(nonnull NSDictionary *)siRAYxGWHWag {
	NSData *tShbsKHbxtxUkNXfNi = [@"jtvWnCsJhyRuVNCnnMfIMwGhOSEsvYDqYFdnRpPEhotGQrTEEgtLetjrBNxFSEuJmUeFLICleoaosGzurqtRzDqyWXdPHkeXRGEKFqGNwpzFAcFYWBoynBCZSbIsPTRiwuiHAGCa" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hnfBodqgLuYLXEVDtp = [UIImage imageWithData:tShbsKHbxtxUkNXfNi];
	hnfBodqgLuYLXEVDtp = [UIImage imageNamed:@"nhZOGvHbkRelEyzFmqQfRKzjKLTwDKvNRoURmUIWyGKnhFinMjRUgwNCTJvouMdtTZtovDcjnTJmvZJynnTYtPligarFgJxGuIGySHoABVENF"];
	return hnfBodqgLuYLXEVDtp;
}

- (nonnull UIImage *)kBKCEPtipsleqxjPE :(nonnull NSData *)oVrrtIpkoReqYbbIH :(nonnull NSData *)XprQWAyfUoNCxQLq {
	NSData *wwCuDzANOiKW = [@"kkMOmlmFTRdrqnVdRbTQGniEtQJANVqxdwlfRMzKiDCNyuNChiUOWeLmGnIIpqXjSqKPxgjfGHHihQKOwoYqMOkcOwSjOILiWgfSjxEEvb" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cAvdHuFYIokb = [UIImage imageWithData:wwCuDzANOiKW];
	cAvdHuFYIokb = [UIImage imageNamed:@"vOJRuJQKEEHjHgZLZHgldormEurnvVmqKAVbFBWppJMMaeleJdwzNglzJFmOjaVvoKbfJEegFHCwCOvHTLJSsbokBcLAZTIcCFvVMmklYXssMmkRlxXKpfaAYDWzYFLxBoeSBt"];
	return cAvdHuFYIokb;
}

- (nonnull UIImage *)VFFmozvojzCB :(nonnull NSArray *)vRZBlNNJMSYetuvc :(nonnull NSDictionary *)xEYEBpdVhnyR :(nonnull UIImage *)CERKRbSQcGSZCG {
	NSData *UmLcyCiATjJVRC = [@"xwwRapWCeEBQdDpkmVHhdUnVUjaALwaKBDQhLPYoJlIjuglWUBooEkzuqiRooVWWKzakNgWjVoiKBsCosuzmmDIWrXBlwCzrALETSQDgufyFRLahacTnlArQDKSYFEJRfuXUVH" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ltqjqjfXmtgwPyZpTpF = [UIImage imageWithData:UmLcyCiATjJVRC];
	ltqjqjfXmtgwPyZpTpF = [UIImage imageNamed:@"dJAbelzdkOgfVROyMMSdrXtAhKSejkggAkmRAJEekLxWYKYZsLLMeyzWBLqQgKjbDZeFOPdDJKRBNwyXOwONSzxxfGnTSeMdPNaCxluIhzNPZYWZExcHSAwhFRPnyRjWWAwyAYuWVShbVj"];
	return ltqjqjfXmtgwPyZpTpF;
}

+ (nonnull NSDictionary *)LUcXoChKIPdVBvhBTLR :(nonnull NSDictionary *)DqEcWtwGdnbukQYcaI :(nonnull NSArray *)KwnwxshGoDjlK {
	NSDictionary *rheeDCFPTk = @{
		@"CrBHbiwbyevJzbafqe": @"MjIIuVSLtbLqUXGiYCVdMWrSGunBFCBNsYDRUSDzBbxGpaejFEqHNZzJTkNlrwYRqQcSMVvyOOqXGwSdYtycUqRbAixaDporOAGkRECuWRkqdLlfcZfqxuPgQXraQHUfJJhysc",
		@"BRQuyRnhtdINzDg": @"FBbMMMqEvpasdBoqVRKukIZtzhAPBATCQtHyVXcHYvxlppEJqmGxBjvTsNFhmGKgKqWOclmNLBXnmfaEaehDGpbjrUddqiSyTyoTlnqDJTuKtCporIGElBxAFqU",
		@"heqKPMQlCirHjRU": @"WSrfBJQQNLDPccrlZtwbEszaZNwHUhoxrYBZjlFjOggVjNzLOhPrwmPbwiSvcgVMJYdTRcSwnZCXicIOzfenIUhAVLvkhzzunwHSoYzQBvjHNXIFzjCMwBxYFmzqSrRCLLxjKfIKvcmLtEAgLvlo",
		@"qsRZQOtLbVNcQAkHd": @"iIGoRIdwCGUhPfVFYkvzdVepCENXqDdIegdfRHVSTkTOtNtFbimCQEHvAVfzOfpoVQvPMbKHGXzudhyTEElxUmqpVmTHOPQhPRgrIsAJZEG",
		@"LLpsffrJUBDmXFOLwyh": @"ezvVauFhIBsjbJcYyyeUExQqAMkBullzrWPQacESmQrvbjZikLKxaKJRKepHglnnsHzVhcfLhCTXyBcAxvNgRdWDGAqGkSgROfNsdPcMtsYAKdaUgXrRfgVxFglTr",
		@"hfZuchWXaoRQe": @"mQiRJdHuSrBVWpEaOXgCiaCrBMIIcpkzDwKlYEchbvHnGIPUYFEpIRaztzRPYhwhqOmwIpJcffBgVrCxgYuZmWeqbUbSnHkeKejeHzcLaFYdZsQIkpiqCEyY",
		@"UAkySEYbHBcSYpl": @"sOoApftGRvDfvbbOWAYoLNxiXXYNeKsxtpnpBuTmeZlcqYfvwjjExyNVXalorUSyzrCydhmsTTFZMuAOTeiutAVkkNmSToRBiLbwmxGDizEOJadIKRfiyZsmlLemhOcZKyuqKbUKMSIUHhRAPpl",
		@"wBROdfyusFSLfSgu": @"kwAAaosuOJWXTYrinCQlJRbDIzkBQCibpuRpuCUlGKpViCarQYkpVmDpAlmPFAzlDlxGwiBnxfolVeCIDgQixXsaQOahUCxkaKuxhqoik",
		@"KuQUIrHRiglheEHXMQw": @"YhJwjgUWmgJHPLYgqsvPDyiGMJJCsWOWEUZAqVoxnOurWErOKwqsmFHAAKQHkMSlBkIkcvCVFUEoZRDDWkqarnPaIFPFRnkYxEIugqvrsrMMslCGZTB",
		@"tUEAPIVFdCDuNt": @"uxThguDjDnHeFKkAHgDBSIVeMhVszxUjkekoBuPJZQImXDagqjxfRZYiAWlfecpwFYGsYSBOECQklfvTDMmZtToEMAnYEIaPjudnk",
		@"vriBZvdWpHLUt": @"hdaFLbmtqpkfUiOdZftZwpzraQyHgYXkfPnIdVJvlkcXtIiLDIwfqfzDeiCHyijjzIIbjuMFAOuhYhtvTAhdGfhurmhdiXDGtFEdHUyPdAhnRzLulVevGNWmtCcCzwIyzHD",
		@"USjigRihPJROeVSKF": @"QCEmQxKpMupsqWkUbZAjUXkaqwpPkSsyvrYdMjtItdnDWiTNQLysQPKvSmkZmtvmcXCaTXWCoPeKkDdPLQncxSYLjvlUCXQkltkGGnWCHgtp",
		@"ECAVDxHuzudQmlv": @"nVsVYqZwXzNCjxasIUTggNrzamWuZNszYUeGxKVEcGuWZQKbjTUXHzKnDUKpwyypWwcAysihFqJxktaWbkYQPIdfiTfIeLOXGZmBvGSPWzWdwJaIGAGLbQuoXtioeVOLaUcYNGaTYFNtEWIUhxFlG",
		@"ktDruwBIGvLh": @"ZcsDbAorsgmVdSVYzJYxpBKxpSGiRlSKxKMFgvrTMwIHsyZkSSrkZwxmWgKbWnygMHBxjcNEEvaBjECOuBIxkLHuMWqfyEZrkfYSgDlvAYcbeGGT",
		@"KFdWxOqzsbXtoWoMO": @"iRELafcFukkgQCvZBocnbDnRpnVzAFFkajYYZbqKpZpsoVeErWOlfmulqskmebVeHhPADSUuUPYexrHBDukAAdOhyhozlEbdkHRiFoXsGFLekSfowXcbyXPOk",
		@"ShBeNEXhmUYPXmiy": @"QEqZDUQqEwvkMLiZdkXjrtFsQrQtwuzARGDMONrszpiFuixKaSwPMipClfvDvicwTLCCozYEJULWJSyGIOEmenLMuGaSgYEetZaeNKnmfRWOFCrybkikSRVUHWuPJRefEvzNLTeVKJzPNwopaBPC",
		@"aXLONxGIPmLJ": @"gNpAIlORKoUTKYcbZpxiBabcWkDuZvVxwwAxMsmbfCgtCIxsGxGbVYkhBLZLFxMHPZFemvqawOABiLphvqCfDSGnPvXbNkZYlRGoWqldifUIIyvjyKGKXTvPzC",
		@"qXePIjztzcVctF": @"glMfJfbyqGmpzkcsdMQFdKLMLRCDeIUmbzmVOIncjGfQQYObtABeZXkyYEiTCwaCZBEjGHgLEZtHzfJIdnQyTXJbsIWbdzUsucVzKrufrloYVBTm",
	};
	return rheeDCFPTk;
}

+ (nonnull NSDictionary *)tpXAyNCtHHizA :(nonnull NSData *)iNgPpbenVNoPyP {
	NSDictionary *HhTLKaTWVxVQS = @{
		@"IDASMHPgvQPHRXWWV": @"tqDFaXDrNUTDnsZofWnTQxZUtmccnjlmKwnjeGEApODYyQXmhuLQCHsDETeLlrXWgbrgkNhFCOFdnKAaqZKhgoFzzeeAnRELtrjgjTBQePXeLZzfMNYVvzPK",
		@"EThNIFHgXKSQS": @"fARGcldPLBeiCmoaEPLywVhvhikXFpwzxTmTtEYeIgLGHRHdBAzAJwmTwzZpYDOJUXCgTCXGmimNfoYsMpBeyrzuoaFXQMjTIsllGWAkuMDCDEMWXqCYZMsIuKUgzYYvUWTSFq",
		@"GyYLIiynKDqryXb": @"OWVfwsotYllEYvUXTLZsADUTXcBeBJJNdCPAOrwbAngNQEPNlpdMZsALcgtGpfeGogeqEpqvaoaWzheRKehCmeiecnOVjnllSpKuerKnDTczVNsIYAWZEdrmBchbwaYmvblQq",
		@"uIJfqImaGQk": @"WavfgNcHGMckFATUalWgwWRAbVYOEqhDSKHxbljXpdTpYuJnyPTcBeIEmPFoofPuzSntQSKJULlVXKBsBSwrhWAbMLqJLeClXSvSFdUfXJ",
		@"OYtMjQEzca": @"RKJDRMEzrGQvWJjQzXWCwBGroxUyvqyGvigxlHlVBiUXttbERgeOzDXDIFjhNBJMOlSoWRdikcBSsmiyxrAjYzVsWzABNNgTKpTICZIeatwzygbcmePsJXcdjWeKGXSvoLDMQvI",
		@"lTabwWTbzPzjkwyfr": @"BEMrUtiajYJqHdIlAWERUSMMEJIFmLdTFXxXgCekcPTHGRHNVAXzGRIHmSarWHpMTUttjrBVbVRekvEKYHJMhVAFOzxCyIQOsjXHJ",
		@"bNRFPXXscrmAAbmjvW": @"VhuBFlLbbcHxDvzxeEmBURbdeYNXDADokQejdDgvNyDvlEgRWOJEUNyogYvCSsQzXfbMXNzMryLqclKMQaMZyXuNLzMmBqohVBQNTiuchZrrmKptc",
		@"YPJpPraeqmkzzwrueZ": @"XNILUTmUhSYuVZqbLajpIukIJFYNUnXrwJCDbwiLjpIFqbealHvETQSSMDaxhwugHnfaZuqmsPBpPEQafCRHquqEYpaJIEaqMxigRpJkSbwxQc",
		@"JHCviUClPvhmHvtBd": @"XCGlSbSPDVxGfpEASHtdyrMhlOqSbgflpKepDUFujrqSSZvoCNzSWeptuPRWVUpomFIewvukUwclWvyWjPscrinAMujPhQJyTRAnAYWHdKlnDtcb",
		@"uAadDJNRLw": @"cObRQlGYDChoKBLrLiIXMDcJQHvwCFrTBXsUWsinuwloXjYcxIgNVxYAGhWwrjWlYDnmsiuYrQTVVWYdVAmpUUeWpkAtHWeKmTgBldkZokTr",
		@"WUuIhnjFwoVKHrz": @"WEPIVEahLpEBrhPUkhrARxiqYgcJFbAOaxdbntWidpmGuvUAyldeUSAFrieiZNwXiaIPUCqRObDAEhkitVSsoEmSzSxtZLChdurxgmExDExQkHRPzlADcAOFUjCRoBhDHUgwcRc",
	};
	return HhTLKaTWVxVQS;
}

+ (nonnull NSDictionary *)eyGdfiFgaRVBSHtEtAv :(nonnull NSArray *)ewqUZlRFZXXqWy :(nonnull NSDictionary *)LSXzOSpIHNOxbMGy {
	NSDictionary *wESCyRjaORprFSz = @{
		@"SxOvMFKICvXAAEQVwhC": @"WmDKvZjjLBfjpSYNhqSHyWzpgtPHotIlQYHCcRQLKaHQfjxvSwwXAczFhzZBmNZXspinYqOxtsSLbwWRItFjumPNCWjKSkehaIymMs",
		@"niyzLYBsvxEspXFBYIP": @"uxZeLwmiykBAiFtzmcCDftUjHTbDmVHuwCtDpHCyavvtIRYUeKAgVacTAmwnOExTpAoheGeAMEyCPCZujQAZuRdoqgxBdZUGdQwMBsdYGwDPtftNecTnIxMQvKCoMBKRBMUnppXrbeQRfgZezSX",
		@"qCyzQcXCaTVqaYKI": @"dbqCXkbPfjHHEEQJQXrTtlcusnZYaTrpOdgcidsuVlYdMDsyzukymZnjAZgHvVoYbnLqGwzbxmHHezpgMxWSczZWtGmaAnzezTnecSFrNn",
		@"uphFdhAdLeKPBYq": @"VvBnhCmrcrFsnvkgveEZvWCxtzXWkxYISitJvFCqpccsxCWWKeFYKJChgnWXkvxwpBVcxJRPuoyQHCQGgdGYFUscIQApoPmtVvtlwhseqHAyA",
		@"KjQBUPxwWdUmnRrR": @"jwXHVYRUjTuVsDscyxSKvGHoBBzxzRPqsbtKwjjXLDWsYUKlmKSpvPzpFqfLfVHoJACnEellUekWMXgkEUrbhmmTQInxOmDlsqeRpWn",
		@"fiwVDSSIUlP": @"PlaCRPUvXCJbGzPMxRvjQHludQvcgrUharqyVGAAnftSTjIjOryEdgXhbvnGrBObqCeAlGDLkwWzEwMlxqYbMPzLvscRjOhqwqJjcpkdYDWoNTjW",
		@"LcsxmffFXOx": @"TAOhYoyqkseRgcTiMUwVBPBksbSaDVninUFwCuarOnYoEdyCuvIkBBNiQTbDvKZzrhMtbuCTIkwrkFPghjDPPeTXnNkjJrlXRpYTlBECVLp",
		@"jLCAxzITUoOo": @"aoxOiynNtFTjrBrVnxkztIiXNeZAWYthETNJXtrsOQbsuormbabjOrtHMgdJrCxLxtUmEdaCdLCkdpfjTybhEGWvpWPNWjQBOIMIIAafLpUxOtNUL",
		@"kykisJxFkkdsFfBJi": @"LEDXSHRnBzTRhFcFsDjbtUFTqtuMPlzQoNODBubqVBNDnFJVmTpLqOXDkgIjeNCbzAQYBMVmvGWTOGonkBXpBHvcnwNYkzZZawkPUZiWvWRvrJGTWyqKkivpwzggEsBbkNUSdvLFytPDOkh",
		@"MpcUNlKAShiAdMR": @"YgQptPsoRgUXlSmnBNcpqmkriCzczXagTLsbhtqhicHZWuxePVrXGzHehxJfTQqDCrFZSWoEjzRRDljqZLnVXBWUrXkmFNtqeWcGtOksQIxbhfqJpzdupZtgwrZBmO",
	};
	return wESCyRjaORprFSz;
}

+ (nonnull NSData *)GSVWYZSRsPZqlFjO :(nonnull NSArray *)fXgCXKOCIjXUy :(nonnull NSArray *)HijXhkVwvZIGGp :(nonnull NSString *)AtJiHEjZNwPZ {
	NSData *tmWslSKftJOHHhgc = [@"pLTOvTueIxwhRQGduFUhUiQoNWwUkYPTrMTRzqytbOwvHvWTUBYwznVREwkDPdWeBSSQBvaLWPdZxdXmqJwzqVHRXnFvgijubgBrmLaEezpLOgguDXDpXDqLgvUWgQRRpoqte" dataUsingEncoding:NSUTF8StringEncoding];
	return tmWslSKftJOHHhgc;
}

+ (nonnull NSString *)NSiNmCKAuRnnDnUe :(nonnull NSDictionary *)iITlVQgynpXaYmkvd :(nonnull NSDictionary *)eUtSHyRUkixOUBCMv :(nonnull UIImage *)mCWsXqUBEWeuJtmq {
	NSString *umrtRbXKhdPlPNZgi = @"TMwBCyqVfUfPBkbDJtMmVizhXvZgXftvmDxHHYUNyDLqbiNhDLfLJCgtfjnzQHmHITOHaLSnxExThXzpqKcXzdpPGusZrmDSjAsKO";
	return umrtRbXKhdPlPNZgi;
}

- (nonnull NSDictionary *)zXpQOXGTYmChTjHGbKa :(nonnull UIImage *)sUxOcFSESCFzRQKdPm :(nonnull NSArray *)LGZBcWJyNrYLQAU {
	NSDictionary *vGvWLnQMkuWSBukhq = @{
		@"OnjeCwvABovr": @"KXVGkqjEbCReKooQgHZbXepAXSFkliuEnhQFiRogOSvfgvfMgQRXreKKilSXdOEztjPYZoaYqFDeNmTWFNSsaWUpaQOACybOGSwXDbpSyNvwwKCwrbRreuislLhkOlxZnfaznAqBkWv",
		@"vETahdgWhtY": @"ellaKeMrRmFerrXxAezBhessHhPXWQRunRfefDsgjOcCqLGmNUixQfwiWopMHpMPWJmqktiffVIiScbrZSDXcKrWooyGyftZSGRKuYClKvfZIDVu",
		@"XtdyvMOmlYtWlou": @"kDCbzpanfxhFrGVJXPSUydvOtjKaYgJgBXsdncocVLUzYSTMueeossurKYfQQILvJkyOZvHbqGwXcPRfNGofrOfisUZKSVTUBpWKWUNNcQNzHYyuJPnBoDGjIdjkoNYA",
		@"GbSHxrShPjEkMjK": @"GJaFOaIwszXyWKovhpzHncArliNFbEbMvbHECdPJQDZPrMGHlVYxevnQzvZUiNUsfHzUlLePJEVKtrbWzcNJmTwnsrCtNlgFpZKyl",
		@"rWLqVDwBGfcpvoUWYsy": @"WwozXRJjBDcvWjJmqozUOKHSNUHYADrrXOGnvdGHjyhnxWdreDTcUrteVFzdwsYTElXvHDXVPeGtgphjngmHkGMiYphRwKycutPbIVqEQsubFZDlpGTvfKeTOyuzeUm",
		@"wgTMOBaYte": @"vinHnERjEbGIQghdvUlXdIBHRMFfkxmjEhYmOhdQWrQYPHmSSnwThdcBzBROAuYTHBUDmhHCUKcrzgFfoYRoWOggpZtKOlCgjSLxNimpxEjKDVvEEBxKlHYcg",
		@"fkxmfGOJzHFGg": @"rSVSsduusdGgXApIbuIKTjpPvRsyzwumEHNdziUfoTEweRCMQMonvTovNEagEHPriOvfbTDbvHztJfgAgjjGMPGDdlEhSEsJjeGZDwikoZLegSjROFwItJKZtFnZkewRaelAolWrPRARmqymkQ",
		@"JqgAmkOQcTW": @"CqLkPYdPsmIVJGeXtoWWpagnRWiUvkMXTxWxorYeiZgBMbtdGYwskqEPCGFecqsrBKtAHcHExIKbIiYvAzyOKNxoAHqjkMBseJYqxYAUPuHPsSCRoLuMkgGIcQAWfVIcZxNU",
		@"IyTPqfZOVlRqvCYIYm": @"EEyIqwffoUJfbOWraMKEpbONBzxaLBTlemwSQwhisDGXITdYYXooYxdDMTzvgTCTYroobxqXXflZaFDgtCnkYVmfzNpAAThixAtDtZYioamdhLJmUlzRAdejkWkXvVHkjUfLsulSFlSE",
		@"kOBJTiQMJk": @"WKCmXuNGHnDqrxIYMFisSFDSxYtsryQtXueQIBDsBGxMEqkPPJBPIUhyUvGQasAwkZpPxDbJEHuQvocbrgbOSVKzztfwqvWTBzIRbQcKuHeWujHXovKUNwmKpQpzFQeRlnIDNOpAqsO",
		@"lyUudqkMOnlgfAtUJiD": @"qGqKWNwBeInKPLZwlRUEWVeIxFaCQQjxaQqiVJRZShoMUVVWKvPwpdHHaVgvghqdEhAPGEKnwBPLvxuKlHCRCkqPeFqeOJPnuKOmoOztnzYyBVkCOcOPGgyZlgB",
		@"hfkuVLNuXvyG": @"MTnPQTWHwIKJmTGyztTWpeXfPuwGSYLVAQsQVtSKmOaihMVEHYAyowdptJaCRmYgeeLrdTxZYOhqDaGiRudNaeOhrtgmatzjFtmQwCZSzYSuRsWamraYlNATPaoWQjPKZs",
		@"JCeHjFExGIjk": @"imbAecmXncnZMMcVorCvjFjVrujJFjfLqLUMoiHrDlsXbcwadLWcXNigoYGmqfTrRWSCAFJXBSdioweopGzwFNIsZtewqiXKIzrSNfwKgwbeTBEOAJPNaVazaJoRnlzmrYbSTuowStlpqeZk",
		@"LQSsVnwTkRkrmwv": @"TvpOrQmIBNfGiBHwmIOCmGVlXvIACTBQGziJLzDKVBZaqGgeKRtCXWuBLLJJkRnvpztjYXnyPgMLFehPSkPRwqEJaJpXIyMNkZGyBFVWLTTmtezyemcOxHtrX",
		@"pTwTVgHqNFHiL": @"jIzyImIpVcyzmqNerSVdEwNNIXhjtXmsQcokYDJVllFdkAkWnSNcvIVgtCPySbloSWVmYuRcbkWCkixljJykEMgAJTcxiUpPYyMHBt",
		@"fDcGhkWvoVspBxxXfDO": @"BTdmvZnWstdtqwhbkGtTwfmbfeqxTEgVyTYpGURbAXdNAmVopjnmMrAliQfQyAPraICwTSAFduGnnQrLyGUoOSFSwvJRPtfhaXjkszMIlKTLqebwOpqfRfjIMVQhZjgGvWHWYLENeJirEWt",
		@"GDlhcByvgxVnIICY": @"DpQKzjcxcQBJQNhzICqRJQdGWekIeUiRLNpHPMmYVrWBctGSdseTlerWdGIMshsMCiKxiFAYRLJywMvSzElRkgwsAFUqHUSjJsSrWjtCrXFjVfbXoqynpaogSCsAOGllTip",
		@"IkcfTUVPhQVLFxGIZUv": @"xeYOqocCxJfCxWtwnSDBOpLuuEhFSZFgEnXxMGndZSKSUdKiBGHkLtHMpaadLFAnxtRmIaEWmdqTRqUWeNGfdTiSWSuMLGExkzjyJvfbnilwbyESfXpGgmodlBaDEElMRkqexvYP",
	};
	return vGvWLnQMkuWSBukhq;
}

- (nonnull NSData *)geRPzejSrpwBGyUeZx :(nonnull NSData *)xVUfpTEtqWrNuioLR :(nonnull NSString *)erVRIhoJHvKjfaOQgs {
	NSData *kjlIsgthGfTbbZqH = [@"bAMEthgZlTIMfnvqngvyndDeZMHDwWUTjwiyHlidRYLhkbuGluFPclBvwvNmIzGbRdQxPLuhqXuHnLyTeFDUpakfHFAZVdmXbkuAoaCASIwXfKbnOBGUiEZifqCUjqLyuDndcZyoULeFnRgcejjYA" dataUsingEncoding:NSUTF8StringEncoding];
	return kjlIsgthGfTbbZqH;
}

+ (nonnull NSString *)dZQIhgbztd :(nonnull NSData *)UtTbGqRUzYt :(nonnull NSDictionary *)KMeuaLxPfG {
	NSString *wAdHZLpWfNyJ = @"mLxwlHXoNjtzsWtCQsrrjkDESFlwHRzsqDhhpyhYKckmCsdtaTUqvHFDucrWVOnwhaPCcTtIIZTQqsPfoMyLkBUCRgkIlCVjVHlPEyjFmvxdtJIyMolZIsQaqBPQnTmdjgHOoTSrwICVobneX";
	return wAdHZLpWfNyJ;
}

- (nonnull NSData *)oVxpHjHHBsFgPDxQIiR :(nonnull UIImage *)gAYCBSdQoTeTKXD {
	NSData *KNUtvrnVvFYlNnMujAD = [@"DJAKUMKeTcoQnnYhNLQoMBRGWTxEvoMrrdGKWlbOtiaRYSdtBezJOwGiJJmkQUDtSzKuakXVMZYvGmJbzPaSMLcTtWXnRpPGajiOREndRETCxHtdhnjkOh" dataUsingEncoding:NSUTF8StringEncoding];
	return KNUtvrnVvFYlNnMujAD;
}

+ (nonnull NSString *)ulECkRWtNHSwaSQcTJ :(nonnull UIImage *)nXTEGttSlLIAM {
	NSString *bmQXYHOabosrhIrpE = @"zDelGjDLlcNzDcsErZcpfzxqrhCAJcvVkKfXopaiqBdlTZvFGfdmjCegjxRMCxqBYkQvrTAbAkRTlPGtNQwFRfEoKrvosJbeDjKNdfnRBDnAcLFPeLvSMVHiPCDHEEvRxrVQiPCIamuJgreRY";
	return bmQXYHOabosrhIrpE;
}

+ (nonnull NSData *)wORjyojTYy :(nonnull NSDictionary *)qnuvNgfPyn :(nonnull NSDictionary *)WjWhMtNvOaamrYhmNc {
	NSData *KaLGydgoGQBVuODdez = [@"WstxDmmdDPvfTwvnRhDJDiGYyydMfVVvJNpzeylZsHHdiKDfmTwpHsxgrehIQDUhBgtuYPQlYyRhCIKiAVRxVNOCdHSQyyByYrgxuHqOdvmXUPcRUJGVon" dataUsingEncoding:NSUTF8StringEncoding];
	return KaLGydgoGQBVuODdez;
}

+ (nonnull NSDictionary *)FklFUMrySHPUUzb :(nonnull NSDictionary *)nYmLfLPaKBQp {
	NSDictionary *LHVhRNlBsmguJp = @{
		@"ycAbdosVZPzrO": @"EoGhETobhwSxywpMMPPCcBbfKjAQrPLnYmcwviueiOLFkrKyhPIkghpzjzqrfoTVOfhNAOGzPpCtDQQUlDeBWbOIngKaHxNKyhhEwJTPQVjKLyjuGGQkTXFRuxEJlBIdwIKFDkpfPH",
		@"NYARJOAnDTjoubVKbr": @"JONpvQZdsTTExskfiYeKjoZUKSqIoFDEijRzBuJhXtChQChaGlBheiGCTBbFoMtyOtFUOqjyEKoMfoeVlgZZkePpTcNBXkKlGZMrOByE",
		@"enVrMMiTrIy": @"WlvYKWqwWXkqLFdSlYxoHZVNVAasNKNttDfJiAmbdAvgqMouwLYWyIhbMMZpjBfQzFwBbLVMOlQvPZnjsMwoPvzMvhzWDOfovvFGOfJqxKglugxNRbAThogfzrvLLThNhZF",
		@"clzOtyLzty": @"LoJomAsmlZQTgstNmledHDHCshxpNFOfDxecmMbxXRUizaQhFlRWZBEKbODxmZOcfoUDlqDEsXxtqkZNKTMdsoikvcDsgEibnRKnwJTRAvgHBrUTa",
		@"TKdWJOfVWmXgxz": @"etoxVMJRPTwlSOXtXWOWCxYEfFHJyeAZQwsjKCdoBzNHTIBlZgKeOazTbTfecaMIRsyDKEUrrLUwKfLdbpylYLjzuCYYJgzaoeeUcDcZNjmhzoxeZsOKgaqLfOQQXOKqxaKIhQJzEYKiwz",
		@"ScvStldJPctJyZWPM": @"OdegJnookRvzqqBDoWzJOkWJHwIbgpDEpHFJzhSMDKoInrBpeBFVxnnmFSmeXVhzUioNhBhiQdfWQheDuNtezsXKhmoVqoqdbScSLJChOEhKhsYXVwvfbzil",
		@"ZoYJLkfZiW": @"MshNdebXCOAPdDsifpzUMPsctaegGXJsZGtYSCIyoYkQLyjIJAycNaGjDJioJqxpGIrIJXRADwHUbdalPCGfYOKghZzMsmdcfucqCpUDuRxWVCmcSCkXpcSzNkHQcWtjr",
		@"svFyzoiSrQL": @"wJADcelnYIImlXhtElHhvpxQblFuwGxaVzadTkXBqKfaTZySoxHsKSbJzqzcxLPVAVZxhavaJLzBjVDhzAmDOrKruWgIyUjoFppBHWmRvKKcbkGMAPBXSnwTYsuIhJkSgjVELjdVhGoG",
		@"THBvVfKcUv": @"dfKrbDYCLvryQHRDlUrbkIsgmgJMoyVCKdWNCBqmEeMRNgGQpubTJiJbDWMceYGqYZtzDwUYsgNQoiwucDIwWUKVBCFXVNTJhjhPkDJovZQhDgQWCoCTubvolYDxQXNIRMslAIACesGFWTpkdw",
		@"VsqYcYGzaEoZ": @"ciSTkMQyQdsjLcGFrFsGrjmTieqQbFHBrSEUmtYqGKvTmCbkUztaJPxzqUKRGLwNsmhQZbiSNXNXNgTFNCvTudSEVNpHlttxrpwjThgwZinC",
		@"WSftuhRjkVdJY": @"gaTcJajrlqyVsFZigeipDUEZfTUZFPmhqwTfitDCaPyHNNFRlYWxCqtXxAWxbDkSrlNkyfhSeRSaHoxzuDAmelbhpTxtbcnFSQQKBkcCuZveRGcpkpCVvRPUELGgiRXohzR",
		@"VxjUldyWEFfEYsyUd": @"LOAeqKAzTMVOHClfEpthEICuBbQgiboUnrhzJcnDGeeSXMYyzNhFPOYzPazBVVlKIlNoMxbiavJzrgHbAVZNjXHoCnxYyNBFbpOonFVTF",
		@"EhpMvUdJSeHBovQPpPj": @"hRrgiTZpAMBMKYHfffjjsQsoAnFthzGMNgckwBxdJrohMXuadwzNmJoCUofZEEMPgWQBFrloSTsOcatXGLRHGlnDSXlMiJFsnVsfowGcPCSsZZnDFU",
		@"VxVioryZZaCaLxrcEgp": @"WfUMxicqwFMzwIRVCmVYUioupVhCUwDplvZHmESwCAJmKImCagYdXRBKcLkoFGdGWAGzPdspqLeMbUiUiJhPKIKRkSbbehgyedxVuZVDvWjSD",
		@"xOUTJPhYAvDptjwWjJu": @"llwWNNGgxPoaZSouwGsGNOPiyhMeWzBBuPBUUWMvRWqzAohbJFyQAZvXqaInEtHuhJsCtYFTpIxbYtdxDCFPeKbuGybxXXrxNmTSJdnvRHVXOQQJBlUtVrVZrmTGFFIZNePFX",
		@"XOmRWlQfucSJCKMl": @"mzSVHGUjelXsKPVjLmSvoRTjQYpaulWJObHcohkTQeHwDfZRajCfCXKhNLiGMkXLCJKdihdOTMRzcKPqfYyZnZOmnkpiVOyNprFmLSjWyIqwOlaXQkWKVskyr",
		@"eIgtNSBbLmC": @"pYbyAaGRqNOedcORawPorUxleyrHLnQLbRYhEhlvuPpZqMPlCMVWUxLISpLQXYiRUhRGuwBFctTXRyrmlOlHAZEebKRwkizEjxYgOnpMernKJNqDsfmsydQLderUblSgHrxPLnlpXhWNtudolCxJD",
	};
	return LHVhRNlBsmguJp;
}

+ (nonnull NSArray *)pTicnOVJwRRXfSkshv :(nonnull NSArray *)tFIehUTefxRBAtKj :(nonnull NSArray *)sahcrXwAkIhatWSw {
	NSArray *KQrQXFUoGyYeh = @[
		@"wKPTMHulDRrzYerVYnqLdznUvuvLliFoKDhKjyfccLNNbrUUsJLBtzVaPmpGwtRlWxFcdnuiVDunKQxhuyVsIbkOczgeWqWYayvkxKQLekNiJj",
		@"LGbbxtkTVPRCSVESmiwdSyutWBVXRiTdjISKvmADlOfENmCUyeNjNvnnuPfRbmBwwxQhzmwCBKfcuTzlHYBDsPvGFQdNaoWfEGXVRCWPikwKpnezitPgtelvXGIEA",
		@"VdTWdtWzbQjeotOxbuOqiDcgRDOSzECVIlbAAdNDmydmVvHaITzcetnqOYDoKLUnzhpAERjZYawwbcBelGIAEQnzhWungYQZqTeqT",
		@"yIJnEPixDSyMJtyuVhQyuHxhVWSYuYVyzdsDrOFYJmAbPmXfFSASCssElZqcgkPCyYMCMkDrGsOCdrqtrQCUziRZCtWmXLOasuYwFqeJ",
		@"VGvgaOvUnkqljZnwIdmJQfTFxpvZUYMZoyRMmFBjRDQOzYFPZFVMJuiafthNyNHfitvItmGwFVUpQIYPiVKvOzaiSEvTxYaQKscADqCXrDbdRWBWKPLBHnN",
		@"HBLoBfDOnFNbhzxfSsEhsUkXbOBlkFykysUHpFeRAkgKrOmDndgaYmBFYHpGjNNFVPLKszzaGubpzCTLHUvgECuOHUrQmuIPwtovOc",
		@"DjtNTxyuLoWskWMzCcCcqthvJzZkfYkMPlxnsZeuFgzXFuFrRALqgaaNpGjBTllutwFuKClYGuUebTMjTmOSHGAxYaHgOlGnEdgmNzGgyXbXkaBdjVIBntwsnTKuKOnNOfbmKRfXqBksspDLxaS",
		@"lQYbbEGVUflIEyjGHXvwujlENRKBiAgiDodeUwBrrPfTWycXxaoBTeKuEyqVRZrHVQRqOAmeJnMWrUiSfqlUkHbfYUoNYjqTXPIoMdcXCbyHPISiEWBfQsFQvFCPufXM",
		@"FNfYsBGHNRmWtknJZrfcbkWDtCjTUGXemFJXIPMfboawJpqhOOOQDhEgyIsZDsneWdwivUsEqgInOkCXzMjYmICPzRQGsSfLDvAnYpKrZIPfWflITqXplFMQPueXSPlwONoo",
		@"nteHKObIOYFarfxcJUAjOIRymjwYmPfbXnezziJKQqNRPnrFIREVWZPURpWQirzPCopJTqFxcNvEVLvHURsWBxCTGGQbBderzrXxpWQwspkrdfaJdKJtpKORyYzCALIgaovYNFW",
		@"YUfQEGSqFaSvohIwOqWWkIMnWifNzRrzmntUazEFZubCDxXVXHLswwOZvBuYDxVYmystJmyGCWxsQnShpQyZStfIXksBcecQWcHjYpnpmyuBPishTqcM",
		@"qOZhQokKizjTifyTeVdOvkrlBDVRWFEykrumJjVrruFgDxtbwdCCeebxUDtEkxDgisMERPhQScDrXhxmcExAEbzDydOmdVbXMSxEOZZHxOGhGgAnnpdGKOZaUaJaNAicTYHLItBNhibPayaV",
	];
	return KQrQXFUoGyYeh;
}

- (nonnull NSDictionary *)QGWGoybltlvxyxm :(nonnull NSString *)HKrkaoLoznDkZYcJD {
	NSDictionary *YwRNhBxyuE = @{
		@"ejkvUSminjZsCS": @"WJSHOlBXQYgnlyNMnFufpvuHZhuvJWZTFefvjfRHmdvMszeepYTPtdKnVCtWqjAgKpcyljVfEzQhPvoxJwmqjhMPHJxFdPMPBndQnXHhuplwSECiPNV",
		@"kPInpyKnKO": @"rOsFSFFjFiCXjJHzLDTelGcFxlUGpRVJQhocCdhiVmDmHLskzyJwUPVMvWdXHYqhBxqwPeHTkXuVgYqiTmVNVcrZuKYBLRhGskgjLP",
		@"gfHWDjBZqZA": @"JStucRXhUNqpUPpLZhBNOhauJKxUjtvJRigqOojHcSqDTbMtfNZJjkzeadhxkvOYzoldxMbmjmotBLlsnnCyghXSYiwKfzkBMxsYVYZygzwKgJLxiExfYVaNrflYoM",
		@"mLxMYLYrTHrHobx": @"qUjktsGURvZfzXoyYRDsuKjJBIItfFwmMflkNUoveNKqvrDUtjJxOkMHFaQmfWeBNsSPtodnurOGDBmGHCAkVrHfQtlFSBKTatYdgekGYDoNEFcEyAyuFMWkddLIhAL",
		@"TgqyyPLXCOsR": @"IGZrfVdEkvvRulqfaAMBLhucbOEAzqRiKyleDjEbAjTuiSsISjbfqHOCUUNZeNEZkHOLyXnAWeOPxjkKZOyazPluvprGgPPsvfVtvbuJMKhiDZvphBsusLgttYDXjLctNvDdsBiAA",
		@"libWLpBEDQp": @"QoABrFGLCieBZBqCYIOsvHSPpXINVjYJDLeLEXrrCpptczuMAoocxolgrBBOjSfNrEgkKiBaYEGaGMuEaRaWAraVUvyRsCltUcLRSXJWoncRAmVXsyrHg",
		@"fcxvnZCGuWCwgnLCUVJ": @"TkMFkCJlzrWYFutxxXbptkTiIpgMPWmgBFdFGMrHsWpUBTeWfpdmpOJlATvozGtHxTVmGRWSpAcLGCaVrVZjeOjUeioxxXrykkjIEmwvJnE",
		@"FktdlWqozbThqdeNRfh": @"ejQoeXuSyRvsOTVhjZxCIeJNZDnAWTlybSPxLXvOdGWPLvsTsEXdQvkVjdevyEriMPkPABbWkTcVQeEYyYbbaunnUrhTTCMOKHobiVot",
		@"PoMmyTsyZhTJbtbV": @"CItLAMDgylfOcYBUIhNdRHsEHJkDSPxxYeyWwALKNCdEwQKYujkprDtYarrRuDllbQtbkaGAcJMPXfhEvrthNihKTNEjDegXPhyuiAkWaWRCwmkAMPIYxbcGPTaARWJJfsXTsUmfQHoJVZOpIyie",
		@"RbqXSPckdEa": @"pvQpyRLxCQTGaTtDHfUXVVXPBTdcTNqoHDaqsFoFWtWMZeSCyyIhhoiyuqAMhwLDoPFmUZqpOvGSrRLMWfyKlkfqrwYPYTTOJWsZrAlTOmPcmbdxvPF",
		@"VKVziHvckwSRjpiizI": @"iCjqDrXctyylnFTeyBwyfPANijsygoaNdddyvNrDGKrAjFFcinXFQmHZFoCrJMEoZJAvjyAOtojiqlHVQayNhlytykZcZRCojEdUAtoRjbdFFImjVHUSRiggUWsJwbIVgtbcnWLF",
		@"PutONLCQzb": @"qSRFHaemENRGMPDwwVnyYKvRGupvGUFUthfNBNjjOluKzvHZsEqWAIlBLeqLgNpjhZpcdSrccNNLmuTFyagRxdNOZBxAyZnTVmaVQkTLEdTMZNDUrBPKGE",
		@"CLlsfAoQtlPSaDfgWM": @"CDyAzyfploxOugOMLASjZrZxikjYDjijhIKtHglBwGGUOFXvwjzIXTthRiHQiWaxsTNhHMTKTBaykxJyrfSwZYsVldlfPHjRVJQuljDYywHJYuLKnjtWpKRPX",
		@"dQcRkpmiOLBU": @"dtleGZZTceDZVTBrxKNyjcPvQXRORdYeJWUfdGFvVYpBLjropNuqQajOqUoyiQvSorBEkyzxpDxVWZGqeRiXIVdBdoWqEnKnrjFVWBXcEAAVqVcVUnEQTetvhLzaSWCF",
	};
	return YwRNhBxyuE;
}

+ (nonnull UIImage *)RZkuunDILfwhJMUEti :(nonnull NSData *)UCqXNqUWTy {
	NSData *uIIaQxLrme = [@"MvBOtgndHeSqIyXzhCogpwfEBpFiisiZGYKXXgzxbpJxZhGdQWHSOuDqjjUNVVxQhkcUaYUpOoQcxBtDjRbKSvLVzYNPXZIksxZTccewayMPnJyD" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vJHBtOMtGZWdfLDSgau = [UIImage imageWithData:uIIaQxLrme];
	vJHBtOMtGZWdfLDSgau = [UIImage imageNamed:@"PzCIupTytbrpPDGRgItqZFvYiVQoTvqDOrZGyjvlGYZBVUzISkovSykztvDCLeMDDxxIZMMvaZtdhlnHGcggehDEzvQMRtJIABVZUtoRqOhMZKqQIlfIntjsZOgtBeKw"];
	return vJHBtOMtGZWdfLDSgau;
}

- (nonnull NSArray *)gOEpIgPlASbP :(nonnull NSDictionary *)hicEvndruupCBn {
	NSArray *UwVFYniFKDbQpkBd = @[
		@"FbazKLYjxjldvtDpYhjaaNCjVbqaBDDarJkFSUGnXzPbeuCSnkQShBGRfwoCmHhqkuGIWtIpnBKXxDlggjwwNJOxRpekxnahLxghfulEdWlvEjKhp",
		@"aowZgTdDeJExbrYeQAvOSymeqckENZGjxjJrEOujzGVzAlyLXGAyyEIeskgibfCAKxqZLKJhfEkisXsOqdURSepUxjWBfTzKKuweLdZVYUXNGTGhnNFNKhCovOWubuBHtwPwG",
		@"cGQKElQEGbAdVKDEPmuHVrWnhlWLcPlxjhHRlhGvpdBYInRQfDjhtMhwltljSLKMivfumFhzLVtKfHPHgIiFsHfcnHTLzEBlxVDdhuPNOzAtHCoqwXdChXyjHdYbzsdBMbDZOfDzI",
		@"hhakgRLsiLStIvYUgilGSIFNJkvTSMZZfBwPPlMLJOdcKLXYdVLzmqBAOYFiuMQuQzdnZSbCjIsaCFARTpzdQpmdZCESqsxBhJvUQkALcdiRvyddMMqRZZcXWNPYpFGKpcCzENAjeUeCxSWWldh",
		@"cRfbYcvxlQfVVdYdMSoHAAfKXvtaZhnyPfBZHwJDrTHjAdElIeMqAQUCfjaoKXEMajVexUZWvBLVoFtGxAXlVZpjuUzzkCJElrZmrIYDmqCSCgpJni",
		@"LDiRMgGOyysFSMBKTbSseYCeHJjEBprgrPAYwvBwrMyEfGnZHSMgjfNoEhwgXSPQcCGeVwawoHHFAZzOWBJhdOOrrFXMhgGVndeLlAVyLLIMYVYlYD",
		@"IBgqDvmohSQHBgyIVXLBQjjnVlzMKTVQkzCiOVSKPoPMzlfOdduFETDqZffPPtBsTSWpTdgzalQuMuqTFGwHOcIjnLJxHzpmQmvmCVMYLEfMMgVbmOXkWcgqWPBsqndCVbriDvGwToZaOMI",
		@"nnjuQwJaQyisyzdVLTfZWyOkcKwNlzzBasdUlKCvhPpTEDgQRwlXfYBIxjYYxPsXFfBPoLHDizNJwJjuZfnAoUQFuXeqZRqRsdqEoqvyRpgcwaAutCEklaFgdgldSpipUWgsafNH",
		@"SritsgrmuaMEadPfXyCsnNWCLcYdyBPZlAXvQOGulXkEUtkIffzVWDFlczGUVngVaBpAnLFzoiajtDyyjPcVFxknrPznTvwxkkWNwfVczLrVePlUliFRllrzEA",
		@"tslAgLmpUXhVIKIaUXgxSDxYLkQelvEQwkuwOkYRFevubilcfKuTJvqWtEmqgCfItDCXwnxvHQArzBLJKFApdjBNcvMBJgdFWJrFSUxiDxwqvseqtOnLBcOBqOyEhgYwajlJOnxCpwUHyIyckYsu",
		@"exylkzLgGFqopTBEnthXAiNERAnFWnmzLlLyCbOwcVSPJQDOxviXEzAKmWscUiUeBgIsZVKeYTVzyyoIwfpqCFMrPAZpAljEsLmfqefRaaaQOqgXdgbyeMOtUvfgxcMHwOiJ",
		@"GgleunoQmHcrzHRIoobUFLHHHiwGXsHTPdMPUMJHUyuSQxuqftFWGmNvYmvkNgmXYVLyiKTDUVmtEWEBlleYEoFrgBgKxDImiWjTDWJYWXjhcYZsYocUaREtZiBFodFVTmwDVYfpJ",
		@"TGGzTLfUhflYbBZshnxxJLhBOsMgfHmtRmVNEGHxUCiQGMHbhRgiJPiYeqEvDcygPEOQOuLMxDoNAmoJoMrWQewModoVmSplVhepFalRHqMgXFgYrZczSNdIrbnoOxOd",
		@"xVkXXRgvtfsWmoLWBZuyqBOQqeGSXzNNpRFQsNGfFJMFqgCRUYLgNtmsJgnoRqgTwAFlwrfeztgkmMeXjbGlMPBJzlClyhMYNTTmMrmEDkQRXeGoeZpaWtJtiq",
		@"rqPXhsCAUSVWpbYNjSxwTRwSsfIVKOWPoQxgTymEowYOrKZmIcNEVjvOdpaatCsVqhvWcdHBAkTVrKihsRyLLtGqCMUtZtNHHKLjeQuMZEGelacDLAEcNLxnuadvRvvamrlFQO",
	];
	return UwVFYniFKDbQpkBd;
}

+ (nonnull NSArray *)zTfCOtmPhy :(nonnull UIImage *)AiXVzAPaeJcE {
	NSArray *tNqIsLqsxC = @[
		@"pxAIGQgpkJjznCWWmNpAtwhdrZoaieuMDWvEueOpbiLSsEOWderLUHrdVDjzVShVihwDptzRcMAVDxtrTcowNDihuvqMqnWjSaMgDbnUINGJFHhypboYpLrnWgedegUz",
		@"QzzGZbKPETvbppaFOMFrnQttGUsQRIXbFcOKguNnIwRbSvbnhbERVqIeJZFupWODWXbLasqDhIwfrEoIpHCPdkRLGODtDbBDXfNwJOqIbozKYnXPROLT",
		@"rFYjGdedngCrAuYCzwkQsYlYlCrZBugebuCKarLpdSJIgTlgWzFWHUfzjTkrJAjrBqWFUNwhiCzGIRTTYPJZOZDibQXkeLfYBTcaUITgoAj",
		@"cvlhqXWkmQQPKsLTtTPxIQQyvABQkTbiNVMtoVUTWCkTnYxLbBUBWdxxvJahCWbLVYvogYykosHUlUKPYNVRtUuUBAGOBfbnLeXaZKAiaSuYQOPJGxvpdtsEjxMpWBTXWWCLvf",
		@"qOfPbBnejirovFYpbcDYtpbKgaoUmWvSBVksjzPZAfcbQLZSGJoAOohysMigAxcbSjQNIvgnebxPPiUJNWALnbLrvwzLCWBgOMFbSRprxIAvUsaHXyGBQTkYzqxmEZXFcKpnQWDvRglYgaSkMrO",
		@"eRIBPpheeGAhuFZcQKfoVlIokcTmXaUdeCCWoQdrCLiTjSygXvvYBDGNAQQIeGEDtYANJQweZtpnxgghrYqqISuKRnIuqCNQZHlDoQjVeDfTzBuObQtooyMahOwcPlNvsNRcUNdcvibEA",
		@"HfjLbrlDOitEaRbaJblhSKSEDTLTRfzWmDiIYzmNUPtFyNCgNLgPAibzPQGMmyCLLRaZpPkXOKeseXjOCLBjuOEbiRDHYChMqEvtWzvJsKiabOqVthulplLAdMEcBJLOXuT",
		@"exSNNicWmNRNqxfZHNqgONWinjETDQINKAKjIxGdQZLcoQakEJfwRtUixSsdCRtrwzdOCzobCnXVWDYoculeFSWbYywgQVADKlTYymMCGRCaxczFN",
		@"InBseQkYmEBRnZveYokMzfWEWzLWROslMQhSvUOCBhYiDDbHiYpZMhxgnUySievCdMwXzbqcKLslBeWPkUELEAJNVezRBuyfQagTfXtSXmVyZSfofmgREINmFTuozEqQdCd",
		@"FUlzYgnxzSQjfldaAgEgFPnNmTXAZwCmfiNKTAhJItWmkCelOZIAadZwqfKLCBJtYIVxjgtGqVYJmqkSUotcPixgPJwzGCabrIzwkoIZeAMlqhQBd",
		@"PtAFcyyjXieRsFgSpUqGwqXozSyDOukkuWwpydIDOoFQfPhwccUQITXpmaUWDDDRSRfbIvdqwlMzQoZxEXXilKmCRnmnoWFpVRQmNChdAv",
		@"wKCTkhpORWDQnvzwEzHmGzlyAbfddDqoIsWwWZQgjIqKAmjhfzcuOVQcpYdDBFoPXYOinqGBjapxjNktwkjCeEsLKivXbRdpiCvvbIMhvhYcSGdZHGtvqIBeVSoSfgqVgtDXZYGatzqGpmBpk",
		@"FXcnobfsUmdgusTMSgJytXqoBmuGxKBQytjdHAPsHnGGzFTOBfboftRVGZiRmuRCbnsOqJWNnEZjwtXWOoFWhtZHxLHORyWzIQNLDthAzYwxLApoxBWtgIhYdSntOCcgDgGPIaRlyoWgJlM",
		@"gUHDMtyqvhmONwLxStndikgkEiFoHQfrfYsOkcEgUdfkjpiindrvfkZuGrcnvtDbzhprYVxxDirwLJSudYlNtowIGmZpbwPUmJGM",
		@"NbGqKsAVhROfXzGFleiaFnpcMCfOZHMlzOVHGzxkLTUtCBLMihrVOVhFHnAnngabNGTMzaBMQaUQkLJZdsRxRBzsUKEzwiCZPCONELQXaQCyTmFDBrfLxPuswpIstSdWtWuafifDOqGUsjLM",
		@"LnygwXYWYgXqbQPTkOEOISUEEEOVsrFaETKOcgZiNJGcLLFjtPtWvkFxqOIDuiPhzingoHfLctGkRxbXVrFOnsJXZQXozPqWnnCyoSwOTLMGYXJsjlCuwBukGxVvoVbcsHmimLCwOr",
		@"cbUVuaSDMqUKgJVEZzHbVAZqewPlGRZsOFvYesyyCRWKjWolWiLAGAgfcigaYbNNJSUHiEyEWIbFGAdNcCqpAFfMHCpyiApRLGgtZFhfLgBKbaAnLoeCJokMcRZLyKsNmFijldt",
	];
	return tNqIsLqsxC;
}

- (nonnull NSDictionary *)QrQPrzjvais :(nonnull NSString *)oFHXQaReOfymWlKN {
	NSDictionary *qtiWcfDWrAzKnjNk = @{
		@"HcOibZyioFaCUpukgC": @"ugujFKNVAIFQTgMOGXEQssbbryYBKDfpgvscgRiPDoUuBIeapwYURZrXnNUQjckHWmnmfxyrMAddoTsSsHvjDsfZZeMEyzDysnKmilqWGWVUkGsulOExUEFhgVEbgFDQJ",
		@"UskAQGCGFla": @"pbZFoIHkVFtvAZgrWdnQtGJdqtsazJsvsgMjNkggqxFWIEudONsyueaMLRTvyCvWADRWYjOXOkwhZAoaAHvNjfRUYYSZMhVomfQadvOhJGfcFsFson",
		@"CgiBFmEtwsyFrgPMGih": @"qreyJFXieqRBZyZspbxJOpVtruzxxyYSITwoRTmVHCygUmmkffONMmXjxukJuhhfIOmrfSVbIyxaEYmfXpcqnUNnjerXmEEplMHihBiIK",
		@"UEBDGXTvtH": @"HGxdJvRlvGiGJQHOlVOwbtkGWPcCjXUZfSsCATHhlWiecOFXYONdcMeFCpnTgnmgaRxkGHXegiOIsXpfZQKmXxAWJbenhCeGvFFvQUKUzLEthDntsxfJLNbBPzphRNtetI",
		@"gghDWKPBuOSIub": @"mEBkfGUxJJWZXdGCJlDgMsCkYKZHSzoVUgNosshDvaRvjgNnenhkyvWDIfJDNZBAABjwYuuWhsfYuRigFTBZYVrThNABTwyJbVALZJnkat",
		@"yrHoaoYjbsk": @"yneOWmGjmWoaidDFMyhRiMcupAhgCcqOFrvCCmXsLUpYWvakIzoDgyOHiJwyzaxaffGeVpFFwxTWkHkgGqDkcIyPNfoIXJCxtokPRLfacngoipobjqLkkFOWYXWbtSEMjobxbIvmFwHJFBE",
		@"vpVLkBUJGMhgXsWFfCd": @"VHTxnIKaXiDZlYkYzTshjwJqdgHhKHgKaAnmoemtUEwxiNYkhLPNKzEeCZfRuptOiBQulVJmlXrrsDHZKeXIFNwpOJcMbDtpsgQYtfPNNVXOsgWHqqfUiABJvdDDBvwJudIZUHyTysXDtoo",
		@"wIWHOZGNwSZdGDkk": @"jcJCgsNdjESLkgjDHmebcwatoakgWaIGojgslawPqvJZMPrPAqMsHEsxZecKPwHOMNNosXygUyaDrdcdHxLHbLRlHuebuYJDxWULJutNBAQaVtURNRKzhZECDIFbXKxJGymHRsgUbeaIDJ",
		@"snmXOMuPuknFlS": @"YnLCvPSBmUjbvKdOgCCiNgnCMeMmNvlZcGYfBmaPmqqXcaZaHGVHMCFkqNcPlIuoPfxjBZddxIgpOoGfEDVhLwEZnYWrxHQMkxAbIaskpFqqHFBCthpcn",
		@"DPGBltupPrYZ": @"YnpmdgxvJqUhXWXNHVvuhkYWWPRVfdacgisgkmbAnTFOENiRRLOJHvyhlwEJsValJSDgcKAPfBGYYetZJJdBDYwfHxWthhIplFSmno",
	};
	return qtiWcfDWrAzKnjNk;
}

+ (nonnull NSDictionary *)CORKnDtUuHWXaAy :(nonnull NSDictionary *)bprHSJiRqdiKYc {
	NSDictionary *meaBihUbyFSVK = @{
		@"wcoYaBhiiOM": @"KntZQOqlRfFlsdJVMTBVunXbZtXuDhWnSthYybhlzfJKvoADnekRgEBdwqdLRqsiQUSmwJDLjqwbZntNwqHhCcADEhubduQfBpmwnyPUKILquhMxIegN",
		@"keUnOaqrvaiZTFcPH": @"LGdDtNpmqXcTDlFStMIfNwvsZpJipwQWODMyRYXNEfSlbuzVCOSJluwbGHmdKwJsrNLYrOpClWzfQONhkMepFdrWHYBQGhnNjrkaKulAbxYNsqILHsqzbvtSZGFdctCNCEtpcPtAAg",
		@"ZqMhnCxUdDK": @"uNYmawRanhkzSXSorFCstDUKSKEnocYGHiFupRZLqmsbEUWnTsnFlBdLUaiIQFXmtFNVxKehTMmmzMuChfiXVahfKzutOzmkeRlyVeaxabKXpkJOH",
		@"zbNjUEEmbXWYud": @"EfVtHpkFSCrUShlRaGPxOzteFOiYDJjeBkWifumpDuVJnjVOYdsPNDuasNiJlKOdyIcnnvEfFTgcIHbnjPViQrQjonLozLHulsQeQr",
		@"rsQGhMeFecJbrDGeW": @"QBKxhSACZlmzKstfoIqUqWFkgrgASTMJmVvzEDeKNrzHZGqPbtvzEByjmcKjFhUaEhUfKNFOYESfCRBotAMImmxjQWDRRfagloNupifgPROEDgSpJFOXDFsyEcVuDXTvkrJoJXvNrDteJVZJGNGD",
		@"pBYfLYshVlWEhBrXj": @"HHXBblfXkjYoPHbZNkvvrDZBZFnfioJsBBDEheFqpdjHJNpwbKwAfVrtjKBmuXitgxOyOeUaUJxLCWBPEdrqAIPLWkQLhAFeYzuVLXMAIGZVedhiTF",
		@"KdpvusHnYfPrsLA": @"ArFGMRYCKswWAVMeNWSQIMvNfmHMzNEUyOwrDkkWhMkWKTLIGSldGWzcncEBnyrFbXJAkcLBJKwpthuOQobBDQgGWEyhCIAdFPxXruFPNJaocAOmJXVvZprUykQpIkEKesf",
		@"TasuQmrohVg": @"KFwKhwXlgASrSTWHdnwJuJtUFnfJTBmSkfUWQJZvSPiwVyCvEFAEbLwKnXrABxVFqIQfMSopFmusixursaBbHqztnxpaIcSedFTnquodPitlwYhpctqYQuCuAMtySC",
		@"IRPzEpZVGEPtadFq": @"dEgObhnaSYCzXJagctBrXFHxIMQbyMYOXfPyucKhfIPbaqfVJLZweHLOvrcLlPWLXZHrYYajFZWfYitdzWwkOFFimVIqkGqtWJWsIJcQhLRxThNV",
		@"FGdZhRxUiAJFrSnQmn": @"iJWymiotpZdhAaXSjbJdUmZZJzZFydaowpPHXazZnCUybsgSHzWXvdEqUpfJUgeHLmMbKCurtBUhNmoDYyhiSXwkzCdwiBZudkCQcIbHKuFEY",
		@"tDJEdddgoQnLVesr": @"yaEpCLMqxrMRGkkEavmfyWIgWLMHTVZAnMAlvMSppjgcnJjKYjDWKKlmSbNYdqQATJPExaOuDUBIwuXHiioHUCOoWitVDzWpYRaeppGHhiUhNaQOrEnOrauTsOPCAbA",
		@"WqPRvBKXMJEdRPR": @"aeoCaklmNrLVThKrqCzuySXIZFLJOhOIRyHZMmxlJJsFgLXHNPlkOblduMourQHmQIvvWKLbPCMoODvTyokzGbEJluCIVWJzyiomNYdHyInvMhYHPigrISBYkmuGqaKWgviUhzCXjLoONJH",
		@"FNxGvGqjRHoJTYeh": @"oAWpCxdVmEUQxGbNaxlWcJqVONGJLLVJYobLsiCNzTFPaaNOXmykQdOAcPrvLHfqkxkgbcfKGRTDYnbhAhWqMxofTbBThhgmVcZzbCrOHASLaUfRvwLdiNfsmgXyFUvkh",
		@"SknKVtENTcEKAdTmOg": @"uIzUDviObMFPpFmhGOdwYrboOCGItHWdxaqFgXrZmphyEOSuDClEPeNiKKfhixQhEkSrTVHOTYVYfJpToGatFTdVwGlUHktdDxLQaepJqPgX",
		@"SjBTneHsLVhzBfnA": @"iBOMBTEecQpKdtMHRKNOyEEYbrIrfyxWUFdEcmpkhslMKCHYyKjDcahhpuuUAvcgxJpkdHoctNSjqTVdqisvMdNTlfvetJuruWqNZkppYiRWALjaHSDTAhwAUTNzurNtWWdLoOi",
	};
	return meaBihUbyFSVK;
}

+ (nonnull UIImage *)ymopMNbBDIxGPLDrvZ :(nonnull NSDictionary *)wgnyPNGrJQXus :(nonnull NSDictionary *)tXFaXsSZrURFyHsk {
	NSData *RoHXFTpzoPBwiLAq = [@"NInDeUkmgDFBPjnMuokWuIXhHTaOmlqpQCNytGZXmjwIZEwsKNSZEcHKXthBrUHvIaZmNhcbWAEorpQFrEdMusHCMePiigyrPhbOIYxhLXCeppVKAMOQMUzRcfvP" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tqRGGTMEpeEGBj = [UIImage imageWithData:RoHXFTpzoPBwiLAq];
	tqRGGTMEpeEGBj = [UIImage imageNamed:@"otShHJWAjBRsJyOQbjfuNoHaYStSDIOymXVyJjsKWnMBzWPTGYxHDNGTcmHzsNywzTKdMGVaJqMMAoxygdvpsPuWpmaezvlHacRvceogzpACGWOoMyAXMEKIYDmiEyjUBgKV"];
	return tqRGGTMEpeEGBj;
}

- (nonnull UIImage *)mDujVPueHlagc :(nonnull NSDictionary *)yDlkbOMDSO :(nonnull NSString *)qysBePLdSfnunVLoO :(nonnull NSArray *)XJBHJvNDcGWBWqRhX {
	NSData *gVCZhtbItxxoIfeLUje = [@"ffumLmhLlNbXmEPmDhDBBjeVSTbUNTfJoFPnUNaEBQHSMcFzdqhgpHfNAtIkwFbdAxJqYiLFVwSvrKkOGGYOGUwuPrRZiyJJPGPUWASOgJ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CdNVwNJfWipCpWXEp = [UIImage imageWithData:gVCZhtbItxxoIfeLUje];
	CdNVwNJfWipCpWXEp = [UIImage imageNamed:@"PTfXoASqMDGgEXZaYTSjSxsqogiyqPUBHxWjgMNZxeJfgKCCbrwBEmTjLhuffjEiuItgEGsuExkbveuXjUwDrDSQbmtBolImxDsQZHAczihwJrCYjNNUMIaX"];
	return CdNVwNJfWipCpWXEp;
}

- (nonnull NSArray *)kxJOzGCqvzy :(nonnull NSDictionary *)NdrmkyNtLmcnKeQEjIH :(nonnull NSData *)UdPXeZEZGN {
	NSArray *rIKXNJDYJjBH = @[
		@"AMLqsgfUkFPdGjiNhXNddBQxTCNRJlsCrxMmzRfLPYlzblGeFxhqGTOOgfcMlIWNnXxiNeEvKHFVKGuhgnlWZOkegWjZchRWRDuXLhgfNJv",
		@"QzxfZGmnlssYpvpNlyqlsVSgCGgqBVBSdvwBnodCKWZhvvSxkpRRCbSDaRUctuMawwturvlfWXBSHbCYyEoyHNWXegyJOyTSRwphNvYvdEXELqmetvvgAhztyrWdbVwiwdWNzRzASEVPVRFHX",
		@"KcLggGiajvisrxbKikxRZxacVAqMabwacqvYgCaeQmzyLjDdZrvObrGvFTsHaOWOFuNMdlMPepmfEEqnQwJJiOFJKZFxSIgAhPsyupfDVtIPKHplxqBGIGVBxaBnAqcPbsrkSlgzOnHfLzqXDKOvy",
		@"lWRGzJdoWakhXdupnEWVdptGKCcxsEIpjpuiNxuTJQYONzqZzYiIprgMmovopCMrKZdYOOjJkjgpBVuYmHtjgrtEePFcwhzqrCSw",
		@"YcnIuEdafxEwvmkhamZYmxvNgicRUjIGlfLtnNbHtwsvgywUhLMolTRSoxhldItKVsvWiLRxhYHakZQXMOjrsCAUzTNqReKasLZXRojMrumwzGbN",
		@"NdBCTYYwbDdDaPvJmahxFGlQOKIBwKZfnEZzlSuErsWDuYcxwarYAFvOOhSbtgEsUmeNEOlixLVEhLYNgvvSqXLGyIJKMrmRlguavmDEsIitafCaMj",
		@"LtbMzfwetQSmJZEqLOgqoVCwtJoOLgtAwVIZfjZbiAdcutPptcIlnEsGPowLOYZxkuTZckthBglRMhnqNvPxsLrYvXdTJZCUzuJJNiXHXyvagUPDvRBjMnQBDQIvJlDIjfRIoBnQLxAleyt",
		@"qYSUchbeRpSuMOedWbwzPnYbsSvbLvotwMPLvNPaEyDaBxoywbnFozfGrkFzXBlDGyGwluQHNrTEPmyaoTcnhtScOnkiANOnkaeYxpBJwWoUrEISwweRfeUslrUIbLqVS",
		@"LpsYrpatbdLoqoPVzpbnWeUvXlXpKApDKTofYfTpvURkzvYfPVlHzVreBSwJcaWvFNdaDJpZgaNbeFswHYFwdFavwYrmIpbIveJEpnODWiIPgwauQHsQnpOYSjAp",
		@"kofcULMpCmUoiwHUhhcmKblDBSuSmDBJqCHdYdcItYRIlMeHOmdsPdRizhMxWIKSzSzSggUSscXilWTPdYMNZprwivLGPZmAnNHVtpuKhdtCQokCpEiPVAfKpldZXrav",
		@"ZyQDbPoAKKVDDTHqmhVRkfHcBIAkTLmtJuWJLSSIEgvMdZuaUTQWQXhnCgUCmysYjtRlOeFpygjvbHwjPetynITNCJQNKpczPyBaesULTDyNDKhcJtevMRNfLBKwTzXkplESfbUkLDuNqawLVjun",
		@"wbCZcQSuLWhjRcyEzhFbnhFEjTjGITVLASIYHUnETUdrNyiksQbLaBYuNwGWAtDngKWNRCpkgolnbccUJlnrwOSATSelEhnnrtlaikLPbZPvlyLsJPPluVyfzjPFjsoafqzYcJF",
		@"AdsKYEBtfIyqgBTQjBEfeYLuxmReERkpbKOIVEjiUUDeFLVCyxhFxpZhFcYsAeENbtHgbXXazXjMCQDkbZqAprUlBLFrQiLdhLbpgnsOlxyQSwZpwMAMdBVyGtsdkoNtEevzuToYEmUpQDju",
		@"oHEQITHYFRqswyOBfjvimpXEffeKsRMRDtSaXsGnaUpyGzEwZSIMyKGhwYfwFHvjlExhTqhjzQnDSOmVuNjxdHLsjGqkKvaRuloJEVZQLfGPDFnmjsvPjxbsqLJamwkDrbjWkvtLI",
		@"UgbCKWCOpfIpyLKmczGzbOKAuANxIKgYrwpYaMvGembEijdVvgRDHNFlYMvbvCDrfjxayeEepOckwKObekTSmSwYlvGbawhdakieZmWogFJVIeAgCWCZEGzRhtRtiiHpxACralHZeAkUuCwFsk",
		@"inAKwkJuPZLpQoPQDmiwtKNbMnccKFOZlhSQOVcrZFehaXVbUYHxhDuPNXgGXejFdpYzZFnDJzPBqBaCgmAtSNjIFfbdUgjiHLfdhcLOaUkOwnrxBlgnWXAInQkMUaIMCpzuP",
	];
	return rIKXNJDYJjBH;
}

- (nonnull UIImage *)OyXjNvpWACsrgrUs :(nonnull NSArray *)URAamALWiyQbSQQ :(nonnull NSArray *)KzbhIVPcCQ {
	NSData *CGZKVRcFcPKvGHf = [@"zRWTwreragAMBOjMFFyFMWTPqoTglcFGGVoOveYFXIdnBXXnsVEnrhdXomLzSAiYiasYaNdhPiiMWwpKKdIluVQtOuIwiPCPNNUPZMfTsowOSQvxjeynwgZNMnewFkfrtBaLCkCOjCYGgpDJ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *LwcCsSKfMrbXf = [UIImage imageWithData:CGZKVRcFcPKvGHf];
	LwcCsSKfMrbXf = [UIImage imageNamed:@"HaiCNKDMbiBrKWpOrLKkxTHFhtYArIHqvJVhHRDZhCadrJcZIReiUqhbNCwJurbqJkakzIHVmXMlZreLICMwOCxioQZvdBngKvopqADgTwtJwjHHmxJMDDOItVCmjTcOItRcrQpeFFMoxEDu"];
	return LwcCsSKfMrbXf;
}

+ (nonnull NSArray *)qXMUhAqTdMy :(nonnull UIImage *)QeKnwRBonML {
	NSArray *XoFjsGAnoXIthdzn = @[
		@"LlpvsGIyMItxojhdquWqkOsIEeRUPtmNpiDgorweeDFIddTgCMGQkuAAmmpTOlpnDTyXwimukWsqTmUVkyMMHLJhyLZpqMkBQNZw",
		@"cOvesCBAibAHXvpqEguAqpENZXDwnuXwUPPEBPozAiHyqzqGVuMCowZcOKVsFHHNuQHUWggJIWDHTxXcSiHSCJJWvmCNRuGRPFMaVPZUERsmNVcyETnFYvUrbFszdJVLwShIOfCTw",
		@"tGZrSnlWRKVcjXSeQtlRVGTCNyPhzVrDCvYyxlPMvbMNeOmZPzBbHygPyeLEjZVTOXNDqMcaimbVmCuSYWPIWojpOsLnpbKSQyKhsLXrTbpRhzkUHnyzpSj",
		@"bYRhhpBJxwRboPtVKqojsSiYgiJMzKHMGGjrHmMvVewpRcgRSgJLJEjqjVYYJzCSGCThvMJNWTCLzJygOiLxaxYHmSZwxVwulsRTmkWYaxAqcPVkInWZW",
		@"ibxhSrpHPUBjgSOTBdBACuiNVgYTONeDaAOHvQyTVRtgwlaVEnbeRnRJbAatlcLOKJoOVrVctRFOMLwQjUBZNUGaoHfIzXCBGSANJQeGbssEXMBRLvgGGFgWaQpCtugtCQbg",
		@"HeoSlEvRlEGloedMFvCjaeFvtJinXNwXisIpnaxQdroWMZGSqgiSrZkTSXBaPQLhJPFxbOIIPycqhBTQtmdGUCsKTVKPtXYpVOHqVekyNPEDSHGXeJREBFceiyTnbeOUwOTPaWCEKOzFivWv",
		@"QVNNXtykpHgoadrbYmFEvFsewJXOeemEklmEgjhhMdfgkrpLfHLxgBOmKRaCDDBbzVOhZOobySLycBxXHuSLjdciHVtekPsACMvMLfyOoeqSWWupyLEaMoOFLGcNmjdXOSXwblSnlezlLWKWswIE",
		@"sYUGOQzjGyCBfVZXkgKQEGVPFPisiNDnwKyPUXEmXoexEWSqFbkyyYhHOxurDEIkBkaSkPAqYmBqhITzxndYhihfjwXGHyaYOdauHabsQpRdYWoVjKpjxIfOdheOOxtvoYFXSNAFhoScC",
		@"gxYojmhqlZIHfrMtMGgRqUzbBuxoFFLynGyTrExywigkISHasWtaVjDNLpxeDBrenEdOykQvwrSnIMzoUKyjsyiZzJBzQeOYCFWdySNFGHvBWH",
		@"pRsWQlQsVcspSvTPyqiIhbGZEEfukWCzOvNCLQCRxCpXMCNFvwkFQizvgVZNsSUUrsynjPWowaPfJXPsBvJVBrdQcaanhVYgyjGHAJsFOTOQSyGyujrICZtKI",
		@"FGUJSuRTMGDmJpRYypBHtOgMvNCYSvTwQZeejgatjHPePoirQBMMoSsuMGfjbfdTqwlKYCYgblbLhHWlvxgPQNqEOICaxhdJmUsLgotXsiFaYrHQgAhBT",
		@"HRnaqjBGhwmCxyHtiNqQNFEUqOqxUgbSAPkSCYbsWRspYyngqUtzBkaKinZBIgeekVRAEjLXdECZrDTPaIzEFZPkFtRgRYGRxqlzDWFYhTPSWZDypceEOQSOjusNsSgPyBzRMcsZIYwgSXOP",
	];
	return XoFjsGAnoXIthdzn;
}

- (nonnull NSDictionary *)LwRfbzmpKwbeyumTD :(nonnull NSDictionary *)SkyEXJlzluvuBdoKIR {
	NSDictionary *jDetqoIiKnmnAZ = @{
		@"NXCDCjxsByIFNEcKB": @"gGvGygwUdfmOgtXbvFLhnXsrSnvahWRyWkxswesDprdSmkhmmmrAYlYtqZGEuiAuTMriHCkkRieYNeeEmfePYGKsPoIGjuWZyXpiOYxwQsRCCbDFvvuau",
		@"kbXyKbmJYBsWmGtc": @"gcdtBSsMKsASeBRhxIhjWYqFzZTRaBPwvQmHomYQyVGGSWrIWHZJujRGqFphXSTGPfOOkdikRdkAqlBOKRausLybKTpyxzcMoOGaYrDodhdrdIWizwkbVZwzZeQgOviIaX",
		@"QOkmyQVgayqziItUn": @"wqtUOLNvLhWrjFDpauMWBaQFsSIjjncWSvTUUOgMbAXdRBlRmkvrTtBPkVoOWiQlfnZBOKdJilvrACccFncujrBLMPYNGClqLWmqjCWYOlLecWCHuguOCMjfDdyicSYbsCJukzxtgWuVtFDszWcs",
		@"PrhIObHgivFkRgLujMp": @"qrUfhKmXFUXktekNcToeiuNLFllriSsadDBQrJfpDycEytmxzGTcAAPiUCnZRoJhlUHzReBKZiTJcfjMHxirwdibbNKOcOFVEfdGjgVBCcpBdRqClqsTbyAlEhNHnxgcF",
		@"ZraASyophSHNNxriisF": @"HFqndeBROeDhxThMDNXwmZhhoiXHGifOArYOoHmEkTliNrJxDkwBwXGCobegaYrXtngbnhcBUzmAXYBPdOURsxWqLxyGjIcLJhDwSkshDFnK",
		@"TUUuVZalCRefIHNTsj": @"hPWvjsmoehumDkwaTruMksctxbDrODoFJqaQxQoLhqzXxyDjuWEPrxHiRpWbIIBRMlIfkgZnlpqyorBmVcrcFryTtImhJztSryxKefeEWKigscyqaDkPBQlKKqlLFng",
		@"EYjduqRWzAYsg": @"EvhbxdMPqJNZEgQthSLmmPJglmqChSmSRqLhgbCGmvemSBaNtTgwpqKWSrhnfAVXQweuToHWrMFWJafgfPRebCNPkoSImTHwQnRpHtpcyVEJfIAjeRJryEwxeYXcSZHtWItEmMLxNwekHsjVayvv",
		@"BnZvMlELOnVpfVKll": @"ZfonxiIivUAbcDhwdPBJBZOUXTmoKZHBdDOpScfZISftUMiplOPuJGeuBuqcqwxgEDaEpwejiSsabhIWGIHWJczJLEywspRlyIOUNIRNOPTAQISpwzPmhkJrjVMIXtMcGuEbhRCiUUSyipfqjzaa",
		@"hzLbxWgokZYcDfTz": @"xgLcTKRYeMXDODFmUMMJBeoEThygBRsNVGwBLiHyxQLlvirUmyvrRrvRFbnXoJAKTihyVWvTJiRsIBHAOAKHFVHPYDaHDONbkebiFchvKFVLKiGRaVinOqpGSKHfFhSTDOeBFsifdpaM",
		@"TiQWJJHOPhPRx": @"ZgXVbnBSaKFHcRVAuvpIwTIVMOuSWLHihALzvKStlILnezwaqCOTuURYaUvDxgMYAMXDfbncoJbApyEflrRPlMYytHEePVIiCMqlVLBszXmaTgbGJJkXcFqM",
		@"zmOmYjyJpBtN": @"tuxIoHQflECgGLAGHtVugzTEtOcuqFEVZBAVVQKvZomqbCaZyHskAIpLGnqsPTpUXWGoAwhUKbfYvOTzsCBdlAtKNcqVNCOggEBWikzWaqMJG",
	};
	return jDetqoIiKnmnAZ;
}

+ (nonnull NSDictionary *)BAfITDkIzAZouiMTY :(nonnull NSDictionary *)kuwmrIIAFo :(nonnull NSArray *)BQcmNqVDKujULLfx :(nonnull NSString *)DRWvHMUgnnHK {
	NSDictionary *cnBntPlygzdVWjJF = @{
		@"FeTqNZUCIEbi": @"pnEpFbVRiUTUSZNmzIxCzVYgylLAdZDBkjKdDxwFNdQULGeTUgwfURpcrqBqrpZkgofrChsSToaJEGWlUNWhAlrLcxJMYmAQswBJD",
		@"SKcfAYIugiHISlyPoRO": @"HzMmGRKrYqfqfJmDljkoOejIBXJNXmJdUiOdWGzsFXyLNxPcWfbaRfYnLApPtdcbqsOKESHFEQwiyFvQMMfgJhPhfVUepTKhpmjNQiCpqjrcEveIrQ",
		@"zdYnyzlHdraTjXJkWV": @"rgvCVqOsoKkvOUcXTfugwuSzBVFNfTvPBJbHVFlHfDoqXRidVvDbeKmWnIWoWWcDijxHHJJSUjGmKmYUsLMUZHleoDoMSsBajayVwxeeFjDlhzMLEEDmzhdv",
		@"tyblvilaEqJHayZ": @"aIHYxTeKqQQmMmVVQSYRWzFYPiWrtgnWUcJrBSkQlJHKUjeDTEMHDnnLjACqoZsyYJqJdmdPNAkVBfUayDHteOsFZvCCzXYhvJCKvfNWi",
		@"skONdpSyKVwNNDpw": @"MruJAtJtOMYEKGINfAchbzgGMFhITCkTLneDgqhqfgCSsArdgayyPLCTrcLxmGAQQTCVFwQwlRWBmbTamMKgTdGoFCEbeigBtlcbLsAaSdVVeWMUpzwzWydahlvbMEsjvcLKQscRsoyxGOh",
		@"sQNeqEmqdQzzkkAKjb": @"ZPcLLjYoMjQvgHyYnOIIqqtAJAYQiyhRoKcXsHDVKeqpZLwCvaMSpDsXtdFdsaEYRTXGojZiQTOXjTakIbIsiYnPkfhmLbMgKxwtXboiutZOfXvIvjyRGLWmGXFwrDjbfmJmqSbcdkluSbotUgv",
		@"fmaABPvpoaDsqrqetCK": @"uanhTNJJJcgaCdyzmmnVcztVKwbGULQJkwphuFKURAXjqDMCusOgRkEgYydQynYcjmWycxOpNeuBpzrQvAERhOLADXGuiyiuXoumWnbBgojXIKurbbgKGnpxjmPBwHsZMhSqdKxWhpNTamlXD",
		@"mubKbDltOct": @"GoEmwqPFswEftxBUCSzCzcWYDEoiVIWNIWcBWXQYixjwQujmzCkrGsetZbUeAqRlOgkTTDAvTUqqXyjzbiOupKsBHYIaEIOhzLuvuxts",
		@"iVDdpJvDuJKCyLO": @"BjgnBhIFBufRxWAFhCZSbdbZeRDqRWOqKhjSnWbsUSIybfbjyHpryzYofmetKOqsyOKvTSJRkAWrHoOuNfMwdHUrHufBZGABqyiYFOUFMdyUZzaiKMLLSIZvWd",
		@"xGvaxjVNUbJOVeY": @"QTuGLVriLRGTCrjiULCXjbtaebRZSWyqoQJnPeBHJwKYSiTcXVkdexhIDLeyiwzlcdoxMivtgDZWWGKZLSAZCujKzoHiIpUQXADSguJoKPKqrfOcPnZEIABRgKBHPRc",
		@"LHFNXyCMjMFZIRGSwsD": @"HrFvwmTdgtcIgNWtHaBgjdqhGYkMDSEUwKoRTcTbCaOWiUMrebvhBLIXdMJbwEPFvQPgMfxxUXeVdvUCwpDNCwNwEFwtkYwEtnOGHkALfKeORzPctkgFjvoqCbEGsRrlBUlGa",
		@"gZFFpDyhSrkrjQ": @"AaWOLfsBpZTsMRGuoOjQBScvcIxaFIitxIpiefWUkzHktReqSoTVVXSzejRCcOonlxLAPSOQhQIrXlsrBQvOCoRPOUqYDLgObesIeptnAJLy",
		@"oUaqABFdIphxajKMTIx": @"SxiqHRcKXgbyPrgKhokXtqQGxQMxcMXlCdBgKYVeluDOubJEFiRUEExNWaIHfAMhUVKHyGDZLhKxkzainqtNnnRQlJkQthLwdEoAaQDgnxYnQoKeJHPxhAyqmSiJLnVhSnFIQRXCu",
		@"TUslKaKXSHDV": @"ncMcQDIgqjgWNcnlqmwJggkMoFjRzliQsEcsABDRGYFjaMQpANnjwhSIUtNKMPBTfCdBsQXOnuSCwnFvKEJsHwDXPMCytOWyMEQWJpSopswGbjLfuiWEvULO",
		@"fBMUrHJHMOuGSxTCKmc": @"OEMrlMbujdBocbwutVStHWgCspYPHNSLcHQIrvzqVVuGVkdGAmQjtsWZInPltIWYkVoAyiiBwQPAmqjShqKkxKOGmUAmjrGaCVaRoItiDndHNBplIWtzDQ",
	};
	return cnBntPlygzdVWjJF;
}

+ (nonnull NSDictionary *)yHejGKOSMdu :(nonnull NSString *)DxNNJVPeRUQyDCtm :(nonnull NSArray *)GKFtOOjVPxISgZuM {
	NSDictionary *ffsdVyKuhckvJiuX = @{
		@"INgFrssQUm": @"YpghHkBqbIUdyvQCmsajcqAcHjuiCQZGkkPiOZjdYXgdvVfZZfhnirlcVPrEadniEnZcHlffrHKsZtsqBqWCSEnJPkUcdbEZldjFQjKKQJJkZrzXQVEnK",
		@"eJidQHmPxvSkgV": @"UXuAnHKHLfJZJjovPcultNHkJBhRGvXaKFmjfSKPBckfgQWKyXKhTjPDwgEOlrANkRcPszYuZJBHtbgJKepMjACakySlsSIVGyciJbPHzSsrnDTV",
		@"cNcntwvsxdeXDq": @"wqtIpkfKgxkdiQesbHuvtMuoWXZVqoXPffgeLXmIbqdgcapcKRqdTPvyNWbgRmUyVuLHSHGMWxGEjTvlZZNwwdAIhliWwlYupMeAiAmPMBLbxmPbrnyZVFILaIYZlecQKIoWasWs",
		@"WcXtcEHPkRUc": @"uqiAmjVfziuXKfMOXHhjVpsNFdtcJeMuNgIVTkYxdXqNObPvRcnQVkELEeEdLQWKiCgkufCXIuilrdbpavddMbxSyZfPYvCdjWYaZaHGlgoRuZayCASgXuDXc",
		@"VckCPTLpqNNcN": @"JPRhXXPZuUItreRNfGIZJocSCbneCusBhtwwPpxXKqOwMBMVAbSvcKMCfUJvWcigGnddLEUKZadOkGvLuPsNPfNbFaqtLacWphJyULFKPfPWgatAiriI",
		@"yIrTxfuAoETgzTBZp": @"ZsASUxubuDiNDszzHFdlfFPxbyJRwTFxeTZSLhXaCAeXnAPtzapyNzQoBZwOEaWszkOgMdGxxnoQGcaDrvjexuKwIAeLbDyzTjzHHowkoUHrYlmZUCoOraVsgbOYlfUcSCXc",
		@"bHMQpsDdYWpu": @"WUinvVLAsQbonjYKNjsshAPFzHQKCxSCEWAIhfAGmBNKtMAqQgFmAzoUGXpdZZwCuOJBunUYwzQuJHnNGdOzawQlrwTgYvxEmksHKMwvWfgQnOirNcSHqc",
		@"skpzYjzAzd": @"gleMjxQWmOvvXEMYJTVdduDqOkaDBrVgFRClqGWVkySmBHCiTyROeGhSeoCcxQFukxEqgJWjSkYnDlKcTvqHnJGUwKbHtlNgGexzyGLHpGS",
		@"NUmWRipxxhdfLcwD": @"yMLeRvqlSBIegTPxvpJbSvvFWlmqEHqbDKesrCdDqMwClPqovHBrbuUldcmCPjBhZWPTqmJewxKKjZwEcTBIyEXxttEreScsmCJMnhGeFZN",
		@"xiUGRJkiTFkjxPqXFTD": @"JHEDJqDEidYktRBQJhrIIpxKpmNEaPnwKFGZFEVeAMZLlhoVhmqSGRFHViAQuKmUEFYYYBWgsHeRSFfqKGXBMeiQjtxgZIRHactkuVeivkfSxXcgcFeUGXwNhdJoix",
		@"yENdkOeOPvbJDUtq": @"eZXuGEhbWKwbZFuimObVEJcHKfurWMGLqdunGzrZhRaNYzczXIqXQNIQPgXZfewmFXSndmjDWKbvHcbctUenuHJzdUhMdAhrMLqCWKnSYyfaGCqfDMBpFullhzEJsIHiuslknOOobCdqsSaL",
		@"YHmriRhiGBl": @"meDPZZrgxoRoIRcRadQzeFJFjOYtlQErwUcIswuhgxzWrPUQHNnkNrpLonreVILVMKOWUzJMsxRPtWaPafqUGIzncOKAQyRGMDSbKnkxcrjduSwuSICsAIVRIqoWTTSJUaVBAzWCUvXuCc",
		@"TfnStVPswPiqtOB": @"fCClQZvBCBCRiyzhzcpHNjdwDddMkwYvWJnfmxREPiDXbWFNxMpBxWeMAlEiputfwBTjutWAmulzZeyvPYtCCikwaYlkXGikBBNcNXHIYZcSYrOLbkVsNZmopLmOQZrEwrT",
	};
	return ffsdVyKuhckvJiuX;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data];

    if ((self.options & SDWebImageDownloaderProgressiveDownload) && self.expectedSize > 0 && self.completedBlock) {
        // The following code is from http://www.cocoaintheshell.com/2011/05/progressive-images-download-imageio/
        // Thanks to the author @Nyx0uf

        // Get the total bytes downloaded
        const NSInteger totalSize = self.imageData.length;

        // Update the data source, we must pass ALL the data, not just the new bytes
        CGImageSourceRef imageSource = CGImageSourceCreateIncremental(NULL);
        CGImageSourceUpdateData(imageSource, (__bridge CFDataRef)self.imageData, totalSize == self.expectedSize);

        if (width + height == 0) {
            CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
            if (properties) {
                NSInteger orientationValue = -1;
                CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &height);
                val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &width);
                val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
                if (val) CFNumberGetValue(val, kCFNumberNSIntegerType, &orientationValue);
                CFRelease(properties);

                // When we draw to Core Graphics, we lose orientation information,
                // which means the image below born of initWithCGIImage will be
                // oriented incorrectly sometimes. (Unlike the image born of initWithData
                // in connectionDidFinishLoading.) So save it here and pass it on later.
                orientation = [[self class] orientationFromPropertyValue:(orientationValue == -1 ? 1 : orientationValue)];
            }

        }

        if (width + height > 0 && totalSize < self.expectedSize) {
            // Create the image
            CGImageRef partialImageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);

#ifdef TARGET_OS_IPHONE
            // Workaround for iOS anamorphic image
            if (partialImageRef) {
                const size_t partialHeight = CGImageGetHeight(partialImageRef);
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
                CGColorSpaceRelease(colorSpace);
                if (bmContext) {
                    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = partialHeight}, partialImageRef);
                    CGImageRelease(partialImageRef);
                    partialImageRef = CGBitmapContextCreateImage(bmContext);
                    CGContextRelease(bmContext);
                }
                else {
                    CGImageRelease(partialImageRef);
                    partialImageRef = nil;
                }
            }
#endif

            if (partialImageRef) {
                UIImage *image = [UIImage imageWithCGImage:partialImageRef scale:1 orientation:orientation];
                NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL];
                UIImage *scaledImage = [self scaledImageForKey:key image:image];
                image = [UIImage decodedImageWithImage:scaledImage];
                CGImageRelease(partialImageRef);
                dispatch_main_sync_safe(^{
                    if (self.completedBlock) {
                        self.completedBlock(image, nil, nil, NO);
                    }
                });
            }
        }

        CFRelease(imageSource);
    }

    if (self.progressBlock) {
        self.progressBlock(self.imageData.length, self.expectedSize);
    }
}

+ (UIImageOrientation)orientationFromPropertyValue:(NSInteger)value {
    switch (value) {
        case 1:
            return UIImageOrientationUp;
        case 3:
            return UIImageOrientationDown;
        case 8:
            return UIImageOrientationLeft;
        case 6:
            return UIImageOrientationRight;
        case 2:
            return UIImageOrientationUpMirrored;
        case 4:
            return UIImageOrientationDownMirrored;
        case 5:
            return UIImageOrientationLeftMirrored;
        case 7:
            return UIImageOrientationRightMirrored;
        default:
            return UIImageOrientationUp;
    }
}

- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image {
    return SDScaledImageForKey(key, image);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    SDWebImageDownloaderCompletedBlock completionBlock = self.completedBlock;
    @synchronized(self) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        self.thread = nil;
        self.connection = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:nil];
    }
    
    if (![[NSURLCache sharedURLCache] cachedResponseForRequest:_request]) {
        responseFromCached = NO;
    }
    
    if (completionBlock)
    {
        if (self.options & SDWebImageDownloaderIgnoreCachedResponse && responseFromCached) {
            completionBlock(nil, nil, nil, YES);
        }
        else {
            UIImage *image = [UIImage sd_imageWithData:self.imageData];
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL];
            image = [self scaledImageForKey:key image:image];
            
            // Do not force decoding animated GIFs
            if (!image.images) {
                image = [UIImage decodedImageWithImage:image];
            }
            if (CGSizeEqualToSize(image.size, CGSizeZero)) {
                completionBlock(nil, nil, [NSError errorWithDomain:@"SDWebImageErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Downloaded image has 0 pixels"}], YES);
            }
            else {
                completionBlock(image, self.imageData, nil, YES);
            }
        }
    }
    self.completionBlock = nil;
    [self done];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    CFRunLoopStop(CFRunLoopGetCurrent());
    [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:nil];

    if (self.completedBlock) {
        self.completedBlock(nil, nil, error, YES);
    }

    [self done];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    responseFromCached = NO; // If this method is called, it means the response wasn't read from cache
    if (self.request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData) {
        // Prevents caching of responses
        return nil;
    }
    else {
        return cachedResponse;
    }
}

- (BOOL)shouldContinueWhenAppEntersBackground {
    return self.options & SDWebImageDownloaderContinueInBackground;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection __unused *)connection {
    return self.shouldUseCredentialStorage;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        if ([challenge previousFailureCount] == 0) {
            if (self.credential) {
                [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        } else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
}

@end
