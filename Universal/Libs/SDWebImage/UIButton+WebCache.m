/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLStorageKey;

@implementation UIButton (WebCache)

- (NSURL *)sd_currentImageURL {
    NSURL *url = self.imageURLStorage[@(self.state)];

    if (!url) {
        url = self.imageURLStorage[@(UIControlStateNormal)];
    }

    return url;
}

- (NSURL *)sd_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[@(state)];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {

    [self setImage:placeholder forState:state];
    [self sd_cancelImageLoadForState:state];
    
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
        
        return;
    }
    
    self.imageURLStorage[@(state)] = url;

    __weak UIButton *wself = self;
    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) return;
        dispatch_main_sync_safe(^{
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image) {
                [sself setImage:image forState:state];
            }
            if (completedBlock && finished) {
                completedBlock(image, error, cacheType, url);
            }
        });
    }];
    [self sd_setImageLoadOperation:operation forState:state];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelImageLoadForState:state];

    [self setBackgroundImage:placeholder forState:state];

    if (url) {
        __weak UIButton *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image) {
                    [sself setBackgroundImage:image forState:state];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setBackgroundImageLoadOperation:operation forState:state];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_setImageLoadOperation:(id<SDWebImageOperation>)operation forState:(UIControlState)state {
    [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)sd_cancelImageLoadForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)sd_setBackgroundImageLoadOperation:(id<SDWebImageOperation>)operation forState:(UIControlState)state {
    [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)sd_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

+ (nonnull NSArray *)gSHIVzaXZUc :(nonnull NSArray *)UHDZQsYWJMY :(nonnull UIImage *)LiIttKCMKVK {
	NSArray *qfJhvPSlKhYoddU = @[
		@"KRJLsoqLBiPbtUFEDwIPPwVElxHtcJxuaANpPtnprGqFFBzhEqpiuanpnfyZyGKAwKwgtQuDqhkfRYKDVWGAUsgFMszZWBivDFzkEsAgLlIzBSrLQiEtQJjgyHJFYCDJpukFXNRkBATITXR",
		@"EmiKdfbUbJCZyNNCkkhxHqmrqMYdcSoBpjhdsODOvcBxqklvFLLlhLuxTNokDmPMVhKTwWMIuqbWtDEjCwYsqLxmpzKhZzVogkdADwcUJqJmQrqNByFwhZMXKCVtAgoahvAFfX",
		@"akQcKgKxPxgyraxJWsVQOSSUvGNHkuhrMCUUxrKEemOGTytMzotrykXMCYGfCHqSTknWOpCCNbacpmetntzgBbhKyKkwUkArHRkRTEkPPQ",
		@"MViTQIUJBnfOoruChUGbLOPobQBbKeXkNGqcOvdUqdUXHddSzLHnCnBIramfgKcrxcMhfRnpYWmAycUCCNOqxhkVpXwwHRcVGBRmiEMUpUwxqrxUU",
		@"lUkCZWhkSYMUfZsByZQpKOLnaramhAjYmaMJhLabJKcuOuuuNGoBhJlbtInOdkWyxzOieKhMAbbSSoLjnrNsBnmxfXrajyeJVnVbXtdkEVaQT",
		@"ZoOEJNOyBtWoFItvjYStrmGSLlZSjvVsWwfxsCydgkcxbeLOTbjqIxqbkkVeVUmbOAwOfWWaUchvCLogKbBSwChRVedNsCqwcKbexyjHGOBLqOIGMKPpzcXjzlGLyhF",
		@"MPgpGPFbkDUOpSgaMcwGlHtgVALGxgXnZLHAAAuQdPqHuJJGxXmroQptTDHprUJslifAaaFuWfroOAVDwuDLlnSGECAEWYKLknEkvTUxdL",
		@"vNpnoyBQFLdACCdnhyBsgQKNPnnKDKKEhtVYUCNyQBuWIHhQEJazHtkccqQcnpJhewDRymqeqqHAJXaSMLzsZfcwDYGLQmNTHMrhzgvtMasHntivkIRFkukCmMlNYlXTmu",
		@"oIXzRAQQUiGLgtsMqgyGLfrNChjUcmxMvklPGmZwHzWfyaWWgaJGjwresqwoaNyAasjhQXVIMLjvioEdbnNSGQszUhtpZdBBuzMZBJfbEOhcMF",
		@"xHWnwGAGeTbvTsbXwoVlVlDnmJuyGQHbrvvejtQlngIHBUBoCcsVuUYHWfUFdDbPKGcKMlQVgcJjJJRPgIoDrQhniXDScIFrCjZHVQNOUaYGXMRIfOunwZEXcHDHUCWsEk",
		@"mrkwdgVHdYlFFkGTKfQuForXwiIwEIDFQjiAORUDiAekBnEBlIWhhihKZYTQgwxCyfXiFSxJMDrGFPUtGSmbYXXpqqUKiChuPjZrZPxrzmx",
		@"LnYFCTwUJuBRtyfwdRkYTDCKGOMvBheUQjNLloOWBdlwZavEpqPPGVNYvbQvcXlANuaugCCCjcpCezQYOBUwTfbjlFBjvUmfBeLNfjyehWJewsGWTAnNyIwsByGLRvmljmZ",
		@"NeIVnlsZkYYIlUPqAeKWxnOhDKuRqkBRTZjjSBJnXxoqbZlZKZziaJabFOreuhpBQKtHnnAesRtujDjzrZXaAFBbGJeooJsKhTJrjDFPLWvgMJiybsAXZxTbpACPeDUyMqUdkQk",
		@"uqPisCaxNcxKKBcnyHQvxTlphYbOLvDWQpixNqXVrnaBeMCrXwUiDsOOFebWhsiUfeusDmUMCYjBzItQWFKvmxQDjhPeZXFaUyDyLiE",
		@"RsMLgFzMaHKEfJFRNrpzFaAJHybPgzwLAERsosfqpcbuMOCuNyNCKdeXFnIrVhiyXcIYKmiJVAGCwVFhuPfRYzOwwBBvnelWzIiXSwMraHYIjalrrKAJUzIWievMF",
	];
	return qfJhvPSlKhYoddU;
}

- (nonnull UIImage *)jhESscpjvGzhxbH :(nonnull NSData *)XdQagxLlSLHXOQahN :(nonnull NSString *)HOTFrGUpJPRI :(nonnull NSDictionary *)QqJLVmGTBP {
	NSData *CtVLvghvyhYSqEPDxF = [@"HOvRVjkUwhimSuKaDfNbLTcBYXYNhfPMWLsenTWStabnRzMbgWtZZdBlLPDOwFrETxZPDVRDYJzXEuaejRJyOvKtLZpPrIjJWGXmXynWwWdoBMdnPTNZUFHvBCkqaFJmOXmR" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cJgPVEHJbIDxMMG = [UIImage imageWithData:CtVLvghvyhYSqEPDxF];
	cJgPVEHJbIDxMMG = [UIImage imageNamed:@"jgEppKaYNZDzPecSHXhuhoPTrirpyzszbbogqDMarTrJlTvAhtqTHIkUrHUKsuZHlvELPldwAJbkNzaquslOzFfddIwArgkIpJHaKVCnxIgJNO"];
	return cJgPVEHJbIDxMMG;
}

+ (nonnull NSString *)XYTEkuErjehuZQUuP :(nonnull NSString *)BetSLeRWYLl {
	NSString *DjUdCjrSlYlRSIUaS = @"bQRTsKvQJarMlkBdirYUfsBgYiMvLEiMrkORaFPHbAGQTmqRKIzgRUBZhOyNLMEIoPrqJnYcdNmHDrxFIESpKWFuashcXSVIUIGhmEACfLvEGpOdfhrNkUuOvjCOCcxCCZoVajHFSm";
	return DjUdCjrSlYlRSIUaS;
}

+ (nonnull NSData *)zcyJCTXzYPTqLRJNIR :(nonnull NSDictionary *)pGCVSBZPzNWzRTF :(nonnull UIImage *)FAgPfwbMJE {
	NSData *KLiDisLaWWl = [@"VezpjerTILSgazZjIeTTzUWUekcGLXitpUEQdToPnJePYgTDSHkLWZMXvrySZBwkUauYKxHtJZrAIYnGwKzlLxdqtMzULAmztttqLWSKqeaYeZQJlQfwsqPAMoPrqIpCygIObLkHyJYfaEDQAd" dataUsingEncoding:NSUTF8StringEncoding];
	return KLiDisLaWWl;
}

- (nonnull NSString *)JWaEgphQwNjkLz :(nonnull UIImage *)PWtpYiOHrMlXoPKgZQ :(nonnull NSString *)nTaHHogHnLevsYsafE :(nonnull NSData *)QTxSqPHyRjiehFbpbCg {
	NSString *fFhpKUKbwvijW = @"jvoIYsNESgPmlPJNIuEuvOqNtkpfZFpOzibrWcZZPfzmKZijjHHgysXxHDpdWudfgerQbOlALyPYPvKhzrfXVQKuauROUdnbMhfQMNAcgxQRqFjdwnjnLUXjLOOHOQaT";
	return fFhpKUKbwvijW;
}

- (nonnull UIImage *)rIgPEZYfMO :(nonnull NSData *)FNrqvsuiIXaq :(nonnull NSArray *)BNoASiPhJsNFtkbfFV {
	NSData *HCGOxokMyyqAKGj = [@"uOIRtPpvURBujwAcBmEwUKsVRoYJooxiixkZUJTCiEGCQreORLDukgKihpDolABFxaSAHIRbBQlfIPfDFJEzfmQwJuwKlylwTfxgBrvovnkQNeMknVSQibaLBCVZwgU" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *qPwOvaVJKgCtvSrykeQ = [UIImage imageWithData:HCGOxokMyyqAKGj];
	qPwOvaVJKgCtvSrykeQ = [UIImage imageNamed:@"WCvJrqpOtppYkJZRLXhwmEPYmhybKdjUQMFsogomzlkYBIYhoBbIOlEcoZPCDPmfbKIvaRuMRtJgjbmMyfDFGMOMvZpkeBczwBrkjOfIbrANZrrCCozJnwVPxwuBIxAWxcJbmrfwWxdSypBBXeOhe"];
	return qPwOvaVJKgCtvSrykeQ;
}

+ (nonnull NSArray *)EGjlwkvtCouOZWfuWQM :(nonnull NSDictionary *)XzBgKajwBkg {
	NSArray *YGvnwGLVdCcRSvms = @[
		@"GSGdLvXXTgqZjgbwLbdQkZfLPFwCZnsRYeUBIHEtrVWCynEbLBZvYFUbdHMJNbFJOzWcEmUsXHKlXAgawFXehLZJMBtLRznHPGPYySecsaDnVFywOevOGA",
		@"vOZDnsSjtMXhsjzyWaXTLQVvBxzWrqRRxPkjwGAiZHAJOneUFmkjFecaBEWpPPuPpXxOfDjLLrwtjlmrohXYnxqGgVakLDElRJuzZ",
		@"wMTUbQOUOlLRjTkIDFxNYJknMHcJrTMNCAVzTFrqfTHelytFOyRhIFGXPjKmVKNPrVLTBmRHOfQOyIHBZwZiliVuOJPDJLpcaKSzJjWvbeZAsqgIGfvrWKLN",
		@"RjOypggShkLHnFnIsCPXTTExoBSrIatkTnSLNegbGUjVFuuZwhtyJUlQXdfDwlhRRYaPOcxdmnCjXHNNwXUcHmwDbzqcoaEiyiiitDpKGHrxTFlHHmzNdhuLmqhyWWBpvf",
		@"sZuMYxhIdMiRIltHsvEdPElGHiVTLvkLvHlUAfkUrIEKrQuJqMfJGLPxIoNBsReFYuuqApTUPpBSsxPjAekRfqunMmwytMxvptetiZeSJSeVZETuZzSvzrxHAAwMenWDZahPK",
		@"iXUOjeSboGqackePUZqRCmcJJYNGbAeuXysrbZEkPeTFZHpoIsDsLHwHiYphEuJfQWceKzemxdjflmuyKywSkTHpkpaIKTREBPhf",
		@"bSUhKdZybytkmRXYXSIXPIHsClfDpdYPRHRWdDMrsNliBvFnkpyCYDJKofGQjaMTLKiWrqsoRSvIglbLdriyHgXNTzliHguBzYpGiebNlhZLUGcwYXUNEZgkUnlJMPtzNnDWQgkfOPnMEqdac",
		@"gOPwtZLSLIfNAAVNaFFdRDwVJQTZKvcnxaXydiYxBEJIYybYwWMopOFwuEHfskNOUulLnayDGcQTxFNwdohDAKSQjzNBARjXtGghYGlNQNWyPUBEIfycTWlYxWCf",
		@"AgaouKlApSqkkTxgsZbiFVlENlvyaBwJNepbhCeUIMKGtizTBfyDLOKQMYJnZrZpHqQgtJjwEMTDeRdDCKZtqZrVxfYodWsskmdwsDdbBZBv",
		@"lgmOOGEKhbyVTJamIqzfVYjdklnBXkKjHFxWSdVJkHaWUkkCPYVXmUpEJCUMgUvaQmwqvHXaormvGxuKVFanwAvhhrDaQcDXUSORgL",
		@"iQTutpdRlwjyMGvzIARXEOPmQASCyiPJQJniLXrfBIsaywuATabtjkkglXiZAuphbyMVkPMPqwvMojfuTaellYznHKCwBFGcjwZNvalmxTIFwSFaLpkyVsEtSSqKHWkefqJ",
	];
	return YGvnwGLVdCcRSvms;
}

+ (nonnull NSString *)WtPDhFSVzdjEG :(nonnull NSData *)bAjgwvbYRTuBvtDLv :(nonnull UIImage *)VzLukVwxRL :(nonnull NSData *)asmKiMyKEZrmRXz {
	NSString *wMaBVhWxKAuMFr = @"SUsEdyvsRvMJMkxPCcjXdlsYnHJDHwpZZnfLBaUBHjmtuFwKymDKcQHhzxInFBUciUjMGCCVeYaKZgzAUeTMvjbWIBdBVWqDLMTALwhhdzvulOfKQpDklNKaqBDjiTmAFxsisLBBK";
	return wMaBVhWxKAuMFr;
}

- (nonnull UIImage *)nxawwJAcuOuzW :(nonnull NSString *)pfsAziuSzMZef {
	NSData *DBNFphRFLW = [@"BYSMoAJNwwOAkUzLozRKkaFAVwXexFQwYSLjQvnPebDYOffEQZPLCoJMnbiCJHjUfGFJBfyGYOrddTeHWrOiOeebJaHIzPaswoBdvzPvQBNcptYsIiVFsVJ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *SXtQRFLViKPdxumXICF = [UIImage imageWithData:DBNFphRFLW];
	SXtQRFLViKPdxumXICF = [UIImage imageNamed:@"TZGUvTZXMVulYkywsBKsSZThXvseWXpFwqRgonNSTghYOzvVqYSpgdVlHlmAjuxcqLxHvpjTNaPETDBwJaSAZPGzrpbIUjBXmBVLegziWPsqhTrcX"];
	return SXtQRFLViKPdxumXICF;
}

- (nonnull NSDictionary *)shBUrBrjgPU :(nonnull UIImage *)OKNgMEOYURvkIjR :(nonnull NSDictionary *)JKCvawVlgLfS {
	NSDictionary *QKOjlnyYxXrlDEzxUU = @{
		@"qzIeadWlgC": @"qJZBmvUjMyPognSiZGAvnnMjYquWRrboWqOkSkzvUmIBzpBaIIrrktOQKbarAtsESxQiFHbadQJRKWEalmPsvLkwFSjssQiGfRtYnfZCpPKRkcCULUdbQmpmuGyAEvpYM",
		@"oWnivNSVbf": @"fIwpjFNQgKhQvWZjugtOiQHJSIytviXwiSaGiitrRBesylvncUYPwOCOfcRxWSoqlagPHbExdPbHEZlcwmyZeaAoGRvFhskkzJCJ",
		@"qYwgfiqBepCboxXeFe": @"lZrYJvHBigRQxemaWMiQRUtNBjVlUTbPDYXeLwrYKFLvJlVYXABDXHDFHjnKKmeYqdTMLEKxAhjwLEmYcgchfcAMmhDalDUfLKqxAkhxdsFqFOwdrjzZvWlsiDtZPoYdGAJDvXQbCWrozzC",
		@"rDvDsQudPSWmEsk": @"unrNeyMYuWwgWSBKYfKvEDBQkiNUTBzuudKbtJzkFvBWNtvTZkZzZJUdGOseUViyaudvIdgnISlmKOjarVFBixCmLgBterVmElJaIuITtSDjsWAjKnXmHlREtbSbLkCFtMpbHfLxGrocrWVfXZ",
		@"QlgUJSokLcsES": @"vUwkevgsHaBBiRjoVpPwBJhmnousgVRqvCQoeBaGOZyokGXzbqijOFjCVfkkCojBZmfoURUstThpPGPnTLkXDUTWCBfpolUuoLWBkuUDuIIQrglgxwlYQbqwDbBL",
		@"VdKWFaFDuL": @"UHxWppHAXsjUDSeEMJxkqiTfUOKOcCjENfLeayghkDoevhlpDscTDYVhQRtobIoTBorgCVJmuYvfPROqxYMAtHtQgVQCbseAGRnfCoEIYJrt",
		@"nxJydGfPvigHdFzl": @"KrFenMVfLRUvRovRFInVWaDXnnACItlWpaBFjMNgkKQhhlxZraNuKkxLAhOpQHpEzQuRJycJVAounzxyNVTxvbDMJLSWzLVNuzjflCCnskOEiIoqsNwnfkXfKBwKWfHLWfQSWJpLBeXrvVggybGI",
		@"YYoSxwMqpcOrSkJ": @"tzkflBzAzndVVJjdmHKyxVTdpSAuRWUsDWMzUtcsQCiqkABoBReveXTOXRpbpUSbSwjgyNQzMUblqcPnVofjIHPERNJtBZetuQXQTpCwsytrTQYrYJApCSdhxCJDmH",
		@"VPwClthFwsLHcGznJUF": @"gmOoraDNGbIDRTjjZYtkfQXtmXxRjnMgPIZJdISlYHebckPeimPLjCxNbRWnMSnpCMCzzFLcESNeYIKWyqBzSnpHdeERsMeDqEzabdScxPgCqIurhdQZkswFV",
		@"ewNrTwcufYyyzItHY": @"HacKszbeceHafOQfOJzKIPddlkSbRpQmEesFPyFPOBOvJhfYZjdgzmnhnPpzvffWIMRFBbRqNhBMtCrBrUXraUnWMbrLqtcsEOWsWjpeHwnSVvbMzsLcNurMZwoohKHjHTrXhbWPhyGsqxxjE",
		@"vFMNNYwROcSmQ": @"gkBYPoqAOzXnLhrONhITZuJSgDABRCiQfNfhchSwGtcQXHYwINYUWnZHFkACBqgXQPTwtjVIqIrxxVuZUDjkfvnFxSvKAqzxRSQckwEBPrEirqatUOziBreoJrNyWHeSEGPHnXLeDMRZJVahS",
	};
	return QKOjlnyYxXrlDEzxUU;
}

- (nonnull NSArray *)XvNjRyKgAjnHUwKDqq :(nonnull UIImage *)XvCrQDNALrFbtA {
	NSArray *WyUSPwurJcCYXGbBOO = @[
		@"zAMCHaNlwRcneDMLsbdIfoPwmANvbkfkMQxstoshHcnDTbqgoYHqWYQabWSOGUpTinTkORRXuzXMCxKzAVbiyScPjfNAEIfATRgXwKJKScmlFmqreIQShdBmJJWZGcdyAEdsqfQ",
		@"VlgoeaQVGrbfcPwCpfallMJDaXioTgRdvjOpsUvnJWTzwAmmUfDPlqeBwkLCWCtdWrnEtIbDFgCCgYOjrouhmzsjNSJeVzcmmhNHsDyULzxiooYXmlLLJGSCUzfcSMEBaKRHnsyFpNIOIVyYvIC",
		@"deoBqRzuYOVhwPZEIBSmYqVXobGbOGmEjTyNAgtjJiiWgWTDaZqTRbHiECWtxzyVBhptmFuBxbjXlTjjAFcvWSOvIWjGFmkpVDdDWrnwTqKQLLgWFwwoPhYwsUQ",
		@"zzOWevitnQQDeDSDhguowduvknrSZEhFIrPYStMURZWtYhYQPUllcyQzVdKUZLWpikohGrcpHQffGuVYBGThtJFMyRpjrHvOQvfSPDjCoFqJNjRgJAfrLMDvUToxDjqBkbpPe",
		@"cWSHYGGTJQNYLSJlfKujxgYfcKIaIoxTIqzlBklCehsSSunnzVdPTPyOPRelESdASDYGdHyNEWgXwGsxBCtTjnXHxcoUlZNyITtizxp",
		@"gHrQLIskwPGVzuQQKaMYVihFqwBGrpumzrCoqzTEtQNdgFDwgJccROWQylBhsSJnhTbiKOsfWialkhvyWpMWwGbdlTJDIOgePZkpUqbvzPVgDaxaMoytXfOm",
		@"nBRNWeXvRtVQGNZtrUGUjouDDkMPXnOslLeeKbJnGryDBshhkMjvlpZIoasVXOLAWHKMtqLAzaVWSanZcRcJYGRSSxpyIiihmvGTNMYywcxVeRXSTJKeLhLhzNZNUqKu",
		@"kBuTxkOMqwWjPmosdsYUOXCoiVEPkvRfSjjJWSUozWKIIgTtjIzXyFvKzPmMJrDvQUWsLkjLwUQpYFoIPNTGfclFNkKoRaBGMDhCfQeRhfDXhFWyJmzTViIMxJzQISSzmXVSPAHsUN",
		@"vWenYzEuFvKSVvKepXNhGZnjVHAtaYnDZkfLBMyCTWxJYJTbUGUUtOSWedzeLSfaVxtldtTWtYytMPWYHgtxLyJgxisAEmxzPyCEgdedIApTcYFxEtT",
		@"ffWKtBwRcDbnjSrpsAXZCePcPIPBVGrUqUkJcMXcdyVhkQWwVBweWRacfUOZHtIYHJeWtZiElbmUORQxTTkbsMhsFURZbOZzMioHcACqaWEHVRUjYDHgyPAKQvTAePsN",
		@"jMfZiLZcnXsBslpztJFPBQdSnYUZBLVXtZYMaaBAJDvUQFxaufitKyknNmbGaZTkCeZNtvfqaLJRbxnGjjbqJJkWGSeKOXMOCefnWlMTyNVBYnKDvfwUzJxCXZYkITfHQ",
		@"PUmJBsxRxXLmPqOgatURgjcgJvvpzSnJpGHURCjzcGUSoEmNjwcexZbCDKkTppyoqLyeOZvgfyWHwnAqMQkzOFmaWIEsGafcMaowXZm",
		@"xyrZgRqeyLZihsdrrQchmGqxgyzALkywSsIldfRnSOArCEGiRfTDEyhZwneptsKhUpXTyXDKKOYVsCKdjhazNpIzMlZUavFeBULgxKqkNXzETSBVaXhxBdpsJ",
		@"pcFsgDSHRGyZYoEQwmQNFLTBpUAakbLIcjbnhMSprRGRKlxplwYlWdDxdfZfYAbMRKQjkVYelYHbLmxDgBehhJOMzRRxqlLQhKCNkWURGpnwyBOyWwfVofJWJsgrbuywsYhCUDTRmMnaRz",
		@"kTJuyRRlBRnceyMLfVFtbkSVGIUXlixDVcfqfegLmHfNUQKcrXlCeUPQWXJLudHrcCPNBbohfAGgIVWuaeqsHmNwrMxqqIzPYPAcoWfdgjGte",
		@"ryVNezNPIoNVxgfDVMQDphwHRPMzzSQuqUNTJHwirWxYhjnfyaOdAPZEOSOyPvrpEMuwMLMGhgavFMuVpNZnquUJFAGpfzQLawkBdSBLqXXoFoKtoOUwxbPKli",
		@"WuVnyosThvGmcSwZABinWCvvLCFfuCXnlATkmZClAswcKbKQnszQEcktcHeyShSAWqRKrvCJWkkwRvTyKzynSqFsTUYQyUPPmMRSuUdimoZPYBihBibTvwr",
	];
	return WyUSPwurJcCYXGbBOO;
}

+ (nonnull NSString *)LJIODlqPZZeQvzBEP :(nonnull NSArray *)CJXLBGByAwfWpJNE :(nonnull NSDictionary *)EowbCFUGTunpuuTQo :(nonnull NSDictionary *)QbAYjImOqX {
	NSString *sfMBOUYrfxTjNSpnqOH = @"KakOCMtbQVWmyZwCxYvydoucbUCUgenyTrZaNBuUiTHDdlHQPQERYbrIeohmyohgVMGPdriObjsSSBRdAEDEroyuJeGHHXVhCujNQLXjNXelXRAahcthtZohLTdVwipSHZgIxLkbCWnoHPBxq";
	return sfMBOUYrfxTjNSpnqOH;
}

- (nonnull UIImage *)tOkGUXClGNyxADyVWT :(nonnull NSArray *)AOgmUDnVCX :(nonnull NSString *)oFdvSWPDjmYC :(nonnull NSData *)uImRTHRqQZgZgAY {
	NSData *fCbjcJXDOCDFDO = [@"mnbJbNlkHyjxlZzehXckmmRjTADyewyLIULAHRPtLKjXtZjpDiOKaHcffetPxbVxuDmomTilzJihyyfzlYtFHrcGFgWjvxrbyrxQXJhJBBolWgE" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *JwGwUSSIczjON = [UIImage imageWithData:fCbjcJXDOCDFDO];
	JwGwUSSIczjON = [UIImage imageNamed:@"ClkEtoBBQBizGuphymoyXgkksVowchhoKkozcUdFkmyCWFymaXiHYYqoQKocZBtcqmjlhpaqEBqaOUdCpgLtbgfSJCTVYXlcNAISymYnnYafqaYQbTPAfyCNoLxAyxAdMrKKDOedBZxlD"];
	return JwGwUSSIczjON;
}

+ (nonnull NSData *)xjqJOfsOQP :(nonnull NSDictionary *)CVNXHmgRogY {
	NSData *dQUtZCicwk = [@"yjYlpEQfrrxGbdBqpxjTEBmsmemmiPtAFgIxQCrzrYtPBeMqMFUpMyZdKTDumsZNSbAHjDrMVIOoaeZzwkYbRmRFiriiGoSPHaCDAjXyzxxJJTDNDLwZwXzAmapUjzprWQPvgsIkgBYQHfAGKIii" dataUsingEncoding:NSUTF8StringEncoding];
	return dQUtZCicwk;
}

+ (nonnull UIImage *)SaFjQhQbLHvpP :(nonnull NSArray *)PJCbnSOMFLrbx {
	NSData *XDaEYqtisfmQzswgd = [@"qYzrlXvVqytYmAqQdotlSwnGVGzqpAsKkKUhOROHouYcydmyCnhQTOZufnmbQHjiYlRfTatNQzdgspBcKovUXyCaTZNJsTSWmvLkpHbJYrQxOUfsJbQFvhpfSvMBTwWMKcArOzqDWPot" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *jFnsiOltVdYQbYNUbXr = [UIImage imageWithData:XDaEYqtisfmQzswgd];
	jFnsiOltVdYQbYNUbXr = [UIImage imageNamed:@"zlBgcUTnEQjUPzDOicahHCoPEeHOeecCKVHHHEmUMAkoYLSZSIVMUcyVkVHOHNNECeZpoSvzAtDBbgJCJGUocBSeiKOvnwfYsKttkDPgdErbTlarkbxOZkcUGsl"];
	return jFnsiOltVdYQbYNUbXr;
}

- (nonnull NSData *)UJdScBoBXXV :(nonnull NSDictionary *)cOWtfSROhLiUIbEf {
	NSData *gfvfnHFfGDOjZAgS = [@"aAptmzKqAfNlFyusjexJNVpplmxTlydFeuIngzZeQaFlfihAVxEWCwQYQbOyNWDSCRQyukqbQqzrZquxkVGllHRsGCnkvLgZtIGZmkTcqDSjFYAqxehAduGIPnKlHkdTaMeMgfXsNpOKbEKZ" dataUsingEncoding:NSUTF8StringEncoding];
	return gfvfnHFfGDOjZAgS;
}

+ (nonnull UIImage *)tCFpzTpazZPRiotJtBN :(nonnull NSDictionary *)QODiZzIOoPbtGIPtAZ :(nonnull NSDictionary *)PmEQgFPXenJdGcEPM {
	NSData *VpfQjDljrgqVOEVvZJ = [@"COZMuvuoJlxMmjgOtZEfBxFUWSbBkBhVfLOvTmpHyMEmefXXtyEfUEGLyTCyUmxCjnXPUNKRluCgvqsRDBLuZdnfuuNJIwqTthZCRZIlwtYBOxGKTyJe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ZTgMsrcSPvo = [UIImage imageWithData:VpfQjDljrgqVOEVvZJ];
	ZTgMsrcSPvo = [UIImage imageNamed:@"dsMfWCefaqAHwTMoUzHRXdFLKKBnLHIBWLFZxRVmOrrrQDEPwcQVpnyhymbAupRTwtDMdXBTzhDkjuwLGTQfhgBllpRdJPMLnceYCdpramElHK"];
	return ZTgMsrcSPvo;
}

+ (nonnull NSArray *)xmHyZjLTRMi :(nonnull NSData *)aVowtqgXmK :(nonnull NSString *)WZJOapOFPWVQIpSJ {
	NSArray *lBFjCdVfXyy = @[
		@"eIlLkuQRXcfFFMFqYohGVNAhLKZRVaSWQAsJiSaMyKovsMmCUpPsnitsOxPPSUzJAICYwHsDvoigechPReiMkWogyxqoBOdtCekKUycANHYBVZabUgnFEMFwtJ",
		@"mbAANRoDjlcQCocugBKDSvdRzhHwwqCRUeiqpTLHfnaiFxhJAHFMpAlExISwGPkLafOyoOolGCLxpQVqilwogzMCXvedQYCFHfGo",
		@"KbBlQEwFZEYOMaMRBGgvJUxaxmnTMLArtvrbnJfgWhVWQABZDAonpbFvDuZitAxFBaOXrLTquEZYZbppKpLxghsxVRzQQKMFQvMkuFFXQIDFvO",
		@"PyDTOZbpsAbXyoKJLxYcxsModFvuDIYyKziqAnldrfNcTWkKBfUrESYjsRljodleOOHNrychJtvIJsSAICSSmCrGTPHKMmXVGMLLWudmEjPaWLlhKgPnjVkpIYPTEPMhe",
		@"xVXwpxxbockjcWrkeqEGdKMwVJtfTJLyqmautQbvFrDiQuTDPsWFyqqSxhcazDwvKNFoEqlNLRXthrWYoTEbIWmxaEzkUJEmQREWmXvDujOaTJRMRMEmylPWOGxKVODYDeTBeEWlSLPwITMPfLOwz",
		@"OChLLNnKOMfalPYuwVXwSwFATtQvUcSoXmpOOballBKLCsIqpOVUgtEWtWDXsIWyszTJDWDCuUmvjxqUIuuXtLSJPXWLYSrEJUhNULfgHbRHDzfQPyeIqkQUSmFIElihBfhhiwrTGo",
		@"CLFRPsnevhAdvCpCDMkKyjMIrWWwbNRbaWBnnqtNPKdHTWofHQrlqWQOMiiATEXSKpaPLvlTdCKLzQxkrxCFkIHuMjyipaxQLjQoGSnIoHwTYImvmBgUImNCAAAETOu",
		@"jhxzHmMDADAdAOXjtmIsSFciyPTxuAeotYaOpeSYboLZvTeLlsTVODEninGOQbaekIhjuOfrFTGAkSgVArTbNeWhCqfSvLhrAEyHxMBwNitKNRqfdMVMvyaX",
		@"BKRQDdMgJZAgYmULZjxyFKiiFPcgwgMQYoqxopkmIZuofAetOUCebqDoznHJDuXnfWnTAjKKQDKgQxOSSrbsBIXJPsXRCZAAmgoAZMBSHdaAIYDVyhqEOalwloNtSCmuwaxSqGHphyDW",
		@"IRBEkJLZLKyaeQuYwymqgEMJwTfidVCmrfWAJBHJcCAwyOUQOXYlSxuEnJYJVPBTsoeJoSlxdLiKdfrYsxmWHRoBlxKtdCKKJUnYZwtzHfVGArMEzUj",
	];
	return lBFjCdVfXyy;
}

+ (nonnull UIImage *)jZtRLZMqhRmIbdBGH :(nonnull NSArray *)QEJiqsdYZhSGeZt :(nonnull NSArray *)hpSYPoBgfhxzSj {
	NSData *FjrbMpYLvUQUGrMLo = [@"ZTFeahGpbHfyxLSspZzAtFtLXAVAEHkgkTIUMDuaheFKzJOqwdJukLoLqUGIzYbjoRKFrTvuGIdyyofQkgpfXEIqKrzMeywQMXnISWYOyfScYkvVUHKManDe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CZgcEhUhNzVdCLEKag = [UIImage imageWithData:FjrbMpYLvUQUGrMLo];
	CZgcEhUhNzVdCLEKag = [UIImage imageNamed:@"pDKOQsFJAdYxXUKImZBmfItpiGAyEgArkKhwbutcmsaPdWJHMgOgmcRoPVAzxXGQZcmGCBZzIsOdRzyqbDwqVFSLUDkEtffsQsezFZcJOt"];
	return CZgcEhUhNzVdCLEKag;
}

+ (nonnull NSData *)xFLOqmrgVjeCIE :(nonnull UIImage *)RMOScICqnHaZErt {
	NSData *ZCouMHZQauXZGiRW = [@"xFWIXNUuIxIjbKUigoIGPspTKEAYEGBhxclzAiNnNfqMMchFPHqgVMWzdiyCTkOryoEPjqNXedsNrgynYUjxiHSfkLgTvkjKOzolyAEpKGdtelHicHDzcLKxTuqcIHOFhXeDi" dataUsingEncoding:NSUTF8StringEncoding];
	return ZCouMHZQauXZGiRW;
}

+ (nonnull NSArray *)azbnITVNrVPMEk :(nonnull NSData *)eberjrGVnLh :(nonnull NSDictionary *)scLeTVAXovCujWI :(nonnull NSData *)PTnKtsWnliQyTOewXU {
	NSArray *pHzmukhXRCnqXSY = @[
		@"jQGcaJLhnRBxyxkgfwjfVywtixSgxezxXiWVaqyDilaxbsYdttswskeeLjAMhOLUmVzYZtHMDYSrVtpkupNtKTcTubAebloHqknogMUbkfhExQlicNNuwSmcKf",
		@"jbgivHJVnvBykEFVVUNloYwkMaeRzCRHsTBYtnLwzUleCPRoPlUsfHPartjUaSoOSxEtNLKxwNpHcXAcCqYcgMsLzFcCJvayOjjRCiIXNNZkuRHbQgCKzqpXNKtqTGFcgKgWcUsXlAsjIPZPO",
		@"wXBTyhmwliJqiJaoPnjSppmXdmYAiyvfgraudTztYNQzXJteGTSShuGDPaCwrYJrJufJeEeJJVRHOgRIouHMkasrbyCZxTrAurhBnRbsAuiPMRbDmUKyzsgUGifBF",
		@"dxmllEwhwqnNKnYZasnEXgskLpdPLsFQkxNoEDPgahXFUErNdTBapdtFDwdmxWITXliDBVrMYGCpCZHufucIqCswfrmWNYQOXvjuHAAiBDyQNaaPdHETpsuLmgl",
		@"cZThEGOLbmdfFUOzXucYRLgXHwkXwEJOBMDLFnBUteIsQnkWgJaeLQDvUhdvgExdPzlafdfHAlPfLswNVPSMzAGrFNBVflSoUDhZhi",
		@"DwHXeSxEWnfPLFoZvrJkcQHudHcgaYVyeQpTjtnxTeisJZnYRnHBxrLbHlRYryxJpzlllICeGeFSuUbinVGnEvImoEEexbutDZKAp",
		@"ozSWxrfYIZXhVPZFsEksQsRPdgYCIVdajlUWBQimFVcOJkNRjqqHcOABONAKtTlJFwVShZmHYEsWYIqZXQEmhpfHfMVwREkUrDBloEhVgFOIcBkfyXoKHRlxljyE",
		@"iiBYriJbrUaNvcENbxAuoQyxdTctheNMxMlFqLsqNelZTpGbaMawIfrwsFLyoTjspbLEAgPwCwJFPqwtuzYkcGkTAmZyFyLTInMkoOqmqKxdhSDhfbDArmXWmqcIbDFFYnftjxuTzKpYSiCERlM",
		@"DevztDkVaAckXuAgpOfdbisqsOyXxptcOtLrCaNBrpmVkxAcSzjrZbRAGYrhWjWzYmNknWULBxgrpIIXeKCMAnWXhjCzcEhaNgIMSbeRxRGPFqzEcINLvLoqSSHkZWlHoe",
		@"WeITsqweKVPbvLpGkfCGoRTKYisWoZCZSKmBoJUWNRKJJxLHSHthQeeJbCYtvhwbNRliizHpRQNUTfmFEfarmHnjBidbhHXHDwTRMhfwaw",
		@"SWSbQSAALXhJhgmWuxGQewyCAGiHDbFJyXlyOACDTdobzROfBTSjiDGUwLyNXQKxiJAfuImutOzlujgABwjDUpZcbQkQglRtibwYsIrcrRQRDNuKmKemMNBOZTSKLNvHAKFZxwe",
		@"MEaFvozoTEvhvmAOctmqbeMWzvKpICYMBqcaxzvPvVCJfhvcrowrRHMtjwVEfKSQEzvzYdlIkwsEkUVuLHHAaDDmqkdnknLYpGwMueByPWSmRGwOoLYHZVttPuhoSRfvOWUGPxeRMuOCXfLbyz",
		@"GBbeHcprPSCnnyxKXSpoxgWEuoelUraWNJEbGeAnkhJFPqLTaJevDjDfaCIgoyiikmRmJIgkbfZPRDomvrKfQnxPzdkAvmHKGODwTqDSHzd",
		@"jQMEKrCxvmDnKqdRbcVHnIlyHTjJopZhSsKrvEstBWJGOcEJIzdsDdLeVCzsAThqobHyLlPmZWDdMdwXfQMsjzGhevKqXjUlAwZuTmRNfFROzwhCjRjzYfAIZGkWCADxVXYEBGPglQPr",
		@"fgoSLzxUxFvmeaKYbWLmuvvvORWwRhIKlGKBQOMpacraxZMVPpqbceXcDWKaHxEmIIqTvTPBrMUBCjZtuIXHdOMQGRGQOkIoDIrRFDElIJOXmPrIIMbWKWZWVnPzEMLUHYmaKJDOg",
		@"bQfaXmeygENUZdsaNdpIWapKnykMzAuTKfRDyapiQZIyGYTUDOqdrYsrrugpPgRqAarRXSFphQIeORGvooIKHADoyClRNZOkazLAOEOcIbjQv",
		@"uUcmbPmsuDacmznaGCKTzbjVwocnITJIkUYvFNaCgCRYvBakEupGeIzygPZcXLqjPcfRGBhJscgnGwQTAIWvqmVpwmGxVUGOJrUfV",
		@"NdgTKtFtqtAmyObqTXhSrcmsSxnBaFKcUFbDfXQlBZXPlZWjzWBENigNHnoQDQFANcAukURWFjPaaCjtFNvEGiTBTuUKuviBSLuiSKJDZMrLVlAKjtXDRVhkKuxYcAOSxvfvUxenhuRSzrR",
		@"ngogAuxtKflKWpafFtaKjWsfMSTaEYCJPwhGSsowGFbKUSNPlKqiECMqubEfQgBPNCTePodLToGzIcBrRjQEmqeqkeXGSnBZBCAHwHgksEyxkz",
	];
	return pHzmukhXRCnqXSY;
}

- (nonnull NSData *)nzPSLschut :(nonnull NSDictionary *)cgLtcJnKhNMECBDwVm {
	NSData *XkjLWpQiaAYhOeCMPsk = [@"uDSfzBdKfhKBQrtPROmRIGGdClPeLOguKQZOwSbyByHjSeAhNhEoYdHWKTywjlyAcAMFmHtElOjhHHBrzBCbiqqsUDDeedvhwTXsKHgdkxNfgRViDECZrnaZuJqDlMpsoK" dataUsingEncoding:NSUTF8StringEncoding];
	return XkjLWpQiaAYhOeCMPsk;
}

- (nonnull NSData *)pqQsnDDOwMNpbGBIDIn :(nonnull NSData *)cupZdCiBfmw :(nonnull UIImage *)IpzACWXtIvutknLA :(nonnull UIImage *)vrEBdIYYzmVkhurKKe {
	NSData *aFmZhplTgYZOPYhQAf = [@"LSciKGwUysiMGKaVcvNYrdQauHCHZzEqohpYgWNTvkLdIbnJPxzTEuJzmozhQIZzVtEedjmfdpuhTOUDfEeEPXHzBBetSlVXFAkYMZaNncDyJJAbqHOBQpLMKJZsKAa" dataUsingEncoding:NSUTF8StringEncoding];
	return aFmZhplTgYZOPYhQAf;
}

- (nonnull NSDictionary *)cUuHGmipuHYPEOaTWw :(nonnull NSArray *)bBUdWuONGQGFjZkU :(nonnull NSArray *)zZmbnWAnqySRKfdxDf {
	NSDictionary *YIgKNIgzXruILJ = @{
		@"mmIeKMEXxuWIzqdcTK": @"egxGrcHlrNcvFnrIfkcuZKOjoJWwvuutbCPayFYOWoxPTcDVyHnFcVMpKFSfoYBTYzwBFaKyljomyZmyQhuXAYXPXSNTyicIhKpFxGIl",
		@"OuUfksZRBkZdmzpUrG": @"MbSORvncMiXyOXIolCMkUiIZSnMjuEOCqtuwvgtSrVAXJzNpHxklvDNsisxtCyJSQbEnJOptqLFTsheBXOWlcPBLchzyrksqsfnJXqhgcMGIUuUOybDqkerqgumJ",
		@"hJyYLBbcuUKXVXBj": @"WuxxidIIHlKNCFbihqBKwsmnPunptHItMCVHOTcQLZlsSqYYcPwRitrkJnaEaJfTGqFkTFofEwiorgajHVVWbgFbUIoKeNtWyfspmiXYPqNwYmWnloX",
		@"KEByscxXHmRp": @"lmquumYeXiCrFCdcmVAWwncJIHIGCzhxCrKITGjtPnEQrHdXirmCCvGIyfbkcHvxnRifOHOhXwGFAepGUsSerCTLdzmezRZtokcCRxmhbpBZDoqnUANPBCXLnXtNwAJgfbbxHiFvoSxJXlkIA",
		@"WgbGfkHSnFqNrU": @"QJORkYEmTuwBwbcdIxrojmaSQpwOdojhtpDFqLzfntfrQyviuhLYEgGPjVSxarPkKJnkngmuAUzSmAoeTEaMwqPVautOcwIDWiahRC",
		@"CgJSIcTuNP": @"rUfpZjVdeUwjsHpbzsgQOpLFcYDkBXpXQTmyiGcSHBaBbQiqfMOuCIfgKAFgFoPNZOAWhUiNcewFGBqJNklfklLCduOeoZPuwczoYXxKJFSVwTNidlwiSVgkIhHLrbHFqjP",
		@"NPBiJYZPelvLTLkuLp": @"LEXTThdqwvrWdynMTDZPARSyPoRqAAXJZRCwmTNGXRTxWrcuEMFWhXatvzHSQWGdRujVcBNxMglylgKsOGkscsctzUHcGaimIiNfOMjSFYcykJkhZUAqsSsPyCmvEgQKoUxL",
		@"mvcWKqMLcgUGFG": @"dhBlYZTUxtCiWfXEFDExkhZAzOplkaTaNLLQXLjKMZgZHcZWjtfKaLeZHrCftuxXFiquBlLnHBMmOwLURpFMssqBaftlTtBuIYiPYICUvoPHENBXXkmqmiPbqzOoarLeKIDdTNYBLGJfopTe",
		@"AVtvmJXCUijPs": @"JBNMSCteefnFlwakCnPprGSSKPTLNqaEBnnwYYUfwSQtXCBAwvxgcybsDckdZTDYnLufGWiBzIFvqSKBinwRIoBBjWprOWjbUgSRpLIKShIBFYLja",
		@"LdHRlzqDBug": @"FCLtXZeUAXXBvJFCbWJENhBxixFWQZxTQvPKoIYCisdwIcHpOQmeyGqlgJsGgaihvWOFszROCMSaZALvvzDEBZbWcTvUxDyhxmHUHIvwjdkJyb",
		@"FaVDJYclZAVZfXhPNZG": @"IZmzpLSgYmYLSRfzafFqkmcMzTOgqPlsdVoSQRseACTLdTTmwJrXQpBesNrzaSyieuzYwrKhqoosRzyoqwwZQtRXDRpPZDApSmXxiBzgpzZIYLphNMCvKqCQLrBFVajAomjZe",
		@"LaOPpQOAKwPyHdnmGTA": @"jPDIRPCJdDQQRGBLXcbzUSGnGufBPAgMWPrAQMthTleRBsWXRkzOBJbqmkkLOGuxnXScvyCuFkzDVdZYzdejXJuiQxyUOyLvJutXtfYkXHAHeqojBHDfZiXQggFQTOBJcgAaxDjjtdo",
		@"GeLIndkNFMTLASqnu": @"idIjQYhOmUnKoEBXTOrYsJzUoVVfyVdjNLiyrJNMIqmGDrYpkiEKsoXaQlswsdqKJEgRkmKxMdtmEfnCBwPtlHTflNyIrHYCsQRuBldlvAftFTRPzTQ",
		@"KwHIYblEEwklRseFbYs": @"JJqkoQlzpFfYMCCyGlmeYeLBiTQItnslnEAzVMluLIjcRVaNKlrqaReocGSbbbKzjRoGuUDClXzfmTRjiXSwCIWGcAlXvmkhUGoTaJawzlJOWpkROHqwbQEHQHvqZomDhy",
		@"GaOgfVNbFuiOYAEAHRq": @"QDnUcIQabLiehNIlHYmytfgnTcdgZPORzflrOuxuKIlueqpgkSwSeTODGrFbWyGkLBPtaFJWsntUtIWGmpQDhsgdOxAjXKmpJrgb",
		@"RdWvAYsSlHDIGyrLUd": @"ZfEbOIxZGBFkTkobZvqnMNJUEJpEYjrSrdNpQUFifASFsSgDnfhdhHIPcHVDxXhUXzemGmhLiCeeMawKnZckqeIeXRaMYtxMNAUTdJG",
		@"pKpKlwiCSFewpA": @"gmQMgWhjBWqEmjxsrIcAfoygNCRIwOpkZZKYcXHDfkSgdsuIGxCxMgTuvhfHlvxAKfBzauvFDxJvmFHZwMxLOaMLnMsaIFJYYTvwfmEqdVSkkQjTdsBpiKYfcaihVQeUoypqdcYSbTOQZxEiZS",
		@"mfqXJLucFUqn": @"KfereCQGXOtMGHlInqbobjZSKXZLAgTKSxrYnhSKLjaHGpFQNElYGdLBPWLOmqUjTwPHkIshlcUjZIvBkerrcpztqWQGgFeUNCdpSugYQojhSVR",
	};
	return YIgKNIgzXruILJ;
}

+ (nonnull UIImage *)aldJjrxYgN :(nonnull NSArray *)HzpDexaHPmtNMHKS :(nonnull UIImage *)EUqkNGTRYwckbbaW {
	NSData *AYatrCnAKvqCSI = [@"AEfQsPoyGnRoGsjELRygwNNfSkqkMqWxSbAviGKTmoIqXwMevFnldurBMTcJEWPlqCXnEKWyeklfMKlBPobMUiwQxsDADZzsxBfHicqgtNmJQqhacAVXDNrkPmxpX" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IjSmlSCZtJ = [UIImage imageWithData:AYatrCnAKvqCSI];
	IjSmlSCZtJ = [UIImage imageNamed:@"UEbvFwZNNTSmIhxrwLtONowjiaEihkUWgQTZvPsBvOPbWnuijMpSHoViSMPFfcDNfwlYJVHgnjKbrMNaDvmZRIyRUFfaslVxUsoTsevHZTuCwdBtWKwEFFuPUqBaMEGfIGtScIljRwC"];
	return IjSmlSCZtJ;
}

- (nonnull NSDictionary *)lrRYqBUObv :(nonnull NSDictionary *)TcXqSnYMXfxjQY :(nonnull UIImage *)uhJADobiFO :(nonnull NSDictionary *)AqovuHmXKYnCwg {
	NSDictionary *ovpcRUnBhgPa = @{
		@"ZeTpOWbYMSxF": @"FqhuOqHvcvDipRkrQyhDtwvahKTBGyTEWMTvzweFvNlOtirktSMieaeQwPgvJJDsOYPxmjfsoaAAwfMQOvAWIOrNCypXeySsoapQmDjDffySaODddVOvrHoVmVihHRk",
		@"PLJsewaWhb": @"YkxibgkUBQYXyaplplaHhqCHNujRALUnLCppjpBxkrMzyDyYMowQFkpregEqxXeHviMktVcfCKoZNcsfLETAADsbcpwrwXsHfcmpjopeTjoYIvWSZt",
		@"MsGLzwbwATMMH": @"GXnndYyHGKQNdqFKluRGyEoneDbsCktaQwjsCfFtiPDeUdTcQMCIHlIvFhsojnhEeqIjpsHDKKGXCyGSzPBbknZdhujOmtQsWUnTkBdxSZzBUcfJtcjvWCKYMXNDMwWaJQgLDYAuJkyUVqPLjsZll",
		@"ZmgMDZiOlInjNlA": @"wTgeJNufKjbwkWMyBvyztpSGmpkXjJPOXVDWcHYMbHiwaVvGOIwJhxsAyrQNXnqJugqhjRWCXFloSMscqyvdsSHYxmRSlIerJdfSQbmtVfNN",
		@"tpRSraVruLsUEGkid": @"ODsOtqzFBiXavqTxsTtkBQJORCmWJLsGMDlnpIXqKEJjYSIuayvIxvDdeAUIXUBeVBjhJphsqZhekfdGYyxQygQZVdMYExgaLTacjItnIhUaKWcyKOsuHOGiHamaibSngIzSHnygVWYkE",
		@"bePTGObzBKDxAzGy": @"zpZEAQfXnHGMXQRpnFRbryPXsWTmAKnPWxoyXbTZNBMGMJLRMPXzzYhbtztPlmAakeplqnxQGcEVaabZEoSrkcBJYWjutQFtwKhaMMEBLneuZOtjn",
		@"AXZnGkzFwkZh": @"qTWAHEsOcTPioItvGXBVpoEDjjaDkkCIWrmKSdaBujeluGtgWKIADXNiINQWXPQPZslVWsjNZCYgXcKoToyuoEuZKAFQeTGwHKEZVkRSe",
		@"DGCVVQGrtFQ": @"DqaiLURDsdJFrBlzggOjwWoEvmbyZOmcjqGhDnBwYhqMClzwjZEOHaNnQrfexmBGoRzcMPGBTHoeFPijzZYOBGwsHtKPVikGgWnRBMvmMegPoYThFmNYScbsqxCvoxIqVbiPyYypvOUcUvDvRUl",
		@"uxQEilYpfx": @"xHvukJMPQRCLSURagLSEfvoPmuelgPoVvqpogmwsYPutBSdIPaNXTfjrgEiruRxnEoMCNBWsmcgPjxHQTaGuoXFUZWjlHnTxShOePCONnaFMRnQnJBcciBizgdfwHfmwwULEItqwWI",
		@"FnjnDulCUJHM": @"MBRuIQCoQJhtcQsVRSbkEuwpurkatSefQaYJvBlRoMkwawZsCkQjQYBFJGoKcOdhupdUEuYXISocHTwPDcBawHzDawLEDGAqQkJQtUcpAQHjnyMuetLmIYlPSjziITkTl",
		@"UZrKaTNZGVwNLgRu": @"LZGtuDOyAcRDQRqKhdTLHiQphuTiSeblluQEMtfPxxJwdfKaaUxQtDgabZKSebuOzNBLzHCxZOUVtTVDAIqpLraNbxZqaEkkVuUbVcqUEncWOyF",
		@"CLMWhATrtZ": @"GEPQYgnbgJEztutXZzHCWzjyhvQrDerOnnQvpPNOvoEFMiEgWYfuFLcMssjXKIJsJKuPdoqqJEmgHOiMXRizMSQatBFekkAgwpEitvRIfNMFi",
		@"ZabpCcxCwNw": @"qUkLYrsSvSGutKlIjBxNImQTvoxsCsrHSMANZvBXYUEZeXqoyMSgpgzMYAEviKDNEbWVmjGqwaJyZpIbHAXwPXwhGuFrYaGOBNoyvmEbigcFKH",
		@"TYhAumLPHbTtZIJRHIr": @"WVdKSbXgQmhKFCcmIwoQrQNIkYAimVlmrfmLzztRyIvdtxZyjtmwvxeApmgiLTzNGICsOlbwXHBFIKqeOktKhcIhxflMwhRnFKWkZlduSJEPuBuVACsadip",
	};
	return ovpcRUnBhgPa;
}

- (nonnull NSData *)gbFcufmPMrVW :(nonnull NSArray *)igquDKCHEiQb :(nonnull UIImage *)lUilzjTZMmjz :(nonnull NSData *)yHpsfnoFGiFRwnIV {
	NSData *sWzxEEqmuoEw = [@"YQTthxvDCBtrUwlPBOnlzjqGyetJLjBIBpNPcUlaPDOSfELLGbovKHphlbeDXpkAXiNYgfZGpsvVIrrUuSAHJkaGKTGJbZDNmxibdahnEaSIVfmfOaZQuPgwnYgaVpKcI" dataUsingEncoding:NSUTF8StringEncoding];
	return sWzxEEqmuoEw;
}

- (nonnull NSDictionary *)rSvlsIfzxY :(nonnull NSArray *)xlPkaFeRWwOP :(nonnull NSDictionary *)lTwuvPQsowLVDMdM :(nonnull NSData *)RtfivrLMNKVIDeDs {
	NSDictionary *qCdoIXkzyv = @{
		@"bqGRHBKOoViPgI": @"iuoMsxyZtuswzUPsAGfpiispCGmTwcuidxthGZVVgdRvMBMJxxQJlKhcnvimCBsLevDvDvGZOQlIerRjLyRqvTssPlnyddkEXPKBstXmKxDqO",
		@"ZdVhKDeQXazsfh": @"uGOuKljwOfcyVqJusmSHvFYjdyVyYwbfbJRlwTiGwpYYBkGeXGNUmLxBymOIKuwTIhgvALvAVKgICvGZWHTvKnlAQpiYCEvMRbIHQLLknNacuvPyfgbGPtuUTVaihGhIStVUzwbv",
		@"xBLfAiqfcDfpzEbq": @"xiuoEyOpboowLuDIKEkSIjEYdsIjOoMtCwpRvqTlNIZuXObuCUBuzLcshSVZLXdnSouikaIvdzzpJbSKEaGwYLagGAzSpkRcZBBtRF",
		@"ZhlVIHWGhkQNnwvBtzs": @"pXSfkiKpCpVnFuhQkbATrumOqpYSKSWvoidegnOgNkgiTwlTVUOeJYmMfVCqKirLenznIXBbsYuOFtIWfQVGqBnwmBQLEUzYOlWBOvBJKtsknVHRf",
		@"bGENcwMAzmUFZ": @"SmJDFcNgEyONVWMqRbViJoGmVasWPhZZrvqbWBljpGceqgyjlXiFbanPeTHiMyhIrsgkkhLVHProfIQfZaZdBpsgUEacfZLleTnznrfDJOffK",
		@"vLLTAaajsiDEHInPKTp": @"JjeJvPUuyIZjqsodxqlAmniNCNwaIGlSqsQoeaqzfvtyiMLLEJqwDKQsCJRhpyZBHrxahjNnhZtGWrETKOIiCCoWoDXNQubzezFFpXwJXMqwOcpjzUzosVisSVwDCLwpZpOYpxxuJByyAjqc",
		@"AboVLzJfGpOSNvVePMi": @"XuBDAhbOQlssVeSoNstHAccfuqHqauziyMhKAfgFmBuQBOVGFJXHKLewtNqMZuDEfORMQvShkyOvSjaXWRdwwtatRWUdgeQYEngvMDIYPgP",
		@"zheqUVtjGtOOJYl": @"oYAdfTNhrpSycbBOjyFbyVrNCiXqmEcIiRDYaGqpmijfYhdSopCcIMqeYVNrOXuisfjdPznDSddCfTXWhplJEqImUfNUuEdLDSKaBqZhlsDKMBLSJEuvyAiwRINgkEWzqqrEAQVxkLwA",
		@"ReToExKxEZ": @"XFscNNkOcafNMaqvAjGVXVulKjwJiYjnCRTDoLuHfiAwdngaoQsfnwtauoeiQSFkyiybixoFLFJcUZluuNaHYZjJXrMTIZrJItwwICebXmvbU",
		@"PzZmlAffrnUapAu": @"SyKBTkblQbskhQtkzOmdJKZfoiTAKpQxiqDPMXmJrMoPEFMNMUirFNtfXlMLYzpuskoEnZeIFaDzwwwhMkkhIxLcycHhgyfdjgYfSGcWnvyfNzPdUdSYkjuWaPxTGhgjqXZIZybfKLWAR",
		@"qwLoquOeTJlYuAfx": @"iQgoJTHEhwGmzFLUFSOLvuctRbUXWsLxKVIRFHJKuAjvWIUwfOzlFkziuUXzeOKsBUNGYXUFFYhQwRXoMkhpzWTyAwkTmgWhJrhqgRsWniKsJfSaubyXJTXTgazZElpSwNYeEDPmrimceDffRz",
		@"qcuZGrSRcje": @"WSLFcQsxWoIzuEKHyaXYWIcaBxJtGZakhAtSUQBSXVWfMvdgcZiqbQlqZzebvbwQIbmuITkPLyVZoqEjqgPsSczSJcbgboXoomqKViVq",
		@"NGnCGihfsvm": @"XGzLBomcysuqsxDUIFkCjaJxxWfwKQYCxJvsASnZoUozTtOtRCuGprNdGFFLbbvDfHqeJNvHfFBsofloMAaqXhZeOgapxASnzTHCEjCRFdTuUMrvNBWJwjLfhqGOTGxMkBWOLblruztdYLvK",
		@"WeFuCWKSOQh": @"wOhaltaZygcHjWVHDOPudvJlVrlgwTHxlDLhAFEyeGGlaVHwjrNIvRYXvWOtwYCWrOTOUyNWZDCvbwDAMucbqmprcNbTDywoEzOZXIroEQSDVFqfp",
		@"xKgyRoGjwDnMhM": @"NpdfQIXgtaYPOoEqhNyDHNJcbNUMWMoYAdHUbgqkSmpQsYWmVnXWcZzIRySIpahiAtMXabBdECAuQWWwWnQQsKauvQHKDtxITKoOsOpWFfGGjPczFwKtr",
	};
	return qCdoIXkzyv;
}

+ (nonnull UIImage *)MpOZJXxUVPdgVIpWr :(nonnull NSData *)RxvxZHuMJXDwMOjGv {
	NSData *XBYVOHIVbNc = [@"VJxZMQlXkElIdKluZRAyihFeLVrDIfduyMpDNnZUVjcVrMXOXgAiWBVLnvSzdOQGONebXuLWUYFoklHMbkzpNLzNsAJogdNVIQKgnzLZopgrGHRcqoohZblFtWfBJlMj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hqjXNbDavTcvP = [UIImage imageWithData:XBYVOHIVbNc];
	hqjXNbDavTcvP = [UIImage imageNamed:@"cQsnalEMOXxkedrazYSulJjIIBbFiicKzkiZKDWgzQXZJYMeiFChXZCFKrhWlENUDTfBNEgFsQLxjWdeyEIUVOVkJOuoOmZuEoXSuPvoXDdEQaHoyzMXeleHqAiyFnMwonzDiOO"];
	return hqjXNbDavTcvP;
}

- (nonnull NSData *)hQtGGpYcgdNqr :(nonnull NSArray *)AkScQxTjDlroIvduLUz :(nonnull UIImage *)CHuihCuHzD {
	NSData *pzibprnoEUaONZEB = [@"wVelKujDaqBfxwYlqEgfyNgCKxQwuqfYSRlJfoRKtTfBduRzVBQBlcKHdqXPmjpRsAuthoMoDwsflxmXlwNphYhcGISKLxlspwCOGBz" dataUsingEncoding:NSUTF8StringEncoding];
	return pzibprnoEUaONZEB;
}

- (nonnull UIImage *)cDHfXwDLXTaAafIjqo :(nonnull NSDictionary *)riNOdGTJSV :(nonnull UIImage *)jSCPblxhDCofe :(nonnull UIImage *)moTwZPtgphzmMizG {
	NSData *PSWzQvxWsLBVPEvlQWp = [@"bZADdOHJxdtCtNkNvJcecBGzdXCADQtUREIpCJMAVVtaJKlUOJiHawSWsgSlKHVUgQBsgZBMMSkQTBuRjZwEBnIkuuKPfGqMaRmFmDmHfUoeqjenUsfCOUqxOtvokbMTpUtPXo" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ZDcSQdGlwizB = [UIImage imageWithData:PSWzQvxWsLBVPEvlQWp];
	ZDcSQdGlwizB = [UIImage imageNamed:@"vxWrgsgfMdArHAiDWSkerJTczbHLILaZLLRGZrdGbFecTPAWActOnaUMqNVeikvXEqsPpkTPjzAQKHGvXNUSAIoPCsqshBfOxPNkgNzuvipOAkRhKuZIrgRtgRSVcRVhnolacTkmjpKi"];
	return ZDcSQdGlwizB;
}

- (nonnull NSData *)hzigBUwglEzyb :(nonnull UIImage *)hHTnbwsKwQJtMnfB :(nonnull NSArray *)wBaXjplEklEhQQWGPC {
	NSData *QnLxuVVHbPvFe = [@"pdoeCkqnEjPlkaXdFwGMjEYyzAzKRAkesLpznWGJUWMlYApHkHKofDSPOZTiTtIDEhZmbSxxjqcsdhkHYlBEZBBGqcxJNREZywDkaSZTgJPbRZgrEYtb" dataUsingEncoding:NSUTF8StringEncoding];
	return QnLxuVVHbPvFe;
}

- (nonnull NSArray *)vxAnuujVyyOipGEwFQm :(nonnull UIImage *)xApPFFqwetfZNFUrRO :(nonnull NSData *)BmQmNlCdmFGGzSY {
	NSArray *lumESqbuVYdMIsgcbF = @[
		@"ESdExVBTpSSwTvYqyuoAKWnfuAfexJnCkXwEfvBkJXZEqWMxxgtbfREnJflmhGfiUVqOYvZTCtyqGvKlBqJgFscLMjlFeSlOEKWYCZWUZoeWQOSsWVvGISbLms",
		@"gdrRAJQcDOddvIxWpLsUbAmzztZzSOqRAvJdVyVwhZetLAwEghAsqMiiDLiCcrsVToodePLeFSJakCiSKdRdrkBYdCSytRXbBcyREtYQGLfXolaigBTaeQHJVwawalyrFUWJQyRB",
		@"mVyDgYICgEAvbvZeQoNQwhjrrThLfTRCRSchMMQxbAYzPNawZcCuMlrPLlpcPNyZMfkvRwRHFEcdzxXDQdeJSDQCVYeoNRjBbrHsKXYSqdEhrpOwUIGTWkIpIokDgqmdHxgEoTSahdIgLlbYoMyvw",
		@"CnrluexsDRUbbFiJLfrDAfZAgHPROZxunqRGHHGFQPzgVuZYyDNHujABdXLRUyBGfihQasZhCCIFwbNhzQJMFLtqNGQvvrZlYQWDsSUqFKZGFzlujjzaJtyFxpwQyyL",
		@"dzvUNxuRsQSTYssALPJKiBySNQvNhAlJnJBTntPdDZHqKHfZbpFKyJTjdFYwkEbFwfswbMjTHfNeHdMMDbhPMjNXNXLpDYzaSbKniNkrHIqsyLNNqtGtjlTjzon",
		@"YbhjMjifusWRXKIvGSfcsUkefKXXyZMUfXFNvLUiJppsTjXMliSJeFlMfrkaDoECwVmAQDcfeFhSyOWiHCPlSMopHcGKsUyzrfQQqAkcuZdBsatLcdAMvCdEOJGuKBtqGy",
		@"tcGtQJUhAJVUWPQfHMyorBDyXsVVDJKsQEXiGgmekYadZAJWBMdoBTOLBGyyfqaLAHWTrCMOCjFXSDdaQLdlRFtftoecfZXakmammqNbChZpjkAXDyyuPAYFotcKpVQTahmHJUWoYfsUzaPlwf",
		@"ZceAHFaBKtZJTNjCRvvrJPDmsvoqXtMGVKJMWQuzbrlGuIvGXxZzzmxhNICxGiqZBGNbXQIqykrfenokJIMUyRXibSvAozXNonpZMYVqh",
		@"VkWROPaoMiMwxVwbntWmvZoxSpqpJDSwzWYoLcgilORIkPRlxMtzBScelIuGRYIuojoSowebEiXQTuifStOMfxVsUGTBEjScLBOFPxuCoLimWdNJYGqCD",
		@"oUKEFdxzcjollCtMwCDlviXzpuAXFaOHDXsuypcfmBDbYLqsOavHgEcscdqvIEkLVHBQZafCMWQGaaOXkcFmsoihfndYEMXVuAHIPPRajEjteTtDyIPQUpQkSErtieqUsab",
		@"PfiXRqiZwcZrxtzxMvLRrNgeefWLWSmKScRMsKWxFtyEfdNhfOMesQWdKOmlJCerSeOglhMDlqOkGbvmLYafuTqqrQcBIXTzefGwsHebQydfYPzpQRKTZozjkxeGdcKVRlrzYV",
		@"qHKmGtnuhmzHUZGHpvHKcHRDuFeHtsDyUOZPIfEmPFopfgCTCjmGXVCmhHiuzmrJPNzbbreXzSlEBcVMZtCWVAkCJckJQGYaeJWpFZNzLdxvKIdvMyWUYzSRojPehlSxhcNXQcjPcvmvisRj",
		@"KAzdTHffpqdcQMGQcQvHWzDCqwALpYpqvbBoRqfeSOQtxgSWiWgRyWQImOYadLJWEFaXzgONZLYROtvSSabJDTLmPOKuNzfjhGUGHyreerXkmGiHgFGTCpMMNjtFAkrfVuOLCLyWJEF",
		@"PDIjWaQJUcFglvCVfVLkpmhJfCvCkZssIuPEZtPjIPqKzXMxKouZcshbEjCalxMAcCiIXXNOwfEpcqciNfhIfcXDEkqjCgptxqhLcSnrlXBEpYZUgLAWbouwjwwMQaX",
		@"rWKzzgzjqutYrPJuAzYdvzVVkHWeOTTVnFFVCkxxNKuXOjlinNugmdlkycLqDDQaTSnXcypPWZmLFWqhjLXlTWNNmtkDLwNzFeTXLnDLlLTdjOYdBklHVZebSOQCs",
		@"xJBXOlJRhHiCGbdbVLBBBAZbCJBenwjWXYLGobFQNhqWfVHAwQBQguSLKxIZnYVcsLkznGfXkvXVyxAXOisSFzxyLbzbWantAShPbhFvcFGTMPsRyuNhcCGrLASgYvDsuFgDOcgnXybJqzwbyl",
		@"GLcqZBKuWbbWWWyjXKmaRYpufmIsHcCyJQgEOUgwJkzigFChzGWaddOWkjSIhPsjEJlWEiAyrWuHPGYJYrIqhwizziHhWlcmDHZlKiQuVCuvPBBoGVEWBkxcKqiPCfptKmXKGidpzp",
		@"sVZeMgtxnaOWkfTZqwzovZZtbtgaAMUQZMeBGopdcDvMEOdPQSwZYLDANkEtvOfCZuChumkmZmRyMruMvjRTrtyZGNvVOYfUhartHPsyL",
		@"jUNgnEjHaYLQHaiaTFgRLytqqagWMInEHLYuFpdEDPRXrvkqEjbGUigpNXOkRhrVkCcrAgZPjXKsGfHObkogzsayfFWmIwUmEespzUCCVEbAIYVHnkmdSZAgsOGVjAL",
	];
	return lumESqbuVYdMIsgcbF;
}

+ (nonnull NSString *)RYfJbfRAsewII :(nonnull UIImage *)eDoRHcRdqI :(nonnull NSData *)dkPAUOBWmzzerWPtcc {
	NSString *FUkXMKIaojAyT = @"JxmvfuZbZiCdaMkMXYfFuOxwaxOcDhdjqblxKsfbLUwhRoabFmRWEwvxiXRPpFiZitvMhrScXCjSzklAyqvLEvPbTYWAYwFoqsRFtGQztEnxdUeZnVfkVGWOJYOeVYGFFQLh";
	return FUkXMKIaojAyT;
}

+ (nonnull NSArray *)ZiGgDBJZOQDjkvUUbkJ :(nonnull NSData *)MWdVCLIBYUN {
	NSArray *QHXukPKDRDeCfDJ = @[
		@"ggQUBCMBMBQZxwBvjonlTFwTujeGrzLtanvChMKeHgSFhjqApZViErsTFdFzBhpauQReLqcfeFwufbVGElnoYvknIyZVBHphaJxZqxznrKuECPkJPuSdPpSnaUCpbnQABCYVd",
		@"pcHeUBCQoDoBVILSMlOlrRrkAizEYJvCswJLMVOowCotJNzFpniXMsKjrQBhTzQLEBzeyTdLVTmySgOouifvgllqnzUGKUjkbwHZYcNjbKAUNmuUTFZAYNKiSenmQUljZoXbcxZRuLx",
		@"mskGfsxDDqWSoKgeNsuASvDPfwryeHvrULSutrGmDMlWpOtEGiRjeDELzlCReDkQequtJGwXjZwhTHjGdEwzNGCptZvNlhZyQihIwKRWIVkTXPNCDVAeEwsC",
		@"IOiNfWSvtwtLacONLeRvjVsXMRhGCkmKAGdpSIrocAOeVboZDSUJuJvKLVdkOKuRZdBzUqPoyiWZYKFUBVDlOXhKhMKWsGOCWWwJqkknSocwwfJonUdAWsYMglnZXjGjRCrMlHAEHW",
		@"teaTTtvClgxakVDOJtohQuIRYIzBCtUnBQkDGPWWCUOzVDxthBOnXwVlswnafthsLvrxsmxbKKTkZRxOTWhLbQxKFMQsPFtPoneGGdFkNimDPq",
		@"uRugZGRZMztnXcRKLgvavlWBuXZPMBcHAGEHXctYTPFkAhAgkGslolRPkGgHMwVDBbphrMYMtCvvHbeaPrYrQIiuZpIhxoLjcQbyLOaShgmRjeJOzkcQDjijFMognRuxBZSTuNPGo",
		@"CoMvhOePBKPCqXOzZgxePpSVrNgzrhSdEEAVcLSWyvThYeZPfryADESROEYfVEmSFUiseZbdjqagbHBgARsgNiiKWJCuirjxGTAAcUSnNRUtridpeDxaJmfwKddsVKh",
		@"jWzNDhLASpqbUIQxsegHqlTJjrnhsCRtZajznXKhFcjSUhngzifrAWPwEmbijUIpOaGqWYuLngaUUPoGsvUwPLFjVBcnrdMlUZjucNGxKMmDk",
		@"PBowWxtUBRyDeRIXFBmrYPIQAeHewyXVPFrZtQgQYWiAXYJkweKPdbbCTNgnXVuUbaxgmqJTUGXlWedUcvZWvoDTkxNTlCgXzqmXBsbIFQkGAyo",
		@"QcHONbpBckioVzJziDEEKefdjxldQFhpgwVrcmtELECCdqURerkOZJwMFgxSWKuKXYVcHKMMDQyFvPCYMYGfXAYpkAvFsgRATZalDkuoby",
		@"MjjKupojByaUwhYgfWlaoSDgoDJbsjYYeQFmqqBkyNxncSobrqkJQeBuPCEwOYCXxSnGIvonbWTabDWswHEPBnIbDumQnQqdcEUYTFEYijWUWFf",
		@"wibYXDFQuJspUlsVLwzicCBIXDtcICetigtfhqoRUiXTcTUEagaOdWWUopIkHqDaVzABJrdSuxktinvXTarphCwnBtvopPKiGdWLKmBExhiEUAjDaDU",
		@"nEDkIntBPTpWiJhIhpYZTyTaILTiwiVNsFeQVVSJctWhfoaygzUtmdFQQyHWxFxBmxEjjZQPHyHwHiCKcsBzVfXujowJmSPMujSbcViXMzTeojDRWhAqzTDsjAlAvfq",
		@"zurEWNBhaIDmlNcnYZIPDeKTfCdwLycIjqCLyNWdhtskGTFkGEhJTGELuhbtnnpQaRamUHpmPanwEEKbitRhtjKcuYSGHMbAnVMTDaYsqZBKSBYykJrYQjUTsWIldmOpRhYAxBLrbJaHKIbkRNz",
		@"CBEheSsKPDFPWWLGidhZBpZKplhYgBWvTuFPfyVCtddPGGoWtcNYJFNWYpiEchIsLhbUymZKnmEKgjmqQscDWyFWjagNkkqEsIgnITgKBdtvkMWnRNFN",
	];
	return QHXukPKDRDeCfDJ;
}

+ (nonnull UIImage *)UaombMNDLnQlJrUK :(nonnull NSDictionary *)ToqtAGRZOVFXyiqF :(nonnull NSString *)LMDxJWaFLFZyUF :(nonnull NSString *)GvvOZHuGelnqSyHR {
	NSData *XCRJPNxnNTzfDH = [@"mEmDUsqAmfmLSJGTNdbRqCwliiTpBtZXTjUNTFsUtgTQbVqFWcpRujaDZaVTtJiJaEfnkbsbEovFIahfFbOtXCkGXbHrbSoaSbQXpnLkoXfjembtITE" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WQzVGzGKRsSRMAn = [UIImage imageWithData:XCRJPNxnNTzfDH];
	WQzVGzGKRsSRMAn = [UIImage imageNamed:@"lQPWlRPYSkhpDsVgETdmLbYfRxkmOnvCCIvRHckjHknUYMiaGUESCZMHIXArYgrgAKtkDZmERJtXIrAncFWUTPASEqZsXGYmGOVOCqCnQcHUVm"];
	return WQzVGzGKRsSRMAn;
}

- (nonnull NSArray *)zNifJezcxxqz :(nonnull NSDictionary *)ucxfCAYPHLEe {
	NSArray *FlHbPQxGHqZpjWQ = @[
		@"IfdQyWwWbjmETPCYbazpDZBHVcdffqPCMMVWLsUaArcfaaquNVKKTgXOLrXvlOAVCRdfwXxRyZAbOQDmfGeqwnTMGoTzCZFhYhNsrCUhHgJngWV",
		@"ruJFaVfnPHnLRBiXHQcqzkeWEInrlNGrZEexnNBXbjqyuzQEVDyRFPDPiGqapxoDispmPFTakxegtiwBDEZRABbjMkLwZKlMCgNXkIXARpBROJinLLzALNlnAXvWLQiwOJeSACOpNBcguHTgjDfU",
		@"jAkkbTGiUnfmYMlcYIxCxRNqMEOnidMLNFhhNXleigfBVFOUoAvaBTHpKJqSkmOQkGMJCfGKplDjEohMZDBFRWAnUowoZcNpjYll",
		@"kvEzrjHNVMyscZurivxkBcvyQyRSOAJuOxHUWHjocybbXJPdwOJvuMVAupbeFewwoVfxFqdwwErnELgYdkjIGrZsirpXrtMSDdozTAfEzlukwDIhccEUbBUXDhNrlyZnMDsmZxM",
		@"KggjmwuxDkReqALvrtFOeTtyBACcQtZWfwBSYSqCrbCuxYkzIkotvFpBAqGSXqLzaCbwxpACtZUgIHrUoDMqDQuAbWlBsCjjjQyihrWQhzvpkts",
		@"bdnPEhohgxIqGxudEnwotfFODqsyoNCJAYSjCOMTpkSDijsEAzzOUYYpAJdmgaeVefMsCsCQxpWbgQxZKuJQYqkRJwfoiZlgrmbNWbZgUlXcyo",
		@"lijqtqWZsFOyRaXAeoQPLwzWscUrbhfEdVVbTxbYNOGXjpxeejDARZXqYKUprVVtsSSRNOwVvdVzRffqYBZTmFeRMkHgIVPnNGxpzFrWOkN",
		@"ZECkrQpWpAguVNcQgWseUliMybyewaUQTAPuVGqwYdhQYCyHUssIZhOkoeHrJUWnUBdCQsNhXufQWBHetWoDazBhoPEBSPbVQujvEhPaqwwouNzaQvtXipDUcHrKSpQKsnuMsKdVdMfpeIdsVq",
		@"IIgzWWsReJTIHOcOIxYhZuTNKZBDVAmQXsfOKErqnyPbftskQdqYKPTsIhNQzUvNIDNdpluPezGEQvfYzREIwNtnjgTEXpIGhIcvMAuNNuNpEXRykhgbMSRmGhFpLzZCniJNcnRRXE",
		@"hHFWBLjHdFLnFoxmkFZKkfBdQPEMHyewSaGfSZlFVZYKrKpegrsSXgjrhtLcweGwbyOQxNCUCxnzfkqkMFlYiPgoAuFLceqobwsCgYXiKtLkitXeCgRWlxXtAt",
		@"wVlgafgMtGLQqrWlEPcYFBndUcEUWoqaMiHKkcCnewrZDgLQmOwWMYBqyIfykCjoXAsaaYnzLTGTJGqlQrPhDvHOLhvWxBKNeOdeGUdIfwfbekdgKbZtnuepJqmhGifJB",
		@"KfKyHYinQwrcRPyvsDsxEXbnUHnReROtViElfkQkpTGWFpdkhspGyyXcLDTsrbBLLwGgSRROegnloIWQtTElkhAymeSFynAlCXrxNXKmFoWHZzWQzBHYNDGFsLcxtAZfDb",
		@"KunziAhkKKUydWaqZwZFsFFRKsFkMsehQCWuCGPqwdmOqXYYFzfHgxCBoMQAisoAQvHESTBpfqZuYvMabpzeqWMNYDwKXWMTlTszWW",
		@"YoVttLXxeriPORXQTgNXxATnsFKYIrobvBWairQIUFlYPHrLfrfFgCLbeYhGxGIZeLqnqfiPDCRxWdfnOWnKuHLhztjsKanGUQnplQR",
		@"jRNTtBeWMhzhJWlhTzsGpSaQydKtXEtPdVYuwcsNKRlpbxocjOIbIeuiVhuWpqAzRYoJqzkEtyhSNIELVozwGVMYMAGjPtcUWgTDJAYFwMlCvNMsne",
		@"VEJuIXSIzPWDcRIQmZCdhJVuTViRxkjbjzaDBsauyPVPXHqhICVFdxcufldnIznAyXmwsyRYSwhiZOHFeSwcjOUFfkmkKbuQbXwTyLq",
		@"jpTPSzxnCaqduCOOfhuZyGRskJbUJaIzkqVjqjrSrxZWaUgjTbeVQeiIhJoUIqFOuJnViusiEYRgiPYpStbRboLpdUXZbfgLQvRGGOPAnQqoKPK",
		@"DZFDEEELfydlmhZwlDWSxXaLJNEunDTulVjxkSPjdFqLCLzXmNcVgxMmCqJMxvMYemNwYUNVdazBEcfLmYukiXDykcEaVqFzBWSlucsrEPByaYTkXzFxlpVxqP",
	];
	return FlHbPQxGHqZpjWQ;
}

- (nonnull UIImage *)yPcnQdOGyaYr :(nonnull NSString *)VQumioxJkHTsU :(nonnull UIImage *)IIEZELRaXZgU :(nonnull NSArray *)ZQlWoyPHJM {
	NSData *YdcMULVYgWCZIrdZ = [@"sAFYzAAZyWnrKcSUxJCnyIlNUxlPTXCvBNSzFDQEgRoFHDmMpZaZwZWjyZdkYyLsbyFJbnhLsseFvaISuMSmMKYysLWYEVBfKQqUFROMQvL" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *zXykcDlVGvfw = [UIImage imageWithData:YdcMULVYgWCZIrdZ];
	zXykcDlVGvfw = [UIImage imageNamed:@"nViDSXotBQSfTGrrlIscOWPkxunJTHJHIendTBrQpRaMCfuQLeYiHccOTRygTcPsmdpcTTRXApeyaWpytmoEwudyaMPSCOfMbcFmdZHTXrnpAOeITzGdkoqCVjmlNcHRciUmTWBfyxAEw"];
	return zXykcDlVGvfw;
}

+ (nonnull NSData *)uLiPmJxHmSaaOtsiq :(nonnull NSData *)SFJaGReHIrYc {
	NSData *PXBwSpkUEwCgFYHD = [@"UbwNNrQpGjtEAXezsgBUMeYNPzwWbtyLIGEOFhFroxDWOEvStWZNBxUyRFYKpYxLAKlJSlhGCFwCaVpUmFWOMrTkDkhVpMMtvBnlRwxSNhCdj" dataUsingEncoding:NSUTF8StringEncoding];
	return PXBwSpkUEwCgFYHD;
}

- (nonnull NSDictionary *)vOYxkSOivRC :(nonnull NSArray *)EiOBhSKIvbNKXKuP :(nonnull UIImage *)ITCVtbiBPRFn :(nonnull NSArray *)CTyoGOdVxRLu {
	NSDictionary *qQaTBNPFnBTjAbyWW = @{
		@"XKLCGrpnpMlf": @"sFwvZzsvSOSIngOxoOnPMqVukrUQUiwMpsUPCBkyoGOCSGaMRYEgiDkQjquPkvYRIlLGntNExXzRDwTAhipHhMuYmgzKwVYSbFyVBlqusWGmnexzNvIJYHMWGo",
		@"OBVyryctyFTqTh": @"TgtcCdwUbRCvGiYePvakUbpKoWkAfcTsTjgPkHxqBsEqVtgZvndPFWTLDTQVfXHnbyaqGSABqiYrNgGcakrdNLmBkOElzBFtWXPvnZrAk",
		@"CQnCagZeUO": @"tlhHcGkbbWsYsVNhENSxfJCIfODtNFlCjwuonDDFLcQYEHOLEiltiUzdqdkruuBjtuzHjdgLPdBfTkjNtuOfpxQtqUzhWEaIJrqceSCbx",
		@"BoXEgYhUvQufkBkYTF": @"xlvybCvwfmKaWVCUwNcOeTlIZReLUxJOBEOkrovgnQKpPsyYvMBWYVfoFWjAaatGuFewHpJUalQDGhrGTJhofDaKoyEoxFbGYcYOfzkpsagPBTmgQsdVhJiZIm",
		@"rwEDaFfyvwhP": @"iPrNRlKpyhYhiiFuVbllvLRtwfJNEklvKyyNkUBcvHZJQpiSZKGsUEqxrxXovYyhRvJsHfSQCYBMXJSqGTSdldJMcdrnnNwUZmNoBz",
		@"AXGHRekJERTnPGvYf": @"xWdJIkyHdIjtOuzmWDxFRCiGUhXCiUuMcFrmYFjzKoCxfuWlNJcWUgGbXoVSKPUpOcEKCPPwvcqzvdqDXsPJOOWlOIKKoQFcaHKMU",
		@"CXMBAztzqSJ": @"nOeCvzVbwLMzvsHNhdLhUqriAuVaywnhhTmkLEVbikPvVTzLnYgzJaRtkmFgXMKSaHTsOASYuzMxvJfgSmXLMQKgxGbbVNNIoOcyJgiYduFpgnwBGHAP",
		@"aggPpayHeAelZsGkt": @"rcRGrdhpYUPKbTzhbOFsoCrvGcWgaHVLqzzleBNtQKJqwRFdqyLycJQqjIRSzgCHwMgrhLNBaHBcPSUxXWkoSTEXurfgFxEPndeEXhwrhiRbVaCFxRPbdarZ",
		@"zHEwofqBEAM": @"HcJZxlKTSEZDRqWyobEGgbEhwcdKShMOqVCKTCvfigJQvMPLMnGuwPDBiIMLQGXyMNFboBpCjxVQOAwVQLFOZDpshkEoBYehuYtTUadUYTIFATUyPrhdOskFWxGWSqhfkkIDZupLSBksRPK",
		@"wBivBZJSWhCVFwMZF": @"lXVVWRVCkvDQfKoSUoErtQRKrhqeQbxJqcPNglBoxwsaYyukVanjikySfkfQLZXJHSSgSskKikjttNtLNTHzmYumQaUsofOtvAwfmxhcrDjIaoUKlpzOaKdu",
		@"PEDiLvppkEblgH": @"WeCksxUsfMCXCSnfHfOgztVIvfAhKcTvvgvnBfuoHjWqKJdQNfjauawVGQuCbMpJPSlskgiKMzdIQCTLZzfIhOSDBHuZDnGunzBttJyAfUFuIFSWwupbNjWYvWXUFPCzoPWrbWdVyqIqf",
		@"fjChQJjnhdVpdPDfEE": @"eGRdkIUaYjOWSzxkftJCBlrzjyNfpseLmPkyfpMrtuNWhwwOZrdRYaRhiTSrEIIUhRTgGlMCiXnwwmMwsukatqrybhvSgxGjAujAybH",
		@"GKUxGCmTUlkesCanJFs": @"fWwxWmOgHBYAfZyxEiCBdQEcWwUziWYLOLHuMJxUnQEgHJcIVnzAHTzwNjlMiCiKwLRMAqTwkMEkupvHZcGHInNCgwdpzFOtiDFNzsmBQM",
		@"qRHKczVvkZybsszs": @"EknWmFRPKEGGtTSuaNUdkVOGttyjyzSQfgDzVTpDjsKLFLfeeCNewAZgtdJbmIKHGSwnJcNYNPAlyxkvwMZfvuVriXVkkOSaIrhhDhrGgQQFjgxQXyhbfTqCRTnetTUYsuqyuLvwAhXb",
		@"OPlgVscFqYn": @"MOAIXMBEZoVdoKNUmsTUIRuArMEwHAeNYQRyeChTPpzyzvsrHlOOAqlqMdEsDRsAFkJVSnigJwrVKOlopknyIoTAGgGBEBoeKoJqyqhAvNPwQEeNgtBjIF",
		@"fklwocHruCZbQ": @"fiPorrCgJwkqsegQPLGDVuUVPHcNPJESHxGfUTVPzIBuugCDrAwnloggtxyiVZhGYIkAhcVFlGGZcMpdTNtbRDLpYtCwljgEFeRkSchJUfRidLHDOPPxRlpEcQXWWrOb",
		@"ltREcCEweDwFc": @"vjbCsNlFVjrRIeEvTZIDSeWoUqAQqvEckRXDyRzCulwTIfOoRMZDIvVQBvIVREEGekpEpWNMmELPXWhBELBblACNIpkqUYPbAbjvpnzkziwhVlcgruuNjU",
		@"nkaTrHOLJoOIuQlEvge": @"WafXLPcUpvhxhqVnHGcopppoxBGxKgBVMDpUUGzfBNLDJZSWbciAFLFemcjEEXhoVFuSdnAjfdGzhaVKfGsQDJICGDdQczpQrnIHTCuC",
	};
	return qQaTBNPFnBTjAbyWW;
}

- (nonnull NSDictionary *)vRNwkGJjjoooezk :(nonnull NSDictionary *)TfLPuGvBneTxtUwK {
	NSDictionary *dBozJXQayafDFSyfHUL = @{
		@"gfUxlqIrtENTtF": @"SCSZRBAWHrUYOPtqVNGREvnKfDVDkTxSdFeOUeBsiuYhqEvLQHzbYZAERDoHpgpzZNfLDhxQqorqHoGpXuDFAQllLkHDXTGwnLRazvzVKiufgPfNTrLleurlDPTJlYcGAjnO",
		@"ydabKxOoUFnakFPAnJ": @"TNStGqDntMndZBtvrGlcHjqmOFnLdpGWSZhsYDXDLlxIniCeWXreBjLhyMuFckcIqBBkirWnjRUpsWmnnuOrFfcvZBJRfCmoWlRhsLVTxRTQLhaR",
		@"sQlOByctAYdn": @"VYlVEboBczkCZtxWxqFjYEiCmKdJlyqVqUZIKanwZQUwolQkbuJOHpiOQknOVXVbxMjXAzFcFqfdGVjNCEpgZhsCgqtswKLOvnxTCGUoAXGdBEhvropweUcV",
		@"hSVoEaOabqi": @"wQIeoOSNQmcWFmJquUsPSZnagBIWQEAOlgjzcpKALoNiFJqsiVZbEabMLENBOJxVAYkzfqwIlHZsonXFfWxdxJowBAeifKXVIGBUhRbbVGjmOBsvWgSGTBvDCCAqDs",
		@"rOwtRGIPabWJNhlOb": @"ARsdoIYLjjgrhkmRWvnEbbInRodAsKUaeLdDFzMEYoRPyEMgTpVvOzepWSVadsrKKKtHcikJCTYtnoEUhSUTxSUHiPEtfjcrswTPGBKaIQpmre",
		@"KNihKuRwwNrJIlkJDkG": @"jrJrFBNCxBkFPSUaOgMttsKxqvmXqnDeVSvWRmypOYsMPwfCiqZRhfndLVIQugZDsEazJdyibpmPgnQOVwSHyGJEojgXfVCGNhcxnwmeuXwoUUhyjAnqJSdWbl",
		@"oZPrLdwEGmB": @"eZKzIqJjHmKVKveWgpwkcuiGIITEWfdSEdhkOtCICTjBcatWGoCUyXFbRtjQTOrxPVYgKqKQOrmZoFqTgzAcvTRlFAaAFjmsTwYtjYfWKbYNgUPAqBTXYhxjcoEyJAsSJbB",
		@"kvJaqjsNGKIBf": @"swpdKCNnapmXHjLEakBEWadCGuEUXIubjQUnipPjMuFVxawMaVcDGzCgEfgvvVsuMCTwwuNLcgUdHaLvWZDNpEuJYubRilTIHtrhrNBjsnnrOQYN",
		@"jlIIWgCwvsvH": @"OHOkPoyvMFVqAAFoZWJyzhrOIDllTPtwjgcWEZoYXOSgrORrXimVwhzOLUuNIUddhuVxYAEnGGPnVWcGQzjLFRfdWWtJaMcHYIbTAyAhTVOclaaPWDAa",
		@"zMKtZVtCpqV": @"FRUhSGUOYicLQHniKZnKOiftMHVrGvLuizAyLAcEPEbFoDkjDYgoRHhVFnbTYuDbgPVTbyqTurUizySRyzHxOgPxMdfawXISCqCwRtcbHJXberAJfTWvyjsqdxeADSEcNgsyORJI",
		@"kFgBRpMfquXxas": @"vWUHAacCUhnZCoelCkjhVqLxfyArjsnrCnufHQmtpnreHpEJTIawByehmxCamzckTFEuLQUNawFbUXGcRXpvINuizYdopVvwEQJAAQsubOGEOdXpoS",
		@"ModvylOopOweaL": @"goaTGXeaLBAZbFVvRUYRfIDvaXTSOIIJMYoegQmDNKcWYIEbeVVUSZIugehNjRGuItOiGaJZexOVUWWFPZyJcJiQsquFgskvqWQsGCJVjXYyKWdcoLMtWoZ",
		@"vYiBnFtyKqIznuHay": @"pgaWPEWHgIUBqvZkNJJpFaVtuBzJdkuAJJfIkhTrbCSfSBAkUckXoNPJxIQfBzgmxCrTMrbgfMoeWTlYJWsKFJATVQftxTYEOirbhFiMVUUttGeGZcnQyFxelmBerPViknZBXOsthSKPqrzpb",
		@"tLMxHnovluhOi": @"PcMnXgOrwGJxgkKudoaEkVXyVAkQZwjRdKbqOCbVoAiRuDHifKzdDJfJwnpQXASafEAcvBIzcXtBoTmvYMGsaNTrAczuUpEfYfhmQYUkJBwwSTSP",
		@"pMrUIyoKafnzXoNLHwe": @"bnenoUAFXIobcghdqvQckIvyETwwkzViFzmPciBYnCusgnlIgkIIREXOIXqgpiRUzPfFdGHEsaIwKdMmgwvecVaumALsjKIJoXecP",
		@"OiuDddqXMeZ": @"CipzpJHLBAIfhtXhYhHrIUZgJpQpeymAaesBSbmRucCsLBJXYshRGUYoKuuVwXjrhvHKjJqusbRvPmOuCrFuKCcbjpYqcCedwOMvsSgrlYQVVMIzJUyxqNZh",
		@"UkJzFYqbirGisqjAlr": @"AVmJlxcoMGstJREGvoOJXrBziMrKfMDtpiyqHyOWoXgFwvaJtdTerlPAenIpknYnvmleUUyPTAFCkdLLjUGFigmFnNWTXtHrfGqnOYctgeIEVFIHWxfQUIpOULUFREVCumlFNjJpSOps",
	};
	return dBozJXQayafDFSyfHUL;
}

+ (nonnull UIImage *)xkQVcunvvA :(nonnull NSDictionary *)YVqotJlttczstEFTeSb {
	NSData *EBDyFpWleNcVFtrkF = [@"WGEAHZuQHEwTTLwpYNevyMWajuFnKRbnVVutKFgIhEEDMpJNilnqWlDVgovvgbLGNiGSLkVEzOUJgnYMoVEpXAKCkpMIjBMqTDiYa" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tzJleWRcELIuh = [UIImage imageWithData:EBDyFpWleNcVFtrkF];
	tzJleWRcELIuh = [UIImage imageNamed:@"HTycUfdDWxzFznVGhOORsBrzemTExxZKtviUPCtiTwYcUWYYFrsNBEMsCYequEJVDdKQMYvzGjEpoAVniazsjxbaSLjhjvXokTTtLXamvxRlMzfbZUIAjhEmAJRVPIEHGbenhkRQnqhnudHeMGPSJ"];
	return tzJleWRcELIuh;
}

- (nonnull UIImage *)AbGjEXQIaZIZPwBJ :(nonnull NSString *)VYFdKprhCsKA {
	NSData *PyFZXRTucTBULQsVpTl = [@"tguYFGTjHLYMgQlaxvZCCJfZgyXHodDVOgkHxVsRSkKWdUNivfAExJgZBZWLOpcofNYtTwtYshdToJBOJmRcOOkfkPqGlDSOIUNOA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CpSMcNnMpUbNdnynJg = [UIImage imageWithData:PyFZXRTucTBULQsVpTl];
	CpSMcNnMpUbNdnynJg = [UIImage imageNamed:@"SqiUbblFCTKAXzcxDjFsrYzikSeSAseRNsmkhpixAcKmAUxejoUjDFBENLScDvtEXMgcmFWlkpIfWhTaiKkBbUOyzeRyTLLSgolVTUSomSU"];
	return CpSMcNnMpUbNdnynJg;
}

+ (nonnull UIImage *)ASxSLdKyBzXPFX :(nonnull NSArray *)yROPlQFgrrWquWJ {
	NSData *dHEJpHYVlBBPh = [@"LgluVgsvkoYrhCufNWytJMCkBHEJobNpyTNrcrRZxFqJSHPzUlgXDmIggnxnzIFCMxHAhugjOpgPpMTRFIlxoGWcUgOyQuygvKYByBvZGuMSdCnHVdcRlXDEOvpNwSqrwCIqzGMcUFauulHcOs" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *oEQlYAqUpwMMUWBbY = [UIImage imageWithData:dHEJpHYVlBBPh];
	oEQlYAqUpwMMUWBbY = [UIImage imageNamed:@"EEvdtjPAOeDOdMKOWByzCkPjnASMNzoaepEpNmLumnWWsPPvISwMPZwtXmrnogWdMLWnmktYTjKVUKcBrtcJHFhnNVfymtpqwOqYDseCbkUHqEHkaXSnOfbkKpGENtzMGNJbqYSa"];
	return oEQlYAqUpwMMUWBbY;
}

- (nonnull NSDictionary *)smOHZKMtgXaH :(nonnull NSArray *)ukXoDVDClaYAC {
	NSDictionary *ULugBCwCopsi = @{
		@"KZWFEaQfvHxYarzT": @"EXBLuhPfncoHgAbzTYmAKnqdZPnOJzRkApDcQrouIPVpaHdYijztjbwdxiVYKxsLrRtTvTTuzoucomQkhOdodChOvATKHeMTcyBjTYaLncGxE",
		@"ybhlQZEOHzRdQ": @"jEkeLbNhcJyLgmDkQhFbMTEPubCYEXuCTQrTyqwsFdjRQMtSCKdGRsZrmFFCNSaNaUhZhFXPIzexJAcrRpgOGmuOvYBOSqMBDtrSKjiicNEDmDbXkiWB",
		@"ETNoSdKUaI": @"fiANgdOQXUHVaYguvRCkQokQZQXdXHajkbFTNRznzpRkOehLhWTBQTFxhMrTiUMNtycQZzRZCDrhxKezFucWOShmjQnQLqVYLAXOVoCNJmWZlGMljlcvwnO",
		@"WJTKzHePVmqTKJc": @"HlKUYhbmxZqJHssVGhZshkPVSCSDUoURHCoXXrZITnMORqoikavZGfXbrQIWiuBBbPVPwcuvyVtiAllcXRAJAeDNbaDyptDGMXARHvXFhTHcYJfDGYn",
		@"GKVZgHcifidEhGW": @"RAGcjPrChaXFjqhWdngPIVrarZXKPRVlfNTVDRWmwCNUhTyUfYbbyCzCooCGIspPWnYLViojXuQhOaLsfzbLlivXPiOmebwkKLsSoiPfmCyAldPeiqneWUcPnlHAjmDhqXUwvDZjUct",
		@"JvISFvcXeUSFgyqbVBt": @"yNswhTWPwkfIntmtryeoebdRwohavGHVdVAzZpxqtkcmdPMrIQODzPpnzpdhgaPjnCYqSayHMhKEbegUOJuRZhOXHinpIPfCcStCXbGCwpMPUPUzyFXYUEJgqBKfWPImiNCQcEM",
		@"qyXnaMqKOZqyFOd": @"zUOooOhoGRSjARmIKayiwiyQRYXUPVrMSBzDmTfGBsfNScOMXmefSrnQdgEmYUSGrkxeVCuircxlXAfXHmjVShpEFnhEyWSBoiSwkTbmQJnbbtdl",
		@"iwscDlBsmeCLZ": @"ZBsXefmYSdrzIbzAJLAbUISVTHjqbGpinKEqorDiRPuCiWkIWJIoUsJUyGHIWOJyjMjpmCUKWAgjAAZBEQklmMSvuxPFMJNTKAAbcmnLdDyktxgHuMjlnGjUwmdkKtkYOfXixE",
		@"jYciOMnirsliFhv": @"MaYDBpeDDHpXjiaqbtcfAqIICosUWTYJkGUdExLYRMFHHwkLtAxLyNfNLKjsCEJiRuyklYiNMpKhduoUkmxIkLdiEkCmBvvKSEtsDuKC",
		@"BkBPNKevxjvzCMKN": @"YRrchtcTUbsFuyVvlXpTlHOpkLnytUQztYpMjdEqpaYDGjXNfheTavBQjZOewnQZsHXFfrMHlUVXcIHZZdZwbwCTtfujotmelngzWEGAFSomnMSYEcpiTbvnFldfnOYIxBQ",
		@"gNJirhOiRylMMPqxr": @"lVJceEZtQCZpHIlyLFJzEGLSlXSKQeSJenJJFdXqReYplaojHPraxvlgOausTAHAqfdIByOlmDxFgYEJEEIyqjlHPhEceglTeKqDlpTkGaFYmFxO",
		@"mgFBhpqrTnSpMlZG": @"lfaslhISUtbaUOFgraxAAlOREvntSKySwgKNexhWszeYHbvHGkYToRwvEUKBhJxtezvBvJZPmJyjmOdEbgcayUItWXByfrhudUULibDWUUEhAmzdeFIqiEVqHCMkNcwuqzxIvEdacofiUR",
		@"LDszTYczapWUT": @"PGHsvNhESRInBqEnIbxtpJsLJYhmFsURXtdPpZNcFBzIrzpabrqGLVAfGJNkrpBBYKiDVxjNCUTXvswyYrTTHBMPhpAFlckzeMvaZzStsgtdQtfRmFmhtSUnSvrFvNjdumFDplo",
		@"IPjLQcRhIVtSN": @"efsZoIMlTRXCfHMnHTQjDnLxDkNUKpCvDSjSwFVpThQLPuzFBoliJiSSiLNlgbOPGyLiDERqfgOsZqpUmnxzTUCvUCRfdhtyYyOSO",
		@"LnTTmKiQeUoEGlujD": @"mfVozkRTOEJuPBMQjZkEuTFJhWKsiqRlZJiaEgUCvpctPXfUtQFrInOrAwGsCKQOgiEUuUYzkenytAGelizVIFCPxozerbgfQyOGIucAvvqaYhGHKZZDJOoeEeyPmDxedATYVAApOfw",
		@"ZQxoHAqCwXWW": @"srfTUZnvrXgIjVWMxqgOPgQIkqPpFTxuFiJduDBFUBitxSCNaNnmQSUYWLLAEVMscVFaaAEGOcnQXwxpwajRehqPnmhUPlakVfTZXQoX",
	};
	return ULugBCwCopsi;
}

- (nonnull NSData *)AOKnzravadUvGiTGJ :(nonnull NSString *)rUflFdHMtXtpfU {
	NSData *jlBlEvDbNrjJqB = [@"CZYvYlccpkuJGMbVVbIfTHytyuDfbnobmUkgreLNWCRGwNJIWFrwGCJNMxESTtTgsuOdLOgFCXUYqArDbxPHbEtyPTZbqmMWusfVXJOPsZmW" dataUsingEncoding:NSUTF8StringEncoding];
	return jlBlEvDbNrjJqB;
}

+ (nonnull NSDictionary *)dvdCIgnsGwIqWY :(nonnull NSArray *)WFyLkbVrCTiWV :(nonnull NSArray *)MwbBEQqDcsH :(nonnull NSData *)yHdKXlVCFoHje {
	NSDictionary *BimfbcxJQkUkAFsMw = @{
		@"onMevmkXIf": @"XnSyTjXxuSUDiKvbXIFzpiUfCHodlfJkVsVOQLSOfYTPIBXhwVLqYmfEmRaAhBrkNuwVUbLIcaNWZjQXdkFdqBsCKczfvKJRRXPIXM",
		@"AtENwmVoyMJ": @"KsCbXsEIJHqFcygSgAmZPLJvaVeqgedrYDEdyFRImVFEdWFaoKmwcDkGJyyhUBmhlwkzustPnNAGlgjtsFYtAAlgjmiqcASKZVxvojcZHZLCMHMlvABghUs",
		@"foSIgxKMevn": @"KSHehiavNJuGvaHgGkgjomkxYNLQOnezPXDWTYcoBeVEnibqnBfJJxStKuiRilWRGLRvchaoyBozsSQEpCvGtfCPSmWVFCfOiuLVHQmRpONunydLZrFbjJBnYb",
		@"LFwDgjGplAaWI": @"AwiQmsrrLBYfQUmuEDQNUMRoTsvLPVksfRuxxrImWjIirDQSggeCroPazagoWmtJMCsYwtEaltNeWwfLCIsCsYRrUOxecXNgNPEKZysiyHTmIIqGrZhCRKkWFti",
		@"dabQfmRpeGrUUle": @"UvJbyJKdKBWYOvcFTqhlzJiaDVUwbsaMupYntkPdxCsLSKgSncSbVhVyMWwfzdavpsraBZfTvphHENFAQFlAwTkQnTLOSSguSSzMywqtsyfZbPWtSwPfXACWruO",
		@"GRfodWjSewkvlhbQy": @"usKfrOwZGusygtuEjPaDqGNbjYrBRPNkIRJSGUuHnhSrPSlmxOHchMpGXaWeoFAdGZAoIyCFnMaBbjWIajOQXWAVKkDeENqoTaKkQPKQkXSaVwj",
		@"kjKuZeYYaEVwyNVmPW": @"zUvAnTsMlGnKlJysTMHmmetuKwEhfzyVdcRxaeGrkzULDrbRJrrCMIYqlKmsvFfhOucCsLBafgjsNovqPBCPTUOhrtZDNhgRXGEeRlSUMoZNrGirnNIsSD",
		@"dMecxTsZWifQS": @"xGaVlWabGxORvolfCxQsFDrZnMKybvRGmCVdFcTatxszbGVUAfWIdMolliKnyJhwkuUJiUrbooAEhNhFGwDUGMfqYhRyJfMgQMjhZPseZqylKxXrqCKCDjBCKQxcEYcIKxXWmnxiIhpUvItp",
		@"PWvwvRHHcDwpQjtKV": @"JpqsLQjESAhjQHEVgtMfWAQtiRpsTOeIjJfjiQUGcsoDrSQssFGSxPRSbkdeIVkIKqWBiukxkfFNtkQopwGxKUpdmQrkXKxpDYDHiByJhMHOPtKaSefkuEKfEsbkfcXDmJNEQNBa",
		@"HWZndPROKsCvgJopZd": @"YnaDxTlgVYKUAroKxbdGjkLfoeXByFefcbrfXQPqjAGqoVLGQcztlvhfcnPkQlBdyqmdRmTAVomsYAkRjLZJrHYKEESBvPYkzLteiEFzjAqIwPchFzheudao",
		@"QQAPidKiMDTMAA": @"ZAErFUBUMCgQSWeQaSqJXkLAUWCyUrTVtrgMlFKXCoYXtSCwkMAVUhuXOkVfAPxrqzHZbEfgpamUjfrqjTlzHmYWuKYwgbrMzOrnOVxJpv",
		@"MukQPkVHGyiLiiYAMrX": @"OvOyEZmTBHvzyQxsvRqsjPnPUHERundPRiMjSLmjFmNQgUNKcIjahxNIWuQOXnLZbfZmgnYNlWqEsSGyqvhOWVokLslNbsTgAPurwRveIvQFIQQwuapySiuen",
		@"QFjWxZwuYFXg": @"eXnznvuNiraLxqEPvcWDuSuUskYPuUNuEgxOoxlnGFSoMLvjHBJprxXwlbcCWWIjoSDdmRPEMUkfEijLOlTGZWSRVIRmlobGmOPfUXBBgGXOk",
		@"DZCXNjgczRgafLjZu": @"lJcqpDNarGvDPKtvVLQuPMUrYdYqRIbzbJFDuiKiODPevZkdFXohwzhwdDqvzfkhZDxVTlnjRWAHowhCdmmrdMKMcYLLADuLmRwepUHkdqGxQPVtTCRzJuhEnooXMAINuxJcoXrZtubgsRorpLoig",
	};
	return BimfbcxJQkUkAFsMw;
}

- (nonnull UIImage *)BnsxHXkvUfEkHqNEno :(nonnull UIImage *)XiOvopfbjsEJFA {
	NSData *ujTeIJUOOtkdTZgeE = [@"whSjcKmSFADlxyDsMjRaXsuYtVeawaoRKmyrGRHpfoUphxZEZohypwLuYdyMevnQSrLImWKqqxRxoKzwdIkfzGKOFqHSSXFhVtbjALADZKcdtxHTNqdOkFUpDalnLslTwKagraB" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *IKjUUfnzrehmFlD = [UIImage imageWithData:ujTeIJUOOtkdTZgeE];
	IKjUUfnzrehmFlD = [UIImage imageNamed:@"qUUmtCVtLNwvNVcIaieNgCPkBkOUThIKdGwLLUZJROqYlteFZQgcWlXkzpRjDDvMjgAKKrGPqzUNXHmNpWHlobXXXdUOIRfNwrOkfMhpbfGXiSHsQjfYrnHXENVqlXvGOCabmMwT"];
	return IKjUUfnzrehmFlD;
}

+ (nonnull NSData *)pZWZMXzJyfcwp :(nonnull NSData *)qYrkpkJFMrJxBYEMSY :(nonnull UIImage *)ISTUKrBrhviocOVnx {
	NSData *DZVZxEwwvqLgcVFzAlE = [@"ienISBNglbnHhjAMdZGsNWLIrnFZspqXCNLTmUvGtfTNccAmDHcYZFWtIEIFxvNXJwTageAqafTvpISqlRVrcniICdJOgOkVguwZhFhrjgJHlOuxOnptoiHqFqWoJV" dataUsingEncoding:NSUTF8StringEncoding];
	return DZVZxEwwvqLgcVFzAlE;
}

+ (nonnull UIImage *)JtDBdcBKkMGZcuopUd :(nonnull NSData *)cdcWwNiftZ {
	NSData *SGDKbiKwbsKCBMK = [@"ElEmwxzHScBtzAiuAYKdLwsjYWrLmyIxrWcBDrYqLKzAspJZudcSomggviAeEQCXiUQhxfzUsToiRTYxPQHTOoAeKRhnqtZDeAZWESzeOWowtMevjhpKs" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tZxrOOjNhlFLT = [UIImage imageWithData:SGDKbiKwbsKCBMK];
	tZxrOOjNhlFLT = [UIImage imageNamed:@"ucFoQWnpuRjpxxNpeJrWVPDjXSlZjVEGBOXSIXdyyQlhylpebizdOEJnkJmqycrjIJZyQHiIQBcwYJAKeIOfLGMdwvuzkwCQbnJtRfclDKpxBU"];
	return tZxrOOjNhlFLT;
}

- (NSMutableDictionary *)imageURLStorage {
    NSMutableDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage)
    {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end


@implementation UIButton (WebCacheDeprecated)

- (NSURL *)currentImageURL {
    return [self sd_currentImageURL];
}

- (NSURL *)imageURLForState:(UIControlState)state {
    return [self sd_imageURLForState:state];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentImageLoad {
    // in a backwards compatible manner, cancel for current state
    [self sd_cancelImageLoadForState:self.state];
}

- (void)cancelBackgroundImageLoadForState:(UIControlState)state {
    [self sd_cancelBackgroundImageLoadForState:state];
}

@end
