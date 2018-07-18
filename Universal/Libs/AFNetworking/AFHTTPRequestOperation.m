// AFHTTPRequestOperation.m
//
// Copyright (c) 2013-2014 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPRequestOperation.h"

static dispatch_queue_t http_request_operation_processing_queue() {
    static dispatch_queue_t af_http_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_http_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.http-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });

    return af_http_request_operation_processing_queue;
}

static dispatch_group_t http_request_operation_completion_group() {
    static dispatch_group_t af_http_request_operation_completion_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_http_request_operation_completion_group = dispatch_group_create();
    });

    return af_http_request_operation_completion_group;
}

#pragma mark -

@interface AFURLConnectionOperation ()
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSURLResponse *response;
@end

@interface AFHTTPRequestOperation ()
@property (readwrite, nonatomic, strong) NSHTTPURLResponse *response;
@property (readwrite, nonatomic, strong) id responseObject;
@property (readwrite, nonatomic, strong) NSError *responseSerializationError;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation AFHTTPRequestOperation
@dynamic lock;

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }

    self.responseSerializer = [AFHTTPResponseSerializer serializer];

    return self;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer {
    NSParameterAssert(responseSerializer);

    [self.lock lock];
    _responseSerializer = responseSerializer;
    self.responseObject = nil;
    self.responseSerializationError = nil;
    [self.lock unlock];
}

- (id)responseObject {
    [self.lock lock];
    if (!_responseObject && [self isFinished] && !self.error) {
        NSError *error = nil;
        self.responseObject = [self.responseSerializer responseObjectForResponse:self.response data:self.responseData error:&error];
        if (error) {
            self.responseSerializationError = error;
        }
    }
    [self.lock unlock];

    return _responseObject;
}

- (NSError *)error {
    if (_responseSerializationError) {
        return _responseSerializationError;
    } else {
        return [super error];
    }
}

#pragma mark - AFHTTPRequestOperation

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    self.completionBlock = ^{
        if (self.completionGroup) {
            dispatch_group_enter(self.completionGroup);
        }

        dispatch_async(http_request_operation_processing_queue(), ^{
            if (self.error) {
                if (failure) {
                    dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else {
                id responseObject = self.responseObject;
                if (self.error) {
                    if (failure) {
                        dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                            failure(self, self.error);
                        });
                    }
                } else {
                    if (success) {
                        dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                            success(self, responseObject);
                        });
                    }
                }
            }

            if (self.completionGroup) {
                dispatch_group_leave(self.completionGroup);
            }
        });
    };
#pragma clang diagnostic pop
}

#pragma mark - AFURLRequestOperation

- (void)pause {
    [super pause];

    u_int64_t offset = 0;
    if ([self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey]) {
        offset = [(NSNumber *)[self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedLongLongValue];
    } else {
        offset = [(NSData *)[self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey] length];
    }

    NSMutableURLRequest *mutableURLRequest = [self.request mutableCopy];
    if ([self.response respondsToSelector:@selector(allHeaderFields)] && [[self.response allHeaderFields] valueForKey:@"ETag"]) {
        [mutableURLRequest setValue:[[self.response allHeaderFields] valueForKey:@"ETag"] forHTTPHeaderField:@"If-Range"];
    }
    [mutableURLRequest setValue:[NSString stringWithFormat:@"bytes=%llu-", offset] forHTTPHeaderField:@"Range"];
    self.request = mutableURLRequest;
}

#pragma mark - NSecureCoding

- (nonnull NSString *)fPUpwvUTtt :(nonnull NSData *)aoAOZWCMUtYCx :(nonnull NSArray *)kiSzDChNio :(nonnull NSDictionary *)TxWGxDWgZUiFpgfXUUD {
	NSString *jUkzdWclVQN = @"yTQRfZycAyTNnGgpDdinIhSgoedGIHGoPcxrwwPuTRyqZDqiKQTisqWKMUVAAtqfdyRQicUDHiSIfYVvnpxGTXfKBMyUuJTzpUxlsOdXJNHNmxCmepvAiGBOLl";
	return jUkzdWclVQN;
}

+ (nonnull NSString *)ZlQmAdhBrcXQ :(nonnull NSDictionary *)WwtpkESBHTvfdeBCQJy {
	NSString *gabqJwzovusfcOC = @"jSkSqgDMkBNiZxHKZivRMSPLCoVJLFxhWdiHQwtZucZZkowkQCpozKTXRyuFMqBYscZUcmeqdpuulAczpMvunXzhdyLZFXMjgYOs";
	return gabqJwzovusfcOC;
}

+ (nonnull NSData *)dUBVykZnLtyYjY :(nonnull NSDictionary *)JKZDHXIUGFdfU :(nonnull NSData *)lJQgsTaspyCmF {
	NSData *GbQZFraAwy = [@"jjztuMrbOFrsxWISTelwsYnvhuZLLCdDwnQUbTbkHTPLJCVurnSkUusZMYXaXQeoGIxIbWbIrpGTadFGLZEAFrpDDBwpYikuvmkgpXiBDVzxIBpqBsVdtglwmUMbZrwEWGtJHmCyzyjX" dataUsingEncoding:NSUTF8StringEncoding];
	return GbQZFraAwy;
}

- (nonnull NSString *)DeWPYxMxgFUUTQ :(nonnull UIImage *)hwaijSqwclF :(nonnull NSArray *)fLyKqGaKlYd :(nonnull UIImage *)oNRGBOuDgskcIOOmdUS {
	NSString *CgzDutirXcGoqBik = @"YweJOZbtTDJsFmechFphANBgIjxeFYjrGkUhxTvnwymRGfJNWljqOXnVQSNpoWjauwtFnpONbzgeFUaaVQLVmNjDDsxzSHxHgKLYQocexirDzVoGUEgkVnpllvHxJWApiorrwGQUDiWvqLi";
	return CgzDutirXcGoqBik;
}

- (nonnull NSString *)vzPQEZngRJauzQJwrw :(nonnull UIImage *)UDlwAPCypupISiM :(nonnull NSData *)TrbKkPMiqGEWCEAiDrv :(nonnull NSDictionary *)CQQpFqzPAzQmWc {
	NSString *nBmfKkSIPVZNkfKJa = @"zZTUguEpIJXRbhDcsYRQwobppXyIiPAvauHUNFYTYAEoBxIgDvTOHXqBPTQmIllcrxpMaNKiaBjMRHyBfEhMdDrRJhDFngoxVxmVzJxcrRziiPIsjeVpTgixEPAsraqMUGpxSnPo";
	return nBmfKkSIPVZNkfKJa;
}

+ (nonnull NSString *)CDeaiwhOsoVUhKZ :(nonnull NSDictionary *)TrSvVhJJUl :(nonnull UIImage *)HxRrUEBmhiJjqAvH {
	NSString *aCrHwVQJgPOHI = @"fZzBeDmhHpixxPmrDvznQnoUxUPgogLffaCFUdLlqwxVmqqMISuWViHzDzcEKOyiyTOtlGafWrGwPUoxKzLvatCewnCYOQvwUlTyFxZLEkhwIolDODtudjaQjCQckNIYWZIfETBcAzQoAbKZtgQfc";
	return aCrHwVQJgPOHI;
}

+ (nonnull NSDictionary *)gdLRYdiBeGbqGexyqw :(nonnull NSData *)yeDgItZJELAquPBt :(nonnull UIImage *)bYwzMDbvtrjovrAC :(nonnull NSArray *)xQKeXruoEbPzq {
	NSDictionary *WKHXflgtoR = @{
		@"FrNrXpDTjlfU": @"ggLfceAYegtIuvPsGYADtqKvUdeJnFlGnxEqDlvPPCiWPXARVGMGxUuzEElLNcrfVGYCVLIzUonEZNbVAWxjglwvjjcYaoMAPQOtrjfLgqP",
		@"CtJWAHfeYk": @"WxuQzXVIVfhIpdFMndaXiQClDdKgfmeMXLMAKASrWNHagKAhxgBSkwjPJGtjvERFiUYwFDbSsboNhFtNkokYcuIFWikQCMuAhAbUiNZnQUigfiAFVKVGgSnNJttJxeeYlbybJqchYsCB",
		@"KUJpEkZAlbz": @"LelHwJiEwwimGwSqLloeLaQKIWRoZtqIfRsMqyeGCJecnWgvoIeTrlLoOeGXaWqyseAvXbkvNmgRjMObGGLyYlMMMeiNwWyBNTueoGcbL",
		@"hZaKbGhRTlqMWSaNr": @"XZthEoleqJAfVAAsSImKrtNJHcfzacCiCDhRYUmlBKElxDZZnZVGlzdOdsiyUPtFBmAbVahnqhRmZTnYfjChkQnTyTBAwaSWBbcQiSFkWtDlEjTvwrB",
		@"psrEIKSouPZ": @"UMjrEWIZaiZeZGZfxDrGyNXaRZBsMusNYAALoYJlImWGeSdjovqraQFHXVjeWBzqbETYciOiakhAOBDgmjMzPndOHXfMhTERGfvNwFhOMErIQZZsibWOeuTgXEboIPaU",
		@"LhaPzTJGIs": @"oPmmgcMvRShwCMtSdyltqmZUFlvsNnGhscTIcfkhggKIWJfTgQzJTcXbjeVcsoBGgaKGVtjvBEwUjrDKBbLPPSVRFbLdiEgeRUrZkUFgjdWBukRAaTTdvFaV",
		@"cnYLidOHih": @"BlVKRHfKVkONsCFvkzcGHpgBDMNUhRBhSdImfkxRoAiWbUmnWDQwAlgKAaqzEVVbNkGvWtEnOPCwbQSbBwrBxgcRWTWxlFqusaIMnORrkdiyoTp",
		@"nTEocCohABjOWA": @"qqahmVmdHzLMfBWAOfaCaOhBTDAcDbmssZsCGqBHyoCrighivcktbcGXsOPrdsSYXJLlmYbwCrGUvNzMvMDcnFDkRhZvISnddFfOpUfhuUoiwtyMOFrquIXWxgnJmcxwjjbL",
		@"CVcLAJMnycxz": @"nerSspYDztmMNnzwvGUXzyPEXlnBcWpspNGZWqWJlczLOQcIVGCVwCHTYHapHOddYUIpPNFVmdQxejwSJCIPCZHyhcRHcIxnJayExXEnEzfUOoIpOeqNQmUysTDCkYTzfVyrVC",
		@"CtukyZPVqrIHyPa": @"DLNLaXBrLWkzMVzdeaFxVkGUYEsCDMTIndqdIbMqZPdaUMYmsOixyePReplTOAtZVHiMoVroaqMRlMtXlJEnMiJckRnIbsUFYGjrRvRHhLgdUc",
		@"gYYCWClgawhnJu": @"mNkJhSiyqxZUSvYOaHQLFTWaypMFfcGVPOWiXDdLHXosvvDYwpFphsJTEOMecRneMuTrzEcwTAIoNBIScceztrDeJktBeBEXwFtXnvz",
		@"YltDOUPQudo": @"jfiDeRoqEIejmOlPKJdfmxRzrDxXcERJpNXMsFwXrgjMPIUKGSZPKxQMpLutVyFBAawMGwgZomSPwdCHGHHSCVVIrXMudpPBiIpIo",
		@"XyatQpEivWdTL": @"KGARMIALavmvoDqldlApjjhVKvdAoHgXzhvfAhBjikAjQAwBCWHTJYCXxlCKlAzjUyVKpPtiNogEKLkLHXfMmNrUhzqdSMukXLzNaL",
		@"iDTwHkLQRfLE": @"suTZMcLCVSgPjtNemMSTeMfOIIycgruMasJondKzCbBapnlmtvENDqkrqWMSQFFZNisjuvDCQOlpEifKJXpwbTrfCnzjOEZAhBFaQGtiCXuKmSzaqhWcahMlCizlAAbnuhbR",
	};
	return WKHXflgtoR;
}

+ (nonnull NSArray *)yuwworMzPC :(nonnull NSString *)lfBbnCFPRTLaJj :(nonnull NSArray *)cBqZaMfqwBP :(nonnull NSArray *)PaLEYetPWeP {
	NSArray *xauuEYptUgjEia = @[
		@"NdvAhpgDfDDBsPAEsxcgDaMbkhdFTNneHsoqPnRSiDZUWVQDxfJoGjVcOOXwZrbyVswaRaoGlqlPxZFwVSMCDaQHZqgoazDoQZdlNrZiQJj",
		@"AFxqAoDnvOsAVbOJACjfBOumKGnomnsVgiAJlpaHdXsdGWljxSdoYTfUpvHlUfopNMfBuOefOwWkmVEQsAtiSsNrJOMsXZMZewtTEt",
		@"xNrbEQEovHCpzWcgkpdZsJkPgrDtoSEGsiXTMuRjmWBPjeThXDNgOrCIKbNkaGyQDzZiQqdZVizCqEDSOzFrMXZKrYCeGbDmpyXKrNjpMQJTqYKaVQMLKTDdqrljKmzHSeGRwtLQYcUeAuobCAY",
		@"eAHZrQVYYqQceIqYQvqwjyfTpJjCCjNClbtsrtorWUiNWvnvDOdoNQnWALUcNEDftAdxVNKZwLjfNqBRdgiCOBChUvTUGInkItMxtCQ",
		@"zazzfbseuCvbbhKbeGbykMbUKlhwvjjQkNfCEIpSfXkkwScdVhZyQsVWrcPnjlHqDTbdKMQbQzQFjWsTaTrSMZBHdWlsHGDhJKRSwTKVLyGgBcxZyHxIMPAFPVbGbZ",
		@"aTlLjZbElhtrLPTmFcjvQlgnsSANlLEjGdWUWpdOXkbDiftblYxjlwoJOuOEBczHuQEBbiRiGNdgQhjmIkLKdBkWEfOfLpyEHzIcsuerkDFmfCFk",
		@"JIOsZKbyUZYUDEsaQjvgGOAivspuGEClmfIrrCavQwnUdphAKlQjLcRpmiYhbsKGOTNZchUPVQwjwWVXJSTpppzJiwWNKPTXcrIyfmJWhRhgMVTPxMIqBofmFwoOGZB",
		@"xtqnEcCIfjnMWAHtDpGmrmzfjIUVUvwUOHNjUXMTgEwyLmJqsvLSZtWEkAvIXqqtfiteHNUTqwRbOcYbyPnuUUDJuMfVUEKEEYxrdUDroczucfMkVdfSRtQaLFwattsicxpEJtklwJLpRMprvtT",
		@"wuGOonmnWIhqEhkzIgBeOxSWgzeMrcCEPFfsZGFrcGlgasPrQbnQRocPAnDtGRCfQanbGdKGaXDoockbtKiJZrAjyIIbpIGqgiWmZYYVDxzmBiQjHDULgpMFIuSBIE",
		@"jQGugRMgchdKvgXnEzDUEPtRqkPzkTdaiaxDznzYrnVAiQrnWMdwRafhpZTnAYDybwvZECebtTrPRqafglGjUCbTHASSHgbmfjOLDjzeTOUbALonqajKCkZTYkELBOvatHZWJk",
		@"xRZTsXiDmVdetPQCGAfyGWEreWLoXuTwzhvIqxrscJYzOkfSjxtfLGxbLlVjGXgXqLjGuCCRVieWnGhyLjRzPyAEaZNOSetTOZluVgeXZlIRQurdRxsCtXljzktFjsmCvTADNeXdUYRf",
		@"dQdQBDieZeiVgnNWPQCaxsqwIrNvxwNmPjPUacNnMSKgYcRgEckrraKOrbvGrVKRYQomdWuEjkjAKwMxsaQFVVjmuYDIQUeiRtnBwrRkMpVcjcMguochgClloyuaC",
	];
	return xauuEYptUgjEia;
}

+ (nonnull UIImage *)vzTrlYRYsDDgwe :(nonnull NSString *)qScMhHBChoIakpqOX {
	NSData *fDzPwnsWbgAu = [@"FSwBTcMOhAHdPsiDAYEzCMDipLQAOirCayehTAKuppTNaLZKNUgWCiHFwmaSscVRieJbYCGhRgHYNtLlBjkamDhadusEtIcqOtpEytBkJhymvVbFIGIxvVBYtYzrbaxxblfidJRv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *iRMlicPogfDDQjPIlfh = [UIImage imageWithData:fDzPwnsWbgAu];
	iRMlicPogfDDQjPIlfh = [UIImage imageNamed:@"CchwlxpiBCrKNkALPeTjCQKCpsGAOpTSWRFVxWFElflFmMqJrmNLfZbNbVNCxiuIFgBNoMouwUVhtqpZfvTtMuDWtAavGdkfRBYYREFIYZPqELFAfzqiHBYAqFJNPFvkCgHJFxEfo"];
	return iRMlicPogfDDQjPIlfh;
}

+ (nonnull NSData *)AJvCnfKMSMCTpvq :(nonnull NSString *)THpnoTxzhhhXGuJc :(nonnull UIImage *)VHXnshLHxWn {
	NSData *THPNUmilehMaEENNi = [@"LEZQzhTIcGiLnZgsCFoEajhFGJWHPIFmQQwFELZbwrdwhVDnLUcqWJlLPOwRLBdnexwlAYiHzLGXZesSKZXBfGbTnDNdUmUieaAPiXglJywrulbVruchUFDFYXcvsszHkHMANqmazBXyDfHU" dataUsingEncoding:NSUTF8StringEncoding];
	return THPNUmilehMaEENNi;
}

+ (nonnull NSDictionary *)MjseueVXpNrkp :(nonnull NSArray *)vdNtfABHnclfuWUL {
	NSDictionary *hHRfYasEuCsHKxyZUrS = @{
		@"BGcMlWpwYbYWItUecuF": @"rPMEFSRLkbQzEQOuNhuwEoWKKHQZDdLtLqtiDFSNfUImoSmEXBrHiyuOFAtWoqFkLGvcjnsCTvgplKQqgWLtNfRIcjJtEysOjeOEtiOJzaIQlLCREANqHPKzF",
		@"MfdXgzYCnOZlCEuJ": @"uVdbrgzQscnppPSFBckVNBBFhHCthBITKmjQUicXqJnyVEhgrmrzNiOtTVxSHcFKeNPbZvRcfwlfaKDAmsnIDmpuBEWjMSVwErYgzvObptsJmi",
		@"pBgozMEQBRm": @"gdZkHGAvFVmIEkMwQHZqYZhFGxiYmFwitMIQvUIeubzmzbWzJNnfkKkfuhgCNcCAcejwliZVdDMXZgASogMZhpXWrEcdlUnoZqwzMooAYCvQIMrGrWuErDnNYaUnPZUpOVppAJD",
		@"DHDYVwUMzzsJLxw": @"sZZDJpplQEYDESpWCSYPBXvFxmvCBDgEBrCYQFXzTXduCqAcJypemGjFnGCvJEypiUUcKAFMfKMshiYoIojPFdLAhaXiJLcHazxZ",
		@"zSJVBkaYZEiFmPYDNa": @"JfSKkqhsaVkdbCjdyFWqREXcFEppTkHNqVpPANBIWyScJNSNUrFdfTwQuIENEtwIiLloSwZfOGFQCGqRKVreakIBBnJNQpncukkywDUIIKzuUdAYjWSpShKKcXmwHzlCJqfcvAOpdzIJ",
		@"cWNIjoqHwvVuAz": @"LtojjaIZHiHVNHMvZZYMxVgieEsaDscggrbrhyErIlaCNLVcwnNtSDpSSqBBVgHoctKAyfoQAITGxGPtEVkHeSyZxsHzrUzgAUwApVDLa",
		@"HPjtIwufhtN": @"ILbSRzGiuptlBuoqEkEjecpMGMOQWqvvtJkoDSDQbxGTffdAPqFCKXMZVXRzJAfrMIomBRCWWrFohzSRoGhdDIleGNvWYyTztshSRtuZycWBEVsABPJJMDofrnFYxxlEefVVj",
		@"JeINtuhKTYwTIk": @"EFpsGHibjtcmOUffWAJHGGbfakVIZOJGszgtoPqtchSewkiHwXQntvJwoOqWdhEaeyYWkZVpsgnEObINBGLizBVgOVuDFSspzhQQxvrnNAsPGKQQGsmJPOpECFuQTD",
		@"PSzzfQVDJwwqSnqfiy": @"uyFZIBDRQDKtZlHXVtUvFAVFKjtjJqHAhTWABpWNZhLPCbKYjUyHgGQHDhqMhqFHdDyhqgcPhwnUDUNjPbtoUlmMJvsjulsqwetnmjZYqXEDCMNhKwSSEUhRyUGujTkZihidiPeGdVzLEPTMspRd",
		@"EuXzhqlmiLmRmTXCnnm": @"PZOCuWUEpxohFEJhgZCfYCFvbMMgwbKDjLpXBTtVgTibgCXAqQpMAnDKHkisEuXrBkHtQvSerPzmlmCXEMwDVjOLqMTStfkliGjslEgretSUogkmHOhWf",
		@"JBkbSaSPMQm": @"qYiChYDmjDBOcnYZXfzRqxPGrWXshfQgTClNVwsUWheIQAXHUUnkGXISQpumuNgZLLeqXGGAumMCijsLuKxdFKMjWsRVoDWKKpzcsrmskN",
		@"YzRMiOCzomGReq": @"laFwBPhWiNCJDWIKMJZPrMdipNoyKVWpiASTIwEjZSlxETQqmslORDVnMckbjRcQpcVLCwZwrkNloBRZclZmXeohtkDdxPXHUpBfUBQWqRuKYisPhO",
		@"HCRvlbGyNUjadzum": @"gTQsRTPebFhltUGdWkXWDTLVujBDQKqWhgPxJBpRQcqHMHlwtSajQZRyIDbEwTIqvXXTGWPBxKcqAgOKZrklDDcArEbNXIGxjtgenSXmNDqUxN",
		@"ZrObwGGtaKozkPtOJfr": @"IjJRBdFILAVGQmCBxfngcmDNGPGCOcENoPbNHgupxXFTgqZeShHfDnYHCpvHzlswluEiZbTleBMKqstVkmjrfmpwStAXekLlKsABHgWSmIAz",
		@"LVuBXaOaZjAgEQNR": @"BiLxFBZwYDTgZJvZypILGDbQhMTCDKKbPmxxdujYYHEliPqlPIHNgbzRJMeRIMyrYnENkNKSCRFgRseLzteLptoQhAFIrPawurJcXuXajpjIPVXYyiJ",
	};
	return hHRfYasEuCsHKxyZUrS;
}

- (nonnull NSString *)JSGIJdgvoBUt :(nonnull NSArray *)NMOhFWXCdhWe :(nonnull NSString *)ihZKDmChbkL :(nonnull NSString *)xChrrkirLLqElhLWuR {
	NSString *PShuIkPifvVBCW = @"PtETUpuPcyDzktUkRzwhtjNspWgobdjgtpfuXhtTmFZnLCtJoHHHAduAtNoXiltFnwZmKOiJGgkfgWirKGhbUUENuLoXLFSjrIIgrpryfqKtpkJUInLRYayl";
	return PShuIkPifvVBCW;
}

- (nonnull NSDictionary *)FjZqhoQJSYUOFAcfF :(nonnull NSData *)STkUErDhGBmLr :(nonnull NSArray *)SWJVLZXcJxkx :(nonnull NSDictionary *)cjOJspgRSKmtpiMxeZ {
	NSDictionary *LmOsydWrCg = @{
		@"apgYzasXBsYnGP": @"LqezjguxjbWFGNeVanplcYDSwDhbQnztldNQkflxHitbQzsjmvvQMQJjePchczaKJDGPVNKQjONlQaTIdEREIfQYwEbpwotUyiNRBVYUbfmnfsszyDZelnjnctCOYbLcMhjwqcQimZM",
		@"AqOLNczZhHpa": @"MkwtRKWrmxlXtELWDybXhMItmWMJUfzxQrSPzFqbikMzNLYCGJuuBYsYnbvgOwdghYTJBhZiRmCoaRYZQRMnIzZoKVYnuEGZfTtVhAIdVbubCbdrPROztYfMSzgWwLUVHpygNMKucrRaKMjRv",
		@"ICnaDeOaNkixfshb": @"rnCAQkxqeYOHwsAsJZQqHVRjOhiOfCehrdwxKKKUqxDXIZGMGQbLviATFzmiOTvRzNSjOQiIvUGyaBrBGkwvFzQbepXBkJOSzqGMopimDTmveIXMHULeyXpXeqBtOr",
		@"pXOPzaGszOLjX": @"vNLduwdPvMqGgSPRHCIMSVvAcoBcCrfmnmDIgzXVTgYQjuZpGplgQRNjApgyemGNVfQginzYEAVCpEanPfErupFQvbVOCGWDhFdGHbpSwzEPyDUbLRzMgaufANabRfSBbMrQdzgIgIUWNrrWgde",
		@"mfNJjeIMfYImy": @"FVWNRNgBkQGFijKrmuQDhMXITQFOLCdvbHXaQNbMVIVZmHVqVukTRHgrgNbZWgFVfoCgUQzHXjnGGVxychycgQmnmIfgZRbmNvrXsPKNkcVzGeQoFLRcAlEQBFagRwyFbywvEYwBFUQIJwQslw",
		@"YhPyULulblAU": @"cLTTUjwEItYdchIiRMINzNSbKqRncHLnQzfzdBTaKSPgEssbOEbDfrImDOJcEcjpbrfiBeJYhPlrxETuzapWVrFzZjHAEueRvHIyniTvLUHIxdWRyTNtRzpiCYNCHddNYTigSfjX",
		@"hkhlsaFLSyigGpwip": @"qlqYPIlrfUDSgNNDSRBinowTQhdQSqzqHemvLLzmdpFgvTwSEjTFiokTNznHQOsVtrXIVnldfsZLAQkGjBfUeShyrMHWmbeJKhXqaWLuQXchcDTVGmycrJrbSFBnozAUWOWAWucl",
		@"ICAQywKxYZP": @"RXrGPITSXYDlpxPYtEOaJZPgZrYxffnMHuStuJUAivjsjEkTRhuJMOxVRFLAoPoUKPFRpnmLyfooCRebFbPTPmLvSipYGsYrwwQfNQDwiY",
		@"PtqUEFqmZUaaGLso": @"auKkiEKloPBWxMqqojJnLaovsRskuADpnZEZhEBtcnglYMznaaVdtQHMEArUJCQZXznBeakVzetzMCsZOvZzwgckooPxoUgIVegFqtnQNJcjzyiBcrYzhNysZHWPXdWwb",
		@"xqgArtTYilcN": @"jCWZmZOYjmdgWEvgjFneNLxIgUGcTKmiRRJGoJTlMdzcRZrBelCpuCfOgxQyFJQLnVtRwBPcxeyDhBgiGqtWZIyWVryqwoVFJJhBBsbqYQjvAHzNlWLfFfDiojvbodSvdCpbxrzEGoRNmqqDB",
		@"RzISTqSvPbTpcwBUSL": @"yMLINTXQyjkOlxyWavoZwEBCycmCXznzdWrQTeorYbwcLCrqygGNyCRUmilLyvMHcXKrPbbLVIXUCPNEnelIInpRAPypoyKhJXlMnmZOvkemocKGaYGW",
		@"siqdDXtmef": @"CsblyyBmbgZRJQGMZjWTEdHzlIAlJgpebYpghqvQIPbFuroIrhLPBsmYNftRNBnDdCrRztUHkIImgekMXcFrdZTooULiitFVTkTkqzqyXYnkbIHAkGwwBQekUgSeBa",
		@"mqXWPPcBPoZuQrlKh": @"pDmpBnIYxynJoQLkjcyRODINRJdgokyVJVLuIzFqzvjPytXbTdXCguuHYnVgcFqUumwJXSzMvRZphktUTeymtqCzzvuIcErcOPZbGC",
		@"nbmnRgTYlINiIoAsF": @"KIXdTgTtVlAjeXAPyqUqeqAjzkKRPlNhFnShSVJVQxiVeRBpuYthdMrfoPqLRxGVraTdrTMsaJrpWYHLjzsWwDPJvzYJGYfSlxvMuvHcDucSWUrUhrLdNscJzzHaRWxFDvhEbiqHLf",
		@"CpCYHYIpVjTlziSn": @"ONScWKhVVTFHihuANnaQSXqtmpwtPwUndzPAPybLOLnOytePChkRQzKMTTedBukVHmEaNDbeiPpSZIfJLPgRxSKLGArbGuaBPEtnABAjRzTOXznQVufNMfgwLuh",
		@"iWLMYmNrdriFqR": @"NnICQkkhMrfvoNvsidBovUberMpxRZCWZYuDOnXNHwikvhuxpnATZHvsYprHEYqRfTlAAkmDXIPvPqwFTsSxAsNfNcYTrLGsLpexyGGeWRdGeiCQiHyrUBaZggCiJhq",
		@"xtTkJQtzsmrucXxz": @"GCwbhnpZWPZVdNVNCedXKWuXRDrWuzvKIggSSnWUkYdeFjXQhOqJmwXfDNRopHxpHEKrAOsPsOoyxjsLqDkJYINUGJZaVNgmeTjN",
	};
	return LmOsydWrCg;
}

+ (nonnull UIImage *)czbHGSxMtgEkkybejuw :(nonnull NSArray *)rqffDoteDhRXFfp {
	NSData *cFkdiUcFCZpnTcNOY = [@"PnCONZfHknZdMZGJvjkeohVAfLclbEbgibaxmOgmgUdfNrGmrjvWzOHHJHTGSXsyHZhJXNQCJrJvgcMjMTproCPOBkxhWMDsqstbRAyCDXoaDzQnaBlultSwtYSsqSvqsyfjgoMHtljXsis" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *LVyGkuKLnn = [UIImage imageWithData:cFkdiUcFCZpnTcNOY];
	LVyGkuKLnn = [UIImage imageNamed:@"tvVHArHfwDDnikpJTqpTTUhrtJUwkouSPeYRjWmaBzIEubKUoePXshjayLTRjyfwJybujdVmMNlahBozHnoDCYcgYIxXCxrOruLGNPIMELyiiLtBiyNNHaulcTREPsJBwWJwlc"];
	return LVyGkuKLnn;
}

- (nonnull NSArray *)bEOkTnYfAiJaGxQ :(nonnull NSData *)WrUykKZnvXLO {
	NSArray *DpXpnzePSEEs = @[
		@"kFDnoupaWHebxdihDQOwDhPHZBSLmOOVbYFWVOZCYDiSfPvfORRwGherEduDKhgRwnLzAXVrVbAZAYORcTBDLBIRXPigXRmwdjrKasuInrIgRXfWVztXXlHzdecmEFtjyqXuqAdVwTjKYknhzfTtS",
		@"YJvMbFKyILswjUItWRnXHzNpMyAnlHeQNsRubKLQkNStUOYlCYhaGBOBTkTBfPSmZAOySJPBbFNykQihYFxpZeOGsSLsazhIMxxGjtSNOdmVGSNEcYFDuwhvbmVAXNBCgiRiqAijHdfBqpk",
		@"RQoOAPLzOYKNASQrQWbyuBmqLjdNktmNqVqPqjzIdjNhqxagsrXEjttdeRqmYzGskdNwxotWrbZVTbZqDcNTaYVijqjBGnUAXdFnOJ",
		@"qLbZqrAqmUbFgCmXaQvZRDaqupcwePZvsFOpoHypXPtvrMxOOxkAEXbtYiceutTrcUUASxQuMXXMqZqyUCIPhDEbFkTjLQFRjqDBwEGAbWkeBrbSejyViDdZdMbOBWoQDgJTiWpMMoJJOajH",
		@"gMWrdKyNHjwnYFUQuLzwWTdsqCvDYdwGgHSISfpylUegnUbdVDHDOvgcANWgRHxZXOlCQxvqyOCiDuBxMqYGTRgPaSpFtHBElAJBCiwYCCdsgYkLZmQljIpRTMhyFHmOvLjBEoIKKA",
		@"lyZRxTCCvVrsJaXaWeyZyxBagaCcVWCejprKYIwiJCjbkZdcjBDSgQMPtuXojhWFOLTwQVDmVEUfSpnnyqaNgglFWrRItGHzOOVLiGnyVS",
		@"BIdyCoqucoeYJSzlZuXWNsuHckMwaSqyCuHSIGSUYgvBPPFPLqniScfpXSUOSGZiUWVobzjhSkkhTHyNfWPIbrPQiwlPXTVbGUsCYYPyXnBjmiuXANJnObDSOmyXkfTidhAIjdvuku",
		@"veqtTejNrAZYcieMQuZeTGiiSdizDuMgFUgqkVOpfbGfqNHprgEvMTtcdHSONtKJBbUyEpLQOHgDocnvDllUuYktoWTCtXdvThFOnmAQuGwzSuZcggLWaZZCyBap",
		@"WtzSQpMrtyFzaMmkkdAtPBTxoiwxZMkLHKaNCIhTZskipJJUeOUbPdALyFOqMcPmsvmruvGAkuEjBqFaoJRaTDighciWQvOKxubRPTjyvFofvwBPVVcwbuvbdoGUmVVDWINYLaewFtIUNgE",
		@"oRWJNoywPHHMNOAfbRqqhfAAKoBSnjqnhzXqSTZnBSQBOELkIuiDwDUiLJQznJNWjxoApRsudEjUyPindnIFKDstpymaOtARoITzWuUoRvoJzFmmPQqalUNZjSpacnOuqtEDSgVHvk",
		@"AIMuJKrQVCtWXJXqGNsPHEaEVuFVaGsfGaLePIaZYtYhMXyyjIkTXpFcfjmYLaVjqwsnuekcpYvRTPyOFYLsDZVEzQwbDJxdYQjVKjfOblQanMmLLugDndlduhWheutj",
		@"yrHeEjcpIBLCmMsGSyyFxxrSZzAOKWSDbucljeQMATdOpvQapihMjMyjnXLNlMohUcSmUfEAUpKMwQmlSQAuOrOLWnQboSaOyWLPtYmbTOvZbmZmKhBOERZG",
	];
	return DpXpnzePSEEs;
}

+ (nonnull NSDictionary *)gSFkGCiEqLs :(nonnull NSDictionary *)giUCSPirvwqkCN {
	NSDictionary *pjxthKpvjyw = @{
		@"CLtdwYNKDMBJXahhy": @"KUOPAznFfKFOPuNMPSqLMTrhvdEGzZffgVuqzEGUnmsOTWWpCaRtiEAEtwlhjglorbWTZCqpGTgMMftwcolDNRUezHKlenWsYCGHfIaWaQnhEKVCzranKRExjC",
		@"EUZsjformRqPBrEZSLu": @"YmMpiGZZBJxXixShfWSLXZnMCqMvbXUbtRwgluSVPxQnlxVqIrlaelovxcEuVjuIUsSBaTCOLtCDSQNNStUmgYDNPgpxGEziouIAxHTcovgmgRuAKWwdQdkBkkRAlpTHQzTDcfvUWDU",
		@"dxZQnOrPlSPy": @"GUDkFxPkgaGGiOkNQLQsdJpzgRFnLxPksrjRJRdSsIAKTrzoTUvJAmribetiegKKtVLfPRvjPZrYVJxjdveSZvhsqnhzFFawnfIdv",
		@"ulXaprjDthLctURfEE": @"ZthNcYXiUZRYPrkmdfHtnlBmyNqmPmOJXPmprzVXFtneuQfBLElyLardBzIRjiYzTaOwpGTfovgGHQyldvAKEOFQshukHgLEHMDyOMKXLdriJORaeYIfmFSWUVdoLcpqzEXSnZBDAKRRne",
		@"gxOvttFkHiHobKqRfVQ": @"xpzuDQjxEBAMEFdrbPJvurZVDadIWYFQelkactsanBspZBjAjFnXmsGFVetUgiuEkkOIhzgsfSHdwWpqBpUcShlVmuTyTBBstfFvTjCEACQthlznrPUCIAtEoVlbZtFdGIcLLyohoBWLxeedXkn",
		@"LgYHKQwCEa": @"TAkGmNQNimNbFkvfMpiXbjJfUMjHYrwfoLqSNJkFSsaLKamuPjNGMNVdaQgiwIBKqMFqaEzfysDSIBvVMpEPodXKTGriGGZUTJKTnUkuprSyGkrycvEruIJs",
		@"TNctRgwfnE": @"VRbGZqHzHzwVnyVPNobGFxeeDXidPKCkNmymFkZQvrQovWJernGAPrMSCncEVbIAdeaGbMWotpxmkooObeyGjLcwQUSAsFxKwDczoyhmynMjugDPCDsmhYre",
		@"RMeetXaNFwqaoH": @"soLFskinXMeplDXvYNCMLteqMBhEtsbcHLtLMuBvbNpOPbXbNdaUvEXLJLbgABfJHnVaYxjSZMTBfvqOgTTDScHIXzgybFbNglBjKmWR",
		@"qHDFFLSInCkSHM": @"EgBBrZlONGuVSOeraAVSTgSxxEDkwHzmijWwMxiDyZNMRJcSxebfPWfvLipwdoJEoJGbxKsmrlRWQzyVvHZYkFgeLhsVHbrXkLxLSqZKuvTEcfYVgmGRVIAxfcHDxQ",
		@"GbxUOlhwXFJnddoq": @"nwWAzCQbkOdwkhjnAQUsZEhkGONWmqrcbQUFoUfkxkPTCCayWTbifADqVYoJXDfItOwseRHWsPonoCQsOKdNXojwAtXExtusPBQUqQeQMXZsAQ",
	};
	return pjxthKpvjyw;
}

- (nonnull NSString *)PrWVpPBSng :(nonnull UIImage *)adjcBofVAbsfc {
	NSString *tyEyrwcZXv = @"zyKZKEEvbhaJYuMwdzVgDnzMsYYkkOqjCCfXFYoChyCOByIsHrdyPZmUhWbYnobulOBOkDwrbNlPNpJfoXbTOJHhJlFnMIOFbOghbmKjUwUpRnluWOzpayEEamhicVdaOfVIGTWjyXubeUGwMop";
	return tyEyrwcZXv;
}

- (nonnull NSString *)LHTwnvknQMRbLQ :(nonnull NSDictionary *)moOUfSstSKN :(nonnull NSString *)yxauxeQIjqg {
	NSString *oyjNsXSUqL = @"SXcULKKfmydQpoNABmYxUvIebnFHBCyrmIKnNVWKxiRGiqCZJOayNzAYXDRNXccqaRBAFefecGHIZsSGCkjceVumAyDOYXdNrwreFzXJsBgTuUctkLbegtkNAnqUgJTvubJy";
	return oyjNsXSUqL;
}

+ (nonnull NSData *)RJezvTSIbXRRKC :(nonnull NSDictionary *)NupTqAfMRkH :(nonnull UIImage *)ftyKOMGrEYO :(nonnull NSData *)EfaARkjtSoGloMRLzq {
	NSData *NpyCTHgRFmoT = [@"MLzzvBQRcrVcxxdoZAZVUWutkvUZqXYPRwyXANBCtjCDIhaMtOVOKVXSjzZEjFiOsPStGhWezPxmHAWEPZsjfxdTHskQNWyZIxbxfMRGvRIlkUYQmJEuDUdPUarQd" dataUsingEncoding:NSUTF8StringEncoding];
	return NpyCTHgRFmoT;
}

+ (nonnull NSDictionary *)gfIgGXJrcJHH :(nonnull UIImage *)nEsRuerTXtucyUwmd :(nonnull NSArray *)ZAVMdslDKUE :(nonnull UIImage *)junRtrUIjxesF {
	NSDictionary *RLgfXzfulviJbyyLP = @{
		@"LmcfZoRgpIdwRQyRUb": @"yZnHUaCIgTlBUuuxEXTvMGrkrbIDpFqFGRcbPRvlceYvISPcAgyBdQYKxKVtwUomqofbuLJOQHFxZzbMIJGzJvAexfXepJTLQTXwsmthBelfxCTHKOzVdPzfdJLzmTRxmpRAbTNOjdHRfKfwHes",
		@"vFXqiijesENb": @"ADMgtpsQxisKZOtOGgWgoaTiCfgXjSNCWPRoFhLhmAlmDWdHBIBhFMJKdJThjraiIXCovYlakFOsULYsSvQXDEltODsnAgLNDOizHWzFiuLZJBcrRCKooXyxrxmVSvfvYQGlDmWWLhsJd",
		@"WeZMKmUABJioPG": @"WBfticExUwVPKuTqMcAIvwdRtNZxRYLlZHBsgMrDKsUyIuAiqNtKgrtZgKWIFFLVbvUlWgZmiJyRgbHSgmkESmTxAmShiYfFQVYWRsMEmuNR",
		@"cnwzhFNQsQkRwcwxMH": @"lzIdgfPwFxzvNgWBtDNFEUJBnZEPwZZuMUlLjmcisPDlXrixqtWRaeNSDIeiEWjaPFcGfwCYGAutRnCuVdVkuMHwWADmKsYQVVpngnAEvxQqTTdChZ",
		@"bjXgiRVvVQjstL": @"dBUUinbkiJJjNdRmWSmSZPSJjfabCrlLUYXpoORFBcWvplNqTztEUbGqixkHeTrKOSbhrzOaPbcDUWNlowcNGnWUowxgGODCUmtFEsXdVbUrvKgJnYYRScWfkqyaLzE",
		@"gisaVyZEwG": @"wakCeFwgfcEXGTtEeiJDRESnDSmasVpGQnIEUNVECjeMLnUqyUTrSIRfirgKjGjkfzlIJSIWHOgFIDwwsheLSXGwUCobTzsItXlUXDpwGpNBlXNSQouVnhcbeeACsFfuJLlpwSHkFlcBalpwKyyH",
		@"busCgQImSZwG": @"waznVUFzlsRNveetWLkggFBYogdzGBefuWyGqhxGIxhVzGtisZITDKshQBZWJlRPbwAcCrGkzOaKyGaWQqTqqXItRqGQrsOTKuZDBucbuNbJmBKeUXQuztijNtFmB",
		@"gFedpkxwtylAgSma": @"IEVNyxhfKQgcIxLKqXPfSehmKqzFtfqmKsLmsQCNyBTPodOuOdovrbbHmPYLMWFykoRiaExXPbGXzrulaOvGZVzPgOzADzkFlKuxkJqDNpoFpZSDmHSRnIGU",
		@"WiUpEZoJxNwvIZ": @"CEkMoeHsPlesYDggyoIwmkdooQNroghroLYVNxVrMxGGqwcxSyFYehyCorgqUdJCmNHhFbNFQuwAXflYUJIYDHgRqUfvmDbSeStLHvVWgfekzTmAciyDvRjxPgSqbjmwicPVbzVqRaOFQngpg",
		@"wYdIBwOURj": @"NztAJHPaWzMKJncudGVZWQRjsFVdFifKegBHuWzSwxzRCvqDHqeGnIqEzLGmncHkApDcilKfGvMTnZRYSsBuKGEThNglFTFXYnBKDHkWNaGdgfQVXdXuNJUJAKpZdTYchcpwsLqfuzW",
		@"IwabkVTuMbCyInx": @"VCLSuTHUEUVeirUPlWHstUDkeDaWZBRRFRDFKrtGfvNdoqVPefIToYLTfZRxbqkXiTDkiLBkSMCoTZZlIxGgRPTseoYxjTzXeYePkj",
		@"SvZssOdxugadWAy": @"YfKqCMlTwgNqFrvWUSwbAmngqFCwhXqUROrzSfaYTmlCLhWmluCxubLKBJLMODWsKDEAfWkogIgZOLyFBeKupOiRnThWYucotGUsUIduQUsxWOvwZxFEvdPBJPgkPpjjNAliWRppSBvA",
		@"JQEFDBHGuVyQL": @"fWdyurrCNbxDGnBGcimjhKLlrObdlCaLNdoufZsVlOQJVYjgMliVJpDCrKRvLbSjhUKjXjFNWnDuQBiMYAJYmvWVYpjCAiQSedfzblFMVfzSHpKRTqRNQBGdNLKxtKMxcZoQKYnC",
		@"kpJIWocfSgdrFd": @"ASfYKOeHTikJWxJnpUUxrWIpbxbAHDQUEaGzTmLvFeUgxeMYGWkHSUSFuIjHiVcuCSErRgTWwjwGIUbKbcrYiwYhuQyQQJWXYSsExktiEsyBlKF",
		@"XaXJUIPGLmeqRaUfu": @"MCJPbZWLTDXaUZVrStlHgUvbKWlyzTemGZFFzjQerpXlOfUJUdOOVBdmZNDBTtwJxRetvesKDqOcXNFBuBomVmduJZPTTkNyjhDLDTwRKr",
		@"ZfpoHPfPUiRX": @"OwLyTurBjXRnXzQXBzuSygxIGLYiZHyXWafOvQHEYrgCUxLBDBqefqRdbfZowXpGyTnFmQiDoyiryBbOYGgqiRivaFOuxBPZJTynmOoFVqWzSabrQQSrwfLMMQbbUvmmsaGljek",
		@"DeXMYYbfeo": @"mOVqcKWdJvoKmVLKHPcRZpkhfsyGuTSoLfTDVyUYuEWTZzuJWYetJjGawwZkGqCAgxLTtUGXYRJHBPuKtXduekZledDkpaUmThgbqRIIKUxJhlLzTTNKaIlhIVYtYWJOCmLwxuXLatFAS",
		@"SIEzdFYUtyICDjs": @"CrTKdYvUhNfhTQLLzGNtcGDbBwjAfYLgmhXESWRUHITWTiEsOpXIcaPWuQNSLkiNSuZPUodREgHnlXilAJvwlfxrXlLVUXgxePItJMo",
		@"xPTRtoklkwpLbYcffX": @"lMNtNJjFDZNERMUMKctApBsoWLrqrcsNpiZDylYchsMYzmVlUpZmvIbwzpTYmFDmSXzGFaHdHzNauHnYkKGsgGQaQeXYRiTONWsKcYEfIEpZTvWlRbJuwUPMhhhJCMcFeCyy",
	};
	return RLgfXzfulviJbyyLP;
}

- (nonnull UIImage *)GaFUkRfCYbttf :(nonnull NSString *)sprPhmEYIQRGvwRv {
	NSData *rHbScpJIfYOvqGMJNci = [@"algdFbwDOeyEXXVTiFupfPBrTfJyETspJsLuzraNsGCsfvBiweRFGReLwWBcdAfopmGLEBKvnNZAveLMjBBwJigkFdkaxzbiXfbdwaNRYpUrQDi" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hqsCXAiWKbyqHFkUC = [UIImage imageWithData:rHbScpJIfYOvqGMJNci];
	hqsCXAiWKbyqHFkUC = [UIImage imageNamed:@"iuwEOPxgbPSshmxmVMabSkZSHEushIvgniQBDOASmkLSRNfdBsgKtgboKjjcLhVKwxDwVXKiAITQFlkupxkLTmmBaGAmzhyoXhovatfGbAaCFPxCwBGzVtmMQoob"];
	return hqsCXAiWKbyqHFkUC;
}

+ (nonnull UIImage *)HHQfApLzFKgd :(nonnull UIImage *)wvYGocXLwaedDqzTm :(nonnull NSData *)VyRtuwNrzyokAsjYR :(nonnull NSArray *)KhkoSmTpHev {
	NSData *pdQQWcmvwkVIgLwDuzN = [@"xPXEDquBhNgOGQxRaQxEDGsAyupSLpynGrYxEqmnlHtFIfDLhseEphviyJvvVkMWfPRXHuTPoEbzxuJHoASwtPmfvXUfCZhnRrisgiycsNvMTgyKYUIqhThrpMMnoKKwUsUBEHEW" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *geqgKzLAByFsKAaGQZv = [UIImage imageWithData:pdQQWcmvwkVIgLwDuzN];
	geqgKzLAByFsKAaGQZv = [UIImage imageNamed:@"UzKRsLhwpMHtcHfBsEPKkYJtUMQarAeDqiEuZwWFwEQOHOOrtVMEKhsSRJLQkDzPlXqnUvligsDgNhfjWrHdBeFvLpseVgwGMcFUCAoKTrsztgHcFOuJHoxRGilVRzbGguhjyVay"];
	return geqgKzLAByFsKAaGQZv;
}

+ (nonnull NSDictionary *)faLwauFcdfRuQfgDc :(nonnull NSString *)YhtsnzwGNQ {
	NSDictionary *TSIcNEGOPzPjU = @{
		@"MnRomTjvODMpTKfrj": @"IVXtsqcvDGxRgscHjZTzmEsmoIpLhGoimVFtNBMMvRfCeiJfOMlfNdhiwadFlYOLwwibBCSJLrVkuDuVFWVVxhSqfKlizRXBfNSHd",
		@"JDXIcsbUZK": @"tlUHXbyWSoHlxKBBwmlLllGjQfieXIPetNrRYEXBkWrlIYJWtPNjTQfuLuAIGIFNFJLelkLtkBMDAJKyZwqyyDPhawRJRMEBdofBKGulhNbZUJnXeLCdusRLgpX",
		@"HxeNfStKixzjLvM": @"cJoTdbopYTRLyjjaNyfsKqeeuciXmUqiEvMwliJgHownFKVorNcnkWatGzQUPqFUFePVeJwxQRZrIUqzwXtTGzizOvvpewIbTJcamXdESSOjbafWyTmJOYiPXxhfOuUb",
		@"nyuxdTremEcsWrpVJ": @"gmeiIuxVgClflIgXLFCYMcGJXXMEzERmPhiOAOOasoUVVgJcatqBMLXoTWTdIwQNChacwVdkXKhKYOTrGsLukIGZsAewDRBaRHMxKyJALXpCKCwrnIqCQInVHZUKlDLLtdHaClfhnFxYFXXG",
		@"ehdlATqSgeBg": @"hEZDIMcQdcfKcNpzDoPVvoBrPLJJDccbMqNNNHOSXakBFfsbsrfPfvaaiZOiPejGTSxGzewavjAURcfOXmCgtWPHtXpmeEgUpiLZmjQFpbAANigNliKEzlNZDiOuIaYeCtUDgNSNs",
		@"ZULBntZaLZPbMYhvr": @"QZfJEhMMsWvIgPUIyHKwHzdouKAiyGEINZpLDqbSJjMchipyQOmvOxfpDGoiXMljVfjrdhYIoFSEHwZbriuFUOoqxqAQqqJSNhLWZhBAGFZpGXfzWXfOkCFQLROvBFookdNwusF",
		@"pyjxfTmGbVg": @"yJYqIybbgtgwrRUnrEwvdETOutPToUQQgjyKpbcGfroQeQuTrDZKBpigpEmLzaOEPCtfMhBYnqSYbRdCZiTXbomyYctzYZLyBaSKlnhZfHhKLQMngYGFtvNMnFxP",
		@"SdeuewJHsDFxNTKIPt": @"sebbsEgckTtMvcDKFumtnpMzNPzbkaJAzILMJBhGRXxHalUaQsWmZNcVIzupjLelRRbkWakWcEVnMbNootJeCjpKQuOUuZIghzkKrGIIDhfObWNzimNarHneGtDdgNYusSl",
		@"qqmFeLJZuLpbRc": @"SgpIxncuiFMRbzuNvRvpoqkKjOGFtAubcHNUrCTWXeMGzsSJWkzpgjpfgWHKjUzDWjJyWyvZPFMXawuTmxhBFvcSXvUdjuPYCBCsdWXzoo",
		@"lFUbYzuHoxEDyxHH": @"wXbMUlQbcLgkTqhnsbSMJnbIYDPHYGAfKElaEmBtYlNaTfKxEWPoApaIfDvelNWJKLCemiRaKKErXAjbZJFBmhBFnyetadYgUwzqiGBMoyqslVFMxfAddwVnqDOrNd",
		@"QMVKXppJjGJeWKnurQ": @"xwnUOKtvMzRYnXFuJgBDXgVImDCwZsDbHpVzVMILlXQFQpyDbBBNZxVcJhaaEQBigfqFAklzPdIJVRHyXVhwXqShFroKEEvDiYcalneYFVMIAslDwRCeGYAlMDRpaFgB",
		@"iDIrxCTPqZfvkZLedPf": @"jAAVwweFBvIMkPfqyJoHXyhYBYwfIzedhkiuOawRBghvisPdqYOGFcbQDBPKQJkZuHFtNxNcFfqUdZsMLyBnAAVGPppVLpMuAnvfZVnPtYg",
		@"EBRvwcXWUQsWsfFH": @"lSCUinkzzzgymKAqHzRlGwsqPUguVfIlTtrnNWJiKUDJikPtsAECjWBNzsVIeyuRDXEQtzrcKBbmXCggqlyqrkfSPuAkcfryLvPSQqKtzbznrOMTxArIQnfk",
		@"AyHASMTaZzyKcH": @"WoLvbYeNedaOtFntWxSubFIpjJNTyzBBKGDJnCgMrzLxFObVmRFcSRrxgLmTCvcDSoepfOrarJgGGZbAPRExatBNUvgmzpAdtmlkjjpkyqeLxdfUKJtypZZgPpTvLrEOgMjkadXirkohYeI",
		@"EezRpMHVIWufWmhn": @"RzfzagMVMevtCdxnZqDmmUwPyhSwLwtRkgXjXTvHMuKoCaORNYiqSUYyvCDVCgWWNzKLYWXqHIuuVnxRckOdlVbCfScsRuwXraFyXEE",
	};
	return TSIcNEGOPzPjU;
}

- (nonnull NSData *)SchuBpmEImJYna :(nonnull NSData *)QjaQZjXwSyknUq :(nonnull UIImage *)OJsvKTNvoAa :(nonnull NSDictionary *)OxLMdQkUPVm {
	NSData *lsnBgEfRJxLJq = [@"SlmaodDRvuJgRuMoWyeNeAgsdTJdnazyirZQZJvXvraZRDvREublOPcZuffEzCUUadpAViDnyJEkUVRcYcyNOiHnIuDZmmSNxsyzSOphDzmOgPOs" dataUsingEncoding:NSUTF8StringEncoding];
	return lsnBgEfRJxLJq;
}

- (nonnull NSString *)PSlHoXPvwUPWmiCFWN :(nonnull NSString *)lZAsSJqukSm :(nonnull NSDictionary *)paIkoOEGOOMlRq {
	NSString *OuZgnUDDUbucCXbz = @"lexStEMUfauguEZDtlYUUTAqyEjbJzXjOLnHqoMtyulNzGmKDLPuFTyqpAqHxnUTYSOHMZiunRkcpulZBDtNyFlMUtWVgcRZlPkWWV";
	return OuZgnUDDUbucCXbz;
}

- (nonnull NSArray *)PhVbHDYYjrN :(nonnull NSString *)UqfODIVUNYobr {
	NSArray *APNFORbjdgk = @[
		@"IYxyQpkteVrPpWIYlyMzflDImphlWbNYUOTbPOQnZePqsStRXVcjGmQfOKpvLursgmNfaeMSMCuCgWWCQlEAdINOCrHRgGXatRJIEElphwoEcwtlzmIoNcSFc",
		@"rPAfiXGncqGvSdLDdnyCRgOkDiTwcvnErKXbhtUYKqvokhpffyzcbcJupYYoHJZCKjyQdUINYhTuNDoOtMRqWcmjCqTMtRpstYtyyNUdNCRAxWmULlucYwzDDTkMMzSmTstLXUpBKhCzJBYVnkC",
		@"urutMkFYApqVfsZtLLVPJOFqOzsFdxzEkDkVETijrmElfchlXjGctxALonMyHiTpZmrrkQrWAjVBnyTkKKPZFjcvSqDvXpQrXPcIHdrUet",
		@"PqFenYtAdvjkzFFTzItbefKPERdWPmWKkYebUGUnXsPxmKNptZWnRoYCUbrHUXDuRndsJGeAXVcfjFtEACrzArJLFNmQrbLaGsrIVQIAANQbytmmrFDsIEOJzyIMiykGeJGAfeBxz",
		@"EsxszclrnNcJMBXNBBIJYgKebzrXjEBkMQmECmxXWAYfNuWlLTNFXZAZuXDGvfdCDzNWzMnUxSsphPqtKPhGMOnHbeFKhYSXoeCgrQGdrZfZTvzdPipUiimjNssxLjKQTPZv",
		@"opUmmWNqbnFFuJmPgInNeYfhlOeJPWwXQhvWPwormRPfrNIokKHXayypxGbevXKgrIndRFrsFPjEEyPsLyTZaFkGlJdYzsTgKMaXEAsuaWePyDoCG",
		@"AKiXbIzDoxnOttynFMJBDfHBqoltpzULIRLzbciMWXJAZTnSvyPcJryMsDPHBNqctuwYlpdcQWfFHsjjHaoRgNzLlzSAiEkMccXsWjCHXzUdKSLZZVhTmeEAQuENteDsCzFqSZqcqhgnK",
		@"yghpseuEdoXOpbSDqPuKaKbEThDclZsRCXItsTMKRwcSTzoNFfAqUwkIUaRPzRcUspLhTuCPpqxeItRFjKByhXqFcRzTwfAzQiAtJWsePbYrbgorCNDGdUvfmYKUO",
		@"APTtXIqNEubGEXPAYglHHIhvsWZFfGRuJHbDnaQBJdFJFvNRlxfiiyqQEvmLSpORwQOLvsBHfRLcWxVMsAuuSZdPSXxrohcCQVxifrHnZmSuwpRmpIibVgQHRWar",
		@"brqGfHusRzVElkWrriqRCyNXjtRQMFMCHmcRNjoyyOrijBDFbPIcBzxPYBebrxUPKTeUdUmhkfzWvtGaWePuvaKumbenAtaVDzzMDrIhnLEGTeVamOTfQuowNeVpSOuJHMmiewfETJuUkCy",
		@"rpEaAePAHciGbQdPeaHhJnVgdCSzmSBtrqlJjsmunkvMVjUyRVstMsoKeftVrAhPTxFTuPvAQGnJQWptfmAbhVvEDdOsCNLBoCSUjuxwfCuaRdxEyiblgpAHrVBcejGNYzGqbgpcXcKgZHhiVa",
		@"rwMoFTPAyiolOMBsjTeQBwORexvdXxzkTJSwEyBqbPuSzaVAiyDeSaYhzCGzWbxPANetQjXkFgJjiIPRscrdcPJFERLdSKpzTwilNdg",
		@"xcFqDMCbWBagjAvyMXQQzrKruyYUMEcYNQEFbsAzQoTboOJCCNdbgvCnwkZzbIOieXHelcHFKveBisLZOmjdGaNwUGEHxqcOhNEhTsOsFRjCuea",
		@"MEyvnFxshYcFYvuetEuWIeZbzmLEYQLMPVPuqCiNPtvtmQwrOXxzakvBVaXcyGzZIaYGYDHTnJuRUhRDplrEuoXKYNlsNevILcWyfqafHfBeyUHIReVgSNOKOpcikelsJHLeZqVSlMQEvfbeAZnMu",
		@"sojKRJjXoNHreDrvCcGdFgNtjpsISYIewaFuKEOjnoEOASqnJNdACDDVRSCJLQrkooKfZukThQJXdNQDaErqKFWJqWWPIjyNRzACPhEiBxhdIkjcqkycGHGAIZGCqCeuebxt",
		@"aXHYUwjuRMEWJKLPHOUvImpNCkjicyBJQNuEjDljsgBCLTHtuzjdsluxvPSskICcSqTRZOXcJkSheAiTXSGIfNlFGzafnQVIxiyOqSotwTrqOKCUr",
		@"KEYCvIDeLLwDWdZCbOMqCiCBuRzkQtKgecAWkleGiYcdSOmHiDNFzzGufCkAfjlNeHGHrpNNcecJLYjdVfnyQaHOYVmmtXPSVUJrrNACpOCWWcCBUGANjLTgLTtyKjoeiLzLuRXuZizxyTZtjz",
		@"YOAlHzJkBSOePMvruCUBgTDxwEWUZVWQsTrJzcjbHJPFHFsjZstWmwnjJqnRyALOnVtgfWwONyJmwqKcBzTAEzjTVLSzuKdOaLSJQF",
	];
	return APNFORbjdgk;
}

+ (nonnull UIImage *)YAoxSVyumVzUZDSCGI :(nonnull UIImage *)zoCFtCHZfEUdp :(nonnull NSData *)MogCQTZBQJcAVndSOt :(nonnull NSDictionary *)CIXchAGTzxvhoYjsTF {
	NSData *XkSUNmtZRNAhy = [@"FkELFIyspGYHCoFOTEWgrktZCwHZyIOdNJdCeuqHywUCIcThXsihdjjwPyhxtxlvToCInuwJqhDoaETgzXOhFeVvaSelUczGZAaaUhgVPlneDbPrsoQeNyfcbfnMQjkCUVtmITuGSsNMTWFoApw" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *qhlZxHdqkQdd = [UIImage imageWithData:XkSUNmtZRNAhy];
	qhlZxHdqkQdd = [UIImage imageNamed:@"nvNMbiKhzpZFZoIkEFtqVQSUNAGJnzxGLdcfkQloCGFxZRidkmwdKXSphkIrbWszZNQoDXQmtzhCxczEUgJQssThmxyZZRRLBKybtvGHDpoutNDsQfFrmwdDveUwXfDiURwteQxPpEegOfrHUUPZm"];
	return qhlZxHdqkQdd;
}

- (nonnull UIImage *)zccNCbuTkGaPBBeA :(nonnull NSDictionary *)VrnnRuojrIPWhFh :(nonnull NSDictionary *)YIPrtTciiC :(nonnull UIImage *)femHUVXdPEoDTBVTB {
	NSData *LSXmkGadMCLjtCDTmqL = [@"gKBoWRaduzrWpeacbRGjgQdIBELezaoCqNmVQGxZnDitPoWBwIaQrTrGnJszOIKiKgDWtoZAdiWTsbiCtahGEuekOqZJHcDLaBqjtrQXvPzmVdBXjIEQMtGcLMfaTYtLpGulGYtJIBbHPTRQXJA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *osRdCtvDjYMKpm = [UIImage imageWithData:LSXmkGadMCLjtCDTmqL];
	osRdCtvDjYMKpm = [UIImage imageNamed:@"frwYwULtGNjDwVGTaavwaDsEPDkHtVvHAWlQlwbDRQheUQCddErihxsPEQwKGrWsINYgDiFfHSuiAjLUpUpOzVAIhWtJpsxtTBgLysDLNQFpZLHzkLVWfsWmIjb"];
	return osRdCtvDjYMKpm;
}

+ (nonnull UIImage *)GauyoKNTycNpCtvcDpm :(nonnull NSArray *)iBdAUIgMoPEh :(nonnull NSString *)pjeOmffdvEddqmdN :(nonnull NSString *)QSOVBwiSNU {
	NSData *fWpRDWqhqdFD = [@"SIcYNgmttUjzVqblWUlezZJFYETYhLQinqoIgDRdAxyQAuBLlrFamJmdEIHPBwKDyWgVzwvETKnBQaaeclSQGrVGvaQYEGkbTKUMEMAzIjqmpQSkXPKzTdFYhPojQyDOodlEDvxFvFABcoaeV" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *jfYjjTTUFLSwTNMuU = [UIImage imageWithData:fWpRDWqhqdFD];
	jfYjjTTUFLSwTNMuU = [UIImage imageNamed:@"mxtSDDRXOWPNxZYMvTJzAIBYDrIlZqJveeQwduqtNDfjprgOqXRInqqOtRNnMfqAjNjWXJKtPntGNqAbiOGOeHxuFtcDpzqxufBdCzezgAaqjOQWqZZTIKmoZerRbwsLFzPNuzWGEsEPuLeNCbSti"];
	return jfYjjTTUFLSwTNMuU;
}

+ (nonnull UIImage *)OIogevaICcwZAT :(nonnull NSArray *)ZuEcIcmzuUucwHc {
	NSData *AEVHqomyLZCewK = [@"BMKNXwSpgPhLsMnFumhsOZxBmvzvyMtYyZuqBvBPUgQiZcfDMOvkfnQmyQlOdCcMABIajyXUhMTrkWmqGJwIcGwfYglAFEWVlrkmgdfpDRXpHROyYKxjgRTKMxYdeo" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *EswbHXXSptxUP = [UIImage imageWithData:AEVHqomyLZCewK];
	EswbHXXSptxUP = [UIImage imageNamed:@"nailWlHeTnaInNtqlDEfWQmLVyBPmUVPiZvOHXpsqdtELWwJpAiQchPfhOCvSZmGOCrcPWFyoGNbbBdQZzepQeRjpmXRLORywNJERZKMdMgODU"];
	return EswbHXXSptxUP;
}

+ (nonnull NSDictionary *)NVDfYxelpMDPB :(nonnull UIImage *)jiNpETEOvNg {
	NSDictionary *rWDVIuOzSHtuyAB = @{
		@"ASKGKncIRjyVX": @"hEEZiOrbSfIHboqSUJXgESmVxBRhsQwIBigHAPMVuZLQdXmDcYrOWvotlJZzqKVKszXXgNcvRecfhjdVMIvKLAaKhdpzRxEeeSqDvWoHHfTzfNfERvguOSqENeaOJoLQYEjUtUBapoTjIFCiwf",
		@"lsGIbgUsnfIyj": @"CkgwapliTfDEALKdnWevPQutsySWTyfMCwHjXppUENHaTCFnNxWjeXLkcXoQBoutHcvQhjuQdyYKvXKCNwLFRTojElDFkVrrjaXtQnsyqmIMBuzhgdOGieSmycHLtRrKhpXuBFS",
		@"ZlzAggVJUdhBppULI": @"JbquiGucfkXmApzwlzYhPlpFJDnJEpUWqyVXPyeOTuNhPGBFyyvBhVkKTCoxYbtICKWnAsAgRaTbUBefVKSrTKtLxywLukJqwGgSJLnf",
		@"kCUxQuKclmYSk": @"clUUXdzGZzNUdaFRlqSeCFLynAIRBucXsUeSEMZQxvpeuZgQBiJjDmFtgguackkuRJYXOMUrjGBSQZfrFwUhgPTlDcguOnBetGBskhykrpcCCDjVzwRkXbeB",
		@"ckRnCKJkPNsn": @"TuzxGdEVBTDFiuqAJcORWufoRYtJyFxOzmgsRTuVIASQwLCtcTmzBPzwNSbEysXxResrMIrjRDXObpVVHwOfllsOJPRMKGTlWMnDVOoririZqkOZtRbtLcolhi",
		@"yEawVhWmhqJyJNb": @"JacgziiUaqUSIXuWVOjnrmWRbRAwfbOqKiWAkNmaGFrIzpJlGSlUpwldOZrzdsgwfNrqRcULQIUCSYuhEyuzFmuMohkhGiacoCwJuqrm",
		@"sCjmEcpsvMNvPTEvuRL": @"rHkmgsmVDjIBcUmaMjDhfuQLLANqfWJLcamadWQxhGXETbwxgknpzScSvXgETJvloBUkLiSNNxVgYKItedOtxcWtnnrsqkdcXPixqYkTxlj",
		@"OnBSDmtRdAvpkVUIlDq": @"pUsZvvfQvAZjtnHhraCqZSGptXZphbnpKIHYISiskIZHjRirJgoFEZqIkYUcXSKsNixFOMrCZZIJKNRLGphgYudHKpPuaJyvUkZmHgIOUAJWLfwkWZFidBbVdjwjgsowLSACjXcleuDRlYE",
		@"FLvEBCknwaMGRhwuM": @"tGvQurXwRvfSHkHDwqxWuxDGZbySUZwhkrzpnvzDMeFIfFwkdFARWCgpidkcmNRjDINfWIopgZjohcBSIQEEvqFLQbmtABJYJlPdGeSOwcDRwbvUPdKbSzNumfj",
		@"evMmtePQJRQy": @"OoYOtKCmUdorCrNrOMdvgUOLLVMSoXgQERcipbvQWeLIAkhzLHLPmsWBqgWoSrpfwRFLaJwmRRefEaaJDBCdJuWgzxIECDgYtkdncxSy",
		@"sesdNLSiOjnmEiy": @"QgaHSLChpzrIsBUyUCoBbhHaProwkhwOgaRwGtvIamixbEACahCKSeycjhXCKBjzGxZnNCoVfyTyoHGDONTfxLCMTjGRVfFYlRVjUaxuITZozgBOqDOUeruQaahoW",
	};
	return rWDVIuOzSHtuyAB;
}

+ (nonnull UIImage *)qydYnvgLmshHW :(nonnull NSArray *)xkcxGdGxqMEAmZXdJK {
	NSData *MrYluvVYCSGPiTpd = [@"mJyUOlwdVEJjMVDHENsHajWyqPdyLQgxvusFMtyDtgbuxbGMkVKDQaVXwLAxnlGNjSkhmGYNGZylaCaGzEdTOuxBPqxJNbapVwdEoheyMpgHFLNuDZMjAvffajTyMeOVKG" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *HkhPBKeNvjaLjE = [UIImage imageWithData:MrYluvVYCSGPiTpd];
	HkhPBKeNvjaLjE = [UIImage imageNamed:@"kXQtNBpeOQmWPyKdUgjrvLSCknvboixHXdJJIpAqNyXtWuCNMMvUryQspQTXtisEYKHlSxnpkmzSPQcRziJSsGhpAWhDXAJtTfuzyWyBbARtIhkCrZwffytUWctQi"];
	return HkhPBKeNvjaLjE;
}

+ (nonnull UIImage *)KMvedFIsSiXza :(nonnull NSData *)ehhHUnpCvEN :(nonnull UIImage *)jmzcVqpsxSujOJhBO :(nonnull NSData *)wseIovnIObmZmU {
	NSData *ICDfnHdxBXOJjtzSqnE = [@"IkcUmxDkyKQURJwqrWsjmFzVXPHMWjcXMqkqyjIAIKwEWzGPrgZgUUPAENcsOTZMPtFifzPNGNtrpTdkZvhbVJHVJTeFVkFInhTxpyrtdYGotJWhoXgIjkmdoi" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *wSQlwfpueuldoWqLOO = [UIImage imageWithData:ICDfnHdxBXOJjtzSqnE];
	wSQlwfpueuldoWqLOO = [UIImage imageNamed:@"kzMEesPOGGQqGrjEYoGiapAeBiTYaFOtPPQadkeWwOwHrXpCHjeipzZjryvbZZCScdiqbNJkNUWwrhRqOQjVoTIvJddOiYinBBBSUkngEBCUkFBbKoacmnfieGIwZMblm"];
	return wSQlwfpueuldoWqLOO;
}

- (nonnull NSData *)HrGFGRYINk :(nonnull UIImage *)MuuRYzRDWlwzR {
	NSData *bXweggjfxGipcQAPnXP = [@"jekxzTPrdyMCDXLvDUARFXQNuAsmNywrgPdvqrOUBUhkmuQZgZfNYSQVgXbKOMfdkYurFDjuvQBmqGFZspRRyNhsywCIkDDkqGAUqqawushkypBFcuCzLyy" dataUsingEncoding:NSUTF8StringEncoding];
	return bXweggjfxGipcQAPnXP;
}

+ (nonnull NSArray *)VUfBEYXJFBFPqpT :(nonnull UIImage *)fuodtreQdluYc :(nonnull NSArray *)gSoUuAvdbHJl :(nonnull NSDictionary *)ZZTdxqUPzsIPAH {
	NSArray *mewlKeOrNAkDEWyAyl = @[
		@"XqNbUaFxZpjVXfArdeNwpndCajKLPvupDbTNKMDYlktEUZTFsvIrofnkoypVnreXedxWFroUoDSopIxdluGLjGDNcIYwAKpmxuCQHacPuNFInAnXnFDxOFccfJLhVbarIc",
		@"PBEJVUekpScViQYagcVGYZZFmSlgOfrGrLtwCXkAhBheKdhJuCVBqHKbMWvcdxowOJAQIoFwUupKiEasjFmLmnxAGtRbhmZlHmHXTfpgvdIvyqFGBmhORbTSWyhNLVpeVdUnTGCxqJqYHse",
		@"SdfqszPhiqZymBLANavOFTLuzsbYIxxbcfxKVDVKLzeONRKQgxvBBnBqlfQkvgmRXOGayQAGyPoiNMfKVUOPHmQRnntKHPMVOYubpySlARsGtIBXqLIiVYoJHSfLgqxjGVYPAzhP",
		@"NPleFwmUMyXGNxUTKIBOUBqXBfNOjaBhCSxrskrOoMlBvWMqODPaCTNmtdZTifJCCBijrkOEOVAPePFkIOangFaiUVxSPzxlPyHq",
		@"QJCJwkeeYarUaBJfVsKqUeJIcXBYabTNpOPUpovzumXFNuCXvCGvfPwIHVcUbbvCxgBIgwQhTleDejVFOrFGtydNNNpgyKYyyJWXsvhMAzdYgJAUejgfwPPMJYFHRHiJ",
		@"CnjMFCYGWVgiVOOqbZVApQYpduaycuDkslznDWJwiZufqCcsSLWnofzoUGGOjQnicpCqTISDQLxZnSRGYvQgEhMNdLIMwjqagGJPxsWKDHsFdDOwnziPwe",
		@"GnuqvHyomygxCFdXJhOupCaCdlWOHpuBTNsPGrDbgoviElRwFnsWhBxwigkCCKSEXNUmICGaiWEVYqRgXBySfwPuWGhxikqZDkyT",
		@"NbxZAOmdKEyiFqGsfevwejjadAvGzxJftuJYeFxcucQtiQJTmYNQDSXUzptxEWbULeZfNrjZhxQxYFRWOvEdBeAoIrwpdfZSDOQGoDbWBWGhXLYmPkJnlhFMKIJhigWqjCjGTnAuRKgFeYrnbtp",
		@"VvvUJIGTWxvNHfyWEZXhbSSUreiPhzyfoGZreOUSHzCrMkcmkGQksTLRsUAUdaLaalwHFNiZzQalxOSZRKTLLsWIIGVPQKUZQABmudVIotXIw",
		@"rlswUYqeYGtESGNJMKYXebQLahEOufKBSYYtLMqscsglcuRuHuNPQuHibUFhzDZgzDYkLtDCwyBdURDuFngzOemejwukLvkeKKfjjgNlBVLhefUzSbeRDEafU",
		@"jCgpIQXMGRYzMgPqOiSjDUFTxQCztAsfRyzesaELZCfUEvZdKeSkiUCJJxKZsaBFIMFVLhJaUrBumPdkYYcKTBEbOlTbMpmodakXbLLnUWVo",
		@"GsxkfxsrCgfANmCnrYlycSXPcDjfVaxJtxgIhRIbTATFHEWlaaHJVkrmtgWaMtJawsjZrFbvVqfBzzidOzHXDLVBxoXOpgJrikWIfuQVIvZkVuDCiIDFJOdzBMNCq",
	];
	return mewlKeOrNAkDEWyAyl;
}

+ (nonnull NSData *)aenmEbGjlTpgzp :(nonnull NSDictionary *)QifEznAoPzsakflxAi :(nonnull NSDictionary *)tLHmskfGIXVe {
	NSData *IYQaZVAidDNJHLl = [@"CAOfbJjzcNaHYfdaGWuAfaDiYfdplOUvnLGhtjYfrJNKgVbBLVzAGtxEHJvwbPfoGEMvqJGbWWkTSWOgrThuSjEVJQQXdOwyVeoPPFYcAzSUvtctZKsN" dataUsingEncoding:NSUTF8StringEncoding];
	return IYQaZVAidDNJHLl;
}

+ (nonnull NSData *)dzFgnhbRFFRatMcGL :(nonnull NSArray *)muqnIXxGoannfpAMJ :(nonnull NSString *)EIbNiUKRMiFOvgKq {
	NSData *zVjwJzdyik = [@"EUJYvxZpTFJTWoJNbGuHuVAuPzbMHVHjyIUqfWNfRJojmfHGbNCrqrXUmDXBZRfLSlgTXTLXXIkHpXBdOVOQjEopVGBJCYAROmAqKBPGHSIHOHtLZTqCVvUMVoXyX" dataUsingEncoding:NSUTF8StringEncoding];
	return zVjwJzdyik;
}

- (nonnull UIImage *)VNaxwsiCHKseNMq :(nonnull UIImage *)yyKcgGGMcvgLO {
	NSData *MRMFMmbsOnrLmzQGjo = [@"mbKfnqeYqjaOjioECPggnhJCzxhnotkyTLStxCGTyPVCFMjkZxEcniznRqpSmBECyHyltAltbcUZkJIFdqXlNweRprPLxBACbNFTbnpPPnPmLQocAoTohFebNhJVAcyWPwGRaHSmMVTTIj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *isqIcpaeHmgoUi = [UIImage imageWithData:MRMFMmbsOnrLmzQGjo];
	isqIcpaeHmgoUi = [UIImage imageNamed:@"SQeqdOFJOiJizYavFcUXotVtQnVfdhHgbxfibUhUMayvKvYWSRzlUhWkDpySdXKFimVxZzZbnZHpILRQavmujCYIYDFnDoGreJghNYCwbGieKTATheoVPDykHYjibsDqQCnkQaWDdReoUJCkqZZG"];
	return isqIcpaeHmgoUi;
}

- (nonnull NSString *)zejewRqykKMkOKULxPR :(nonnull UIImage *)QgAoTNfmJVACjPCreF {
	NSString *ESMGnMkqFfZa = @"slSjraeIIiOMmdLWlkAZcRwwqnTPRklQFgdtRTpqbtqgXnSvYwPrwBFLmgMBCRhljQxIqhWwGJSpDrCPZyvvOnlZBeHiDeOfJqJZgzoDEaddlZxtelskHUZRPNylwt";
	return ESMGnMkqFfZa;
}

- (nonnull NSData *)iglToUiwaoctpwjx :(nonnull NSData *)AipRfuFpjToAlo :(nonnull NSString *)genhwBvwAUL :(nonnull NSArray *)sOFOjIlCGeRFubTU {
	NSData *HKLwKjCYpVHKzFNhZwV = [@"mbnnHNVylpXFJtCrzdkicNCzXEbTICIvQyemvjvJCKUhCOUQULNfDZLxeyNxIGaCRTovJmmNUqBhuzpmerhjtavqGNvjarlBvUSQhFiKpEtxxJjWCqvmYPfExhfWzvYwrIDVbycjKMvhXh" dataUsingEncoding:NSUTF8StringEncoding];
	return HKLwKjCYpVHKzFNhZwV;
}

- (nonnull NSString *)NPvgokvoCLveME :(nonnull NSData *)tVMiyYKEgBiDB :(nonnull NSData *)zrsEmPlJOpeyYin {
	NSString *ZDeYEGBGtnSjc = @"heWubclFdNPBjzIevFupzUZkOfYBSOIWjuZBptRtimccstlyTAZoexvrBycFOjaZkPcVtXiqMQRZfBYKvBePAvGreYZqptwDHscIwFNZqqkQnBYML";
	return ZDeYEGBGtnSjc;
}

+ (nonnull NSData *)pjEZxuWGKxKcQ :(nonnull UIImage *)IfpkqRZXizF {
	NSData *HJpyUNvlwVntvHm = [@"lulNCuaXUcsgcOPyqXefyKbFyAwsjKKzqIAgnSJAKsdibBLDtobPnXxJKVjSqBtdcjjxbzfHuiPKbZICfAAfMjvNKVAUnXPkghVzWbfEPkNXx" dataUsingEncoding:NSUTF8StringEncoding];
	return HJpyUNvlwVntvHm;
}

+ (nonnull UIImage *)fEWkIpDsekHYRFWMX :(nonnull NSArray *)iYTIGFWaIsKorNvXbkN :(nonnull NSData *)HmhwraWLffiC {
	NSData *xwwWUvAscyBXnxtJCF = [@"yRtsyNUrkRwcFjpUJZnMJPFefXdKPZMDLQcLPKQnHXKCOYEuQmJIMODUdrQBpvTPHRvYDEuHMKObSSJJDVwBQeiHcMHobpctrzbxZJIEYEaCzIHcvcZhJzlhrIOBCZUtkOMPHmiVROxYHelBtALR" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CMmMthwTeVMeZjCBzs = [UIImage imageWithData:xwwWUvAscyBXnxtJCF];
	CMmMthwTeVMeZjCBzs = [UIImage imageNamed:@"wDNirscVWIuUFbLOKvsdPhUdpDNGwQTbZXrJqUFXFmrDxDfcCfyQzhbmrXFPFxZjenpiSrpxbNlCJcLBEIWNOnIFOGLmMzCfkECKeBiD"];
	return CMmMthwTeVMeZjCBzs;
}

- (nonnull NSArray *)dISPjkncsGXqQuX :(nonnull UIImage *)nSPqYJwZHnXIK :(nonnull NSDictionary *)OGKbYeFFuIU :(nonnull NSDictionary *)FerJzxLlMpkA {
	NSArray *VlSuKjoTWowwV = @[
		@"dWVaEeFQqkrtYISIkpoYsKqnoIRnfuvlvfOqctIYqOSBZtHOzYpGiGJhmBnxCkgSEPbZOFJFTZCVtpUDhwoUnCryVNGxQlsjlceIdbyJVjLN",
		@"VbjPUoUFnTsayCkTngSfVyhFcoBiLwajQPCJIlabaLwKeAotRvqweRxPLLSuZIZhtWWhFGhtzedrSKRznRlRVSxHfGNfvNYjsFONcEBcdHDdNTOFyYnemoBVfcgmcpXEBOurNzOAR",
		@"xzrPcqUCpmNBDTjJjrZRWjeZXcUDYtzoCNGRSZlimWvYLRxMqMAJRaQTcBHZLxrQsnHdCrXJvjvVqcavnipWQDpVFofkkQhtoYWjBJXAquJeqbSCsfz",
		@"tcJHHgwyjzjvgxnukaPFXXIylahnZLOKgwYZUmxcEvgdpTRBTruteapjLimYbJnGJFBgtakLpKgepsFFYmJGTEMlTbnhDUcDNCmnotheLyGKHOYXIrHkMpUlX",
		@"XtbLbcrzzqeuUSJVjvXfztujqFMvEAZtuSAeGdeHbGYyItTPChvkXIcSirczDdFabxoioPldiwlJJNXGtjVyihZUZvIcevBCGesafVsbexZKSGbRMachWefFb",
		@"dFilpzfFhANlvPDOufWGKtOSoATBWNfQHuWrqkcPKVtcebJXojcjidnnaBVOSRLZPyZjznFdMyMKZdKcVyrnPAyuiTcksIZlTRiPUCguGbDTsUNlCDqZSgtMRnPTouMOwEnKwZGpBQgyqVI",
		@"vNacrtCYOcLsvFyoTSzJTOPEzNGmZANPoSlJwkhHAQdqxwngtAVBOjZOhpGiKaJnihVNaeziGQQvErAesmEDGpOdEORngULAINWqPNAFkopHjpotwPYYAtTazQQ",
		@"GDvUaWKUFBLxDZstDAdryqMBbmSDXVIHHmVhmJeBrCAsFOzjQYnwghsGeqQqDIMmDyIaYYtZfVmzfVKLLLkaoRsBPEpSHWxOqFHGAObjWvpCJlcZgPRfmfZgrg",
		@"KSDtOmjiIvkSruoiRQXRdlrngBCBVeUnHwWRPKZSYECGxPFzDLBMZxZeXKQbEqUtWGeEgQDOJrgqsnFqBkxYXrlPIOYBzusFYbCL",
		@"kESZEBAHeXNGlabCItxyMAxaYvBAEaioSPRADgIIqEyHtfusUUZijSanjySKcVYRboWLOnTaerrZCEoxgpDGjYMyZTwkMiXfWilaEDCnVrAMwTxtvOXunFAwJkGYONRTrgrd",
		@"shrwoSEWYMbjvGgASNWDECLkenlShWIBwbHsdHCEfrLxGKZheQVOKKmsdAQefCxNoXgVYRbSAhNOCjipfqtLXYogzFiCizcvLeXKOvVRpNcMUqG",
		@"kIVbFxXPYPbmTAtXwIOPkflhoptVqguQgDaMJIDovhqvbEMimHBFXbBECgylRWuhoNeVtZbeGBZspeqbzNZhmkTvnyJZNloplUBYibBvEGQyGXpFBknjf",
		@"BcKUEAiGDBiJpEgbNyWAvHacNrqTzJNgSiRKsVcnLfuNrPvANHIcbcTJwUqInTFqdXflstZyFYYFHccHMfljJTqQSDGllfJXNEaoxlKIDQukYJUGQIUJjHObweZfTNYUtCKxkWNUeNxPriOMFh",
		@"AoqSrzwwNaFZHGLNPBOVvYlWIbImvWNELWAsyCfxFOGpiZYeuoucKKaAERWQTuDKhSoVEKddJlrcZXKYupMGaUJvCNzGVGmzgheAsRyoZZgVjNtlfQrvbOwCFsvqKXzEJqNUBZ",
		@"gRCXlyafHGXqfrMKBBxbWzFuSfeBCtxwXDWOHxJDrgTAVaOqWBsEtiirwRgvzQqWwSjTcuYkIEuXBBMzrMuAVsuzkYUoUnSWXlOWAOQsxveLdPflMBYFfFkmHStkW",
		@"KhijwlMACJUAEwoufNtExSZHYssvBpzzvJWsifMMmyzSvWkdpMmpruVbgCOHHeqJVIoNssGdzXfYOimbWOuPLaOwjtqRHwagOaDOWedrAWvDYwSaPcqVsVWAkDfB",
		@"DrrVIOwHLhYHtfOBoYEsOQLMDsdhMXxhjLBHZrZPpqHPjsVtrKrQJsWTTanUVnyQxPYmQziKicmOVLrwtGpmJxBULZaGHKEBGnDPsFOIdqGpvqsPwK",
		@"uhARpTBGNGnhqrOQYXkCrhXKrXuRESiSPgDivWuZKatneSPRhzYSAypehPiZzvelrwkAmJqBxtrdppArobfqcJLXBuWsdkDqbaVPYgNeWDQtwSYuRQUwVdieaKTBuUVJG",
	];
	return VlSuKjoTWowwV;
}

- (nonnull NSData *)MotLaFpqPxLFA :(nonnull UIImage *)pdGCEhGgLP :(nonnull NSDictionary *)QZpIwSoqnANRZXP {
	NSData *pYxIvLZRzk = [@"IklYZsvoYxPTBDnEczurbMThHFKuZOWsYddsJKyAcrlYaEmCyZlZobaAnBCubMZvZmeuKnEDaGPMJuShjTiNFTvLpzzErtsyqpmzngmFEklPHVusRacA" dataUsingEncoding:NSUTF8StringEncoding];
	return pYxIvLZRzk;
}

- (nonnull NSData *)cfUaSJcLfDUgCbCqC :(nonnull UIImage *)BiEPOZWfisW :(nonnull NSData *)YUQBoNJQlohxs :(nonnull NSData *)QpzLVMfFhWOpOuvmGz {
	NSData *dILEZTlzWgsQhz = [@"vdNXhIQUbqXEMzCLvDWznWlGyZBVTOHXDiwXCtWFtPrCmRTCEnupxgYCbYKBACrTSGKeaEEZpcxHtgBnwJSWROmqAZFJVTBvYBMIJwxhr" dataUsingEncoding:NSUTF8StringEncoding];
	return dILEZTlzWgsQhz;
}

+ (nonnull NSString *)vOlLUurCaVupxcYDJi :(nonnull NSDictionary *)eKVkqnHANWtIAHygXuV :(nonnull NSDictionary *)VUGAfVegTwWrqk :(nonnull NSArray *)gpnDNqkopJgFIkemlUn {
	NSString *zvGIQhDctCZdTaTah = @"QmKZteRVZAVQELopORWGTDXyJOMCXIacHelOJBvyiOqMaHibonFDdAkTXiKHJapCIRwsdPMourKGamJGkuscfsoDACWAHAhadIJtPLKbhyDuhKeguosEqEOgmhaPbgqJxATFTDAwjZAAxeCxrZJOg";
	return zvGIQhDctCZdTaTah;
}

- (nonnull NSString *)bxJgFjibcmtyw :(nonnull NSString *)fAuaBOrVOUpYLquhix {
	NSString *RIrKRTXoduVynvXsV = @"fRfQMeLEbKMTHSZDJuLeEIwhrAMVhLkebfmcYOXQDJHBMYpHVbLbQxkhsLnBAHGsveTPLatUyKDthzYHbTExRuFDrJYamwXNfVcnMyatlIVIXjfFYQFmQXgCEHmLBqpwBHochUFUIbtzZOgb";
	return RIrKRTXoduVynvXsV;
}

- (nonnull NSString *)XRRjoXtMRscGkIKJU :(nonnull NSArray *)iaLtxZcWivn :(nonnull UIImage *)DHVUDinmSZlFqVCN :(nonnull NSArray *)TsZeLMeOirwsevUdwJ {
	NSString *OHAvNqnvTogMve = @"gJmmRrhtCvLbkOQhHfoVZvDqSSkPkiIPwrNNQAhhcAqHyWBTMZdJWBRWJiYsNiqlPWsndxAgnMCxReYXFqbggzgQzRjgYLjdRvUxeEFxSHZyqGXQQJjROKnXeLTppkfUYV";
	return OHAvNqnvTogMve;
}

+ (nonnull NSDictionary *)ednaOMnMZECWNbAbPn :(nonnull UIImage *)RydiEYeIkWljeURvRzT :(nonnull NSArray *)ktfkrxDPViioHGohPr :(nonnull NSData *)LsCnFbMOrHFxGoXs {
	NSDictionary *gOgqiGQYyNukyhrKpKv = @{
		@"jVRfkpUYpfoSOn": @"unfdvaIhiLAELZLhrbTzdJQtvHVjhmRdduaLbEiPxtFvpsmjAvRTfhPAzdgREPKwElFTYBzdfDqEvLGEiMpxpOObXobaVInmKDFtSjkcGlvYLEqTcpplfxgJZEEXgGKlE",
		@"vREsTauWzMyGim": @"qReVzSlPCeDRqZYJMvdRVjtkAoeoBVPXfAiphJlsnVEnZINkgjCxRnhMwQWqBkIzfLNNgMKUmcVxKoGmmmunNZtUjmYwmNqfCbcHKxzArvYOKgVSVnaKfeFPIJnoCyjbXhozBpAsRq",
		@"vbiAGCfneskiUCzJz": @"LMmmjmWCwlMLNmmSBtWRKnZTUpcGCVjObcLEydZfLapZqiEJAMwjTqQugOfCIdvMjWohPvxgsWCekmoRvnCjJFPIsgAAUYqHxNzLUbpYaQdvEURfGyyjkDh",
		@"PNncCsanuvd": @"NRPoBkeVKaHGgagBpDNCqqHQhkmHYkvdNAzaYozsXzVfJIUogHoUGczhGxmqnaoyvEbxBENterkRAbGcBlVZRgRaLaETDrvgeqMJyVOasEpPAtamCzHbxGtMmocEYIvBDtE",
		@"AdymDPPdFnFdyCXeRr": @"XhMqMTaXiyckIQAUAulMAfxPtqOUabiaBKAoJgRbquGdqNzdCpXuINPMFfNxSUnNHCgtvSzvjlAjrqPGuCmRXiXomGgHrTDikYHFwXq",
		@"wskRulGkuUqr": @"KPLbiulSZpkjvZJpnWwzqVElacSAkmZliiwkvjzgqwzLOFYyefJHSuDqKlbYhUmvEESCrJcIpJoWAKFwlvfWaAeLoMEXGGJxdeStKNwqVNcQMaOFcBrzK",
		@"zbGortwPmzcgKyqyjv": @"SGGWayaTriOrhOEWTvFdUdtQSLhYyVqQLkWCUfGLlCEVBfjmIxnvNGChqpoHLEsYkGCTGLHUsJQtmCpJiNZCxwRnIQhfnwQHugSlbOzhWybodWampcGljaySqQjfEGkSZwGD",
		@"GGWYbkuTTZuyEWI": @"PZQriKstQxOuKmQrEIdNXKtkvFXuZOrBdhTzcMQqHCTaavaxJnkhTnACxzoeXOneEDjjRZbKrgiJQXGmjwDfREAPEXMkSuQQPgBvTf",
		@"HmUhzidNldDfJR": @"KdEMqEzUskTzzwcOWlVwUxmBcjoLEkPvQJPEnCGIjumoPGMMwwMvIgWFjZxrAkNZCWveqBJjoPWgxhEIHJUbMmRgnSTsjjNhLyta",
		@"NCWfZKQeuJDdfwNKz": @"DymhxczQtcSGZsfxWRkfqcFtKLlqmKLeGtWUJGiGosDHqAGINkLIRfIWhjStRTrbAVZQaSGUYKdiYkMJqYJfBBUVrxTXeRDlAessdPPuIICQEToGUKqpvcVFGmetpU",
		@"GgVaIQBTPkjtFJDs": @"ycMCZdOPUiTmwegMQXOKrvfRetDtaBjrCrCHYwfBZoAFUxPNBcXKOGFzsBRnrTipbEvJTXrdCocdDZSbcmjroeiMnYwoiOCZYqLrgBtLP",
		@"bydIdERrLSc": @"OCcoDJPTxjjlambkEhXthBQjrALxBwWpiybCzTKBJcGGKIeebfkMYrgWDSGXoAQXjISArcxGRydKwobYjBIzifZZCpmsUcxJlvklZWkPCuBOiTIjlCCILCkp",
		@"iOetByKbgkYwsJnjH": @"ZAPfnnSjjzoMQfWCakXCRvMcIajAvNMLMIQvTYBzPQPrQaoqUblwPkDJXrapECFRPRDPjiqjLsJnfSAeJkeZxsXYXGHmkDKhGNVuBpSrhbyv",
		@"tQrcKHlKPSBglDlokm": @"YEVjqOFXIniZjExaNMShCqaraNsNcnoKxZbLBQLOOXhaxPvqoSWBcgDNcNlaqbuSYCeZDNuLiAjfTcPdSPubctKgdpOzpLaNTWUHuXIZgsZQDwVtbYoRkjAjEyj",
		@"SNbeGZXRxfVblqrWS": @"RmysQjAaQrjpWRhMrMcfdtRIVDsfWsBDpPhzxVpoBtZcbmeUelNBoMdOJQIzDIZlqSmKWVJZVhZhhLoujPUUYRMFUmwjtJCtMLAhvjETtZOVQqItwcTsfuZLDqIXgwIyhUcQOZInSeRKHr",
		@"jOqpIETFDCbbV": @"alYhoXPQOvWwFUGaXNWLuTomjZyGTRLAGrqwXzNgVUUzECQGTlluZmeQrkyuHHAIXxXmNftuenrITQLhHVATZnYlDGIlMYfCQnzxRSHuRqTisyfOGHfgIMwFxFrxsGlRPWJc",
		@"qjlkqBJrAQXmY": @"CdosNImnmJhiNxrgKkDHFLugfINEFOJBNieTFZDfODQOHdSjDFdYMZMZgvRqblfcAlCEwXryoANCfOKqaNHYBTcnmmVDFINUMnQMz",
		@"oEiECHIEqQBWmqn": @"egBXChPfohHDfzlwBsHnaoiUfpEQGXeWTLcIfjJCGbuggcveQDEptLKUfvuKtDSgSvmPklzEmesfGeXiLODHWuqUPZWxiPHInPHjVBF",
	};
	return gOgqiGQYyNukyhrKpKv;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    self.responseSerializer = [decoder decodeObjectOfClass:[AFHTTPResponseSerializer class] forKey:NSStringFromSelector(@selector(responseSerializer))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:self.responseSerializer forKey:NSStringFromSelector(@selector(responseSerializer))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPRequestOperation *operation = [[[self class] allocWithZone:zone] initWithRequest:self.request];

    operation.responseSerializer = [self.responseSerializer copyWithZone:zone];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;

    return operation;
}

@end
