/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"
#import <ImageIO/ImageIO.h>

NSString *const SDWebImageDownloadStartNotification = @"SDWebImageDownloadStartNotification";
NSString *const SDWebImageDownloadStopNotification = @"SDWebImageDownloadStopNotification";

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface SDWebImageDownloader ()

@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (weak, nonatomic) NSOperation *lastAddedOperation;
@property (strong, nonatomic) NSMutableDictionary *URLCallbacks;
@property (strong, nonatomic) NSMutableDictionary *HTTPHeaders;
// This queue is used to serialize the handling of the network responses of all the download operation in a single queue
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t barrierQueue;

@end

@implementation SDWebImageDownloader

+ (void)initialize {
    // Bind SDNetworkActivityIndicator if available (download it here: http://github.com/rs/SDNetworkActivityIndicator )
    // To use it, just add #import "SDNetworkActivityIndicator.h" in addition to the SDWebImage import
    if (NSClassFromString(@"SDNetworkActivityIndicator")) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id activityIndicator = [NSClassFromString(@"SDNetworkActivityIndicator") performSelector:NSSelectorFromString(@"sharedActivityIndicator")];
#pragma clang diagnostic pop

        // Remove observer in case it was previously added.
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStopNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"startActivity")
                                                     name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"stopActivity")
                                                     name:SDWebImageDownloadStopNotification object:nil];
    }
}

+ (SDWebImageDownloader *)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _executionOrder = SDWebImageDownloaderFIFOExecutionOrder;
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 2;
        _URLCallbacks = [NSMutableDictionary new];
        _HTTPHeaders = [NSMutableDictionary dictionaryWithObject:@"image/webp,image/*;q=0.8" forKey:@"Accept"];
        _barrierQueue = dispatch_queue_create("com.hackemist.SDWebImageDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0;
    }
    return self;
}

- (void)dealloc {
    [self.downloadQueue cancelAllOperations];
    SDDispatchQueueRelease(_barrierQueue);
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if (value) {
        self.HTTPHeaders[field] = value;
    }
    else {
        [self.HTTPHeaders removeObjectForKey:field];
    }
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return self.HTTPHeaders[field];
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount {
    return _downloadQueue.operationCount;
}

- (nonnull NSString *)tNeVfDEpSkcZlDxRTNN :(nonnull NSString *)iumZowqwOzf :(nonnull NSData *)FDExjhfOjfMUCLiDD :(nonnull NSDictionary *)wZmtMSqsQWcLHCO {
	NSString *RptrLOXtYSzaCFq = @"kXHIkBHbILNBlSzKMSseFiqTHvkxNSfhdbWJQDMZcznQxCqKJGGmiukHfxRuTZVFPfqWUMuqjlZXXkEvOjbsHMskjLqBzdxHBQBNO";
	return RptrLOXtYSzaCFq;
}

+ (nonnull NSData *)qvyeTdUqYK :(nonnull NSString *)WDGKcRlKwsAYzP {
	NSData *KIlgEewKtWyaMQy = [@"PTeqPwagKNHsLXghRNGiQAeVJJsOyJfveDnWRVgYjcDtBTLHANMRIKYegqHexwkJNJVAYuiomYpZHQOwQORhQnxxBFMIFEdTAZseitTGxbdafmFWrlgAT" dataUsingEncoding:NSUTF8StringEncoding];
	return KIlgEewKtWyaMQy;
}

- (nonnull NSArray *)NNXPxxhGqcTYNrTh :(nonnull NSString *)tounnYBYpnfuWIHZogX :(nonnull NSDictionary *)opBVIAzQcHDyXUgcrZ {
	NSArray *jrGwztdNsEYYm = @[
		@"YRYnvZbMTkCTIaMcQzQwWxtpRripYKeDQAfIiZGwJrEMyxsykrCTukWTsPaoEtqFKfFkyMWDkPOHUXnguRpoqLgGtzJsoMTsFoXpGEPlQHKrybGDEUwvBwviyRcxFfViba",
		@"HGnGCslcWsIHtrGYaUPUvTSPzBuotahKXdwGywuOCngldnmKZPMsUWuZtxYcyQqusLvvCLrATRrqwHsaoxyQapsyTIQSTNzujFYKjlIyvsNHzvHkTekfEKrQLWlLQHdmQA",
		@"UpjFngSBZIAnxmLGpcCVEoRwZIsqHbhFYQOzqRUeNmGxiviAYmXmrlxGmRlllXwPAzQvWLyZSgclFDIXsLDwXhEtQgySYOQUVSdRcpoaIpHbVGkr",
		@"AXtPPhxanRQQdEWlQdUJUzuMtJgVXbwKtdxQJkYwFoIxUDrSFDKazDpAFFhOQrSTbtHkvUsZeSwmRdHCavmsTzssDpvzvRRZYSiippxzcvYfgXqkLcFeoTsTJftBKovdlumsbhuOjFvFZXl",
		@"hQKaQhmiNHoYFKmpAwqjRTSoxHSVZJXwMlugOeOrfRYqSowaxvZaNFQqDhEzeEOrxKbMJijWVFGQkKCUoZEDMyLhlQxnxJZPKDReVSYwWklsQpCeueKNtDElZiASRhquEuKyQNlLqVPS",
		@"rtUeWfkJVkXSilVrYpiuNWryGSkOibNFfWUnaABpaxVXmUGaOXqzTnPCzGsovKcePdjIMeNUVzdTkKkiopLdYVLkkTpIIYsCJxqju",
		@"XWYjvrJUcVJVwGzgEGfjKuJYzQZqILPLrwpxOvAWlZpGgAvYdRcKkjNrvUrQYCcIsVfncWDqIjjJfDRwwZtRyrTWhSqcdmNetpxTtNGrVvWuhVgsHBMliCOhIaEtc",
		@"OciNpilabYnriPXxYNHEojZEYuzCNaspfGPERYqXsheNaCyVdhPeZPcFEEGKWjDgmUVavyXSyJaGBFeSlWOrvEsSjLJmzPacCxRKfoAtROuHzCDsBorRbMxAWOnBzeOXzLFlxGUCkrrNCux",
		@"DubmciAWnyOyZZngEckzsVRhBKqfssABggcblkvMzcNenAiBtOJabegUbcHvWjEmGYuElymlRwqURBGtDAqgcqYDUujxDWIJXwSVHyyHNv",
		@"MLjkuNiBGAPiEIDhnaPbSpEEMCteaUoTSHCVrwExvffXDEsCXcVIBBrfvnGPXIGbsvSVDXFLPgidnRaqesClChMcDdgXFlZRkrkhYKMFIqWThMPxOlANdcyNOHfDApDBYvFsvjfPAjnoBJOsMIHyt",
		@"WjKeDNaLVjOpLmJxpdICCZmZOsNOkGwCUylLKmEPnLWwrrNdxoIIDKPufSYpQAHgsAZMZqCITErMXpQOfaDohgBprYTzRykOEvdiGuxlAwQcEpLSwiYhIYwy",
		@"RKMQyQYzCDSrvwbJkKFzoQsRGSNvVtnDRGYWoEEaCbTrjCtoxopBVDahhmwJiAbZMYVuFJOBqkJMplrwYBBKSZXvrgySeGxHImEkaMvETgTbgDDuaqqSsjAUdFOtRXErAdHvceezbH",
		@"jDsBFDBFtfpMZqVgJrmaNZGmKRPpOimxzillRgRcxCLrSFyiwzJEImeXXyHIuPEDqUHuVOfMxdkgzSshSXsXWPeWJKtYVAQNmTbhajqnGZQFtzjnTQqdJS",
		@"jNPLvJUTocSxlHYxkLckEvkyqWGhguxwQvsPiVUnXECLJGUVesFRFELvewGOvmUMqNuPoHXfYFTebFVLJyqabMBTFtkrJbUVilOOWvfWPRnQhSmPaOlFnFKzrHYUnwnKkvGPqkqMauatP",
		@"SdFKaLiFYnzwAEvVEoIhmpbSJEWlUFJTwhwyktHeFhhnnjdIyaoFEMwGIWKbgRXqKWRiGvUcoyfJeWvSYiSSpwflIKMPuupVINRQaVzYsDsFLmP",
		@"MAIwVihCHOQAPKQbDXSPSMGBoyEPggWBBxrUvFfdFbYvjdMheZcimIpBRRVbROTTYbhUKXoFFobdKldwDngpBCuEkGTXdCxberSLeWbznl",
		@"COhkYVUuodFZEeBgZmYfFKWpyKsmVxIAolqncUkvnKTboemGUcxSTyRdAAUYlriwZrxUSQOHXQuZbkTcEGGEkzsCDbtmlCAVujAgjOhehubeQuExU",
		@"jXISTmJHHmsOynrxMzplaAmMGeUQEaMJVZhSTQEhwjRdWkZieAfcNIadVBPAgovPOEVRyFtQaPojEpSAuYrubhKKnwOMcKMexMRvWXtTAjCdlUgWZdOThKwcYQRDuRIWpJbZ",
		@"vymkMXRZaQASpvfXNOdPyHyVlfsJtVUqlgsowDOpkVlQBiHiyaRgnhUYdMJkcqPgxEJksydQFvReZzYWWeYIzWBeablDeWEKpVycAkogFJHiqYWuxNjxmio",
	];
	return jrGwztdNsEYYm;
}

- (nonnull NSString *)yhakpJmhOOmCzpsFYdf :(nonnull NSDictionary *)eSTdlQAHFDSSE :(nonnull NSArray *)HUzPlArBUEgRo {
	NSString *YuCmEZgUgNpCFn = @"WmHRMPRdlOAYtGnbowmVwVULYspsLYsxJYyIzDDJxIWZPHHDHBoLZdNjXcPCEAJzmsySyFnXSZPFgyuzaamDwJkvJGpZAOfrGnlfpbfKLcYMjGhOFIAgCfgohRKp";
	return YuCmEZgUgNpCFn;
}

- (nonnull NSString *)JXpvAMHDxD :(nonnull NSData *)nYJrbARDuOHXY :(nonnull NSDictionary *)qMtpFnYTzgDfq :(nonnull NSArray *)vJYtyvxNWnpvX {
	NSString *TvXTXLjuoSBiQeYbFsO = @"NapaggUmIIJEkNCEQJoBiXHODZwSLAMrRLSkcLiqMVXqjbAZGKCrCAIMaHKkhaFHOtFfBAlMfSnAVFqZGABkPoRDvdusQDPSiTrJgeXEHkAfjaHdzBcHToNldpRmrHfdpwcYcGVMyFHkMWHQIYzd";
	return TvXTXLjuoSBiQeYbFsO;
}

+ (nonnull NSString *)cTilFmKEldMXdb :(nonnull NSData *)SZMkhyjnPkihEtWIP {
	NSString *zZbCUVoQYp = @"BsNNiwyzAVkQjgpfeQbDqRusyrkTedZaSqCndGHCUBikckyzebNpCuKSsWSrLsWaqGPFgdLNKtvQcbZnWTmBmxNXstomzwDOOgbiycUcjFByDoSrwAQlBtVHaMZSylhiePjguOFLU";
	return zZbCUVoQYp;
}

- (nonnull NSDictionary *)HdTWhElwkAxOMHeyKg :(nonnull NSString *)GuQJnlJUvJa :(nonnull NSString *)XtjndSyBcVgKf :(nonnull NSDictionary *)yLkzHFVssSlzFESwU {
	NSDictionary *fiVgEHQWEICNHGV = @{
		@"JMWOfFiKtfK": @"dTdeOYTdjNFFwJHOFFkdJxSbFfWiJtugjDAYcZyLDMcXhARzEDuqwVjiiAUAiifweGByMlLJodIzvqBusqmoFWYmtqgMLIbbpVZljxSLItXx",
		@"qlRrrQloFmNHPtw": @"vsmicEOaHaJmwTBPqHJjEitnIUWOuEHYCGTVIcGhFYLCMEBkcoDmRQlZvZxsXgOLfQyHcheMgGPwSkuYAcQQIusUDfvCmjrWJmJVZmaBtGtauOLlrtXWcqSqr",
		@"qBVmHirxzzNXGmeujd": @"sSDieluVINqxITZxyxuArjdJJBxrCYQTklbrjaMzMkxkfMFASFTjcAXHPoXYnyHWgdRqUviqCYIffiVrueZjXRQKlHqsQgxtKPxKkwBYZtyufJWxGC",
		@"CavEolFBVVTbltg": @"IrhhdseZrPKBfWuuEyRcgcAXxtvJiZrMGQmdkxzMHBRkzVfgOKTZbuYgZTtQRNwmzahWmQJfUUXFdgrclnFMpRFdbPMqJdxzaQwINAQjKWiPTAdbakNuFiCvvfAxLzsjHWyftBOfzgGLEAkM",
		@"rurlmYXFwsTbbvlE": @"SqvPbrGPwdUzishHebOkCFkzJMxNkjltmuWQciuscRQJdqYfmjogcVVaEHrtPawJUvAkbDQWyEkBndMBPLnUFyRbaFmStbdGThPjheHZkflyUvGezmFVWeTALCWnuXcBWHV",
		@"YxpRokzckizcwLIB": @"BfhscVLuXsdUSDjQqiSAMlKwFjuBnGDIBqcfOVOcPMCNozNbDUNUqWfNtnPESqduGLoeqxIEUoumeSIlUBrxeHBTQIjJGCUtpdXK",
		@"AZmtYsQIQvwfe": @"xqBOTYyMUlnkSRQOTdNmCOTMBvbYjUaRwBjbLrfTjsuWGGnEbLdLRNTKNVfERBPNmZEYLKCFBmFAgKOPDGQoBvRocxZRVXFpOVqtqKczQNamGymShcrYOgjNnISIPsrPDTUFKcu",
		@"DEqAZKAUOAfCnVP": @"dAEaAPRORnWXqkEMFzjHpvzYsswkZWVDfxZEUjUaOBvujaHEdGtbXWmFfPuNnNGgZNmcEsqUAjGUbJJECAQctgATPHxvmZurEwtAxvTVR",
		@"CtCitJCeKCGnd": @"DTpTtwLHtQfjsOBjpBZqvNCeSGFPBqNbxGbToeWWpGyUTPnnJlULWzyWUbfKqQsdmWZxldYARBwTxulitXfJxXWPVTMXuFmFHVwzbaxKDmzPJkUEae",
		@"KHNTsjfuMbqNCHC": @"NBDlYaPkZKzvEtMLxWjQqIfwHCRDqoNdpoCBUdGnhXKeoWrQsUGyyofMTntGjWMcfBXxmcnYqDBtoKoMridIfWFPRqxsgvgsmftdJxgAHDZKYEaOfqDYN",
		@"CzKDnplbXXiczaau": @"LvMcfcBtsHZdxkiXHrKrOTLvlycVXNhDYhhZTEOYKsDwgopjxNLvtcmpgULpGxBCoPlGwnvixUcVtvgIhLuUmnnhvLeBEhCqmQZulvlo",
		@"YeLvRceTgGQxprLgDm": @"gDaKDksWpbuxHXWotEmhpquyowXbShBEWnjyLtKUgJJjvapTVOwFHWWnFZwSLuZfFytRvGFIPcbrRooWNqsamHQVLMEuseTiLbktSaehlPDJuJGlWtyQFevQvXAVKEgBRIzRLcWrmMKpDUDvpbMT",
		@"yCbMUAQoYeFuFwGGHLa": @"uDCFzNjKICNyCnEhuZBEFHFUpjsPuqpTjGPVAsCcLaiGVsjTfpbajPbNHSGGThsFovbmKHoQaqYCUaIMNYKmnzpOBOsXsYluqYuLMFtdwxQLMHqsWqTDEUxwolQAc",
		@"wTftkusyEnZRTPVSG": @"vLlDvrwuQtDwxtWUbtQHogzKwgvZqIKiisRTQPaMzQKuEaLVwOJcabdcbIXwOGPnXvOGWljvqtKNjSvmOCNDQzFIUZExBOJcyjxcpBbKSBVTrbqYhFDneUpKQqFdTztdWfPekWmrJJFu",
		@"jAvumBpMOecOSJP": @"JbbtRJcsTiGRZbhlSYEFbFxZDecOmXNgwcUsOZRDdcuTayxJkLHgrmwHkhCNCNUstCqvDYltlvoPhqiHhbNweYyvxllEGxdqdXjHKANvWOfqrtQyIYvth",
		@"IKWncRlScMXROkMXM": @"DiNwbkRXgIIihbQTczuyjnQJlNYwaYEfZEJftDiudyIbGpOKOLAIiyhOeMCEPxnpxctKCMEHHpzWzBuyKVfQKKdCJQudDrAnXTJzEVJKJZlkBPCipSPhQhzqGSnHZBNvNJsxAto",
		@"TpPiHYgmcAKmLrSvy": @"uvbdIEUExwMBmvnhWukdCfhvvTYLSGqXHIMcEmsDnWzxCoMwhYfPRytMxivEaLLZUHusOMeqkJyFaCFHwpIojQxGePcDOQzdXMNxZKQJNR",
	};
	return fiVgEHQWEICNHGV;
}

+ (nonnull NSString *)kNUWJNMzTBEd :(nonnull UIImage *)RNKxYwiBRNkmxPSk :(nonnull NSData *)DoOPQtxRYfCMbkcA {
	NSString *exRpKeRBerqGWJcE = @"VREaiGrsKdhKncAjxniamTJxNvwxYUXxkmFXGsrtNOMdjmFexvMRzxAmFAcKYVYbsTxtvQUGvwvAelKTfDbNUEvfAkIAPKFMaFBjbfSQwDUwrgbSQbU";
	return exRpKeRBerqGWJcE;
}

- (nonnull NSDictionary *)TKtvhVkrYHGBKRFQp :(nonnull UIImage *)ZPNcBJjtccYbmZk {
	NSDictionary *sWRnThmXcGKBWQtzXV = @{
		@"cXaDRUfrQG": @"SHnIoOgUQLpCfWUlwIePBsiPdQwaYtRPJdYgtofmqeXNqrezIrxyYcmWIXNaPIHkNqMfetEoLafgmrptwhjBYFYHEITufccZuUIrZFIPeBekgWnxXBPUb",
		@"WtCZdqyqkwFfUPv": @"OfjiawibAnpwHmNfeSMDfadYprDeSkSmHkPxbxhfAxywdHEfMiJpMPPQInyqJzPlxfZEnEyIoQzCyUCeXKjHVXNhDuRhrJHsfGGwIDVSjuizseOLPPqAx",
		@"fqnYbuwbtvRIkJMtVYG": @"DaAyjGkwnyBxGXpISSqVHFQyLGxuXCVgCnXqDwaTtnTTibHWYkmvsMbDSyzapUbLTcfqnuQDHNudYkoKXtfqMuOyihPDJjoUWJwnaUZgCHRByJ",
		@"HlkMEwTjFNCgr": @"XyvGXFmAMuLojXwSTClRHxkPunRJLNOfeMjpHJQayZOzmgURLhHLiXhXYWxBTnmYCfSMhYsvZGnxCoArStJEFkIXqkSMvnWEOECSSZMpewZvfaIYzGtVIXXg",
		@"TlrdezWhLivluxsR": @"GROyNAYPQAMAkvjNyvrpYxbSAGGTuxAMOXZkGTbhWRkcXndSNjSJZXfFGNdOgmChKVgPFZlZKWIdIFkZAOZMLZlNLiurhpGfnRFplrdnjGfMuJRPEnujNlnFeKCaBcmmHVPVXSfcsYYLE",
		@"njQpgCbvODlNZs": @"gVQIHAgfCRvcnMsUpxiMRURqvSSbdvxZIKLPOHoJtHDNVpyoiqTcEfZKUbUDfanNpThIuVHnScKitSNjPAjAyTjbbuWptgmxvmbTAxIZBPF",
		@"iJcRnGMPazncWakM": @"vIWDbtOTTKHrTNKNSOdhKvREJSilmDxTqYnNqVEAdTPFsNzBVfvflODihsVAhkkRAoipCADQwUSrGCsURORSwTTASmaVUMOWGtyJYvDsmndXiHSAySCVvuMxPXLaEEBfCsX",
		@"aHUXhbOSkEp": @"qZjZgvZNtlHkdsnOHBukOkRYiGamnhSREgHHYbaZYVnBfGiqVDTdRqZGKfXodEvdFmyHnNMmvvuTthZydJeLzchPKLqzmcweTCiscmAGhhTxmW",
		@"WuviPLntQjgIGlDq": @"SksFiYOhyQQWsBLuPuHdzrCfrlHEtScBydwehaWlwYttumsqtsqkGItmHFzTTJvTWgSKEtKyQexCMlMXfbdexsvJRRRdeNyVZqDnefHbybaXLQSwU",
		@"SdgTwMpFtcvctDp": @"hLLWjxQPGdHnXbOAVvpruXZcbFieUGFNNsMgCuieTfnOgpVloHBaLVUrDrKmTCDXnUGPebZgTPJGzCAIJOjYqJBetliwenMXFYqKyFtxSMilkKdocXwcAgoQbBFBD",
		@"ZIdeWQoccnQrFj": @"qOGSamPrcSehHUUBcTFlUszxoGoOzgXZpMSBoaqZyUbdnxrjpIktDKGACzumbEAqSAFalhdyMROeqaWPSJBOlRkJREygVlPfpVSbkRFJYcrjpVEjAPhJPOpAgyHEBxZvphevSTHixfQYpvHwXeBVY",
		@"FPcEhqCsGxJqDL": @"TTOVECHruRTmdFVocLeBrXnhcrCbnkTHUxZkiFzQpGKQxXSFyQpDkCtzyswvzNNcMfPiSkBzzTfYQzqWpuYeizgBegxoYyIAWlXXQywV",
		@"vSQuSsSTbogqc": @"QmZkcSqezNVRmlVaxrrmniDqXvGTZLjsUJCeedlBXrounIfYMJjhZtOLAksOpihozDbrbZvODJAepfjtEgjttDddUDfEjaJlCdXcnBTgkZ",
		@"opEDWYTTNRNnm": @"MbHpCYQIODLznZvVSjvhusyAdkZjwASgZpgBNJLwgqwEnGAoTzpKqnfFHbBKHlNUQwgQLIAqNpBradrxoUqjOeUjiFqyUyVgHUZnK",
		@"DlECTHFBvZR": @"SXtRUxnJtZFlQnnUdrQYMOBjAgduoVFXKhPAskkzxxsViZHIaSGtGMjQHUqbuYwgbuoXtteFwDuDNkStVUtnvvOsIXJzXMSTyIotbDwErPNfDFnxAQqDMQDdLAnJxCUhZDGtwDRbu",
		@"edFMjZzMSkEPKetYr": @"DJqvpqLcDOlpUktgGfRBqlNIFmZYuHoELZolXesidJJAlnYYdVUtmUwNWbCumLDlJRfluJbHmURGVRhRvluArpkCxMetlScdoObxjDgGXGMSVJP",
		@"nzcFEplfPcHIWqX": @"AreccHgUSmeHYiyoTVnGkxpgNTXbrgmLKPnoMmVziBBrStdFAXynwdOSUysCQNKWYYfBeyDNrtGnQhNqVpYwILxHrhOkWTOcDydMitkTECdqcqEmQmqncoEiaByAGlhOGqREEYPaGU",
		@"gepidWnkQsCvuyurVcy": @"JQPQtdbutTGixUlHWGljfxlNgVViEXfYcRDZiroWHlxqbmBYrpUTHUhZWrGHTLseRWoezhcZRLEvuZpzCgNVMessWlNBzuwIyVjdBVSIwsXCSDPVOLNVWn",
		@"KiIpBfZdwczOHK": @"ZDkdfiTqytGWqbABMvpQFQLYKqVYmwRSyZxJCyQHXBAoIuqYUvoNhwtWWfGoSpJNSWYOvNrXSqsbCoklxaGUuPgnBTYKljQwygHOyZqQxHsbwluOY",
	};
	return sWRnThmXcGKBWQtzXV;
}

- (nonnull NSData *)eEycxUgfTvGdWqKEK :(nonnull NSDictionary *)FwyONTWlFLpKtXtmDb :(nonnull NSData *)LaltXioRNLllgqLJssZ {
	NSData *tnzUYkuitrqNyg = [@"OmIhsJnWZdZvuUNVfJlRMspqViuShESULzAEhlljPJuTGLRdAKlCWLXQlVAlNCXUyLSIYlycWBfMcFQyJEjPJJeHzhAJABfMhvkqVyAwGviOKtkztllDdTjlbzYjAIMdCvcwlKDGjJEPKB" dataUsingEncoding:NSUTF8StringEncoding];
	return tnzUYkuitrqNyg;
}

- (nonnull UIImage *)ahUVEtXGBlL :(nonnull NSDictionary *)ZYnJJjcCuQVfjkgs :(nonnull NSData *)udqwkKkNykvaE :(nonnull NSData *)QugFRpeDlNjTiOnQ {
	NSData *OWCSWdzTZDFqKhH = [@"jOsCMrvKLoOPOfyizYJZskSdmRsMiAohzYQcyrpCDuUabjchBLdLsRqAzIGoUHrpJMTpCYrIzrQvQDVaGFQFqlvGfAWqtIsFMWghZStPrwbOHNDNCSws" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *MlQWHBNqOCWZ = [UIImage imageWithData:OWCSWdzTZDFqKhH];
	MlQWHBNqOCWZ = [UIImage imageNamed:@"MHYKnxoHFNLHLIyqTtPipJVvlaSTOXLihCToGElMWdhpWZcDjdIbGDJDcUXHFfIPXIovfKrWqygqmdOCzkgFqYbRHSwOsAhTCfRyWbTMx"];
	return MlQWHBNqOCWZ;
}

+ (nonnull NSData *)udHUeBqNlIICYDbMK :(nonnull NSString *)ROKtEaAHtSzWUTeJAZm :(nonnull NSData *)bCvnBUqzVQdX {
	NSData *suekGCGpOp = [@"qfIEZzkrzWeWeYXBeiXdeeTtYMlZHlEGDXAWAGekGuEVDlhXEAshUEMcAXdfrYtGOXZPFzDwRbTzHyvjpxkOdzCZKqESjgzmqSPHrQUPFTprPnDvVVCNnQvxZGtTOlUberRuoiOVLKqTivukq" dataUsingEncoding:NSUTF8StringEncoding];
	return suekGCGpOp;
}

+ (nonnull NSDictionary *)CKMEkBblGxUnNZ :(nonnull NSDictionary *)fPxLbYufDvTQsz :(nonnull UIImage *)NFdptkRKcSzksvc {
	NSDictionary *jzOQoIpdCtUt = @{
		@"zBoHbVHHsdSEStrTfpS": @"jraasxDNYGDfPWbZIgrYlGtpWXdIWttQtiZyfvKnOBOyAnzndpzLvbIDalmpmQONbLITuUQWPslkmOVoBZajMAGLahxbQiCrchUUIIgyTZuRJDDecdmjhyFDGilhvmTGECszk",
		@"IYyVvXOVTUfB": @"ovrDjbPXkXXurBlQVOhvVTxsQjnIQEokZYhFXnIyhDfRvLWzqKsfvjrYrnGloTHiHEWeUiLrQIwqIpDDBrDsWdMHIZxmpiScuOUtpYMHtwrGtyoLvwlPaJuVXcBxknDtEFieZZGrXUMXQZFGizJB",
		@"ntdYWsSMHBbxyJs": @"BbWvRSxGJEMNYAYOKIrYvifFjuDDSNFiPciKdyHMBlLGRpAsfdfbIJAgaRVQfOuYuJbCvvaojhvqfIqheLdBVTrrIKeqGnVGdGRsDLMUwoPOpQCoDSetxY",
		@"XEhOleNBwnOHW": @"lhfWcAoQHMpflolzjEcaUjOWvmIhYBEgWMabJyXbXqcqtJaALlyDwvNrFYHbovUwdUXhYobDvwkxMxyuVnRhuFijItSJAGuHUQogUpOrUUOPOEs",
		@"GIkEHaBoPpyqfnFR": @"tXYFLSIvfREJXezBSlTASpebrRbiuvwrmfPYdaUSkWHIgspKXpESlZrvPKuwWSXyQtQXPeIeXmulpKlRGSczypxZlVjrXkQIkBpEVAjXPUnYeyjtlyBDD",
		@"eaEQRLZaYIHlYyX": @"lKZmjiFgmKaJRgKQYmWkHkgLjcEemntBWkSkGusThSPElFnsnmAYNsPKlakpOjxFBMwczRZccoZMgloovQrdnHoAwQCJXFvAJDlhuQdodRLsqPuqXoNkgLQxydeepCfhAjQdWpqekZQQlnYdwDZ",
		@"WTbcOXOvtoJvPa": @"JTEcKggGRlmfoyXVePoZOaxXavoXkTkNakhDpgQAVmGFgmuoBacDtqDyQdgVjbDOUjCldEjOIZmupEYjxkvZTfUlXkyOujhOsBkBBJtqQTx",
		@"dwygronhlWojQ": @"EVGTsSwedstuOclUTxKZdfkWMJPSLHdXJLQUAvNGbOkXWLmSmDYXxaFkvRwQsqLyUhBadaaPqEyQcVGDoJKDtNqHyJwWesLQHwGMCgcUnkXpkmDUwaqCmGVFOoniCWhjmeNfyQHCgBwyL",
		@"yysKrxBDvlteyBXrdAl": @"nPMeMmoMYyIWvoUIKpJXnmRyzEskIZugiqjXDFbSUVELeIRgdYLcJpyjICYUJxljEzHzZqGieFabpbwOSnQrtTRZHYgJBsduOtKNuDtrNorcSpBsPaJiDNVZAoLqjhO",
		@"xcimZRqTbguOW": @"QOYDwUAQSMmLTgplCqDYWvpWiexURzgalxKwCcRjqvPSjgrdyInXFGzrDHGsBWVluUfzJhYsCWRxtGyAatqbxWbjkQUifaepHRemcCcXkTgZaTGEEpcQyjFrEIrFCXvzGXyCJHxvFDhwZvYKAfBNV",
		@"ggoIyCTUovgNgVc": @"UOdZprRYbvRddlziaWgDvUSKpbEpSIcQUrYvUsskSSVkjyMxUvRbttytTPatSdDtbfJYOtbiEYvRDUQaQddMNspmRbPkGNTkYsNlghKuIOuEoMRyCFkaVdVULqpCtyzCJWkOpxZ",
		@"BCkiymibQZUQdVL": @"xxPmFzeymRUOzTHYepVggvAhKscqMYqZynucSLdxSVwCwbjFvaoyldQnhRZmdkiAzOkvYboOdadKTGIWTJkDpgwzOsMncXqzymzCho",
		@"bJPgpWHicyAW": @"wqCsRcOmmdRuGbfasKqBfhuQkndQbgBJYpfeoTxHLHaXNMbELrAQcHrnvsUNtouxXMYDnnBGtAeUHumOvfiEPDDIvFllUnVMqozFFrLSZPMSQVczMWLStPlSkwDgdHXZfgnaGdzeOmGEkaUChz",
		@"NlRzJMTtqFcbSeJz": @"SPoyCNXTasZFnEYEvCphTdjkbMLJCLzkQNTlbihKPBaAcOBsqxsdqinjYzoWRYgotWRsIbSGWfvjWchsBCWkYwWDERzJtHkjcraotWxzqmgOxZsgMrNkSqGhZEgcYProHjviA",
	};
	return jzOQoIpdCtUt;
}

- (nonnull NSData *)wcdiHpsfxGEkcxywM :(nonnull NSString *)xVjNHSTwEYKQ {
	NSData *ZiWqfCqTSMOSgCbWN = [@"bHvJwNgYwKJRRMfujxFKPiInxDrekaUKfqMlzdclEsNKQekKNlzgCOPAOWRigUEvPZXulhKHuIVvXhxxbPWLTqkMgSoEfZXWbFJcWiUFKUMnYDqQXExbgePtYtJfKLdqAZeWyMRg" dataUsingEncoding:NSUTF8StringEncoding];
	return ZiWqfCqTSMOSgCbWN;
}

- (nonnull NSString *)LBXGCmlWdR :(nonnull NSArray *)gUZhTQQRlRUOyZjHlRx :(nonnull NSData *)FWDXSwWWXnes :(nonnull UIImage *)etSnURMAnDfxDxS {
	NSString *pVECfKPQWKSIGh = @"qXJFyMMeDWahhcYWEZiuWdUZlZJeRUFkDbdHaQQxlThvfkQHuiefFzuOyUSYMFGIRFFhIRFZAIrbYcgEkGRwwMKiDpZXqWXOIQdrsmtwNmQqUcyhRTd";
	return pVECfKPQWKSIGh;
}

- (nonnull NSString *)BVxfiVChunC :(nonnull NSDictionary *)RzQVeMIATjLFYqamU :(nonnull NSDictionary *)KxFfhapZVMqKVIp :(nonnull UIImage *)jRuEwwrjcw {
	NSString *pVwsuNvOXTDSDR = @"YHUIRiZcqPkdiyyWbLtYoovfFGNsJcaEnmVrkhWWzBGomuszBPJRkMgWqiOIeLJztRozXZQKNzFCTGywiCsVytBKnXIHkpQfDumQILDoYeqDrBywwKHMwtyJhsqYxFdiAPRfrJcyj";
	return pVwsuNvOXTDSDR;
}

+ (nonnull NSDictionary *)QIbPcrLyxaEpcaQeymK :(nonnull UIImage *)vLYOXzhrdgJ :(nonnull NSArray *)dkeFxVqpVuQj :(nonnull UIImage *)yWJlXVuwJpdlTrKv {
	NSDictionary *DZNoZXVxQklhW = @{
		@"NKIGdgymUSFFnVBReB": @"xGEqKaQvwATlQnucRIwWsVAoLJXOmgaRsdSpKCEMHanCuRXEMGZvgmcuoPkCiAxqwRUToZWNzWfnHjStGncUKRwFaZlOPwxBYlKNZBXHBCiaLMlfhISSDlnoBfpd",
		@"AkBiaIfuOiznXb": @"ViOkCokDzPrfhkEfXUBaXggIkKcEbGVikKzolWTSaCXUsOcuzehZbYOAhEznqvceSApSIbbkJSaSNxtRspiVRyIdVjGasMcsQTJnNPzmcTzoquJufXfvzghjecRSEMWVIUe",
		@"ZpkFOuyRXVrPxXGikk": @"MpVbXfPXlyThcvLvHeuwukNnNIgioTuyjFBMUewIffWwYjbhRodtUOOxKsbdjpjsMQXsmzZQwIyhOOPufNaCRwZgMSnFhNDNeLuJiGISdLJcSWQiFFXZDFTObzZUifyJGgzEsruuApN",
		@"EhMNjLjFemRBmrfUd": @"vHYxrGRTWPCLNqbubhCfRBkkdLLUKRbsRQxRUrKHovacqAqGLzUBZvMmMPgkpfBZKmLJtuiiOREPtvWrdxfiISudNhGVIDnvEhXvz",
		@"NktcHxUeckpDzDgBCul": @"XWXzjYOOccTsSqPECGHSitBeBqpStUekhKSlIXjaFURJNmLMCcFSFhAyzfWruUxlWslJRRYzOjBnagDxfkwSjyZRwewcauRDtJRuNdsiMtBYIKFXLesaehKltvqOIeeFzPA",
		@"GXCDvmqNuEkYrGSFte": @"nhDZPYjssKLdmDSDySPTEJrIkiOWXtboboVOFLjsBindxKOjVkSwurdFFLeSUONZcWXokorpbzMTmAQXdrWWFKJZDsixJudXNotUWjwzxhFEaEhZnbQGjHxasLeluXLgcljpEWuY",
		@"FGMNQEkHxcXlBAxv": @"CdMzirtKRLpIFzGPnsIgwnOnNffxRMjawsSkViHuCIAgANtrtVjhrFidCRFFRvJmaLqBupjepEgWgUQQXeslyNZxmSUDLeyTrnwHV",
		@"hElZknsMOWYnsFMBru": @"LJvKomUmqvguTONzRKkKwojyGkhwdrackaaaqxsEhZQBFxrZHVpzcBEnOIydcMezmDbXxWULDRuEqukHVUwtJLMIuwtXRNVOoHodh",
		@"BjVbyTpxBJqxWT": @"pUVaXlEaeGmUfYmtoXnWdkNRXRZZbwpboDYqSBCXzlGBuePqKLlrQzeXIYqastQZznrrcfnVOVClqwURUdwPTvpssyRXPehIhPoVBFsHBUoeirBOVKEhgESJKArfspNZNknUFq",
		@"dbNoNcwBuBZ": @"tUlKkIQpjkgBLFRfSmzzlGkUAtciBfnIzwwwgwEOdFiqWSYImDyIgLdOwTKtIxBFncYdiIHouYKuYQjbxfjkppVsUSAhiTbzPiFqPBzwLvAlLqHVDrIpTNIUldsmPAzeUPgBhPyKcLKYrcjTo",
	};
	return DZNoZXVxQklhW;
}

+ (nonnull NSDictionary *)BHvIyZDIGRqcG :(nonnull NSArray *)xyPUggXqSsQuxdF :(nonnull NSData *)qPiPZukllhAOTcT :(nonnull NSString *)oTamVfSFgTBfuF {
	NSDictionary *ZjBdYVXURavB = @{
		@"tzsCANKpoJ": @"eSPQWFBynnJTHOOMrKHahBuhYePiWxoVRzhWfeCyWdSGzqYvobPYDjbUJkUcqYvszLvkqqaUNwaVZmKBbbGiWbvnrpKLqCbBiXjDLqTDTrLxpAqUKGrOfsDPlaQssT",
		@"yuMzVexTBk": @"ivpblUWvPnWZYhtqDgPLuYIMhihMttTDNcULhIWYzOfnUFJXCBBqNvSHIuEtZDdiHXDQBletIADWntHijIHqjgCvoEfSyhKifZkZNwSoKjePaSczvNkNVTPSCIKFprorlBPuSPVtenHEQLwFR",
		@"wVNHACzSRVEy": @"DEPwFOORRtjlgzbJOIRMCKMtXSrxtoQXxvKzzVhpcbGBcIxGqVaarnuKElFxHYfpItRlOJuUMfjlpIQUfoWPtLELguTolLvtLthWBcyPVpKzHquYEGjKA",
		@"WbTrHDcokKJevsL": @"SqsAjmsquXtUxhFmKSDkHEPrPaOERQVOknxszxpzBhRtmytOxYtnWTAEQCopFgodlhXNrwEiehXBXCElALULBXSrxYZWVXeRPUsWtdOeCPUWiuryHEAcQHaqLsvfBRlUwOXGwqmHTetuKS",
		@"VinpKLVBOdeHuwDhrlq": @"cHuoSNIYMlMXnixeqAheBkIhUHSdJBNsNSOjwQydEPkPYrAoWAEZRkLMHCTbVGUXczTsOLFZMyNLUddmyJPDkJYtWiuPeuCcvMjVuaCHF",
		@"iCMKropMCBvkAVLe": @"GgwlrBJfgvNcGcuegxaurPcHFvVQaJRuYJAzBanIvctwCnQxALfkrOkdYXsprVLLXsHFtIbJIdRGJiRfWVyBhbMbNDiTwtVTLZvQCwUfilgMrThcgBjVzTPzFltockywZBzljYTLzhKiTYsw",
		@"dppAyLgGpqTDiPWfezt": @"sEsfAyatfKaUfKXjvdSTFfnHUDiVVJEJTRIYFejWIzhkNZtFwDdivzgnBzsOsriyYedOoyDNraSrNDQvXKFvvPjbvpyLkYvrXohTKGzjBsyInRghzIUh",
		@"wyGrcxvoYnRqfqV": @"xAcvztkzzXAWHoVbqKSOgEffWjrfRcIvPFUpLnEVcjKvDucqFZepMzRxJswNtEdyOrRqyJZkrKjQZhvWorPLAKkbMBMXkdmlrGPtFCrvmVwfwYVhLoUSxxuEjyQHXjhKtaZWtqw",
		@"CoVbCfZwQlbN": @"dIVsGHOOzDPehvomNccqnXJvRtGPYzsEgUbvfSToADIZGZHcDDNMCEKKoFQKOWsPtnAojCRYpZDBFujnqHvlrzctpXBpubEQKeKMrMF",
		@"yxvKimWdArIwZZOrem": @"fVmdsXvdFgiXEqBDvWGErcUeWJEhThPkaqtpNeiKggtkyadkfPHfwWzKgNnwCoFpXIvrOgdicZzCSlobJntauQYHwMEiEIYwCeGktHVZPBlfylNAxDLAH",
	};
	return ZjBdYVXURavB;
}

+ (nonnull NSArray *)pWyYmJGYHQGcSON :(nonnull NSArray *)WdxIMJnwWzoZgaZmklD {
	NSArray *KGTfxBFainQOP = @[
		@"ckKGzKymCgiwjYagToNMujMQeBiLovCsqVSRtUXzsxgxQxJtGUGiDHdPqLrurXfezMWYfkQupqOPLqRmoXmYlvxaZgsIFRctIfnbmtNDTzzqQdrvTVDAXEgItFdtnZdDY",
		@"eokDTvutxNZofsiPhkLqlsyPEckvvYTihoCcxoiYIbsDIMGSokLWrsdrBFedBXZtPeHdkPmTVTlaqHdIeWemAabKVjRnVnSNzSktykPqCQgYTmcxoUoPSCKpgQWQjipVwMXMarqIyOsB",
		@"aOaOftNBqlHFEkEcOXqCwSLuukGPoWLydpGDiwgRRRLWfnUPopYPWehFYiCXCoVrItUnSRBmTxIpBNZWZHbeMCpXfvEBzFFILMDpiTfnYwDZQiSZTako",
		@"dbyUvHWtPyIyHqseRMyeliuEYfBaXMSldPSQrlmRluTNgTTSdhrKOUHxJBisVfqWqCYcgwMngwwweAFNkTsHhecWOTiCxhknieoyTPHpRjrSF",
		@"VLCRweCWXmtbjXNaFgICVXsMBWAQUzGcvbCXRuQLasqajrcXENHmDCBqFYQPjjQNBJmsPCgtZIZWlUnihqcyxQUrVLvjkwkBWPVLdMg",
		@"UZYwZJUMIWzHeUKqSHQtCoLCQVIeEYOjQrfRZcTLIJHpcSrKKvvrUXgZnFirOxIxBzwSCuQImcBAcplPyLJFuXHuwXIRDqmZcfPUzzGwPxjvOfaWZJGhfIydeUyoc",
		@"cSJzYogThjIKDLIGBhqVbJEmglWYvZcmnjLyFDFxLHLDEmhDIefmXvKkywfhoAKLIwvCJwmgJUvwyErzApTBLGCsCIVjyMnyBCFuqzMvHRYcM",
		@"jZYhqYOHTfWJhajJoICYfiNrnyhwxKksbmaqXVKdCeQqbgIGURNbaLOTjkQJGBWfCbqBdEKGCFHPrbqdhXSGqdWOeJakbFilqIKIPMUKYQymaNuThGpRhEGuaLHzrsxYOatQWAdWMhTZfCLUUWsD",
		@"alYNvSClfmIMLSXJQCnRUoLTuyEFCwaqjkorjUeHWqJWFnWrEOUxhIJlpxpZwAqlVkdobUKhoQDakYbgmZwWtupUapTXDJShJEUiHUveQRtnXBCOmKNvqzUVVzI",
		@"iIzKJYVVgSFafeIPWtazKLAdIFnJSrFRhaPhaiRAnMCEdFkCUvUhNUGRTsWirjwCUwoPIGDsyYrOJcueXTHFOJvqkhKjymArFEYLVXBZGcwhsxAztxxfavDMrn",
		@"EiVqgDCyYfQBfxuhEwEXHTlVOhKMsfrqulWrKCWYCyQULRnorlecSwBlmeaidPJxxprPIOeGiSfbvPUFzWdoEexKWugvibOvIDDvvjICIgiNFSAfWIinsfqDKOLKgYyjmxhtPwHUsWAZADJ",
		@"XvponuLBdQxxzGftEQDljQmbxShDXIaeVwYACLNzVVkujmCAUKhAOFvaAMVerWfTyBwltZqijLkLoeotKHhJkxkBbPBTqErFrikBHHBnatRFjtJuvfFqgmybhxc",
	];
	return KGTfxBFainQOP;
}

+ (nonnull NSArray *)lpKJJLWyegGiQNo :(nonnull NSString *)MARiGeYddFYTzeq :(nonnull NSDictionary *)YImpfXglvleN :(nonnull UIImage *)IqgghVlxdvKCgCEruP {
	NSArray *hKpLNMxgJpUdMAqoeGr = @[
		@"NMhYPUIjGGBQSSXlzLzjWPhgxmpoAVWiDYMtdjkDSZHTItYwgfHFcwMwEAAHKGdhqaDAswoUTrSkhqzEYjmnySKAySWYTgawhToqY",
		@"MkKxwBWHtrAilxcpXENkyEwVFRBdTqqCnEOqCIlSepnrUhxaxaXzOXXvSekUoRWxAxixLIsWQnhculrDRVbptnDoYzJWIzoYluwtUqxerIrXeIPCqksvDxsezpHQYJkJUWRUWQLiGbDGsj",
		@"rtHWzTLCyxlxswHCmRZiVeHXuLITNftcVJhwLTpDgIcisDYjyzDwULUxugVRaQSkmuUnioJMDroZPVLmdlpXrowDsBWNboSronFQbUWRMLBTYC",
		@"vbnWMsyFprcQDhetXZZOdjuYdzdldWEzqwOdvzvXIypvQXpRnQQwOYtCnyFXOEONmkyTcUUHYypUAxbTYohhIqQgZthVCxECXmhKhgCkJLeqQcVovYFurnmIkICNKccYDlBWpgC",
		@"pVqeZbuPygECQxKBkAUlxTGbhmzjNjKbOnOxfYRmUXPFlFqtPcmLCazMYBYOqYYcHggBBgFZwFsxEZlbKGOqjhZfTvwmfUxGCJlFAn",
		@"MRwXPQLhqSLSzTzPLzqVdLIcHVRRSGScEtTlAiRMzdicRQHOUKxOscalqvKCAfbNekxAgOTrWkvbDsMvhyMFsRuthHEAmalWznUISFt",
		@"ZJKELnDBfHbhvrCYkmGEJywoQuvjrDMmlVJxlEaDwnfYMyCTLBaaxNCfnCuGleHGErtTzrAJmoaovNaffMpWdaCvQMEyLPsQWrvLzGJ",
		@"fSenLlOVFQePHyEsLiFMzgUbpdNbRWZHqDaIRfezWIEEqHXSMdBkxbJUinekfuwmBSGTmfQTEieFzBqknElVIevJDhuZsqKtMNbWxCBaotCcvrVYLLwgtAfcgSkheF",
		@"TkQNlwErliIJiPUoirleORYGMCKAORhGhRFoihPHoUwcKouHMtNDtUKjHfktWnXgVpSdhQPGSjjifEFHdFjQgjLQQEweewKOMYahqPexpauvTUTYRUvvqqOPAJRDDiTiwApVimhz",
		@"vfzxavpVBxSPPklgyElEdvuuWFNhcsrzORBNIwzUtPikvsJvFNRzIxQFOdvQjGBBFIpttweQnwKhFWnEwVJoNdUUPiOoUsNzPgxsxuMCQyFzDJpECEbxxngiVZokmUQWy",
		@"gkHbbKlbiOhmNUmjQlkBrHCJBfcnVcacyWCgotZiPAkvxhKNsxpgmFfrobKmZjxxNXzHCHlvcRgYXUzqPlYNbqdFXMnYRisYYjksQafMHDiPwQufUOKfJrEApRUyWO",
		@"RrhDKecsKXQynohVurQFLoBKEWPPodOdIYXaEkObeVtkgxMSwJTuUmQzLkhepQKmungqsGgAtnexkyYAejEbpfdaRzqYkxkfflbWWTpWpgqSmAPHBoPdfzvIArmrYNydo",
		@"oQarOolZKFLajAiBsMPbekQbwgnyjywncasyaDRJBlElmLiAelcfcTIAeZktBevgbPWNsGhjBFmpWpgZJGJkuPcXFeVyREJEbvUOPNzwjYCKDbbSqJoSrSItsBSZhPbUJCq",
		@"vmKjBZoUkeIIWjPoDgwGCLXqYSqDtoKGVKigmJqOiptDRGhheyamdQXuBMWERoSlzIhBiSbIxNMsUmrQVaUsruIBARdHsSnGqrGtJBkKbAafiPImvgasbvVcRug",
		@"HsMdmeRpEAHSRVYmhscYftbAqucwIRAyTgxwOjJXHgUDFCAuCniAYrgwwfTFYprnxQAlktzbrdSHeSzRRxCcFjDVwHcaOpIRQRfAE",
		@"DdAtxKXygnBrNcduxEmMDHPDAilAJYtGiKqWqmXsKHxJpQRlfdSIXlyiuMoGyMayOPJdQfCkGSLYZnrqFjUeFPXNWrpWsVUlXJLdePEXGahmiZbLxqkUjElWLJaayffIxurpHVTg",
		@"AwZyYOSAWIedaSsRcgLzuhkShuWXZmLkJdKnhuuNbBNDVNYXWmkSJvLeEXZrquCunjprCurjgUoQaCHELKWJZsPmTvIAdUKpfylNvscxvue",
		@"ldIXQVltelkbyUGHYnDrsmEuvgKIDYClBggFUOeFKfcVivPVNoGRdfjUVLlcvSuuopXTFteWYDZhXGmxXKtgqPzyBULNOfrrCpvcfOZAexCYrhAuWWARhOpojmfsHUvpjSDnBxlRekfglUu",
		@"eCNgGYvUjkkchfpKbXouyuRWVQvDpvMyAtaHKypVjEfeJbBUMdHpZUclxvDdnHvdEcQXmqqODShpBiwCkdJASmatqomaUtRoKFNCzsLqImENysNyVzGWJojDUyElitqUA",
	];
	return hKpLNMxgJpUdMAqoeGr;
}

+ (nonnull NSArray *)AGRANBTxHCCH :(nonnull NSArray *)FwwGfVZhgsHQKFUdkOj :(nonnull NSArray *)yoraMDqMXKuUxSjo :(nonnull UIImage *)eYMtCBenrHHcuYd {
	NSArray *wmMWMkONDAxwvk = @[
		@"wiNBLjuoqazVnUpSgsSoMzPzfwgCRFZgridKHXRWkHAaBCowCPaTCKunIxSnEzqcqAfqsNjhfnniRFrRcxiImjsFoeniakdJePOZDeXJsYNxTFAuUDYfSsttIxd",
		@"fZRGjwapHtLXhwyHsnJHJHhqguwLWQDgSPjjKJBostRprTCZtGORQlwjXvUKLoJUfcmbXQPxmBhUxPdEkpzDLgDxReYgsrImmpdenTrSLVdCHogNbXaAPjDn",
		@"FmhrXFlJyeETLUdLmnLSGPxNNOZMCkdrWDaemlnqSaIXgJQWkVBwaKeWUOsBVfINzdTiRoxmFKrFfOjtsvAyNXLIBiynoPppqpjKfOIUpcvcaJUUPlymCEo",
		@"zYohIElSDPpVTebEdOCUbYhsixbrQSakjrDGrTMYuLRIAfHfmikULeBiNUuLPgTqxRWqcQyidQVIJApoTqrfmiZOtVsQAGUjYXBvWcXVdIuvfGPJXuIVxLFpOQSpOnPKXDbGUfPhU",
		@"LChKHJMNytkDFAmLjazidTfAHhlpllnDlvFPseQIksTXTlzyuaMvIumJpsGozvhjIAaFhiWnMTiLtwZoEPqISAdxQkYsdFbyLoGTa",
		@"vRdFdCMZTzUGlSRZGqrCzWFBJhxzBOLhzkVVvnEFPxTtExBLkgMApIegsyASPeSHkrLSxfedrFSJNOYimabegquuWHtscZMDieiZaOqSEjpPPKfgNGqiXZckvyenxvRTXiVud",
		@"uArCuRXhRkWiANVNbvsNdGuhRESODQASxXYKfTTAyoVtOUmPsgVNmBusvzZvaddCyqsFNpGagmcLsuzzMlkRNBegXgQffCflAkyYSiQOEGuwrIodmeJO",
		@"BYnGlXHdmvXPhLbQkXnMsxPFFQtcTGaFJgqoKlrsoVBywcmrJhxHQeCVnlkKkSGhFseNHLexzwrRfWCIFMjymbzRVogXAJBpOwCidkbhOgDRD",
		@"rKOzaVgLNgdxxellwRDZFsLOykhzFEZMZPEjoHzBektzRdPRDnBUsZHswGKJndmqsblOQfGvDPHZVNdxrMmfQGAHanrupFlyclZqwxnhFwreVvTiNLmHyizTNUnQgGHGKwS",
		@"BjzsEFwZCLHEogsznnMnpClxEeSKPSeXjUfbNdrFtzQLprfWDHQtegkHyWMYeQdcEkYfzYpxSuqQvtTajCLPppSTDItVphwoEDpvekMcaAHXMgFNLugigptb",
		@"JkqdEbaUEOjrdhaMLQaaAxzBsMgxRQyxCOCsCZmSXByRojznHjeJSMaCrSzmXmUUyZqvBEXRAUzwTqjWAyQjzWmsbUDqGyCObZxdqayaxZFEgcBkzxDFbzuMCcBFmIw",
		@"lHGpUhlHAhdIxylTnfdmBgZqRBDrCdwbQUnONkIPcRHnkfaTbKOxUxTwWPAYjrCGCDYfrjaGzpiIXvNZyyUfQyvUFRPdCWaNWPozgASDvvDOfhoKtMscPCFqdSmkk",
		@"fkpXeZqdsthBscavTrSByreVLgcZKppShQsSqMbToNLKRrfsuZRTsTWkFqcjNhmMmtTUwPUyLwSJqwKRDzjmdlnzbrqbaBvAFkEfRAgntRelLtNgoORuMsCkrBPnfdtm",
		@"dkINWnzgOxYzCiCJaKmmHGuDIBnLzUNBXEEvIanoJkvsHFpSrmBhaESlFJMwOHtGtcUViIwohbEfJXlKpiFhIpHBAWoJoTVGfqJPWBFMgffJqpBrYHCdxSKhu",
		@"tDKQBEbeTsYZpHbJKKJZQGczXPypejnSakRwjyUpcUcYCkcQVcPjrABoGmrClMesgnUyGfLQDCGtiOCWxtDuiHyNRwydFMBujwLctCPLPnIksk",
		@"kvQVyhVnwFryuhrBkejCLCBkLsSvNbCbRyvEmJQBLjWgbRxJrUowVsoHfrfspIAJTvmtIwCWnGWZqzbnPGoeOcWPfBPpVMoFSVGUqvrGAuuXYazcBcQBAiaCKjcgfGwOtscLkuRJ",
		@"nfzhjMGSKWALyZWAmlkWwkCOcUEKGGHWrTKsRnKtixYDeoUDNGYHpQFjlolpubtuQVEnxOvaGOREBBzFeZDssDXmjUMtmfAXRYMgCiBrt",
		@"SwsvXMlzmZbphFrjmRZFChwZOiCqrlTCcPsnHWtvBQaHuytYZQrpHlwKTrTWqBTkNRgglWLRxjJDeVEefbPhmrjgicivjvfpNeTTDMaqqGbqAsvCYBuWEtSmFnTIDtcuzNf",
	];
	return wmMWMkONDAxwvk;
}

- (nonnull NSData *)uljrFAwYrUCVoIL :(nonnull UIImage *)XzCAHxJEkjLQ {
	NSData *dONRJcakgmdMvJRj = [@"EfiecvoqmawGwXMKEEQLsSbgyLHxGfoIQDtCRgpZLWmAYAPVHlafPEPvRdHipLWcqlhfKogXjzIqcNWdBZAUdsGqLkjvohzonGoOKA" dataUsingEncoding:NSUTF8StringEncoding];
	return dONRJcakgmdMvJRj;
}

- (nonnull NSArray *)NQzCzOwovqf :(nonnull NSArray *)VKVNmfnzbLflWzy :(nonnull NSData *)NdpqFbBzgbESWiD :(nonnull NSDictionary *)tFrGSouWltpZaJdsfAr {
	NSArray *qncxTquHRVDTeEuF = @[
		@"xjqGUNClPyoVzZBbbTJeohOIMabBHBuOyUkyqPhBtasPQTBuBTMTiCaLjvrkGuLhIDVOtGkltxldOnmLFIkuVZrvSQThCkjdGUXqmXH",
		@"AVQaYmGlMyKLawLukkKvrBujtPHTminNtxmoPavdsmMGAZOiBUfmgaWyMmMrIgMebdZGRUIxvmEfFbEgPjbcgbDOHAAuKfnWsakyiENaeIvZuuzFKkXIXQSEz",
		@"HHWOvDDAaCRxaPWjOqvghxIlVAXcGsImImUXKdukcgYRKWfxZboiBoGVLLNYKLyWlkKxoDzgaluLaoDRKqnpoOIjzoNZFQGoWEfqiTXODA",
		@"HYMEeSsZMFXWPPudLsiqaBITwlnDxHhWGwqpeKuzTSBnIPvmEHegdFCQeLGNCCCQsqAhtBvWJAbkGGQGqcvEoKdRiVINTtNTBXTxvvwZUPQ",
		@"ICShBwYiCHyEgvOKKegCsSryvNnYQxVmanPsFikuygVdyDmJXEIobajTFcNWiOrIVbIAogYBtPRuqmFnykLgTuxITxhnISmNOuQiKUyaIpHVGyNIMqdInPTKw",
		@"brYymbPeClLVKRAxgBdttjvrFfZvhawjebRFRMrFwiYOjjjJMUgWVmTOkkIvTPRfDvPobfGMbwPueWWHeENAUgtquTpPdRRrDIjNjocIfsDXslaDYpIMBMXMCLiYffRbWyiFWBsJzDflxcGJD",
		@"ixlAKrADXYeUTVuVdCbDniqrlmsrAXiwYlkFyrsAmYDNATYccfkjMCstMuHUWVQRKkGuDFFfVmBNQijHXvRkkZBwMQcQKbrQIMigLZhvSbmBZuWvyefPJTZBVwqNDgOmrltfOUlJC",
		@"TBPciCFSUmTeLMOeWuxZIfEyoCfBlINEqrkypcxnDePOejCIeKuJrrshvIMBCAyjIaFlfQfELlpKMjgeDGjOoBzKOHXdlbgDVDpRuHBdunEPwHcdypSxmvfVQdKrtKmff",
		@"QpYKCnPozeYmStgVJsSHgYbxTofDCELYGTpWrXDEToEcaMnLbAMbxRJHHeWnyRrlIVnbjwlBiQMChTikSAajYivXOhpNSEbNIgfUgIWvmqDwaNCrxDyipivUINibUPKVOIEORmyPmnDTb",
		@"hBxoojhUnretdOyaQXkoNlOQqOnfsHfQFJzjGAQUFMzbHoKcVlKbZhGpIgcIvvLNHpoHmRUYcGZFGJeSRuXFEaZOmlCNfvZtSVwwzGnBnHqRfxGMklkFdnUNrOWcWvaqAvx",
		@"VSINGfrYcxfkcBCZEXMREEOdlfjpDVKEGCgMekBEDakkWRMRxVaSRgOqdTaVWPwMgXpTRImqJyWDrDdYguLvNBpzWkgsBsavjiJTPIcOmawNt",
		@"xVObpeWvEdOBgDZIGxuVlmNwYInAxuuwJLMrffetvwKAHSJLtllYaYaZvQghXkWuEAkoXDLKxLxRmVCjlmphkPBKFRgDBkgtboNmhQdmsySMWzDKQiauLeYdjPWdccPFYOQkYnfrogASsdszo",
		@"RZxaQWXAoygrFaynfFeRCTridSBuSWEAHIHwJjXwojasQraLeIiDlTcEGwxcioSWylqdWolrKrhPQSFOompVDdETsJqAubgvdvAhntcpcbbzsjpkVdfriTUcDieyvFuysA",
		@"wSVmhEOmHGaikmExecGzmGupJmkvTXXGlSTJmUfMKqBqtVXCfVCtOAdXlHorecjcOOLWodcsQZyUNJHvogURvMqOHrekNORMXmBEAdAhqJpB",
		@"GcuVIAnwQawrjUxMBZOtMyiAzatHqplGvReqcMRuxQwKsaLAhJfihIfaMOZSCocffKQnLTduerTdzXQjiBevUdnbZjhZrNebtFhCStGMZQuBlveGPui",
		@"AaKAuWntlASDaPtdEXCoCoOGZKxFqEzQqesgsFcOCrlmXNNOtNwDlbcRxDMqWBjZdpaNjRZiZXJPVEciSTfQUfbhlrUcPPAcQojmgwVHvHXB",
		@"RkWBcbnOVgCuMjAPEdThcguwADetLsoldpKBjvXtmpdLSYHzRBXUmkcTpwXBnQGwdGwQxpeZygQactdgCXqNYXmMhdJnANpJZNGkRNvNUyKyLPJKJnWbYPYxMIK",
	];
	return qncxTquHRVDTeEuF;
}

+ (nonnull NSData *)IlYIOYGJzQmiMqqoHhv :(nonnull NSArray *)yvPJWKapiwUyuVu {
	NSData *VcipOtHOXpQmcFmR = [@"gWvSjUHBuqWzcZRxgVeziBVFSRJdiFzmpvilZZgarMASVNmhBYLgSIRCvuvYUoXpklUMWOZSzBWNaaOBrTLaUqOyCoQyWeMwQandkABqwJbhboE" dataUsingEncoding:NSUTF8StringEncoding];
	return VcipOtHOXpQmcFmR;
}

+ (nonnull UIImage *)eljDixzmmHDEt :(nonnull UIImage *)OGNYNXilBCUKOvfhQuF :(nonnull NSArray *)VHOaGCJnsQJQJzM :(nonnull NSDictionary *)AvFtJTTGBDqZBwg {
	NSData *cduJNWJQsg = [@"SBlEeLqRbXlnHymkryKFletnBFWrhuZVmuiGVmqmDLznaMdVvCQVpjgJxvoaONDrKPYpRAKVzwmIxVVuHoZMWlwJQekQpKeBsJMFUcW" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *VIGDsPCXRBkMPpqJkd = [UIImage imageWithData:cduJNWJQsg];
	VIGDsPCXRBkMPpqJkd = [UIImage imageNamed:@"wnCWGjIKAkRCvnZhNsuBAyCUckGQFNoClOiGcuvNibygfNnBASisfGkafKRDWTeJuFakMHCPtvSDQBFzTUweEEXKPvyEhnRsTGCqQmePVUh"];
	return VIGDsPCXRBkMPpqJkd;
}

- (nonnull NSDictionary *)EQzYNcxNFy :(nonnull NSDictionary *)NkJpdOPiujHTukOn :(nonnull NSData *)qFrLSNruyrbtX {
	NSDictionary *ueaaLcpduUWPLBw = @{
		@"JLwzzKYyOsIYhbnJf": @"wyTytnoBXfnxhwcyuopgyXeVAmbfhHonQyyMgnPwaKmnHVhCfgAhaWqfGHaQoLBXoCmKowApDGFjqUJbexJaSVNbfQpdQNQQdqtqVfmNtPpJyFlxzzqdCLmjBYwoaRahXiEvdnZeJHn",
		@"YFxcaTuJBnWh": @"pPFPiICPQIKGwPGEsahjtTULjoqrMDAfygjYRgEBJNsZmkNOXAdyNRzpnvOUjcRQnCYdEijfCoOMiknSGVhHvQljvlHnuGIjLxpPeKFLrgngmCTbSdodxyCtmnpNm",
		@"hDKzskDgxIdWSYtI": @"yLiTLXrsbkQbEINCmGCTPQVIqUPYlNEEFvHXkuKriOtWknUZWwGObUdJvOnXugJOErQuOJLxHWFLJLnJaAsfrOiusbVpkJKCjgAvlpgQbtXPSYhCFo",
		@"VuhRFNhIcL": @"MypwhmQqDYiRGxFzOsxyrfeBfYzilhZWomNquRWBROeLVMmXsDXDQSJHyCdXIbVGxKGwgiVimpJhqUupzrvfjsWJwVoJdHEDMqxKOXdoRsguaoqxcGnakvwQwwcMtYrjhJM",
		@"ylRqZVugdYJeUwyK": @"VhHOdBDzchbjoAalwWMuesEkwPuKiNlgIhlWrmZmPqMXtqYnLDpWBjnunrGGpPFvNwbNQavZrBBNDqFPEgApFQtMsPQZDoLyxhlCwwDyLcHNMKeOrlpYyPGYohdsBWCXUsGHhckdS",
		@"VlzpMhSDvLGqqItXNX": @"xzjLFgOesWaZQclHUitmPZmvSduguZgAcYvOmeyjVuzdweqsAjarIaLqumGvkPlVCxBwPcQEakcYCDyjULisGvukOpkUqBdtnhOZPFNHJZvblqGzewoC",
		@"WGlmwsiUNWNkHjt": @"joURwBDBnTiPmDXUctUjXwbFnenLzKiIfkOZCdmnBrPqihaQHVFrgGsWGNQJBTcETWJPoZSoRNjvytRyWEwPfORqmbsYzUJqXNkyotDjqBIFcZKPMYnslfeOtYxckpjplxNqaCfJNPczr",
		@"mHJfuXyeCetToZ": @"XlanWjulbGThmkSXcQaMjjrZXwyQezEyyCnKkASAHSRTgxteUnFaYzaZSehFTgrinGOAZQNeskakepxQMcFvdSmXguttGaDfrEMqxOZyIrdoEiPuk",
		@"jbfrnGIZwwvGkg": @"gIlfhzNzARDvsVihaqRwousFvosZrpoKoEMIyxpGvGHbdgKBakpUFQLRuRwPDfnLTMTZnmxbmcryUPOrhjNCcPeuHiuTJqcbnbXBWcTKEREcTiFANjpgkyURjRsYYXhsBIAlCTmdrDoDgkmXjv",
		@"OolacEXTYC": @"oZUMPbVPDaJZlbqgfGgQKjpmriMUQqmUpSLIRZczIjrPyiIMAhKwVJuBqCgvvFDuoJqcQJBddsNVsBDSAavhGFICgRPmgqUJaCAPhGlVawwDIztgSIEvtDmwdCQzebRjbrAZkJmxj",
		@"gJOXFPwwFjAoRzkK": @"FEDSUDotGmsqUNwsItZgITheVpTaboNJFCVDWZBAZFfkYpjNsdvioLHyDDqtVnSxDSSjgEvAkAZrDvipskTCvSkinuKLEldiOuVmRv",
		@"gIkboaJvPnXGYNn": @"ePCAnNlinaAADOArWTpNYaHXlExFquXaAtuRZcHTRGYqwHBETXTAxsIzBhkEHcKXlLkzigxXCeflhJtpiyYralXAqJoyjPQuvoQEHiNZLmmmZLMzO",
		@"bUheyatkTt": @"OVlBBngrcsIngVJOjFQEyKMYWkNnCOXoHKniczilJrJWBuodKwIczOqRNKesOEKjLRymxsTPZgFVgUiaLCigFKltAjMpPrSaDoNjlL",
		@"RZEiygBJYWIx": @"USNIsVHzUYHVgFLCCwnaWFJFbKkBkgSMqBldHXSsjYXFefuJNEFZHwnVtMgLPfOaltQYihIWUumWBdFSWGEMOZUXwJLmpESdisvyTksuMZvWeEpHQvvfdIJtwjzjZgjxFwSb",
		@"JbuJoWDygvnAcq": @"BDLPcFukbfQeAKQwhlBhTotwDIPPousMxAuidCNibtDOJLXEeaKIIqetXyQZAPnydKtoionbjEYpRMGnEWeuGTPksJJVRcSeYpBNLpTFDrOYGWVEqL",
		@"lrXenORtfxws": @"lqTrfFmktnnsxajotBPtCcckaTSaypgvyeyvZYujnQpxbxaRXiWRsSAzTiKzEZAFNLuIRMHSztxbqwJknuALZIPScIjIFTSnbBSn",
		@"cUZZjMJhukMh": @"dFHKZwHXnPuoqZtsgLVxidZAgHAjccTrCsLmWUkfsYfDrijvxwiWfygXpaLDYQWcVhkbBCcVXSOoGKKwYgnzrQaIVFFXUuCVNnvoHhsKikfiYUBIvnBi",
	};
	return ueaaLcpduUWPLBw;
}

+ (nonnull UIImage *)WMnttUiqHBGdHiU :(nonnull NSString *)VDGLjHNByCIK :(nonnull NSString *)EUathrzdLV {
	NSData *lHykqvInqXpCVkKNC = [@"FnEPuHVZKSXWuuGavgetImjahJAjeIkwlDlhvSWrHUxGfpMtUAHRTMYhLBoAxSKBqYFtkUKuNZAnLDJPntxLXBTARhiVHpiXesQqpXJTGjTYvvNnGgYUgFih" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *xxyFwmcgyt = [UIImage imageWithData:lHykqvInqXpCVkKNC];
	xxyFwmcgyt = [UIImage imageNamed:@"FqQiqiSSREjifKDWFROnoTNqUtEejaQYLJjKKAIYEVclkzsgaGSjfXUyqikjNGYEQiMTMjzNREkssWRBrdIroppjWWnzLRrMmNjEBFsMrrQMervRxwAWbnfY"];
	return xxyFwmcgyt;
}

+ (nonnull NSArray *)WFLyXIooMef :(nonnull NSDictionary *)kYwoYpZCRHSwzQddf {
	NSArray *jxWMvvpNNV = @[
		@"EePvkWwiwotNOGiEAMXdMgVqiZcBPcSyIQbBCtHxUqIViTGytrDenDTZNnxSKAQULkSiguOQlJNjToVYBhTUtoIPcGrxZgjPsNFTxoBEfjuKrvDrkRDsceqlvQRehUBIuqBGKfi",
		@"GLDVZFMGUZmYnQxBmnmkFjtNgreWiebNZPtyHbHcbgYhwrJxFtYbAmVumJWOGRYGzFfxOQjOSjEWTFhElKVKAFyKVbQRUCYULvKhwmDRgSwfIquaWTJzpuPVBzZoLGTaUyL",
		@"BgjsBvcJzcFvwqaeaiLqjPArgbRsKjxyLIiBCbajZcoitsAUxFCxJVxluEhspgyZanjUshHXjqxpDEOCdayNlTvoWQUwwcaYSgbrOAzIKrgiyIBbriizz",
		@"rbnfzZqpzXqhaqeISjETipdqydSHyggqJbWNfyXObwWtOdVAyAJSdtvFCrgzDcFaOOLSMdzvnRSenaAkreOTmnjDnSMkaiYwNKMIVesfIicLPDHLYYtYCZrIYTNytJld",
		@"CFlpccICiBQMNvCzWVtbtgqMvbtpjZtreSmVsWQrvcnYHvGHtugxbkRMbWTOCkWgAMOSuJfEECYpxbpDywqynzvpnYLIHUeTiYjZYlMI",
		@"YpyqORpFXWYXmchrjMKtzrvslqgfwseacqoHsYFOUGYENgkkgecnvrjReCypuDajtlNnqEELUBhOrfseYJbzsiwJZuXhXVcMhlwllcpnL",
		@"QCfHIFnFYLUDdbphHWhVZjWSWYwTbrnHTlBFMHEgTFjLuQJZLqmUbtThszgVEwqQJIzGwJOiXdfIYDVxwTyZpRUsLEwlVMuPELmULjjlghjlQsiQngmoyMytRCq",
		@"HRehwvcHKUTDQdpJhiSYseYFykafbWEVmgEeScwMjHVgIrsMMfkagpTfAKKwQgHJUBCmQDjptoDOVzdAUwZGYyivYwZuZoBByzZeFAOAWCsdYnSAorKGbFrxglCLCPgFqfaNAXKTu",
		@"PFdSeYHXsVpYqKNWKsTxZINsKPknXmZPxzmVJGmnyVrTttmPUlBGkGxNlgnzRMOlNSTjVNKlWmpyKCNBdIiZseaCvkRBaqdrSUeQUFdaqKxQYGKSGKEIaNgclnJHBFwenBuS",
		@"xnOmqxkdNFSxVVfXTydsXainRthshVNwommDLftLYeGidmfGezbSIVqJNSdlRVHNJpmQCgkuykswytcYgJfpuTRFLSZMbPbsaaRwsDmcGYBotRuzc",
		@"CxJGzYeeAFtLEhRrplSsFQQIiAiOMGYVdeFrXYNCTXpQYRbfzRKQHMezcqDzXwMzSroAQPvFQHDgxaoxrpgWYWlyrDHvCtrEepywgCVgEEqrCIwWqIGKbsaMLsYcmhUVMbchWaRKymrzBBUTLUzEu",
		@"ypBPGhJVPKrgWJfsRXalRfDbJRhukATFcSCGysWGMuWFuiAkGNeCpaolLgycGMwbsIZXcShCrPdbEQTQWcCMyPMFiYoPoOphwoylaPkKyfhcUhzBqOYGTvJDvqoVorDHMSK",
		@"mSszbcLmtLgZUaprPxSvMogxQgpDMiXtjpiVeUMpTSfNQuNxieiUpmbdCzxZURmPPXJttvawrBnNLMuWDwIRqliZPYLiwODvRMnhHndEmlzORBkfFJzFGczsOSNcfvvdcaxVRdQtYGeA",
		@"dVHgmFQkDCFIAscoHcoovFYArkUQgqZvOhMlVIgOHseGYTAXILtFIYQLJkTvVtFZjNKQagxsrxAdYvkRikTKVcCmyipyMAjqNPiJqhxRJWDFCTRhjMJDPqFOYmA",
		@"laoxsiVJynJIchWuyhZhuIhGWtixQOXNBayWnvpHmoJyMmvdwnXQLskRzZwSaAWYLHsThBmIYCIrxBmnpckwxGmBsfXxBFznpqgNCsOojzIIjckIEmoZ",
	];
	return jxWMvvpNNV;
}

+ (nonnull NSArray *)ygvPzxnjPTmUa :(nonnull NSString *)SPEatCNwPiELgEYNyAU {
	NSArray *lAYSmMvPCJ = @[
		@"YAZKPMtawnjNLFOGBvwendpImwSnMrcXBjrNFFLnQLwWbDwjenrgSwKdjciKeiojbWjJgHTObipIkciSXHeamVgtWkPNTdNTydWhXwpQvoBRobFNXGPalGfjKM",
		@"dRbeKbKOABWgOPUByWmZJvKAKxjeLNdnyxfaxVHBwLFNBVjyuyVHwlQyGaHhVOPFgcalhOndAlxYuBYQNmICNHiHBuAQLJzGcFTTdGZHRoKIAbCKNaXtVALaTsVALrrniLKDdglDqvWvCfJJUIoDW",
		@"ZCcNrLaUTBiXZluYlgPHuMBnoMHmJozivkzIaXYQnsdsnomOMNSRIwejlviWwBXKTzHgKYIMBlzVPfzmMUatAHCVcgeaYXljTUpebMdZdencKNrwbXXYPocxuTVEOeHqwvuFj",
		@"RrnbliGdmglRcsOUDMgBhAcxDvbwHddLJkUzMlzvkPkLyYeQqQAdzBvUcTZVxrWxFWXlGhkdyzVmFvEMtIkKoBNCXuFdyYeglHxcNGSZzkEcezNIxgQinrnKBrpj",
		@"tmLAtydtePJrnPRBXUrrGWfuwfuYhwpWgjwdnzhTfKcSvdfoKSehpVbVnpGefSmFUVFuCQvNsHwEbPxUrxbwWDbjkGPWtqxIRBPQCKqfWEqLKyzsBCaQO",
		@"KkQngcSySaFrdbjqHqSsoRDxIrAdzuYDyHCrPPnHqhhqokuMXEnBzyqYZNaYIIKTvfNahMEbURzNcYbnaXkifFpILmUSVIlAxwYJbpTKgTHJiLCcjEPmqKmcVHIRCeNhaFCJW",
		@"JfKbdJHWwRdjAFRVzlVuLOwUlvdZWgjqBAFmtusNTqsvFsKjnuSIWeoCIdBUDshcSFVJAKSxvkMiEkVEFSQpcdAmlTuohQcHAhMFPvfiIhxKivRMFazDYLTcNvNsjAFIM",
		@"WPHavgqXoQmUywiaafBzIcLwtgAxfLzHhAhpFJNiWJMwMMJDKGHrLBqRdHkZMPIyGReebWXnhAIoZuMZNSMUQehoNvMGWggnmJHlCHTFBdFiSpmslbGUycANAXSIoxdRlLezNVTSPMe",
		@"KQEQIFzjMXqlLNOIrHgUIqiOdjpkGAETnjbMrlKoepDpperIHsuCqbHeHNYOvtIjdEGLKVQilQUtaxwsGhYmirHsXMzKhcaUaWbjjXOxMhzsEJg",
		@"fuarpDpzBpOTFNySmaDqUDBuywpDkwkqmWqSbXKdKSDxRIunIGRkgszuXlXiTnavVfjGCMLJSgLEDBCBjwcoFVgNoLkxBMaaPZeiGZqbyraZkjTxNkJYQAgIGGjXmaGaIjTYcfjMHmNBVgpGQFD",
		@"cwrVzstATtMEhSXEPVVoXZsIcaCwbAVFgrTXxVTeIMkCnWpiuGVnIOMMtENenUtVrokHVZZCNvWhePZUgjcKtBwirvAPwkLMtBPKzQUA",
		@"UMkcbAdwLFZowbrBBFeaUrsQkSUQKbmTizkHlyTFTHeWrSZTsEHTgNIyPhhhJqKLeRKMqoyeEQakGmhZGoZnPScQcSxJxfGdJztJFaqjCBFmAOVMGdygkEcKPQyyuQfDyNsPEjKUNzLTKo",
		@"VDJLLUbbdNNGrsoPrsWpQNZhvkeeHEKebYOzKOXsWKxuuWUxGWLVqTUzEFNlyQPOEcuHaiMpUHMbQipHFgDJCADqhPvcICqpjHZAMypnjn",
		@"gJHjkeFFaxpSBikczDGtFYJjDWwOJTvNoyKkLnrdgvRBsmGFUXFwaHsDekfYhIgLCRddIAwcltAqSesfWcDMEXJpeMitwyUwhpLyZLTObWpXIDTzUPevQKYWhQnwrSUyBdAvH",
		@"DyHzBjtNectrFJMrBHVsxWulGlQsitDOcevcLzcPrUYxBAWCmLRYBTEUZEneJGPYyLPQLVSJbigRrlTBgZckLYVNSzEfiBjFykVjxFtJbLLmXxPvqpxt",
	];
	return lAYSmMvPCJ;
}

+ (nonnull NSString *)MiDGBSqbkIZYytBT :(nonnull NSString *)fELASPMyqUGlf :(nonnull NSData *)GqLDarXyoIivavuX :(nonnull UIImage *)cuJxGmWMfdCNGfA {
	NSString *AVKmFZQtFtk = @"YgXUKYrNGEwrDqtoBpbEYsuIksCSoxOETjwYPLvOcQFhWdEKeOyZhAnLpUXLdzdyNMvNEsFsvlIXPJtmrmmzVpnbFhGdySUBIAFKHOlfBdxycaHbMdtHjudKAMwyqgcsMbzvAtnnZMtdvHxZ";
	return AVKmFZQtFtk;
}

- (nonnull NSDictionary *)KbfbjfHuXFzbC :(nonnull NSString *)aWLFsMAgbHAHuCJP {
	NSDictionary *EIRMUGLsGzHJMf = @{
		@"omcvixvesvpbTGRsI": @"QkXkGMjUYKBGURYrRerNZAjvvEdKmYBGQzyhglVUcaYePdPVIMcbDVbwbSQmAtCJpEegvuHqAspQNxeaEWMTCVhFIPqppmWgAdIcoEUfBemdXgrd",
		@"rDggdjsrlUUqW": @"DirjnBxMoyyyPDgPOAlAHkTWtDkAmzVmqGuwLgZClQMuBbLcrxaeoLmWCklXKKXUZIddmcBDanyfTDOSHsqFBiRZWyLpWQbOygrODriinrKYvleNqqacwVEB",
		@"CEpvzKRXfzbOvSTt": @"aWINNmtoVYvEUXOtWPLixGUTxwRelOYSzRSiMieZgpdlAqZIsZbPUJCRHBxTUkoBXudiGxFwlavuVHdyWsZnDccZWqpJmldJrBqzxzsXfPG",
		@"NYZVZGojBvuyBGq": @"FfhpTTNdhEgOKyUyVIBQuNTDPjjxkoCVpwsirqdEUPbFtIzAeElXPJXiCsGgfadHLPnaItFBaKNHJFaJCFshIctUupTOrCrShYpycPJtPmUZQqYAt",
		@"JugPLGftyCAmLutf": @"PhDwOicbkOgmfPmNkDHOZyftRZkpqpFEPBWKHLQSDdQDAaAvBhvRnvUTxTFCmKEHedFwkqUFwXgimfvwvjybqgdFebxMRkAAWrnkVlXRygqLMz",
		@"XUDIGtiXDiNtaF": @"sZcIFLPyTkafKXGVZuzaXBUPJXRToKnJhwMrOmLJywKPFwZLDJFIIJLiFfWzOTxFxAVGhdmqWBbredNZGMwwLDibodBERDIJsBdyKIIngpwHELN",
		@"HUoTJRWFwVSYTgsu": @"HQywrtLZRFeQzsSlozgWHjqIuDWNppzrWYLnEdZueaedkHiGaWMoynoniafQMvoGWCkVWORFkdwoiCWwuMuwNzoAMpyjWJwmqlSTEXvxQnLaLKUUprxUQeHrvJlTOhFKiKbdGA",
		@"AtVDEyiYbHOgxqt": @"NXIgmKJmaTaEQEVFSQrUgVzimUNxdkmBxnguUxgDbXofHIEcoOoHQmaWRNAjpjToQZfphbvxTfEPocMqNHYFBawpQbhWihlBbXmxU",
		@"NDDFOxbyFD": @"FifNFHxDafSnOwryDsxWUnmAmKlxjyjnQCVNFzfISYPQLdGpSBEdmRfWatwhUnNbMfCGMfxFFEsAqDLWYBFrFgicWYqqQwcxkdpXfchCbXZMoSUXhmKsnPzcDdaVMRVPbqAssSCnunwrMvIDB",
		@"dRypbQiAfagnRJ": @"bjKIcUOmOFEGulSQfrqHzjCUyurIZBWRDuhoeHaZXDVotKWDfsokhlquucsUVJqFLuKzOasJuBVUFrSlRBbokcMvHEeEPyylagGfrdvKVKvGR",
		@"StdFCWUElM": @"lXBcZZqVhQMpgGmumxcRrGeeROTdnqgEqpShgXjNVWWcqodwJjcFKALVNCdhLGfyJveNoairLpBlcoPWodAgEdrzZrWplBHnzpNhrcDcnzNPgXKNGBFlCndNwOUBUPEWLxDGXsrStEPwQPtcv",
		@"BvQndktPSMl": @"JDcJHFkohAVtfJSNWCvVUyqtldPuFVIJpjLxXKBWMXxqLrxcLPVeQSywLKsnaxcNDtyrEtjqvfQQurNcBJdXfAgnolTHhrRoktWC",
		@"wCQcnpxoLJ": @"pUUfUFMZWIcPWqRpTbUThtKWjmIMjTgQpYCZDPoFiYUbNPKdAXFAEmyAJETdlHwsXxYkNbTpJlEJDntJkEfnEtREpEHeBtvfgVDuVAqy",
		@"dQxdunVuWyzMMilwLpH": @"CesUijOtptxoMkulDCuAOjklMUVhCYgRZBekcUlLjMAJmYQRvRCeKsEubAWbUPDYjhybCfbAXXDtPCGJJcUracKiSwlyJoMWqOhGnxHuBMgVsjcJpfw",
		@"tKOCVNZpqvl": @"moIAVHUJhdRocSppGshClSGseXZXWCKPMynNDYhzEZsejVLpuyHwtkiuiQTfdXADCZwpQhBDyNxPCkROlWcWkGLUigbwlSGAEjGQtLFAYjgccBxQhMuwgUisqhuLdMon",
		@"CCXTrayHXoMGrZg": @"vuOhQPoXoBDlEFgCjSDoeKtHHhYExkcWydpoSzqfWZzEsenPeIMhxgirbmUeDSlcTWNVRyQswdgWVqhHKlVViRIbWXciKaWglqecyleafYWkvlqZC",
		@"vZocobphVnSw": @"FMxsenPcIIxVJAJcGASlIEocxOGOaJnuAZrdXnUnHXtESlacYzsHOpVetwcLEFwzNkOmujlLmZTWaSmoVTFWXOlRnwhCBTnyugHzph",
		@"gXGSkNrPASfNh": @"gMjOARMKTmZaropLZXAApLcsQpYqWKlxSHhCjuuBWNzhwwkJiroDzFAzZVFMOXIlCgSkLlfYrRUwDLAJBITBRRpQZCyfRqKWdklbKhzAdUqqjCDKGwlPXVtwB",
		@"hmLXsfzNDOD": @"cfkHXGKQvtCfPgnfYawnZdxbpqzXPjTgjBjDlEDoMImLtzosFRfAtMLACwJdljUqiERiGPZjMGTdldSoQYoCpdiGfQtNIvSPjMJeeGwGsrOrKICbNbbZSUtwXUvHmPtOrhuNXyPnTW",
	};
	return EIRMUGLsGzHJMf;
}

- (nonnull NSArray *)kTKxZUVgHpb :(nonnull NSDictionary *)MXQsiLyJzApGr :(nonnull NSArray *)QHbLHakDznNgOFwJN :(nonnull NSData *)gdYgWehurMdUfM {
	NSArray *GbhuahTttZwsE = @[
		@"dHtmwPcyROvatZTAlYJERcfkxdRQrdgUmmqTRldsAjqykEoAZznhtsJiDUeccIcvLCDohMSEmtQueffWMfmcvvnSSDDbSdQVDsrn",
		@"QrkQJvlPRsHdarFnRYggXpphOZhmGUKOAYGPMUvWhlIbkwuaPNOAYpwuoayqyBjXDVYwoFCezQOJLORbXSYDEzNcDiziONZviMHujSviIdyJRaSusAWKDYuA",
		@"wDaoYNXybAyrLdgoXspPOZzIFeQaoiEiFEauhimsBmLXXbScqOPYCNSjhnkLLgRlqYvqcbHIqleevCKFlMAoRBgDqkgfobrFMyhJcYPtZeJKPQVlzLYpHNbzDWyHuBIKzo",
		@"NoriwUazTDRaUceyAexjNOkhuDGnNKYoKQlWjmkXQkRCRMddNqpsVCzBnhJCWNPHXDCGfTmOzDqboVpeUwTjWDemYwncHgrDHcQhRgfelRpZfaasKchpzeQA",
		@"dLyFCFWMQrcsHTcjgDiQrmXhyYEvnbfYKnvfCxUKZjjVnKzHDSEqwmLXdnbwYEvZSPNqvtNKGbGodZBuNMQvAlzfDerEMREBryyPSzGDvtlElIDPYjlJWmkqtCGTqAoJYZp",
		@"EZnctxAxjjsGfXgzNXMSFdaQMhgodXHMmztASrsrOelJPwDUGGgdRkrvnKCqUmxHEgawlNFckOLufACosvBLpYAfSKqGoVvSNXrNMiiRgIJdJhzmryKqoPokinkgMokZEIuxVOrUQPmu",
		@"pwPSGrOjLwLXjqcIQtvYjaIsKTJGBYzYRDQJGbjYGHQiJsqZjitMaphfGpKCYDEGuFmAlmnBgcKeXIDiKkqOheBUNrexMciNCsuTjRBTJpToFopBGPIoG",
		@"ESQrdvKrtVJBxKiBvgbvqCWQmtHAcRWfZVemVgywrrqwoemKHqDPNMDRNfzspaDmoyCwZFnQjUCmWAxlbwwIDtgrYSzqyBMAuDrMkRkPmTwPrkLL",
		@"ZsbcxhfBTeWkxpJIDkMzvnCAAcMghTafBejuKZYJooKWGQcgXzSYBLDRFYJeHqPsgmWzzmBYBVKdNzwthnWFxDPAbXBDhrgIPcHGBg",
		@"tiOIVUCEYtuyaERNlqLXFeSpetwTsTvmiABQzSimywDQjgvhUAyolaXkLfutdGwKGtxdqfCUzstoJGwpIGSfyyUrjUoXmsscTFNqLGQJqeUSFCiyPyirlCwFReDfiiQL",
	];
	return GbhuahTttZwsE;
}

- (nonnull NSDictionary *)cVzVGUMAzoOxdxKz :(nonnull NSData *)WqnFrJvxgLqoOS {
	NSDictionary *YmoRKRbPtmJlVomoyqy = @{
		@"owdgIpikrkEkQHGxHyS": @"MDHzXgTRxWYuaWMxTbpuYPmXKaUYJtzbinpsgBGHLOHAtVVmpFrifpDCvuSskVZLXCMpWIVCRraggdZqFJVqFGSAuJYUGkMlzTYHmEEqFhglRlxmsgADcbPUJFzbSpnBPbgmsUgniGCTNovnptn",
		@"QmJiEzjuZiPLHvlu": @"AMGQTixlMbjsUvoZHzTOLoZEdCvLJxQkJhBSTYmGsQEqAGvOaXXFZOrWRRgosmYGmTLMheJUWgcWVEcLpaYXiYyEIrNRxHZEFDjJjKoCITgcGFQrZfpmqByQanou",
		@"AeyPEUViQG": @"rWLtJVkXQCDtItNAPKwFsOSHhYInOzTPfoAVCdODaJDqHWhvNVVpkGUbRfHsAtGPEekYVROuZiOKOmmnnRwVGVvPqhOHilTcdcyzsYFHZSEipDbBlzXlixTEbXGDCecHzbZzWEjZLnKYutvxS",
		@"lMudCQrWGgZL": @"YuEUiCTOgkwFUIPgSlyDjxvnhKBOmWCqctMIizwcovXQyCgqFOnnBgWFLdhZuDyVwIBPmjBMRGvTyPZJMDUtbcFwCsFDvxnJUMTiV",
		@"aJlDUnJtejG": @"dIObwrKeUCaCeNFTSdixmlPobYfZkRaFFYssabeeoNJChDySAdRksaFLpJFgWsMPOyDuwyhcuzEmsQoNnewJMLViMUttXZhcSfGxGRzC",
		@"EfPdIRsHnwhznxlbtC": @"BiIYYpTLbtkMbqEgAIqfEblCGCkTlbJkVXpdUhpLOqrCItJBZMOFlzBNRaGFwOJsCCFkZzglejdWEdFxdHcRpAUqTZsIEINhaFuhVHYvcEkIYIeowReLIvitzZLWoG",
		@"OIrjLUBVmllcYkA": @"FMCncuOusBLzJPWOrfLKwclfGgxUSEsjZauWbMNxwYHpReBfnqsTqnAesQGcPlfGXdqZnEZSPikbaOYcxScyeSLHoDzzvaAxNTvdVkuSqqHpJEBCENqGrlqbFZIIBxYpDeKC",
		@"jyKEXbWmXMQK": @"uVCUIJORXrZILTDTrjRshHkZGOAgkxfoXdrnYiwwZUrtbJgVIoqhCoaxJAacCNPsgjzkprOfzzoNNqFrNBkLulRrcOvotpEPyIcZmpoLWfPtX",
		@"ayFmeEFsgeqNU": @"wiOkKvXobOnhudKVxzKvKGSFcnUUnzWHMOtHdZROaSZWJZHYlLroOjDZDzoUWcqxywnMAWFFgdwRRkNeeIldhQTCvLdsHPQTAVDSGDupNH",
		@"dJvGXGNQgszWDI": @"BWDylrUWkGhZoGTafeFrqCiNvAwqPfdUuGcgsMhcWcDvScktDxmPPaOQGPgsVaQzPCyzHgjqaKIvVKyQzLKHAnmSwKeWRoFpdxyZoRnF",
		@"MXrxIqYEbLHCrn": @"XrPRkBbFJDIIlvThxjBQwixWoRNNZdWRsqbsOqebojCkpKpwmDzvTOHCBHyBYWeWWSpgSWFRbeAlPXcvSLNSqeEZWiDQFfZZzsrTLxbRRxGOIOaRxuSAPN",
		@"zPtOnfUYvPgkyAAj": @"bCPNtLMlcDrReDFGVCukvEhXXTIbjKLjghWMAIseDsJMtQFKrGPBxcuoRwgZcSxOfjalhToBBWqkSbxgDmFYUHbYClfhYVHikvygSvWcKSjTyRdvKTxDvMAKlpEdGbafVGbkwvd",
		@"BGfDSszWzz": @"QMySCmTATzTjxhFkyAYNUzpjVnTnpTDzDMvlaMKRJyuiVRBlWChPjDEjHCOuJSxNyrDAMJjqCQRMVFOLzRfHlVokQwgFFrKPpNEdwoE",
		@"GiOxoqXQStJxyhu": @"lcoyFSNETWxsSSRUylPKjMUKFxxZayAcPtaikmOHvuJVrMMBpTcPuiHGQPMSMErRwHSYNnPRZROvRScpOpNFMJRbqmMiuDNaozwTfRvAqzJDRLdlndkK",
		@"jwjvKJSNmmQ": @"EzOCzKXYspVltXjYANfzSiUVmWsnElRtcTUhSAVSneMUpyhURjgNpNutJyEPBJIlmtZbKGkEgtycAOFNaIpZACzeyXQsfONUSrxSTbdASDkIfbdMeveSBpEWpzjGYDQr",
		@"MXAyhRZsRosMHvJ": @"QnDakcNdKBGpsKSzgaFGDEvqlJtBAJaHClJVCsjwVOqehfVZwlBpQXssljFRTxoDmmKnBaLhJgZcKIKPkZlpwQyzFNXaTQvUMSSXKaLFKGH",
		@"mXTzWvfWmiSTSI": @"ZEkgffiHTTmZEMgdhCXUZjAKgZHFydDUFuFpwjIqZGSJUMwsiReXJvJPxiMlyDLidZOzUSHvXLuRsDIwVylzfjFVeoorVVoFmtAcywpJkgWNeDjIsOHKSBEUX",
	};
	return YmoRKRbPtmJlVomoyqy;
}

- (nonnull NSArray *)AAoNUyKijOVUzi :(nonnull NSArray *)mChKOTikow {
	NSArray *OnGIatBrBEZ = @[
		@"bafohMRimCGCCNsPnecoVWdEyjuyBWqwpMRVSowphUpPMuvEJYSTvWsegHcmEpVlUgcSNIYGDcSBbdKbzCoiqfMDMzENOBvlBFknLCzlF",
		@"SEvXrmOCFXfyvtsObxkNetPMnaJbvAWqpKRwYpwrebYdwavAmiOLYmTByQEIOHkhWOmjfcqTZLDLzqaxWobQMdiBltxRFDsUASzKPNwSOManlZVSGaKNQzRT",
		@"IxCJLJARFHjCzXnbMWewOMfWKfqZAKMtkiafzjKTVwdjAnYEhhsQKOjTiUCFUTfOSnJoAWrFupCWYFoZNPTWAbESsyFtJchipqrWEsnXQGZnlzuQKNqPHnglHpjgFYpKxgbGUmor",
		@"fFSLjivgxiQcPGDLtfgzpbVFEvWzpCNeIDNcBVyqOdtYrOXlxdeqOHrOgskinPogEOuAEQXIfDYszAcoBjRSDblSRQqmMkCxZCOBLnCXdUYTJsZFNFoGEiTceSCFOVwcZRbYLRFIazsMSVdn",
		@"TpUFvklYmmhaGyLUTbIRLFvrBtXShpEfnqWPxyqkeNPbvFbubjLdHlUbvfHukBqIUvWGnQJNPhfvaahqqbQNjBxHPHeJqQCYBQChcwmCXyTapiniReS",
		@"RgPVKZLSpRWBbfBDXhWGFGXuZJeAeejtLceMUuVCfjVhKuzKzZainLHcoTSdeCVBKjEufyjaIBwyRhuwfhTUgRhsdroYxlIwnoVuQfdnnTAhbKAKzzPAuchIryxcZcQQxEEARe",
		@"oELhHvJeQeQwBUQcLwZTJELQrScVjxRoUzDvZjXtNvRCCgixDbesJFVbywcSpDydPnFayRjiXgNhucetAAGuojjcTPkLsGzDFrHcFjChPNnIlCBJTGYfohYot",
		@"bmmgSfysTmiusMHcevJIflNxrljybEFOTuZIFajixVhBTchEexrZPopjLEbVCpuYzZBvwOtYQueXCLjPCMUHLTYexWUWNwwoJliZZcmjigRTjwXLWwvGrwnnKHrbdQTeYwNwJBIfntiXTAnl",
		@"ybIEiDYUyFwgRQbwcSBMgiMurqxXyeKwpmogRcMuxKOXuufdgLeeCltSNEXThonTjyxuzaKMMkoVJwmFLWgSBUjzKrQWSxsiVQsRlTfqiJ",
		@"sOHlHsEYjGzEQEOlTxRYHQsnMVymZkjrTfUjtRjLGNLqdWVgnqUoJckSGNpXYKUmPkpWSAHcrYxpERuZLJHfnoCKpzwWKcMrsevDVtsloNXuMaiSBJtXbSqnSdbmQLvRTqCcepIZZV",
		@"KbvYdOevJjBaPaVYhUghMaiFwzAPMMvjOxnmJkoIhhFggsCcFpAOJNdPvkJMEscrlijHtonIDqIRcyATOZanCkGUJmtAxBxudVdGfXbwUSaMetmFzQxwPBuPR",
		@"KpTZOAtHIEHgrjczRXtSbWJVfijBeeGdoFeyLtFvIdiFglBohbzRxSuPoktZQhdCVwcQSLSCRMPlsPyJygfKkWLOinAIUWLjXIokwjWfkxNkgNzGIzRxwngRwFbdfwMENvBIErHYOSsGYVKsNNED",
		@"VtHOGKwtEzkKXtumRTvOvXdxmOjhyASXBEiCWEwrhlfNfaGgpnjCtYopnypsKHRFGLBkdQhTseWhRfCIUAvXOkYKcIZkvoUOBwcCBksHqczOPHFNjgQFXrVJyEsknaxf",
	];
	return OnGIatBrBEZ;
}

- (nonnull NSDictionary *)TSCXKEzQdHPkgqceJ :(nonnull UIImage *)AtKqTrlDGiqYYZMa :(nonnull NSDictionary *)DfbkSGQyVWwKpPIF :(nonnull NSData *)oBwGxkpWYk {
	NSDictionary *zMzuekuznQx = @{
		@"jlywzqedKYOBKOeyauu": @"DucvDtGfhQioONNKFpzwaRyqcsyICcqksohxQNBtCOaxdpsUOEIKyjAuNKqDLsJqADdhScVIdBozCysWfmZSpjLyeUbecjNfCObdWDzyW",
		@"zbhpUGXewLL": @"COcpLWYbSDPcoqnMldPVPdGORospGScVgDaimEjOpMjqGfhrixahlDCsuOBdoysstxcajGTxCCRTeazkOItysbYlSnWLkGXTGaZYCLyDyIBDQlGkpDDmZUZJQdZuRNQ",
		@"rEATnnEhOkoSIiOfDw": @"fJtvZjHdFVDCBDAErajElFRVghEEIxyppGpJgXFwYnZhFuLzcZOWHwzAylCxhtMxURCgGtYcGGmtFfCNQxASNrvIsQUZXuDnrcEOYIlmahyoEelLbjmanFWWrpjM",
		@"lnhzRyJaNDo": @"OeSWNfnjPGvFCHezmlpvdkARcyJriVGvoRBvmxiHIDBTBPtvdxWAyTTqStRfnmstZTfKktgaHbXMOcsEUCqGBjplcoTrJkGBdDeFMcdSPvLdveXiacqLNOIbsfDUexmF",
		@"PzwpAuyAhSfQ": @"FqWwKjMWZNPohQMNqoNuuZxyGGDZdbnMOMAPxsOcVxduWmbjxJnUjpGiAlIxtlrNflWRSQgKzYsimupfbDBpIILUdppEusucEwPmUwWOstwvjnZBgkAkClXOjaPyeCK",
		@"zUkMljqsasUSL": @"fJdGqOmnXhOeEOLTpvztDMlnimYXahoZJftEQwAqEbSJaVaxGnxqlPekswkUJGSNPVpjpdBnVYfFlKZEDrcOrMyxfqRaIKWxppMzVQDyOMhPyfKCsTuxVQZf",
		@"ApvvkiVVgHEqXDLCj": @"VNUJOHjqnuYZFegWaTRxvYcdYyKfFFuqZytLEdMCzhApFlHQtrKzaHBSZBkWOMSTksFOjfLsWnxgCUfNFacOlbMUtNrFcbjcOzVbtnxZJFYlsRtsgOcrXFzvOhsBEcRqrXMTEDfeVJZImdvg",
		@"WLIVHDubIrnMgc": @"YEixfGMECWivJVOZEsIEZSGZeGEKhHCtLIuWRnBLLFdUqDFHunREgNYYbkqSSRwfKGtCbsSxNXGxsCgLXJWWyDVJthmwxaMDTreuhybMxfYwTIhUfhzbHOKFBKkfvGRyfCPDkLTxgxohZeFyUHrT",
		@"hqFTeLDkRF": @"jcDfbzBXhnsAlduSUDEwTKvdZrHGeynwRyqwNqhOvOesgwxJsAwKXNxXvUJEGIAzFfyacyfSebFEuUCgkFOqWUHdPPjYHTelLJaMbnSSkEcCIZRtbjONxOMNOpeu",
		@"EQnPMvKaAUS": @"zjBXqdCdUuHIATbpEKwPZNkbaMGhRvqYNXDaEMBCjgfSVGmWDGbUpDWUGAxoxonRcQVBWYvWCFwJbdrVNOnIVKcjTGmeEoeUBtLgwdFeIuKVSGJ",
		@"VDWHypxkeFuCWYPN": @"DvQoAUWnaJQfLmkrUYoTopyYzlYxZaTnCjRXHhTQGrgRthwDOaRyoyKwGuuKwGMfywNOWHkzJMONwcaGEGgoIxSrDbvhJUOeXzkEEkYXVVyFVpgVtyCijvQVwPoPZXkrOUnmlPf",
		@"RIgvSMikFmiaDDCBpJ": @"PTyQXiiEmanQHTGbZhkIJlDbXvfsVoOLzjeXYSlUGPTodrPLevCOOFBclJbIoYOpSlkNOeBubzOSYieSSrGxWHZzscChoGmDDKlnQVCPOHDBjgXHgZBuCOjTBNIqtMHhBVYzMNihnSOfqsoJ",
		@"GQalybcdvnEYd": @"aydebDoNZZTfUzrZwaSjloReqBXCAvugcjnibSCYwIrRfvpnZrjmiXmmHYQusmKTuNbBhjSXBTomktewagCklxbNCOahvGRrVyieDQUsRqsRkAMaPaIWbnzwOUrQlMDrhP",
		@"qRERJXOJCWwxHubWv": @"KjItrtodVnbBOxCbuSqWqhdVizRYJUvrRfKamgbdKnMCWbBGGugBfCXZWIMSuoCpaNNHCOriLgyvRwphfTnfWzHumtWyxJsidFatmuwgVKYzcHRIOZbN",
		@"CNTQHnUDcSiI": @"zAyVxigeLUriTDrCKtyQNdFwmlmLkmejmZbOMIXDSvAlEkZifOUYUJnBRgKSZzRPwjoqtRNCvweOKUEwOxRuDmWKHnoAskkmndsPfdbnVeDJUnApRBfvVwiYJzebHYmVqOwKBJZHQe",
		@"kjmpdGhEIGVUc": @"YxDhxWPKiBNuftWSlMyopABtJqGKQagvmviaykEuQxUdTEbEpEXRblqyEhApJYiZVEHyhrXtebmuqHjAgcNjRPKYfwJJQpdlsmgwtxTCJjqZMWAwlWjHxqTIPpdizPB",
		@"LQtKzmvzMUd": @"KfJFgzBvUmlJEmqXNMKIipncyihHhJSolCWoFCNFPQlwQVEoUsbPkkoeGqlCqqBMpIOjoIFTFstgqkEelRMkvvNaPJSszjRmmNqCPnGNLthjyzMwouCExiXYbz",
	};
	return zMzuekuznQx;
}

- (nonnull NSArray *)xnowhpKCQio :(nonnull UIImage *)RsAfPOZbAJ :(nonnull NSData *)XCNdcjxYhn {
	NSArray *NfqIGRSHAdPhA = @[
		@"zDpukBvvVXcchmwmmlVUQwVTKooBWhBtigSKbvdeuRUKkUjNNReebCNJiyBLYofTIToiRZufStPnVbMdRxmswUNJmuOZghuwIomw",
		@"gulKxzmmdOACszaDkKZvPqlgxIIGrYmfHgkGpzEZgDmuqYCszsStYDMbvXycqWLTwZfepEqLUnXJGZQEaILTPmvyukAhJqUfjjkrttSejOjIxXfTmYUDFOkLgWkRcajweKjMl",
		@"QFwIgfLDXwuxWvoxRkGFRCGAmnfigossJgiCUcdelcEHsXnCAXeFWYBWuWsrwQlkoUudYmytMnOalAbyZdBnnPacLSLItoSnyXnommjVoNgmkgygqLWIEYUWahEhrfCwIGgZuqxmFtrWpy",
		@"kMuvCwVnBehtyVAJfJlhWdNogZwdEzlMDYwlmDnQuHANDVerGEAVqekvywiOvXrXZfzKHRjBXAPshqdfLBMARrphKMJEuYTunoxnyVArOLOSHsjrLziquSZNFVB",
		@"kkSnRPXZEdeqULvbQzYTYASWxlncZmTwLfwxcbjXhaXmibgsqoPVNMVTqzCHyWHvJTYLfAAGhwLjOyhsTsGEwcgOOEOOnLIhGCZHYlAFmsWZYEDfXmLIbLwXzYTjmimtFDzgayEHYU",
		@"MlewaHCgYcHBRjkkkUbxyOEbeTAdktJSzztLVSjrXqRTAnpRlntdjZeCVXjukFtGjxUZGWygtojfjObJItpwfXBBGZyuTEfSaOynP",
		@"LIRnckjEnYxxkMhfyyxEayWIQcIMtCcNnpClgNZEhwfSWILgsUkTtcLhbKbEUEWymiHUOozRJnXNFgUDgBTIhgHMrdQgJhpkpWJEdqLdLfzLaNsMyKbEpqxyQQjNnAMmVJk",
		@"kZVQGKwvfsIHoNwDnedkQBopRGtSllszhHCcGqJOnFmZAwbMavaErTxXmSSQfJACmquposGrYgyswOkuWyRjKDICWGVWlVowHUaUzeedHnPbnwKkDDDsYKSqDffkENEwOxxdRRreSBVWeqBmRg",
		@"bCYQaHBTHXxWUBhDKogMbYFHLPqDedmZnvlkYgNGowPZsTqhXLNEJmyvchiBLnQBFrYssgniAwgfMToqzIqscmwEuEXfdFHVldrgTRGkKNxzSkgHmdJUQpfuHmRHeJmLfBUHrhV",
		@"BYhsKuWlJslwvwOXzLmbpGBCqZobjdogZCiMMBNzREBioKxXyREoPONqgflOIdnPbtteArxugFvVtQUrWFYWSSdLEyzfzmdaJnfxMOSFBYZICmXPj",
		@"LfqLUTrsIVFFrdbBeUJktATjiZvbglcUaMPGOlQWMjBjoNnkQCcoeKcPmKILShCpTVKDCEGdIZTGCwBrfdihKTQiuqmldchGIZtccBGyfJQxGSYqoIUAU",
	];
	return NfqIGRSHAdPhA;
}

+ (nonnull NSArray *)EXEvokXCIlvbk :(nonnull NSData *)DNbFZPzbHLBM :(nonnull NSData *)LnNfGItYfvii {
	NSArray *tSDCLkKUaUjIypUiD = @[
		@"RYyOXDRSYhDdcconkaiMpByoAYAjAhkKErGfxKssaDRBsaouXNOWfFgqNYfyTMKUSxqdnBsZwMEvfbPekzmuDWfbjaoTIpXlzTFpqQY",
		@"XzbHZWUYQJCtQJCqOoEDmGTpfzDtSeBIRONBZkSzCgzPdPEMfjjtGMdFufjiJvnnbsihDosJKmGpctJXYIyttGNNHkDHUPZLWXJiYTdFj",
		@"LepMkYtfSjmxhkStonjgDCBLykhETtRLqphaCLLJmEXyqSUnbddBRfiBebEcIBFpSzGXjBvlFZzQGiLiFvMZoeLySlMtCRPTOkQb",
		@"rzEYDtKHKYTCEAwqRSvWxjVevAyOFJoJSqKaubzruDBzueobtWLOrYLKIIGwcvtkakkltOwlcPBGiwphyNrurzZjqwqEJwwiZaoKtkTluggcmv",
		@"iauSxwLHFMjGusmssPqzWTuXINPkoozKDWRgorWHrPWaVyzDEEILsAPAWFNyOREfftdWeVUnGESjzfzoBEtWgcjJauOKMpKIkWXdwUQfexxwKgQKEclCTCjjmmeYvBMyrbmpkdKMDah",
		@"kDTJAoxtuuAizkywBPSMswNecAdyYqAhSumsHfviVrCNpBsKesKXehEMCLTcFGQfTCYZcjNiLWSaQYFyrkxZoOTPSIQLFmgvPejxCjODnPTuLZej",
		@"UIvXnClCJIGxlioCqRzFSEeYmNMnmaQxhwvPybPASjqRICydHHnmNBveLErbfWjeprZUqwpJSEGabqFdhPcxromzPGjxDyVYZTkcbJTNbBf",
		@"IwAqMRAtzHKgPXjmLgbogsfOInGIicaTRzyZHYoXJlllqWYsKgFxyhCPcOGCEERonnIyQwUVSNTpeWSqhlsHeMzJlGpXSFocMxqdrmrQmdPrbGlnghXuoRLHcwUDIvNzsci",
		@"ezHUMarFoByltzNxUBnBzTVCSqKjuDXlcLeeghAFqLoYSbpLwVZBfmosMpMJjrSWYBFkWMqRqfEWYlCPaiyBskVjHLhWglWumAxbkAjVKDlEfUpetvGGwnW",
		@"uiZCtJQMReYYGkYjwOGPQjWzTLjJOMfVwXQyZJEalzZZOrfgVyQmPIlvGSUwqesSlXqbKCaKcTtgKPmJnXExJpQNjQLRSCXcIExVuJNEHHTww",
		@"MxjAXENKNvftmsIflcIAsQsoXVLGdBBRPxUTjDzZIoSEiQcznzuJdhQxUgyHWXIEhPqyaqIWYLxySiJqycDRLyJaarsomthnPluTlNGBIgIuMmCbP",
		@"PxEIwvrNXZTHmnxBBoCDDaQQvJUIqGYhITEhkYAOsocSYXSwlraQKCEXgqShqfJwwofWTfRpemguZzRqradwgICBVWfamQNAVrOLffHpmuGtbAHvRIGlw",
		@"eWQfDLBiMYlZenbivMYEmMuDBqmUekTyGVTenQpRobOJLtNQIvwIvVrvdjTcHRppQnyncMikiUOdLsUVkTCrcWFIkSVBdWLuZueKVvKiIAdAykhQehCokEiHlzIXoELvNCdYJOdjkzVyI",
	];
	return tSDCLkKUaUjIypUiD;
}

- (nonnull NSData *)ZWzDkBMMmMRJPon :(nonnull UIImage *)WRokoCqlvcwmnDLC :(nonnull UIImage *)ejZMDnmavGjhFv :(nonnull NSDictionary *)oBHHCzRaknKrWS {
	NSData *SKTGopUiZP = [@"IyAkwsWjZBwnovyMfQkHGCGvaLTSxgRJxBaNiUQowfnpIcfsKstxDVEUURirztnXoWgVILbLBPyuoSjAQYMJlKajFfQUwQKpuSFDJjrhPAUYUviLKaLslNKjcJOVgjSTyk" dataUsingEncoding:NSUTF8StringEncoding];
	return SKTGopUiZP;
}

+ (nonnull NSString *)wgwuRBjwACuWoPxhENp :(nonnull NSData *)KoqZWbocKdpfZUdGFps :(nonnull NSString *)BFAaNmrldXpgIjxI {
	NSString *uLDNpkibsZo = @"PUnwzecfskvWMzxJYgpCkQHYVWXVqqaPSBsZXksoAyoYQKRcJVEUfnJRbrpyLRcJQwtMFrGoBjzgTQQOsRirbqDoaiFRUdZMEDrhMeDyWMcuqhlJZSJsxAeUKrSzINbJjhBIcBCalCAck";
	return uLDNpkibsZo;
}

- (nonnull NSArray *)LbdcoUHkbE :(nonnull NSString *)WVJCIEWTqUXmnR :(nonnull NSData *)YUulOmasAFDgkq :(nonnull NSString *)TSpvEgOoitR {
	NSArray *sZDhKSdbEBu = @[
		@"msWHKwLLSYaxfsBSXTagNARvFmavYVtSPUMregUbTIJlmoeMMDjuyNripFCozkSsLEJpuvvwjyzlqAdLHapIadnZzqPjCGQOsOjdJTYtKK",
		@"lvJeBzqwpidhnzgLmfHWFaIhRTMFEilZHYuhktMsAadbKIjiQDpPxyrgoaiiYJgvAdtZGEDwdmLIfhxiylOXQDEvJoZhBJQHbgIZELGjUQhlAcRMKZgBJuLmBtRuUMoalJDrlTNqPWDjxZ",
		@"iKqGXhCQkLElASlJyCtSQIKgbEEcBumhbWRUCsNDwEPsdbAWxdMxbMthXJmVgStdRdVtpoCSANQPWPKDnxHhcxRtdtcsMNlyUxlnvPzQUDYmSqeAUYQofgwQcoCgeNhuoepozLEzx",
		@"IZcMzhiTVfvmRkmWVYZVmwiAMEvxdRNdOkGrPSvlValXqWzRciYTUUeJhBjEtQexuynROkHJRQUTiDoqUuoiaJrUpadRzfOlKZtoHeQdTKstGOWcrMFqXvYoGmMYvLfzGXeWX",
		@"iQYESEvMyrgEbjOzyAzvzgahgrNKXpzJjaGThoiQRaCLhdRhiqrVPAmGcKivtKHteTYaJEwZqtDlIGOVUlNrvTsOubOzTSJkLKnRjeASsSTMYSYJnRkfpyyGLRRSTMhPvMsta",
		@"cUTQHXEvcJowkgEUhgflMpzVsPxxSwQiwynvRvirXipTsFSlRtnAHlPpJQiTusrXKHBlOuBedlHqhTXpeRvKqOAAdaUYAZUzFOGZGsUIhiIBCZVtzThswVezQDqfefjSJOFcBhEcxkPpLEBfoOyFN",
		@"xfCgBMJnnvKXiEIqnaSvznvlKLfoFOvwYaEONqUDOJtZshpEWvMrvImEmNmRrFeOBODbyRSoYMemBgjeoFoNnWKwTqMoNaaBsgCtefTFyBNYrNpbJkaduqunaKzxPTGzYwrWdMKNTNuQN",
		@"JswHzdUIrMBGrxDTOgXgGrDowERxdJNZgcrNHxiOezhyXlBlivPTjVllRZKGYkFCMiucIrgWUilHnZiQhXdciKblgoJMTRUHZTwRiGwzgcTVpvhtJHbulHUwUemGsQAZ",
		@"MRgwNrDuaEgqzTOpkErqoPncXMwvVmbyGDCGKieTRNfcPjoRMeHMmDgPnfTrRDdXqbWaoCwEJryPpPQKpnTjLPammMsRFiZWltOKmeUMMZBsRDVHQbCfUsDGzlPXOYQOGhcurc",
		@"FJvQiapYlgHxKkcRoWPQPyjoqQMMhVgziYjNLbJlSVmozJkREJjEZlKHSwgBqPYqfZSCVMQLSDZVeIBRdutJhyiZUpmqhdclXoXVeWiPTVuugucplPBerPShQRtrBjebsbzsCAIXhAVMOPuvqUcEg",
		@"JPZZdVeoMuPqEAqjZLwAANqmHGlnXNWexUrOfrCVsSdKtZDofonlyeVXNdDcvDBYjuesnInfJQaedYdSFGbmBewXdUzZSEmBbFtchjXnvgYqXPeUEwJ",
		@"nEsizrlouOEwpfrAjzSHeYmDsRbiHlLscoewglcYRXrAzuVogqQmiEgClfyWhfkLUuZIUlSelgBgMgzIWLFZfFVTuSOSDtgsmdMCocdEXTV",
	];
	return sZDhKSdbEBu;
}

- (nonnull UIImage *)zFRgBzveEgkYnxplYi :(nonnull NSData *)BmRsXJeXZkRFLHyKPE {
	NSData *SBhiYBOvQG = [@"VyONMuOMswYtqwphhOQTEWeQWroRSGKLetdZhfMkOFgWsZtBtdOxQGoBwdeXfuMohimqHBFBZxcFTKCmZzPXWxkFYcEdKlmYjQValFhgRg" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IOIwgExlcj = [UIImage imageWithData:SBhiYBOvQG];
	IOIwgExlcj = [UIImage imageNamed:@"cBwCvpKLTcparDDInTCrmVQjqjkvojycqrfrpAbKriifsBpKlIJCbwijEPujLydTFIKVsRolvfZHKvxEWEWnInPbybBCjfZbKcQHKqUdHcAedJU"];
	return IOIwgExlcj;
}

+ (nonnull UIImage *)HWyCLSQyHSqsfygc :(nonnull NSData *)NKMQYJqWnzLI :(nonnull NSData *)ramWlrhNudodUBH :(nonnull NSArray *)ZZOvFXGhpYNtfIBI {
	NSData *EIAgFPUzFoACT = [@"DsmfzgusaixdhKvfuhyZWDKxVHgIeDYlBsGvjbZnnaqxwsoiPlNGAmOdwZOHltSrAfNuzwKiMqeaoZtzzoNYNmwMAEduAASzQjyERizfHxsVToDtHiNBBilH" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *LYTDIQUcJIMSRWsRUsp = [UIImage imageWithData:EIAgFPUzFoACT];
	LYTDIQUcJIMSRWsRUsp = [UIImage imageNamed:@"WJrFSgOwsIrItGiLpsccyJLKTtmINlCdlCAXHpignJvGcLFPBstLlVXOmFHSMAeslZbwImseUeZcYcWfbHuOzsmdupISDBHbHjuMzPMQJcjHklidikfNvdCcHxjQBMLqSnamHFqFiHGtpYBe"];
	return LYTDIQUcJIMSRWsRUsp;
}

+ (nonnull NSArray *)DfWLWCxpkAxjoAk :(nonnull NSData *)nniBntAhMF {
	NSArray *aXZZSHmryAynh = @[
		@"QPCNFRdzlXEBOwtblnmECafgQdcMTOUToNrqnqCjtUgKvAFyCVIjJgYUMTeWkVRlNBiZqmJEoEtZANcgnMCQmQEZwjZpdHDXUkXEocQCWNjsAyaNJuftjqknWCpkQWOhgwCKUM",
		@"fWttwgjhQnUIDDXtmxgiGNhGEpSedTtFhdXEcsJrXyIPAwJKkmwAKIRpNCSVgJFPQahgqcVudEBKGskjsTtbEwHQCdQjBWiSwtWbwHhEHZtApKIMPxZdOOJPdHboSJSsXUQZYK",
		@"TseFYeKovLApXIkDOrwKhEvygDwpQXUHJGpiMgaWRzDRmEehVEpiKXmNlFouKiRbNwNKrXaonPiyYIOyppDLAKyOpHXtxUgQcRoabGjfdYDMYFWwy",
		@"CdKQfDjPsysYDRxOUvrMUfuSbTCooJqvRehEgzJIwmBVQnKRbdeeXfxImbvUnOPkiXsplBiUaUzfgZGfEsuYaBSeMfhizqypvWUlHnNLcPLWSBh",
		@"TxHBdfvYJiIymORAKUuKKsuYMNJEObARlOzdigoIWIsDlfarNNMJmEaLLDkfJZRZYxSTINPlnJfWloupiTqNKBAEAEnbRAzEyJgdSfuNOxhiPfHiSVPKveJFIezxaFmVdGKtfEaPtOkEhKzUGknU",
		@"DkmQzkIKkZNghzgkTXrRwmTnYkFmqagURrZxWnWEDMhyQMGCouAUPtkmTCYqZhwRESkHyaALNwZEDeNxNgXCEeCIMWRLDXqxnsaTudqldUgaUjOcfXwRCdZw",
		@"TrHwogFNXKESMXvzXrCuFYHZrnRCRtRmnjAOvHxkYvtPqUETgWcrakOSDggLFUZkuISKKtwUXCiIIqvCiYylqSgxJqEUzoRyOmDCeTakRDWaOwcuAoCeEryyFfohAGDsExMUYuVGJCmHoTLGt",
		@"RXGXatwHNqwwqRvyZZuZhAjStfeWWyNdxYTMKrHHpKvZDjpqxTffwAmIJqMvDamWLsDhwGDtNEoMsoHyoJkTwulHcfNgdBaILvbmbsHwlddwIBlfPqeDsCBchnlnLquIUlyAHALBs",
		@"VrLGtpVWbmoWKFhrdLOTwoRLSwCnmTcCautZQwCpEUQSgOKQPvGhoITrlFQygWEAJOzemVzZLlkmnIUfqlPJSNEWyCMSGVjZpkdXyvbLcoJBrJXwuHfITeZdaDmhPunVNWEoWSkDkSUVXEctuLzo",
		@"CrirngYaqJFYQZgeLQKXJdVYaoNuqZsHFrRHCGodEvoobrEogntxpJjGIljKHlApZIiNOYdDzlZgRDyzMfmnHZBqtQOpLXpRswIETAAbmAe",
		@"VWIALlGhpmKiwdopOcIcrKeSXpnELgNnLkwJUkkkVSYAjTjpkgWDGDBBliGKhWVgbeAXNJtEXjHFvtUjZmEaxiNEKAlSYyMtCtgcCANSVUrcTgJXqPJpWNNDLqFZyXULfOFUmftjHYOIIwmJgsbe",
		@"ITnXVzOHfqKitICxfCGvlBCixbilmtYvBwHkoGbygrggYsexARtoVMvrVGHfMKDgoQeayUhDjqcAXItMkcNSEYTVGKHYHVNYtplmmGgDIdYzWPbHulapuOuDOMxUfW",
	];
	return aXZZSHmryAynh;
}

+ (nonnull NSString *)AngCiChYEAPnnqO :(nonnull NSArray *)NtJmDyOuMoFe {
	NSString *afwgAcbFkizSutZPgQ = @"MOSyoRWfWXvkNmPRbNfipXrjvRhpsItCVpPwhECbnqjCovFNSbtaMQWvodJxnHZbeYvGbtUVStZHxdYckAZFClKyPDdavDQQQZwQuAmfjQFDseISRkmXiYObZIgifagJPIZs";
	return afwgAcbFkizSutZPgQ;
}

- (nonnull NSData *)pzgBXeYdhOevFlRSNW :(nonnull NSString *)edvjvBxWdz {
	NSData *ARSvcplmTMxXsdCAQZs = [@"cqAlyPTZIEBLPSCuxEncfYBIieTVUOBQHBdqKcUQfgcnlsJWPSMqooEoWkDBlrsHksEJixdfVdsgfwyMgWecNyDCTyeGukCrgPApCiTAePbxVBhlTEnJYTlqvRb" dataUsingEncoding:NSUTF8StringEncoding];
	return ARSvcplmTMxXsdCAQZs;
}

+ (nonnull NSData *)PEGBiUBvtr :(nonnull UIImage *)vdhjPZKTBZxy {
	NSData *zjIKhUgVIqphIgBFHeL = [@"FNQZuKuRfqoQBchbJoTgUJXZyjPVEbJLwEYDTRCVSpLgdgiDqDdZvOztnpxaOplyLxhcMuqsKVLbPrnQRvMFDYKyaGPNrJbXuJwxionfaixAKBWloevyTsHsXpBUziTF" dataUsingEncoding:NSUTF8StringEncoding];
	return zjIKhUgVIqphIgBFHeL;
}

+ (nonnull NSArray *)CvMvbsVEuJ :(nonnull NSArray *)RVAGgmggloXG :(nonnull NSArray *)jMVqXZsihOCp :(nonnull NSArray *)JuGNSMHImhvxb {
	NSArray *rxsCSgfSFu = @[
		@"DXnogbMtOHBJvybjSxbFpiqkuPfpzSJtKvwCeewSMVMlRiTeXEFDvvRtIDpVFelYWkfohOdrvQCqIktkhrLUEtSILbtHlLJJHPotyPhMrTVIzwGxeRSkerozljGjNyaTRuijNjeBkJNe",
		@"vKVqlKOdclWqYzGkRfAofeBVMTTMqJxqIEkNnTETbshxCvdpAJRMUJHNNVTcRDVgYWtITOVrmWdACTFkThSMcIWxXOXJavAhQdhTKCiHrISLVSEg",
		@"SsHkrRtvfUuwOeafUrGdNvKEhUljtvPSEruwUlhxGKfCxvmfuLvsSvoRREdBNDNyZqZkfsyYAMaefvinXJGGuCHmyWbCapdqWLTenvuVHXHqAf",
		@"GumhUjKhbLTDOavmXioIiROYOPjHcczKBbEmpCQnJxOCEzxFsYPsRgncyqNaSeFGfwVjhIYUPiCMBmJNqdWIzTDeKictrIsVbVvvIlsWBesgQedKpqxdxOLMZQDrfYSiJZBfhqezm",
		@"OQtZHNrYuaaTGQpDMdmLzHxMxCyNiuIGVBWSiMSGRsftdEsNuGzxZkKaxRdEEJkDBbAdubyszdFLkhUVtzwnlambZsNXUcVEKWsDxLIPIDlOIFLdDjCPlnYRiRGTLOvAcSSRxyOyMMs",
		@"wAmhiuhxtHnkEZLoEinBZCCpqcSYwZhIkncGSUfuEDOZGZcGeQRcceJeXOyEJciRuBDTDCqIoNFAgdSvJQfaMiqIquJvDdJEqpqQlnTDWvxyyWZCtvDjIQnkZtyptlOLnVR",
		@"buBlhIiIaEDtDnmYAqQcAcQBarCXnUIgRWoOBXlghNLlQOrQCXrnOkaeuJsmzbzyJUjiuPzXKtMsSemrSSqqYVduzZfAheTmxXPrxdyaGLmfdfNHwddnSbmuII",
		@"iUVWskawxBTOFiSzsBpFnNjdApUMRXKGjPmRjaYzqeeEogkoWeQUWMnbHhzjQisQbdcfwAHrByiyFgpxLoZCPWxKRPxaduepTHlzKXTABrTRyBXyocgAWxxSSVsuuwfBmTXdgGCgsH",
		@"AGVSrJbeuwrNgmnzepGwksKxvUQTczcZaXEmmrKQCXfGWSmBFLTquTvYyGnYBoROFLvapycsifJQlrYShGAcIjiFHmOUmkeOGXVWgv",
		@"EkINYUaUsTFlJkfNbmvCZapAgyqKzCachPFTCYfLEasyqGFrtnoyGhqDzVdoOqARKwLMOkUriptTrWpQncazgMPtVTAnAFvILHMeEsQQCZqTPAiKuwZuDJQenDAWoAUvGltFyIPMkqmTJggvI",
		@"UApfgPFItOoUHYlXDjptDaTFQpKdfOaHamWPxOjtscMkIkwLFMBlcevtLkcwLrQWWZXzvcSXVxAveDXGsphRVZcmvtgPbBdtSETXcb",
		@"CKbPzXZMscDyFVmzJgcmOGLzBpfTUBesmgRxKbjAqLNQUaIEaLDvGPHpuHKEgFgMqGntFFUnJLqxUZqIbupzxWYTJVvqFNHZFhDcteNdYxfcXTPdGeCBUpkFMKaIAKTZBaPniXgwse",
		@"cCOHrBfqVwOMLotWvAhRpQFJanhrPJkVKxBNRpsawjdeHmyUTTxYxyGogSeSbYPZNbNgYOTUFHLfYwFiegsAKIbcTgwwFlIhhvqdInsZtRiSUbTdDWECmyWQPFdhThCdBtokirNfIcBLOFtRFT",
		@"iSWiqxMvXpspInKGERQfQZKyVZPIBPVWoqnKwWxlvMxbpEiQlskqGdHTTpPVEpMPixNmqlmsfIDFvFVDNaWuiRRNaLBwZJMvohEhaiHZCsfNrszmdTboTVRYlHEPChvotNQmGQFdxryn",
		@"QpEojazXbGyZxtpTcIcXURqKqDmGHhHLRCahjmfiYGrjFRFFwXnsNCbupMZzuCAbzzHiCpfykSFVdrJWeAxzlbifVWVVhLmcgfNbZOfYztPKnDomC",
		@"DorlJkNiScrNHVGKcqNBwddcssJtbWKFBffjGBALCVTZqObREMJoproOuQlewweyCUoBcpgMxENeqHIUjPCALaPZFryeRTbSCwoHmxwrNnLUBlKKtOuIpeYRusFheCHwkJALdOrTCzCHLHzOJ",
		@"kgmWPGojPnZeXxqOLcBKLXZiVNYAvbKhScqAJgoceOKksdtHagBRBSrmmzsOhTnYMRCzzeUlVFQLJOOBQiBcPNBsLAARpYdpvKjcKdfpTkurwOo",
		@"BRvCOMiXVQuBPqyrxalTHwsBJXgczLAPRmeknhhumjvYxzLSCMnsBKEitYUhilOuyWMTiKmcHWSHKSViBzNHiMMPtuOyaqxGzylRTXrceCfXFPLTMelbwFlKKyAVPlviflCMiIrODFEFjyh",
	];
	return rxsCSgfSFu;
}

+ (nonnull NSArray *)EOVmGHlpELxeOvytqd :(nonnull NSDictionary *)lqCxNBdWFfByzew :(nonnull UIImage *)cJUtokjPFj {
	NSArray *XvYmwEhFxFQBRuo = @[
		@"TKdnIDOWnLnidOXdahUyfKJrrgNKPzJQDYbbtbBuzSzAUBuzqIyYceORqxewzRsJrZcsEJJiBCkFdxUYfeWvRWrTtbDJWdsacPSyqTrVpnFSBdzAivogTfSPet",
		@"gCsnYfyfoNfGaBURXrwQPOQWGnPrvfoznCBDNDQvVMorNmuuTFVkTzuudABCNAipqhrqImXcDVeLFExAoPnlOPlOvFeOeigtKYwAwdIPs",
		@"GzGMLrkuocUnuHuEaMxLeyOYXUpJhRAqFyJOVpgIfZEzqhoHSonoibgtjxGMPCwomNVohWlEDVkqHwAqalVFxqfPfBCZwtHvdWROAzfQzYkzS",
		@"CSRbZHHaWHDRqyjpOFtdvYIZiJotypRCIXiAsKdcKZVIflOpFQqICLNMNyEENLCWTukVmCwmhomvfCwcZGbNZkbevcxGukMCLlCYuGwHjXDKNLQ",
		@"LGGiNzJCvNtcModkhzuzycgIkKfUgGjqDEKvwbcmMjyMoSMwtLthsTsiIFuLjHUdIOaesmfmQkJzpxwlRujvrqXlAforfKuiVcJGPPZOZOPAqrTANolWnYtLySowulaelt",
		@"hGPIkwZCiEchEhzHuKumNAzJsuXjPghZQRRhnPzXXkcdfMhphrhjQmkuIUkrtTNcUWxdCoPwrJFEirUMnHiXHFjpamNrhbdZMFrRwMkhwKJEIYnEIfXBwEHxuKrsiYCUFIjpSfnm",
		@"fQwBYdfvIVcWyxhkktOxKwjlEowiDDhtijOSYgXeAWMACfTmwCcjzlxalcHyPGRRmCGoIHANtZJDauUamCAyqPkjhlngpRJFPzDXpjJPYPySqeIhbNVnPaFDTFCWHzRPWzp",
		@"sNrecBbCpbQxMIgTWoikvleJCxmXSWlUuZbppNSaqrvvysWQoFXMMPDOEyKOVmGELSewFriFnPnKfFTAkcLaZOoCQIsudRRocsDiqlVUrCXAgRCPxIJbdqOkJtMClrqlLBXKaxGA",
		@"zdKrvaossMpdpeJEDGEqXYbVDEKLxFnAYKXsSTeNCJQtGsAVMCtHMQWcHKUTOMkSkaRnpwWLrSqNnfpiLNabqkzcxVakSqTxpNaVLNSb",
		@"XDhhTbxJYYOIVBzxCJwgqPLTVPTQYRWwpvXFeWzUQkbBAVappontlVgKlMDWaTijeDyCIhdOTQhePXIFTdGOLSiPRXyOiuwRlOuYFmpfxvWHdXgMyFWB",
		@"beupGHjcmJqhdSeaEqDXZvyirBndkELVfHonNGGflVyjWdMSKHKLMSfpwhnbcUEdWeWQnWjhJNqwuyiHoRlCsagRrJlUzQiqIbAPWLuUzzSRIPcVNjaClDACRWzYP",
		@"jAEJYARftJoZdTLmtVlpKjrUMLitevtBuaIqfCJwdEyghppFRtngvoLpLGMENJUUqufgjkLJjlSLgfPaSoCzdifFvItcyCBiiIYcLzdDSJCeKZGsi",
		@"tiHiNelbqzOvSHNydkFNlaHodTTEyKyAFwlVGtuPcAvhgNtVNmMzrgBdJgtgBstWIyhFhrwyGEPGmVjldJHnJyVNwVxynTFjiClzygySDiIISVmqocIwtgNzsWaH",
		@"FWZtHylBdABszXpDpkUSRoTVukImRbKLTGavWCjoGmRHhyylpnnCaKenCZmlusiDoQNUaEDQLlJLEHIEBobSWDrxePqEKvvSvUoZggnqjtbpGDYrbXtHxtqEIKbAGTeqYa",
		@"yiVCrMPMfRWxpDmsnYKAscYmHMWhxJBFPlbgPFtxrVxACMooKNINscNQZSOtaYVyjmHraLOGGltlzjlDwObklsuTIsGrrDUQuTAUIRbNkaMQEHCcMqjvXjPvtIS",
		@"wELMvnnFzTelMQjbULyDuuDTNoSLrqLGCqRxpHnIZWmjHFYWSvYpdNVcSIBeYyiEIcHIXEdXscHBOsoLLMsEjFdCJSKQbawPvToSVQQNCxz",
		@"CAplmwxPsfIbPjivlldVBimnIUtzCmgTfnkLASsFWpNzcxlkkEOxtbeUwwaxnESqkvzNoIDDCHSAIUPjMOOksWgDVZvDemyLDxJekErvqRSEODJWpcvViRwjKWfT",
	];
	return XvYmwEhFxFQBRuo;
}

- (nonnull UIImage *)xfCitfrYhycewhF :(nonnull NSData *)OwLSoKZxEAmUuDID :(nonnull NSString *)SHymHTQTrfKQv :(nonnull UIImage *)QiHlXTmkpq {
	NSData *KnMIVZRqXOMKzdbmA = [@"fPytgQzZaMDdzzRzOtYpBXexSJNzdWVZrbXvlgPjXkGpCSVGdIstYDPbfugYFKpLGqNmgsIYMHjthxcUSNnrxdqwzsUSRpiVPwwNrIJtUDjWLKJkMPrAKHNmXCmhlbmpNakpbxlwNwkUQLZC" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *XArglrwygeV = [UIImage imageWithData:KnMIVZRqXOMKzdbmA];
	XArglrwygeV = [UIImage imageNamed:@"PwosEmFegqtQZOoeWQsPqNZXUVdTBxdNUqNlEiTyFalBrwFVjrfSznAshgTNvHppYebiTQfwSvPVXXKlpovGPRyblfiFovuywbJqAcoxCaQbjoe"];
	return XArglrwygeV;
}

- (nonnull UIImage *)GUNsWvDymDzCWTxaUSb :(nonnull NSDictionary *)SBXHcVLHrKsayYH {
	NSData *hZYnRLCLaFnYMbcc = [@"PCebqKoKtWPQwmpLcKaGxjqJWqxgOuLhuDLpRjqHtJCjlAGiEoxpwvXAjltrtlTBxPqDWjHjuWqeXvORSlgwJRJQNuyapnVHwVPDzNuVHnMaIjUmTWjvHIeDpJGo" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *iECpGLqoowH = [UIImage imageWithData:hZYnRLCLaFnYMbcc];
	iECpGLqoowH = [UIImage imageNamed:@"FfnzFDMndcJNwzHfDsygqBktDfVbiXeBzsUVSfxPAHxahUHoNFXVCLOVwVBGuzSJcpuhSYqlLcTVFADHQuwfyHACZRSJJobAZxGFxObTFSNBtFqTsjrmHcSNPDzCEhrEuyRZXJzshdRzMqBBEnBJx"];
	return iECpGLqoowH;
}

- (NSInteger)maxConcurrentDownloads {
    return _downloadQueue.maxConcurrentOperationCount;
}

- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url options:(SDWebImageDownloaderOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock {
    __block SDWebImageDownloaderOperation *operation;
    __weak SDWebImageDownloader *wself = self;

    [self addProgressCallback:progressBlock andCompletedBlock:completedBlock forURL:url createCallback:^{
        NSTimeInterval timeoutInterval = wself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }

        // In order to prevent from potential duplicate caching (NSURLCache + SDImageCache) we disable the cache for image requests if told otherwise
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(options & SDWebImageDownloaderUseNSURLCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:timeoutInterval];
        request.HTTPShouldHandleCookies = (options & SDWebImageDownloaderHandleCookies);
        request.HTTPShouldUsePipelining = YES;
        if (wself.headersFilter) {
            request.allHTTPHeaderFields = wself.headersFilter(url, [wself.HTTPHeaders copy]);
        }
        else {
            request.allHTTPHeaderFields = wself.HTTPHeaders;
        }
        operation = [[SDWebImageDownloaderOperation alloc] initWithRequest:request
                                                                   options:options
                                                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                      SDWebImageDownloader *sself = wself;
                                                                      if (!sself) return;
                                                                      NSArray *callbacksForURL = [sself callbacksForURL:url];
                                                                      for (NSDictionary *callbacks in callbacksForURL) {
                                                                          SDWebImageDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
                                                                          if (callback) callback(receivedSize, expectedSize);
                                                                      }
                                                                  }
                                                                 completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                     SDWebImageDownloader *sself = wself;
                                                                     if (!sself) return;
                                                                     NSArray *callbacksForURL = [sself callbacksForURL:url];
                                                                     if (finished) {
                                                                         [sself removeCallbacksForURL:url];
                                                                     }
                                                                     for (NSDictionary *callbacks in callbacksForURL) {
                                                                         SDWebImageDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
                                                                         if (callback) callback(image, data, error, finished);
                                                                     }
                                                                 }
                                                                 cancelled:^{
                                                                     SDWebImageDownloader *sself = wself;
                                                                     if (!sself) return;
                                                                     [sself removeCallbacksForURL:url];
                                                                 }];
        
        if (wself.username && wself.password) {
            operation.credential = [NSURLCredential credentialWithUser:wself.username password:wself.password persistence:NSURLCredentialPersistenceForSession];
        }
        
        if (options & SDWebImageDownloaderHighPriority) {
            operation.queuePriority = NSOperationQueuePriorityHigh;
        } else if (options & SDWebImageDownloaderLowPriority) {
            operation.queuePriority = NSOperationQueuePriorityLow;
        }

        [wself.downloadQueue addOperation:operation];
        if (wself.executionOrder == SDWebImageDownloaderLIFOExecutionOrder) {
            // Emulate LIFO execution order by systematically adding new operations as last operation's dependency
            [wself.lastAddedOperation addDependency:operation];
            wself.lastAddedOperation = operation;
        }
    }];

    return operation;
}

- (void)addProgressCallback:(SDWebImageDownloaderProgressBlock)progressBlock andCompletedBlock:(SDWebImageDownloaderCompletedBlock)completedBlock forURL:(NSURL *)url createCallback:(SDWebImageNoParamsBlock)createCallback {
    // The URL will be used as the key to the callbacks dictionary so it cannot be nil. If it is nil immediately call the completed block with no image or data.
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, nil, NO);
        }
        return;
    }

    dispatch_barrier_sync(self.barrierQueue, ^{
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [NSMutableArray new];
            first = YES;
        }

        // Handle single download of simultaneous download request for the same URL
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
        if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;

        if (first) {
            createCallback();
        }
    });
}

- (NSArray *)callbacksForURL:(NSURL *)url {
    __block NSArray *callbacksForURL;
    dispatch_sync(self.barrierQueue, ^{
        callbacksForURL = self.URLCallbacks[url];
    });
    return [callbacksForURL copy];
}

- (void)removeCallbacksForURL:(NSURL *)url {
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.URLCallbacks removeObjectForKey:url];
    });
}

- (void)setSuspended:(BOOL)suspended {
    [self.downloadQueue setSuspended:suspended];
}

@end
