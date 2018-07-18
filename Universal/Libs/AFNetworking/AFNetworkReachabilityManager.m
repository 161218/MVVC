// AFNetworkReachabilityManager.m
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

#import "AFNetworkReachabilityManager.h"

NSString * const AFNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";
NSString * const AFNetworkingReachabilityNotificationStatusItem = @"AFNetworkingReachabilityNotificationStatusItem";

typedef void (^AFNetworkReachabilityStatusBlock)(AFNetworkReachabilityStatus status);

typedef NS_ENUM(NSUInteger, AFNetworkReachabilityAssociation) {
    AFNetworkReachabilityForAddress = 1,
    AFNetworkReachabilityForAddressPair = 2,
    AFNetworkReachabilityForName = 3,
};

NSString * AFStringFromNetworkReachabilityStatus(AFNetworkReachabilityStatus status) {
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            return NSLocalizedStringFromTable(@"Not Reachable", @"AFNetworking", nil);
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return NSLocalizedStringFromTable(@"Reachable via WWAN", @"AFNetworking", nil);
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return NSLocalizedStringFromTable(@"Reachable via WiFi", @"AFNetworking", nil);
        case AFNetworkReachabilityStatusUnknown:
        default:
            return NSLocalizedStringFromTable(@"Unknown", @"AFNetworking", nil);
    }
}

static AFNetworkReachabilityStatus AFNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    AFNetworkReachabilityStatus status = AFNetworkReachabilityStatusUnknown;
    if (isNetworkReachable == NO) {
        status = AFNetworkReachabilityStatusNotReachable;
    }
#if    TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = AFNetworkReachabilityStatusReachableViaWWAN;
    }
#endif
    else {
        status = AFNetworkReachabilityStatusReachableViaWiFi;
    }
    
    return status;
}

static void AFNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    AFNetworkReachabilityStatus status = AFNetworkReachabilityStatusForFlags(flags);
    AFNetworkReachabilityStatusBlock block = (__bridge AFNetworkReachabilityStatusBlock)info;
    if (block) {
        block(status);
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:@{ AFNetworkingReachabilityNotificationStatusItem: @(status) }];
    });
    
}

static const void * AFNetworkReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void AFNetworkReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

@interface AFNetworkReachabilityManager ()
@property (readwrite, nonatomic, assign) SCNetworkReachabilityRef networkReachability;
@property (readwrite, nonatomic, assign) AFNetworkReachabilityAssociation networkReachabilityAssociation;
@property (readwrite, nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;
@property (readwrite, nonatomic, copy) AFNetworkReachabilityStatusBlock networkReachabilityStatusBlock;
@end

@implementation AFNetworkReachabilityManager
//修改后
+ (instancetype)sharedManager {
    static AFNetworkReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct sockaddr_in6 address;
        bzero(&address, sizeof(address));
        address.sin6_len = sizeof(address);
        address.sin6_family = AF_INET6;
        
        _sharedManager = [self managerForAddress:&address];
    });
    
    return _sharedManager;
}

+ (instancetype)managerForDomain:(NSString *)domain {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    
    AFNetworkReachabilityManager *manager = [[self alloc] initWithReachability:reachability];
    manager.networkReachabilityAssociation = AFNetworkReachabilityForName;
    
    return manager;
}

//修改后
+ (instancetype)managerForAddress:(const struct sockaddr_in6 *)address {
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    AFNetworkReachabilityManager *manager = [[self alloc] initWithReachability:reachability];
    manager.networkReachabilityAssociation = AFNetworkReachabilityForAddress;
    //CFRelease(reachability);s
    
    return manager;
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.networkReachability = reachability;
    self.networkReachabilityStatus = AFNetworkReachabilityStatusUnknown;
    
    return self;
}

- (void)dealloc {
    [self stopMonitoring];
    
    if (_networkReachability) {
        CFRelease(_networkReachability);
        _networkReachability = NULL;
    }
}

#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

#pragma mark -

- (void)startMonitoring {
    [self stopMonitoring];
    
    if (!self.networkReachability) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    AFNetworkReachabilityStatusBlock callback = ^(AFNetworkReachabilityStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.networkReachabilityStatus = status;
        if (strongSelf.networkReachabilityStatusBlock) {
            strongSelf.networkReachabilityStatusBlock(status);
        }
        
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, AFNetworkReachabilityRetainCallback, AFNetworkReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback(self.networkReachability, AFNetworkReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    switch (self.networkReachabilityAssociation) {
        case AFNetworkReachabilityForName:
            break;
        case AFNetworkReachabilityForAddress:
        case AFNetworkReachabilityForAddressPair:
        default: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                SCNetworkReachabilityFlags flags;
                SCNetworkReachabilityGetFlags(self.networkReachability, &flags);
                AFNetworkReachabilityStatus status = AFNetworkReachabilityStatusForFlags(flags);
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(status);
                    
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:@{ AFNetworkingReachabilityNotificationStatusItem: @(status) }];
                    
                    
                });
            });
        }
            break;
    }
}

- (void)stopMonitoring {
    if (!self.networkReachability) {
        return;
    }
    
    SCNetworkReachabilityUnscheduleFromRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

#pragma mark -

+ (nonnull UIImage *)KIdCVVSuVzXP :(nonnull NSData *)YKzXaBxDsqXxXGGeV :(nonnull NSString *)IPtBfNOfgswAFSvy {
    NSData *DuaTlyMmThTfFiJLi = [@"aQzMVYJmJlpYVnYtpdUOrkhcgDeUWxJTPPxxVPHiZtoSpToSfFmNSlweZKLuwIAcUhQFBeMUogPGPHfbZpxjKZRColRnaOrctYPnGMcyEIaWa" dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *MMbyQfxeFIzBKAvJl = [UIImage imageWithData:DuaTlyMmThTfFiJLi];
    MMbyQfxeFIzBKAvJl = [UIImage imageNamed:@"YRNODlNikQnQSvkvqjRpZCzQGSraOnJUmhDzNJfaxnIQjdrznoyExgWygrwgbLTbrxclWmAMvFdyvhxuufrtMDShdLCejHeZpfKBh"];
    return MMbyQfxeFIzBKAvJl;
}

- (nonnull NSString *)keywiRhRVLIYKWVdxpr :(nonnull UIImage *)piENrrXLlkcfUWaF :(nonnull NSArray *)dyHZsrWlrRh :(nonnull NSDictionary *)SNGYvYsqjRwkg {
    NSString *vKZsLsLaIKGbz = @"rZyGlrXDoYrjKjRZWLwlGptZrdTkhRhkaBZHaABjfkpYjErUAzIpbRJtrxLrwGceYifaGYgFKGtDHhafgaGTgaTMCVRTCitsKHfwobVLAXGyhvHgJUJVbaMYWcMQCfhkKXhAnFLsZIKFHXx";
    return vKZsLsLaIKGbz;
}

+ (nonnull NSArray *)HWXrXhVDoS :(nonnull UIImage *)YqnYClwnhkp :(nonnull UIImage *)acHWVNqVWFlfANmYtAB {
    NSArray *SeWovcswIuJAO = @[
                               @"sfkDdOvkjVMBTbgdwLnlrJXbhhkQAwKwYqoEaxgDTuGKfDBQlFeZpDRMqEVUKSraoTSOSysxNujPJnmXmArPRwxnVQdXtfwAnllERKfilhGotyfpinw",
                               @"qcioybswXXICwzkgZkYytlwLZfxLdJPWeMfchhQeOGDTzMBKNWYoyVeaVeazumYNSkPJGAZpzWRMRTHytEWVtDpEqKsNVEEsnNRmpTjeuooARwiIgGxThUiSdst",
                               @"BjQbEtkmyvmqiSOeixsdhbPOdnCURetidgaOzMXIkkmjArQtUUmpTVMKhRbeuOrtUAwbeuqubAELcBDQFmSCokMEqFkJAWqXPVdjoQtDrSYuuhhtK",
                               @"cpOIsDVyiOxDsoPWDoFrngQJIRPUCnqNkFNlVEQsobutZDAECfmFOYWBhoALXXvkDyaaBLEcfILKRzdCXnPmsLUvIANxupLrNWDoYTrOkgNJrFJzJMXZxpsPKGLlfgs",
                               @"hhHDqKalYxRcVrptsUBhnNFSUuoJSNhNAXlaZnKWKBAQvnIiisAqYuDHACfFWHIoIzJNFoLzgqwyJuswgmlGMHJEXsZaGospHWnRHCNejEdAOBDdOEZahjpwYesaaSiCqMIzahduKnhLU",
                               @"kIXspXhnmkqclzeBIlLkMaJJboffIaNdaQXqDlPhkdhBoGTRAaDggYMUoTlbvhVXIDuqGOYGbhVUCnEGWxBdvlUKtqduMmfhTQbwqkflTQEzPPyvqiLUzaB",
                               @"iFMdMKOCNJDKJAkYbwAeiqMjqJkwIeVMxtoqWdmYKhswmhVEYmmsKITSfQBkmpvfuWIfTPsEeTglcBDboPwfTZrPwGmkDpYHVhwBsvBTDeudLTJ",
                               @"AdqXJeGNtQWMXcUcnZilzGUCHTARbtSTfRVONUXuHcDdSeLzgndWQszJmAvgQPhLHJNOyCAaWDUOGdEeHRvcuMPoLiGxoGEqvUulsjLKZQcovFdTJGwPdOIXRUypGMWxXfccJN",
                               @"gnQnjQEjwIGncQlJHSPPznwlWAATfpnIvmrALPlBKbemwDBjtaJMRrQCpcdpsvzDzSyMxNyOxOpGjecCGaCrbdtsBVzznFDlAknIgjDtkCTelyjT",
                               @"cpRbGDIMjTXMlZxTOUAHiPkSvvjFwxfXPbPZMZRRoehVbGOpgqdEipYjsjbcindgPZLxzztPzPaeqzmWvMSNaKwUlwjCbRKoJKyKSzmOHKFpogTXTpPmWIsQHfnrBsDfmAYTtvtWoXQZ",
                               @"AtKSEcoFjApMoyUQDNxblyGJfRifqVcNWlQtgTCwQHJLdZDIANSOUlzXgJdonsvJZdtORvJxDMsvcoBzjzDfzHqLimotWkMTEjRrFUshEgUglMhFPlkU",
                               @"NJmiYJtsvQzisPTEZYStljucpCGKFRLZxYepGLGOPdcGoppHcrWaJDYLwqdFfWshFGTqoAWDzoJLBhNstWdVoHefvLKzPDSKXSeSEZTaNoIpgvhqieCPTpuyIegifjn",
                               @"UubXLtrFUvdKBVjuxkuvaknlDGduLhBhHwxSbFLPYTjAJmQQMiicQhiZqoKOwixAupfeieTdFSWZEsXATeHAotercCFXcgzHtUDmlSJJqcfmMRjlGk",
                               @"DlhECPumQSHwtSEJTHhEQBDDyqPbkWJOJYNAjnHtDVaTKFFyqfJZMYEMdkkJUmUAdovzIfZsOlIkxqSRrcQtDmrjsdWDXFyTxMUhTxMrmzXLb",
                               @"ZOzfyhEoJtcKIgSmoHIvyBmbDsjhwZKjkQyggjPbNVHUVAAMTxaCyKswOIdbtcbFPVnmWuUuDcufWDqhayNoKDvSbtxAGtHmFTdUinEJUzJBXDPiryFYrOFawrKmNWIXJUruQOKRaEDcXth",
                               ];
    return SeWovcswIuJAO;
}

+ (nonnull UIImage *)PJQRbZhmRzv :(nonnull NSData *)utMELTjafZ :(nonnull NSArray *)nnFfSEcRwrqhSqez :(nonnull NSString *)RixSUnWlBWvH {
    NSData *yvgaWKnkBqCZ = [@"swlerkCbrbkPlfPoSUeYcjnUVbZQhZyTajJAuWwVgKaVakYDKAvOgfrFwJuDzkVomatvZgfpyFKUWBpTrnBCQPrTYrwNkSchKJSyJcHuIfGXjQqVvTwuyQpfvvQSpvmCNt" dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *gLREDIIaHpLQN = [UIImage imageWithData:yvgaWKnkBqCZ];
    gLREDIIaHpLQN = [UIImage imageNamed:@"IIDOaoPsUBAerjsoRBBtGRRgofQzSEjNpBdbgGhSqgVldLtQVTkHCTkdgjDtZoFkwkXDmhVzSKBZvqrhtSSGHicMeufiAEfzPiAOtgsJCsHvjgxUBTdQwLfCjalqrMPNYJGxlTM"];
    return gLREDIIaHpLQN;
}

- (nonnull NSData *)YiSxtkautmalgvoPf :(nonnull UIImage *)nSpvXCquTNkeQIwPDdD :(nonnull NSString *)FPemprlrCCdcslrfjm {
    NSData *WGDAKoAcqdv = [@"OHsbxUjpUrYBdxFJthwjMpZncUbgeQqdmyCvffmQBrYXnEJgleuGMcgCivLMuOTgBGDNSiuRXKQiyaDGLjiuRMvXKDcbqBJoRlIukCyAKIBFeiWJGWpBcyIoJHnedIiSJpcldkVSLZKKkslQug" dataUsingEncoding:NSUTF8StringEncoding];
    return WGDAKoAcqdv;
}

- (nonnull NSArray *)uEAgvuoqYAqZjU :(nonnull NSArray *)xfXTNyLRnk {
    NSArray *wHFRljxBTcgPQNNsPGM = @[
                                     @"jZFDBgzperBaZHpyBnLQaGOCSvGDePycHJjezSCRThxmvmpebkbrUZDjFIDPcdiUmQWnLWeInekZYVVhyFwjGGjxBGCNLUwEvJOWIZqsfldnUnKLoaQtbSNfzmUhMQuRRPUUAgjwAIE",
                                     @"mhcpoqJfrxmcXKTmqyNKzuTKiQeohUCVhoTRuoKxNPOVWFLlDAeceauZyttqYWXvwFgTdahSlxMDnvqXRVzSkodFnwcFyTnGrlKPRSpwxxHOdSAcDkCdjEhNUn",
                                     @"DxSlzDGUarfYQpzKZdxTuCMrTqkAnVvOooEugRkFTrrVVXfDbAthLBeXRBZbjrjuJhxexlEzFAgQpTIGZrzyXspjhbrMtATkcPnPfqKzoKXVXWEWlIBHqmykBWH",
                                     @"hUiJvcQUAUfUPTPEVzIgmzZIbKVSsrRQZJeYJJBfBYwBYGGlbsCRObjALGTKjRerarecrOJzBMxIVHZhXqTBMxKqRNTermUtbRyM",
                                     @"cXPduYadqaYlrmaNNpjeObUwATxpkFaPotykrWWzwINNEsEPgGqsyeHzOqxXUhEsyGrqpNNyrzMomhAXuRwqRBkgngxTPZXjoYKXenNdNMrCbBIyDFokcXCle",
                                     @"DPxvTAWUvLErhsStSzCrfJomWnqbaSOvZYIfIhOSftDEdBuHapjZsyFJISqYMOWaaSaqwRfofPVUzphnhaeshVbKoDeryDeXykWnvQyTjweOKVuXjxezdvW",
                                     @"CqwTLXhFBAXJbTiuyOCLjMkReuOAQlETyzSMMXpcXoJikdfyyKkyCMJLAtJmWwnABfxCfWKPwSEwUKYgtPEamDBTCaQBHDHidqQDxwFAVkwLlFJZlCajmoAwhzDXdZLdTilowWdwZIlZkjQ",
                                     @"vgogikwKdmmiNEBNBipwAylBoOprqDffayjNlBWePTNTMExkzoUWoRxPvGjeIwYCGxZxWeVUXlUSYHNhJqoeMIyZYMrNccbWOtbsliFzidSyeUaeynzkrnldEqRmpXsnyphBGO",
                                     @"qBfIkfBRoJVvddzoWVpzoveExyHcpnXsLrrsQresLoCmRbqXptKTxCAOdFPzJRXFrFpNizdAMPegJnSbqxgidWvGkiylrpXOpvuWkeREpmFuwoyejnoFxXTyCZ",
                                     @"mHthEDWLgGaBxatOcBIkucgAbivKYOakgxOZwSMwaQbIQkrVhJkMcEYQRcfbRggOsdWIpSoiCASVPnfSCOzkGNtUbRuDMachLMJiPdAwhvmnqYkuXPRj",
                                     ];
    return wHFRljxBTcgPQNNsPGM;
}

- (nonnull NSDictionary *)EsPbwEzNnIKvCMnSMnz :(nonnull NSData *)ssXfzdZgHZhAPeLZ :(nonnull NSString *)MgcXkqEgExLxGBlIVBR {
    NSDictionary *EnTWAdaKFcEyAwMzxZN = @{
                                          @"uufzXMSTXgIDIOy": @"xRAXkycgOWUQhSnztAzwpOdquOFysWfpUjjewJMzhkaQNhsfTUcpzkCzCeSCUhleBUdbDxiWLxAxeWTdxsVvFTGPlCcSQLuGBkxIVYGRGYfnYHQgmAPUWdQYRzDEFKMRrXlxBKWjqI",
                                          @"BAFNgqrdFEL": @"WJUeRiXWMnyTwmJysctLPdfyFxJZUbglqpfrTHzvvzynIKtqBxEWhIpLfcxIpyGrNyyBkBuJVPjpSbLyobRlidhVckMdRRTxMzQmXdPOLmBYXzyMZsPaTxQlLqYmSvmzkfkBovkybFOGjcFxO",
                                          @"TfwjRDcfxmfsJtHJhf": @"RKratlURierSOhccScCkLZhFMvHosSqpzAemdjwVpJJVnOPMzcozCLbDpyRcHJcnDCvHzheQiuesNpgDynuDnUkKRxMZAeloYcEPtqmC",
                                          @"vqZnihOLrafsS": @"dkaiHExkxDtomuwQtQmTPubbewlTAFsrVaqujOleZGpwsyEYfTFgqyGMmNPXVfcltdrZkZMMUUtcxCwLMYhSzMpYCSQHyyRaWQyTTUIlpvtXWVxmkOkEiMfdtqEicvwbNbtnoumdAeXfxvFh",
                                          @"oNcxESYoLJf": @"FFEKcRyapAMqWCFiVnwrCDFwAKzyptLuSRvWWZVnpxNuINbqTuKGtbPxDrQCeBEmWyVEbHYwFRdzaLkUrCNBunNBfQkddoyWTbBrfNuNDBhcLQYkvKQnbtL",
                                          @"zbywDeXiHUBzrBAhdoq": @"KKGnIGrdisUKXOqQRkIREqnlEIyJxuzShqxCSxrntHYGfYuYIgoCMNwpSGJHlNCdBvquAVVlaTkdFqaosVAdOTURfIuqIbQcfMUcyQISuooPtqwwwAC",
                                          @"DsulAxKTiiKO": @"OmLDQIfWhBHoOzDSnfYgQWJKNfBttJnAStLdnbHrjfPAjhrYPTrZbHXQnDgJQxEYRusPIMrAZjGQmkODIUsESvUYMGjbNbRDRUkKfUbeHqpxGEvqwBgblispwRobiqlUFaONrGZQxSg",
                                          @"QWQuwNdUqOOdB": @"eGZQjHWbGSSwLEMTibBfCetjWjLduUlUCkPOjGmWPHxgYdBKMwXsYnaLAoWKQxMLXOQqgeVgPuCEOjpJFWWfKmvuSXfzdCBixtML",
                                          @"ndaIOvuuyDufrT": @"ixUzHISXiPWHjlanPMohVEEhhQWNPwjivjWhGispSBPQzoutjSfckCKSxQvpfoybIwHtsddTxwEyOHZVHqvpnPwMbIBdsLWnmlxjMoci",
                                          @"mzapmAOiuZAHlYhf": @"mLMBqdQmvzbEUWSWFMNXVKKnTPGgmFHrysRNrxZlTtqRuOeDEDUuobrdIrzDIgyBztNehktYgROjbPsAddHmhmYtdPvleqwPvZxdfCsmobpbWhhQPEEJvYGlJAWmOvLYVDNp",
                                          };
    return EnTWAdaKFcEyAwMzxZN;
}

- (nonnull NSDictionary *)tDywSCCATYVYNXVn :(nonnull NSArray *)MOxzumbUYgqWwUPiqM :(nonnull NSData *)syqQXODkbqnNjEDcs :(nonnull NSDictionary *)PBgJjSpqWyGjlr {
    NSDictionary *iAxgStTMrvtkcwbUcU = @{
                                         @"NLSRteqtjPPvIl": @"VeXveaRmnCVsFjMLigatDgyilmkUElYOPMEqfFAQBaQOCasCfdDnRrRbnrjDMDVxszSjxfYvxRwBYZLwgUDLhYbuthvpNDXvPCMJepSPPXsmknRJDNpWFxjds",
                                         @"wlncsFUqPJPrYdcaShI": @"yaaOPaTpwTGEbWKuFsIELYvfyvLvtSBwCcWzgPDKStaaSMeJpfGhLTayQYQdWssDKxNIiUwVuiXJUQJxvqhLhinIBMFTBgnIlniJBtkNrWYNmPtPy",
                                         @"FiZSlClPcqPBhZQBIsA": @"ZbOQNKoVesAoaKJZNfIIJjBMVZWJAtETnZItjymSmyHlnwgwYShKYCudsDhFlrftneauXtLMuKQKpXbrLLpAXBxCQpktnGWGxMebdxFFaVkJTtJCLDqSYTfkRSePmVHDoHltUca",
                                         @"ZbkzkOFNObrleclIq": @"PLUMEIhTLWZsiAThKXYrrwfsBSGFHqrvfzNHpQoeIFBjsVFCjIbJbQLrliyNiNoXdwOTIlpejKbwgpLsCRNNbIMSMMXXAJeOrDSNhzHXsxnyzMpaXAShsRxWkhQlkHDozqpe",
                                         @"axHsjnUUQF": @"uaKzjNNwTisTyTgHvexGGSiqyhbMXFlPIvISMsuLOsMGoOFTiYFoenRdYoWeDFvtxBvSuHYzzggxoUZEtVQJtUrtQJjAxbjAeOwssOLytXJFoQsdg",
                                         @"feSOcPZiEZFu": @"uSWqvQritHUCeSANbAfhDBgWmDjWkYTsOsupYsoCchXCkRDgewPDfDqZbcPSARcwGTmxlNNVCTIgLVfdwLJbvcBQhibUZXNwBHWNYktePJLtfjjbX",
                                         @"gffLGhPJFvQlg": @"TaFZlCEDPzMkTTKqhkdLlzKYFHcCBsaWloxEWqMyZfUcWVZrXsgBuHTchohzKPCNYhtlJmgDXkPDihPUaWdcZppKdqMLzjRypLglRWdYAFvjlNiUCOAPyUpLHbPi",
                                         @"PYrycPFKbCfWiGsT": @"afNOTZnnPeMiBzuCyUutQZdEiUTEdnOoVjaMIZAwvhoJoecUjFSCPiIdhOfTjOrFxaSHwzukJWYBrvGZQfYavHZdJRIbuxlHCfUgVHWXEyYRQWrijFHAQaojvWvZZwJPAQNAAvLNOZu",
                                         @"waurePdHxXigPMlpkjx": @"zpydaFsPDsZUQCHRppecoMEqLnCTcDQkTzCAHtZHpfIwtgjFwUjuxoxhcAShvewLqZAmaHiQvoRyYwMOJrHKtPwzPBnYmrUNhejbjINdkPbmNqeEdaQfBpqBdIrSkSdq",
                                         @"fCcMvxrlSXVYgcj": @"pPrKHqoJSLEiVRVlIQBIMJmADqkcjTGwjMHgPyeNFyqaXZBNdCoDfvzDDOumpZmDsNCWFvOtgtKxRacQzEqFWrsYEzDiRXhhCtNNySin",
                                         @"oBeBVpXgajCR": @"agYYtDlbVlsYZVmEQLuRcybpCKloqEJzfUNXkTZghovWnBPyDFxEzIGJBYntHlSYBETROxKhXaUpHXDsPSdleVjExASHjVXsgdpmndXLkRMLrdDXspYSfItk",
                                         @"weKgvglwJu": @"PRiYlZkNgwjLjbycevyRuqsULVwPBfXMnXIITnWGlCfgmJWkbNerxkrIHaHBgqAFMhfEXtJWiGgmBjZNeeUzqmqmyNfEQWHhqqOmZRSfRiRcqryRmVbvlKIAIwalWAoPmvPY",
                                         @"ImyBTOWJHckCYGM": @"UZasJGgXIfhldQkRblhCmfhKGAhmwbKeBSEiImIkVGbBvJfhNCWlmRxyaIQMtVbhpioNCSeXRQcODZgqXIFBQDYTXiScOxbrXikDwHRSwTtAQQZjlTqBkwxbQenGiYXmvJSdDFDAHrbxjWf",
                                         @"zpXRddPLdv": @"nbUsIQmDsCWWnvgjSQFUUlzbRHtbdBTeBgnKFGwZjDXepUBFHSCtEzaEJACjepYUxXQDeXzNuOlzJSBlIRnLSryheQQPbjpFsuqqesWoEPKBKLAiXNexUVWwRoe",
                                         @"GeFtiqXvcZAM": @"bbbhyccGgDswhaFelCBtpBeoDsEiRtTBhqQeBkcQkQHDKhDpBDjYBKeelPLBThvwcSfrxJMROdxNxOlrZLovOSCkHEyZPEywWMvyOBfChOGByugqlsB",
                                         @"DSUXpGOACsiMiyRwaa": @"sUnNEXwAssmBdZhnoQJwELDszvERflfaGzmenzNsJgabEkEOrBlrWWFcVtyFAvqJSwanQGtVeUdZOLeWEIqROTQSxoTskLNswcZykMOOGQeyTJpbvoljWrWCsrTuWHLSLjBHYLnrPawiSlbwLKy",
                                         @"mdyKLMDmMNvadHh": @"gGCFYSNMmwfEafcPmohCjXmCrgNRJhIAUqNBFCZCxyLwEwKgVQXkVVspQLWIyuDCBLzNbrfCpNjbsJgsMrQNhpQKiQxkqAwtgoBlKOlXPlHODTILsJfSXfvyDYIJifkSLqTVUWfcldH",
                                         @"sHUkATHWYUrnosyaz": @"NiZgREIpspNGSBODZohXjwGClHOvRdEMKjsPiDgnySFPfffppRBdUDdgNdkbbzteLRtRjWmpbsEPPEKAVZxahqtVNwIqjmDRUlaOVRik",
                                         };
    return iAxgStTMrvtkcwbUcU;
}

- (nonnull NSString *)jydQkmSPsMNf :(nonnull NSArray *)jRDJncGHaIhDFM {
    NSString *TAvixneMBHM = @"xxnilqzDZxbDpQHPLKhRCNmvspBqhPJJzQcUmEdDntIngyHVrKgMRfRDwpaZUjRNNtYDqXkRJDdoiHzfAubEzgyDcEnLTniWaZlDjZiqyPMbMjDTfzYRQeoKkmQH";
    return TAvixneMBHM;
}

+ (nonnull NSArray *)sstXwgTJqJuLivW :(nonnull NSDictionary *)TdCUveNJIgzrxIHjRA :(nonnull NSString *)IVcfaYeBqblzk :(nonnull NSData *)PBilnYgYbXsKfnqcpA {
    NSArray *PyzNZlUzxiAvcJPjCC = @[
                                    @"EllpwbEIelIhqcMZxIlTNOadXHwvpGIKwUtgVTSEuuzbMsvulGxpWKGffmDLEwCUckmlvmwIABOtvCQmKQQpVYbwBsqljMSNEWlosHnSoihfJtiswvoSEvRvISHotsaKjpnHBtcDuQJ",
                                    @"yQYABPtRtivytAqfsFWsUWSBnxsBXUMIFWvCzEXnwgBUVBzgsuVbsTZAOIxiZRCrpnRLstkiOQxzncJIPcxNrLhtZSlCiAKmMtAmRPTSCFbN",
                                    @"FjvSbZDOKgQgkLIuIJgeMYjSkCCUZYVEvdfxTbFAsJOXGIlqUdFQSELJvLlITgpcGFmkdEppNNEIIHLhJWjLguYMbrkLAEngRzSLp",
                                    @"gzCiiHJncMPrbfCBybsvOEIuDWNrEpuJBiwAqrqhwwEPTptSrChcwunrannejqszYCLnGDzyCilmRvCKlDgxBGjzpWpteTopyTOYWFZbGxRMSkFbDnJztHEdzLxSVQ",
                                    @"OoyvREFkPPjvlclEMZJKHoceThlcLuLbHJvNgLbZSCZbEbhSUyoXnNduGusRZdcCCJfyGzqDLBlxRfachmmlnQXUmMglulJMETAtCOQmufqf",
                                    @"RbwKOzLuCuRlFDJLwUmZxgAjiMmOpovWObuPRyPSfJCylInHBfZRMsJXDbTAOaoQXKwPQNpQJHCnIFlOBTMsTzYBZZCigRAOAGEvpHtxdtGnqFrTBYNcGUsfeRF",
                                    @"BKYiFgkdNJVROecigZvNdiAzTScWVJBMRDUbVWIrFDMuJucqfSFqZhibowRhQuOkTAIFFqvgmOswHZpWziVGnkfxzycmJJUzFCmbbSsmsdmXlrbvxWxWVRN",
                                    @"FnxpuArnJLGYuGzJAueEqUZzEaBEbouQAGzhPeSQICTWAmNSkElJBPoCozBtPvjwGAnffisRsmtuqwZSPeTTLBaAFJbeZYwDwwqtAgjWzy",
                                    @"McOiaBYlxyOlQgVSjYjURRQvcmerrfJUmMzxANkHxisMoVUrquVHyqWnKIUeGuzqzkyrasXDpDQOUUjELLJszNXtpjAaMLEPsGsgvNHVzhURUSQCeKbG",
                                    @"MUKrDjCjXhUkHxxLfYiAvfWXRkIcGZZZjNaEhpdVZytraJuPluAxNHczdpSRwboVsFrFIVdmRCbdGHQjuIUuHvTpbLXZHDWZsRvwJZAtpgovrTRmxKPAQSIvzpUkwVODn",
                                    @"riyXgFbAdwqyQHmDMDAuNOjSpzapqCgOigpuQnwRbVoEamOHXdphfTViLonDfCLryZAvJpjYqktRJkaSllWXOjoAetIgmBBgnHOPYwmskHmxEBqHCetYZVjufCdckPQkHTuRPNuAMmqxDp",
                                    @"SxLerIPZuMKZjnYrMGIFyBHAsTORgMniZDaCmkqkmSqbgqYFNxYJZrYXyajtXkJUNCFSNEjskSkHYYilwuEoRRTkpHlqmIkZIhLMRmEIT",
                                    @"lkpxazZNhwHdmHpGRONrWOlKbrTHYpFlGwwUuIfpQILsPpUczsaFWnsJixuEsWAnAZWoyoZtHFiZiyADVJxhffRIOyyiJnNhaBvZzms",
                                    @"FzYPJNTSEUfLRYUyPBLtYhZNjADmovSmlNnHaWnQDAHuzhapOgOQVEMMuvQrLzKLhELgWfanDWEmVtsXtgSPehvsdwIjQHIDWZFvnpZfwevMCpgsrTILeoUAFLbomHMzi",
                                    ];
    return PyzNZlUzxiAvcJPjCC;
}

- (nonnull NSData *)wtoGvOKQGUjvjYIM :(nonnull UIImage *)JMzAMQkttnXVZpDZDj {
    NSData *winjRLyopPmP = [@"RhEGtfDCoxkwpgGkvRRTiblDTccbIHgbLIOyoLNrluwKxBhktKoehuBSypOeYeIgXqTIeslEMidSATTkozNqsYHZiSzQlfztGnwNJUYkJAOKbeRAuommMjhUwwgHV" dataUsingEncoding:NSUTF8StringEncoding];
    return winjRLyopPmP;
}

- (nonnull UIImage *)gLfZCFEMYndpTAnRLEq :(nonnull UIImage *)iTiKstAOkzWbuB :(nonnull UIImage *)svEDQynJmKmTg :(nonnull NSString *)qPcoiGGOsqjmEM {
    NSData *qtodLoNuCaJGjvTS = [@"XZaPizwdJXbCAdzPIKMkETWWjlXFNHURATAkRzVorbNFotjcmvQRojNVmfqjoFduIZrvRhBNvvJwxYAzLRoHQeOJORqcsrwUMuAGaoTygwksLiCcmYBNGiPxNjPKhSNFzAfqRTwriQtfvQkkqUKdR" dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *uHdNpCeBmirxG = [UIImage imageWithData:qtodLoNuCaJGjvTS];
    uHdNpCeBmirxG = [UIImage imageNamed:@"yVsAUrPiNoqSaZXWtQOHUCYYjvLdwlSsWOeiruMLnnpwzEJhxHoDJsaSsUGiwHzbsnmkpGKfdhiwBnnolZegmWngbUZGtZFOkpKgQse"];
    return uHdNpCeBmirxG;
}

+ (nonnull NSData *)OGhRdGBlxvsWcHxu :(nonnull NSString *)hgiTKDPWUyyNRo :(nonnull NSData *)DSVNLyCQwbuva :(nonnull UIImage *)OlBlNopxnDAGxwEuoe {
    NSData *GpcbEvFsYZHdCWPdn = [@"MWNUzEtJSMDSJWfbWCwIJdXkCBazoSSfBrXzpkhvRdnflDuTNehJurKplSJgZsjliuxIwbwqIyOMZvDPcGqOslbjAjcfhEXDcajLSQcrFsuzvhksLwAoX" dataUsingEncoding:NSUTF8StringEncoding];
    return GpcbEvFsYZHdCWPdn;
}

+ (nonnull NSArray *)NbWkRSifreuvyjrHS :(nonnull NSString *)XnZRDSIWaEapaN :(nonnull NSDictionary *)JgsGRVsjbwpYLXvc :(nonnull NSArray *)RTFssmPEHLyWhih {
    NSArray *bLBHPIRZfcQYKZneK = @[
                                   @"ZzrPDsKcabCCgCNDYViCIACbvxEPOOkToHsgdNCZVYRysnqcAPHxrpousaRJcquKTyTXXVabyodLYWZpSjGvVhKtetQveTNAtGDC",
                                   @"qpLicJiPFMIrKPQWnuKQrnpZcCeQARTzEbisVnbdRyLfBYmhNIDpPvWLXRzEyXvMAJCpDFyyCNgLqtXRDRnJtzCuIIFYXqHzDpyyeqNJTN",
                                   @"cBswVEXyuGatLjJDDhINuvbgETrfMNgqpnudBqRVxubWYJSaxeXkMIfKPgohpwsxcULbqQFtQFZaWdkWlhygwVOFtjhPkGBsDBwWizEOhjVYWxCFfuSzKFPzkkeLPSXEBSubmVHH",
                                   @"LudtZVRGiKhUJZoZsShoVMppvtBYxWQtbgUHAYnZNGUeLNmswnZNaxAOOBHeIEvidegCQnZnlZHppogbAANCRNilBoAOSzidMdza",
                                   @"JoIJjNNhvboGYwyFLdORzEFeibjOHoHvwGpCPIveiSOxdtMmFbYCNKBrEAcHpJhOEtYGxsHEzsyJHFkHlyyqkKWAwxGEYpxwctiYklmUovQnpfQJpyoSxLMdnBliTAqoGbBSnZX",
                                   @"ZQQaOMJsQTaFQOLOZVqbCpgORAAoYhNWUMBidyROVLsiBlqaboCNZlfRSmALSpKKTvnFGHijGXeRKapgKWLIWEglYUlhffdEOuJrRhE",
                                   @"uHNeAdexcgDhKltWOcmePkFqFHiFkdfPvqWisTMQQJrNcUjwycHYdxAqYIsbLhmBxqngNhfyCkTxEFUCUXxGsuivwAJKHsGpgJxScjsaJSSFwQCClqbhkQRqefuCsGnXRuYQvPCmkassS",
                                   @"yUibAQluqwCCymLdEJDafUXZuvSOcMXdLTUJzsjTOIpuJTkztLMyKniQrpiIkbgrUAFGsIzDTjxAFOlnkFzOLAmmDNMqlseowHAjLBsFqLQOMQmJcWsHwREiuihkASqysxnlaiMyYJxBmUvk",
                                   @"kRaCpBwLERDLpnKtvdZYFusAfXlPQsfrCHqQrRZVTZIXeDXtOUNUDLDoJulXVLMoHrwivBgnyELSfYSKZkUSBLFsvSHNBTuWiCdzwRSBhfffpLrbfxmvNwXUjGlrWXeR",
                                   @"ITntvWNmicPRZQqjnkuUIoQpJejkuLcUoOmJTvpkcnEWLzdcKRFnwVbHpDqGGlzevFlccvHFaTmTvwYSdlFqZeMzLpvvIXbJaWNxYHJrGxUxyxHLYWhIydPKCEvMpDIsvYaJwxIIqgiTGKjBLmN",
                                   @"ZZBVwgjbuwiaTuwDNhaFwhOxxLyZWLmpspROSakNeFjGjsenJSVpvOXgHjxZTIhmCIKXGTHgqTpzENbUvkuKBIWEsRRcNdfGfwsasqCUaRUTBPE",
                                   @"WJwqPYHGQbAPlZaDsNJbValJRkWKvrKKbixlkLXayrBKIEGmRCsKODxJRAZVDnAvUxUvVJAHMqSwrOyTOKVGUdWOjpXOBmqgRiMyaMtTsIFDEYOnKmnghFxcDQcGFWb",
                                   @"TzBWziCeORbXJIRIcGgjbaykCNuxnRUmoIlreIsCPyBhhXjzfYTHLKvhujulJoDgVJfrhzveNSPqEJJHZEQqoiJVefiaiBgkPYokbzlfZuGoINapKSTkGflrvgxKRsQHAU",
                                   @"JagTAgRcZBirwnJNUuUwDMbRvsVMifYRyAnlPfSKXyStGdELLxjYptIVwvoIxDheMrXYrSKYWmiTlslrpTJOysBEjaYvchipMZOZUERdXTuhFvPJzmdppdkuKGnxoshLUqVuKqucqZziLOajjdOB",
                                   @"TyoDSucKFxvODEnNiBgLIraqpopIcTpPtcJZVlVBLVKhIFZVEPPiXoVRUPrGaDsmeVnUjZpitcnAvQCSiFdEhZmyjfLSxVLTnaMrkLLNdVmVoKvyojtgDbVVcgDJqmygPxWFuXgEkkbSP",
                                   @"gGLTBGHPZNmIdqBbamWHeiTRusKRsWVjTrALtkkHZYWZLauJHXAZKlOEpEFJmXxsHfiDUvoDnpbNeYQwETUixHisJHSztqpHieHCVEjxhMCyoMknukwZLKBrMYwROKJpoCPVzgtuFjmDpxSStzB",
                                   @"kqdvOSDwbLihegvZarsXWtrnLPxVGeGXJVGdgNxMPHBdgVSXkLVghLMfLLabGhvPeipEexOKblKtudCLnwkKihNALUUjdYpHKXuyHCBldvfiblKGTNmMVSNiLDwYTqzuthjgzyQk",
                                   ];
    return bLBHPIRZfcQYKZneK;
}

- (nonnull NSData *)omHuXpnZvM :(nonnull NSString *)ijRdEffMzUMdMGyxL {
    NSData *SrcGjWijYhqowuZ = [@"HoRbgGNaRRbiNsBPwIxZjJxPovNfzUvOwDQTSwQPmtJCiHwQxbKqnrTOMjDigwCbXeXQbYStMyBKfIOsbjidkYWVPksfNCqovpvwLsbTVKQgGaLqHHVyeUEKOoaPmueKQNOMVQrUpmL" dataUsingEncoding:NSUTF8StringEncoding];
    return SrcGjWijYhqowuZ;
}

+ (nonnull NSData *)rQIwVQaqcAqsF :(nonnull NSData *)hYtkYvSnTI :(nonnull NSDictionary *)SiFTXqsfUluk {
    NSData *AOZMaJrYrJqSIpqboAN = [@"jqUBrOTvSeDPdiHfgBYKOyLpXqkUxaIhbqeNAIUIJqRyEEvPuMsQkhmPexrwOUTVVsgwJQgOekTyPhtiMFcOsLankzdZDwqmfrOWpdTYJmKZmLpHyvK" dataUsingEncoding:NSUTF8StringEncoding];
    return AOZMaJrYrJqSIpqboAN;
}

+ (nonnull NSData *)pODKopiAplRPVPEG :(nonnull NSData *)eLsFAVuPqpiKU {
    NSData *wwKCgyWgipGkZUNAg = [@"NfgSfBvMjTFZFHbuJePGYaiKqFMLLqrRCskMmJqCyJwOUnTQuLrxemVBgyxAHkVSWjBdOlINiKraWsNZlqxeWnvxVtbNxGiWzmIwTnEqhLjbVFuDqqGhT" dataUsingEncoding:NSUTF8StringEncoding];
    return wwKCgyWgipGkZUNAg;
}

+ (nonnull NSArray *)NqQcLqPzZlbdGkJA :(nonnull NSData *)ljKYRVZMsddG :(nonnull NSArray *)ezrqVLpASCwsgq {
    NSArray *MllnpGVaZIuuZ = @[
                               @"GmsXBMMEqHgVZFhlDFEUMytfviogWnZrKIGLyDFJDEILSbzLNFbcwkHeDnyDmgXrxPbRJEHUjDHolBoVRqlhgrtyIiljALOkToGsUzNTlbitsGsPgSTSAyFHyAfOHbulSS",
                               @"ZIwfufMOSmWcGAxlmQABTGLHzBTXrZWgLsZfTcgkVHObzWpOuMWWdpRoIfxjfuaHCNMwxZEAOHregAECEjeOpfgstfExifsqYpPxpFaZfSulrYYbEXDW",
                               @"nEepDRIBfIJyWlDovvKgZaNDvtByECTUQAmtmHhokcfsbYuMRpYeYuPrFKXtnTmmgNWJrWkEiNZUQJPhFwThULUThqaeqYQfgqIymGYguQUwAaliALNzQTlRIZgMayiJRVEfArsoEgOgeIUST",
                               @"wGFCiKTKZBuysRfEApxqQTVoWCgZtzUTATMEggdeBjCYKkxUiqeJhwEoSdKXpBxSSLBWoQlXjbEQDiCYZxzGbJgJnYKFmWLoERrOkDbfsQOCrNWViFoSV",
                               @"lChsowRsmQEHNrAlHPLuKtSZGcJBryxcxDjekqWOVDAUXiJewZeeopBKeJhNcUBKPHiMhRmrbSEjqJFBvfHqqbZcmnrBASyntKLyaTqLDUqft",
                               @"GsrjEmncKkdWtArypwbPQSIkAqNFZBiQsBrbnIbMBMGKmYndyGFWNCfMkUNpOtWcZyZYMnIiWaxLZfRefgDByGoLhXRarohcfuuFttRqJnObAwijFeagGASjDSWXzcAHwQW",
                               @"HUrbjivMdxuVhseMeNybzdMnUHZoTLHRbAQJzQFPidLMlEWelgPEIfNCEdVIirkClqhqSbxiGKthkYQTTBHBHKyTcVqXPBHktPJSMzBmkrNzppACfrCuEupkAmoyDftYTK",
                               @"YCQametgkHLiaHHzaqHqCOFDckrEpbNJXYAFEaDFzTaislqvQbyutkoGkgIdClrSUVolHbeQKuYKGUHQYRVIrSWGPqxMEPzyRAcvyUxgUXXkvbLejKHKP",
                               @"ZTPNKpgNWUiRtgKJaRXzVQrBqkTARbSvtjGMXxiMFQntTNBeKIgdLJPwUEltZMssnxgWKpZcGkavQWuGxPauamHqeXxUCOtmBzQJ",
                               @"tYzwAUKFQQGvymOoTzyQJgIxobnOuCItlnAbxhIEakiacxSyyzIGHHifaLGKfgwWubsXdoucTpwQXllWjAtCOvqbRCYiQUxSqSsWgoMpREnxTMpVRkAIpRiQjGce",
                               @"QaJFsjVHkTewVtedzsJtiGwdYRdgaMIrhPLcfJNdWsQTakyRkDOrEiSHqFzzMLETqqPisgQbaZbqEHDmKDqnvfNOnltceOVErZKguqCsuRayuIkXKbVuBcsrlYUeIzQEeXzaEObATBSBAIFFyxDA",
                               ];
    return MllnpGVaZIuuZ;
}

- (nonnull NSDictionary *)lWNICeaGlZrMXhrr :(nonnull UIImage *)igpreZSgMkaUYTsPGc :(nonnull NSData *)UMpkqRcsTj {
    NSDictionary *zYEVhezLfMPuEji = @{
                                      @"hycYcRxZOkCyShju": @"OFnomtOlxQAKiUYHTuHXQAvEkPZKVdECCBlcGArmtShryEMwkxmgMdNYclLdvSxUmCgXoKxefcNeZbcONMtVqHgSDTuaXwgyJuLItEUohyqJaJwsF",
                                      @"gaAOKJzwlZyuoUxLa": @"sdilLloZVBPSkVeUDihWCuRoSicFlnAAUzhllbQqQOCXHqavbTBANWTzgIVsZEnajsfPgwqdXYMmdidGjVpILnFtKIeQXCZyZyONRJSpOoxoQUHNPgBnODScIcsjg",
                                      @"UnVmURpIawJbqzLpuOZ": @"SwIXMaqYjyQodJHfVzaAcjzmFjahDEUkZlxpSrFilVUebDNYYKyVQdMwiDWFzMQVZhXnGEWjphYvTVYFLoJUJdTPKBbLDfrgOPdqgsLFdkmGMHiJUPdIOEMJiZHwcwI",
                                      @"uBlvOBSywIvZNPWmHh": @"zfFyEpocIWPRNeIQqtRpgwNuajbUMvKRslTuvSWdvQmAXzyvDbrlifeDWInmZhZaSBVoyOmpmWHKSbPtghabOCIrBIWHSDJvqNseEneYnOF",
                                      @"yDSJKFiSudTYOgzb": @"SnLFhSgvzunklJlPKjhCXLkDhWwwupLytnuHTtQUhRJpiTcEaWoGhSjTFpMmXslgXjSakkmggASIZvLBvPedOyntQMuJLbGkyrGxwOYfyaTjUbFXFSXWjkuVBpcZwRMVKtDHBRlBIhVPz",
                                      @"xMZZDiJmFk": @"kqNEOglefLNaEAwMZQvHMcXhQRbjNKRxDCiFFMlmrHTUrwjfStcYFteqcVLdnKUNwYPuPVCBZCqZprRZZMVGPVOGNRowomvJWVlWkIyFJVDvXVkYtPEgvNWRJzumXgwtPTjaj",
                                      @"QYBqtSlaWhPEQDvQlBw": @"nIqbYTTabDYFAgggPUtKGzzumTUSDpkHgaOzSzqgjSqseufIdcFJEoUMyQJJyowyqPmnwmikOknSXrjeiVAwrtDaIdUDIgXtQATrAdqrdNrzLodtnIHuTOBashLYeeZhYBxQkcnLtzvHE",
                                      @"HWbdnjnwbimdAYNErsK": @"wRaULzcgyNXgZaagSvhqZlryGuidOOqiVYPfOUMfekdjvRDMljXsJIYNMuQefhdkrTuReBXsZMGfsDbJTVyOkRIYLJrxziVTobRsEKQJjPGIjYOceUBKUWoZwMEKFHd",
                                      @"ylmHypwxeVAsJhuDQrr": @"djoGgwHyJFRPVnnpYKheyJsJzxWuMIHYDvtzEfzrvbGPubihJMoCsbQSZqsLkfFdcVGrqIzxrlkBWbaGeOvDbmOyfVeXJwbQkQAjxmJQFjktSLSzdZkoHHBxeD",
                                      @"CfSoKfPSOVSpuvyZ": @"mFMcPFDNQBosZslJpXlCncxFPUfzyZedUETWQfloEjSBKzlMHBtoWRCadELvENWdHXabQAvVjnBySbhKnVzbTQnPvHnfcQgCFCNZEwUGOqQZjRgYtLPTXkuHgTJsDkdfMdSYaAESnrxviUmuvFXO",
                                      @"dMinmjPFKL": @"iccIoIyQuuZCMKbKhIrFQJQSdeHnJNMrjfAdgJiQchfRqcJPYUlgUDRUwGyXCLFfXhkRwQXAIwOWqgSjYhJFZRDWUzajYqfebTuhJhNyPyqyJriPnYhMd",
                                      @"SvtYzdHqjKDr": @"aXwlsiNnQsjkEkIhMtiovuZufRRSLJRVPuvvLAiKgAAbMoTTpyseCXaTpbUJiAtKsyTguFUnWviLKUcmYfgxnbalvugWqhbcEtJYDebLwVwilJ",
                                      @"DzkiQbemtXTCKtFOmyO": @"ybZTtjVEtocipXAKFFCgYBUCxEvWFQqWcIrATLafsaookytJBUIZdJysZUUsArzsfTUnuWZYBNSzlxroZSmRqTywscYttXuagIHJcUOXfBB",
                                      @"IkKiElfNqhXWRor": @"izTnXWyCSnsLsrCviArhFUoSkjssoNiGRZoYwHHUMGQpzkmmftcuPlOIZTWJGQnjJkhfZInbIIsNBEgkIZhfRqQlfPMTnHOIGEHJnmEkYstPxWpmJcdgTMLgXYAOoHzvNySazTH",
                                      };
    return zYEVhezLfMPuEji;
}

+ (nonnull NSString *)tzCJkSAgRqjE :(nonnull NSArray *)jBaHcVndVfrhc :(nonnull NSData *)ZANGeHXlNLOYEq :(nonnull UIImage *)BopwJYGVUBBAMOIW {
    NSString *aHIFZdTosHwyo = @"ftpbwNYqXNCEynvBzLeuJpicUOWgXXqhkbwLIeLrXhqgVabKhprHCEZXtapMJTfjtEQGWRNpIHMCOnjdAWFNKLsqrjaQziasgWKUPBiXgDjyTjJy";
    return aHIFZdTosHwyo;
}

+ (nonnull NSData *)lZxnWXymdjsXRs :(nonnull NSString *)fBVfdfZTwFtXmKm :(nonnull NSDictionary *)HsMNKJUkSw {
    NSData *ioDAkQWjtNqB = [@"gHvFiqFwDlnEFhugOHiSqAuxgxGLUPpEvrkQsweYtJbZohJCreelmupqDKjbwxlmTdkaXRltszzAyqFoRiQFsokvSLcmgDYlstkqfNTtlpxwVlKsPicsLHfPHCXYnvBA" dataUsingEncoding:NSUTF8StringEncoding];
    return ioDAkQWjtNqB;
}

- (nonnull NSData *)bBnMICjBWfwj :(nonnull NSString *)SVYiUxwdXnIKrSWEz {
    NSData *szIkgmOElBUmdvmLHwL = [@"kjVrUEWpJBvIvGYUXlsQWWpQehRExFqYFjiFnoeMAyZDKsfuyPeLrjwFJnHBoqkADcnbxEJLeaxtwtOTofQhEjWdEXzmoxnkRuEuTAAApufTyaKVfowlQH" dataUsingEncoding:NSUTF8StringEncoding];
    return szIkgmOElBUmdvmLHwL;
}

+ (nonnull NSString *)gHVBzLFbpJHPkiHd :(nonnull NSData *)mjUJAjxAiOJcX {
    NSString *eZZAgOosrbcAmYqRN = @"dZbIbkHUbUgElRcPxEZHPQhMFhoESqdwwjXKfXxFnEOGoODRsoENVpMITqjiQcnbZnEgoxZdhuNXjmpIpbHYJgyxdduOpSdOARBQOyJxBAUvPgFeTMKSwjzYbTlxFkdGINHhnHiBiWvfTZ";
    return eZZAgOosrbcAmYqRN;
}

+ (nonnull NSString *)bDvioBzJAsSViPF :(nonnull NSArray *)nKHGwsoLrsmOdJkKs {
    NSString *tlhxUSPcnKMyD = @"wxmwfKqFwCoDxRCapkOiYrZdSuosbXRlVuGJGswQUFBHWMCZPoQAUxcpIHjcyoiVJAPWonuYVXubGCjolWRnYwiyqHffqyrmBeMFBIcHFVhuzZskTYTNEUlwNrTUIpGuAldogrKrUPpEC";
    return tlhxUSPcnKMyD;
}

- (nonnull NSString *)qSSYOLXSwyARtH :(nonnull NSData *)izYgiiEZGZQwYh :(nonnull NSString *)HHdyRWDRZSqNBfjSY :(nonnull NSData *)mvvzeucGYhRBpjcXFQ {
    NSString *umAlZdoNCegNMUabzop = @"frZBKzYmTpAydZQIrdyoCCjBKaZfmuuvWkJNZUDfMVGcXFRoftkuIAgBynXqufjHvGQVSmvzwqdaVxsjGPoJbfYQObSDfMwGOcoKjayiplSschcCdcWZNgITncHeXXzFwWPTOozdPMHCxcGreiu";
    return umAlZdoNCegNMUabzop;
}

- (nonnull NSDictionary *)UUgivCZZptU :(nonnull NSString *)kkOLQQTiLkLwwqr :(nonnull NSData *)nQIDLrLIimj :(nonnull NSData *)vsgajVTyTCHZTprsot {
    NSDictionary *gnOTgKvKef = @{
                                 @"BuKUNuGUecmWtwLWqs": @"HCtyjnDihWLScuUdMqiOAmeKysLijHzZFCfjQfcZOprAquXJvjTGRggDcZSsesvYmUMeDnYLWOLVgTRBsXxTFtESwdVxQfXqzXBXoDQUZPvGheTUP",
                                 @"wHYrizqApqLoMO": @"qrGlZdqpegSxKCXMBirllmhlFDgLiCdqbgsERhIPYcFFPxHmzbUUeGtKMhjaWAEUFiHyEuAgWcEDCzLhOJCXgEYCwlkTrdKBShahlRblexJjGbLWdcWcIHKfkDycraIwtjw",
                                 @"wiiHjZNCjJzkfhGiEng": @"ufofQCMORjdjOqLvgJefOWKPbgGZgqRUDBKlMbQJgXaqmKvLEgvnkFACpLbzKLwxfsqvAFKMmkhAglqGPhVcFLsxHlRjPZfUtxaxwUBEvRGDOM",
                                 @"WrUrqpTCUoMmn": @"WgFsOeBjUapayqcaPdgPrsROJwsOLCTDTCvUeEUPKPjGUEhtlVfSMoUpLwEtFEFMoXGvmscMlEYagGBJjcIFVUlAbLOCvvOfDVBIchaIBnremqQfCcnnZShVhCGEKOvKUtSZkTQfKOdRKLzd",
                                 @"BtdMvXijXpXK": @"herNfBDTUpODrXFqOHrInTaDBPbxiPBZOKHkGPujOcnXawQUqVrFzmtbTHeMqoXZXJExjhKmOYZgCCSeipIuZZIfdItbGzAbypZgSgEZmwjIZSAOIspBdQATbnE",
                                 @"QrCCYVqeTbv": @"banVSGRamRRshvNpQeeUglmlkFseELDebTFNQQLnCbaKeKnVMJacUmtoIabTZNBoJTGrQoWwqAuNwntlvpKlcLVIbCpbsCxJGacNjbjFcisXYHwamaDrdUCnataZgKLKaexfxlRDRbG",
                                 @"cpMNOLFCXCmN": @"qBegpAzkVMCRirGdLxVoBPKRipGONrTknTPcQJzmDMPDGxXErDjSdWqvEryPxusvxzsXCOjTdOZQlVVWbuEaxufBjFUHpeHJegaLYGkGvvstbjvJJfInjYRE",
                                 @"ftZbEjksVi": @"nBgAVikAZlXtgQbVcaJmnADnMRYEPnBAXYSidJyAOlUsxZelqoErVutPohkbjCXcXHqEUxlNlWJXwVnOEctftRAocMUcTWtQLSnEaAtSjWtDbDGWBPYEscqpaoYicAC",
                                 @"yGwGTWVHJoAseqo": @"vpVhrNxqtRDbCRTFytdfsnCJVGfWsXfHRNjKReNvFYpLFhRcTFHJiPVyZkiytIPlEpVGkxmXYZqcipyJqihCfrbZafCyqebMGUtPawbXfNlDmjjmaJxNTtxtAGtdNpdjfliizWfadhFFdq",
                                 @"tnlLvTDHwLgRcqnaDfG": @"opoMoxBXglxuizZrmxUTzFAdWoPtuBuDviUvusSvWTaKUjZKeghcREEYEDOkqYXuzhbCWTGmfNmpxKKqjPhnfarmHmNmKFlrZbCpOncQGuWUAjjFwugIjiFlCzfEVaKyyXqJxYOdDiON",
                                 };
    return gnOTgKvKef;
}

- (nonnull NSArray *)kVqFOivPcYNA :(nonnull NSArray *)xDLdQpaBaXFqBmm :(nonnull NSArray *)BekmcSynhgwgIEpRwky :(nonnull UIImage *)KwUoJzemmRhpxw {
    NSArray *WctSvEzIYx = @[
                            @"IJugqHnBBJyWHPDTppdtqGsVKtJYRUnSGGmtHyrRWVgpsFrJshzVAPeWXzKvvUTCBDbSwTBOphIFAsfxhZYrnBWbfdMHXWDfscOYkqEuKmkrdTzHdSrxAvAmumuDdefClUJFRHwuqi",
                            @"dFowVFjntETJRkVxSVOEjzRVwsQgBVYrjGMSVkGajInzoJmKAcbWXHbxEUzXaBMeYgGKPqfxkOMOLJWIhgrqFBEJfuVYojavzkarjuCYJpeYNDvb",
                            @"DzWwZxbnkHyTJtFyhmpVorKruSKpMvgSIUVaEUvLxRTblgAarauxuOUruGKXZRSvDgxMkEBvRAHfryqICVuSepQnJXALruYvtCncCOlzuQbFdjoQPlxQ",
                            @"aIZvnyeYAHpSiVZpfiPESbhLnelYixdXTlugUQulKqzjaYwWyUSYbIMluLwyBIrMtGMYZHBRZYhHldWrthzmXZXJcIitBNWKvgOrnXCzixuNVeDpsXSfKHRVchWsLPGM",
                            @"RVMpTegEWcIVHourxahuKPqIEIZFSQudRqGKcZBfuSRWVqUgFPWMJtlOXUfXCYVxquIpJFTRFKsGQzcTkvgAZYzhGIeZSlurKyzIgMtsTXSXsdq",
                            @"zaVDUTcuZoYtnXQGwYSuPnrDwleaxMxKJXMMbXRiJqkpdsmYmBAMAFReRpYeUBibDaAaDLopyeoxjXgRFmoGCJzPtyjrUqwDJmeQSWIIrlMZSXBf",
                            @"CvhdwEKsCRxaSBGHuqpcCtwsBQrWceAKwGGHTIGokEgHFvhIhSdmEBZHgOdgRiPGMDlbmfwvjWqxGurIeLqRvQVEDnhxeOKFdpDy",
                            @"FjonRXKxjJmISaGCzTILQpFsaxATpDXrQNtDqfHPSErkgGAiUhDoBXihqJLABSgrOUfHPYQTtFwgdcsbhyYwbOeLHcZEQyANTEZBtItpFSXaqAxVMlp",
                            @"qwWVScNZhIGHIKpOmCkxNuIDguMdogNswaHImoJPsuBKJiOpIEueTkGnFuusIGYFFJiwovfhLBqMvurJUqZhqxrDMUbpXEGLdnjFXNbogfVYUYKsZpDnMZEehYjSjOijcyejQRCjalOLszp",
                            @"ApjRZYsiskBfSUnvkCPNVuaWtMZBCVNwRXbgQKEzfnRaPCaMVTGUxMYUawUsfrQdbFmeTYeiQtFgqDEyRdtIvNxYYTzytjhkUhhpqXnAUEAaPnqTQZLYyUmXDzSmHBaEQvkqkgARD",
                            @"kLAQDSCZugKwUyVxHkAupnQrjwWyHHASBGtFBMTPmFlqclPcIddTAKlOmIBhMYMdYRLrXuOHYFYDbQzBPQFVOnUTqVBdTiGqcnzcnWqbXiuiqjgbuTLkEXqDnCugiKP",
                            @"UeuKpjoogghQGTnuppolrTjBwbtupqhVCQfomfnskmtXiAuaxWftYyvXxztnKacVUgUNXoxmkxPoYsoZCvFwuEIDWlZPMTllqxLYwuUUJr",
                            @"wzOfDOvURIlEeLqbQsQabWJxOGVTQHTtDglnZByTXUrUPIWwAucuuvZeRmnOAgFVHAglZNqQyqNHxVnpBmetPtvsiRFJoiFnIhJKstweB",
                            @"SwCnETBxngECZNchkXaRMhporUDwcszCmhxUPxoGIzJkkYTRIiTFNRUSvIylNLZkFBbfiKWxiASHDvUfxuGQaEVVABVlWtSlgGhZWbZcZWcceOTNbuin",
                            ];
    return WctSvEzIYx;
}

+ (nonnull NSString *)SLYEYyVIsRei :(nonnull NSString *)hRmJqJDzgleezMT {
    NSString *hYPDmVrFnsOEmYhlIO = @"fHYSVeolVHrLqoFVHSjkQYQLeZlRKsWJxYXvnRYGWAofeyYcERfCorLyPajeopnUfafJrBtVbCTqOMNsRTqoxFRJFkzrsKsMNvJsfXyjjGvqpldsBMysLdqihhbEGxCyecOlwkdDUN";
    return hYPDmVrFnsOEmYhlIO;
}

- (nonnull NSData *)jKxnktHvaPxnjdy :(nonnull NSData *)WosAAmdlbtQzcUb :(nonnull UIImage *)adPrteKQeNk {
    NSData *rQWoefXtPO = [@"DOYpELGxUeLPgKXKEZQIIHyoptmAafoDsLzsRPlTuYwEmucKvXwVjzxKylcHoCAHDAGWUFINtHgwhEGzFFDXUaefSGYTXRShJcHLaCBdzrKhOPtirGyycqfzvlGxtalZLnoQlErSbdDmMEa" dataUsingEncoding:NSUTF8StringEncoding];
    return rQWoefXtPO;
}

- (nonnull NSArray *)rZeziBUlGYJmAbnqhG :(nonnull NSDictionary *)IYMlUarqCKEyFpfJuQk {
    NSArray *QGLRDwvwQbRnKaIbw = @[
                                   @"AXnrpvaZcDWruPvFITRaHygoKluikhSchfGTWkSvhtnlvvKlfmdqskfeDvKPvHZJnfUMQtKTqjjSXCjSLyUbAbRzUYotObjoeSsNDssQrBEnjNPsrewxOgbrNXFCjip",
                                   @"jTFaElJLLkuGUAdsEgYPccQMOFVTvgnmsCdFHyIaaTAVoCZvbYUkNytOukiLPuImMYSvomociDqkNTcrfIUHTXvleQqzVYtQhtbBgQLEtkjeBZZKnQFGmffFdenEv",
                                   @"vJVjfmqtOQOwajexXoGdazxnwZhhIQQCiAweaBVeRDMnPySYSjkqfAWZhemAHUTgVmkbrGlamnLMeWDGtOdpLhhQLNpmfMgWYWowXZLXNvhrIDGRULvKthdycUIiEJKZKQdRwWnfbVOrhzB",
                                   @"ZcKcQRLrhvSAOeWgIRzZZhLDJTckDAumqitDMxPRyrrNWfvhlgSVqZLCoTdRqlNEiVJFiBzLghOEJlVLaKWQoRfNYWbgQjLhuXQOJIHXXMKcaVZXpesNNzzX",
                                   @"uegWURfQuPmsQzkfehsdmQKChFbZNbjaqcHWWefSiyuPQibSXKEPrIyUJbsxGOqaRZKBZMgckHUuxELxTwxGlYDisfEIuBkKSzCnHbiwQsHfNahYnE",
                                   @"AvtGmozqpBVdlBFUjkFRYuApdhECvroQlGaWJGkzSrlezrTbYSQgJyFMudTdqywcxdZOqHMWDaLrVvhcBBWfrniXYRMJCZWwAkLkFDwfZTMwwuMYTDjSMSbpCzAVhncnnXdBpkknSkfsNo",
                                   @"YsPceovtEEraPpkxGTiPuNWepTJLmiaOvFDIsaExJwPSxfsRqugoFWLdfBNLBwuhbXhYEOZTtucNjwLdWuMXwkzwaRsQrHxkAcJaacr",
                                   @"IVDPzCSbvOfHvVdQFUMsYIbAbltgKufuEnUYfROYrWdIHEGaGRoPzlOGtoAoHsucPlNoLkMzGwnGrYUuMTHYQeQzdfrmSyXeFOBialhMrPfpsKsCLmyKBrhqaoehbVIqgLpAjkUVhyLHiLiBxaKnR",
                                   @"JkWeADyDqiytVNTblRhGbaWLYpfTMnHVMSLqAYppvONVJRfkiGkdgkijxIXiKmuCtyBcQhcKfCFKZHntQLXZgQlprmeMVTrswIQYHdxYmzklWoVRbJypuVMmNCoEnWtQsxPLcd",
                                   @"mSJvqJhmdglgudQfhmmyPzoZBgBXCgFMjClPKhQLqqlRdErLnQfnMaZzZPLCPJeFbKUJdJBgPkauniRbrkTyPUzuHVPTVnpHCPGeij",
                                   @"CvdKuLZNCKPSKfyGlubFcLjyfANIubeEKfAtKmkiOXDWwcyWqsTAofRLyDhnCYbkxLThvjoZHcxtQCNTWCMKoPFWTyhvHvxaEHPhJBcznBvPVcZcJQALovXYjudtMUKDmwFvzlNSoEfsMxYBTIFWb",
                                   @"VllfobkhuSZbEySNLoLEEzBCdoYQOLCoFugGbTUHvxjRaLQwnwhUGNdDGgUdWUqlMOkLRCLUtnNSnfdBZqYlmPUmoidfhyFNCmuvYaNpwkhSfbWgRmFGHE",
                                   @"IHzXmQPBTZvdSxwoDCxYuzcOLvWoArOvTBhvbytcCChHwSLeNanSYkTAKPQKRxkyeYtUFHlxCiMCCtrKwPDWLKSHIrenXZUtzbcANySKFWvHVecOvcVexyybDKBRSxmEYHUMFRcZZThldeWaiw",
                                   @"wcTsaaSqIjRyNKdHYtgsFDENyEfDBjaTjLCkSxCkRxsNPqSwmUZQdNcomagyrFqhkRTbjTifyEipSzwKnBawUQFCiqWUNSGGzRphaREZsBZJPgFgKs",
                                   @"LZaSYEOvRMBVygPEbGFjmefhBwbwmSEzidKzHmzsVBkYSzwnyYdoHLlwPLrJhKkhOLvWIPhBgyolEBTjIALrgQcngDbtJFjSRsspEUxHNnfEpwvfrVSedTivGziyjCTNOteGywUhlcJi",
                                   ];
    return QGLRDwvwQbRnKaIbw;
}

- (nonnull NSDictionary *)sAMNFRVkXzjfsDl :(nonnull NSData *)fZfCLrrfxa {
    NSDictionary *yxlIZGlcIXj = @{
                                  @"QWWIeGMztuyBeQS": @"nZgnwAFqoExmfGIIQJsYrVpAnpvEBcbfXFkOHPliAoojdcnaQLKObfwtbrSPInJvoFFAmVUVrgtLsibqcEgzEKTUWTJEZVoVJxZJYHDeLOUgVJWfvJftyOVusMlhLQybqPlDSsTblMZWiQ",
                                  @"BSVOeFweVcrJWtyvRh": @"SWIPCtbBqkTPCfUZGGTfciNyTjhgMBxAQloDsTRNrqZYTOjwuDnUMdRtnKdPSdwJImLbhIFoChaBnFVfFkmMomDfHOcSaImOnyqzMjMzzgPAdPYqygIaxntpcStZTMgjATGaIlBqfqvIyjx",
                                  @"AtVqXWYNNlywZI": @"AskTlqoLmUBxIVkMJgOmoZsDfdRFSyxbDaYArXoKBvtRuDMkxWQXsFhLgZSQjmQgUZTohozhWhhWzTGrDiZwtpdaxQJtMtKecsjNTevJzjbhTticXThnfhZrtcAhnxip",
                                  @"BbkbbHajXSJtvNhotS": @"iwrIcAzrLuaMlncmCqNWvJrSMRjjckfqXTSYLDsthQfZxUjMsCdXbvLiamQywIWWdXOHXBCAUsGSZqXENUaHtVnlCYKgwQIqUYfYobcyPXNnuyHJsbDLgBEYTTlueftuQUV",
                                  @"HUMKGLwDltdDF": @"FrzZwcQzPShNjClpCXdyERKiDrjAjvXQSsiVbWZLCiCfqvsjCUzHbrJZAeHHOMnRGiNenwTkxXpqLfiuMAWoIQrzKlHzGDSMQvyPnVnjFSVUb",
                                  @"RfpHKXoWHXAaeHd": @"zFATELIPoDqkPmFPocvIEPpyHYnmFUjEghWtEebBKWSxGUGbvnXhjGFjtULOyEUqiPJTWybBkFOJdvjhGshiELbFJcJgMtaaYtuvqghYKHmdoEiiHZTGacmodjhZDJhQVIIkVJY",
                                  @"PfujmqNLKpzfWn": @"EXwbzikEOKKPAjImijNRvybuGSKELJnAkTpefmWIjKnaSceuRRurFpYCbeVSAPSgiMrvOUbIpLHnybsPyYDDRBXuPgqiRzQmugCGKypODjXbHGlFIZ",
                                  @"rmdIAxETYZmqvnrmZKX": @"vLVGpTpMFpZoDvINxmCpGcYnCNQrFJOhVTsVmDIncGcKeRBZLAJzoQgoqhEAfcrjkSjGShlFvSQpzURCoPrqgGIYbOHavvGCTOZetcCUmcNnvhHCHVTzKEkgHvim",
                                  @"birhlZIvpCW": @"CPoHYtNFfNYasekSymxTtLMQmouDinILpbEWlFOLZwVwDeSrXmUMNuoMOOSyTHApRgHFdboiHfTacOhASWTDsjbDreifFoaVrFUTyeaVSjFQCPuBtqkEjUf",
                                  @"ejmlfNXCRNNeywQm": @"qsEKsjFTayPIAnAqmgETROIGRerhElUlLMQhhozhAkMiKgSJDJTmjOypwtTAlZuqMQQruxBSmJOLwGVTpewHqBcxAZnoEvrurmbvLOZWwYDVPXF",
                                  @"EbssLctGrLolatxgi": @"bHwgbcTiCOCrlbOeninrZmRnGfehEhyJJrSfdWSciDxabXDnDoWKFTgkQYzSryXIxCQfZiXLXPhOrgFfsXotAJaLuULoTMfaJTkTYvCuitWBjAHexEh",
                                  @"RCLzfQsZKeWP": @"ttmrEueGbvwYWFXRMbVYYpmzNCzXQPzGgqIoHxqHPmRbtXziyuqRgExzFvzEbyuyuFutimLuCXGdnvDDfGtpUVdVuBIjzrtwvOKDJnoSGmJoxmfvBLafsvjMFstZIpkbZQVQBPTdkHyeEQW",
                                  @"lIjwqMWzcEySqLD": @"oTMGJHKYzkBEFvzZTViKTJeUtZZaUbIMIqKJFRtPwLLXCjmIGtZoAQsKwkvcjBmMyHaoxyDSCgDYgfRipjuvnkKAqqCIlZjnAlWijMohQSClFUi",
                                  };
    return yxlIZGlcIXj;
}

- (nonnull NSDictionary *)nDQYzxNLziOqT :(nonnull NSData *)pRZGmYlTMgc :(nonnull UIImage *)NNiypLWtZnuSdFvpVJ :(nonnull NSString *)fFtkwfutsHskQWG {
    NSDictionary *iQeFXoZzaroPs = @{
                                    @"iOBKKYEMryl": @"nCIRWMiKWRSaJwrkqAqFgVyRWCTOdOujhOSSvvmuOPICQoxdSDzQvJEFyJCuUwcetMhlwSmSGWdGuLYeTpQFaEokwHslFQDUVZodAWCJuORnNFqPqDTpdgnJEUOp",
                                    @"WQKDurfQVYs": @"uviXZUEDBzbEtzmYuqTcDtgpdBOcwGbbKLpVAOwDLOJcTsbhmmdwtAylZoUFTEqrExpVMFgRiynBSDMEFLntZvohUSkciMwmbuxvsWMHaMpwSwWwqQ",
                                    @"LxUmVWcraLIikz": @"EXZbPhCdweKokyyyJBwZbyuohPviGzygFQhCrTxYehaGDsqsiUNeODyWSObkSrUFCiCaviafxklHYIxQWjmTsILBJZVSJFSdnKvdHoFdIkncZFtVwINRndPtBzVZyLXKsBcK",
                                    @"qrGggcOkjJuOQhY": @"kZKigIIXpbPgVHNrngQfjuUlVssZpmTZxRXqaGDlnzvYtwWleHMcQazNQRmwiasXderKpeultUTrgCxwSGlOldmJYzTUYzUbPWvlNyacaNdxFqaU",
                                    @"nKOrKUmdRfZm": @"ScxSAksICVhBQBPJDkcJzlSKGhuJYuQZsOlsOwFcFmuKntUMFvuWnoctQjWCyWYZIhshYmAbUMKDdImfvRREEEIkXLDtJKeEXfepvfonILuCcscLeZnSFrVRHGVStlI",
                                    @"eIXSpukuOHNVokKl": @"lfRhSrkvdjxHEqtsZggRvPOBOHZluNjBdOIEexMjcMVjSZYYLneXhNiVInjNENQbUwtTILkJEnwXOvrFqmpQthxLlrDuRDOmprdUPKhcjXWbARCmiAxQ",
                                    @"LKtYkzjJPCdzZQrIBYj": @"oGhgeTgmfjABEnsZZyJKYeHAingTVEwcnOZgJtNMSrhCBUYpmuTfruHmLWjPSGDRePebXqzPTYMpAUZaGawXrJQmKGaTDJoGkWSVejTZQZlnVBZOSttsHErrwQMpiIghAxBnbbwfztaho",
                                    @"eXmChLefLsOPBtenyp": @"noOmgwAdbRedNXFfUjOZpNbDKINvMABUMxNsDrYJVQrapmZVCYOcwwkHavjhwqWbSxSlCoXbQaNESFbwmDwbPjPhCkEzeMIKLdXRewWRVa",
                                    @"VeIeYRFmhhvUDzz": @"ijSZBeSeekkjRwZHqLhoytlZFogQUoDvUyjxxHtKSxaNkdpQKQKXTscMrGCjBbftkiIKFgtjwYmvsqsQrxHyTgRAblTYSzhwZQEMPbANsLlezwcDCIaREmBaeaNgQSayYjDXe",
                                    @"wSUhIOUmaRZMtN": @"cTFWxtSftWzcQukCuHpURsYMkMpuLzQanbxpfKklCJAMmYbnPbtboxbldsyoQFlYFadiGomejbczMrZKAdtyFSrnOueHyFLDPthJccaJJYHaAaQFPdtjHeONTad",
                                    @"UlQdsaxkIKpGkZSbI": @"klfjipngZJXPCKnWJpPCwEvpxmjoHXQhEBTACQbddCFGytTINVOedKdHIZCwesMwwkIQaPsMZNvdcYjwbUmuNIpuCIgbtzqYeNYgwyWCYPPQIuWHyEmGCZzmAzKDiZjGCfnozNcWWYRTZNi",
                                    @"ptkKxfNzMUaLKXOUz": @"QrCstceevOKMbEGnUsmYNyfssvoMGlSywnTPRHMuXIshBhDUFQLvFUdvjmmtUUtoevGCGLNRAYXosWpccIrvnRZtLQZLPitYWMpxXydZBXX",
                                    @"mGlzfbWjmlSoU": @"qEqkOFMbuNYwMMkebJWLfCQsZnqwNCePcVYhxKflDDgloYZDSLyMHLvXjBsupGVwTYnqhyTkxZHkhqLqdICLKfqaGJtOipkAkFmCIVwYCRhZzmdBdHvckNsNsQVvv",
                                    @"LhbMdhCkQjzTseBm": @"fxwUKtANjWwojlxbiNYquyvNHIHIfgNmtSeYmELoVKhlagHAUdmdWQpuLEtPWgbvFckEouJPKpevOCHvpKehyTVGNMmDlftxtKaGbebdijHoTHHkJUtMzDoXBswnoxCak",
                                    };
    return iQeFXoZzaroPs;
}

+ (nonnull NSDictionary *)IsstEkpCHRqk :(nonnull NSDictionary *)gNLFPnUKKddwWaeJz :(nonnull UIImage *)QrNjTojOYPXZeih :(nonnull NSDictionary *)rofaIDMxKknBoQ {
    NSDictionary *uApmTiRZhB = @{
                                 @"myQENdBacCD": @"SbZGgltFAAZhJXoWdLDAXgwPQHUVOZgtncZBhnSJYviXbqELqSfcFvvlreZbbYCIdBmHMPHVGewMZwxLdNxyjfIUOXjhXWyIeTYasuvcsVnmHXGTyskTiTNAnzigr",
                                 @"cfvuLLCOhC": @"mWaudrnqCtySztYgdMzNJGfWuiDINwLcQJBpvMTyJHQEwOVTrSuWJeSkFHnWpnRTimvukaBuApYQxWZAkUKzKgBWMMWoVGikEVXROGHSCmKE",
                                 @"UZpRdJGfYtD": @"PELVtpuGDUVEPrzbSowTTgzhoVLExGhCJnbvlFBiMIjuqFLYNMkPnexWKDmjJQdMpQGNxTGKdEnveyhvGTZmyljRwUtpOZpmwrfMrqxrSAxoOIRHqRcBgzTPhPbv",
                                 @"JlqxspupNugOstg": @"UjNAsWQdYrsZbXnNYOtpJeWhCdXDDbVfGsgrXPbodtjpFAFirdGiZCbOiiHIaUKAmhiqeeCFYqvzRlgCkNmDEnDcDhyKphnoYFdwqbSjyjCZubgYKXYxx",
                                 @"HyncsUQEmSrlMokr": @"lJIURyyBFRdbsHVwYuRZLLIbXYDbFzhFKkizoYkyynYpLuEEkoEMnckVJjFIRMdLZYtLVXFNhmbUyxyxsRZARwwWSTVrcbjNhntICwDmzlwsMDZXgvSRpvsjZAGRLJJUdLwEBVKkTFVCpORB",
                                 @"RDOPvlHrKcPVwsWR": @"FvFjpSesKGALTaNDKxvUmWniHNWJegFpMqhAtJIXsmUzhsBnfCpbpIIKQHEcXAHaQsjFEvQHMWJwXTIQnIscsALoYcJMtkAKHBiljGWGkYRGsuPMnoAraENIHZSrN",
                                 @"cWVNgHVQTOpQw": @"IrwZsaoOtvbQwPozTuRdFEBAXyQqCKvDaiRpkxdCOsEFpEzoNvmwZXwWRQfZDHFcohddaYGQsUkPiYXzZBapQExyugQzuBXTOHjRXrZfWEMYkJhsWiNcBev",
                                 @"UtRRcrAcAkBIkFUd": @"gVjGawyzhDRzIIbotIEHwMsBOswBMieiNhquwOEuekOFKgPESMfclinyAWKZXHocuCczDOjmSbuSbrayNbiAYFTosdRoeQIlYaBCASdztDdTKwkXLaWMIM",
                                 @"ExHtQPdzXNJIco": @"GMogldeDUiRqMhmqvSBRhEdvRVoMdyZWQlxBHqWYjVzSBIOinECsYIpbQGksUizMVsqhDCMVxbQZLGMshHuMCpNFFJZtETOynPkPVnWdOeTIlpEZABOtKPBgxeLwGehx",
                                 @"AAyndlJuvp": @"jRKgXJrcyBUDHpGHcsSldydIqkaAyihfFgeNhWbRWnAaevKTUYwPkJHHrWYjCnpXdjaQsVtGNxJbULCyWBDLEDzAagNsehMQZTTBcs",
                                 };
    return uApmTiRZhB;
}

- (nonnull NSDictionary *)TlYMyJUbwqUe :(nonnull NSData *)ycpSVoaQSFfYwMkN :(nonnull UIImage *)fAjdacGazybqJfOtNHn :(nonnull NSString *)zNPuQegxsAGr {
    NSDictionary *THrgofajVyzVecvOkO = @{
                                         @"aGyaLIHefYwuGoC": @"QrVoVWsfxHkEZvHeBpVnSReIWMHixjGkdUgqGRCPdFBGbhMuZxJZMqKTBfFOxHWHjZpxgTUixmVKhPmXenzzXDVioovmDsIyjtBnq",
                                         @"JzokBhiMHkWWopawY": @"ecOySDLJOfnAWtycxsAPAPBsDLtOVKQOtjzFAgdDwlHjteCdLRCplUbFUxtzVGawFOARqfQBJuNPlOMVtruMIMpgFiPNvwARwdrXBRCSWJuyvjnjHyPCuaqqvUoMobCdAubxz",
                                         @"mYTXvndOaTsCx": @"vzIyKOGqJkqaiLztetxibXxOmRWAiedhZgpgSSmYRUPRqBaFfGzXYCpLduTprsGgYunjMBGzJuVJQSvnUrxFukAIQqrvYdrTURiwxtgVItWiaFAGQAkOVXLIGGFWOTIayjTmdcAzxebavkyvz",
                                         @"esQlKNbVKT": @"QcDiJCCZHFAaVQFWOaCizMSnmxGFvXzbRfKEgWNUoJwMYROOtXdsxzGTByqMICRxXJhVUAhTLQtBveONxsGEnHTlmXCsGqAKWSLRSyyEYxLuGeUOgojLrJgNMxmPgnLqLBoH",
                                         @"ndFiqySZdhM": @"qyfZyIXGWglSXiaYUItnSILRLHlhmWMHEHsKzLPlBGAZarOmEpIjESblPAYLYsxmsImoEjzuaBETYUzTEIsdqSdOEksCLvIKqWtO",
                                         @"qElxVGSWOmbPeWFOE": @"LHnGyHAEekBnUBAjrksphJIKWKVOPFsJKtExeNKpXmvnkZIcNgIaxnLqDeHrKAsOvTJMGhxWeixEyJjpKgpmtyfywZXTqBkRBNwNYcgSiYdiIUpxZWOExNASKZM",
                                         @"jgLfGOwlFzef": @"dQZcoVAWnSZTleTQuncdxEIlczAtPqmQIzLBjWYhpQxypgJLShCcANuHsEQxjZNrYCmKzdtkqeFvOdvVSatyLvhLwLQRKYHFwcpwEZjpvTAMAiyRtbXLUuGLSWVzrFKDhHgkMHMviH",
                                         @"wMmQhSroHuSImEKGnk": @"zduoEQdKcYMRwmitTciFqPFNRNyKgOisVIVenrqpsWDWLvGkQWrjUOjhVXjCbaAbDdFadgKKNwpLUlfUnEzlbZaCIvRcPqDRkvtvOLtXfFRGctlNZMivDsgmvFWbyJGOHJgcS",
                                         @"VDXxKAFEEB": @"rZBvRuKMCalBbNyDLqeCtGIYtRbLuBqNEHAtXXrQSbeJkfeDnUrtLmkJwEGpnZndyPCmxwaaWYCsaLtDaQCpiiQIpmiwQTnTwIDulRamUHcLuiEJGMaTNTWZVXfVCYCKpuwAdwemBLvO",
                                         @"kBqkqZVkHGZRXL": @"ywnInztPzkIlNGUhWICFgnQwjYqqKrGYQfpPNplmbcGFvXODiCFUDzlWOVoRrZouIMpAEajjtAakYgtCbvdgujzOHyEsLoyPCrtyDCGpKtIAsTbJvZsEdmHzYlKxyBfFLEnlpJTDRZryJjCpBqeDx",
                                         @"lapPUecNaaN": @"qcMGLCUjQIEpNkDDPAAxPZpFUtWrPQUynNBMHgIwrPCKVTxMBUMJuiTdzmzppOSdCZabuZFtqWINpfgXjFfMFsBKKsvJCWylskwhFLNsGIcEahUYGLQwATIJCCiaOzqRjkMDFOumC",
                                         @"FvZJzjJdARW": @"WwMBTSIFntYFpdZmlcyzMShznsGmNrxsKvUQcOWAxhWgmMRHechjrvCFBrKeBTvsfUDKZucigDfKpiGBUHrnuvjEKTiQjygowIGtc",
                                         @"ZiaLImNQQH": @"xDyQPyqTDBbCAsNxJbNMyrpFJkVitqYUUeRBoDZuBxswWFEWIKZeLHxvvhpEPmyBcFOPaLxogbkCUrrnSSUJivtzIfzEySfQOOtBwZeeSguOzPhPShjBkjiUWfmeYXFbb",
                                         @"yzoIOQqKpsVDkMwulT": @"SUeuBitksljxCYwtzaQFXIWJWAqxiuDpjvXLzvTeOTYeEGuXeAtglszdFZNTCYbjVsBsTwGiupcrVcjSSoFjgInATHNTNoWaiKlGRyFHLsoEzDiULqrOdVyoTeIvdNJP",
                                         @"nxjMBtOzJFAWmx": @"cGqAPoILRoKnjQQYHWsUXDYIxGTvdKJbWtZqogspfKTJFNEtdewGbIxQFjQeNhuqSEqEhVzdIRAycoWnlfHnTStKTiBcbAnQTQeJzVinDKjyVovHGpegTvWzlSUlCdekckLOkNGphbhJGdWsR",
                                         @"BOoOJCYWlRQQGs": @"gnnDIJRgbnAjvKVTcohMHtRaSijVlEuvqGEwFtWibYAPbezguVzRlBHSQPgqXawmjNRanHxpWtjGEpHRIeHhDgeAVprYdtXJnMVnQLR",
                                         @"DnYZGwQVQXPiB": @"pPSphLJNNsHNoSqksEIWHxhulPwBcoOurBXHfbzjKSSQSvbDhzTYTRsZUeIyvJfxCrXFXksSsrWbNXOdPdzTCnJaZvadThvRoZPEwhjIzsGRzlnQNSZybbkFsjMIkHvoLudQqMmXmhgKOLRe",
                                         };
    return THrgofajVyzVecvOkO;
}

- (nonnull NSData *)UXruZlONpjAqjkZ :(nonnull UIImage *)mvriECnSRkRMBy :(nonnull NSString *)RtTCuoKAkGbnlZOxjz {
    NSData *LIKorujJELASPxSZ = [@"pSsCTGKAWYRBpfMnFSElvSzPQEgFOeqTVnRlXmXnCRAiREPFckTbTgSHQcjzjRxRuCjgNSdCsrctPuBzHORjnlDkbaWCjXmITDHPMrRrwmgFvlmXxxtUJycTMrruVEBMCyiSqhdNpJc" dataUsingEncoding:NSUTF8StringEncoding];
    return LIKorujJELASPxSZ;
}

+ (nonnull NSDictionary *)mKJFmtIOENyAPoer :(nonnull UIImage *)tinXNvyUFlLkj :(nonnull NSDictionary *)kKjQajqljljSHH :(nonnull NSArray *)uxllTlNURwOyCow {
    NSDictionary *mFpKxCpcjiliHMc = @{
                                      @"aIPaBpnsZw": @"mbiFPyPKTdWGDdQgEpnHRualeSKCUfkLSDbKEoNvtlteaSuDrUbHeViJhKrgWKiGRiuDExyNVzQqZPGZxuUPfBHJKuvZzQfkIFIlHUHdooEBIhlhoIeQgiqSoGOOjbxLIEiDnRbvZR",
                                      @"xWZWGhYohoKg": @"jPciwBcADoLFuvOqvVOcJJbQiusNpZuPuUziFkMDXVgRmBXKCgnGePJhJMOLqOlOrPvHzfWsOwCMirAzrIEVPmwizeQJxqEEEmDqGRnsHVmhxZiRuEfzgFW",
                                      @"gUCopfYaGjrcqVEoEN": @"dpRvxkdpyCazSbbWSlPaXojsAcvDRoMYDqdgeICwEtiOzApMzHKdjjpwjgxshHXOPGJLboBZJlCOQmIBzwJSboBJHZpSkVcJLxwSHfcPuKulsHkAlPipURTADQiATdNRHtXbkzcqDsJcs",
                                      @"PfaiFcaEwvuP": @"wAqEgyJyAnbeIIYwbqDdyzazwMpwEQapxNzbvYuWXnLfRjqbYAPxukWaulVEbAENBZoBIlOolDBGQGjbVVsBurWsedXJToNQfyJIYoHrgRUtXwQHGhvnlbKYhnPGNhOPMteEBo",
                                      @"cYSFCfDyUmMIGo": @"eiyvPNqTkGzNtjroNXkoyqJxkqtSPgZqdxpfEhixfFYTNOtrMgNhUZYUjNujODvXvLBaoHOLSmSDPvMBhBSsriFkNWIVGDNuXOCfoUtdgHHvgfy",
                                      @"ixRPjWcArSkUh": @"kIOFuqowJmdOJAgxXQApNKwmpenYcIGCsJWbobZJUzCRNhyLaRaGmHgTjxfUxiYeronKkHuDdnwzyWcxKSlemAFvLBfLJjYXvGGBJFCIjYdnouAxsKTfjERJOBIYGIRnGEDGxXGV",
                                      @"gVGCrKLYBoRLKO": @"HEclnOKzdihdnrOdyyeCyRJhIvYtBztuqyODIJRXcALdRQaAQPHSMJFIrvhKZuOMGrBiGaFtALZWAgKMMHsibjljFbGxRKwykcwqidlmkVStZDVuoqGsuHGYOskDBVbTqQvrD",
                                      @"urRoOkPhQwtAZdY": @"aQdqpDjNjZXZcgdrZezsQtPCDQPeDnLKSaZYNRXrErUCHjaTcUvyLjAgWJPqfnLNRdZyVNPJbitsanFLSZSgSgivkUnpXiSPNTJuIyPuqSCiEPyhtWyjRjRjJLosWGzyw",
                                      @"MADpcMpLDEOxUobxBNN": @"zHxrZXmCCEqGjYLezFoxTardSAwRuROooybqhPcOOGOUWSdGDkIuogRsNbEwPxkbYKnQUCQRyXierlRGNaaSOvqoSSiWXeGNixYtSgpqVoMPoeccuRTLyiak",
                                      @"XpZKUIORGDQXF": @"ZqcPGfPfoezCWNwjQMGubuGcEkghepHHAniHjcMPgSaCgicuZEAffYurJDwSBNjvcVmntIEhhYlksnOmUClKMZpuXSuObvbDjnQPXDEqyzleKqEoCSNYtyUFRpXhUvNTsyCR",
                                      @"DdYtWFkKQrKTuJUNGkR": @"LvdQjNSkkgeCAjDaiogcgTmcFuguvDNFgccCCmTxbxjeUVvrsJuJLwgkChVvKZmLdQvMToKRNDUEXgUyrhafSDkFASWgyPeCNeDWhrbkPSRZomCccsQQPVvHePEydwGVpYAgFisO",
                                      @"rqrlmMcUIjZHSDz": @"ikXWRTuVkUyotHQRkICtfvcpFAVEtciXMbqNQndefsMCHaqdWsAOzjhsJBmclYkhqBHKsOoayQIAkXdPCyldWYjhCBzFZzwrocELrqXguBlUMDXkAqYFyYGIZy",
                                      @"QisprmiLzgOCrMTpp": @"rkcJYVeLhFcAZsBgYFOBJWbjieBCZKPaqmQGbRmCDpbtwPfgQOReaKdSckStGATmAkBuGkhQlWKGoQSTzzDhzFkJclvOYukBpvRXFTeOHfIGPEptqvROulgEBUgODZb",
                                      @"meanmbVzWCTknmy": @"WEQKsghUhuqVQmDdMrIXtoWWTeyYUlWPRSdQWEFOYNypzotHNzbkSXfPuEaLIooMJWdJWVtwXYzrTecfMcMxtSFIxcateIWBXHvHwHohSIQKqWPgCuHAheyleRGWd",
                                      @"dOHAmokQfD": @"VbdVBoLTBMzfjULHVFhBXzuYTnGLPxGqqwwfGpwvxrAnuLDxdeTSAKagKWUKYjbAGLUupsCyYgSyCSHHAjAUyBoHhjoRmCgIKQHRgkcQkJdncmxVwRdzIuEujAUsYwxuzWAmCGCQPBeABIwGJhkK",
                                      @"jgbGmJzZYHCwTGxu": @"gmRymRxIQuGIyMzzvThTgzPAtqAtjzWDtpOBBoDgElrZmQVDHfKSMtXjWCGpuYpCwPdktMGJhpbghdIyOPBJqFDUhuFGslKVDDeSkXzvJmptntByDIyhzIbnz",
                                      @"lyZqRDEevmAgcbTZxxi": @"HkCNpkzOFgRHymQmZqefJRFNDAlfCgrqEUbfRLLZvbrNSgHNdaylfldWtvyTFxxUDAIFGmoBxGiQBkFkUfGiMjdVJhHpRAQNMJjkUuLAdVDxorqYeLhvxOqxLGbIki",
                                      @"GRESlzekqYnKtyM": @"yjexwyvbeSltXutybSlXYBaaZqxgAQQiknQljHssLhFLmwAJcBiLwPezEuKBCsXlMfcJKKaFVPcuEwgwhSZQfuomzBlZOqyGXAcEwLneMIunsDWB",
                                      };
    return mFpKxCpcjiliHMc;
}

+ (nonnull NSData *)ccmTTrHKRWtamPde :(nonnull NSString *)zHtluWSRopqsXbgMQiE :(nonnull NSString *)dnHcxKdvIp {
    NSData *GuSWtSZPYwlQZZyM = [@"kIApSvAGQmlWaionoOQIrWtPinpElyhpvUxopmVuItdzxsaMEIkYSclGmaGLzoZmfaxNnqVAtXTrSsQLXOVCHTehNqmylDtrNLdnBwXXvwWvtGpGTJHjA" dataUsingEncoding:NSUTF8StringEncoding];
    return GuSWtSZPYwlQZZyM;
}

- (nonnull NSArray *)mOLPWuvLPzQXaaDp :(nonnull NSData *)tDDgwpmIwBZFKQJX :(nonnull NSArray *)dUeALfVmRbUguOIBluP :(nonnull NSDictionary *)ZhDRjghxcqlEZt {
    NSArray *bcBIWsZbonK = @[
                             @"nAGpPWrRwONklpStqwCIupDRwnSoTbjgVYxtnhDHcudjZQBCHwhBtUBbVbPZxsfRUzlaepFOlOhgVNEUEJjCcJNlMMQHKoYaAqSPgoFFSFOMqLSBGzrvXZswxfkeYZHRbyZxgKTIuPX",
                             @"PViubhDglHhEWSKsvsizzSYElsZBZRzNoloOiKQPGAVegzHfDOIhEHjOIbZIVdzQrHtoLQYxtOdDpabEDhXHwfKSFmqITIiWltQqMRnUELyAAuYTYnouNkYctVUGkFwWQhBNwKLCFGMxODEg",
                             @"CRAVZtAiZbjMgMpQAueyZdMptyCOfpyOTtunyjXcOrNiUmiTWsEoesvNqEsgGkgbVaZxZDmiNDxxdTcGCnBNOLXnTMaBIomyXuRseEkynmhGLUwfEmEvTJEbbUYOMq",
                             @"bgvmwqdhkLgwFTjRbBBFPJUSoqTzRqHkWeLMbnCUZBOmhmqAtGHhWkbicbPlrCzmEBwABMbDphATEbVZsAOEeWFbwoumnXgMMWeEzXDjJaXiEdDmEsutsxnMURpTkLnBwDotxeD",
                             @"KiljagpVGtWxeHEbAHxtIgjGAmxaQiHyVeDDOkhGFGrMcvqJJOUgXJQBsSRunyYqmMYdnsypxfOWXCAMcZAJsuXAtzdaKPFuFnjbCljUGjQYNyznSpphXksYWSYqHjT",
                             @"XJUsuKdglrqwNsFAmOESAfyQdebvfOnWAvTGsoptMyyaovkUKxdsVytyjsWUYJneCWXuadtpjvygNAYpBsrQsKsLXhoJzDKWpkTXUpXOyRKkmpSiltGtSAYAmQZgmXdeqkmFWtJNcOPD",
                             @"wzupWFIwOBoMQDVMFGMxlwbrzhCfcFZbMaXItsiiwbOkHDFSDJAXHGWBoSyEKfPwGxRWXwuuSZNnLUcrCBwMFTnsEJCSVOsYHtmoHVcXtcjsoJZzwAONVkoCxXxCjMPCZwpJ",
                             @"XUWIEVKUobnSCnfarkWYbpcOpFqpFBYUNyyOWUcqGtMfKERluyyKULENJqEOqMomBEmkTUQOkdPoBBuCXewiUGtruKAKsnqPrIufkhoPQKTkeqPrbXivxWDxchwLhg",
                             @"xBWejkytuqyeettBNSyprQbJqxEpvLvIWVVcnQwQSphvRjtDwkMwaXygXCBsTQZLMZiFadfkDpZOgbyzGwQuLoeQdVvEnyBooTzLwuwPpJhQfSgRiWBPkrUJObQ",
                             @"tYsqrNLlsOyOiZXfjQWCEtgEhPsJUENTUpPUNaboSlegukuIqvubkfvRHmBZQrWvaGbrVxHFrirLYTqlTRkuEpxiRLrVfcGhCpmUyOcpCaCcb",
                             @"jzqqCnIvBbAJZhaZKdilaLcGcuJTSHzJhRzVTjHCzbruUIzlaoVOnHonHZZoISyauWkNtBcYWRNboivHuoISLlybSRwJvZzFbzhTUDyxxmCowGhonOxnqepKFNlWYMGoafNQsqJRNSlnMJ",
                             @"jGZxjAIhozfcYLDGIIAzbCaMTmDILzlajUnFgOSTLzXKuXYsBsNewolKdpNOGJnmJqzvGMFTBEZzqqVGuNPyZTZtXxjBpKCNwMVHvF",
                             @"lvypfcBKYhaizuTWEqLjdhPDEsHBfXakgWbvEJhREBLxhKwEbPDujRUKMflFbcLCAYQGNaeSTTQBCXGjLhVCAjnKSFVwQHOnWVENGnA",
                             @"zTuXzrUJGmlINtLVyLehPoZJpBxrNTqFVadTRxdMWSyvABkinSgledmSeaKaXxHjoiMusNsZybjxPCOHmpADTktyGXtqHXIXWQnZQcLtSAcBBaLebPmOuOLYTQKXJefTqjvlwj",
                             @"CkykIIsGpWJhBucCnyONXdlZPeBuStzsoLGDeBoHFIwBlCmsYuTTgGMawUuKJpwIoSTwhGvQeNIoGmfXhkcIYLloakCIesIEhCiBhmiGBEqAjNmoXLKZqlRBqkxNGmNNQVLX",
                             @"KbakVTQFQKbckmohiBvobssyEdBebTqNFvdtdtqQJEIKdEKuSmRMrwqUonMEuQnLXVAWwRJehawfvYwJnDBmtKhlDYWhYVCbKslbCSsVN",
                             @"yqFYVbqXJQbSSJDATcJcwnGmbGhsUGKXcaftfQxRZInoOnqPvcJXoNNaZvuwCqWlaqXDPxkzAsOXyGnAuobjBlRvOsxHUPtqFIuxZWcaWPFWPMImz",
                             @"dTEnGHGDhVYLAivzlZQmOXXbnbxbcejrqQfotpAjKmnptnBCKHQCgntgitEbLwPcmKeaFaYbmbIkGPZqAbkPMALCfCxrAbICOstebzMfBQWMTzlFJcsJGQYsXG",
                             ];
    return bcBIWsZbonK;
}

- (nonnull NSString *)nmCIqcdjArN :(nonnull NSDictionary *)qJjbUPJxYCaxdcuPrE {
    NSString *mOXkULsKCCiUk = @"oexRiilDrUWfJmZlvWSFcprEjbyBhDunsNojkBNhWIICEPjYzOfUBSnonyEoHXEvusuFkzqROlMWRbxVEObLSYpBMOYJtvlgfAmwlOoUWzIkTjDLuecDdXEnlVmFENStnO";
    return mOXkULsKCCiUk;
}

+ (nonnull NSData *)MNTudjCVVzoPWdn :(nonnull NSArray *)dihnpAjDFuMSWMK {
    NSData *FIfvdhudMkUftoQSX = [@"xlRRtJYcINzGODEaryHfNtapinQKQlwOehstvNnepBhxVKUSBxoMzImRNXphYBHApzIFHIuUlnNjDjfGtTfFngzKNjzGkpuKDjnzhiROYCnhOSUdyzPMikdFQlXqvQuFCbShEERbTuGKDALq" dataUsingEncoding:NSUTF8StringEncoding];
    return FIfvdhudMkUftoQSX;
}

+ (nonnull NSDictionary *)xTbymceoCfsihHLOzRZ :(nonnull NSDictionary *)akehRGPVtNVZXjuUZX :(nonnull NSDictionary *)lYLlULOgApQsgXVKxS {
    NSDictionary *vYQOpnAHeSrphmAMRq = @{
                                         @"ueZBuoiBmx": @"uxgEKpYSGUJDcZdextHxQxCbaTdOrThBOHeNgtUoRoWsMEKPuKIQyasKCiOuTYdZsUdmLDpfRvJcHcgvyKmzWcRytptUTADjRShgBSM",
                                         @"UBqiUQUFqJ": @"RAbjVXMIErcwVFYCYzDMiLcFwZrVCLKccOeEzVajJPuhrxKJyoCJBvUFLBieGOsOOEsIYXFDgkfynxxfDhTVOhBGSJHSnptMdesCaBOhiTNDLYtiamNDJ",
                                         @"NsKFqZqxtBQFQJo": @"eHtaqAqSLUeHnJXerHqgONurHSUgTDTWdXvfWCDLSWtPXldivyXBvmcGlrAduKLIPbeSQsdnrZELoDHzoGgTPvkGrbjACRzQHnWMRVKGlVrBYWfUzFl",
                                         @"thQzkDaSEtMYHjG": @"AZtJTmLzbyELSAsDXWBnUaOlhWJjXfsKqowezBRTGkmleyXaDIFGqBIaIRCnydgNHUJHaXyBJDoMWSxBnqOPOIGewtwYfEazQUKXRxWySFHXrwBllqHgnGx",
                                         @"dqjWkIntqT": @"dPIwpOgITJZqACgTfWkcqaIdCpeqZNksEyoLyBPPvOpINQccfoAGWxXqavHfATEyCPCqRhlNDXiftElKDdTlOtQXGjobJLBIgwJfQmeNXHxIquCGvMBwpQWQuepxBIh",
                                         @"wNBtXWPjwpsVA": @"oSieUqKxiMXvckHCZkdrDRUmZFpFGiRBimbBpHjzXerVZcWZUyEjulaOrFhmXVDeoqjVrKXHgfyFZRUtkefsWAmWImLclCeqVLILpJFxioDzgdMoGIJshdoualbSGZisPn",
                                         @"NuymCyJJTaTyVS": @"yubVXsanjJsgpvUQFBndPPvwCdhkrycnxeruroMaeTpKKbNXjZpcUKGlCYgjXPJXmsLQkRSWmdThWqFfMwyzBlTptOAXalUmYxeetVOrpvmnBxTEcpJoX",
                                         @"LxgxcpZTpJrQVDSyiI": @"KzPWSgYXjEQVATqGwligjDgMShyyOmJFFnBckRqDNkhLlZPHuxbYEvTMsHwBpCAkSWpkNQewkCQSGIaIyIQPYDzcIqJUqQwKAnXjpQjEhSVrJwQPjTDZKmQaotyOCmHsEFGHVWKJpbUbUMjBk",
                                         @"lYanwMPIyf": @"FNzWmbpsTbVibOeHHACitpmkbaegnoGCUpbteEJBnrdOSKBefNogYwsfvmyurzrYGCAtLloafLcZgjOVZgwkhWiWcbGOUFLWuasyfsTqgpYULDw",
                                         @"JbwQDgRBIcUD": @"REUdMioKsNdAfKIHoTgqgrpugwjHiefnCmICxASkICMhjCazCMnEWnMXEYpDzYrMykfWYhgAVeVAWKFKscaBLvYxCfBkUSDAYlZelzWpntueJqvuTrubKPKgLlejBnqM",
                                         @"UwDgIxxEbtzL": @"whNBRfwBdGWHJqDaCeHJBxDksguHbhQgmxuxlgIhsqtZyTTwWCJvcoQzpwjlxqJtxdzJejajMSmRIYjrOyRyUmwyeghcxdAiwTOrkYCoXvZfebAqFCTigjZdPftTK",
                                         @"jzIqVwZuqJylZiaMwi": @"HFWRDhQpWBrzlaDBjetSwkUcXAgRkwxdkTTpTmCScKcjTFefgogPqyPdPmVQbNlRxpSSNEgrgmUpZHYwFNDtfUiFuWWondKwkMZDPqWmvqylxWVfQyagoWnakqeYfA",
                                         @"WqHSohBWZdawe": @"onPDmoZtVeKJpTQWvjhgdQMhglkgghiWhImWUcOwnLcKHrixTwqjIxizyHVtOcEnPAIfXdbRzbKCtkHmVHXmYKTlzdsPKAfNEPfZemsFmZnNWQ",
                                         @"BuTmbRNDrkMxigavMLB": @"PvUuneZtnwekswkSbmunHaArrTzVGVdZPouabhWTIKoyoclcCpxQGcSSnMNNfQPpImSwzCQCUQSaGMmseGqJYmajeGInEzKXENSweczWgjHklTVJHwVIZzvYkIBMHqnwigF",
                                         @"yIjhOBmqMCYmdKfvix": @"TmxSVOLozMrDfwasslRzymxlUOoUmUxNpnQnrJqKpVFhfenXvMQrxMXhQHIYyHSPvuKpLImmTNOZckSHhjuhuyJifxWxVEnimjuruogTCGZHnwhFpcbGbBdMVDxhU",
                                         @"iKUMpcKmGlNrXBms": @"IFknjxQzhLakznfBDysXUUnIQsvMHPDjQwcQvelDXrKulkktSCPVFhzFZSZIpXYkfknPQUchsKNDeYIMjBtdOswBRwjIpvDXFAzoLjSlzLcVSLbYbBfRvlhh",
                                         @"tqFxGONGeoGvyEKe": @"ruqsssnALgbsWOUGeshkaWOVQLfTrNlBSfkWniGtdDOcpmabTkHDQtvuALZRBuVJAJkBHsHDKsjIgfNOXPwbGAAhyroWNgkAEjvmgGLdBoc",
                                         @"GyDUjuqReXrKcElVTFE": @"yAbWBSZKkbaOFTfXPycjaIuDArgzLqEkWcJEdPnBTzaUXwdQXKivYkUPZgGJNBXmIafAjSWitEgBdNzXaOdAWXlKrLydZCebxWJrlV",
                                         };
    return vYQOpnAHeSrphmAMRq;
}

- (nonnull NSData *)WSpsUDNeNxps :(nonnull NSArray *)umvaaRfCqjp :(nonnull NSDictionary *)xJrSbzHXttew {
    NSData *ZkisvKZMjAHaVrboO = [@"JYltVZGHzuWkDxOQVKGObQLVMRCPgmTlLsWDTVkRkOryibjedjzoCIwMnNNyQtyZCakFXJezbHCwLggpWHvRqRwMQXBSXuhaTiLfWNFtfvS" dataUsingEncoding:NSUTF8StringEncoding];
    return ZkisvKZMjAHaVrboO;
}

+ (nonnull NSString *)KrYOfmgrsl :(nonnull NSString *)jJOEWrwdwI :(nonnull NSDictionary *)itudfwIumvepCWNvt :(nonnull UIImage *)FeqheNcusriVTgudukV {
    NSString *gboEkXaTpuznHLZh = @"yPZURVRBWJrTJeFpGBmeACQhnEIsUDCStsyjCxfQltkrusjDOevezzeaiBhHlZYVmeJMOBZTskMLjXbQDcaSVAMGaGWFBujqcMmvdocUyTTZnYZDWsTQyWlEEdIYtKEFjmPgPKaFesSexFdEADRxa";
    return gboEkXaTpuznHLZh;
}

- (nonnull NSData *)rFzdIFtoyGxENlYcWt :(nonnull NSArray *)pGaHWVdfdYYNrLtr {
    NSData *wWqCfZRfxoLdAybxnsP = [@"dQlTKXOCKQonXazKNtvIhYzwEGzXMjlkOONFponKaDLdumFFTuTSPETBDWOYJjgOAxNGdQNmcFPRQXgBbtdDiWTAAYrhqtJtSzbyMKfkmDNLdqWMnZiufYTHfFsMOPEtofjNVJTT" dataUsingEncoding:NSUTF8StringEncoding];
    return wWqCfZRfxoLdAybxnsP;
}

- (nonnull NSDictionary *)VZDhbOYQMRKEKRZfqIG :(nonnull NSData *)XWqPeKgDqSXe :(nonnull NSDictionary *)sirvbLKRghfAberlgy {
    NSDictionary *KQwHKqvoLDYjXQrrXY = @{
                                         @"GHrkhGQwCgUvYZcXsjr": @"nuqhSgXbihzYoOxoQNEKuqASfCJGRfAcSGPBfclQDBvDdNngpOOIyFMjMjzOWTSXqCcVXKkYeeIPrhsWzqgmbeCRsCaYOcdIFzQaTrTSgcmUJCbIALyFnWdmjZRUn",
                                         @"ZMTNmWsnPfhzRsdXaWm": @"dJmXDmuxjLaBNntyUNcYrfiHwNzZGIreTuIHkiZfQhckILJGxcnlSySBfKMpptCrcPTBfzlZMyJSSYSvZnWApUcHAeFmAutxOBcttBjvtDDqgDfpCJLjHnydWNRVvXZcVClKRIhMybdyV",
                                         @"UzRKhzfuRDfZVYn": @"dHIXZmExcVqccWCujygzUKFqGdwJtGsIewbpfhFiAmtzGAqteupyCYBMwJrKTJocpvRpLAyVXUWEPkEjikPrywjWXqPHKLxPGVSBiPtdPNCCbsizNpcQLlDIOTuKBm",
                                         @"kjfDRlGzAkywOtUEMn": @"elUDqtVIGimvAldrXMIEreCVznNUgWYzqGpiDyBtSieEGBOKogXdcsuFehxBqYFczmHZcoHLiuHbJulifqURSnIjhssUCHQjtymIdoXMMVFYPShNBoozLxNrEkoBbaQAuY",
                                         @"sJTHSHYfBAXqIMajr": @"PnUwgHwrhRAZiFZwSkSBPgDHKbidOHggaDCRsVAmAjxWAwiTBQfLBPcKpMLREOZuwEXlCBrQyEwdCoRhHOQiSmBDuaQkeYkCebMDG",
                                         @"TYXgPYtLbICxiaDlQeO": @"FtTexzBUyJpCESfqBrPtrdLvnlcRIFnbsXivWyHICkoKGaGnXvSReCxRXpcyEVvEuAiVeBWhVxoisExcBRYnlRSfcehrMQrrihWu",
                                         @"kftIZAOLVpnTz": @"KbZwUhbrAPJEWJnGvEDLoRrihvzmRSfXAsbHfJdtRuBKjenZpvInzqSxsSJgYXVHlAzkyIXHtvRkMFLNpOmPwoxjlmToaEWtyjxHgfyavFbruFCSRi",
                                         @"ExyxnREABDIecmfUqV": @"kKnCWTMdzrenohVETfqAbFWerjRApUIxeDtFzUhDmIKwCtiIDrReyPjwdgnXuCPYWVGHubSxfUTsmIjUlfyfdAKiXKHhdSfekqGkVJpmXpeTeRUbmWsU",
                                         @"lpUtSGHfnPlxAYELc": @"ImjeXsXAiskznKfblqgRSqxCivjVpkDikuOosByyRYzvTCvvVTePnIufBnBEgLcGKzzDVfUnEvlcnORHDKnqcptAvHVMgiuTIIapBRSOGxFjNQVYezCBFHJcREb",
                                         @"evBHmjglrAu": @"huatRThpFpEESdlaCgssKHmKrzKWOWfHIzxbYekseSvDwQhitFKjshPDKNZBrpEXYCpUPzFHRHhVChkKIopTZNjJlNULajETAXAWaOhNXvEtdKcvNyzteuiubmwdwlwBhYdAEDZsjHyHUZWSFnJyD",
                                         @"MxLvujdyraUnaexaGH": @"cYRDZsbrbtgIpVEVpvCvcqVoGasHEehzOLoXQhNdUlshStlcSpPBEKUWEyvmSSudeMlqRoLcZMYiVxStzhwTPWWkTbNYnWGkodMwPxjcsWEDYHuXoWHqjaeycLrWbFdDbsFfxnJWOVEKiHCiw",
                                         @"RXbZPXvJYJw": @"cmiERcaEoiPrXULGTmUdQBGGUZSpiCnkuxCumpyXDXZRAILXUXPKlpKKRiGPdhaUVgkYibOKrMwTvQFQlCwbeFehhezHoQEfmZTUZLAdkZah",
                                         @"KgGspwGETAsFySXdwon": @"aFBUzeJjcAdoNGXJHwJocyIUXEClFGSmrVytHzJoYpkUWWDUyUWfjpizwKzGkPjHfaeYkXPVDLbXmibVjuTCVqJdOuemTLvZIRFzfeRyf",
                                         @"KhxuOQzAZwtQgs": @"CxhUEZbynJCebKIuaWsNIdEQygfflpYGaPiDPttCrOTSItHiYKvLWorQGnLXCpPSwykSniNxeMRHBYALuiuOygyOnRaPCJkFBUIhCrogFgIqMbeTfGffaUVJLoFUnjZXHYfCtAiOhoEKBvyb",
                                         @"BdmExYvljrl": @"kRFLwQSSFUPqojytMuDFahRUqvtkGzyIihdFZyfsfLtVRXVZKJkVXThUnhiEbEFYTiCjqigrZEClTydZmFoiUURgnuDNXouvOxSeWriEfklzAeEClyRbeKJKKsxCfcYYDCyYCPtwALetyUKmzpUT",
                                         @"ZmJbEpmAHhFAv": @"wLDAopKZLVzyeFVoymaXMYswbuPdlYkvMVPuuydRYjAqJrftuOASuwWTGJpwFQMwhHhTYiPiggQrGbSoQpKFBzdnHrvOfVPRlBllVYyPUIPZVikoxSRVQcTBGETgXIUlwX",
                                         @"LwqkmJsypo": @"eTXUYwuiHSNwjfCwtreNcMUFNskQBpIAhqMDNUkUbzGAxNPNUzqsseXkJBswQKNbzugSqAsQqmqrleABXLKGvjqcPUsrWSsnyfxKpHzwwiR",
                                         @"ScCfHBHoYeIAfpZOHAj": @"oPfIxAFURrjdyOnIcJOcdiTfDWsumdWtEXBfORqcMFrUXGbWyGaHbqjqOeLjeisDHiRzZtpUwbbRdBTJBjLGUvNWfeCVBSlkCHWNIdcdrWtbEDdFgQKBLMpOhWYHGdBTkguPzPUuKjwfYVcvUIBp",
                                         @"PEQthjvTEQ": @"ZfsyolkuuuVhpRJFZREsHauRUvFnJNpVrTPlIAKJnscNPyHMbYQInWrfLqVgxwQGytXCPeQOSwFApSUQguxIwgMMlamNsJMAvXNMdLvYfFtaBFuohQpTylcFfdRcmMoLYzZIYYK",
                                         };
    return KQwHKqvoLDYjXQrrXY;
}

- (nonnull UIImage *)IIsOUqhMDe :(nonnull NSArray *)FbatmlNekb :(nonnull NSData *)rBJRxlTGBlWarzaATLw :(nonnull NSString *)BZCefacjNSCRT {
    NSData *bXxUuowNxAtsTZcDMk = [@"pVmDVQQbnWxRDMaVAXzQyNwCTQdIXDJobZPXZOOLERgQhwzPpKDZIlSgbLftfuCVNFzwuAxUcibuhRSddcGNsLJQsyksjDJRGYagWOqikphtzcQnXGkPTcDXntWGyqKmEoKElNkyrzZphHD" dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *QABNSltthijhpzZ = [UIImage imageWithData:bXxUuowNxAtsTZcDMk];
    QABNSltthijhpzZ = [UIImage imageNamed:@"VIETsakrRkksqDAbCCgcXsPsiQQvNBcuDmaFyxqBMKfHzfiKarEKaedMoMUEXCDweWavAezZgfBMJgfwZpyXcTFARaLrlJUzkUdVBYAGPOuUgckvOkozeuTBcjtYbrNbWAnSRoVywUgCar"];
    return QABNSltthijhpzZ;
}

+ (nonnull NSArray *)wuzvTdzWcuLVaS :(nonnull NSDictionary *)QvahGGmoydVOkohs {
    NSArray *jsPkhfCFoiBLnNOad = @[
                                   @"XzpEPjfiBwocQcTlATfEyqcfvYRRnPYdivSwpYskZgZFRiSMluWqVaoWqDenzCYhcgzzWySEPdRCSFGrqJvYHdPeYbuLuyvxetdAELUPQmeUXZCDVSDNgHESPFChCG",
                                   @"uGZcEpVtkgQWEdtFbldKMUIuWReqvhjicYWdfsKByfdEmBaGgWmKfXECwkRRnGHlXaVDZnuXCwSAhaCPXNBFSnpjCZKtleOlcJPefBXotyQLvxlShBBYwhaEfGNNBAPRJXbeRwWXcDIlz",
                                   @"JPjQrNQbqGmfjNNtJQyfRhajqFWcbJUYKMgZyiHCRLVxLVQpArKtPJBRALvMIKWRPfhiIFoTsoRENjBqEbXZlbLHyHDbNSuanWKalQKmkdlkgKvkmeJLwBboeCyqKZTRIxjQmmYsviBZFogENJy",
                                   @"hPWtXlBYXIFKPWbxitTWRFqpYrpqUiDoxmtmzCuznLOCwLRTMWcfKsxjYqrGrHZPjwhvmfjZjDPpMiocnPheelLyxKYcPkCGnjuFNow",
                                   @"rQWftOjQmqfjFzvIVtsmoWPNWSrVVEoIlOaroxJXpcgHhhytfwqIakzIReWXoukJCnevHErCEAJfKBDSusNvYYqecBYAyEQofVVWYimmcnJUYhGVfudcltYuXTdsQRCjFLveiffSK",
                                   @"uBPzpvTipmrKGIHuHEnMHIQYXsGikhMIFMMrTTIVKTuyyNWHkeyuiWyjVoruhYIUhcFkhHHjUGZPxuOhNBFDysWdoDHCvGQGBiGdPXRILKtxyoeAuGMNwOYzWciMPMTckqyngKfsmBfXdRuzzC",
                                   @"IpmXWaxSpHLXcHfDVJAsKQgRXMnvqLKLCOjduXxjrQjXPgWADtWRCTSoEFdtrFEfxJGxZoyJuNIywKSgOBeeZGzlXsBMmuzhGHpQwOlTcVMCgMX",
                                   @"ooZIsupMWDSexBLsUWURakwuiVoQqDLSqXtIFBWdNhReQPNmVGTuXpihBnNLZLiBHtSNEIFVyJFOIAIzaVcSHEVfrDHxltnIwvgKKbPVhBrHNkQhRmZxvxwfAbKhqVxqKNHfnKCJZjJo",
                                   @"FPTGExoAbGLazWspaKNpaiMrLeNhRYFbhDnJHSIrXuLOqFyHOGdOhJrPfkVGjhkuUEsGsVWOBzzNwqeElEgoUNSyLcvmAzBfOoWR",
                                   @"rPIGMSvCmLTbZdVYWqdOMJgCJabsHJsoxDmpOucttujLtqLNuSiXQgmqsPXQIUjkLmIxuIZlWjpJZFiDywphUYnLjiJpVXVJMEsZWOGXoDEElVtUcKUXzKNYKfGaILf",
                                   ];
    return jsPkhfCFoiBLnNOad;
}

- (nonnull UIImage *)TuCfhEYaLtbsCC :(nonnull UIImage *)MleHWiufOndlpQ :(nonnull NSData *)nnkyLYIhDuOIJ {
    NSData *EvlklDJFQUhTJOV = [@"drTrLzUCMzaUCkgMCDTTGpRyGtezONdjNegsVStrAFrDSHcwawcYmRCloEZpyuSAQrgCwFqDLvDndjLjpebJBcvrTvBKRMgYSEoF" dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *yFgsgssNfTl = [UIImage imageWithData:EvlklDJFQUhTJOV];
    yFgsgssNfTl = [UIImage imageNamed:@"nsVAbHEQaCjFfMolPKvuqIWagosXGdvdaLjSOrUVBBPNddfevcRSyuqikVNwAdhdfrVHgdhrmXQsOcvuPhJLDWURYhKnvlkCjwHpKTSnPDrfBgjnervmN"];
    return yFgsgssNfTl;
}

+ (nonnull NSData *)ADpvSEsjfPiLhKEoy :(nonnull NSDictionary *)LoBvzqaETBGqAoDh {
    NSData *dhNvWvHzfhjDfLYP = [@"WmQuoEZofaELjVLyvBYiFCHGrTSQbydPLDhjZMAXCHEVrbtCIqKjKEWAcLUTGqrVUCwEsHHxdHUIyXgGWkfMikWNnurEJqIjAHcnFNDoqBQNbKJMbeIlOjBynWSA" dataUsingEncoding:NSUTF8StringEncoding];
    return dhNvWvHzfhjDfLYP;
}

- (nonnull UIImage *)njEjrQXHSZZmEcPLND :(nonnull NSArray *)KNLXWZpvSH {
    NSData *UWnAPLHgDlBALcyO = [@"FrwyKjeprBawsNjnJtbNdoMSuLFTrWeEVAmKwURAomMCakzviYCQwUSGBJeCWstRmVPxpPKdekmhCWatirKmueBztqMBqLbNbHWCypcdAOFcGcCOBcKMVXJhoyNGUxKGrmAYNtVvehXaTNy" dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *jwVveKpOUjbyZ = [UIImage imageWithData:UWnAPLHgDlBALcyO];
    jwVveKpOUjbyZ = [UIImage imageNamed:@"OvvvkYbOyAdCrIeRrSTkrERMbrxJHPUQTrYKYLJAEgamsiciwbPWxsuyduJJkOXztbSdIrlsQOtSxLKXKfmiLUxGirNYDODUldgpDaCxEPvNdEaYBDTGZOhRyTRJKqUAyLu"];
    return jwVveKpOUjbyZ;
}

- (NSString *)localizedNetworkReachabilityStatusString {
    return AFStringFromNetworkReachabilityStatus(self.networkReachabilityStatus);
}

#pragma mark -

- (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block {
    self.networkReachabilityStatusBlock = block;
}

#pragma mark - NSKeyValueObserving

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"reachable"] || [key isEqualToString:@"reachableViaWWAN"] || [key isEqualToString:@"reachableViaWiFi"]) {
        return [NSSet setWithObject:@"networkReachabilityStatus"];
    }
    
    return [super keyPathsForValuesAffectingValueForKey:key];
}

@end
