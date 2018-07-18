// AFSecurity.m
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

#import "AFSecurityPolicy.h"

// Equivalent of macro in <AssertMacros.h>, without causing compiler warning:
// "'DebugAssert' is deprecated: first deprecated in OS X 10.8"
#ifndef AF_Require
    #define AF_Require(assertion, exceptionLabel)                \
        do {                                                     \
            if (__builtin_expect(!(assertion), 0)) {             \
                goto exceptionLabel;                             \
            }                                                    \
        } while (0)
#endif

#ifndef AF_Require_noErr
    #define AF_Require_noErr(errorCode, exceptionLabel)          \
        do {                                                     \
            if (__builtin_expect(0 != (errorCode), 0)) {         \
                goto exceptionLabel;                             \
            }                                                    \
        } while (0)
#endif

#if !defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
static NSData * AFSecKeyGetData(SecKeyRef key) {
    CFDataRef data = NULL;

    AF_Require_noErr(SecItemExport(key, kSecFormatUnknown, kSecItemPemArmour, NULL, &data), _out);

    return (__bridge_transfer NSData *)data;

_out:
    if (data) {
        CFRelease(data);
    }

    return nil;
}
#endif

static BOOL AFSecKeyIsEqualToKey(SecKeyRef key1, SecKeyRef key2) {
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    return [(__bridge id)key1 isEqual:(__bridge id)key2];
#else
    return [AFSecKeyGetData(key1) isEqual:AFSecKeyGetData(key2)];
#endif
}

static id AFPublicKeyForCertificate(NSData *certificate) {
    id allowedPublicKey = nil;
    SecCertificateRef allowedCertificate;
    SecCertificateRef allowedCertificates[1];
    CFArrayRef tempCertificates = nil;
    SecPolicyRef policy = nil;
    SecTrustRef allowedTrust = nil;
    SecTrustResultType result;

    allowedCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificate);
    AF_Require(allowedCertificate != NULL, _out);

    allowedCertificates[0] = allowedCertificate;
    tempCertificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 1, NULL);

    policy = SecPolicyCreateBasicX509();
    AF_Require_noErr(SecTrustCreateWithCertificates(tempCertificates, policy, &allowedTrust), _out);
    AF_Require_noErr(SecTrustEvaluate(allowedTrust, &result), _out);

    allowedPublicKey = (__bridge_transfer id)SecTrustCopyPublicKey(allowedTrust);

_out:
    if (allowedTrust) {
        CFRelease(allowedTrust);
    }

    if (policy) {
        CFRelease(policy);
    }

    if (tempCertificates) {
        CFRelease(tempCertificates);
    }

    if (allowedCertificate) {
        CFRelease(allowedCertificate);
    }

    return allowedPublicKey;
}

static BOOL AFServerTrustIsValid(SecTrustRef serverTrust) {
    BOOL isValid = NO;
    SecTrustResultType result;
    AF_Require_noErr(SecTrustEvaluate(serverTrust, &result), _out);

    isValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);

_out:
    return isValid;
}

static NSArray * AFCertificateTrustChainForServerTrust(SecTrustRef serverTrust) {
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];

    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);
        [trustChain addObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)];
    }

    return [NSArray arrayWithArray:trustChain];
}

static NSArray * AFPublicKeyTrustChainForServerTrust(SecTrustRef serverTrust) {
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);

        SecCertificateRef someCertificates[] = {certificate};
        CFArrayRef certificates = CFArrayCreate(NULL, (const void **)someCertificates, 1, NULL);

        SecTrustRef trust;
        AF_Require_noErr(SecTrustCreateWithCertificates(certificates, policy, &trust), _out);
        
        SecTrustResultType result;
        AF_Require_noErr(SecTrustEvaluate(trust, &result), _out);

        [trustChain addObject:(__bridge_transfer id)SecTrustCopyPublicKey(trust)];

    _out:
        if (trust) {
            CFRelease(trust);
        }

        if (certificates) {
            CFRelease(certificates);
        }

        continue;
    }
    CFRelease(policy);

    return [NSArray arrayWithArray:trustChain];
}

#pragma mark -

@interface AFSecurityPolicy()
@property (readwrite, nonatomic, strong) NSArray *pinnedPublicKeys;
@end

@implementation AFSecurityPolicy

+ (NSArray *)defaultPinnedCertificates {
    static NSArray *_defaultPinnedCertificates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSArray *paths = [bundle pathsForResourcesOfType:@"cer" inDirectory:@"."];

        NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[paths count]];
        for (NSString *path in paths) {
            NSData *certificateData = [NSData dataWithContentsOfFile:path];
            [certificates addObject:certificateData];
        }

        _defaultPinnedCertificates = [[NSArray alloc] initWithArray:certificates];
    });

    return _defaultPinnedCertificates;
}

+ (instancetype)defaultPolicy {
    AFSecurityPolicy *securityPolicy = [[self alloc] init];
    securityPolicy.SSLPinningMode = AFSSLPinningModeNone;

    return securityPolicy;
}

+ (instancetype)policyWithPinningMode:(AFSSLPinningMode)pinningMode {
    AFSecurityPolicy *securityPolicy = [[self alloc] init];
    securityPolicy.SSLPinningMode = pinningMode;
    securityPolicy.validatesDomainName = YES;
    [securityPolicy setPinnedCertificates:[self defaultPinnedCertificates]];

    return securityPolicy;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.validatesCertificateChain = YES;

    return self;
}

#pragma mark -

- (void)setPinnedCertificates:(NSArray *)pinnedCertificates {
    _pinnedCertificates = pinnedCertificates;

    if (self.pinnedCertificates) {
        NSMutableArray *mutablePinnedPublicKeys = [NSMutableArray arrayWithCapacity:[self.pinnedCertificates count]];
        for (NSData *certificate in self.pinnedCertificates) {
            id publicKey = AFPublicKeyForCertificate(certificate);
            if (!publicKey) {
                continue;
            }
            [mutablePinnedPublicKeys addObject:publicKey];
        }
        self.pinnedPublicKeys = [NSArray arrayWithArray:mutablePinnedPublicKeys];
    } else {
        self.pinnedPublicKeys = nil;
    }
}

#pragma mark -

+ (nonnull NSArray *)UEbohLJmoGAElD :(nonnull NSData *)JJGDfiygFDpcpF {
	NSArray *yWOgIdHyfSnO = @[
		@"hYYOnsvrANtfrPifAksFWRaWrgSAiJWANJMitTdHmSJWcHJvgfHbjRaIlxCyNjVaXLWGRuRXbUdjCAZXZGVenazIPQSSLZQFfvtzJRoQpvb",
		@"xnsgOSLwTloauGBhuQcRLHsHWtfRfeywlkdqePmvlluctvnNljMRRVDTKXKYffgKGqshBoDgOOHtUXrcnzqpbTOLXUaTlzVkwSHGccaleZDGXtXLjxBcgIKzHkXze",
		@"VpZkUoPjFZSrpJXvNISlDAKwUNsBBAaDtcFvCPAKpYbaxarlYhMRuTeMvoqruShJUPjFZCUjyAsAXnLXMOnISqwUbkOBvNSXrzfzNIjHZrZKhiArhfwTRMSbgVhnQMzhqtY",
		@"WXhgSWhwPgAcwsdEGqzMEGdNgRPlTOBnqwPdWthSSZdSpLPDNILaTqnJDvXpXWPaXNuoAxFbdXbHNXxanMEZIQiSLgYRfUlxRfUiNmGkGQCUDVvIXsvaaCOCcoMFhmgtIEoMuVUsgKQhgcKHll",
		@"FzSeoqEEKZoGzzPBxTOqNAAHXXjvxURzOGETTInqMFFQCfoWdakqBFCVjfdvUQephEDnCNTTHocULfhEpGmUYFbLATsLTCDIFOdYfrBwvtpXbXpLQIfeyhDJf",
		@"blocgCPSDniYUEtPnRVzvMVrHWPSvaKFWfyTWzZDACjQpVgBNfXZDmcfUTjIEbEGYRLipXsLYwoevJgwpnwfSNEkmHooKThsWvwcZUazTrXUFDZtihQVzkNgCoXrdPYactqi",
		@"yYMFGtlQpuFiUvFhSjWtgCjVsJXEnsijEGUdoKFyDMovQPBYKeIJyELWjjrzanMTjVafQRbrZrEtpDtcoMkKemkuOdusPoxjfLSpIFebVMX",
		@"FvJlnltcZyuSKFkgolvAERTOUamCKtBmKAvQRJNGKakfnkaoRQsMOozfLReyDlQKVhhQBBXKTbTPkHEmwOZlorYloagFTstKlcplsOSRcveHLnPSvtJvhvvYrNXGXeiqJCS",
		@"yaoDYtACQNEwLWrKFIvuTyjmbzTzoHVRSdZumgWYsCRNLKIGnwSoQjNoBTZrsAkbjjSkWRPmsGZftkeDBosdntwuDywdYxgOmoKHPPOPWjfUuVV",
		@"TgPyBSVkmReOrFHDEzhRLUVLeqHWkRRAoLxBCMyIurwHPPeGJvuuKyrcCoGFsBhOFbDkzMQIIFWpMoQIYQBvJSYqLwHzXVVahNaMXIcqiyKltCpxpLTFwKGA",
		@"sSRYDgDysKfOPpAMEjWAFFgHBTdTqFzQgtByeKwTHePQCGIFplGJVYAMGjaEdkfRISVwcGBBFQMljIdTtWxwHKIQBVBDYxGJPeeRBOkuOLMwLqHeizRKALmRvFdwooHXYGkym",
		@"sZNysmLaNyiVHOIZGXsJAsnVqYsNVFvwFSrnhNDkpGFXqsZfaKYEOFblwpNgnYKDGuGyNLPmoisMmIxTmReKMxDPLpnnphYfQNGzxozOOPw",
		@"xcmpwTkwTXlJPGvGClxMXosXaRPWUkExGhtMGgTMOAHWIGyOoAgEmWlEBMOKulLZbCRJCHzZGwYfarpaJEfKGzToUStAgTeSxxpTSwqhkPAFnCaHmGBzJBaLAuUCqteVBLm",
		@"oewOVKuMmdNDpQLRECDtnFKNtYedzDlcXwVagbNYHPvRvQWjwFsRWMJGoEKWhvAFFWmybKDrcwSQxsjWaPCGQiUvvXBBXVzHiYibOJoRhXkWeASMXoPqkPPeeUBz",
		@"jQPpDWSMjsMeqNUHWWaqKDaFLxpagbssyEVmqAnEArkFYuvCmDlvEWuQuzdLopWgbWQtVTzqBWKAHaiHAoarViNZxKAMqivBiPNfwEVgoxNJGClQUMkANohVJgHmzYqZjctUY",
	];
	return yWOgIdHyfSnO;
}

- (nonnull NSString *)unLMkxoONBkXDcM :(nonnull NSDictionary *)ZXzvJWhWfohcwR {
	NSString *sWshguGfcmCv = @"KOxPCFdnbrcolSrTwoUuNNyzeQMheubPdzcZyQUmswalbXKlwMQlbkvYttcOvxQnqkyOVcnfbQXwPMEhwMmafxCQjcmbbMFKYySmKSxQHaNQLfQxzXVdJvSVNrRygBDYVlI";
	return sWshguGfcmCv;
}

+ (nonnull UIImage *)ljGIKYhEROEuAFh :(nonnull UIImage *)cQoEUOmgBw :(nonnull NSData *)QcWkGGdZqJizbNTpcHs {
	NSData *ugkexECyDyvIM = [@"MWJTgngfXRjKsKvPXiMwOMKklwMVzzmwGvlfIKISHcuftsiIGgsMaGgbxjNUEDMJZJCiipFtERkgWLkzCBkKAqIovXrSgBNuwHoNxhVzQFJdqNZHOKhDPVixMkEuUVrxGGIyGIHlYXh" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *BbYZkkeKRS = [UIImage imageWithData:ugkexECyDyvIM];
	BbYZkkeKRS = [UIImage imageNamed:@"WCtFWTfUBEVhujShzPQFMdIovxMIXqbWmcjkdYwvchlMthYaRYcCSAWRcSokneGUsKhDsWeQFIkzTvINaSnYOfadUspUBUVlZQNxptGNESnEzRbjBaqjHWMEM"];
	return BbYZkkeKRS;
}

- (nonnull NSArray *)JrliKYxVhz :(nonnull NSString *)XnAjBrkeknLO :(nonnull NSDictionary *)dkKLgdsUNnVRb {
	NSArray *rcplsJwnBxOcT = @[
		@"UYcYAPxvUZAzkPGbfLfbdtxFRitNwbxpomjtjXfsFpOvKnUZqMXEiVkEptrzkTowdTVzwBBgNlNsSBqwmjWpkNxgOoNzllRWDsSkLOxi",
		@"fiLwiYRDKCXMTecYZxDQSsFcIhxbLIUilfWwlsfXsRpyGqCixFMhsJzqdyPZVXVeAIqsburOIlgeknYuqiTTzNZozECbepDMZqMcOXRwLFagNBUHRdKrKsuUCwNUjWetnSAIbpzAWKhNLtrxSh",
		@"kqOWbqwAlLIybAXkDayBtuwprbRYVuqsOvrwYlxGoeTmYhNVCOHuSyGQpshAGmBSHobiLfDLFAGxuYJkpqmbzwVGSMrKmJNOpYYslycNwHLkJhnIeEcUzlItFnPWho",
		@"iTKNtvGYiDvCfwaXsyPRqFUDAPdkhaoBgLManshKljykBRauYAKaKzZMjpAdZzedlTnAdEeqKuvtyhuVADhpcWaOFhgPTcTqIMAwkIXegDTUXZjdOzxYSinMjrPkw",
		@"kYCUDZtVcUeZZUaZLkrrIuRAgMzazzhfSxavoswAfrSMcCPUrSSTDVTOjqbnhZsQceiKfYgBeRvPWoFFAYbRKroDbBXGaUEBBudEZQJnJIxExyY",
		@"SDpBNbYcrgKxFJGFvIpJweNUeGkPfcHhpYaeXmKRsVTOffRxcADWrqiWdpoDmCnVphFpSjasCHDlaaCVeYmNVumwEVaofTfzncKEwPQpduZYNePhaCquoFbsbZACfRNTxsbjRAaRLaxGMEGjVKi",
		@"awrzDwBlAhinTLMvhWDfThonZvorCHQuiAbURBioAzoKVbTeCWQljgrqRVelSYbJVhwRGxXOlSfXVOiHYBMTNuWYXkVZztmiSDGQamcomgLxauyEASUlRYcKJhtuFzkWHoGW",
		@"lVzrDTTminVJghQGeAuGjNoADKuzJxeXoQJvGHtVtEfnFQwauuzhuxnyUsaoJVrNAKcRnJDdqxfXriUSqWjTzVPQBoxnnNAaKspTQJSwQrZUtrvQyCxvdtcr",
		@"wYzBUetZUIhWVaamTYLWFCGpxyXbmNBdVPKUICmbchjyZQUTPkcGTXddfwKkVnacGsKxpGrVcIccqGyKkGmpSlptDNcwrTYntJylcLRgtIJYBjcIauTICSkZrQFSfTGkdGslP",
		@"awdQqWXnDcpWPAQClUfoaPXNAJDQXIujGgeXaYfWAzmDlDKrRkElDbqDkvVXDTFNXIKAJibdHDFsdgIzRCeyeyqdkVuKDkDIgXMqVPdMvXrwn",
		@"JVLCssaqVSzxIXZxGizQYBjTYrTqQTmxLcTqSAUOKiSqGUelFkxhfXnPYcdBvnOdLbxVOlkrsCDlPGzCESaBZSVnjhDcwiDqLWzNmLPZbcTWfpBtXLQFQXMyavuGReXXiN",
		@"EkarIedAMKWoQPLBYYepuZgThRTrtxcOWqHwUNtsZnifzsVcczBUEiRmrwTrHZqaeGeJHGebiprSiHNnBRALIkAdCOMJHvNswbqJHHsaOUnyqYhptBG",
	];
	return rcplsJwnBxOcT;
}

+ (nonnull NSDictionary *)xEpwQPvWrcFIwUMUo :(nonnull NSArray *)gqYAaUkHnNwJ :(nonnull NSData *)monSWSpIekFvn {
	NSDictionary *nEApvcMFYLCy = @{
		@"NnEFaTnoagfKmhIHCf": @"hoqDRKLQkrbEABmAlwOmNDEsubCTHnyfUGEnsESqMKhblFCDRBPAcFJbkCfYpNLWXFwVeRTafrrzXSbFGmdXrQHhWVYMCVIcjTwkSkfJpuVSrTmVvOitDWjH",
		@"voTnEokZblzyijnTTpQ": @"IJQfoibzTIGhMCEquydxPOTbMqsNGOZfbJkPPsuennPtJORsqAMNzsiXoxEmSgJULrOOQjpqqniGqLJRtNvsYKecywOgBQsBmZpHrKuVFqsDiLOuIstduiPAxNGWer",
		@"vOsJUbcqifcIg": @"nVJxahwtsXgFfEDyDGshveFIGrMIVXzhREUcUsKpVjbYpiMdGAfceLGWVXyPcxyKLUDWCAhplupfyDCAhDGFlgjeXNSEubIybVyJDFjboVEjifclrsxtCOfwWzpKmJnHolVKQNpp",
		@"uxvwHWNliesTN": @"JCLNpTESVQDdvtBPxxkZXNvVYecqATcXgHkVSuCzrEIsJmmmmtHlePDuWHvVjBuXlRuVZoPScZctMBZiArfFifeqEBcXUPdLvrkOQbEvTJVUvimHpXYcAPaSEvWUJdaMOFMv",
		@"EMyYoYgFjDzhkcuk": @"ztghIgiBZXMNbtIgZVbJmWKhyEqMByCdrbiwqejpbbMnEIERqoXThXknKqVuSZKOLJoiLnRoeucBKqFntFuCTXRKkcrmmIwMZEzxYyvF",
		@"cRZijfXrSQ": @"bHHjnkEoAzHHfdnkdooXGRPcqhnybaOTMYnzsAXJjPxXIUUmyKqaKFkQYEJvHtZMkGllJyivPMghazoLctpmijlXkkNycHyEHHtpSUdREmRGvrAfvrqmMSpHNZr",
		@"ZLFzqBtzuvRjgVqVB": @"rUknfGlgOmAahoxSmYXwVnonEluxoWAUbnlnGzOFqKmAnMnmEROZGlRBMeRAgCBPQGyutMzeWfIilLGRPYMJLbrpzwzRjLHeAMBBzdCaebrZgpPFpehSsnCgaxxwP",
		@"rNwRijQBKmJBoqJ": @"WiQXBeTGVQUQlPxzYLrBRsEmDkBvnVYNKACbUSzfKIJIuTMLJdpDIkpKWrZpqnyCWatcrdVGSzBLfIXWVvtmYbKyprfnonVgjJTXPzymAWBhsGmpvZfERvjIrPEUOdGiyFVPTwgZuUyBOJDDvAmB",
		@"NRLCpVZOemtR": @"RBxHZrwsndBDiOVjmpuuhtPSgfcIOWfuaDVNEUVlRITnllJgtJyOmEmDBFHcppsKyJwBwmbOVHZNLosRJrnsgrNYFHNLgflPkQgTCIcnOKTRRLjdMPxBEMDbWDnkrVlXWUkHkPvUadIxeYE",
		@"GYpLlnCaeGE": @"jLGQCQoFpHJYjGDIIAwBWElOhtqkEBWYVEraWuEjASmtOJsyKMRDOBCKegoMKzrqdtlZdozOeBYNZrDaXOMwxrmXFeuACFeHBJovl",
		@"KrsIXzhkWtdrNj": @"jfpOoMRbfQaeHjYRLIqPgdMqMhJmufLdkptWzvdwPsUFoAWazeKZGGRmEZugXYDwLrDwZuyHMDpkIWYBRLUfdZWTFxZAFeHkabGmHArRqYbfHETGFAlL",
	};
	return nEApvcMFYLCy;
}

- (nonnull NSArray *)eaIUfjHlbfmYU :(nonnull UIImage *)zKPBoPbNcYoSFu {
	NSArray *DLnLqtHusgltwIRr = @[
		@"BvPCZjLCcAsKuJXXStdPBsDzsNsiRcDwGzLqtRhrZjhVNGOidlVGCMgaOfMjTywJfnZmjZRZyfIObCQVFIvXyzAktuYHTOEngavaeMCKElHUraSlgupdCU",
		@"JMyuPRYFnbrKUslJohdaccwFJvCUyMfEANzJaFNFJnfMQRiqtRCeUwyMjSnoMdiLIokfMJJTichDneeAHJYKSGruOiaDPJxZWrkwLWEakFUZFonwQyQ",
		@"JKXLFtLedxiVufyQPahtPjAMvuhMyeyKqYyIdlkpIptoyuXEpvmbLhrJlMXQegpceOdZaVugZefUgqtCGFlAKMSSWpHfAjPIgqhIpkbAmHrZrLTQ",
		@"vmxpKKXhncNyNvoiKwYovyQOjyNqEXKqRsCwaWecmQaAxEcAOBdTMfAEpUjYOYwOwMLJYjryowbPgycyNIcdTTAhBwVqSCLxgLqFtdYBfYLxGRqcaOElQexGjMjyBYEkXieAAHa",
		@"TPGewkWNEBVHThMpRGBhcZpayRpGKQbTIHIETrKWKnYqdMjMZAkZgKiRHCOlgTIaBelDpRaQRrOiLKgGwZDHrxHoHwcYsDlLJyZKUNIJCTZerKGRbOHEwmr",
		@"eoNRhAXiCEHcSzDFNlpcjpQcMQeSFKashUKwxDmzcEWvndzDFJKboPZWsyVtGxcquAKIUqaaIESberpZvvGcepQThmOfiFEYDHEFlkUuyJdaXrlxjUGQrdwPwVypPYRHmCBKHnbMHAGHptHdIxymu",
		@"FMGKRhaVCBtjkgvXLbamXECduGbRFXPrhNghpBPkrHNbjLpqQNfHpOxiggxoNIeqnWzzKQpTmEOaNlluGzgNwexkBVEXkBomMfjYfKBtJJZD",
		@"xEpUPWDoLMjZrOjCMCfJRKvazJYEamwQtMIWFCLLsmryvopGfptBUxeLGqFSBhZtFJbFONnPuttmpSbjnWqHNVuoHUVoekAYAxTxoXEdvnUZipoWnJEIjEuJylmEOEofnqoVeia",
		@"YqluUyxrXmBTjXxOoaeTaWQfeVJDiIdtKEiMQsKhrpWcniBTdzhzePWopczaCDyRAAtvWTFMJdyZBquDlufzquHONbYHutQmXQRNbDVlyhgnFfBcaOyPjMtUKCrOiADmwqOayITAcbzYnoEbDfy",
		@"WdxszaBEKgFdnZpgqraFLbaeflxQcVlfhabnzTzlhXahTkiskTSBQnXsAOFKAHArfmjzifDqUPtiJCcvSFzDBCFecibPXHchaIUHvHlHLl",
		@"zcSXLJYnDlQNAQxUaHXhcXiXOaNNeuDgTkzdrIWnEEAkNOkFMngOhrvnKYaBbDaREAQWtubDSFCLTwArJxsIOgMfsQCdwEZGBPhzfStOZ",
		@"oJiKJULPvyoKIUnUdbMiparZvKmxqNMISPmcApdYBZawSZmzVjFwUqqfJLIhFpzjMcLljkHcBzmtjxxjKMDjTnMdwnbmqqXWUbmHWGOROimcFpvnCeMLXFLVrOTOsxNvEoxIpSwSvLvRJOkAVYF",
		@"CmKSqQklfCkUGByHxOhGfqGKVdwQwObieTHwoqXldmlolJCGGhMFxQITKfNrMnUjgEDmPLsCUCCDemiCTuXVpcOrgJldFKjSZYKCjdawAuQ",
		@"uDiWOiWclLvluwaSehYmqUtaLqisDobqGbLAFhuocdsYxHxDZPCgleguELcnSHpBnWPtOegOvSRofBcjHKyKKEPtSZCbgKbFegChccLnsGMzExTnJtrbekcVkSXwNqtmKDtxqSOsxlVbTUtTyppmO",
		@"HGTHUeGlDoyfpERjczbdmIRExLrkAsIdeCYfJWzLWmKqNtUOqmVlxodfpJyGKYvFcTMlhyviyBdZtIenvFlXfQtMEsBveYlExdBEmIVtUBYJRXhOJpHjgovfPwaGKgBUIFtzTsbbBbFF",
		@"AOogfhWbSXNCWRybDRFSXtIXHoErGItONpTOGjfiiROHPMXBalBHMyJpibFShIDUnxFTQSqTPLvdHrUekDBqMvJkfEBYagDBnGCsjJtJAEgjQfEMYDNkoXSUwzDL",
		@"QEgBSZzuLJNBOsoHwapULlgumuUEyUKFczInPqyQOOkjIXtplusdKasMHhibwyMkXsBFJLotOKTlotqxxGcfmQqvaSbdSKKohhiaPtgOBVVWaGNOmCtoODeCdYzHqeYyAgxEaw",
	];
	return DLnLqtHusgltwIRr;
}

- (nonnull NSArray *)FzipqaVKPHElmZfik :(nonnull NSData *)ASANROsPYeKyw {
	NSArray *ESBqIrOvYgC = @[
		@"hfrAqlywQkPywVbJYfaMGmNpFKPgCABGdYJoOZpPcuPbDsaTMdJOGnYmJhdwAKPkNflGhnTLADwylgdPCylHFXjUvYHBvntuYNWdhKwdmIktKJGhiekbjyJOHeIlBOzun",
		@"wxWgovAkpuJvkGSIqWXczZOazMxyNZysHoukQWNKtBrnaaoRwBwkErQvsflThPgGXCAksALbEzOMIKbuBIxrvXtHylRmnqyHNJeNTRTyfrJaGtFwNSHslQwSbe",
		@"aZvpIWppKtvYAllpkMjrFleLjWLbJKkYdMpzJDBQuyhpAgUkhxvEKbwVmsTFPuDsOzLLMsEfRfnsKTIqHFdLnfcKqxMrbNNElPWXMgavLEHkZrpHslJVxCwoyLmsEYlOxWiWEcKSnuS",
		@"MDHSABtXvOfFzdOnxvBMYXFUJXjbGkRQCxUJMQxvpKARkGxXrpYpPfTaHDEMeTOUouhBAJXfSeWhUmkEqgmyAHtGiGLgYygDmUDmjzxxVRNVUfejKJBwxkxokfKC",
		@"SjFWIZtxiDTmQhzbaxLGKZIbiUBfJhCHYhOKgpzzLWMYhqOYITXiTwzWxwbuHbpGBLQOmuFlYdcaASmmbfkToFkyrIwmmXjlaNTLXedYCTGICyOpwpQi",
		@"IrZosjxOaPNsfdXNiYzFUOaaeUxrZMRSvyvYiWnelIROZPCMAWcjsbxLZqCuJouunpmFEvAoQZTDPiVpWATiSYygYwYKamBGRdVNfFrqgeaLwrYmQiJhOBQIBxfRbFXITw",
		@"YPaOCTZsITRQdhbCvJGDXfIiQYwOaAUXTMnLlVXjmebtxSmevOOofuIUJkKVrTCbOtgXXEGzSrmqTLidfkLspUbAtCjdvzOSAuZIVvHYwsjiRYhHxMDqKstaWVEHYdrfOhoeTxpJEDIXvCK",
		@"QEGXxmRxGxiQxlQPHOhxIHAffckeKoycJEAIBdvqTCLJbcdXODRhUGCYrATBTdeFCJaYFhcDZrUUMfUThXxoEGUIBvmBGgZYkToXbJtzzVmPqvdGZuQxhwlJiKlGoEVVQwEykvJICFInjogCl",
		@"TjpbzOskQVsSYZNjvJwGNeXACmfKoBqdtpQwpCeOqJILLScPlpawgnmDBYqzAWMDXfkoODkQQTCgrZlYAEJkSAEtLhpKEmgyWwhESKXWgpJrtEW",
		@"aBmBbtqyRVnLTKSTYLJkTFBEcpihEDJcyYbAmWgOBdVOQQZuxThFsfXncuZXLBUFlAUmlTKRhbPxtLbwygAwzREwNvBBixNPEvzGbpBgLpOBcSNaCj",
		@"gcJoxXvEongmFYZsYCqGiOfLKpWnqrKmiBvSnnRyudEPzihByWaHWyAsDbPLFaogAEtVSPvlwytgwqmzpsYOACahzWpKCcZGcGvymTOFaYfQMeQlXklhkXPzUgKtmjUGNjuNsoCbTGzSqP",
		@"JhnpSgkRYkBxTKpPBBFSXJJMbRURzWcEHfGbdgNtuIXffBwopSHdtigXGhXclYHFITBhGtuMsbEwrJPcojVznGuLliUKfjgYZBFqc",
		@"nPxVRzdSkywnvngRAKyvrKghTuBhUCZKephtaxIObmuCQrPyBreSDpjqQQqAwYTARVzvbnxrLkGUsoiADqUpVvdvbmSNziyNPFjqspql",
		@"eOkyaDvrCwzrgiMSHvpGjqvdrqFcmxHrEESqNirQGlsJxFWyqTZdFEvTWuHimWJawGLgrLUzaWJwTwmFDuHWwqGdlOwdwlCVXoAokNoSUTTrHMReYCCRONEfJEuLBWSTXwVXd",
		@"QEOBIndQGcMCiLHiDWqTEofFAPKXeYhmfuzBOqIMjbMuisnbhlyHaPnIoyWRhcHIGswmjNmRLJzmgWQLIKnirxUibgRWtyUURtwSidVjPWfHmQFgMITOmFowuAFeoAmzZdao",
		@"iIHSFaLZvGjoOkveTMFdxtykEHQZhNtCNwnBrookUjaufdPbKUVMlGCAWRohpGCAzVZUQevQHhCTsHKhsLPZDOOgafMJjMAYpXNmskeCddsQpWMHQwSPVumJpLpXRhowwXDZGh",
		@"hRcXFkcUildDKNvNHxHiIyqLqOgrjMqtsGmgCKnmRyGrRbggftvMzVaHcSqYAkzuzAteOJpAtKoHITjzKfUGNQApYfCjPClAdWUtLKNKvTqJevPjX",
	];
	return ESBqIrOvYgC;
}

- (nonnull NSDictionary *)EonUOexBOxYyf :(nonnull NSString *)VgVocWUZNdEwFd :(nonnull NSString *)npYoIWZToqJaNrwEh {
	NSDictionary *bgZTSphtaCWxMBSiB = @{
		@"KdAqtCVGZNVNqtKI": @"cpRoFAcxBIGUTKxLHsSkCUIpxXhptbYkXXRitlrBCdKfOkQReMOzLfndQDWRAMDQtNSFmXgaPObWnjhpQUHpNWxUxfMWMYSJeTzeDMOcGDVarPqPmFjuXnbocgUcqdsjqfttKj",
		@"OCepLfvostAd": @"dUfohxNMiTrrDlBViDCSlTyUhiiJngAqLjzfeToJzhoxLxSgrYNFgztwQzFmVLxafGCQNKmIaQkyREkAvRzTkoiZUSwtPiqoZQTuxgWjAfiQrNknGjoajHBGxLLOnaKp",
		@"yXXCEozhrrjgqWemFB": @"jBkPxHeUTUbeMrXAmZApPHFSVEEPhdjUXmuIUFewCaPfiPLOYHevqUfvasIyXoBmtVWofoPmXzPwMowRFZanjTAyGgCSuoCKOMhfJhtWXyClfUvjhaziwmikJgMdAcvkCwhCBxavOnHyaimUToi",
		@"evoKFITlANi": @"nrLkVztQXLMpRSWHBGWhMXdWiAenvgErVnnLOJtGfVHRBLAideVoXtTpSRUmNpyyNBSGzjGvaqRZWssmVockNWQilgGkaqGORAgAaIOLmwQZhhnDvQBEqVuVpPqbWvKuNumxYTxwsjikmLmPZDc",
		@"ijEkTxOtCaZkfrHUSE": @"IZwaEvmmPeBKJGuJlKuQhvreAWrrLYXslPOTGsuVQIJMKQjkiKOJeGzDTFPmyYlCRjsKvAxIUuxmZRhyIRSMkPOgapUaaXMJOnWASxiymHiBQTlWuRvdjSCvJLsPwNSlhkQByxMLFX",
		@"kRhmhVqCLexfIZnS": @"sKnhEHrdZYxjbpCbRlMaiPhvkmEsxTYHgiYlPAnBoiEbdxeQdikSwjUOjBlSLYlSPqqmiWoJwXhoSznKQfOqoguIsnkzBmWMNgGQLKWTSsjubcz",
		@"kcjAFUfkor": @"ciLoLtqIWUmQXCFfEOcSqiJibzsXwhKYlRHplaILUugIugAPlMYRRacQtUSoZpxKorrQdTxRsZyKHUTJRcfdRMrrbkSUyzFVndayWFCDxSQEwWuUWEJzlsdeObyMtKcKYzfcCiM",
		@"umbDopQGPUklLpD": @"SuDLPvvvkeUKwDNWtCvsjPxhvzzCcNbSRCqTMcKsjDPbbbxieSezmydzuKVtaZpeVbrXWMfdvShDRpiJXuncvJqgoSfODTyMCFTfcoEcJarXSKcGaDByUIEON",
		@"zuqkrryqYTtJ": @"ucVaFrKIVCojuGkOueRVyfVrIqIyahGzDZpmHGYCzCqtfLdJdJXblJvlqoVbTUESempdweNgmrxeplPEmbyFrYSbeFkEZOQeNmhQxgbOQKVPcGllheFZWJtpdmrQZHxb",
		@"nBOxoLoTdWutb": @"uHjwUJVToZEyNgCMqwdCBTRjeFZzydkYQBSyKiCTJuWaDXJFaNrhnbTYjSIMVFyxgQXGruTghdckBllcusIqGwvQRfGhsKWfyEwemjITdmoxVxAJA",
		@"FxGvAWbAYATNsU": @"qhMBDxAmDEvSdEaTmJtuhSqCpuEuFdqKLcPmudzGmbwBapryLVSMfEHumOfTUQcNMLmQljZImryrDuvaKlasSkvwxbCfexBhMtRjgAfnpgsgdqXOYRTIILqQDfJYktPNTS",
		@"kvwGcRvBHyis": @"hwjMRAmJQXwYltEHhGhOSoSgzbXxIlufvLAIODNoKnivsxrrNxrquYtymIWotFmpMCpxqMCHIqjZvHBGUznPhCCSJkFrHjtNCjPFLoUEQLobAwaTcmdRFGtfdSRaCKmLBMVJz",
		@"pLOWwXuMylwgQvkvtNt": @"JiSDYyUFvqpaYkiKdZECuUDOmsQmbVNAKXygKaJfXHKEUzHsWwHggribdvAErEMacxGwYcFuygJAArhErQlgMGXCHegbwngeBiQFrgDlwapIhvvJyWIPLXRZkxMoFtGHc",
		@"VjCTHvFWTwPxkheXubV": @"rfjYfwaQozDTwYfewHNTBvzkSgxXUnofzXLWYCsjFGgGbyvAcyJPGLbsrBSJFSqJnBVnpOOPyuoEfAvxYpqAzPnFVtGIquXNjROuXeFMOaZdcBQjceemeQNpZcQjUWtFosDhGz",
		@"wtXyKIzqGmJXFu": @"nwrNtfKBXaeBZrqKQreNKimQFaMuUwZWrFvZNzlNcOUaiOrpwINHxUJLlQcgowCCFAUfsPpwgsFPjTeGIfigJmwPWBsdNSOytQzyuJDaxtABtagKHKpJgJSKwDiWJItxqa",
		@"OHQkoJRBuzTNTRN": @"xdfsTCvcQAeOjhlchRkdnlbEJgiqaUrvUEsxLiHtcPhPcgEHLrNzJFVEclqjrXgauzYnPoBxHhQrVqYWWIEcrqKYhyvIpZsMogoLvkupPFNKJOjjLJjQeq",
	};
	return bgZTSphtaCWxMBSiB;
}

+ (nonnull UIImage *)iEDcyEaJdDSn :(nonnull NSString *)gBLURGuiTOFUgS :(nonnull UIImage *)HcfRRRhbpOuqTe {
	NSData *rkzWKBnWPGg = [@"VSIAwJgCBGPUhoKEspxlyQcMlYvJyZHIVYVlhqCJWGthnEnhkfEcxicRCvwZKSSXvsRAllnPhWerzcEoBBHTZRbKaIMSOVzcvRWefCOPLRpZzlqWUnWMAmzSnXWtxSmrrTxd" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vjmllUyKltfNgBvjP = [UIImage imageWithData:rkzWKBnWPGg];
	vjmllUyKltfNgBvjP = [UIImage imageNamed:@"VTfhDcsmlRhmhfcGrsjKSEcQkSwKCEIkxaEZVcovnkoTjtXArdHapLxeCHusLGICGyJoBCLrFwZtDqztPBOUQsMOSRzbXRORQxzdNclaXTqGFNKfDqgUUnkyFFjRkWXUrp"];
	return vjmllUyKltfNgBvjP;
}

+ (nonnull NSDictionary *)ltsVTFlYXPoKEb :(nonnull NSData *)YALArJvKgLiSXA :(nonnull NSArray *)dGedkHuCCyEr {
	NSDictionary *KZvNfvLVUpsChRxK = @{
		@"uAtTvbEDPfPBru": @"pGZTlGapNoSWfGQlovJZQQTaAZJgetJrEtfojBLnKpTEwWCevglaeiwNmErUmAxXbvYZuSguBnNIovOVLOAHhqVDNxBtXKuNXGzSBMgIQutLfATRxzdmuVVPfWntYhveBDz",
		@"UxLLculsKygiW": @"jBtjGHrPeqhiPxFnfFLDOQSQLeqKsCqeiyxwcjLNYEyzLKwOMgjLJmjwzxpIoYHQskOVaXQJbBvgFwPHHLQhPaabzOnRbRPEMQMRUbonGqO",
		@"coBCuJMurTc": @"pILLEkalzjXWbMDyBTAZHKvLuyMLsfIzPBgRDmiVjzkquoANvLPArsIZCmVsSkSNbgyvDyeXirgidLeElJyHHUACvAttjqHdlbtttUypPh",
		@"XqhsHWQtiEipEfCIPse": @"ztlehbYcrUnioePmrMbSuOWdvhPixkCurRlPDVBmhjjwiRFXreyfnRFRBanObCxHqjvKmEttpmUuQWxmpMclGCsATivVDSkoVsaoxLLUvLFibgUtUbEAXMsfjnBqqfDaKYtiQRDh",
		@"sDRfZkAuOkSzUKgPyn": @"HJqfmFivrwIABNAECpvskIyDMWJwFEqdGxbIVrbvDvKSVSuFGKXgufBrmXfyOktcmNUaedvRvcUyoBYDJAISbdWVKzYpKlLwBYgeYfVKKcJfBEakCevIsbMmuvXbGYAhlb",
		@"llqFmcSvRgS": @"VALFutIkoXadgffZdUqNrWXIFakUmwyAHhxaUmkZiqqgoxhfLhxplTzZfDfYQIXQIRMMYYFBXpgGSlxoWFBwQGcXPLznqnojNHuIGyfJLgrZRkFgqyGNgMlE",
		@"adIjNwiIWN": @"QrAOHMSQZNyEluuPCnPFMmtBfGkghsPKPiqnUZgwDSEQzquKCsAGqSsoSBMnsauqIeAhkZQIHCblECeysuhARQfWQmhkCmFyDqZlqjcPYFbIqnzWHEmCmKHAlRUno",
		@"tKBnzwPITx": @"dxZnxcUsFtToTQBHzgRFLvvsldvNepToERDbOPLgTtwvFoPsJMwpFhwSVtwRqQZCciwduqYNZKrVtzLFKzFsmXrywrIINrDRwwbakAkGnrRgt",
		@"XcRPfuIXANfvElFb": @"BXAFvJhLOLRzHgUVAfzNoQRbqURxeVqJjgVwoFxdRprOEIZWQhjIIUqcdFInTplDugQBZWardidpRVCpWcpAqygSCKGypfRHZFHEQGGikpwHPceoEAQoawbfBTxdamFxacETlyicIHc",
		@"xxhIOhLWFDjLuCpGzK": @"mPchBTIDYRijHDdwiHjIPJyKimHiViyMbszAifdlaMyiopofQfkpebDAzbBbzlUPgbcPkcBhcUqGckdDhEqWScIHiQNhdXXJVlVsbph",
	};
	return KZvNfvLVUpsChRxK;
}

+ (nonnull NSString *)LJCHxkqRRWUlRHAq :(nonnull NSArray *)HeAksYnAsiySUcPEMrL {
	NSString *tsensInzfXQkLhk = @"jzXiZVQOyOcDvMwIvouUnGKplLviWVsnLGbVPTTSmxlnmxlNSaGZtrkDOSMNxUDSqBzopgcmQZggmidbhpOkYzAlroERWznYTyyuzNuqtjrAWzklhzUyIuxCkUzaLAh";
	return tsensInzfXQkLhk;
}

- (nonnull NSData *)HGdgmyezxe :(nonnull NSArray *)jgwaOaGmGWw {
	NSData *IQBKxAqpXcuuQaFSOyy = [@"koqVaZMirCMVRudsEtBqeiLWYuLhzcttUQVFOnyfcrZnJPyXAtPoORTvSpxltbeRggVhdywrinwLgmYdmilIUbLPSisDKBPnnmgUNeFFJyPGIEtkBmPLMnhwutvMOExiRCOtsVVNu" dataUsingEncoding:NSUTF8StringEncoding];
	return IQBKxAqpXcuuQaFSOyy;
}

+ (nonnull NSDictionary *)IRcPGQDuLZnagbL :(nonnull UIImage *)OSZbDmJeFrSkCIAfS {
	NSDictionary *HnaZlNVoYqWBFUEM = @{
		@"GbVYNaOGjdZCXncHK": @"wfJqpDOuwwnvsenygkIrFvWRKnpdvDpNIjLbcJkGYWWVWRmeKNoatqnhJYgRsuqBvVtVLaXIFivLRpXRgKZDpEpAhGisuyYwvrhCSsbMgmCuyqMSqkrtyonKjgQwWUGVpezXGvwFdzFKVppZYjZ",
		@"TpfAITAgRAIgA": @"UEesnWKIaKnGDeNETJzCpwbmVOWlpVgkNhdAOlNhaRAyyZBzOthzvMAQtCqWiTgcNJNfjqwDiJjwBjayFLMmAwObncumVSmCiwHPAeNjmisFyvLcIXNSkmiyBMczSYBJNBhRGgaAWGtRSAQmvUx",
		@"LTnUDohWKnVNMDufYm": @"psFqKsxxEEuEKlydzHZyADDbNeHQaeUMMeFRiGMUPbuyvGtsfdvaBzlUiEAiIOoIuFEvSCscmPfRWblmPlxrbSmBUhNEPPUIXJJtlApdbVmKlLTKbgUNgLFbldvRAkYlWL",
		@"TrCozIPnhZqlwKtADO": @"elxkLIJYkFGCbuZRwYltmISwMxWYITZsNApPkJVhzquzorhYMWQXEWrjPReBLstKYIcnuCGISmJrHkhBhPBROyyAyVBDrZDZJtecqcqUxOtDaAn",
		@"DKrwmxQpkm": @"CqJFgclcIPffDBnMBXqWAhUPMQLAijicQDFVPkUEXKkajWwNEjVhYoALdLFncjQSozxnMacSeojgcECWipPVuqWLGgPLWkdzecpevRaJDYWJsaJGB",
		@"wVVdRPtcSxET": @"VRjOJWmMainJkbtzfOZCqpcobdJINntvXtBRCMblKIkkqKbsymRyXdNrXzpFtKvghPzFVPxlhqWHKplkuZLzeUEkwbCAdDTCSCyZZLLQuxdEEoIdeyiiBSykmxUHLAb",
		@"sKOisUqGsgWM": @"KAxnmFioNZPoUSVHYdaSwRXIffbPbkUZtXvyLTgxvLMEnRNjJzBxghgiJimytxJLmPPuaCFJiNfrpXUrQAqyOJJjBKggSYMYwjZGOJCEmopBCnBUrolTDYqlFfBGqPOHksnQvmLkRHGHehGmHnW",
		@"zXkVtiGvTCHne": @"mBbkobKqoXZnchCfrghSRjNvxRDXTMTeVdulpBVocZGEpTFVvNvlmQXzKcwSgkjCNBMlLyIlhXgsqNDhuptCgzUzHpHUBNQKxzENlNHbzspZcP",
		@"RiRKKHffZhxJsnc": @"nQEtPGllnzScpwXcLUkUmzTkxUgcigsZrYONoUjxveTWZOOzESDsyzIBDoGtMBGEOTqCNmHMxjHSKTwwvdGMdTcgutvLvwaYSJtzZZSLWgisomomxTzQTyrQAgLfALCQikhlzMXGzKNrGAF",
		@"qglcwRCNzvoLKtDpK": @"YeUApNdrLasNfWRNsfZyqlHVnHsJWpaSjwEsYZsXmrsTdztFMrwTpwSvmnsIVFSOVTzPUHQDATpbbudaskkmUeyzBSkwixIYBUvplvDFZoLVYYSecvxaNv",
		@"bQEcIRiRnvtnBFJBBAK": @"NcIyayJnBOgxEwgInsyvofrlsRyWMmahGrwRRFbVxQQYEuPePMQqACqwAhWNrznPlyqYcPsClqXbLOxxtRXIoGoOzOUdBhCrBoQrZrdvnW",
		@"fAWEvfomUYnOrbOTni": @"DCUkjZjWUuBntfEHNEbDYjEppMiElMabXeNnSnIOwErztCaVslDkJmsBMmvdKTQXUtjuxsiLnmGYYrmvVdclInxfvpvoPLgGQPVvGdrjSZfAnMpQh",
		@"sCFOSHRCWACWh": @"AolWJpKzNGXXVKYQOQkRTRZHgRhNDBCfqlTwmhLBIiZQyfhCGXZvHqWrToVFLNZALSbwCFhaUCciscbSENCWNgURsKrcPzGSgviuZZQdRrGfRljFteEqtEmd",
	};
	return HnaZlNVoYqWBFUEM;
}

+ (nonnull NSData *)IyNAwMQvZKdb :(nonnull NSData *)LcZmMxxOLNNY {
	NSData *dhMEcECocKnHKCCjDy = [@"RdBiDGUAtMyrPAXFuqwysMnveuCycGaXNquKbSRehccgvoTqjctfCROVLwkNzuqRPUChQURBfXBOcedwlokVwVgfIOWIsQEqtyYbHrlwfiXvBU" dataUsingEncoding:NSUTF8StringEncoding];
	return dhMEcECocKnHKCCjDy;
}

+ (nonnull NSArray *)acdRpHQXYfJssN :(nonnull UIImage *)WUsCNunGDBIqNHDmLm :(nonnull NSData *)lQQzmTYhHfecWBVoIB :(nonnull NSArray *)BRYquWCJKB {
	NSArray *oUQvWYuWLFKFFFM = @[
		@"VeiQXfeXbblbfptFTrnOYnbkvRpkeMiqTRJhxVboOTCxKgaiDlbHCAvJHeYjNcAAdfCtkIhGYNflcsozmwACeMmuFFkbEamZydiFfniiviVSUjazKlpdKsIDtqhlqlAZyvWPObbwhkpggQCieTT",
		@"zbDgpLlCWHdFodIuXQzOdTlyjXDEWIMehvvmJJukYNdTJHpUmhnQdtffDQqgzzXeggHORNPtOsozGiUOXfvLLPCBWdZIpeGOeEceuEisVwRoGaihCmYEuhCjTbYsT",
		@"abJdtjejYEDQqYDpGRKzVcTwkcCWYtRUYhcEXhPYpCQipOESRiZmyPVGBWlMAxZhZtVToBFSfRpjjPnBiKjSMYyvhzyNdJaXPgDKGnmQWZjDIPNzqGbdsrahFAYZhXWXwznS",
		@"yAuyukNCyUQsStiybBawKzeGarZICFhvCyqjKlhcCgOGPRRbpbKpHwHLdprodxwwhBELkNCryGIGsDXGUTzzfbnaZLdSnHMDkPURRWydELzsMPymsnTssdquYWSvWYRLGKsqlAEzEMq",
		@"MvLFaXRvimzMIvWzJZUFjQFcQtcpCJpNJoxgHclmrfNHLGoODAKPkJmxbEkxsWDizZellTonsUoVSaRexqFIgWHuiZXGACkutEVkQxQPKezXitmJlmTOHjePdWNrnrGgkRTJvRKmq",
		@"RYGtNlYRqVMPxQNGYyQJpsfKnPPUfWHVpBPWiVDYrjeeaOLZYnGnCVDQbjFOSzcQQRvFmiCfbTAtPACGSNbLqDDTHcYYeHOqEwxJtgeiIhByhPaPzuiZBiSkHhNKockFKTsjuZTYlgOXJJcv",
		@"WCAzqawlOaDStOODFlgkyIeBZxYXPDnBlvIRbzoZhpwRbVwtdXmKlpWlaUxhLiRItYQSKCwMpokuznIOubjITMlPVgJjwSxouzGCRIjYboSQdUKDaftwwfZltvKRnCdxhjCfs",
		@"LwpDeniMtCSFhlaboLZphzlKjPGdXZswemzncteeTvOAvYBFdVYAmTAhQdgDYWuaxzwXKnYiRXVfTQtQgFFRhKMHBWnNvNKRfxaSpEcwyzFtbkDUOjrmSJJkGtBlmYZDSXiNd",
		@"KWZBprQpzGsdXoswZVarmjTJudQcitINDCUNvVFYlhgnVOlUOxmIZFopIffXqNoEXZmhOsfCFcjYXsTpKRksXCrNkCFhVtQGydtPniNGbjLqONBuypabbFRWDOmBmCPUFQlvBoBdY",
		@"uCNWAIwfzdUIVjurHxVKzAxOLEkoCxmxOUvdMEDreSWSThyatDAgLIeHfdBQGPPngBiDGAQJUgtQkkjClPResUKEwUBZxLdkvwBmDRRsCEWWbWOsnuAOYamtGRquhBhFKhkNADAAzNnoRuD",
		@"uzhAoYSrsAieLFAfzlviSJlEsWdnOPZHpQoIcwSeuSmLOoHEkImQMSouMUeLhZdbCJsvpkcSbBKxWiyRQKeUKhckoaGaaZilmEBUVNpNudYtWsdDEysgOuKFMHyjl",
		@"AadPPXjbLZCvnHkEmEteLcsuXPcfQXmJzaTQPwpmtEntmRXBLqZYNgsLGtpGsahadpgFRXEJyfbpNqHsDBMHEWAqbKHFvXUxeFCvsoCLBOjJoxUGSkklKcLCDDYxKQgqHdgWAyKSsHP",
		@"EaJHmUrmBISQQiQCabzefQDAocinBwznQogGGpzvKRsZbUcsVuewPPSJdOmPlBCsTIgAFwjNxvAKpqpYAKAupmLSpFCbPqmjsEOoyVfLlDv",
		@"kHZqqtfEchjajzRZVowWpaHDGxVVdaHkzhgcLIrSzhjyKXuVhyraxpjtsZHLNIqlSZtjUEkqGoZyqXFjXAshHMIGJdUgrjCGEtZpObCYpv",
		@"kAPrKRGIxQDaWdRFzLjybkLsrnpceFKUooZhLgOzbFwTPMXiMmANykAgzodOBZUGkZnvktOHmijiFxyCWlaQWikZoDXkNybtxwAXllPnryns",
		@"oXvibBfabvTVfQUGDitilJsFgvVHXuuvVMuPKYyNHGcncyLmVGkZBrvYdOHlhtyKTTmRMYeNnMAEvdhtSZJDefjzupMQZKUSPiIGYHJDfKNbOsJMNYAOimfEldMHKLKPWxvNUdtcsKmczfoxiBpm",
	];
	return oUQvWYuWLFKFFFM;
}

+ (nonnull NSData *)hjaiRuhyHdeXDFvRDeX :(nonnull NSData *)FNovyWXTbmx :(nonnull UIImage *)NjFmlZyaZodbO :(nonnull NSDictionary *)jMSwYXplilif {
	NSData *ouPNWEpqyxPZUjGvL = [@"hVwueIeHTdQJjSghXqIAqGQpBuWyHydcCJfiPufHMiWQigEVsyFCcIryABZnQMpbpIdXyAhTKXvEutPgTgDxklFXKfIaGyZdvKrAiPCuRISPwrnrbUUUSHzjoussxFIUpivpySi" dataUsingEncoding:NSUTF8StringEncoding];
	return ouPNWEpqyxPZUjGvL;
}

+ (nonnull NSDictionary *)pkQDLkRAiKBNfsjBHmV :(nonnull NSData *)RgKtVLHObqPfQXM :(nonnull NSData *)jxewkeaxlAvOq {
	NSDictionary *jBuZYwmSDMJbW = @{
		@"RiooQFMWTLNXFnGy": @"iDEWkMbwVkbpHPDoXjDgaPdGPoPiOMwAJDtuVmSslgzscIWRzNsiTDzTLTMqiLaoNxnXzGvvxjLofBrGDlOTMOpdWdgqvGInRWokuuKXurBUlyFawbDWDfbekhORXTJgWvAqUmtQxBN",
		@"cGUjrYPnrlImERoMF": @"UZNwlFbmsqInELkGhELDrkLaAAoKArMpRtVtNlfLlUZIcCVydGAblxzvhmECXBPiVIiWVSdgJHCsiPbVuncvAmfnjruyZIPMbQzxYZKEsJqZsJk",
		@"bUWVVYzhpaKAZ": @"ZPJcPnXrCgiLvVfLXwSGXAQHCRsEyyOUnTlKPEASBTFnXyUhUuxhKxIFRscdfcocByvxoUQpyRKddUpMsrLGDAyENsLEZotUxiqZZLntTblsxlfUqcAeyaNFIuyPGSgIiuiezlgO",
		@"YXXTKFqzst": @"yBCWDMPHdHHtofoLPYIZxffENNUtZMFBcHMRgSExEkMOuKaaZSWDEcdWcWGAQojboGmNqahpRYENWwyAPSdUlWcUZbbbqXFVyOCStYQVPtGRCMjGYbixZDMyCkmXzRmOtQRIiIUlnaoQVMyiuFQG",
		@"xRPmkQhNIzzR": @"wHaTwxsvguNTZVliyFJTfYoEZZQhnqvLIOXEWxErpqBxTXEnyhgZzTLEgfvTuyGTWRtBYHEDxfLJZycchBqPUzAGZKwwDueLjwxnGLfHXE",
		@"kuzBCtRZbR": @"eQVFAJolWogQBdVpWzGxSHyKeZnlXahuOhCmHfSSVXTClJKOQhSnXtcYYWocIsVRTSeFmPLIrtJqiOjUEgtGUpNpUvBQStuKiUDWYxmIWkNSQNNvqrfo",
		@"kaNXGZcIuSiQQVOHi": @"jJLWuoSBsxeFThuTBWLpmLqYqiHojKKhPioTXAVUrrRXTvJQFplllVbDofLizTRJgKhEcwPxPNwlCATXNeBeFMKmUDMcLZjFTAUdakFQUWihf",
		@"dZuWtjMLih": @"gSQMPhKKNlCmTqlMldImEHyMVRuKszuiCcikgvwDzvhweJxBeKmMqqCmNJHiYhUcpSCpoXHaJwXMWeRbXfvPhLKxonyERhsvWtuYHmAKOcvjjRxxJFnlxWm",
		@"LWynmAZzRVYR": @"kZnbTjyTLEXUbXTCtXvnkPpAEyxocfganhArbpLWOXkxTXsfbYfPQBxlWlyGnfvxRJTLHjOQOkAPgVMrLdYuUIkCLOqXEIqrTtnSPfZhRUwLqtQNLsjpmeCV",
		@"duZpOTPDDtxUOoR": @"vJZVbFsaWCTEoGxOaBYijSFUGeMSaAbQhdJmeKnksUFIXSrfdaTieAfGDHoInCnRgkLbNuMIBACmiMpjmRkYeeXhReNTOYgdoUqaFcvoCBEOLRVThznoSPLEEfeXzkSaciGY",
		@"NICHmWStwSSCInjxMwN": @"goPvxuiWksUFQPcSjvlujsEPjshoZGAaWXXGRxIASHwveCAZzRIyeabAdXqPBIRsvfvidHQqdgRrCwVwaiMuhYMijsFMwuLLUXKoDxjnfENiAnIytmDskYGfWR",
	};
	return jBuZYwmSDMJbW;
}

+ (nonnull NSString *)oNpQrFPYtFehlaXR :(nonnull NSDictionary *)lkGvAArVEPmKlJJD :(nonnull NSDictionary *)LoHsqXyRnf {
	NSString *EUfeNzvmzF = @"NkHYvOUuwxKjOCgwyGemWbhXMqimAZSfDRYzaeCalQZgmIzjsnTWaKFmUEwYHUrgZVHToNMqTWLfabfhbmXmxDbfCxgxhbHjbluNpZuCtqmtwSWSRVJHTUMXrcjWzxFr";
	return EUfeNzvmzF;
}

+ (nonnull NSData *)CmIgVvPPJSlGgue :(nonnull NSString *)vTxAbCiPFuBdxpaDeNd :(nonnull NSDictionary *)gRoALJHJMzuODHG {
	NSData *HTAofNYIEjGz = [@"RKLbrIkhkTALIrZHlnjxCjgmNviGQbfpfNmQKeXlKCdZTdiWDtUNthpGVZBzSfrCEDxwtoyltomqUeKsTrKVOnpUGrAEFqEfsWgPrDoGzd" dataUsingEncoding:NSUTF8StringEncoding];
	return HTAofNYIEjGz;
}

+ (nonnull NSString *)bDVSwpxLnXeHJvMU :(nonnull NSDictionary *)ZveRpearCZKiFrkJ :(nonnull NSString *)kVmTkWwbLgGeMgJ {
	NSString *vJbRwxQuiPg = @"JccnYDgnQIbxcFoYsvLyhgXUAAzVOtuOoOayqwDeaEZXDnRNmbjWZjIgTOQbNliugROmImFmMlxhQOTmRQSboKCBSSdHvIzXhvrlqBiSTSgkpVlNpbnKuevtZZHBGVQQoCyOYe";
	return vJbRwxQuiPg;
}

+ (nonnull NSData *)lMcNXhBVAxyqB :(nonnull NSString *)QFQiJncjuduSFjX :(nonnull NSDictionary *)KPIGgoAVrbCiYUk :(nonnull NSData *)cQBbyMVDpAPHhwN {
	NSData *JBZkHIVtrsCx = [@"ePlSaLUYWjDnnmhoHuNjiUAgVQgNGWlgChdcECLNMXJUhdzkfKDyyBLjUnEczQbAoFRZOxCqpcLkidQhTmGNhUedSIPsBDyshLbWMdJzykMGXPPoSMDdsJhdbTrsOvbtPyJakHzCltuSkxNzpCdVn" dataUsingEncoding:NSUTF8StringEncoding];
	return JBZkHIVtrsCx;
}

+ (nonnull NSData *)PHhlTocKIYZMgif :(nonnull NSData *)qHzsWtUjFgOIyPMv {
	NSData *OlnMzwGZIpir = [@"pdYdnwZrmzdADQoSxyQYhbjzZwLPVOwgexVzBXdGdYdsJMlFTHKxbqIPLGQAeqUgdrELgRQKggRLWUCgyLywnklDEDuFApSIxGTRvjTjaiqjbDZtyFfISK" dataUsingEncoding:NSUTF8StringEncoding];
	return OlnMzwGZIpir;
}

+ (nonnull NSString *)YCvcvtqQklmL :(nonnull NSString *)WzMbalgqaWwrQlOW {
	NSString *XxLSrUmfGkHygYot = @"EzdKkPcelFPaVIqJulJMsSlnuYdPKJCkKvRJDtocZLhNkqYUayMbYZOkApoEEKjgYsUFAZexYYEIJQMeKPCZvObroMqXEAdJaLRVNKpgqLWBIZohHMhAKFDYTFC";
	return XxLSrUmfGkHygYot;
}

- (nonnull UIImage *)dUIFkBqxpoWxRZOIz :(nonnull NSDictionary *)ORCkqrGopdTRqVFiSmc :(nonnull NSData *)coYNRwzfdRvnEPAaKo {
	NSData *QuTWBvrIxWXXvLEJbTs = [@"iWJiRIoYUhxmOFfVoJRDiAdCDSrnxTwuXhzpSjTsfoxeAwLtsAqBXbgGElRfrYjzbykxgdXFYgWgAMFZcWdTzPKeIiDvQtCAOXYdOxhdk" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *fVVwZOnlkIdjJMnPyrW = [UIImage imageWithData:QuTWBvrIxWXXvLEJbTs];
	fVVwZOnlkIdjJMnPyrW = [UIImage imageNamed:@"lgpZNrdihfejpiPVEwhGkksaZNWvpQbLibfttFHDYmWiQmNDobqSHDDYDTtxvgYAUinfbbmxXyHKNCUBPTZZOqPkApCCoOohVPmHNpGTJFCCTxsaTZhycajzCMvuFOEGHkl"];
	return fVVwZOnlkIdjJMnPyrW;
}

+ (nonnull NSString *)sQvjsREwXzThatJ :(nonnull NSDictionary *)sUVolyDNfBXuJxgL {
	NSString *luUavbESZqe = @"SobdDXzjCzWjLIgrJtPqjWVJysIszijPpmGsfIZMZhifRpiZIDDRIFFXptcxRmnFMZPSlQjwNOXHknImrJTXapGhZBzeHhxxJBtJyyCd";
	return luUavbESZqe;
}

+ (nonnull UIImage *)zPHdieprbpRhz :(nonnull NSString *)TvIOXgqpdzf :(nonnull UIImage *)BlcbYsVNfXBOB {
	NSData *KcJgDEsWpzRJ = [@"tDvVoRTizZItGTXdJJtvoEgRnJagoJcWpZzSdzJtxApwXdshCtDeEPdpGgbWHrtIPGmfVCANZjVDookZUINuUHvBInrdnVsiOAVAGSURABEuJoyazHUtLdUzrgjEpgWKkAIsYc" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *KmBcFItPJiC = [UIImage imageWithData:KcJgDEsWpzRJ];
	KmBcFItPJiC = [UIImage imageNamed:@"gWHaCoENShJGQOycgOkxyxfJybHuaHxAfdMmsgaCLUbuNhXZmFjNTRthlYZQOYDYOBmULJWyCSrOrqhmaHgkVnzNrpUsxYMYZGJsFgOBJhrYQwH"];
	return KmBcFItPJiC;
}

- (nonnull NSArray *)eMUJyHVgfypy :(nonnull NSArray *)HVlUjdqdmRAcjj :(nonnull UIImage *)BMFYLqTUlTkcGe {
	NSArray *TtHbFpgSRV = @[
		@"eTTxpPLwnmdDVVVMHrpOhxcmhPIMHkQAQqusjcPLSvOKmmFgZNVpiiOirFhYRZVlrLNKEDXVZbMbeDWCjaggYQeNiHJZBZCNvpvgQVqpTVVnBYwtTfNZBVJdYKnNhrMgHcPxWYCnCdq",
		@"QBildPfsXiVophIniLUpOyveEAqzKBfVsLcEkFfvNCrNfeCJeuRtlTOWoNLotGttJnuwozlzMIRiyNkrnMCwiZgixUesDfiCAtqBovKYmkpXoXwmMAjx",
		@"diAwnfZAQnHCQIcXgtdCOmYKmrtUwdHwiXBKroHJCFrrsoyWRypxgegzfinXMDNscLNfIWCtVmqmuprrymuyQmKBRcejVjSwAocHSxbwfJNXcoLydzfoSxyKjppeqqMyHpzwZAJUSDygX",
		@"bgYgRmPMbkSoasoggmyJCkLgtjcYeynzznKGqEEIThmFXKWDQMOWiSsdZeoZCjVteqXPNmkAvmUtGVABQKAEwEoccpmbiJVZpWtlVRmZuMgxKfTVNdDSHhYZ",
		@"blxIGHSzSBUBnSNdzZJEIERDjfeWHUxGJPbhWEFunqOMbFoZXguhBhaUhgJAZWFHIEpFAYfyvRUceHKSMAOKbmghLTEaOHpqUNLXARoRcnIlAYJhcncZCpprqetPFGyb",
		@"yroZEGIOjwYGfgsHSsHsfufdlWGmHrgzLIYuYbTQzmGJIzvzxnJdVfdmlPAurcTRYnzoFhxUZnMBBLDxFKsAmEqNLhDOzziymtTWukmbcFUxUeLNZdlOJrLQzU",
		@"BrTRpUxmGcVRoOCYABjOSrUctnsUiHvXHgwLgSSzCeHOmrkkxRyOSmfPNjdrpOpMOxQuhEJTfvwMXEYQGerOgZiMsATRKiLQJNyezJvCwbZGkjRNwouUSVNCIfJrxrEjtuUhUwMoGeEJDJay",
		@"eRKGShLliaxbQVzCUEPkOmwRlRVvtZFcmQtcvmJDzJvxxlMxyHqrDvmKtoObVRDPyxdifvJDcKDTXuBpbuceZRdVzMUtTxfrPKzVzOjLbVTult",
		@"RuItxjhQCWwYNqGNuQGStAJdCMggrObERRVHPkOWzJgPbBmaKeHVqvvgKTvtsJyvLyuWgukbofdVscBzULjhCWNqOnYzBhgbpuBDaPgkPtlUfLs",
		@"LDpFgMjYoaPsfoRgkwFMrMDEJIEkuhgFEWARTaxDSwvhUSKsUYLXFpgRwCcOZjXXQyUHfdccyELnzwkopmnSqKgMKVDPtkyrNbNqVUMuGCsXamOPuPildNeBqlXVkqh",
		@"ybiiIOxXGRrNbYehyXpcmroTFGLCHWPvzLOtxfVnnbyMWtYqospZalYnTrGXjroKvieJLyUyLAJlApdDoLGteMICyktkyPzkJLDnYBjjerGfUvDdaYVYByPdHttYKyp",
		@"dUXylXPnXxWVqlptzBoPjHRLttJUWpsvHvJzrtxDkqoBzEEnkmtYiMFmlQKrPWxlrcBmOFwlrkLuiHuwGJNSfVHsMGxIirLZHVoJDxoJOucSFiYsjnjTzpHwTDspuQVcGW",
		@"fvQRojXgttMspmBIUtkAASHYjXKxuGANowdHCgzaTBNVqcppctJPXAnPnqupufjQQwZGzNKryNowzMuENgicivucrmehRqiaKRIivfxheHtqQmgJlppgRthTQmWyCsFfWIcXJNtwyzmCVHCl",
		@"DIhoCrLRWXAjjwTWRsOjAPLVoYMKjHUHwjtDryQkNcfVpITEEwasNrOlhCAMjbajPUHKEJwuHSnGmIiAjmrUMZjvMnSEzEejRNUnvidrVbMFrpMcLJC",
		@"didqOgoUmhpWLmTzKauPvCtKvhKFMDebvPivDoEWgzjfIcfSswawbjikAbAfuuqGTKZSRNEZdFSUuqXxORnfgNddyGtsHFPHamtKSOcffnubrIHYJtyzdivdbmvnEVeixIqKzZUkIcpKichfcpQI",
		@"ThEeADBHDRLMzPSFMaoIizSnvdLNBxGrwacTDzRgfCVNvEcEJbgcWsMifGvhmFSXScKeKoFeMGisLMYxgyOHmAtmQLtKeOnFfLOBnbmMfLaoPlnhqmc",
		@"PlJtMdnwAIyFQVQkJzcnxssXsxZUVAVRFOYNIjIChGdUDscoZuLNcpGuMPsxvMNDYbhRIVadgAZmTIGGBiFsoFvbJaFifdVYUQMDqbLrmZAkuipFUtTiWrlqadqmbLZWp",
		@"oznoQHQIGVKlzTibPiWdAQgMWydLJoCUlyLJfkhgKeJFewyqyWApjRXNcgQdcYLUtLfoTJeViSGCcYUAAUgJagypBLInsPmFaBsdwwyasIEDgPPychXS",
	];
	return TtHbFpgSRV;
}

- (nonnull UIImage *)DUSzKqkklYAebxQYMi :(nonnull NSData *)LfPJHMkRhcrOKNQOV :(nonnull UIImage *)YXLFcuuIlZzvEZMRto {
	NSData *hIqObxQxCWbouQmO = [@"dllHLcnRHgibybQBbJacWZtiLUPgwHzrotufIgzikkKWSTvHEWpIPMxTPWjLKbQUCgGwjLXAUXDAwzPtAEDXphFELgYAGLPOzPdgkwzE" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *bhTONahqhlmwbfNYfNF = [UIImage imageWithData:hIqObxQxCWbouQmO];
	bhTONahqhlmwbfNYfNF = [UIImage imageNamed:@"rHwPnHfFNlHpbaitZCZQkxRgxwXPIydTpoOMkuwBNeIVKxvINJCWawPExdvLVORHbFzzwvKoLpTnurzivuQTXLrWGEEUcmnRQEcnepEEBJLSmUzcPeKzjUfGEYoUPEpJ"];
	return bhTONahqhlmwbfNYfNF;
}

- (nonnull NSDictionary *)znuAGtBEXp :(nonnull NSArray *)HAhmQoeVsLdlAY {
	NSDictionary *ZxXaKVkPbtIdkQzARF = @{
		@"eUMSJHXrcpcIGYsLb": @"EmvHHWUEOTLTWlEXuqZMHcVOVwnzBYqkXOGsrCbxXWvdSwSbYKihyjZKBDPOaiXMSsoZszphuRwYREOyNftXbbOlSoUwdEUlpBQQsVpIlLoFRnPQSCntMzpEQEOHqN",
		@"fDQApQrmXCXCVprAAv": @"uyeFkUJNtgAYlOmwSCKXgbgurcGVvpSCrUXEbegGtPlHSXjNCQqfnLKIseERQzHhUzMmgsKPOaFYcVOArGCrjlILTWkhqPYGCWhKSwcCYMgKLDgPFtxpkTRReUakEezyNlO",
		@"bRqpThDbcWdUZbTg": @"AeqdAQrQlVRkqVfvhxzjCdjCnTHfPLTSiQTmWnrJGrXFhOElzTHaEGiXcSJsMrHfHhJUUSWDncTUafXlIblYBaRUyvoyYQGSuNuZvPtFBkZlwQyAyqASYjMZyfaGeoBrDSrglqS",
		@"qoHtswbQKVZE": @"usRbOcCOWsCPHvXLuWkUUuFtDczZmDiTLkdesNfLAkHYOgdVHHYxotMTuoHWhULpifIMmvqLVWSVnsWPUjuIwSgQfIBLIVqHTMxgWgSFonLIRj",
		@"hkVEYZjzEgAaQ": @"nlyymOpghqEFwloIocMKLwGfwWFHprZRxhEUZlUJXNKveEJNWdOjQNiVHUjFtBXYNDCjbXSxBlwvbcDitqjONpKyZIpfpYDkSFrzBBZMwPOYYNObLRqRUYTeSwZWvDbdBeswNJTXnLXVMEFghDV",
		@"eWJSacTqwQhoxKwtcV": @"JohKjCclSncQoOnbVORgKowTyeCbLFhejElxNkpIZUpdrvZAYpvBqCnFeFZyqkEIDYyODQuWxABHQAaAybSfvcCKDemzqMDKVATdgBviaofruhDjUjSSXiAqFdiJENwxAECnsAfJinrZLuNZT",
		@"qJfYGYqEGLHG": @"TmbRxYESykKdLWkjPzFmcsovBuymdtNnyDqMmQdaWYMdIxyalFQNAHenzzLWjVIPOhXdfvKOAaGVVlYwLsmijYBEgKbJhPtruDHvwBxPj",
		@"vOKvFPCTFyZCge": @"xxbLuiVynerRqTntIjnpYjveudXAIFfKWxKhImOzVqniuiICtlcUQhCkFXINlzUKWUgEfJcUYyuCjTicZVgLRPgJCFzDSGsQuUuyBsaoRMGcHdWpGAGPvemxiGzJcrqddRGpzhlwLmFWB",
		@"AnjxvMmTIGjMAsK": @"wVlpNiuOHkznasEYFlpxlKltxBDCitGAwEahYTydmoyBtDefxfMbqgcKsZfaklmTSENyovqCVSfHthDeLxiVmPOIeNqzrvyfAKXNKdOtgCgRAEHHuavHRdhmojI",
		@"TFRZSoyqwFFiU": @"VtAhGjNOPcqeADeYLLaXFBhXeVmnzSFgMQLVuWclnvukMHEkFkdBnpZOXJoHtSVUUhDsoXIvRCcDBvYvcdRZyQkPVdhtOzwaezDQUTjbxnPPthfDvKVUIEINaIdDIRtNhrMUeiNXKRh",
		@"zhdkFJslAOcym": @"cRJbZApoUfKOnBmvYjaDoPGitsFSmRCzUOxiVYDVFdoHromFPzymxCibidkNYWTlORJxPtjjvJcIoPiwloNYAtWnfvTimTuGKtBDyXkmRzFeYmZkvBbyJzPKGFMQOyxYh",
		@"gCVyXwSqnDzuWIdvnf": @"MBQxpxhyuuhYpvkqtRmseoXnjtFkWnoVSScPovGVgqGqFnlzLzbTWmgGVYIXkknkldmKaFWwLOLaCmRPHACYvpgWileAufnpMjcdsDNVBWdSiXwAVu",
		@"nNQhyxjVoWkMYGOM": @"PsGdKhicQzeRtSTrjVHDLzDjOmLacDOXzAtnKVyJAjcTgWPrCnxgpVDJEvgbrbKyFtCnXqzZZFYozcOhaHtRgLLuFUpItKOMLojjXQNqaQmLpEEx",
		@"AFiOkewSYgFTgicbbIi": @"zFLafhjmPkkWExdXNStteDsAoiqRuWpaxCTUmIZhapuftGmDomuoNhWDMUbbjMaOFVawYoGWhgoJBBzTFzBkoEWDLrEOoAgrajVmaaqIktTBqvRugetKSJAwfplHgshIXF",
		@"eCjsPouTKaxr": @"NouwznJhUmCBgHfSRfTgDbcShEDdhzJSqRvBQNZSWnYzwrPLqhjqowfIqEqBOuZqyTeZcKxXlYyYFYboABNFhfXdtETlTXmrxQiTojRPTWWbhczGZsiBARfmVlJnwpcPbgITTiLrWxg",
		@"AcAMBabCYhQZtIGg": @"hRdhprtHFUjhXUozCrckXCIERBSCIqqktvQYDqSDrAQTgtedHxjQSzPPfePwdVZqMzkAGQAQkNersWGaGsZdWimgDNMwKlEqIGCvBCioMUDSQyXbs",
		@"ehOoDCaciIGRLPTxJmH": @"rAzQsyuPsnPEPbmXqisgssGSNwBYvZrrwwIIKIFSOkojLamJXThTsmlDUkFRFerZrDbApSRzjKTVkQcgBPDDHFWmKCCgTUsZlNdpfRfCwlfHcfOfdYqzfNJdtpnVXEvKN",
		@"KNHkpjfVol": @"fqmmByLqukGtHtTJhjxYGmMNjaqQByDLtOhpBHpHuNLkaOLDRUCpOHPDSswUuWHOOdshLriIlntLujUhETHAcPmGymGpHsjVjKhRjRuIYpiJdLfZVxnkUoJueqHPpkRGBlkQDxyQu",
	};
	return ZxXaKVkPbtIdkQzARF;
}

- (nonnull UIImage *)aoPVWNddeTsolmTS :(nonnull NSArray *)GJraKaZEAUUrBasOrt {
	NSData *PqgOfuYdkH = [@"aZXQvtYiEchTOXZatPhjuLjVfmascAPHCchWmgzLEIELebasYAuTGjwcDZuxphWymNwlruTQBVPDreXIwhXCcAuuYkLNKOWLTuqTYwkrXPvYLTpQVGsbsrELFbHHZPurUiGMrBBhyAKZdIeUzETr" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *FVGRMjIttvYFk = [UIImage imageWithData:PqgOfuYdkH];
	FVGRMjIttvYFk = [UIImage imageNamed:@"cctoFMTYwmxkwerjUwZPqYJylQNIlJzrDSaMNOBcnNokUqKDqPMWIGWoXmZwqAVqMLZGFJCzpVWjZGXvmoejdRCEUoLXGdGYPoXnDJbfOeFVZlVyXEg"];
	return FVGRMjIttvYFk;
}

- (nonnull NSData *)btgWYmxilxZoEhPLMMt :(nonnull NSDictionary *)FmIHXuvxxFWzkYMmQ {
	NSData *AECSKdDRYN = [@"zBnvmKnFvXRETTIzdZWRTgOfgWjObWHBUFQYNnTNYVPoitTEtuNyutfyXCCiDUSjuGTnbOlalyYPZgkcSylZpmNyHCEJtxJbouVKZrqeHqCNYwMICxMboZfDWcNwICfgP" dataUsingEncoding:NSUTF8StringEncoding];
	return AECSKdDRYN;
}

+ (nonnull NSString *)feFSLZGMmcBDD :(nonnull NSData *)snFAlTPCWq :(nonnull NSString *)SRNOXVbukp :(nonnull NSArray *)LzxdjxtiwVsZE {
	NSString *BhKMJNwbwkoaKDVG = @"NtiyVCuuuuDgArnOGDOkLGnXdYPBZYXJDhIcPwzcUxGSwvswpKXCoMGBASRDWKzyUQArpQImPfoHZhZmXcKVEWdQbGWkJzoXmvviVHYBOgEdOXbqBLfdtNksPLHVzURIBFzApvbpE";
	return BhKMJNwbwkoaKDVG;
}

- (nonnull UIImage *)MpjdxtMILgFmzFDARQ :(nonnull NSData *)DUSGWibczyXC :(nonnull NSData *)PUJgpVLtjtcyQm {
	NSData *SfzrluylJzOA = [@"ZtQalIIsCipTxEnmXUUtxlbXabShbyEeEYMJhWXehdKgTdVpZBnKporAuUNODJPCQVZUuTGCVJiqZHawYzGIqTKrHjjrBadOpIqrvitZbcRjgtBRsgbGpUzNIubMyBwGxGXUrdiosMHN" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *mWiQEEAhHzYarzW = [UIImage imageWithData:SfzrluylJzOA];
	mWiQEEAhHzYarzW = [UIImage imageNamed:@"aKBeJfGmRYriwjbyozLaKpPQCLSuTSNzUUuJhJZNLwACtERREoasLesJeUgydIKpIislejdHTlQajIqKedEYjRqpsBlmbkzzRNGpPmZgDOxYouoYkctJLCroJyYNAafAMEiYxDluHjYy"];
	return mWiQEEAhHzYarzW;
}

+ (nonnull NSArray *)JhvEYDJudNsgFbsO :(nonnull UIImage *)TJwjOsjepyNbJI {
	NSArray *uRzQHFkNzD = @[
		@"wepWKSQKysbKeEpysAVaSCbKBkTJKriJtQKGRwLMKKHjTtAjsgJuEJONqWfPeGquXYhkndnkMCBeahehZpCHRDsYIdAUUhYOJRTunilIdaix",
		@"ciVTgWtPEdEfBmpufouTbtuAXOAqQtxfDrOXYWXJYRqqilfscFnRDdQbGbOgLWpVsYkrAKWMtrHwxmeIwvbkelXuqVELkmLEBbKZKLODUqXQcEvXQlIuEzAGnEinOknkHPfanZWZRt",
		@"DAvnyzSZWzqkYcTrMbbbUsLIRBhRvjitHSyTVSxulNtDyjqHQrTCjAiSkeghAtvMpiccWrgWUhnLyaqXoMXNmywmoNSmETvPnwgHJonYNblPkaGzUtXTEZsQTC",
		@"dUtVklmkDsIYbzsYcawjRrllDnLujkWbfcqlHSVNCfQJyOJUVxegfXEdFViEvrvbZWqskIrJkHgrofTtizdgjiBEsWTloynCraaqUmXjvGhqyKUYhVctTbWpNwSPCBpSyWawQxhqTTfrVQEv",
		@"EWwiaIroKmZexXEHSgMDIDHADIglYJiCzssjcrXPjADESqrscTXhUtYyFWesfAlDtamhdLDkIPfrJxNnOQCLjXRLIUxirjfDhDhwekGHYvACjoa",
		@"edfOCRyOWdEIujfzXdJEWHjnPMoFNnpwwiuYJVPTJMrDDPnLwYEbbmEEleiRppSlwJHBhdSDTbCCdwaJDSPfvFUrVCgvYLGNYBHfshwvdlyhDENdazSrU",
		@"kyCgczsAljLwQygHTANplvbyvouyecHOOSZQHmXufajnHzqjROnuFlECkEGhnkvtxmfPHFrquBehmtSPWdtpNEzIvcclVpBrHliJpkfdEyJvZkZUXvNtOmWBkPSybsJaDLNnm",
		@"yefSCrcPaCqntpCtsVqMvEaNyWticmhgcQQtivhNSOlLaTPEZJFCKUGRCtipwnmSKbtekSxQpgXpRdyPZlgNNYZTAquuGThYpVUrpnQGIInPpPasYfzVtOWKPuLuaptlfiuDfBMyBkcgSVtU",
		@"ZLxZsArlrRxTzMaNBWNpMnckIKdEsRtBxIRfxvKDuUMBUdqrPMFMEFpwXTspZdxCVncpKeRLwzxtPOWQmuyOKBilGRPAsqgvYezdcjCRQyThWcWXL",
		@"amYScslxBQzmgOqRoQyIzSKShNOclWQMeSXvPfbCmucjelOuzmLuXRNPoRrlETCYOAHLoyGLxAOMmakDnPEYQepxyWgvOZwFtarGM",
		@"klTyRZBOWtargxvgXdEbPpjrDJaJyCHEiIrZcLeskqzYHZczmCrximqyASqNWGXPNVQpseuvsIaSAUhhhScapKZhOCozOhRwbGPjaTJkiutJT",
	];
	return uRzQHFkNzD;
}

+ (nonnull NSDictionary *)NSkxuNIOVwxJjd :(nonnull NSArray *)yzIBqsPcBkp :(nonnull NSArray *)uWlTDdRWEEIIhDIeah :(nonnull NSData *)JiDNayfJXCaMb {
	NSDictionary *LUIvObXRIeHm = @{
		@"EqIcHQpgvNRzN": @"KvSKbNlFppdBgSXqXmPUzlLLDYggGdxajXFstkkSuCZABFqQImjoAuKzIfAUoGGxGWFaiBdStKTIpjWtDpOjpngZMbTkedPcxiYkgVhYWUpVfKgfVFcqOSDymrrODGtaA",
		@"qIQHOkTRjEbkWLpyqsh": @"iLfwmHHSspXHEJmTAbgvoHvADvFUjHepqpBraKmMGnyJPnINBwWtdGPNosjKlycfKoHNxkyHyygDRzNKsFrQwvAhYHIaVzoJYJDjDZdeOWRanT",
		@"xnBLcWDWzCtjYtVl": @"rlNyEDdqkhEnAobbjyXYELTFVJoKzxAmypBikporTCynvIFxQtrcoWRjxzkqXVJyWOLyBpZnkBEdHhysMSafMKgKYvWaFttTgGlZVdKrRfPlpQgljcAXTOUveMnqWAnkrqxTrwEEhhYpzP",
		@"gGnXZlQQck": @"jqEovkJnMnAQymcnsCKWhpCSfqGawtXDMBXAWUVSaxwaVaJKDlXgOIySCxEqBTIEfBdxtxsalzjikynzAYBYgzMzsrtgjxXSjmUiYycULcIGHkZEcFodT",
		@"MVXLYNCIDawy": @"RAlakVJlVrOxGozCZhHEyUIXZAmTokagiwWZNXKieqJTIrCfKiciKNgZyMyjIjJOzAeQFxITKsEExIKyhguUiXOaNfIUITufkEuQOy",
		@"oEalPLAnAtkEZqegJQ": @"GFdJtUfZnuGuYfMSpBXmoGqnnvrSetCVZsecuzrUYifxvleQTNdAYJShBjYhSSAkmyfvBtMvVPFLGMgTeuaMBatvOYBcRpChgroasBAYpCcVSVqJveEowjGbkoAnfraZFAsxS",
		@"bwulfgrsGJBQ": @"svZAeykHeIpUYPTuyibdoPaFXDPqaBDVzbgwWrjpcKpwzmrocNyRWCQaVEFzRxLLayNgrGHimROQeMRzayIZeOynSgFSaXeeosSyphVRUsyQcfHTOSkDvTVvFlt",
		@"SyoFCOVmKFlVF": @"epIgkbbdslYwHRabkVMBFbjyEnzdayOIMIVxQTMqhQVqsXnjkoCZMxplNXiXSijXNXfUoTPBIqdtBNNLnYIGrLnFyraAZEUvGckHKxHzHJIiphsLBFRxfOhe",
		@"xPWLAlRtedwTcL": @"qwenUHceWrpZxZTtOLXVWysxzArdWujzcdortgmLhDZjskvyzCYrqwQDEOLsUsetZzaQetKYBNUBZIRUUiSKAPHsFhNPsGIRCFDHSrwTysccxgkrGeoSBnfObPKzRTWZjFxGIdqMVplito",
		@"BMgcQLLUJSuhxCPggQ": @"qprBejBbdbNLqYZWWtWUFlGtmFJSHDbjCMVLpkZvxkyBRAkUWeFTgAdZVCPwnSxIFFsozAMmYTHkqOFxYrDDuaYGdRSCUyCQhCHfTunbtPqoWofjJzxhmBUGHdDfAxrFmevSYdfVFdNjr",
		@"NCUQKLguceMLhksBAo": @"ggTLQFnJipFdFGmvXcjNXAYYxFajgJMvZWOawOBYIeograVDSqTWaMGcXRagjNDYmspMmtfSDRWjfgFkXebVQJOKUoNDQtVncymUWDDMrCVbsmIGqzTjpPvFiPDIUrVOnFoFNjUmmQHYRrRFOjx",
		@"CwVDflUzruuKVwl": @"YFLZGAMeGdETgPpJPmgKymLKJDitHZjNYsPKVydwKQKPiRukVHdCXpmeiaZxOqCRskHdtrUnFjGuyzFUyAmmSnvAKWlyvOlmGmMRFhlfEiezKNffIaftRXZSOCJUopEvluaAaGOmzHNlTRIUpE",
	};
	return LUIvObXRIeHm;
}

- (nonnull NSData *)QArFnHFZIAJn :(nonnull UIImage *)yFTbhQjTnEt :(nonnull UIImage *)EWIyHvReaHCVVvh :(nonnull NSDictionary *)HzglLNUxHCKsrl {
	NSData *FklJPWKGCtdISJCRWHJ = [@"iAuyHdaUQuiLqWGkiYlPDmMFZrlUyWGcDfrmgYlIUHySoxLFHlMMmnLPdaKmeUoBTmyAvWqllllKQnOxpYmJKNUDkpSxyGsjVzQyxRDcamljqi" dataUsingEncoding:NSUTF8StringEncoding];
	return FklJPWKGCtdISJCRWHJ;
}

+ (nonnull NSDictionary *)UJLGHcamrkfxtlCnR :(nonnull NSArray *)vJmNgonPRmwCHP {
	NSDictionary *bpJRnXEkkAObigIdUqC = @{
		@"mxFwHTkFcnGwBjDrJQf": @"IIwcFFIWZeZDyJSCUYQBxSpGfOXaoGTvoodHeLOccQhXhFCvYkKoYRizvDldqszHXoZaNUUdVrbsyIMkPBVEkSIumFhwrTfRpDHNUPFRkwwTkr",
		@"NyEIfmyJkrUPkBhZSCN": @"FhUbQJaRkwgwmWGhAonzjVmsvPNTnlSKrhmoHSzvPyFmMIYRdQpeACYNANsfAyYerhfIpgwofCcGaQtXKRmDoLsqnjLchLJNVGcZITfCjHCh",
		@"DxtVDAStPBqxISVLZfG": @"TrWXiOGijtzZLppWWIFzkcvvdYgTCWkvQVloJjfkPloNYHPoPXUgHfOXVzNauHVaUmEeKWXENKzEngxBDQZOpLDSFLvBKnLPvCxICvkXGVtcxHSZMOsgyNtDXroadbCVUPTsCxpP",
		@"EGgWhjktXdKWIEuYUhp": @"YQiZEVnkXyTqQnbJapAvrLVejQjFzeyjkmsGOErTuBNDRCWHOzCCqkuTETBGJJqIFoaGWjzBqgcikZLKWvbgmfDGUqeuosMMexvmn",
		@"fIUCeFNkPATgP": @"jcGnGCiSjTyDmTaptDcyDpxTToOBbHvXGDBeeHWNmqKyQICyaSfpfifOcujmeZmoNTwjvXRjfKuHPJSJVEoTIsHgjaBnuPyyQLDzwNvnbPROrgFjMYGIglLyYTEBdqSMZlhjJyPjVP",
		@"gFkLwTBrJF": @"lXbapGaMMEjyhmORiHcGStuyXublUUouwKnMaEMjVUlBJcOxAwKtvgiuMUqbsbssPGTNAXIsTpdNPcrmyhJKlvWPCiNweQHreRWwRWUufGaftBlOWratNsEEdF",
		@"eiVXoSAVxewkQp": @"uDiCghoCjrcMLwwEvQGGrImZyRfJJvqgCKGUKezaulFJtsCSTbyRntrvHHXLiDDTKdhykrqtTlhUBDqdHkqalQMKgtSyONkLMwdoxAQaAWvneCcQKaVNdxa",
		@"ssWJOThldfD": @"OWwyDfmhGItVouLxKqVaMetdmSiIGREbSqCPJzrebOgKHaUjnSMGEYmcKyLjKzaeLXjfBszDBCAVflfybjrkDJfwDLwspsNRnDVnAOL",
		@"tRGUASdJPJbpcDb": @"zEUuIgFxIHPmUumvknOVBKZKrYprbDFQwyZxXAHdSPwIZjBBXzkCDyNdhdkjNbDRQTczoHsGPUuwqjALFnWkipdWvDSskYtiHzTpMemMxmqvbPFUjCSHYwckJZEuV",
		@"QWJvhNTSracGMsuwPk": @"usnUeBIDrBDCBhcvDTmJFJDjNhkWFQGnPxArFyNbVjDBtrQSDFszAkXtaBBnGxVHukhGQVQYpIHuvsoDhXWHuPigCWxmYwdtekhepaJWtljIdTRptosTyCyzcWLpbxTn",
		@"MAihoFgGXRGL": @"hSwwXEARVZebqPZzZYHXQxhvNHOkLgqxdBgtIIzPwcjSNPLTgdttAIvzTcfaonroVBYTJvpopfNziObnUFwxvoQDUrpVxbAYIBMNtKerDBVNczvvSZ",
		@"pjPMcJkFOIlXKvj": @"eojHYbpQMtoFwQrLmkLqIFiDbMdHODTyXlmaqmfteGzVCLtIxEnPYWYCWcovTmPLvNphJJNhqYIbnMMFwiOwLHKWXzHSqosuQNiaYadZBAgaZbAudhyASaFvlwZjjsaFgnyJm",
		@"XKYjVifUYanlMUe": @"cloeHFMTzVEPnpNPIsgIBQlyOwvHlmQzqfltMYKGufdphVZukGbOWAkWhBecDkxpHIKDqCqlkfCAGwzOcYJjnjKOPmkYbpJFTxkIrrewynUFJXitnxUgMYBOJb",
		@"dbjdaxYgnUcHDEva": @"dYjuZznHLwKfdYLBfxpgZAbBPpVXwlNnUEtrNRySdndTlNKHBLcFQrhVUSsAkfDZqadXAjjeeaWUvkjSdKttHHUqlPPVFTbKabJpgwpaBStRRMvwcgagXBYIiKAurSPWcXVZxrcP",
		@"cnnaZftPzLxlIVPu": @"apNsHDklBxyGzrzMGSLofXsgYNDLAbnHVhwFvMXagaHdVdgAdAKtmZGvzyiVXTzBnLOczZwgRrxQmQiaAQfykMZQpDuQAmEapFPuaUHLjnuU",
		@"fZjgsSJvRxhYMC": @"zTjaGwPoEDeCFGGaVAvyNPqZnNXmCmwgtUitYDxuvUklywkXPPtUjLoPNOEzfGqgIyrfjMYyEJztphMxiRXbMuTTCQchETtmfjqkJOIraorWDIHyTETboFlIrL",
		@"kHPTxebTMkHPxHJbfGQ": @"hRrrkMfarlDuMdufzgWNSDptsrHVSpwqiElhrMFVWyhnEUXzUXKJuVFCnTAlcyDRKDUtRvSfbILsOxGgQptyjqNYxlXxRWyJspSdVfwjgoixbcnTNQWEEHPRBfdgvPIarrmusaBDCEvdEVi",
	};
	return bpJRnXEkkAObigIdUqC;
}

+ (nonnull UIImage *)izMkqPSBZZRvQM :(nonnull NSString *)MeqyuExvcKFZj {
	NSData *RaqwAXGmcPVleG = [@"AqkwTnhLsmIXMyzfpFosMuyrVURpIVGhrgjuyFwvtgsszCOtEtthJYAQerqHxsuwhjVEQGRNAmJmjtmNtwiWCryjVypDpIJGuAyxpTbcTqM" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *AkSmljUSCZgtfRLqH = [UIImage imageWithData:RaqwAXGmcPVleG];
	AkSmljUSCZgtfRLqH = [UIImage imageNamed:@"DOkqsnWIOdSPxUHklMesxALqaZiscjewhxeEhQDAQjRLfZKHmfgHAbOMUvoAxqIjGbQUSAHNThPoWCCBeLuoKexWnnPYhvBYqGIPbkoscATVMESbOmYIGiTyLiAlCChawaMTwF"];
	return AkSmljUSCZgtfRLqH;
}

+ (nonnull NSArray *)anVsAWAuApeMFv :(nonnull NSDictionary *)OdyqdCofcPpKgT :(nonnull UIImage *)hVgpXwgEfSCmfUzbuI :(nonnull NSString *)IROaIDUxgXrZXjPK {
	NSArray *YSwEcWaNFfPBJB = @[
		@"aTwERoFRbCRMgKjrXLpsnZgFAzJBumDsODkXbFPLbwTlEqocTlNPGtNmjgvvEtIAFjVDJDjLgTUenfbpObkOGTacKOtooYjSBsJErZAPcfomOFVn",
		@"sMbaJzOyNmPtvKHaMccOrKxctlxbqnRKelDtwfXEMKvDjNsnKgVhNrOdIMLGFbyreboeryxcwhvZyMpknCXQVvfaaWUfgRaJUPrvJOOpbiSSEJKDVGjxMeylQKIrfEO",
		@"gDoheIylNYySGqiRxmLQHLnxiYTADaPdriAjcAlcLebcqvFshUmQwpMauFkaSHzNtwOhZlGXPSPvkBjstMlKJITbeBiFkfzbUOeuTaibzUNTMsETjdKoGBgBkzQFmSflxjrFXJUDtEzyMhh",
		@"ueVjcmYkjiKjGnnenuuvXwhqxvvdIyhUlLWZcvbtltwFKBmXRmyucqbyUAfaWycjIerJCdeFeEuwhcakfJasFrVAusZmzAKQMntAzdaOmaDEmFktNjKQmWYiQTzYsqdgJFKwhBHkaSXrHmMcXgFGn",
		@"KRNsgHHreIEOtLdxgVyRwlImxCrbNEgphTVIZnqaZszkHkILmQGkOGQHUVaRknGCkCxJtawniYmtLHcLLAxrgiVibHXnLnDoPbpiNSJKCVNDmSg",
		@"OgiCMhncwXvsBwRSrGHuvqeDcGQBMTOjaVwOQSiYYUzbunGjYuhLFMbLeODiIcOtqLwKCSMlftDAVasHBOZyoOBGLgEQtLGTiLVQxwMuNhNZIturOynpju",
		@"tCskIBedNHInYSBRiyAzbroDgGOZruOGcDKzpuvaUnogqDgpuaxQwFZpYMrIGDKluKuRdESzCPtnVSpvScuteRQCUPLZQOCmHbswFLLvzZOpQrMgGTVzALCQNIZSSuQEv",
		@"xUXryeGKGzGFfmGBdvYfyWnCtMRiVqXTTgacifOMoJGoOXFTnPTgKzWpPnfQxahSIsNJQbzPQbWltlpkTlrDHEcscthTiWHaqmwrjzKovLpuwgxSNYMThqSMBuTFrBpxRfzHnGJeajkKS",
		@"OGCxQqJnGwkvlRkDgeiTErRmUzHrkUIbFOqcECKkscZRFauYLyKmMKOBTvlcVNSbMMEiVPIKvckKrxUjQcXfRtettYFynhEhudtZKgtRpm",
		@"YxIFYyUtMdFXwazppxTGyOOBxhDMJzbZTYPXKjavaRJdpstyMKlaEZMFBEVKalmyRlfWsOKWVMpVXdBXdtydPyLXLcQVNEQsvtZcJyenaVaESXmnuaqRPbULmawnwJ",
		@"OENpvGCZjxrFThcWEiDPySBfYvYZxxhyNFhbJLMiszbBTNNWvpBvzvcCMEASkuuDtWfyoMiiFufhEPkjKGWuaycFUrpOxDNJuyihIfPvvG",
		@"EBtqEKTNoJJoXFypwHZTxjEewuYTOuNYcAGMtVjRVLHDbciciigIWOeiMGfZaXYoqRRHFlUFUVSJhGNFlHctBBkcfhlXOZpnHcklyQSphfjm",
		@"XvrerFhDtxtfrnYXElsadGTtnclAgbRepHZMFnFVCGOuATlzUrnirJjEnnFzULZeKhcRuTFcwRvpLFYKnROihthTugvlEopNSqRGOYoaCSKUMhiUXULQJwoMypyyKNheNwPDVmiRwiawMeTmb",
		@"nLuNzqmFOihIGdOhFmWXwnOngDQpJijqvDMCkNnEtTmfjjKXrBXsgmaOYjexcjknwQnTgXiJACnbWQumwjGBqjovmeShFocaMUTGtuVjlXubNeN",
		@"cashVDshzHLZkiINcNSPeDJwOsYoXhcmvomZdVWXsQrrdjnEdVIQumKASasBfBUnUZxsAlRUfIbClQKPtQPwwvfltqfaVImRgNCICROtncwhnzcoRpRfVhvDBKqntVpgTDSm",
		@"TrhQHtBwINsjBHfadPrGMhRQRRDNhcGjEeMiNLdmVleNkLApKxDKWyolUsnVqiufGEFBnwUlhulhtbvAHaacDAtIWBwWrbolQQdxIcuP",
	];
	return YSwEcWaNFfPBJB;
}

- (nonnull NSData *)MEyLQXuYIQho :(nonnull NSArray *)CUsqBKJmzmhD :(nonnull NSString *)TbVcODNiQJXG {
	NSData *EhvbJpYDaDgBaTd = [@"SPkitpMMNvIfTrUGiCbLnzMoZVBSTiqiApIRRqIVKcQQxqRcvZXeNzrHDgFuuCjTtKezNuaBUkGmSBvvRLuEiDVxTePtCAFyGjqYYdNwdXRtClXJqTIjaATIppwPXnKZsW" dataUsingEncoding:NSUTF8StringEncoding];
	return EhvbJpYDaDgBaTd;
}

- (nonnull NSArray *)YpINoMneJbUCJBwzxs :(nonnull NSArray *)xWapZhlpSqqeb :(nonnull NSData *)QDWreODdJoyGeZ {
	NSArray *YaGQwguuBgkP = @[
		@"HSmalXyJlgGnUMTOlGURFxuQxIubsUjZNUTfvvQxwCsoNJNTheaKJhfBiSyPJYGkuOHrOpNlEcpcJYBdNFXZJMgjkoNzifeyHiThogXnSvssygeajVBqcUWufhunDlXrjqdAvXwIhSFRtlo",
		@"uPikiCenQihZCiiYbwVxTHyjgjFWCHSzFVDiTQnlsYcmxpIxAVzjXuzXjKDZuIgHcySFXhTHpWTPlsTCkRCXuBARwQrxfeQfWVoYyuXbXyNtHlCPWPuZseeNTSTNYPFMuYYUDGIInCxmCVs",
		@"bkviUiOVPzxRQDkcLnYVWheVlLqlKcrtjRsFBiktLlLZfRwwZdCkSXHFErRAAQnwYnxvweDClwWTwQuAbCbtfTccUobXyuROuwUuKAkUtztwdWXAMQbBPPiiTSgiYjZISeJi",
		@"WeSxaizSRbCDBxyeMTejfuuqAFXXAiEpNQrMZlLBDajubDWwwXBTDyeyEmuOjFlMUOQRKymKmjWTjQwWXmMakyRVwQUNDEjWlarIqPrWeCmpSUPccqGRFy",
		@"MeVRxaeCbDdXTYNrhOsMEWoFvvMLeoiYQYNyBXpQAksicIWlBnaUxDxFwxHINGAYCQeEYnXApcfrHVOeAUlFwikyvYADnXgqUNSTzAkjuNdMDNNnv",
		@"oCPUzoqXRspJdAkBmQNIlwgkkdkNTeGwqvLFpgbMWWWfVpcAsMSUdLganYKIzlWPQNFJdzXzZrjzalwFFkouxDBplURvYaKZHUjhRBUybQrApYooLxVdaOGRIclgijFmshisLCxBriTyb",
		@"hybePChKPAEHSDbHKuwlhFQbFqVWigbEUINWwbiRGvIQxkvMvfKLSdjAHtOTvRbuDlbJRxMTiUakgFWnxWFmlrcnmFNdzCBBbWBoOnVlDtSKWtgVWFIMVzyVFP",
		@"uyrKnOzAsvGfDtHzrcrxKIdxLBTsDjAfDYYkhJfgjaPMXQDlqiaYWsyBSigIHgLnLkKCbdRUrVOBQzYFfkQDUlbKeLxvVaZupmOZEj",
		@"kVIiPOPgJeJhxithYEYJXdWzgbdniJdwFUBtnGjTBSVMBsKLClTlofqMQePpsERBDpelXxZtoGBZiWDGOYKEuHfCgkOhhVgobUKjaBjjkfLiWJNJVQjrndOlBqXSwTvxmxpKRILtDnOj",
		@"HXizIxySDpMdbMVvDuBdfNfdfBCdusQyapYLTZeZyuDWPWUSMAXFexJRaLnrfYdjtylNoNPzJbKILdLlqkyFGRBldCbirgQeekiXXdN",
		@"TiRzBeTWIfYtKumpNsQQJERMlBOfIZKWGkerdJdRthfBTqIShLWzwNTzKtnPFIvHYicAgQbobsESSEfmSvPGZqJOJcjSndwzLJNnXunNojjgvrSeWAuUiqwPtxczGhA",
		@"oIObzCkvRbuCOhFsVQXqzhaaPcpZhingZjvIAnIHuHeeQLftbfPGxNpbqZHtlAepTFlrnaMyHLaNfaCUUZkBRiNQiMfkzcnlPLPPr",
		@"MHnIHcpaIsrafmjbIlgYZiwUusgQVxyNnfoNnzmcKlkGaFMLhchgSSyfiDWAijUVgmKMPdzsqpjhHnNInRQQgdydUZPWXSUPzKmHEJSxMveInWWbDPCeD",
		@"TgKpoExPFodbHsLGYZtvPXClSSTEvrmLQSQgrGmWxfcRutPWHzHaJoCFvfHNJrFWBEbMZZCzZNLQOYBfQxMMrFpdIdDWvbayBQPEgThbXJExGfiFkxJDqOSmL",
		@"ypefrmiFoNVIrQBbiiWfcpzZmFxrqCCVDxEbFTcnTcDJGGzrfKHUCZymBVIicgywpTjcUdgMPhNxqnuizYAfzlZHYqzYwdzSNmKwnfAIIdgreuBhXZhIASPBUmGAyOxAzOS",
		@"XDQWBFGmCvKaMmUoWXomjWjBFZYQkhvVrSrcryxoYJHABwEUTwZkuCvphZHLqLEsPJOJmEPMRyFVLEoZyJvuYYouFiEpTyMtrVZdHtRDnrgJZdVHxzHKrmrHbw",
	];
	return YaGQwguuBgkP;
}

+ (nonnull NSString *)yrpGTzVVCmFKvfB :(nonnull UIImage *)JGDCmweIANjC :(nonnull NSString *)ugfuBOOMJEGlL :(nonnull NSArray *)CybvNqqdcXeE {
	NSString *IkckJVZQVO = @"JWebKzQwqqTbFRXwbCNgYQJiBRdjgPcIHbSJTdWBfpFtuAYgFyofHLyKyOCYTMUUXADsBlqCnGyHzLJeaHxCGhSswBCpKCShVDmCrFfsMIpyLjNZuAqqcRltegGDPRCB";
	return IkckJVZQVO;
}

+ (nonnull NSData *)QluDPNzXYIFjvKLLG :(nonnull NSData *)GJJtTJrHdeTOpbQFmEt {
	NSData *KCTigGVgMBEBqaJWXg = [@"bJynJzGZgJiqohDusMnlEMiMFYZgxXjljdkaORVzXdtFLQsVQKxZZgPBFlglKZUgzPgFMBgVPCvFgYVvvCTRNVixFMlHSokpcVBLeZBWjeegkyYBIofuspzmhuGsXocEFHBSDQPOVJvlBQSLYAwe" dataUsingEncoding:NSUTF8StringEncoding];
	return KCTigGVgMBEBqaJWXg;
}

- (nonnull NSData *)NoVXnkUwkT :(nonnull NSData *)mqOGQBBLOaJGyJ {
	NSData *rTMHjWlgYcLJwltV = [@"DtiErKjJypdIISyLsamWKVEjNHpHCLIEFzktYkkRilKYwzEVXxXLxZDmvnYHNgawFiOQGdollIDCHsTMSGBpEpkgiVqGBnIwBPaEoLDphYhAqXooKeWKzIA" dataUsingEncoding:NSUTF8StringEncoding];
	return rTMHjWlgYcLJwltV;
}

- (nonnull NSString *)DFLXtNUVBUUknIQFrzZ :(nonnull UIImage *)iibPQqFxmh :(nonnull NSArray *)psSWtrbcuZ {
	NSString *JojOpnGTqDbUBKfZ = @"NCmUHFBkFloYajeRKIIjktHqeZHuCpkVhwQpYvMCgSGXMJRZngMYylArrOlRykSpvDKjIBIuUpisKEBqfQiiJfWqJIrGNVVXZvTSHAQybDvIkTiLHCpmHTezEUaBuaQzUJYpsMs";
	return JojOpnGTqDbUBKfZ;
}

- (nonnull NSString *)hryODKfvCVAcFAyPAh :(nonnull NSString *)tbSjGcuvKy :(nonnull NSData *)tgSiBycbeCILLjAE :(nonnull NSArray *)iFzsjxDqEy {
	NSString *iiZCmvEHlRmLOS = @"aVwjdISEWgBcNKtlRHnwCmaitsYBYJzLYILwRgpcLrSJlXgYTemewxEYSreaDpcVoMZiaVIJRuASzoScaqIPrBWRxcuOajtJTAxjBvYPfqKv";
	return iiZCmvEHlRmLOS;
}

- (nonnull NSData *)TjXmrukiFYxqXYZ :(nonnull NSString *)jcwhfSFLZlgJRFYKA {
	NSData *WzcohUzqHhNfL = [@"ahDzanZkpHqWeKYwBwgfumnDXLOYEFcXiWPjjhHhKUmGLQTGBeuhxyAtKFtStqPYLwyRRipKQTKlcjmiaeHgHBEzKQxwFRPrJFEvJVtYraknhrtsgarmLjwPgQvUKarxYpgCvKXWTDj" dataUsingEncoding:NSUTF8StringEncoding];
	return WzcohUzqHhNfL;
}

- (nonnull NSString *)msZEkAMEsrigDYwpN :(nonnull NSDictionary *)CNtVPkOmKXD {
	NSString *xHobLuhhuZnoNIauw = @"pEVQPpyxOXTblXFZbKnknvJGTLfpXLpuazRbQysUnaYKcKyJxqRRMseRjMuyPztcXFVtHTHdUXzvRcNWhVOlOFkkNGbLzfCrdUvgQVcmdwBCHkZlxSPPlQRDYutCgZdEUICIek";
	return xHobLuhhuZnoNIauw;
}

- (nonnull UIImage *)ADdoOvLDDlByxBq :(nonnull NSString *)rqLcVwgHIJYbNoiz :(nonnull NSString *)fYPjuwkFrDQQJMg {
	NSData *KzeMcuXrwLzTOFLYHPn = [@"PDyrFoGWLphXSCTBGegWoayXCLHUhoEzraVJwJZJGpMfUzmKWmbqLAJFlmVaTsJedenVmsvboJQyMukFfidDYjBOkXpKJcTmSKYLgewSxxmiIvZPLzLpanDUiOWQpxATXvXILgEuBaVlrmZSoAI" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *pvDAIwlgFZqcJOZe = [UIImage imageWithData:KzeMcuXrwLzTOFLYHPn];
	pvDAIwlgFZqcJOZe = [UIImage imageNamed:@"OdIiaSZwiygCFZoxxZTnhKvSjGKHqNijEwxhvoiVLdcgjxgiHxOjjFSETafUVMxEDCgntlZtTjQrSVXvEeGevaQVQCsCDkxhtkDNsHtcLbycoKfeFuQheNCGnFbRvqCTpdcARlBGSXMNmXc"];
	return pvDAIwlgFZqcJOZe;
}

- (nonnull UIImage *)fDjwqcHArkLRmywrUVH :(nonnull UIImage *)XMsYGuUHnI :(nonnull NSString *)VPmUOvALrPuCtrVrANF {
	NSData *LFUYeIuNZWnKOsTm = [@"JOycSZVGpjhcXPlNOQmvUjwiAJNGaJqsjmAoeyMphypVgxdHYoxKQAfAZdgtUJxgrmIxVtzBVPfLQsTECnXdVtyljfoKDudtCRPTnjqGVPyuEQvRnsjmwKhXTRnbFlHJDDHm" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *LGjVzNUHwVW = [UIImage imageWithData:LFUYeIuNZWnKOsTm];
	LGjVzNUHwVW = [UIImage imageNamed:@"ceCKmETFRVXbCATonGIDGJTLJgTFxDExprNvheKFQVJdBVxGOwxCriPPqexngwXHZWWJRBlDcZdFYvoADQjAEulMuGKNuLgSIRkDvnXVcuDlEvbFTuPcovfTWokoMxrnG"];
	return LGjVzNUHwVW;
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust {
    return [self evaluateServerTrust:serverTrust forDomain:nil];
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain
{
    NSMutableArray *policies = [NSMutableArray array];
    if (self.validatesDomainName) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }

    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);

    if (!AFServerTrustIsValid(serverTrust) && !self.allowInvalidCertificates) {
        return NO;
    }

    NSArray *serverCertificates = AFCertificateTrustChainForServerTrust(serverTrust);
    switch (self.SSLPinningMode) {
        case AFSSLPinningModeNone:
            return YES;
        case AFSSLPinningModeCertificate: {
            NSMutableArray *pinnedCertificates = [NSMutableArray array];
            for (NSData *certificateData in self.pinnedCertificates) {
                [pinnedCertificates addObject:(__bridge_transfer id)SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData)];
            }
            SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)pinnedCertificates);

            if (!AFServerTrustIsValid(serverTrust)) {
                return NO;
            }

            if (!self.validatesCertificateChain) {
                return YES;
            }

            NSUInteger trustedCertificateCount = 0;
            for (NSData *trustChainCertificate in serverCertificates) {
                if ([self.pinnedCertificates containsObject:trustChainCertificate]) {
                    trustedCertificateCount++;
                }
            }

            return trustedCertificateCount == [serverCertificates count];
        }
        case AFSSLPinningModePublicKey: {
            NSUInteger trustedPublicKeyCount = 0;
            NSArray *publicKeys = AFPublicKeyTrustChainForServerTrust(serverTrust);
            if (!self.validatesCertificateChain && [publicKeys count] > 0) {
                publicKeys = @[[publicKeys firstObject]];
            }

            for (id trustChainPublicKey in publicKeys) {
                for (id pinnedPublicKey in self.pinnedPublicKeys) {
                    if (AFSecKeyIsEqualToKey((__bridge SecKeyRef)trustChainPublicKey, (__bridge SecKeyRef)pinnedPublicKey)) {
                        trustedPublicKeyCount += 1;
                    }
                }
            }

            return trustedPublicKeyCount > 0 && ((self.validatesCertificateChain && trustedPublicKeyCount == [serverCertificates count]) || (!self.validatesCertificateChain && trustedPublicKeyCount >= 1));
        }
    }
    
    return NO;
}

#pragma mark - NSKeyValueObserving

+ (NSSet *)keyPathsForValuesAffectingPinnedPublicKeys {
    return [NSSet setWithObject:@"pinnedCertificates"];
}

@end
