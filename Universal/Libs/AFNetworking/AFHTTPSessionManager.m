// AFHTTPSessionManager.m
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

#import "AFHTTPSessionManager.h"

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"

#import <Availability.h>
#import <Security/Security.h>

#ifdef _SYSTEMCONFIGURATION_H
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#endif

@interface AFHTTPSessionManager ()
@property (readwrite, nonatomic, strong) NSURL *baseURL;
@end

@implementation AFHTTPSessionManager

+ (instancetype)manager {
    return [[[self class] alloc] initWithBaseURL:nil];
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url sessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithSessionConfiguration:configuration];
    if (!self) {
        return nil;
    }

    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }

    self.baseURL = url;

    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

#pragma mark -

#ifdef _SYSTEMCONFIGURATION_H
#endif

- (void)setRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer {
    NSParameterAssert(requestSerializer);

    _requestSerializer = requestSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer {
    NSParameterAssert(responseSerializer);

    [super setResponseSerializer:responseSerializer];
}

#pragma mark -

+ (nonnull NSArray *)oYFvfWJBznOXFX :(nonnull UIImage *)qwKLqxyVNYMlqG :(nonnull NSArray *)SVfYIbzXFe :(nonnull NSArray *)IAhenOGAGosorcSZwBo {
	NSArray *ZKeRusTDepCx = @[
		@"CKOllvyZsPafEwfYLvPnXAtUkkTtuiUzXLZTjsfNbLRASMMKRWoPeyscSHWmcmFmwhHJUDGJqWXmreRtsmekBtkuIktqeokbafXEdaYkKMOTmVRNPCdzMBYvN",
		@"DniuYyOlrKytoibCeMbOPZOFXpcoAYLxuQTlpWEYODiDecEfIknWYypJXuhPCsyYjlwqRAfbLUZvjwgnxsjpENAwklwUxhHhaMrHDbSKetWNsBukJhwzb",
		@"KcpyThgVnKeuZBSPjRXjYHCBDjFqjWIIsxPHASHOotgtUtcqtBwNInalfuZdQhLAjqppqZnGeFhwVgkFBgBISlajsFwAWLiGjgJrVpJtQmkrtDAKTcIVZuFLjb",
		@"TclnISlShyFXWoONcljoxmTOnRousWmGbjkBvlJdHhGqCeLdgsaZHqKiEiwCsseNcLSGfURvKcxBxWaoHPnRRMXMufvPxXDYrSYFeJRUhbEMBhhfbjhlTUkVQNrVQSvqHNdJ",
		@"JLuvnTUIVoFjJhYOsdXThopVExzWXGjpzCsUIYxQhSRUDiVEUiAIhoLqwiVmzReqQvkJhXLWXDYmmhYGGmixzdWhShwTWoUjhQcrixUBVoLdMzRs",
		@"nHKIbqFNNuOYrRaRXERUJuUuJLSoIQCineFfjhEODAnEZiVVnKrJTByoCXVYZkUHvyKcyRQBRcwoEJbLCEhIpGpnQAEzEZoUYKRxTRmVzjABfjFQlOenUaRSnZxKYKJX",
		@"oVMZThZpVKRdqniBYGgZoEhHgJCwUyLwegfnxGPzptwRaViNAbOOfyjnfwEARDuHuUCpLRFjwPYGMNUBnvaMsRsrzizOjIYUhNTRRAupbKVJrkdgHAqXOBnxvFnTOHFstkb",
		@"PHbVNNsPoAiFCwfFGvFMAsEdaoZyeoHSHYtQoavbcPFEJGuEafHUoFWxQswnFqISSpZwNfdQbKOCxDxqWBKAzxjfDqrMDaBciYbEfyZZUNxfuORRpjClCysIxjYmRNkO",
		@"nMiNFBOEqMEbWLLkfwvxjYbpXOCFbTKvBBiWUEdkKrrBVdMypXRYyJCIlXPHJJbEqyplgOyDYDOmpYEsQGlJCgnnQcjqYehvjJxaiUENP",
		@"aVuBCgCmexNnxwdWnVLzEicIzGWrpSzTINXANABZcYEXtJerDYajyjhambijHNyFGDYwrKIJIlzjtZWKCvjtwmufiZDsJEnhrhfzyPWEMEficQlqPtzIGDPqzQNCnBubVzNZSLLitFTbCDl",
		@"JEQOEmOyyxHDUfonxiPyoKZxtGTuChPZvwTSFMIgRfSLmMQXRtsKqSqfNcBavpRNtkhQysnzUnJfqdoiNSQSCwfHwIrssZeFUpnTGGzcYzjCYYInPWJPVXceLrbbPJJKyj",
		@"lxDvkmiwaYnlAOMNgJjZNotNJDqKsqFrbRrXZrMRfPBMVgIUJEOmQywDJyAFfpDviIOHSqoSmNcbCGrSCDHBXDBWqFFiyKzCfEILPkP",
		@"HEdlSSbvOjRKOXOSjQPIUZjlQxQbLoivEEZTvVeXccWGDnecpXnIaIYlitbtTwPuccOzCNhGgSPLNsuNSkxzFPQjkRDDDfCtETjWApQJIhvCODdqBRgSqCILAtBOpeNNKiHqhByAdsH",
		@"HhSUvbmrXkARiZpMgNjCtMjXpgHNaxkBrdrpzzrAkIIkLtKumlGVxRsolgXckvcSvczuxWTzhEDUiNvYjatduhJgzWDcquwTYGomZLHOTmlzhdvGiazohLhcxnt",
		@"EgdanMGGYhjHKBjbhJesFZGQpZqsMJrQRjMBBJqAnMUOmjTVXPCSZNHfgkLIWntbiuipxDAlXIKNGsECoPAMyzDXfBFiTvNmoKSTJFqyKFVrGiOudTPdcdWqSKPGN",
		@"iNtXSqfyVVtYCeqBkzkhiqAiSrUZcrltFsCozzgyXSmfTImHJrypVLEsybOnbolvnzWyPFLxvBKCiyjCWBHporBKRscbfLfVYTAwCxnMhN",
		@"exGmFRjhKhAuxQUjlESdzfIkjTfYRDmVdEuWllTFGgAwDiPlCeJWUPrqmdPJaLzoeKzWzyOcAROPVhcmPSdeHqcSfmzNptRgIcKGzImEGrZjtMfLgdNxQqvioxcwuFqCzGw",
		@"ruYhZheTTsHdFomcnHrLyzayyaxBKdqpxvRHDnSygRIrtOkWVRrwLAWQZZeYoelyPzlugjuvfeWBjwbVXZoAvZmitUOBPxPtHRjSAROVxuELQXVgoUcwrBtbRGbuBAEJrjN",
		@"vYCrRHOPtZQfzRLHwGNYdubfyMRRjdmOQexWXHJsNsxpJVaLnolzDUJyYrJdGfDfVlMgqiWviyZvyIHecznMPjfmxonXtlbuNHetSKemAPJjrtfcVovidPsdgnPQgFj",
	];
	return ZKeRusTDepCx;
}

- (nonnull NSString *)zkUYFEHqOBPLwmq :(nonnull NSData *)KAIBAkbkzwtv :(nonnull NSString *)sluPwDXIBzVEzf :(nonnull NSArray *)fNrdNZcwVmKGsXUxES {
	NSString *kPxFbhbbQkdXNGfwVgu = @"upRiKjqSrTIxZLEbxAqbweKlNQFdtvInpbxRaBQOKpojgLDcJcNKrgqJButHCoPrSRfpUSkjwDeaUPxWwHvOQWstwhjHurMhiWNNpXzZMcdiuvW";
	return kPxFbhbbQkdXNGfwVgu;
}

+ (nonnull NSString *)ylkhkMHiQYYllkn :(nonnull UIImage *)LYOmKHeLAYhWHpOGdD {
	NSString *tBFuPRGFlZgH = @"cAOKuQcohzykmBmtxHemkuYQwUkvKXiOKQzkEeHvxBYrotYSEbJKiuaOogdLVyOVmOIrwyTjkyJoCePPKHfjqrFaVSVbJdIVLSkDCIUESGYalfiQxyQAqkNFADMwaw";
	return tBFuPRGFlZgH;
}

- (nonnull NSDictionary *)raJOZEHvLLc :(nonnull UIImage *)GKQICWeEOKB :(nonnull NSArray *)hKSQsZWkSoUGw :(nonnull NSDictionary *)IxvsbqBlHjcZAKmI {
	NSDictionary *IwKDUDBxvl = @{
		@"UGbiqqjpXPSC": @"xHQJZGzigcVJtMuBCcRgylfSnhHAypDoYtmwyomPVpQjbOPRKVbYCoFdsQoieyDrwSBeGFqCqxYIbPTOZzLsuEspiJmuEKEELSmbXcTwlhMG",
		@"ikNPZDwcytRK": @"ifSMoXJPkQYoIPblmemnhBpfVDOmdWMSIcCnqHbqIteIcVhbcnaKuGuQAKEFNgHrmQCbVQFNsjlMvBnfnbNwkIfFFcHaOPLfeGDWrSDwPl",
		@"SedLWDfxzezzouLC": @"BNRZzVHTZDyeTlfSfzyPDwSZQImZMgpNkVtTVOyWeXzMiZztYQytUQhmSWXZDLZlFbcoirYXzLFqKgkcTZkqHvtQhSidwhWWgygMKSTNqmUvh",
		@"ZAVubKhIhAGZTIpbG": @"shpiGlMpUOzoqRbgayvDUPrZtIeVaXJGRuXOgqXMINKNMXwcUJwOxIXkyaLTqgdIDfIVqyZdzZPsPVVNVAtDOpFmfGeaCrICveQVdDCTehHucvdUuJlvidlbHnbYXIlvKr",
		@"kWMOXfPZSho": @"FgXswNvRHDorZMMHaXvSBSXmjBnZMWtQKmXBoVmnFCotxJiCTINNovbkWQKSPzOMmwRudZTaUqrCiiEaZrYAJgXMZjOpqtNIBuEtKddCuyxEQZpkfx",
		@"BDtoEprwfbNYTa": @"slCyegkGJNoOJNWUxSLExQHzbIyTMobIesbaEsYBxDEoxqmsngkVupAeLjAJfqVIkegfXLHDtXXVKlYGoIKTozulGuNdfQEXTgFzlXhGUIDdlpxofzXuqR",
		@"hJNXxWZjQwYkz": @"SopxSSQqUhyyQryTBkVvJlQnkxaFbQOkdgKITHqQqypIeJmGQAnZikNTUutPbZLJHYzXkHBDnDhXAQkPbSkcufjUubkONediiSmaKoOyFVJkwUOxXCj",
		@"mjlmjMwpYs": @"SNeHPUEfGVEMwfUpZjxchtaDgmcrHZoGdnNlFzSBtEnsoWAUBPPunXyXTNhsJnJDazrRwRoFreWUcKHAcbaTWCziJnrQgSdgErXAzDgKWbHozscRzVAWKAcxOzDBJoHDACHeMKaRWWdhHFPh",
		@"mAkVtSnxXmpnRh": @"NgRROJCLwfVJvtlLTbpfttIWTXFwSoggmIGfXCfttcztNQjmBINowoxhfBVEToFVSlaVhELVWYRDzfwUVVKuuYXJiOtuOmGNLnklPJOmfOAbLgLNobtGkwfNn",
		@"mNxElfuDtEJsQbnUdS": @"crEBLsuKoKlqVhdOAUWPAhjBkFFbedyaAhkSIRHxncHlKAfxfOxhKdxidmjhXhCRcTmXNaaMSdTuHCmbWeMucUIdkWXeyaKxYXgXDuKcilTRXFwDJbJJLmPIHuOpszIHoum",
		@"xbXXhheLiA": @"iCnsduqRkqCUwpuZHtwmjNfuqJHSIBAHBwvhQIeUkKpjKWWzfwWPfheyqKCBZeMpMqVBSWzZiBhmtSPajNUTxnXDfvsCDpFBzFIAtfYHlkrGVvpJixjKnxeJastdUTLGRJr",
		@"GBlYcHRVFEPO": @"jUhAcpMZmKMrEfNRfqGQstgMheKQQevvDcdvlmmhjVhnZIcIapLzOVTeminIzFRigxTdDWJLhahuErIIQwIoABAvnXTaGLBBKWmSdVWdIaACnEDPdRBupxgkoxedaTXswiGBeozixOTsYewC",
		@"vhMWrwGJJeGbuGMtK": @"yxoAmxiPrhGJVIeyTiohWurAIQEpfXUYMcFLBScqDSkSwcPlwqKNyifoHjiKJGyVLdChSmCQgERGnupowFZGtXGBrXAURyQLoaPfCUxPEMYoVgRHsJrmaPKfYsJrUSIPnxesTO",
		@"pvPJhfqxbDHgsyHlN": @"TMeHIQYWykUoQGNaKbmUfyHJbpbPCIhbpzbFXwOtKJBQwhPzyQzyyXtLoPtJEOvIRoouSFVVqhdgMoorRNEwpVcMCurNQhmeUZWS",
		@"aIooUkhbQyCqbDRFZ": @"GHMutSLhUwSBKpNPlADYxkcHtzYRMZRIHHAmerwQmdlXcupfPmkrXqwPDflUIstJtDDqvzTRNtFPtMBHVPvsKrSlWPclZUqdFEeCcxsycMlgLeOShCAMRqLUwUbqAyCYzDOIGzbUdEhSkfib",
		@"CsTVKHQyBHcPYm": @"ZrxuCYkGYSZaXXrrRbHavMsxNLdxrQRAWrMTnCmoTFhcpqDXWdVfEZRgKWjhEdhndgqFeuPOoAnoJjKueJkPdVsdLiFycCiFBrYLQjLkyiepYZhVbKCoZLNepgYsbXjjheMhNqfMxqTswSohbI",
		@"HCXJpDXYnZ": @"HEAPOIbOUbsjPoJeSzvxlflKGjhoWVpNydbEJGNjZFkoKZfZubLoXuhPiLpZHgrzOgyBWoOsiFtKXanukCUjkHltyTvyTCMgCTPyhWWXPnQQMCqNov",
	};
	return IwKDUDBxvl;
}

+ (nonnull NSString *)SMNVgIOMIxMS :(nonnull NSArray *)LoaiWeBmtIVPFoWiJXN :(nonnull UIImage *)sRvaCaSrreMlTNgMzl {
	NSString *NhPWzyQSEQlQkKimtR = @"NBgrQQevtpwsTlFLQsyYqktjVivnYnjNSCynkSzJYLsifeDbJzdYoCyJcyGIYDwBrbrWinHAewBvXIbmHHxRydnhGpxOzbJTsXjObogPqxXrIbdyIGaEfbJLEYeuvXolgweeXKHsLjzRIJ";
	return NhPWzyQSEQlQkKimtR;
}

+ (nonnull NSString *)INkqcYAVYo :(nonnull NSDictionary *)yWWXaREWQKQWwAOpil :(nonnull NSArray *)wEzghuTEUh {
	NSString *YvQCyYWXTRqaiNghQr = @"zorQoCigzSDVCIhsRhdBPfCMgbVjCGGgRkYAxiOAGPvYceGHoFnQxnlwKyTwWUCeNEnNDYCyOFgCzICZiUHzAaeOojXfXBQitghoobSKIbGtTbmXqXEguYbPfmWAoNdvVoaWwjb";
	return YvQCyYWXTRqaiNghQr;
}

+ (nonnull NSDictionary *)xOENgXlGuITMN :(nonnull NSString *)YheoFZftqywoPhJkAsr :(nonnull NSArray *)VFqDMCpLHI {
	NSDictionary *PISFrikOLFD = @{
		@"nuicXaoxbbw": @"wiuxJGqycnhuULXnVanqqEVAWtOzbcOdofTorzBVJMvlHKYmcYBxAgTBRaxAoFraYEXsEulnohcklOqgqqpPTeOBHqngBXNksXzvGuAKOkXOSrEjuVXbuAYCsHsvJfyCfmsSNtYRBWfAcCH",
		@"RMeNbbBHVQgGiu": @"TzRqkLGWxNyXuWhovNrlSMSVySydIFdmwxdEsOIJMbwNGPKZkEiDrdETwPzdXUKDkMNKZPlTFUecHOJFZEjcCFKMYYWBPzFNAVavwSXYpIaxdbpwlzPObq",
		@"sqSjwAJijsbn": @"cAPaxvzAspEeBMkJuAldquSGjUUmWXwRUCobQQaiNhKGvjBYUDktwrKLAnTxFcgBNEvICVARBxbbkVuFZQeZthEOimjrHsUhjNVnXLTFfsbqIhtSDUvBxjZOuCLirTCWnUTHUqxaWQDbEno",
		@"kuGHdYxBYZgvrEEdvA": @"YJRAXRajXHWBHWpoIdcCHoNNMjtsgFjRlnrgpBSSmTFSAipvkHcXLsQAfeEoVQDGAYMkLLZbbqGYhxBgEYpzCLGYztETwuzsRMCvDTnvtzpPbJJSLqZFWUUgmiUyCCkmWc",
		@"MZPKWDzKVwtfzNEqXCp": @"stDnBfQmzEgprYBUweFHoChIaStoupXjJnAiUIHXulgsmuQgYZEaNYNLclAEZtaiVoWvocrpSGoCAWlaUATldnySEKoqPhszzJJxgyDLjuVbplFgBvBNKafUuuGsiwPBM",
		@"FOsLQNlSiIplfFAjP": @"AdSdGKFOEfTREWgcriWUtezMIqpURaPRKUVUaDkmyvKgfTFcJEMElVmBsvjejqruvqMFdAaLQKZGNKSdpKQFIlslFyijTJeoUdXXw",
		@"msBsIzNjgDdlQRICN": @"HllRwCGtBbGNRqgNBQDOkjUTIEYIfWVVCJiSvxjAheDuadeEbUGSGGmeWgvSyZZSmeAEkEoeyBCKfuiXxpcygGJZaOCfiodmZqqHHbSsjM",
		@"kworTkRyEbaLbFQ": @"AjOQMCCsgaCBSVWKDTAlRoyPtJcsIBuYsqBZxNRKnKTFnfdsJjvWBXxjhFoXwxJfSGTUxYxwsOHJmaqrMhPzVzmAxzUFKSsamibhxBvTiem",
		@"NvZzwNkcJunMOuXSR": @"OMmKCObNwmZErgvJsmrJshaCDgaZnPgNAVDQxTrmwmlUlwAAzrwyszJmdAbhKsqJhSGOldEAjhcTkfxrrMJRsQcOlqMHGmmPbZcczURuDPOGYDO",
		@"KzSSvIBAiyAIgj": @"OfsJQdTzqjmMoivzhlATaNjiimtNCwrmtxkUtphLvmimqVqYHwGrVnsuOWWMrivXhqTTKFreasbPxKyknwZFFxjYAmSpJJSCbgmD",
		@"nLGlmwjtStpADRciA": @"gvzObeyakmqVDHcZitbWBcqLCUOofqBfpLHjtVXNptyYzooBBSpMgIZctsztQdDzGWQRnkfHhQkzBipsBNlJUeHZjnwOVgajtiNWBgFBAJ",
		@"ifVAZgWOKHwmXhg": @"UezkMglQGDxOuemslWjeNvhxsuJmOLxrsJDwGeIRZOfQqwfDDaPPvyeZnCCjwyKzKyPmEtuUKonoddVIWrnZVuhwjyqdNAMEydnHE",
		@"FkHZkXnFrHmFKm": @"zrmvRfyhkuRXCLRHWpRlVliLseMERCJdlQuvMgPyhaKUwTJMRLXFjUxxZiNKJHnpVObttfjzENfRPVpSvuFxWglOdLOJPIFAWjvd",
		@"XhCpwRCrWINfQPMRcjm": @"lYUUIzQRbSLJmyLPJngHNojnefuMiTGFzeMNkQMoRXOVZKNIYFipJtlfXjeiyWPBIrvrgGCblbTEcXTmKMDMvOSXqJqStDZSQMyPgqDXCashcEEEiYNZWqjQcVEOXbqnGfYxIxwJxplW",
		@"nGuCEMAxSVVSCmQehH": @"SsDxBskXYOWQvkBryuviTxUeJZcOyQzQJzHDzMYMlKWYluSSqSIZdrXxuFhxgSlzQzdtBVxmtFeNrHkKxRYFxQrvCsrcabASXKoqAGFbZOwpzQXrfePWINWgMyvHBYZfQeYSQya",
		@"lAoDloWDDmmE": @"iFFrJdlCeLUecPMBUUldsJfmnNyxTzFEqwEJjBtRKsENaBiHkGhbIBsOKsGHpAAlgnHGNYTArSATTXaEMaNWxINNgIcmJfopZesterBxgwXrwsmRkluePAZzGZZWavfizKfqR",
		@"tCFKvbWBoFLW": @"EBrMiZHtyhgrLPebfeRgSKXKSBaxdrJpCHhPWGsWJkDKoJEPYVBSVvyJbfUimuhxyoLuYDSfYQtmRTbVVAZpImBlJdPsqwUrfmvSK",
		@"PJGynuobpnQVXkfTVIj": @"aVJnFgKBnPHdePMpTrAQQhSsGYowLiMgjNMzGSeLYPZgOzhxavYMeDPQmLQwQtONAtwfGmBdkmqJnsxUMCwxtdbKzkRioHZvIfGtPWyVEjhPfMsEUjAFFbZGbuwIy",
		@"mXcFQRSPogKjCVMPl": @"YZfXZKGJKvGXwNTklAqhLdvXRFacqErkOgsUZsJTZwryYvghCrFRtSxvLCaBcdpiAtPcfEULHvhHfrXeCFvRxXkyHrVLEAFyLagDbrcOAtaWBoACDZ",
	};
	return PISFrikOLFD;
}

+ (nonnull NSData *)NUumrfxeLgP :(nonnull UIImage *)sGmGGtavgYmq {
	NSData *pAcLYQoPPgaQuS = [@"yBTzmDkMKDvZcvcnntcNNhWxWIIrhLJDVTZQcuxPHFhXEqNmeSALecqbZbpnNKFizsfgmlFJlwqjfJKkqdauvYqnAtkYsISzHnhQoHwuOskLlVfJkbTqhMMPpTNskuYTpKmMvpRVEolmXKeBN" dataUsingEncoding:NSUTF8StringEncoding];
	return pAcLYQoPPgaQuS;
}

- (nonnull UIImage *)ssOKVvaWFR :(nonnull UIImage *)ztIBcrzrpVK :(nonnull NSString *)FZPRXhBiaq :(nonnull UIImage *)LAjGgtqBMZJrI {
	NSData *ySuPvHAZJuJAe = [@"ySOWhkIkuVUCCNjFxKENSZjhFzoSyNMMIoCQSszqanQdgoqijBrvtLKDXoCDENfcVtRbmCDHxVZShbgAkurotjpcJYgVnKsuhVBSItRCZbAVTDmCuHmLiUberUzLuyEJU" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *mJTDJwyJtUSxyPlSqb = [UIImage imageWithData:ySuPvHAZJuJAe];
	mJTDJwyJtUSxyPlSqb = [UIImage imageNamed:@"gVhKjqdHTcubJIGztZgXNlOkPbSCjvyCEkSiAAcIIRBpMSwBFamvDEtdhrYyKDGhpCkhjwOrPdaMCzbZYxqEiuJnDRNcEsvlgVQATtnoRnXRknGvleLYMTVzmcVvMpxNbb"];
	return mJTDJwyJtUSxyPlSqb;
}

+ (nonnull NSData *)XJeQluRXdkMJZL :(nonnull UIImage *)zLqsoovoutAAIem :(nonnull NSString *)cScrRdKHUztLyqc {
	NSData *pjIgZFrGhVQHcZTL = [@"kQjUbmiwuTSuzUQtNMcwXgqXrMFJYMaIHLqhwBblHTDQXXgeYFfBKBDrZOUdCgFrRIflTannwhzURefjjpfyncyjrcwOswBHpsgRJqrLZZVbbgVlejSoBvnqQbYApWRRjTidMvouyxHQgawnNt" dataUsingEncoding:NSUTF8StringEncoding];
	return pjIgZFrGhVQHcZTL;
}

- (nonnull NSString *)HqALYFikHWQ :(nonnull NSArray *)gdYsaDoyRgrC :(nonnull UIImage *)ZmcvABgtADNiwuTB :(nonnull NSDictionary *)SuHfEWJvxaiEfwGFjcO {
	NSString *EtmAjAIrdhvKKlOzMTj = @"hfCKwyCcMdhfFFpIkEjuzXgyYiqjUQGxLcxGzaPVXBPrEKLKCQjddUtqWWnnWylkyomqrOeHImIrqUgwWRYpJlMsKnMFhAKiegoXtgKrPGGfqxNtJaWMqfcCPpuHi";
	return EtmAjAIrdhvKKlOzMTj;
}

+ (nonnull NSArray *)WvmfHdaBFbJl :(nonnull NSData *)knYZtAVMiKjpqDA :(nonnull UIImage *)FFlIHrNpvVZPzPza :(nonnull NSData *)RSzKyrgTUrQdpAE {
	NSArray *zUcpYLoIOO = @[
		@"XXURYvnkTutHOYmhXNIGsyzEkhbDQuVjOGyvzMcMPBgFGEMfmsZfZufUujYMfSnQjzrWLneVtzoMVDLczMZhNoaxxwlGWSCsJKIiwdSsBVBAJqNjbBXpCPOnPOAxVWzyhdiwdQJA",
		@"UwPvhXiUpGfpeQhsEMmdFNdfinRugORzCztGxiEhCloZPzKwCETWcmQmPuvTsuycywkyBCkeVUiGQuRfaEhDrAhedXLqWchWqbBWbPRzvWtvGZRClueBPiJCSmwmYGrpiWYeZY",
		@"EfuXHhVNtSKoGcwgURIErJeFudktpXoBUpBGrfSTntmjymsrHynXHUoXgWXSshDnBtlXRJlZuYhcQqtcgwKiuMTpOtXCAKOrhavNtiAcYZbklZlhqCjLhcYfDtHBWzZzvnawkrLkm",
		@"YOqCufKzxdBSbLMvORQjYOvLmczDCUjitTYsMCgcZrKelamUlsgsVPpnKFuOFHhvqpikdBQbQNHcqgalFMKiTqmGYfgCkDkVrDCpeveHyvQqEOGiARMKIRuoKmiMsBcJbbyHiRYWTbwvVRhd",
		@"fBGkWXHJCIMLVOSdwQQlyOqByDxzQRoTWkVKaXkElyOxRAIzBtTvlIvVdMNojkRIAPoyQSgpVVhrVtrUiTamVdRssCxpFvErvmhMmpkohtjQMyYyjvvVhdzfVFftssRcRfNWoGdXVaIN",
		@"qxMaoGqdtbRgWnLcvjfPjEmiSknbkwowYFiSyAZSqvldRrpPxYErcHCCHdUubprZCXmASAfVMvtmTZydMDdFtcbblLjbPhhOksBKgza",
		@"ltbNUatUBjtbcQoZNBHXrRPexnmQxEnKDXvqsFlIgTpHhBSukuBCHxNfwXysOcgkOYSyytCjxVTrdWoQTVoGqsJBjjnwjLzsUaxBDCbxUbBYguJfasNYwsdoKciWRBGOlWJfodEgBWtsvGGEiY",
		@"KGhLJjukEiQAyNocUvOUUIwxTVzodlgdWdRHeGTpZSFNJgRaKgslXmSnRIhsQHXrFLAZcknBxYjmiCFnqQigzsPvFuBfuJNlNbIVZYjqsOGmOn",
		@"QQDPTzOijprKVUNVQecSULuNSuHdmpoBOeOXTjrufeymiuAipRsElRPjKWGqFONIBUBYShCUkkQylXdoMIdNltANEVyQOrybUTCHeVEpmUpnkLXjRxSqhOnGylcTKvxVInrxUHyLDrijrLgvS",
		@"KpNPBJTGWhZzHoihcdvBlqyDoUazRFdUftdShwysaAaDKfnJDFXkpnQWnrsdkjVTUhiztFpJcGoBMTcIRzDjRigAnATiYcpoXgeowAxXCCvQLYp",
		@"gdqNUbmqkKijAZkoLKRBARxywCLMIXANmRLyQSAWrYVTFuJwpAPlYZHDgQqszvJHIhgXUObADqBrJfQWAnDaHhtJqPjAATnAEhlzOYvsHKAmaAUYXhqtEPyKJqwsYfCAANXWOROhGLFGJRVdaP",
		@"LHYuDjtcoQWjdslGWiksWDMPdBFpNKmcvfdFdnHgCnCbCkTvdIdoUdMzldFFwPbNuouvTQsndtIYbKseCzGTJtsfGbfJliTswhpLpFSNlywzxDSqQoxIxOwtnUwAGlwCtG",
		@"WxIXJriizGekOZwnIiQNXUAywRHyNFicmeBRfAMpWacwZUuezcAleTAtVmQHoJSqHveTOeTBJmPilurlUxdhrrSolpGjAjLAMbzbuaxvROUDIuniMrSgUtXmgsIyDQeFMrkZLgdjanRyh",
		@"XbZdpYjgAdqhWQcTwKwAkwjvQrovnUgiXcsUYZfmAkLlIEvXYxWEXgCAzubaWsvSURXoOgdzKWSiENwsZOoKZKuCazvGeapFJWlJzeoNxmczd",
		@"SRnnDxBUxooRTQvigfjPrJVHMlGdiNEOxrEKIfLDJeHSCKvEVOLfRBurfENaoryZdcoYNOtNNYiNgdoZnXnrgbBmQVJJgmiSqKOOlWVjuWPjmjFfEkOSJKYTIrafVB",
	];
	return zUcpYLoIOO;
}

- (nonnull UIImage *)ldNQxISzJLIBgoXMj :(nonnull NSString *)JulvJBARiAezoxXM {
	NSData *KcrihiaJzigB = [@"aKNryaKfLPHSTZOAWlFbaNwDBtJfYjFQPmTLpEeFKPdcOsIKOqfZJpXmUZxVzBGTsyjQokumrwgFqaWlulQmAwSKzQffeLCJGaUUokxqkA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *HCwvHGJTgOgvTCZCCpr = [UIImage imageWithData:KcrihiaJzigB];
	HCwvHGJTgOgvTCZCCpr = [UIImage imageNamed:@"xWvBNYxvnkcnAYBSUAJROVmVLKFKnXrPvOCUktXGOkLZViRdMEsfPjXWLFjIQWkONSDLrbyKBLIIZsPcufokbOtTfKMCypkUdsMNRofcPVaRkqbEifdfFtoNtSTgob"];
	return HCwvHGJTgOgvTCZCCpr;
}

+ (nonnull UIImage *)miOKBrwPkhxLi :(nonnull NSArray *)ySXhcGtmrVQ :(nonnull NSString *)XRrQqPMUfZHUTARe {
	NSData *wmXxdcuzBhxKLUoH = [@"JWNteByNiGxiiFMjGjWblkDmAysgcsVtJbmilKXQvzKdPJkcJsnXGkiGcRVlliujbqrnjWXMfeRuJBlHVoCLmGEuhACnoguJjzjygcWUGhFlVvRpVkFKZTqqmYSZDqjjydHOfyCG" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *MYSBTlfhCoIoMnu = [UIImage imageWithData:wmXxdcuzBhxKLUoH];
	MYSBTlfhCoIoMnu = [UIImage imageNamed:@"xADIsxwNGBNHWtHHggDiXMfPBhyyeaWPTHxyORKttGSkIxkWSnTxRNFzDxxrSBOzkmXYyzUzCtyZHaDixaxnhgjPCawEgjdJYInNZFSwondgUBhfftWrMoOcySLmbnFhxrgSAgDJhGqKVII"];
	return MYSBTlfhCoIoMnu;
}

- (nonnull UIImage *)tGDqnUkgdlzExtKr :(nonnull NSArray *)fzpOOnVcUvgYbyrhEZ {
	NSData *rMuJTWajAljm = [@"VbebRmAobwYYlhePIuvYJevUliRxfqedUHrMCHRlbvZJNIOcHQSGSVWdVJWUhOCmyXOmgkFVkZCvdgUrDvMHmwWZilElAQiTDsuLkSsxnQITyTVQAZDCQsMBRvcTfmgEKm" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *EcZycENlYi = [UIImage imageWithData:rMuJTWajAljm];
	EcZycENlYi = [UIImage imageNamed:@"uoVuHYSaSEpiWQwSLozbPovEYSmyWtzsEuDpgHlYAvCehCxhNXMkwnqWFbfjbKbXuTclcsUhicDGqzBxgYbGAFoNyhjWhMYVubcFZptLSySTfClxqpgGjhzUepVakQJrXLapYJeKFdxv"];
	return EcZycENlYi;
}

- (nonnull NSArray *)RDkvQALAgRrXtLLILUC :(nonnull UIImage *)UoLofcvLguCx :(nonnull UIImage *)xSsuyGzxnGpjVFNLxOI :(nonnull NSArray *)XGtpAHbSut {
	NSArray *rwMeykndSBymfsOxKJE = @[
		@"OEatWkEnVRSdjNnCHWBvUOweAazZDHooGnWqDYVLVOzlauXMbkKPOnGkiVJqYKuBSHiGpMuhEArmaGVzPavdUTIZpKqXmAswZcYmfVMeWNFnMcQeGUKbUhYoNkIxWkkumbgZlOjpyXaxNlIJcJbUl",
		@"HRJzrJCbVzyxARFTUTQhQejSiifgUywzBYRjxUNtnZfCBAZeAOwtRcpsXcFPVncTtxeKwOMHKCjrIYldWJfeMNltImLXjfDAADKsbdbgbCnGdQIxtvyXQoIzYBAUFcaNWlBBHHaAbUigEBewHbwUX",
		@"aCbcEjgYCVJHbYGnFmoFAkqpbmOtBSNZuAUqHaTzRKriEmeRwUxcByHNkjmHPQFiaRRiGXpPiltuePBiINmugLBsvekyGcAfijyQeNXgSDRBbTtr",
		@"qJvsuUkOGYOtfSHTLJCXUXCeOSRNNTeVnjPhsCacCdITHIOoVekkKGjSDXUKkShAyCCZRaAEJGoPOLdFhEbafIVgyzpzgUtrbXQZnznjjaAADIzvqCsECxuzunVunCOhPBZaesbXkgopjnJ",
		@"XHleSpkvKdsOaUQVkOmqlkbXBmxGYXQfIEyQaixpjQyKlOVnSexfaSgaDyPeGrjyUDORwHwnoDavfdUlWsaQmiuvQbYBEzOJKkIkzFrDKHJKWMdJZgTXCCFWNgyoo",
		@"wKlOStSMYiAmYobVmkjAadRhNNNaSnluwYiusUWKoienzDKUTAtVVUhUEzeAgaaGUMiYUtpzJMFHEYsYYRwZZQAyPHQjzadAsMZhklzMmobOVTHzwTLsbWkscNQytZlpHSvBbRaLswt",
		@"UETGUSjOCIVWAsVSIpJNXDEpXxVNSifUGhQGEzIvxBTqEMiDYDEYvwlFPqpgVIStQpVzIsTSzQwPQKFTsSmoxQdKtcZVmMQseCUYtLNq",
		@"kSBQExKiYRERfHZyHDMqMHhaEMVZoSDvrSyxmsiigZbkvIjVbktdkKsjiwJWxWbuUQmlgCyXwslvHNYRwVVxQxlzWsOPktqeAVhBWgcEkazYbIOFNPcCIGgmGztYHFPzdgZIyFyppjuXUVwUXljSc",
		@"EfAubHyEzzodAuauILtlPrWKYTqDTroSsvdGBTPIGtfDfXEpJYNSnwnElvXBfJfcToEUxBObhPDcNEylzOzgpfIjRAjmKFTLUtITzYsYXcJxMUGDab",
		@"pppNHwcEyaWvykjXGAvCzngtqWJGntfAZTXGsIULItNbIgOopflvfykdePMjJBDhRauMMHxFFiqtwxOTDmmgxSXbxMQxRRfPhCKxkolYKkpAMasQKTRpgYWrPYHCQwWGIcXwgLIdCtFxwrBxgA",
		@"jrESLGfcliotGodoQjPpwnmhEQoSwFRVShSdGIjEyNqgxLxzWKpQgMcSUXYOLfOAmiAtYJdAIcoNhJqEspwCyowemApvvIaeSixEOmqfEoZDZEHMTjBzTzkfHjFjekeK",
		@"xvWlhyLQFkKqBWJqtqYLhKldnqqcDVWNEVhHQldMloUXsjKQvJKtsPaqIBeDCaPMYTSUXnFLWvqcobzcoBtYFVTDsSLrsGRAMIobeAbACyGNOhfURsGmAn",
		@"CVGRaFOowtmQPINREXUTnqfWZcFjogFAhdSaTDgZzfmcbfApUaRUYOQyVwhjMVQatVmuWzYElfbefJCUrpGluZJTFHoMvNRNSmAyp",
		@"xdewKbLVPVfOVZijjYLoLtapnsAMOrmpjEXdJRUVkdaxAcHJSPrTYAGpSLwuwOtRRyNGJudNdYjnccSUXDcSndHpRVmumAsjyiEExcxMxmUbFSjfyFPdYErFhGnoMgsWvqdBDR",
		@"lrStfdaOqJtrSJDifmEWSgIVuqcHKaBHzGtugxUAvDoFKktBFHGWifPOzSLzpVdMvzBHVMdgvotLgQItCADwnTyIaYIGsSXqBNGlvDkWYKhynYkyvuVcybyqPBzNTucjSUN",
		@"hAAlHdQoooGgLOPuuhUUSQTBPYdcmhFdJiEYFkXkQrlMFtDStaVMykLgSgVjSRwFEfNOpbxbHSbFlePGJcoGWIXSRxrGDWneFveSkEomHbjuPFbAsQbzvjranLlPYvsPsTyrZljZHqxYufCfxXuh",
		@"RljHWQMZUVDUVxSjRKLKQztSfdbbeWAkqhXuhKQbgpjUAFrQHlOyrUmbfMcesoTslfSPczVdvEruDMNlAIwIAplOjDUfwYlpkvaBiPldqFvjamFTWFedEjXzcklohBUXGGFsDewmIwIwoGNoHtNQ",
	];
	return rwMeykndSBymfsOxKJE;
}

+ (nonnull NSString *)YJPdYASmmzOhy :(nonnull UIImage *)pWUqXfMEORH {
	NSString *FTsauhgUfVbGsf = @"TbUXlYawvvULDOycFTZWhqkuyNnKwvTwSPJcFMgCbHPORaVNIGHzgCKTmYOmOVNDcjVeHiIdbghcEMlzfnoPobshzFbehIjBAsmcputiuLYkdxEkprBljSiQphBEeHUqfYJ";
	return FTsauhgUfVbGsf;
}

+ (nonnull NSDictionary *)nYmyQKAmJL :(nonnull NSDictionary *)OMvxxANnGEEgmaV :(nonnull NSArray *)mHGtWahJulrwKFPzpH {
	NSDictionary *kMeVsTaLXqfNa = @{
		@"UZCudxCbSZkygBezENx": @"qLOLCpBYsaptNBPtkyLStZgWJGOzlPnQohyLxYKOnPcrDTUZOtnDsBaTAazSvSIvnyLdkoZnIefxRXROZuJUJOEohAnbBVxoctFYOmjqupTWqMrDmFvBIuvaSciTWxZzmDkqUjXir",
		@"jFCfuJkLMxqXsIVKTYp": @"tPBxpqTTnlTSzGlzhqgYxRhbhjJUDuZEMZnaIUTqfOpXxMbIbKQujaNdvwJbndTvQcGcUCywQboIPYxGEOwZXAJuIXcjWcIKEHGR",
		@"DYWzgGfKDVsy": @"yidGNVwVEKTxizQOMbPCdaJVqPCFtVusBOwcZcTmWCdqdTaucETAbPnIrnYoKlNMqVSRXiheglyTiCNAKJwIYlOHuhCXRVwPvbIEHxdqCCVwomUVADmRhvBJriSkuLjoPOaL",
		@"ozDTZHZZBsLXTL": @"WlUVxvOxYCHTyhQeAhCDOMJMkIgjlPYVqtcDrKJrPxfAvxDdAHObzTcycGmoueayXJUPnTyohZEhxODZIbVSYuUSnFsFIrosJhDtJrscurYRgGqpdJmKycVNvPLmkipmoPOURgPqtnhJFyHzecZ",
		@"JchdhADhiKLDKOem": @"sjOXiFPslGwdSfyulaRcDjFqeaJwOwuYHWjzqcRTqyPhSMXpySxYjsDBzecezMDXvuCHRIxpcSIjmXNNtxQvWTWkBPKivfhaikxTEokvgRGhUGyMJJWBLXFRCpGcwWKVkXXhbeJseDRN",
		@"UQXEIkrlupumxxw": @"YMTDQCeYQmLOIZcplhKpqaJAJobHRfcJmOZVyuAUlgHvbIrFNYjbHkgCIbJCNeEeoOKtiEFAztysRaXimaMkcRzeyRycnUmYYGkAwxMmSYmYZlkLgNSvZVSXgrAGpEJcfCqNZdqDUhwYYcBgk",
		@"fwJXFBuFhSga": @"IIwWstQjpLIStpNPPLRwrcNXVQtihXbCEGXVbSToFpPxepxvPQMwemIHlSqmSxMAUzeAPMJshygETjyOsQXKhnzzNfWNWDzgNqWELxSXtUvhzOXcKUDsmlErCPaiV",
		@"VPNurCmLPzhCMK": @"rDcyonaNbFxPfWuZxMeOXJYEiRbfxZYAdVGfwUVYbCzfiiPvjgGdwSBvMYpcbJuRbEVmmOPqoWwIsqmDEtaaFcugdcaevRBsqJELSQOFdTFPYoButKFLruqwMWEjZIgHjCTUNEkbfTmmiuOkrwQej",
		@"PVUrCSNPUvQrbWEN": @"XjxnXKboMMNPjxCEdHJEUEQfMtsMCjSHlOoyFMHlapDFUDoHwhaRZcpUJnyWNdKZpfBNOFynjoTftMoYZSRVzhEfJJOhasjxHJONWQEiZqIwubQkpdvElPDMUIZKPAVLpuQsNvlTPqDDcjL",
		@"ThNNGPiqTDG": @"KRtDLjhsdTJpVILrctBCwKdoJOCUdIknCdFsuldajcxLFZrxBXuHHrGBdkjyYuRRpcplJoOAAYHxaVrnBqGsuidCgyFrGuBLtgiEWknsHTTlCWGGkqhx",
		@"sysvThbofuum": @"MSLvMPslfXTfpSNBVZnGuYtrThoILWZVoxpLgLHArYMmIQWlftkoGPTmwbwtqiOUeTFMQjxxqupVihMWdUkfLPnLJgxXZisLXCuBAnYZdLPDppRYjQEdvphzqqMXLaytwjaMzrVKqQhmGxQ",
		@"hvslTPIDJGw": @"IPCIghDTtKkoPIiqlAKZKjtmAflBGYoEytChwlZjOVBGiBMkKuFWONwxUNvAgakGENHnkmpdRGLOYpmRWrUUDKVgxuDTTUHanwEmnGQcGTIkURkbsHFQozYZueWnpOscRawBgfLNqGtfCVvIWW",
		@"WsyBIHziGOPUZpQWO": @"YQkmqQKuhqsgqdzdzPZNejJWbvBWcXplpjItpllJohAAjRicJwjVjpSQhruqeOrPTQWVYrIqApAEpuZXYlVWCGObstZhYrPhSdUQdksRLxZjXDVcWEEWdruKifJnEClAxlvHNEajzpYaIrM",
		@"TlwURIlKhpitOCwUS": @"KWSLxuuoLqrNEdkqecEMTVdsnnJcfjHAgvtALrcqFkuDkLwhMleHHVolcghLFypHdqTPOrSzrSAlZpvXIlsRdvvPSooFTsyIHyxwRSriDWqimhcbSlPxzfmGBgMGD",
	};
	return kMeVsTaLXqfNa;
}

- (nonnull NSData *)RTuVtvGWZd :(nonnull UIImage *)oGhMlYuApaZC :(nonnull NSDictionary *)kMCpAsdOtjtdsjHKCls :(nonnull NSData *)WHHvESvanbykklujZ {
	NSData *AnkAHSKEnTTb = [@"cxTEgxeHWHyfIYAxgtfYApUwOqWJKRbilFnqStqCpSBLqHhqhIQjphBKUFikRCccGAIgeVbXGLnBNWKmGOaZGxRgcADcTWJdEqLiWqfIKMYxsHeDlBZStTweOwE" dataUsingEncoding:NSUTF8StringEncoding];
	return AnkAHSKEnTTb;
}

- (nonnull NSString *)OhSXAFRPUblVIebx :(nonnull NSString *)XVqnvKIDxrYaH :(nonnull NSData *)noIERBTpTgip :(nonnull UIImage *)dQIfhKyMuJPg {
	NSString *HmuoLePxTW = @"EXnHBbxrJbXjxckAACmVOrzIojkCsJMLOVYMKUWMRlFzTgTIQmCORFJYFmqFOSfgKyBCQZxRdlBvimxYhgtAkelCkLzvxsqjTqLOJwltTPbsNWTfFrLRjjeEjLVfsrdZOIvi";
	return HmuoLePxTW;
}

- (nonnull NSData *)sEgVikqPEqzT :(nonnull UIImage *)zVGLTgmzzUhIetqowb :(nonnull NSDictionary *)JRhhWCRJuNyxcPi :(nonnull NSDictionary *)LNnpUTXuxWvHgaNJ {
	NSData *JrUmwbpCGTnFVIbck = [@"QoDmIetCxIEpwgeROuwCvhFYZhcVqfYFgvkbsfbHhxhjQamzgqAUkeVsZglNvmvfTsVaJoZBmMISslrLWtlNpAOlfWoebUFbgMMePGdVTNjShnhDfjNlRgqtNnueQQRvSIlt" dataUsingEncoding:NSUTF8StringEncoding];
	return JrUmwbpCGTnFVIbck;
}

- (nonnull NSString *)BrbdkIEStLWiw :(nonnull NSArray *)TRggEkQHQoO :(nonnull NSArray *)atyrLVvMNlfIXYn :(nonnull NSArray *)sRJJaVbntdcGYSN {
	NSString *oCTmpnTnGzzcdvssWje = @"nTkkoClszPVNdvozJByUvqWLesQbpvBzlAXqIuuQnSziUTwWhgWLJyLkIRjeVLVmrYyXrNENUHclNUmWsmDYZYlfEpkNvWELPFTTVMNNkgBdasZvFhhfoukUjFJrWhJtLuVsMFkLhFcCwepadnq";
	return oCTmpnTnGzzcdvssWje;
}

- (nonnull NSData *)igdXJVdehFBpYRYIKDe :(nonnull NSData *)tksTBudtcmFE :(nonnull NSString *)NtfSPWxLIanixoJM {
	NSData *tQnqbneMbL = [@"LtCktWwMptvGVNHuAfkJpFWAAgJCrqCrlDONNnNkljJytSRcMXDmPRSPXfJCjiJTwaxthziaUnZcjxpMksjhCiTpuhnlQcwpBRsJtYwmhazPZaaQyGgQNLzxCWbgZcZdOdUZ" dataUsingEncoding:NSUTF8StringEncoding];
	return tQnqbneMbL;
}

+ (nonnull NSData *)KTqVkKEVoWrxYs :(nonnull UIImage *)wjFmCKGkjpgTMekR :(nonnull NSDictionary *)pKcXogSoOcDaFl :(nonnull NSArray *)fEUutVXzDZwULM {
	NSData *uNDgPlnCevQDBkhUrli = [@"zEnqcTFDbJAhDXQhlWOjUnkQcxdPXtmCRPWpEnntmjpTkbkTWuciytDSSrRgfxpusgWEulYxBqXmmHqZrTSGqAuuybndAkyHTYzzwDfIyivCVPEM" dataUsingEncoding:NSUTF8StringEncoding];
	return uNDgPlnCevQDBkhUrli;
}

+ (nonnull NSDictionary *)RDpOMovoyq :(nonnull NSString *)beYlTdPGUbFeq :(nonnull NSDictionary *)flfueWfcwORACZZkQAl {
	NSDictionary *SAFIocjNQcACDloICv = @{
		@"BXHFItORXapj": @"ZBjlcDbOwVYCrNrYhZAwqVLNoHaVoHHsNFDlagrgennTPwIsByrtYpljbReSDRJAxbCNFsPkzYqjETHKNHQhkEEPNdQhJeMgKcQCaXHpHzYyTYMFRpOeVwxeWWqKkNAOOJhHQrmSVRsPiyCHd",
		@"wPVCNmyrZdQu": @"HPOQHgChiXzYGsOtwgTGahLhVJEBsKxyWfEJfwuzMgsRnwqikpXyjSZVZsulObPyYOeNDXbjuDtmVUHjkDozsnjcTtomqLDbSLLlSrFDYVOLjkB",
		@"WhzpBaxWCH": @"ptZLmXjBtTeDZXXzEPgOiMULglxfZBKcXEoiStUgSMPsbxYkwpGwxCrICDeIlovEeKMDxEwyMlmzFbeagLuIktiHpCxXSdeaHTCubXJdfTMDDLYnzMOUZvPMnRosWmEObdtPYSMPMcccBQ",
		@"szZXPoAWiwFrUla": @"mWejcoNxHabLIANFSLkEWkybyUpnLJimemnAzuPwewzKMJnEBEqbYAVXNvdQppcFxjTPnSSYsAKcBYRKMSlYRqAlAgaTdxwMjmLfEcOoCnHqkiGzrRGoXF",
		@"HXDlkjueDvdPehi": @"lVmXOIjNQSbMMjzhffrXGvgfdZIfusQAeHNGMgYrLlBQKXaBFduzvsOonAMNyxcxlfaoufKNhueUONSezlGYauSyvcaRdblasFowIA",
		@"hdNhPscROjayzb": @"mGUDAsgQuBFMHvajTYkqnTnmenkFYpHLTzjgGCZGtFFLPnqlJzECiMBzPVYWzHvZLOzSlzyvBCjUOgWQUCgyrCFTdfEizKZzlLqPRxjr",
		@"NYUvATlgSTioBMJXV": @"VXensjnAJrywvgncsImsZvigdAIOtcleGoqTdoHFQVKjsovHMSToKqEXSHDNfrGOPyhMpgJabrFiqVdAnqJxeYQqrTbIjNwviNtEppZTvbCqSqzqTrGGketpLOUHJ",
		@"lIKMMpvjext": @"MqZGlmbBIcHWPdtHVhzmjgjFJxFMuwuvJlLEucleOJUyOmyVzrIPgOHWoIPhjQEBqJDVWoGEJKIPRFlLTTDuPtKOPUdgYoupAnkObzJJHVunGsLqPWYXhvenejtNpCNruRda",
		@"KjnTfMFiDDlOHClhkby": @"yhMCXkpqSpJKGMlRGnfhUoUvBsyhigRaSqOjOalxKWZiuHRYblJJfrCPdKmBSUQPPwZpfKyDplJPdUTrZSjUyxIdKHTfhVmpaFLRnhICXylVRHuPYYW",
		@"rBWVVWGkiyRXYU": @"UagRoTsSCokELpkaYJFkWFOQUoKnklYetWBZxszrfAQnlIEpYiMiIYghJwGBcPvCafZuwIugHpkfxtwRQWLGplgvksoRiAmfqBNmYgKNMVlwzyYqDGrGAjHHvxEdGAuOSDekKUytnMdZK",
		@"KJAgrHHUKHVo": @"RUvVWAZKvElDwsBLRCoBJeULhgWzgfHrOaUoNOAGjuVKfbJfdHdKNMFqPixHdElOgsXESUeKUJjSdQWsgYTolSTYJJICfhGBUfMClrOiNzGJoCElsslkoHHOnHsKxSPMGgkvHFHIIaBGQXFBsxa",
		@"srYDyiHjAG": @"yDzUdzWKMmRYbJppTYFnhEndYKIANfbfHGXqJhmuqKfJTZWDCBpJXfmxTafTDnPUCxfXhfwGKwZrkTJGExYuCdXbWntEoOIlKRHxwYOhoSDypMjskiETemdVfchwBJfrTpzkOj",
		@"ziAnUoIZquYUCpMzWE": @"HaXDOKXeSenaPhQeuDVPJYfIakTBGLnLgLRhZDPpitCBxbPRvDVixjaaNlhjLVrmtazUMHjPoSxINTTeEALpaLQFTjDLKkpWjpvRDDZjrnKiBCBSfg",
		@"XwtEkSigsZW": @"WZIGmyNIlPbFftrhirRQSMoEkbSaVvPkNuMZdutmwxAbVYDGFlpAdlBNxCCAoxLNpdfFEIsRavhkCHHySBdUKByTjlCQIXJVIqtWrGjptwnPxKfEMXeqTWhjUuzRxcYKuKYlLiWEBOVDSnBUiJ",
	};
	return SAFIocjNQcACDloICv;
}

+ (nonnull NSDictionary *)NFXLFBxWGwueJwvcea :(nonnull NSDictionary *)hqGKOCLfimCWre :(nonnull NSDictionary *)muMQKBVeLwMewmvgl :(nonnull UIImage *)qKURABJeOAeHH {
	NSDictionary *KniwDjZWTNqxZLmWpi = @{
		@"SBjhPoaiNoSUgvcoT": @"VPCQpbYXcArxkBmrDPydJdTZtUTIiVUZiNcPjabmcqVcKRcdJKWGMCHAlHPfwFUCzEmDQJFLeCKxgaiMuIFiWhmLwiPKLUpYnhrOPsJjQndRwXctnzUounecKebibRAaUH",
		@"LKuZICAguEHBjiDTKS": @"xaejYPcxuSrvWCkpRmWdSMtcKdgdahOozITAkMcOPIhyPAgNcgliqGBzzgOrixwpShGSNyhzZZSlmwyeUxOdqGbvSFhqiuAzFPZNeabPpwGTvdDVVSKLQTIXamVfmtETeiiMQTDWqF",
		@"grEFCGRuxXDnu": @"gqRsBlKKzWYVTOsshXaKPxSiOrdZtVfTWfXWJNBdaBDFCUYNdMHNBSTHKEqgduRQucrbXMVzsioAnLnAKuXqzlWlISqXFwRVKKguWCvHjmMgHZFERbrLDVgiqiBtfuGNSgcrkSIs",
		@"rFgcGIuwYHyZEI": @"hdyxuRcrLMtmRDeAuEcaJxilLODKbGRCeNiLLsMCTIbjXJCkRgRsrgZYxMIWFBQmUOWTsClLyoouGEKpccjEzziDcYBWybwNhbyYRdCsuUrzFTtHjt",
		@"UikRJBpeNHTcZoc": @"unORadaAgqbWrVVBdlvUxPBVQyJxCYwtJHBKZZFJfLiZXGavgudGSYffXKFWJsFPBpmvHtmyoVDQLwAujzYBGxSmkpdfliBouJAGovjNLFDMYZkTjuVKNhRvCLejQDwuG",
		@"HWzriBJLsSa": @"nBOqjldRRSkjiRECyKXFkGuPziQPSXwsbuAUDAakkWGfbruugNVKyEJqpwJOdovJfoFQqDwjvAfALfCINEBkZnrbugDLVWpjjjCBDlVSDLMOMffWddy",
		@"DknwhjDbkftoPhcIFuY": @"cBrOdUHbriidBpwBNHgCnPjYPhuSvtUBIkGZvfmMyOlwEAvAZqbwSmYjhBLXyhvImzjSVtsTqQmiIPGblxDcqpPFppqzcYwQyZRKbeZMaVrOTUwSjUEyrt",
		@"qZxIMreBZlwZqKfjOao": @"msyNcSKyJbOPajOlQukXgQnxNnDBUvEeGoRiQCFnseUjBWeBoXzIRgTebUeBBrgXXXSawILlwEJSZBvpiitKXTqWDjgLoDleCxBVpU",
		@"YlQQdEHrhDCAF": @"FxjhJSvadFSAwdMTAHtYzRzQiEeBLtHXguJaSbnFvNChhxyAxGDnyjEfkePzbvuRKUssIaUyeUijAnMunqrRdPWkKdgNdINDIUKoHBCAlMpqrWCOLyhJivLiyDDgMNHZWfDEYOMzPLvBkEnkl",
		@"uMDgnZFlpJUdn": @"ADgpIhdfDpEtllEXBFZqGceUUXzwMtZyXuUFBYVVEwlemvlYPHephngtsmpHiUIJOhEqAQpVhNXggTqteErhZIRBlxkKYRtrtNpgUTFNIILGjnChIVJWSkaBErkvskESjGtNlwXpd",
		@"utOfsruDwlEUtVu": @"jVIphsUiMUpLcDNefjTbKeWIcZLEzrScUDfreHbCxaNLdgkxMXJVgfcJHQTsCwlWkTOBtWEfztqFxtUwVpTWstEwnoGqTIdhahvoasDgfQcMzDjQoMuqQmRFJWb",
		@"riauEmGxLY": @"PrGbuffXfjfhTRXOWQnWFTjtmfaIGHwjZAYcbcHyjyQtGlrrJeqnzjVApRaCXHvzaQRGUVdNbbMPzSHtowKkmTBEgIWTvReEdpkoimOQMaCDtswcLFMZuFjDDfRKPVUuW",
		@"cTieRPSpmI": @"JGzBDyquWclNpucAbdgzGRRGGHbXlSduEvMtNOTlcQLnqudYSUmRBFJXjldZbnRiHrQWLYHZbleHjhyxWqUdmOXWsOiFfviWXrYGuijruEzvmhpGgfQksUBQWIRMHmkDghcPHMMgrkWut",
		@"PzlQUYkEtMqXL": @"DnmwbAMxmqvTJbOwkrNkyzewVTCedSwCvcHLsyLOidfMDgpPCMUBEHMFIyZAERGfibmXqyIhMkrHcUUcgBITIonWaqYpoMcyGeEKDtwWifljznRQuJygoayJWOC",
		@"pvHyOGyyzKB": @"RIAXeBhILmyDkxBDoFTYZCSDDgbxPVYaWUpuerxXgxOzxbdEuejVjvIdsmedzqlnWzXsKBSeQaBZYfreXCbNDNBCAyddBzWSswXBBDLmxs",
		@"bCKBehDZzonjOjnEjcw": @"BYOIGmklvtAWWUdlfhJBPIWyKexAWPNznzLbIQhBzHlWVUCPHsrrUvRigRmbVicOyonGfusMclrzKgmVlulwvLzvgDnvVvoTBDYXOronuCbnwmuCQGVXLOXowYHjtJZoI",
		@"jkAGmIAAlWfEJf": @"IHqNCQIBxVbvXGSJJfspjuFDBFqMBfWGsYQGFHEJRuQoJSzxXJOknivKUTisQrIyAadHhljMVZRetbnUYRbSofVmecpRznZxMwmYZuWapdCMGDojeLkEztbzXnzCNYSWmpZBEsHvR",
		@"wUOLjRjFENAlXfMj": @"wXzwSmQIHEPSYnpsGMLhrZzZlcHaklqAcJngyjQYeNuveWUhzOvAUuVvveglKweOuLEembYHVaTjmJpotyVZDZSOHovXHEjdAaJWUYdZjaQdJabbOctcxr",
		@"XEjxDtcheEFrEB": @"pOgYXGqNXYCfCTkANwAyujFEYtrrhBFWzWdtASUUfZVVpGpVyZJqsrJtzjdlVeYKQPxPifYFTQzlXjFatuFAmYurtkFkHTDlKdfkcGHZoPoDpJCNBTuFfRNpnJGcoMmvqRoURnmtGAT",
	};
	return KniwDjZWTNqxZLmWpi;
}

+ (nonnull NSString *)mFmydZURvvin :(nonnull NSData *)XxosKopZLXUSqu {
	NSString *JNCItEwKHRI = @"mcpHKogojtDYYwudPjetqJxOJxePbdnRmghQqgNtVMKPHPJAYiEMBJzBCOUzbJnvyMPLNajHrnOafnxkNMzWpppfDUZAzadFuUtGrSonnpYDFxWTbCOa";
	return JNCItEwKHRI;
}

- (nonnull NSArray *)ujYlQRYROCQ :(nonnull NSDictionary *)nblkugYwkYzE {
	NSArray *RSCuYolMNdElmiEk = @[
		@"lEAHbWddMemOIGIcNVCvCfmyJPWGjqmYAtQafavciIWHULljNeFQFuENHMKFBXjTLjeMJdBLnFpelmoIREcMQGeqtILgSThJjDmeOTHlvYOWFYRDuJrspVVvzCDVE",
		@"AXqNpjwwQodpTMrBTaKqOecILPZWFpzGzRrQxJVmxjNxQFzxUlbwBiTtcigymWSYMfrUSARTzcEEGcfgeWUvylDxffFpeUSzlbVGnYTtaYbLuTIWwVoLuYHpXoweeaMP",
		@"ANqEEytsolWToJpXvSMSTGNFrZhMXirpzFxctIDmuZuSchndfeDMwqJfgDCKvJFSrqQlCPzilIugoIEjLjgUqOjOXXxMBvvKwaxSSbmdCWEu",
		@"rkbhkjuGIyyJOFDVFEjhaFjgGkjflhXkdsyBOTXdUNhIXoTfNJDdHPmwQnReHRKwNeiyYLUJCLSXqQmEPUkMWYOZjJGuzBYFuiwWRonTjIZJMZmYQzbAC",
		@"qxkYhnazTjHqPCGEpyjUQJQPQpIhuBzAGhcRWzAbOGKcSammZsniAywaiwgxTulNvZFLAdYVXDecXNRaKPMcIIOGfuPayEYqzbaFQG",
		@"QtQanLNapUVDCwbVEwTpWdMAHdOdECVJPfwiGTtjrvmCAMxlBAWJAGeCvjgGJuVjiboZIMIOeYuWBrbDlMnlnCvMpMeUeSvKLcxbSOOphUyQAdtvbUqCGpMnEDIq",
		@"tCpxrMbWiGJgqJdmLaHXwOTVFEprWSGAbbQNaAlvdtIlPsWurqjnUvTLUSUoMLjexPvnTGZIdYYMzUnsYwHMCtHkLsVBGfqGmkRYRuttmIoXdPplTJfQMIKohENbAhfyDba",
		@"mbfkBOMatAeqeUVCQwWhPjDMyTlTqQoLaMLZsnQYXVfyySNlmndkSfgeqOfQWDHVyIwubkKqSurmnpxepMbZmrdfHmxoUqKLGlFyKjVWkvbORpFBUDvXcFEiEsLYNrmYJFGy",
		@"RJqWXhjwVCCBcdPxwSGZwlIvubDHUWuiJTVWSssmRvwnqMDqyTUPMlxeClMhVPsuUvgmkezZgZXoOgWSYevhKEhRbryQzbcDPeVaEXxAMklhsHQEhPuSrXFDChdEPpnLgiGDfnaBrmnA",
		@"mCGOhFPMzUClVUnlaldFrjuliEOGEZsSQCxGbbsirKmBMzGXbUHNnlJNHGFojnbsWzDrEhLCZcmyOTKWewGScPDqAjMYKdLOnFcBShKtNm",
		@"RhTeGUNgduLdymalMqEngjjZaQczIHgkuGSJsvJCBrholgfhsZHWmIdLAvYggBVvwNAvfMuBkVGwfjAWBNcXSZkjSGrAyOkvKnSGpLPgSgnaAKmKMjHyPpqNtUdsmIiwLnmkewYSuPSzzeX",
		@"ufBmKkJUyumxfVSDjfaHlSxqidEXYbwbgQuAQHyXKHoWdvlXNVfVAUFtQfrOkRVUpmnrRQbiPkeBJkeaWKJROuCJkdXNeWTBeUZVyNRsEdWdGebMIJoZbak",
		@"JvWpjjYEBSNEUMLgLLiBEHVKzfEsZvWfZEEzQnutdURHWCmyurZDWnrWgHAGuZmJRdpmezeaWUpruwPbSDLDGuoJXJbfEvqIEMaFDXyPntGyWSlIUEdgYZKOLFOcTSzBIgifvlTKPJfAGoxQWts",
		@"FgiDWlKNhCBMNPufcQoazzkGnyDqqAiUDSsbtrWOaWcHJxRwqiALogpUnaXmZTZpEMOUxBbyoPxRPwQZnNjGlcQLrIomweyEisOKIAIsRhVkxBNSAyjYCHOCLL",
		@"GrhzjZGDNJmGRnusnGztNcaLGKgjFkyAXwdLfQzZvdrVpLruHYQkmdbYBeBNllewkcEGwnHVEILsGbDjQoUBXKPQOUWcKQJjMeezyDcMSosExvZshPDhJpURQKwfOXzJrqdKnyRIHsjBXHOgvFy",
		@"BzaguheGgAPvsLwHlvPeTLLtXCSMvZYqRfYvlaCjCSJDGfiQBnFvcbomMaixZPCPdaZTlgNjIVASswaFPatCjfxQDcQXunHCFMPngvjGyYxzmahUHKFATUnLtrKtdzTqVkdfRCmNczhsz",
		@"QyOVfNOHMAnjiaeeOCFgLhWjKUdrCvdRICbPLMLzRDhqHgbPEBwVabpAbeGHjKYFysaCOTPKvuzuePxzziTAfTcCydIbKuLOIxZruYDCKtZXoaOCeIfycYKOwAyXWOoR",
	];
	return RSCuYolMNdElmiEk;
}

- (nonnull NSDictionary *)SJNWcwSGsvnWbufskd :(nonnull NSString *)hQuiyTdwqHzAOcCZC :(nonnull NSData *)HKxurOWQXgcNRWOdxLj :(nonnull NSString *)DofREZTQkdzTubLAlan {
	NSDictionary *uNuqJvlkmWa = @{
		@"wkuaUmBSjjCrBTKIU": @"HTaRclicyVchiChWcjvENxeicwEFUniEqpRuEEvIHKVzaoGyjmGuLknQKeLFfZksDBGEGzXTlLkqBbjkNsPbXKsivGjjFvRIjLZAkqGrNisoWgHUX",
		@"ipYQpRCZmjQePWeW": @"fNiyvcuGAgQUzQzvafjIpoZtFaFCWAzQivGtlGckOPbOdwemDlfCMggJnWLPymdSOzMGvhuqRURKqejmvEmzWnnCJGoLpIIfhMJAXWNwBEniLK",
		@"BkMCKQfRWLTNdYDTF": @"eQsBgCGIcIcdYENbcmEIHGjOoWDhPtneATWHMNWZWvbDgTyvWsxSSOALDANHwGWLMoyLNWDrosLroaYgTAxfmsjYFJMqNEBQNdQxNTsacjRFDQJYil",
		@"WEaIcaVElSHCDl": @"ycjArbveFrmEeipRVTaSnTEPwLyYYKAvtmaagditadeNpsAZFspVHdXDPPHgOwjiYiCIoCzFglsWxDvLhicYsXfYJiRdccFwyyHyTLyIUQIuIHFfxLPdkmFmqvTivGwaPZBjpGLbTAAm",
		@"pLAMbXswRbLdMrAoSA": @"XmtLfixEiUDuQsIgEmvUVZSuOZKngubVPePpZQGPcngJXRQhjaPqXehXHdalsSTGbhiHEhhuvZMrgXfWLyjrCIZfaCWpPQbGWAsuKqdSbKLu",
		@"cHqXJiFKizqqwSY": @"afUJhkOILaeDRMpBAFPGDSxhHmxslvqTaTIakiGSUvWCYZGUtBLxoJaEAwxawRmzTORQAsZyKdlGmCqaKpnGSuSRzMCXuPEFLNHwBqGndLPBFZfvyjcTRFIDLfF",
		@"vAgYPmDKjer": @"eLxvBCDVACHChLXVXkiXHJQeOsLbXtrgdNlhVdWzXgXBcldvBNPPSSQhhaAEAQZhwpUnuJeuRFtHqTQlIKaaOsnxorBhUHmwyPxARwRinYjamGqaZXfsgzRIGMkNqxU",
		@"LRitOLkhQkgVI": @"IyUoGAvYkidEZTTMgXLnTBYmzSfRKwwPgQLcXwbFkkdBMCzVScpSrQLdgxbpiAOkwevnwYVuFMFZyBzVBLeaztRUGzCNPnQEAiiefVpFpSIvlHUmOpNOkzMUDLvO",
		@"veYJTxBrgXH": @"TrOtSGrRDqChujVQjnlAKgljqZKPKtNbxnJnmjfMagVRfUolksfraijkrWpzhRfuWENVoBWSYmhgrHMZKhcRkGSfJFwBOgMdQjdTMYKuhgvYnCrWmaFjETXqsnjNomnIyWMftSIiyObqfLixii",
		@"rzXAyjFvXESKKswixIQ": @"ReIbuOAIqLxKgPOfjaioevbUvjnKskcqkHwsmtoYMCaRhtmhAdBHGlECIcldDHFROjxrBPjKkhSHEMcUWXLxVghAmgwGloxXPgEOMQiERuNCxqDGLLXGcpf",
		@"htNUflPMYGtrnZLIa": @"KppZdEZKfoORpaPVAXHJKsDoIjJlmqtbsXChUYjpFxTEDimlKmNEcjcNyyyuBxwhzlYapniOSYEzykStvOhIurTuCWrNWRyraNJwygSYxvoguKZteaXcSgpvXymQjCjCnUhWGEasWeXjA",
		@"RfgKnnBoVPYFDsDI": @"URAPwGRfLYeTAGOqmgpofmCuEtEXONqlmcuMfnsUsaEPQXkIORETWObMwbPKEIucUdnhKdXQfvejCcMIWQLpNRQSkqhooHBXFeBrKz",
	};
	return uNuqJvlkmWa;
}

- (nonnull NSDictionary *)wOyajsbeDNmLveIv :(nonnull NSData *)BwVoSFXLoVsntMy :(nonnull NSString *)FAPhpiowDWVm {
	NSDictionary *CZMDxDzWClcr = @{
		@"MPlIKVAPjJXhhdVn": @"KfWuNIKqTOOOwcSMIYufrsFkjYVkUfuPLJxkJqwyPHiPIWcoJNZezJHTSJvQmSKRjKujzlKxqhvSEXoDBlxKrrwvGpmSFudEHIeiQSrlzxRgdK",
		@"ChODKOyaSa": @"DNXzFhidHeZIBndoiEUEqUGEKDhvoPbXKeviqLnINfBYyNrxNtdelbZoCAospDqnnXyuYZPhYDmSfeBVdZaWXxVJzqLiuRgteHGbnuGxcjtjojlDktbfQxyLGnIyecPfAaRYtHGxOtj",
		@"QSTwalwGVm": @"PcfumfkOJpBiYHGEqYUDMpKEJyDKGDohcQKhUvlRBSFhqEDeepuwGjHJVqPZCawOspakVxzsQcntLCZYxeopYwBuHhAVsxNFWXiHkINsAMqytaAgLaMOHfnQzOjCxTvHBchHJstywrZ",
		@"nHZRCpWWQghSXeQQNN": @"fUOztQjfKEGPmwqXSdGKNnlRzWZILVKSjnFhVMewvPNMutkTDCPKIwyNhZFxfGjLmKOqxyXJWBEVztsedDHTozYcvvHWujNUQuUmewIAWeHuXGeNgptPWVBpoOVhWEfqZJuWNKuzHBcfRgccASfI",
		@"YoSyZUbcYVVN": @"oecGckhLsLnFwVcJRMjXIbwXLHgBAYbAoMZSSYoikEmGKaGkYWyoZRTnQWxVyoXkUPyDQsTiWRlodXbzCcduvyxjnkVbeRVtgDPIkRqjXpZEWehpgkctlgRZMWEQJUDsUInswH",
		@"KwmbUqbTwueQnX": @"AHogOGYomviJJxAxXUillpcrzuXxkDypBvSEZgKBGjlPpKbvMqiaHYebhxWISXloGkmzmNglHmPgsLhFWbyiXBIZAHzGssfnBTTaFzULCMoaBKYZLxhimydrMFDDhMgdWWRkRXV",
		@"jYFUiNkqebzAssBTkQ": @"yGtPLvgOwBlDrYBBPdCgABRkNnxYiAMJcaECMyOCXulQNJBfDZNQVZAPaSPuVbedrUZuYfEIzRnuUvnxeOPdFUzjCVOpLiOJtNcdk",
		@"kyhgsYKQRJt": @"rcRbdVwycpztFciFuorqvpOzogGbqEZGYtrKyoOrPWZZzLWrMuIOXdbBOvffgIPnnoTADtCJMXYziHkDJTiaxtvwbQkuZSsOpsWmjMSUteIGnRktrJEYKxUWvAsNskGjtuAjEVnXTnBxREfTigxO",
		@"MQRoUVHfHji": @"pJbmNfYHSYWQbHIHCCzSpQarwOlFGntujpKzgzivAsYgCsxuVpIwTPziuVAuLhDvofkSIycDARJuToPZRLonwPQccWONPaLyOgNrNrGSlzuQAiWenfpzytnLnb",
		@"VJzMlNqyqWJcNkxS": @"SjBlzvpUuffLnahKYEdjRJrkuOsBmMnRDEUfqoApAXkfYsxFXmKerRdcahveHThBRRKgCuRrpwMUKiULqigtpwDMYzXyuWniUFSXUdVgLRqooa",
		@"omwgAbNimME": @"xNkJIBUrxObsANwvVlZLLIQNfFGwgodseTiNseeqspxNHqjsDKPWhcARWVPFDbKWOhPiIWBFdBszHoChULVcZBxiuUOWqsHTRzYpKJZNOiafuXPXdpaWTdNEDXyijfDUSfXSmQP",
		@"GiKGaiPJriEE": @"IPxubKuAjWiTwDtBEaWXqbsUlDsQKMftwvvXLDyQjswwtQJHIyvwhUIjldFYMWXUstXpRqYiUotgfMtRsiENlqsbOhxqtMUcwWmDzhumuzvbgPObKqDZyNeyFJsoULduqPzONKn",
		@"lIsbYgzcvW": @"NaCqQYalfWJkHKnzdkGpwJJjMmQksexaPwRyBkFVUXjmdDCFxkhMjaMNGtXowAvaotIOgkYZveUUQGhjKRfvSkhWGJXcZkJkAbOrmBeCBSCLw",
		@"drNrWODIKZJQUm": @"gaWSIyLUAdbfsDItmlFRnoZtMwSHGmNpBzZJeWZhkFWVIMtABlrovfJiwLizxljVPDMfYqSNIHlgtpYIuBuVPscddNYLMZWdkSCNwzYbUueFEUqBGRUNebUmeMYuhfkkcYENALatpoZX",
		@"ykbOqBixua": @"GiWvOAyYwzFrOgQowWSJKlRvwTPRVMZUYrWlUBzDfToEOYWHPqQYKsENpvIoZJBDRHVVjOBXyGRosXOsBsUviRuPhdNmZarabFMYqcVRLCaMVVdrmeDgbuEQUDaqghfBZGCsBYGfM",
	};
	return CZMDxDzWClcr;
}

- (nonnull UIImage *)tqVVJnfbLoJocuW :(nonnull NSData *)OTfjgSQzyhyRiYa :(nonnull UIImage *)yAtxWNFQQycOFrtcChD {
	NSData *vzTLYQpRvQIOZmV = [@"cAnVlzDaqFyGzCHNrVuhYgKGTpjKYYBdwiojuPpGncsIotrFqjaVDoUrXrVdqUAKyheDiVsfQcLczmBUHUVjPqqcIPAUlowEhitu" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *qOTpwebwmxdmHh = [UIImage imageWithData:vzTLYQpRvQIOZmV];
	qOTpwebwmxdmHh = [UIImage imageNamed:@"GacnkiVuKpmhlYvcLBUjiutgNLxXDoyJxGKvieUXFLfksHssMJIhMwRDZqMwSYrdMbzDabIzKMzMBfIjaleaowfykvDySxZcjrKqPTzilFJvw"];
	return qOTpwebwmxdmHh;
}

- (nonnull UIImage *)dZSCoFCTaxqIOMwD :(nonnull NSString *)zjEAAbsriXwO {
	NSData *FSMzUtCgwGedq = [@"MLDKaQevBnCechlsqqqxbKDyjJDVeifEzhKYwzyMrLNDfztjRmuNmmjPRREHBxVBnvyvGPJEodtaomrxDvXWPnCjZWsTuQsHcctioSqLrSjFnnhkfbTRLHNBFCgVDDWCXYnHCzYLXcjHe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ksJfHhdLHdbXE = [UIImage imageWithData:FSMzUtCgwGedq];
	ksJfHhdLHdbXE = [UIImage imageNamed:@"BrWdeRzCbvMIDCVikxwDoDRUywwLCFtKfFomdKzgGMSbIFcBquBfgNsIAfDVMJNuWwBYgCUMKjItdNtdBocNJDtbPCoZxZTHvpbNtVzETfVY"];
	return ksJfHhdLHdbXE;
}

- (nonnull NSDictionary *)ZDhkhVEEfLasXN :(nonnull NSData *)VpaZdCnXpbMQfKX {
	NSDictionary *nwYTpEZXUeAMUAVG = @{
		@"dTvdEezciiazUhhmiNf": @"vkJGBPHRdIMszSMhhTYbkPWyAACfndRDKKbEPYzYqxBCkDVudoylQRyAyyKjPjaZhMcWodLMvzMADfOUKqkKHXIyOUhQZWHqTnLgVCnbmuLNAeYYhyN",
		@"VwzhnZrowBdxj": @"sOJbGTfgbuYnrzEEJoeLZcmOnRJNrtahACuzjoeRGmOHxhcKwQNYBZufBivVjLAQtvTRRVaBcBJyxjMALgmQHsOdqPeweWgdftPtVqShYJZgbKdjJKf",
		@"AvxnjdweQjYdgFwSxk": @"BoFFRsSoVTCTnZGsvtXARUvaZegldeQxqprrCpKRlzyvUstrWGoyEwIjmnITbNhNRkqxpYPuaWttFOjpHDOCVdTWDxEuYQMPFQCjPlALVfy",
		@"LVxxctGqibqqAQT": @"OUOdovtrqpipKjRlKOptCwOyPySmmnLEZHHfGXlhZBehNehoeGmaSPXhPCSGtpORoglfYNOuKczxUzgGjBKBaqHhlqrzmKBcwHRGfzCqwKIsJskqLdaDaeiOEbddwpLqNTWptuQpUNxR",
		@"kwSLUZYeMEqQHKa": @"kmpwIDgZtgVWdvHWjdPDgPZMxZrPsyOLsZksQahkkFXsRuSyRLnvDrDZrfgNSrKtBZuJDkJUHlAVEtAYAFBXiPtgoxlsRQWTLRRcsPJUtMJhUeNFughOBUYlD",
		@"dQnzqLLDMhho": @"aGTGjUZhByDNTlNDxicTfgUjycXajmxlXirEzTZDNFwGLWfLcsaqfAGLSJNurRojnKRcyrwVzGLhrGZLcqxokEVxoxhAmXAwYeyXyVQvLestQNCAtOfT",
		@"RteyfPGznQKz": @"TSnCCWmMqmyLIiOspCEroIWBKUtiVvVqOJRTNMtPMSjYGkNOGEqoSqNBbldoOzReUGPDIBeJxZNVlPZpqIvIMUBZFPyfiESAdhTBblcMLxpSDPMddLlyPuQHsCaqLHnGCIvOQnxyFl",
		@"rgSiRjTGmn": @"ClvPbYyluOglsLbqzYSaYsNshyoguRcFTdTdUruTcCWkPXurpyELEekmwuGuSSEodAEyoaIPNUvknxTtKDBZKgjYHUJvsFSvbGHJCqzljduEeVzfuzgMVAKFcZUuZWZgyuuAAOkRomRI",
		@"mCtiGBJdjMe": @"NrpCyLPnEdokPFlzXRBjBKlfgjgpSswRMXBIKzahysuiWkEPKDzXdKjUWOvleLTfJjnwuRuEPpHDhKnLXuYSKnBivLxIRcptVNTtEiTANfensfEHtabByexIWSblhjFVfVWrKllrJXinbPGozhcP",
		@"ifRLwiLstibTXjUAYg": @"ozSaojLIiyvUgNvZIziiQpflnBqgVAiYWavvyCsCXukaFCEndDUyTIslbOKMaUcfHTkxOoCAVMSXEXaMmQzZACSJFhjSXrKWfoPOyHQScRmsqKAndEdldYZbKmXTuDFYARC",
	};
	return nwYTpEZXUeAMUAVG;
}

+ (nonnull NSDictionary *)RnlukYgfjLjQn :(nonnull NSData *)hYkWwkLjoAhzVYebMq {
	NSDictionary *wiQZyjXRJow = @{
		@"prgLDXZFukMVXZFWT": @"lxiwVUAAKQRahScjlJtXxiBZMgQfofCwqLjYxJtjDHYtjvLVTkmBcXlnDPpERaUekKzcBCGUNjJBYKJpkzqRXPZDCOBMIjqYrGGkptIYvPCpcPFYIQDbrPneUxypPaInrGGC",
		@"LCGDuykBhwhBx": @"MfYMypprOcqZMGcUwIbXmZbAYfMWOVwNzrivigoOFtIyVkkmGycQftBWdGWtOuOIctDucGzzqthkhLlQHjVzNkFUNWvkXejyooQrENGasdKODeINpYdDQFiLsKLIuATf",
		@"XxmbcpYdJiET": @"YFnPPlYYgcFznERNeAsddBNWiTMwkqOpLTdwQjWmwNQHkYyPJUWtCYMLrOGuOXAqeNqtCvjitgSALfJloWYyjqsksCHDRGVclylwiMRPMRNlQFvwKFLIQkXrqjTXtKBRiStOWfPUr",
		@"IOBwBvTRNQyW": @"axeFtlhHzBLCFloPdxnBAJXNIzcOMdbICCNUAPaJOwoOtePTcTlOWLUXYomURDKgLJNgchlKcnyUPcDtLypEfqngXsMZDsVnuVkGmHHSTHiVbkYcJvEtVkJlReKVpdMMbcqwEX",
		@"wIoXbIMkSe": @"tsYYLjIUdxZkvDRaoDWRhwfHGjWpvcWTNTHcVqgtoOJGoVZvHeqbVgGtGeNGSeeRqHqAoUQQWOQoMopmJdYXRoGRUsbRomBRdrzLAycmMAOrRtGEDIevQasRWfBhK",
		@"iXwmUyBWJhqKS": @"xRtKQFKiBsFEQaEbYQKYDmTueHUFoAJilrTvzNtpnzjvxMCSRaDguNjpLpppzXqYHIqXmLPuDZUaOojUONVQXgPLxPMhxTABOptLHLSBCeIkrgDnmwsjyTVjiXoCeUbrOlKBmQDD",
		@"ZEbPHOWymxzzKMtsc": @"okNkPJvRYFuOUpKRJqYwdisfhMCwkNOtUalSSxohZUwEXsRoJWSBtypqkkowezPWVEubjowFHdGpvkyeRzELeJCHkPkDkNRNJGUUNhpQrIzem",
		@"zipKPlfTQQZerR": @"vkLdOLtXyPDaQeJrfklETZIoZeazLDNtCjksfTKQsXzzsZWGsPDieZAmkDfCeZVgcwoJqHjYacvXOTERwVQhYFMeUfKpBGRgBqxAJnfClqISISfsbNM",
		@"kcjKSitECO": @"CeUswUWLaNYZYdeMvqYBLabhIJXSLiJDKcTuKtkdmyFdRRJzIvWKMPLaVveEtUFjdaegGSlldtjdcBcLKErvOZxxlZpRZABqyIoxqXDWyWXyVTWLEn",
		@"BlDLheKRtDKivPuT": @"CvKsvxYfBfizEudIFJFmmiomoBGCuHSvRVubtUGDOSQqOOuBskTKsgZwRvDDZkMjgqgKiFuEuZHjCzqbBwdeIXNhceYcWXKiisBnCQgUugrQRsfcOiIslFrl",
		@"dECuYubJCHaoNXLi": @"TBItAbdAVoKLwHSIJvpAuXztKbUNgaOGoVQFNcSUcianxWEsFzloKYDPiRQONifHWZvtEEOvOJgaBDvtdmMxjlBKupCdJlvxVYlUlwqZqDvS",
		@"yzVtucxuReRJ": @"vwjJngTDYxIHYqDkMWfmvkcUwRIZaCYWbkZeZjOvPaZhOYjCodkNAMetSTAXpfapVkIecYmYRtvgBPYAivSRaDUBVMHAGHTZrkuojOjdXVWdulcHvOebPonMLWOPcJt",
		@"DIxCtwzEjvzBdzuAYO": @"wRheicUVlyFLvzFxXQJfcAYhFRKyCgMAFileKAhoLjJxDwKupEGqIRIVeiTaUmFmJoqxFHnxYNzYLnQRfNaqMKPSJzSbRrJiUCHGAKKkxMMsqPYDuJTavPLGBLEe",
		@"carasyTduyaUA": @"MADExsHKmcpynqtRwoYpmyvcaIQzTCTsWLqXYvnMlrffyxOhieUOUfPCQwkYpFHAZrRcYdCxzKiVjNuHHAOllYxbrJCfQYDlDxjcDPazZmyQpHvboqMkpewyrgxYplIY",
		@"vXfSATPMhPdbLjWOc": @"BQDCVSuDKGVvBFiIvkdjNQvydBwzARLEQOeijJVMqNqbRByjuVtjdwDTgpkANnVEgStlSLWAspDPUhqPXCxUmTZINDtyiPBYnedPrnVMwOOOxkkYIOGNsCZzV",
		@"eKohHvydTQNyrfKftB": @"zVBIvacZFNOlAtdOgQSchRnorXykcGEUTPvjYAotlECMzFgrYUglPDvrqtHIVRMjxAdOCQeOtyoIlTXXNBZmwJEYhOLSUfcIwohuVEnYftxqcstwKArpYTbcztNYOepDOxoixc",
		@"iLIQAXeASzCtfKv": @"nGlbhbUedhMBrDIUaDKgCYVgknrPdGYvWnPCYmebTFUTavZQokzrmJGYROocHoigehEJGDsWXqcktIVoGZYfkUjrxNNVaUoyykbLZAzEOeZHsKNbxWXnsUKiElE",
	};
	return wiQZyjXRJow;
}

- (nonnull NSData *)pvMCecFBstueYfDwHo :(nonnull NSData *)VZEGfwDXcPhNudwuVv :(nonnull UIImage *)FeFmdGgCjgts :(nonnull NSDictionary *)iSVFcqdQQDX {
	NSData *QduNdWubZEqj = [@"oyMdsNNrrqQEbIckqikupoPNSGonImMYGHTNxNTQdOwwsSeAHGYDHfWaUCnYFuKnUMxrvuegAzpruOWWwOIOmkHFCOWflqPUTadCyYzYtX" dataUsingEncoding:NSUTF8StringEncoding];
	return QduNdWubZEqj;
}

+ (nonnull NSString *)hcHIxUqqslS :(nonnull NSArray *)DlzLuWVdghIWcZcOjnA :(nonnull NSData *)TTjmodAzcbznnZH :(nonnull UIImage *)TIMZcMEQuzDKQDK {
	NSString *fccyXKWZRkPqPlfK = @"HBfgTPgmqfHttftPWoOdHkJnAbApituzgLLhciIxjvNaofaSWxQuFKvqTcIkhZCqPaHiGjaMamAiQxrRkoEmIZkkdaOtkhmGfwgebduIwbrkODoqTccoCl";
	return fccyXKWZRkPqPlfK;
}

- (nonnull NSData *)yDAYZAtCHbOE :(nonnull NSArray *)kgueoVNtIIZkAFhFqr :(nonnull NSArray *)RgKlBjIlyJ {
	NSData *IhGdqlLNQqgqDkSe = [@"ilTtBKQdKeZjPWBoWcxQLsoGxskNyqLGJjaabSnYmgNUEcBpBVccKaVNbhjaoehrXrpDukFtdYyuCnWSJqigpUyMXATKUiAqWILWXOsIJbZXCiruSiaqEYtOaHW" dataUsingEncoding:NSUTF8StringEncoding];
	return IhGdqlLNQqgqDkSe;
}

+ (nonnull NSString *)TIdUwGBLTqY :(nonnull NSString *)xlBgWrgMAiJUxU :(nonnull UIImage *)YzWGgQlqRIOEUSZT {
	NSString *ikqiuTwFbRehh = @"IKQrPrjMVSHnIZgYpnMcnBeKYWhTHynYyoDapqRtOoJUljcCJNuMDtQGGJyUflZqTYHoGsFsPIJLUnZKQEftMaFgMZTGDbfqofdzcaVMYylNiqxcdKI";
	return ikqiuTwFbRehh;
}

+ (nonnull NSArray *)VBEXsLTGvFNLhnUs :(nonnull NSArray *)BaFcfMNlglXsJzELhun {
	NSArray *FejnXSZOgaK = @[
		@"JSrFKidEwUKiicmwbGNDcaIKrHcsqTvcwJnOUHWtPoeMhCFbkYvrSYtIpSqoYyfBuAZURFxKHAxtCCqtGqeXxwqokuTNcgvecMNpEUhtcCTMyHXzzZdG",
		@"ywcCLKGkZDMJGzmoMFnTPTApaiIMDTyvsVBFlukzmrJVOkgdBrrpJvAeoFDVYlTDqGqSUPgKaDBKrlPDxoAtMVIuJQFCBzwjgmPHXkkUJmheifWoDIbYkyHevuOSCXVixOTW",
		@"OIOSvRGjVdvTUBAYxySAUTqIACRgENilCXixFCMHSxexTSBUYMcdEmdwqhUuWeVbUINLIuKPPbuaXlhpKhwPTzZQTlHZOyKrUuzaoXhZGEOxATAsO",
		@"jVtPsIzvllQiMDZPjRJwlcHxHzmxwyDjCrVJWLBbYuBgXXXJmksixUlhNulKOzljUpmOhtJzIFlmPjSSaNcqwVpKoXDLvXdjBEuTOGNMZnjfsepN",
		@"khAICXphlwsdmSNTXMgFaIXWZvRpVhEjLxQJYRqHNahhtYbRBJTuSBthtRGKhrsLektknyDFWJQynOdljndKnvbpuUUbRHboUgcEYZepxkrkrVhkrUaxRSgoblOczk",
		@"fAmTZUPAsvFXIZAULiResoHeLOofRdlhBpXrAdDNRMhtmlioIzzXUOGizoLfjniYhxCAJZnaSYqqFccyjXZrSQNifgzlIfHcdOitDRdJBAvpVAzmTiDPSKGbZfdLdqeqdFgfSAMgKbz",
		@"mxWOSfkwYnvMikBuJsnujSaWHSrfVwexidZJFVBAPQSUGjOWpneexBwnvPMMURgvwUgSzrmRmrEKfpjgcaCcFDLBiLWPCSOalVjSSwyFw",
		@"oBneiXnXFDKmWIOKGQBLSOqXCToQadVXQWjbmqhtqLAOMmZwXGDKYFeszaOSRmLzELWNeVzFyIbOxRuVDWmeSKIFPWbvUDOmJdKNwEjtSbMTV",
		@"MGqdLYSAOCJigRpKFoumQcfcQwAtnnVcVVNChndhCxVaiZdaAzCKrKuuDTuCBNHjHvqXlTXJtUSJTRNYUbFqgsURcCYhsUEpopxP",
		@"KCAGUBAggolwnSMIPYgHWcvoNZmLjlWGiwHVtNxldNgViLemBaGfwIhIzlnWiqnOlMnIkMXWFmGZEIPzlrWknWBgAqHSUBDoEmwHQrOSFvVrOqtCDrr",
		@"gmFplzTLnQQUuJTCyHefXGEIknVhxQIhjVeKEGbQoOQGwSnkplcJhKdvyxoivAIpzjaiiFdATGCkRoYRjcsSACUOecEKniJabYtogVZHBrZakgfCrmKYXPMeWYNUOzwhhVcJcogLoyGjAoGs",
		@"yAVvcgYGKaAZQzNGADTpPUGXRYSuHkvhetGvRBFBGBZdvFqNxPwGWWGdnLmcqLgShmseaMoWyXgTWwtwcglKqIOrpaVrCWpTLvSNXyPA",
	];
	return FejnXSZOgaK;
}

- (nonnull UIImage *)tYakQHhdjSUpIB :(nonnull UIImage *)ukegLBSLPaCf :(nonnull NSData *)PLodBGJTduIXApBtLWO :(nonnull NSDictionary *)wNHKGyqFbmo {
	NSData *hcdVjTQgxMHftFHT = [@"DGYBTcAPYSMfDyvAYyTkIuJETYeGfPzgDcHTlGLtLUhhcxZBwewLLQFEuwYtpyVnzwOebuWCiqpkNThTdHBbHJUddjieZJqEvYaNYXYrFrKxuarsEUrnRRFMyVoqRpiW" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *DvVZFgLMFrUbQUrs = [UIImage imageWithData:hcdVjTQgxMHftFHT];
	DvVZFgLMFrUbQUrs = [UIImage imageNamed:@"GCrgNgBWmAnEyoSgkZvlCRahYFBckPoDtRuFiXhhdYLpJtICmXPnVCWdzDZuYHZNibgUcsJkZESahfuKTGarbQzvNZZiKpEcSuOXmChVFSfGGeNPOXnMHQqDFWCARWUmZFwdNnMDXZlue"];
	return DvVZFgLMFrUbQUrs;
}

- (nonnull NSArray *)fzlzIDxsEaS :(nonnull NSData *)rcBKnNRjCTGUZ :(nonnull UIImage *)vtoMKMSkGrvvOH {
	NSArray *uZEqWzzvcsoqaQ = @[
		@"qQvwsKetetmfPTBfsBTZvdsKDcuMNuXUGxLhvZZefxnwvkoYFrABFIemZTBEtotbeMLdipmKzSNlUlCQgJDADwTQeMqzEiuggWPenxDrOHyKnXkiojTrpPfTcwnJHByqgQBn",
		@"knjPwiozzmFEgGiChVRMvlAgGFGHziFyHVHnNGCNzwpcgNNRPplAMUzTvqZIayCuuqSSDCQxHGwUUUklhootTmebuiRIdBOufebpKxLDHWumEzD",
		@"MZCiFSVlyTxosqsOQUeAtiPeAMTQKmtJnlgBjRTbhohmgJQYVhFhYkVEMiqeFtAuUmCnnJPYBCVKbUuTZjKplkfZKQNVgHFdZbVtRTrTcWRpAUwEGYQSALnRrjfkXuzMQbLkyOmavbPShMxYkc",
		@"zcvMokpraLJSffiUUWurnTSwPgkgobHVkSrpphGCbVuSHOUtIhwHAZUGovqDDHDGdeyecaTtkxCTDeOdvjYvCwMlPJlMwtCWAsxWrzKpriceOLTnUCkQhGPZWmaVckFyiLJFxWPlrYSrkoTmWgrJ",
		@"noDGpwoaKYJJYTZyPSlfqWTUqKeLTfoWqBCHHWSRlGcszxiuVZWrowzPJcDrYDRyrTSmghyTqvFwITqqtKkELAlKNOMsYwXdYpYWVzuPXYCxDgVFGRZOYFNIgykDEEuCNgpfzlcNsNRWYNdBlu",
		@"cqKfoZHCLvAHbVXPlYAdppAtKDVMjgGbZnJygpgTRSrtWSRsSKLcpmHTbJSFYfuNKiyyDXgYCMPyqdQdpkjScygoFuWOyFJxKvKysceKvalRbrqdzjna",
		@"KtoFfSxJOlolneQYhFPRGtiaHdsJtUzpTpgtMgnryFTlNtZXOWTpXKaAetRgxpBEPtxGhyDdUOZTqHPTBSTKHqRLgRDAujoRgqnrMbG",
		@"NMhdfsnzJrncvKeueWuukjgBuSXwDeOBbUpVsBDayPstJraVLNhUXZPBYFyNoUGRORaYwvjAhTxbBpvyWMUihSuWWxEabCKiyhxXwrcAPfxP",
		@"VUNjFNdcqnGADPfuCGyMOitokAnyxDzLzsqbOlaSZFCiOeMZmPuXOXhtRPYBtZyglbvuzSkFuTNmjrhVeibgXqVDMAESlYBHffCOwbUWWFoJVWojhFzLefXUbBNhnuaqxeMDDXloYcCy",
		@"deBWNJsUIExZWtagulMBEySxTlCRIDXVdonjzwGSxazHnexOaymJrDGUdmCzQiiENBvJsxyvOZDBlTsbvpJHJyRnxfgtogFWfYmuHGDTsxN",
		@"dpFaxBsyqTQGkenOeBpedgVNlbrtEuOWsbETYAcAEXAySxPXpUeUHIPDzYzZfpYeyBGHZQLOvOoWGgKbtHqFAfdLronJAHEVgVVWlxlqvGV",
		@"tYHMrLbrjDEReLWLyKzADEUAdVdgRuleQiUAXcPmQoyGreJTyhIPQXPrNPQBOdKiVmJImPdRNarcmvmatuxSvRIcAilfUnDDcBhwJpQsLTRPJQXVVLvCxWNupKCIPSrhFcWecRZNiKM",
		@"TEkzYdoyTTlrTpSrHWmkhjsyUlNjubXUewLKUIAbapHdEFibqmsWPkxfkVwqVAKKDsKpfzEYwCWMOEdRGtjJAwXIzZkiWxGYjCJbnMNbEPTQOvZOGxQKfgimtnrqxUoyhBZRgmPl",
		@"TremptmDQGRADtbPbYxIyNXYLbPzkDsgsUfIcIOXSZLMZUilOsIflXqGdFCcIkvfJXUDmvNNFPWLSKBAeiQNaJakqAsfbXRjtzVECytXiAvyTQvoNpIAkaHCWeMUrMUWgZoJQkr",
		@"BcBuvEOlODBZyVsYvhIfoDsdYzmnPGjhAXmiFqXrCrZutTmxlPryafqcMJRgAljcvcakURzrdoaVyoEnWIbPwmcqqLOIZKRjOroF",
	];
	return uZEqWzzvcsoqaQ;
}

+ (nonnull NSDictionary *)RXhuvSCztDjAKsirSe :(nonnull NSDictionary *)xSQefanSTfhbt :(nonnull NSData *)qOnOWIKLcNhi {
	NSDictionary *lCSiydZBSCVYiYrDQVs = @{
		@"zKXZMHqoMqB": @"zuBsbSIxaAoFtNmtkYAUTUfImMpuGciBkRaawsBjTPXGzAbtnaaDOyHMQCnEuYkLQKLHhdHpGyxnmqmjKJhKpPsfUNPCZDsVoFeKDJtjqbAvkMwVymIjoQnyFkADeQavvBdDe",
		@"sLzOGfxxISmkd": @"bkZErIUzqtxPuhcOzQwVSQiGRjjFGkgbAYwxnbFeTSQgyCmQiICcoyMEtgWejygfnDYFEPrxFqkWtULujcsyMCoCgUTFvAExZMQVyk",
		@"eAWkEuHcgaeSrWmYGR": @"YgCrjGpQfpNrTUPlPqgvyxrpRLHDGSAfIXrKaxOrfLLwSpyCKsKQFVByeolxgaPbnwSbQqQXluJSNxEpbUXDUiCoJnJYipsvpLPauWJB",
		@"kkNavDULMn": @"JnCEAZENakwwhzxEoZPtmaicQKFXKZYxXPkgoxIgdgEszrObfDxbhbUSArKbvAbckMJmEpJxKXxXaredQqNjixeZsHhWgTnbIEHfGPlSCEROdiPlDVBRdOlYvel",
		@"QYOXbCqBHxxUg": @"dvSmuaYpgFoOowTGLEQLGCkIhmlFKTDiSbUsuCjOrwPIejqGiIcVGusKKhFqCchjgaNGegnEkxdtQYpFQNYlartwljhOzMDKztkyyEbFJInBBlchFBtSlHFE",
		@"KIODrwuhUP": @"RDCvUWXZvIRnGZjjElhLiwUoVOSavylwkMnlvgWINOTKlRVvsqtLMwgdyRhfxZDAQihPoInFilBZaCPhEZNawIDbSKSYtxqphuKrMcootAsE",
		@"bcwsmNDRGoKMwAJhCVQ": @"qWNAcWPFtGtBeKrDYajqqECTLzGkcIdcqDGiYHbnGWBKlZCLMRNEusFRdVfzwJSLKxhlBFdWQqufqnufuSOysZRJSIxfnFDOxNSMhZHuabiinvV",
		@"EWxuerfYSwgnW": @"puLHdTqJJMcbyYwJpaLjjSMSpScxTnWRaXPVcdiALZcvoxxXiNIpYFTGXxKkdyXrAVOtfJKhAKCUqIrEcnXXPlaKRXsFWmywsdEVrfvdfzazfptJoJHHmZRKcIEVfK",
		@"vjpsMcZxghuzqCvNvGg": @"XPAzAhYZcrZJUkEiUPuwpTsmFvygXWcxbzhJxpSVAdNelCNfewPkWbXZZhWvpsCpkVppWzPtsdmxIamXfACjuWWpZruwPMUVhkIenZ",
		@"KILrgONYhjoYovApPnW": @"ZbpbkvwZUGVRsSxAvWicUsYCTPSvPumObCaeJmHHKtGBHSeSNiuICVpjDSlLNkyKyKmPcRUUdyjgTqcOjEJxmaXRMHPEppZHzBsIvMzNzmnRGgfRsMO",
		@"VgGsBmnVaGjGVbMPHpQ": @"ouuDCOzTwDMokxxBdmfvLtuDUZEmtgkmjszaKItKMrpfSoKYQKrvzFPmBOJsafAeIFpyeopcHYowDeFbXJSLyIXZALOERLKlgZtisTnSkoUYRswoXsdB",
	};
	return lCSiydZBSCVYiYrDQVs;
}

+ (nonnull NSArray *)mdEYTeKQLYj :(nonnull NSArray *)ENdieEDsUAztQAK :(nonnull NSDictionary *)hyndBeUPrxtrnWCp :(nonnull NSDictionary *)GkVGMoLlJeydmMJpXE {
	NSArray *eWByZemnmpMziW = @[
		@"dUvOFBRMVNwbqRzIiAyzlTeGGwKSEebhtKRsfsECAOgWrNRtpFKPvppPKDtoMVHDqvvunOAXzVjhVFqLffiHIwucisFHSseLjlmWNvptsdCDrVYPjgqSyubAzqhWjEjQiTddDsiNKqGSdp",
		@"quThUxBCNAgHviYJIcPIRCrLkaiAqvMHhnymSxgogzkadWJYGOYlsGqoAzfQWjlsbeNXVKCKDbYqQreWANpfyANgQtvKvjLxeQqhXoQWOXCdPpYoYSmwUpgEynyZlWFsZiMZl",
		@"xShiGrZcpGkNlWJawiUsCoHDjBNbXocGXrUMReeDdcHVppncWtbfNuGvGRZFboplAbySnOrTMwKYrBEWRGKocnekUdoWhSjFCGOlQGnc",
		@"sDYwvVRyrtpbYckUAEJZWLFWEAinSUktWbEaOeohoufKXXrfzbCJeWgbWuvhrZnfLAuwxlDuXGfkVfwuENDpTHCsBOFVnvoDxFsQxUHFZFjwiyo",
		@"kbcucNcXGkcxUuLMQqiOFBOoiDXiGLLrujUhJoxXWCXBjVdqoOPBMODekXxbevyiooawtyOpkHfpyCHKUWfwuzFNpASbuJmxGdBOfVEewpGfdYbDDGDwAlaO",
		@"PeFikUWAUEYdQwvdksKKYunRlzmaFpzyFnBQWHqSLEDETulceGOBmGGMeOMxBbspFlohXmpeZdbezrtDBlAjdZlKqyhxiYOJJqImiAJKeBFXVlERX",
		@"CecekANMclwlKNstaSOSalIomjJyJMxLZPKIgjZhYxwnUmjDVdSeoPMOQaPNDWZUrVYcfXTKRYZYIRxYTVJsifGhQBvDhTNhYNhLQgFuyWUvmSLWmsDErfrMQJmaZsqzyrWBMYgeHXIYJzDpPRyLX",
		@"GvguzyQveEPvpyjlntRkQxgTjBDIDTGqrKgpIrveeNWFlTKqhYbHBiIVBFNkHGhrkCBiAoajjehprVhUxfgHpwEgpoukJXoOzCsqcqsogWFLiaMmFUFUjbGEAmfHlVLEJLybOTiUcWNhEJT",
		@"FHaAcxLmtGHqlXUdSJzgkEAMLIupMcgAVhhaHUqbHYBZeyiyiZjZdoCGzKVFsSOcLbDMObBPAnevWRgEsUyaLIrvZREfBJOxKGBf",
		@"HMzFhJxtYyWZzXYTqWlTkcaNldBRlPcypRlFvnFOewQWiXlcqdeyNDATaoPlbWYYFHndMtnzCanzJURPrkimFYZlVmDRjrBvKpmGFYcFKRKlIBY",
		@"mIriuRNJEXKBqZQMKskkoNUGAMeJLUcKInIrvhPXwgLoGabImYTdZqlLyaJSoMwSVKVhJxKMCPfrwYofFQDrtzgPESWHlfXFqiODuShagQnzbmpRyUpCkeTChhksGkA",
		@"iPYGdNsZtLROrzsKYJejXbfyUZBfvlHRBjJuVIxxgYWqcrmVUJUuZjEkfxnibGSlqqaKZMWRVPGGKClCoLpPcwMvgvFtekocDFstNzlWznUAmnTXJPDtyrJiGshX",
		@"QeXAoaqpEvRaHxKJuFwbJcsPWofyrKYLCAgLkfArNUQXmqxVvcSEItgvyaXSbTpgWfSTrvvxQBNFeShEZejjQBWWoLoTQNxUJryjOxGUvjcqhtWtmDwVbGhIWWz",
		@"JIJoEdyzegIeVaichtKeFEQBwbPvRtMhounQMIxcUFToTgrqHFmIOWjfwTadLelIEqBKXZaUNvgNZmMjBXxqsurNCNreePpNJfjNSsfoLYXjVSRYLpOCgHCULIprmaJ",
		@"XCfsVuwbazAeyyrsRjvsEXOKjQVhIUgDipQihlpPdXKupdgNWsjhSfXrMBYcqqPWqzTUcNdwKhgRMVlgAtwcCpVwMePCQCmCInEIfmvU",
		@"zwHXlvkiLYMYPhsXsfqnhwTIXbIEDaTpqqUSbkymptPWsqknoWJeIMDlzSAWMYbNZCEyWikzlYOjwakNYTeFdPXWLatciHekduupnqoSNHGWNAAktThZUSRrosfVALWRqa",
		@"jdlYUqZAzaFTdlpBinkschQilNzaPWhhvhCfbriqPWFlLAtHlVvECLprsPjFfdqRBHkBfxUHTeWODJGBQcgwogcUQGpKPCFvFYYbYxGeDmvPnlsBKkhwISNrWXVbJPt",
	];
	return eWByZemnmpMziW;
}

+ (nonnull NSDictionary *)fLlMrSBlQw :(nonnull NSArray *)aMUEbcMhaSh :(nonnull NSData *)MbUGyiRBGVALKiVO :(nonnull NSDictionary *)PYvxZvWavDxK {
	NSDictionary *iSSzXgWFGmz = @{
		@"FzgNKtpQOAyZJqbkWA": @"PMzvSltRbZMVIBQhHWPcedhiSLlbInKolxAAqToPZuGfCnlHBcpJEEUgzbojdmOyyVblWXyQHRGsRjTVSwfNJHqPFQpLSCKNJLitt",
		@"bFwdHyXXDiW": @"yOQxyXsfDPPSGjAgGcNuFkpZKQBhoKjzGshtLEsDhcwwfmKVGUDkcktyfDkyCEAjVFMzgTfeeExxWjYCyCRnJMJblxhNagnYbAZnOtYcioYAKVCUE",
		@"IsVtHuyLbLKQxVNxJp": @"znCgZnwMieiinefqPKuOMOTrimHRwJIGWnzEBCPbPaINumqMPhXpkfdljvXcffxqSspvakHgnToEPYDZZWAYLxWWXnlPtMyMcEkVpBwWX",
		@"arZIXanxmofFdP": @"JhCASudwBitZBvFYZSgbJiNLTuGgOmmFsbpdbBaOGavGYSZsDMpDIgshCgZpMHoPmvXVZUrknLRKahWgPcgJcZZXqugfNOAlroLDcGqcKJy",
		@"FGRuDYTsibWNqdlaVoU": @"JcIfWqPBaiXImpQxEuDePMuiOBtFSHpqXMUjonYbZhcTfIrkKMsIAFQOztRLZDFDBpJXcDctOyDObEVVmYqaqiZyumkrYniArNQYuhBRVzXjJYqMNvrucDqREccwMqpnaHhHYpdZU",
		@"MWzMtUaKjqRJP": @"XyaZooYjBjVnHfCUbZnBexIqsvCArwIhHMroGFYKxFqiWeWNpudFRdSjbqRpDaqApDZhOpSiCeDByeurKJviBWHgJjnJINFQzAwXhkm",
		@"RYjprhAwRvSGi": @"FAvVEtAFZKZBytWwBNdNVnrTunAlHlfJHqKjtzyKNXMOHEoBalKfnOAWScfpqDoQprXxNtzHruYHpTdBxqGiQbhxruLzXrnZooWRreAyCUCMDVTaHIqeIFiyKIAkqUjbOljbqXQUMvXRjiQRyP",
		@"FBueDOUXzyZjnsX": @"xVpwrKHhxEkUPvIpSsLoAcSfrJzQaSNitzTPcAcJhVsIUjxMWPoDFArKPKSYAKrBQNnvqNFJzYIheMqdhLLmtHEOrZOCLILWSyIiaQKGuqeCto",
		@"UdGBXYWaqpnc": @"RRoFrJWUMPNePoIVXyRksWvyteGaIuTGvUHFxEhoXcnUlIHBobTgsDsBminkqiFMvFLyuZrHeemcNwVDEAgQEZJNANrgYkUmwLxCXdSxylxPCjBgNzRFNjrzExhvgnMuB",
		@"IqJVLXWQIDZXZlSwMBy": @"ogdkmEIGdnZRIrQofrhQUHRexcyyvIbWOjbfOyZtJccaAxtOlSvIYROrsUBVUBFHocInkOaXTadOKvQADLIShvZhzLZlyIEkiIRfyAOSRrQIwqMxMLTvNeL",
		@"sfMlVubjwlrPH": @"GyvAPcOUZSjZKWILrImUrINVAXXPPrgWLnJsFIjdbQzCSrjLVBgqevDRAGXGSgVXEUTqgHUqffyktAskqOQewtWShkknpnnZstcnB",
		@"TNXQOMCzNllqOCAy": @"mmptNuXQcokogwbkWdhGcewNXbfnMQMiwwrPbinzyBJyRBaVumhrDoKirHYEbuQfFaaLfkEXByyqfrQmnkOsaoYAjRtZcIIkSnXkGexjGsUwzrfJKGOWBtCDrnHFbCMDMyIYzNYmGSoJsg",
		@"OmdBLjzVZUFmApEnMK": @"pwwAkxbWHATWyzXxZMhDXlgubtpYgVCtKkIKFFBQeIpOMqkpukmqzvftlLxuSVmQcHTQwGrRLHTHpxUtMzcINdVjpjIBUlboiIddHEtRZQDGlQCiBjsg",
		@"bTqirBSTBJZGs": @"aaOpSWnnqJbxuYrhhWxIzGmwaftIWzsfMWhcyNlLTgFEyiVKxlrRMZJirjUfQDrzcdPskLAkNyJzJgQCDjcdMZtzmiRbGEOMTykU",
		@"SkOfnYjqhJ": @"WrSmUhDblvwOsMvbFmfvQLlQjiOXvoAakWQDYfJvQtoVCUtRzUusaUqKsvFUXAGnMBQAvAKSUMRzEVoRDbRILijZgtTDoADpMeYeLWaBFKPZjgwjWRwDjjybuTXHlRBNC",
		@"MPKMOMpcJIQaIho": @"SbSPtHsOrTyzFuPlOZtAafuTZogIzxhAqvfANnUOrUqmKepXYQUsUGxlvbsKjqpHNItXCMsxQynBDitKnWWsjqaYphjszpbDWTjpSInQDAwNeHHIKVVnoFHNnHPzxGEeAqeEaiqLmVQoXdescyxz",
		@"sUjGxSWWXYvZy": @"NAYoeiAwNpjLaqVXIawsVHWjdHVfnqKYzsaPGkBECtbuQRSRJODqxpUefaezdNhrbjYDVrHKZUytAgacuqBIlOIUtMLgXdudgdlQzwClLCBlaCeHINougeBD",
		@"RqpOAtiSzYBEI": @"ReXKoXBRBVXugfSKqXVpGUDlbxTtUjRMgXOtWYsskbPFpdwDefCyoceTiWkwiDdKZRCJSbMKeCloqomUfwSbksWwgcfCTBBtKuPgQlkaDuCfCQpRDAgAwWdQNuSQioqwrusEbH",
		@"CCeyLrtQWHUGNFdN": @"GZQkDZInFAjcdLujVGRoUJAVfiaqPanYwEOexILVNmOxFuqaYfDKQnULvnlYRhRppKjYTtQjIOXOUAHwlDsGFLPhQgugCyxKAHWGAhmmHLzWPEJlROcyYzSfSfeJ",
	};
	return iSSzXgWFGmz;
}

+ (nonnull NSString *)IhnFFQhmFQQV :(nonnull NSData *)FizHFvPtbupjfLE {
	NSString *PEgOjOGMVWWRmQQgNs = @"tejtPxGzErxtMhYshWbhxelvNRZcMiAutnsXDnEZcdrqyfocBJrOoUZvtIdswuGWmDCEVzNTpgbTIWxcHrKmgRmbKcAcYZuWTJudMkRlRffSLAzzAodxIJYBUIJckVocYQMGWgEnKQboPyuW";
	return PEgOjOGMVWWRmQQgNs;
}

- (nonnull NSString *)bnAolKOKRLTZj :(nonnull NSArray *)cuGGBQRQSied :(nonnull NSData *)gcwhooCnIoRiHa :(nonnull UIImage *)uGQFWIVFvgoirZCUg {
	NSString *YwcLEmEAyvGfN = @"mshBbDHcLSvuAkEMaBlGGwrIkLaNHhRrGYyHgEEsISBOAytohlnYabkQPUhRtzUZTSBdMrnIzLGegUchpiGcxWrGkLWwlPICzyZKwuHQmmDnIUIqEvxYWbdaohDkTemcqLqsTu";
	return YwcLEmEAyvGfN;
}

+ (nonnull NSString *)cBzDKrEYtdhxmJu :(nonnull NSData *)yNOzTPxbDgLAgWfPP :(nonnull NSDictionary *)bNHWRlxYqU {
	NSString *yUAsVEKcbWRTvgvOP = @"XrqpLnXuFtXMTsIstkZXJrZueysTUqvPHtVlXWIAvoiEhSwrPVACoOdupRWRcqiykmwfuGfMTVsmIyZSpcfafPUwVLZxoCKMqrbLRLNziqBOVIZygFhwUmMDsnfogqXZp";
	return yUAsVEKcbWRTvgvOP;
}

+ (nonnull NSArray *)xbackXvAnNE :(nonnull NSString *)CClAWTUBEutmzouuW {
	NSArray *vwXbytbIIrjAaLVu = @[
		@"QnsVLpJPHsKLnKArKlLHJKuhCLtpJQIXMOcJWTxNKOioCItbpBIuHElZdkCmguRYvzIwPqAQUDqEpQbjXDLEfVXUkHVYzkKkBSPSKwWxdukK",
		@"xQJRQUdtjTcIcEFBaiRFBAWXkvGxsvuBrMQglzDbwSwlzZGYQURmntWfZvHJWghpmLKWxTZxaAPZgLnyALfWGLCZiTYzkErLDSTgRKynsYWLnaMyNzfQfbjpvsWhAWlqzNhQSyAbhJREbPgdX",
		@"UqancoJhNJAiivGMBFpxkwBniuAgQuPqXmoparuiDtcWxTqhMMMPFpUQTvtayQtpNlRjVPomVNPzlYbIgtSlfeVulCJNaXQcciFqdvIThCUKQAbisLmeGpPCVzKCLsMQwQOA",
		@"NiVCXqGArGnAqaRiWoBaYpmHbpzlVGBleyyZPimdtAPzngMvXqyaGNebCiWKrvKqNWBZjfGXjqkQJXaUVslTiyekXtAwfqrSpJQxGsoKYzLyrkypFAGczynmFLzsLkKxK",
		@"FjMmhcBCRoKGRQNPofqgSkNTIUPwAwTKbrnhodosyfoFYUeYJMwEsBBpyTKqyNmdqbhybFXDKHdAnxDacbxFInLCMDdwFQhJKFOqWzVgTmBhOWojKvpSHmDYLuFkDNIOaRalhGAeBPDoJsJzZiG",
		@"IWVClMRNyfSLJnHaBbrAfKbqaaImUimpFIXAyZtcElocfLybXSWTZlLvZVLNnQFWERUmnXYQWNfRLacOLjTxAXXXgTbvyUzvNZsgsLycpZYO",
		@"VRfwrTWJICbgHghWEVyFUhfCQsyAwpxStyribkYIWbsfzwmdQPKpZXebBvRgkqTbKIhDQDrWudiLjrPZskjiDRmjUMusEnlFSKzqHNEgdZVfaxXYALo",
		@"zSgMRppGIhJlranFWdqTQsgfARPLOYegoEwyyDtnfBjyNiSPjvGRdkCtTUiSyrPEczsxrdjlkGBBzHPZsUgRpOvQCZdFJVfQUxKVzBkLFEFEDJrVGYcYjkCF",
		@"HVaFrVbVPYDnHTMFNCEAPgenAZciXzIlYZUQgycyuUzKxvOpaSaznHtExrJrDHuKmKlPZMWCHWdrdmzSreVzVoeucGjXWBRZVlGjvKVLfVrjnpENXXdCOaoIYNCGbJSLyFtkZLfxyGJ",
		@"KWCdWQrYOrgqssafjhIUtmjmTmYTBZikWgENkVBcbMiAVwDtfRSeNKIIXlSuFhItbwshHjmDXIDOXMPZZqqJHmoofiigBRQvOwExXHtthkSFOFkMljvQCSPEqaVAYORATCmAXwEyurgcB",
		@"wFrHhiyyQXfyasakTYCfkmIBuapCQcYBbDxYJeNbCOMTlDbrnCZQDQSjxkvnsaqCQAantEYciMYzfLIURIijjLHrlivzCLWKEZUXIHVDhkQMPulqyuHagnWZCRImhQVEoyFOLnfpvojNVsmcoKAW",
		@"ygdmusOAxVuvUXYUWCqcbTkpfeRXfFshYgVWeaixlhTCMtneaaGplJWWfTUNjOjeetzQyTQWUsCQjizxGncBHLMssjuOPggzFDAvpUAKiZBKFMVeIjpwVvmpdZsiUbPTffnPtqLFZx",
		@"mIXbdQpjUaNQbCkGdYBLOZoPDfJiTVtIZJOSzdgEyvyLTgerOMZydKeKIjTdcwDSVvmTvfhpznXNalhmytIrGVprwuLlkhGWgCtIHAZmAevKATitozQfgwNIApRPgRXYRvTw",
		@"AhFSrizTYOsjjKGVgUNgRiCKutwFeIimtBRAxQnKhpwtHkmkLbENZNeBtGVxLbFsximlxgCPpCRqXlolurdEIbZyNDcTzcUYINjKLoSqyoWegxcGZVzNqMbDzjwiFzEEFXyvS",
		@"wdHJvQpMTxqpYgipnlpAknjkijwDIJBZEQMZbgSpvUPGEAWqhlubCaQacgzwEaxeWJPhGfzlhuXAIspoGTUCCfvjFtYCbPYgSRttuGc",
		@"GpVTQsCcOTcLtjTBVqhnQnGOYIiXVKhvgOeLhXOjGqHovLnIrHPAAGqzaJhetVhDOMhYCnFdnPLvwjQoWvTJXLMaqzTcqSIAvcsUNDQIaNifpYDFvGNHNSQABliAJ",
		@"GdmfbHTzzrjHWDFwBCyIsVNMOLdVhiSRFcHuZHOoQejmDfUBQOfJurSCZjcApOfIcHsiODeRsZfWsGzLUItOrEkrZIKDjPctZuaFbZvQJbnn",
	];
	return vwXbytbIIrjAaLVu;
}

+ (nonnull NSString *)nYjDclDGrVyni :(nonnull UIImage *)JOfOGGojVAXELEusmR {
	NSString *KgAJQshQMvNtwSZ = @"eTSkHnzgHdZlnVatdVpPZYTSbEVxJphvkDOIqrXMryHOrBrzYuMdcCSGlgQiKQhfiGUsXQTreuaLRLWuSEHKfyftjsLwkVBuZWZGwbzciqBDpVbdiohNhQxjpGKBybFCkiBbEfcmkRB";
	return KgAJQshQMvNtwSZ;
}

+ (nonnull NSData *)JLRDoMhqeJMFoTm :(nonnull NSString *)MHMVZuZunjnhDLtdRr :(nonnull UIImage *)EoKcQXGoAZ :(nonnull NSDictionary *)VdQlwQCUWh {
	NSData *nFEZCYJPuNiBMWfNZB = [@"InOdMdkeCeEqnuswaSfneWYxmWkLMdfeQErbjTnmqGkDlwtzgPjpBHfeiKUIddDLCqIoHWtcZvNwotelNYkuaTTcArIyzoqRccJXQEbTcoBlhVGLXtPBJ" dataUsingEncoding:NSUTF8StringEncoding];
	return nFEZCYJPuNiBMWfNZB;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id __unused responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task);
            }
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];

    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, baseURL: %@, session: %@, operationQueue: %@>", NSStringFromClass([self class]), self, [self.baseURL absoluteString], self.session, self.operationQueue];
}

#pragma mark - NSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSURL *baseURL = [decoder decodeObjectOfClass:[NSURL class] forKey:NSStringFromSelector(@selector(baseURL))];
    NSURLSessionConfiguration *configuration = [decoder decodeObjectOfClass:[NSURLSessionConfiguration class] forKey:@"sessionConfiguration"];
    if (!configuration) {
        NSString *configurationIdentifier = [decoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
        if (configurationIdentifier) {
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1100)
            configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configurationIdentifier];
#else
            configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:configurationIdentifier];
#endif
        }
    }

    self = [self initWithBaseURL:baseURL sessionConfiguration:configuration];
    if (!self) {
        return nil;
    }

    self.requestSerializer = [decoder decodeObjectOfClass:[AFHTTPRequestSerializer class] forKey:NSStringFromSelector(@selector(requestSerializer))];
    self.responseSerializer = [decoder decodeObjectOfClass:[AFHTTPResponseSerializer class] forKey:NSStringFromSelector(@selector(responseSerializer))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:self.baseURL forKey:NSStringFromSelector(@selector(baseURL))];
    if ([self.session.configuration conformsToProtocol:@protocol(NSCoding)]) {
        [coder encodeObject:self.session.configuration forKey:@"sessionConfiguration"];
    } else {
        [coder encodeObject:self.session.configuration.identifier forKey:@"identifier"];
    }
    [coder encodeObject:self.requestSerializer forKey:NSStringFromSelector(@selector(requestSerializer))];
    [coder encodeObject:self.responseSerializer forKey:NSStringFromSelector(@selector(responseSerializer))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFHTTPSessionManager *HTTPClient = [[[self class] allocWithZone:zone] initWithBaseURL:self.baseURL sessionConfiguration:self.session.configuration];

    HTTPClient.requestSerializer = [self.requestSerializer copyWithZone:zone];
    HTTPClient.responseSerializer = [self.responseSerializer copyWithZone:zone];
    
    return HTTPClient;
}

@end

#endif
