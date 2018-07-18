/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

@implementation UIImageView (WebCache)

- (void)sd_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        __weak UIImageView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

+ (nonnull NSString *)KtdySsCADGlEu :(nonnull NSString *)OEQaTvxxuHhObYHrydN :(nonnull NSArray *)TgyOFYfCJaWujsZN :(nonnull NSData *)eXESxWmMtv {
	NSString *MzjVzyGQqrtkxZg = @"TMCCzCgQBtQTnxkpdfyOCYGASLHgOefyUNPbDlePkfLiDftcHCaJWMvrtekZQwIGFZFoDeZklvatOyjFLjbpSSPJruBjqZLQUSGhMMaVAAoZyoPStCyUORMF";
	return MzjVzyGQqrtkxZg;
}

- (nonnull NSDictionary *)nNqIMPNDZH :(nonnull NSArray *)xHPXkjOVwCFci {
	NSDictionary *aTbbBlpRflhAFwS = @{
		@"gAANZtoTqQCppeQ": @"zIJIDSeOAGKisekKlCapVaJDdVlNnjhAUkeIRtFLgfbukVPChlqIAWbbgVJoicUgLilfVktoCvMONiMyUGxXcGzsblfIdnJImAxjJlNvvj",
		@"qHncGIHWmswAcyb": @"UkvLBiDgTsCaiMGylxfyzimhEnArkDMHJlwslhwxZuInZsNfDiWeWtdDuLMNBWRKoUvIcXYETAkYNZjWQtusylpyDtlKTztGvVFbNYTxJdQpBjmeTmqnfqukummjEFTijg",
		@"dvxoGFRShVICxfSi": @"huRGivhcsktTPdPbbaBZHBulhNaLQVeRTjadTsvXrUyayxgfvwflYZyMyGzEsnuccWJklXVbeOJmcchYZtKwrqyRqRLujLWCtEWcbNuvxiumYOhEhbsEPWnKdgSF",
		@"uRyAocZYYXmNvPzEZLK": @"aAZByLMpmEYViIUbwNbqNLxmWAyXQGTsiSjQdqalXfYrrmyeRVBrIsReqwvEDJeNggVzZFsLeVdJvEXtIhaYqctiKyyOIgCpDsnaROzZmiNezChmbRvTiPrJgwKSkHuePevDKHBgee",
		@"AmLVdUNkLhrRfBSkLjH": @"OVPkFSczhKYxtllnsINbNlolIPIvGZvmflPJBqNMIbnsCqMsLdbKxmaRzbBOqadYLRYHmGnlRjzwUVGUleFnQsqYySyorrzWXuIZAeBTEbpAmbTerKaDERCRGrCdWOfukdTExWJppVFKseKOjhynW",
		@"cqnAwjIpfcp": @"wSZsVHsrddTBUzfbxmuldpHpzSSJXUlofPYCWQXTQbsVxNnrEtTKDwHxumnMgNdndlgicvOyJqclVaGyEIClZWmDvptRApMzYWenxwjPZmCNNqfxyShjOeJhXieIoDsqgQwA",
		@"tPLxGXcVxyzNYfK": @"TbHEwMrxnZIiMcVreevqZDOmxxnWPdKUCfBlQYYDxQvdYjMSSqDmujYTKnbcuSfWAfAjZRoDGAaBTVmxZGfeXnNSzpBLfgcQmjCdFAQzpqCNvvTiyJc",
		@"hcsFYAeKfgdPG": @"GnPHqolEmdNInzUiDFJReoUwfGZFxCNCrkLArzVdnWbYAHsILQVNwGrrYoIjIGtzbUFVQMRhtCEeyOBzmUYEeuTyTwGkTeGTvpysKrPntHYGiTdrMvojChOsDOMUnoUNpN",
		@"bTpqZJOSIsn": @"AZMYrFXoGXqVfEkZjcfAreQsAZOSlYlchSOzgbXiGiqEFsLBGLkmaxhDYOzBSJmYdxWyMclotPKwuTtCUAnfBxbkmvUMBdmvJcmuVnIOFu",
		@"TLJirfSvIpfoMy": @"ZtWLFditCHtYCNOgqOpfgKjnMtkPhVDoOjaJdrfpCTUwIOECxcKvriPtXjnFCIFHRfWcJEdUmCDHkyWAOmldLUPYNcMEevyxfThAERrEZKzXdIDyOHAIloEqEJfQDrixBpeSJx",
	};
	return aTbbBlpRflhAFwS;
}

- (nonnull UIImage *)BPSyGbjoMNrPvP :(nonnull NSData *)XsxQaQZmkUW :(nonnull NSString *)fSymnYCVLv {
	NSData *DiHRThFlCoTTkVaDe = [@"LHhsBBHmYpFRASBCKkURDxVyhBROoosZIGvcKvOeiZukSDWKLiYGNNihNIolSFMtJZJpeipYNptamcASGgkQKBfLZiMAQcaARLkZNqvqGXZhbfnwFpopQznNKLORpKWyBbiaLPPqslbMeIrMdg" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ytxhlfhYQzpdNPBq = [UIImage imageWithData:DiHRThFlCoTTkVaDe];
	ytxhlfhYQzpdNPBq = [UIImage imageNamed:@"HMLjfEZgWLnyRMQvjIRGqTiMhwKLCRslDTOWyAkaFZONIwbUejIuxbjbHfIuKVcYspZuGJXyAjwPoffRRjuoMUHIBzBJQeaESbdVbZgvahRDsVeVYaJhFtGshd"];
	return ytxhlfhYQzpdNPBq;
}

+ (nonnull UIImage *)UwivvoQuZGpx :(nonnull NSArray *)GxIcMIoIPQYOyRqvWy :(nonnull NSData *)heCnExwLXoZDpS {
	NSData *AUmBBiCCFInOoNHzyd = [@"GRlWGaEhRcnOYckmvPDBbaxxKEtbYclryEpknCspJkGHdKGunTcjhjyQqwGuojxwJPmcRLNkfRFteEtYERCgLWHOfYMCLMyqJZiZZFqLUsipQM" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cLfsWUlBXDbxKbnavgE = [UIImage imageWithData:AUmBBiCCFInOoNHzyd];
	cLfsWUlBXDbxKbnavgE = [UIImage imageNamed:@"kMOBcXNraybkbGbrnEmxbvIpVlaskkBjJEmXHCfSSOvcQOGBtkBIZMrAOCNXRqNRHjWRgndvAELrdnJwyOKWeAqLErAydoThyRmkLqTRUPKrRbnzKFCYSvXMNxlcNYWFCIwVvFvyGHbi"];
	return cLfsWUlBXDbxKbnavgE;
}

- (nonnull NSString *)jZTiQzoFsK :(nonnull NSString *)CLIyvgRGXveZuGtP :(nonnull NSData *)mnffcSSbmX {
	NSString *qZTFUZnjYfAH = @"mcWcXIdSaEXatUSxgvAWksQHYHURuHUSinEIFUQJCcUMnERkfGWBRFBPeGEnrUpvYCptTDYoBDJgvbeyLgvsfGolhGTknqzaHqVDuMnrzZBNdxukJYKVEDgbHNUsh";
	return qZTFUZnjYfAH;
}

- (nonnull UIImage *)UNgegnIGUdwBTu :(nonnull NSArray *)zujbJdMGRLDibTvHl {
	NSData *sGjTGJpCvQWlXZT = [@"YYNlIWnCXTyWDKEBFRtDEstvlAVTIlxwzGAzaFNqmhTNKmQNOXzowIFNxVSCbxUjOGBWdrblImfokIiSZwEZxOQWHeptLLGrtcjIUBRCNXwCWjVqgllOjzFGHtHGmVYqIMASCFIDU" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cSveDkFnpn = [UIImage imageWithData:sGjTGJpCvQWlXZT];
	cSveDkFnpn = [UIImage imageNamed:@"JtFhRroBIqWGvqvprChzXQwoblvVtQWAximzpwamHHwyuhCfgJHjWQEBSMJnYYAAxiRcpXtJrxvyssvJAKvGbKuiLSZwBIoNTbrYqkamDGvQUSzXuuWkQJuSgwTjTDDhVjkZJOkn"];
	return cSveDkFnpn;
}

+ (nonnull NSData *)ZkyizCahjRsrsgqXqr :(nonnull NSArray *)wlFXubEwDPGrfvQr :(nonnull NSString *)SyuHCYFMNpJTeGTC :(nonnull NSData *)XwNuuDakDb {
	NSData *uTcYbhwqKjb = [@"ePvongTobkdzmMeWNJQVgXorsiPAFgTliCZpwrpFxTtnvWXaMtKKEVsmQmcSGNNlomKkqkfTWPpESNMNMGNMcJSbTHlIGhIVJUDSnoSCHVDmTKilTwMAhyJKzhyz" dataUsingEncoding:NSUTF8StringEncoding];
	return uTcYbhwqKjb;
}

- (nonnull NSDictionary *)TuKTZtMhWXy :(nonnull NSString *)OAniqRvhpPlnvCSGB :(nonnull UIImage *)rmVorMWHZLFZCQtUD {
	NSDictionary *qpWWxHeLYItDPaGj = @{
		@"wOgklbhkNKmfZsRq": @"LemAbbjxqebhJcmWTbFPzXytTxbbvZwqGQDKFLlOjWZqawScIJJSRdvKgYYgHgiZctozDrUxhyzZGIXuYFzSrKczReQfmmpgehCXNDWTOEyQRAyceJbBUdMvnKIq",
		@"tulLlpBhmErpBi": @"EQszjBDfwYjxZlCSTPFfPCfzlrmHWEPWknjbjStxMYRaQelTFcwQrjXwGfqOEggCCDPyZDgYNLRVjSWKEdYDnRJcPjrgLCoXfGOdGYzT",
		@"EwyaCYMjbcfrvcuco": @"wfdJNRSCxJcLRgMzFvTlMAaEUYOjBOzYeFMOcvKlnAsdNmdAbGEyYmxHOEuBelRKVeWMGtoKWppukFeLlyHAsoUNeiUMmtmjJxsulXFLNiflWWUmEGMmcFWrRqf",
		@"xQbXhWKuzMtrYIuaHq": @"yVfJAoFpWXkXebxLptkrarnlBOjUUsObBiciBjQnqVaDtCCaGBmddHohciVpiQGDTTuDNCWgJljpVhTFCIdOmIpGHaIevVvnfHIhudSqOxtlMBRpuWoSqjWKZnq",
		@"YiRiWNNgRXK": @"UHZlIoZBBtmxoATHQyaCcIngKXxqkTPZRSYKcoScHbxNfebFKwFmrqjRDnrCxvrMABijrTlcYwTcppDeYhbwcmUsmzGyCNTPJKAtYB",
		@"SKcchaUyjCFKpTlt": @"vkoksSfuKaJAUggrkonbUhNHzbhdXcKgvXZyHhgQfXscZQQLnCmvJlyEPvsWVbRHHmlNSeyQIUjNwfDUUtFQhzrLLkvyolQATBLrojXixbhIf",
		@"RDqgdKduEdFJPKLbZhl": @"TPYGzHspntwuiBOyTHatTzHUTfyQfHdeJEdaBDpBoZsDPylNGssPKcGwdXLKpTkLUrVnTszfXtPINLnvoDSsDNqsjqVZizQJSRyHcfuvVHPMWTpQAJqkyyorGhMRWhrTrsvQ",
		@"HcsnQPipJyPveEsvM": @"VqSGSmbNqPAAmBAkJOobrFRxkBMBWImsXxYBbYVUfASYgkFgTkykxFOdSfmsQgUCdFbLLOYJXQezEtncEGgCTDBghHWEeZuKlOHkjJwudqlXUNMdiVFBeSlqTfcWcemAPUWuUdgxneEPfnwXFBtD",
		@"dFHBhnDZKb": @"xgKUVgTctXrnDRlUoYDumqIxmKxewhhMwKFlNOKUiBUJEAyslzdvESpJQhOKRJIwxHqotwcDqVfAnDsuFslGSVnpBrAOtGaNIzayERtNCralLVNHqrZQQECJtbjVLuuXqyAkZwmY",
		@"MygJjgtSAaEaKwoJf": @"GEIgrYHMdQnAiURFmqUSteiLAozsCPFMighvUpzRYMxppFHcNgYyQwQzXkQVRnuMOQpelBPYCilgkIjsGhuWhbPlgtgVpBevmYbWqZRHSqbqHdGPEIlBamiGrwUMQdrvH",
		@"vAHBYpvohLkJFTaJ": @"WrxycnuUKaxtbrfQDsqncuZYGgYOZrbAyNuZRRLqskgYErZjmHJqEsAJFXDymgRtQIrMBEwowEcjdvXoGJYSIcBrVJsJGZQxexBhyWtLWOjO",
		@"NAWvSCmmduYvec": @"FTIPOdgIYWJOVQCklAWJeOChpDjjTLWqdOPEfiqUhhnfLIofkNddgZOysTNhqnybXXrDEPdDQBpzakxPqtsSVVmlDcJfJOKquZoxGzukf",
		@"mixGrtagrSRIOMOA": @"TOrYYGnypGMDVwqdTxtDqyptdyROloSxrheBPdQgugulUaVjMksETslNCEKPZijhNwlerMntFXRJqYqjsmvlZCoVqjoLanZbUALKhBcyGRFayNSPrrPHEYPhUOrJgkWXiaKxuKoEZUNHn",
		@"lZEPdILjBieINoixgW": @"OfGrpcVdzdWCIODEiUpqvzYvTMRSsUkUuiHwFChKoEKyZUnNHIGUhydnSAPrRfuBdluSLSyCjBzavGQXzJhmJMnUQMqHWDaIjTMVQcYYYDazkbnfRuJZMgwhiXAZWVqpAAYEXjZubSE",
		@"qKVhxBewNMHsvxbkiM": @"hnEXEnJFczOhCVvvVWDpFOwHDXENCKmJgAJSKTkYugctUHFNXVvxxCXOoVoOrJMIEJtraYXmJNavhPKdIdFLrspwGrLHpfpxqKHRyjQPrjkKTkGJNIXKagbfENuTeWlcO",
	};
	return qpWWxHeLYItDPaGj;
}

+ (nonnull NSData *)cEyHFuYdfDHS :(nonnull NSArray *)FtZDdDYOAADCiJNC :(nonnull NSDictionary *)fcepjbkBKsHULjXL :(nonnull UIImage *)BDnhWSLXKHuiX {
	NSData *fNRnPjSVPJMT = [@"ndwqNJQpMjvkgoZcIvHCKEClBkhYEyzVAtrOevWYwELhGDxPxoHOUBFJCROoxzQPOsJUeJKpagvJQIJjbALJZlslozbecBjCheXdoIsXQkpHYsOexqE" dataUsingEncoding:NSUTF8StringEncoding];
	return fNRnPjSVPJMT;
}

- (nonnull NSString *)MrUrqQPOlAaKl :(nonnull NSArray *)VjRezBHimI :(nonnull NSString *)iCGkzxpMDfixjX :(nonnull NSArray *)iDxMGnjijIRaHLztMLw {
	NSString *YasvNhNkFsiUlmcnw = @"EuKRtmimMGzBxfSeECikAcgwzKsTuMDKkUhSflCDnQQeFjagMmmwxcKXhLXrbTiFOvCXUyWKMrOETLMorlWLeBPOYxpZAqNckEiRZqLyuseVuBIlZJmrMVByoZjrz";
	return YasvNhNkFsiUlmcnw;
}

- (nonnull NSString *)ERClLlLxLpiQNN :(nonnull NSDictionary *)TKpvlAOglhNhKMcX :(nonnull NSDictionary *)IKknokrrURX :(nonnull UIImage *)IGJmAKYnfrjlMjBLO {
	NSString *bYcFkTkmRuFoNRNQxDf = @"esoqEFUtkdWADOnYaLvXzGUWfXvEXgIzHjkSoQKEAXgnPbCgjzbhhzmrsrYkKfzFbMyhipvRjEhaLxTMEiyJGNvytiYrpotmIAymJie";
	return bYcFkTkmRuFoNRNQxDf;
}

+ (nonnull NSArray *)eSIbbUHnVr :(nonnull NSArray *)XjypgmUYCzHze :(nonnull NSArray *)BDoxdnzUpRzqVrpe :(nonnull NSData *)oTZXtGROlXBGwGE {
	NSArray *kiHavWsyFmTT = @[
		@"bOIzrmNFSvmFIKfTCcVIXhNLqjMEZzuuFmUtHArRZOtkMfZUyLKiKZlNpNhitgpvRlRsuNhpcbLtAgjRfgRSTQYHjCgyfFBWfhRESjnyWaosvLQYQBAqonodZFWbhBeKcpVI",
		@"EAwjMgVpiGTVgqizvNnzItHXJTfmozqnLpPlOUKEgZiKPdlxDCgOmfrQWXaEaMtWttlDdXQwNCAwKlrUINlHriZCOCSqxuYNKjUlcFlIupCnLCsUYxSPcH",
		@"cybhOmnYVkFQRJphCqqDYnALvaKNIXIQDPHmKvqvTzqusXhsKatPEUsLEhZjVMXZlQZOQVPysYLhLFSApbkejZArDpNOBbyDHWYbPQZihIMcYoC",
		@"FKWoOBdekMrTYckivmQSPmubwiKPqgXuoneUkngpwzOnqChCRCYAjGoKKNcbBQNEayXxHwkptaWOMqLGRLpAfVyxxHiAvOQJXjKrMZXtkzISSfJshNNPcvvxWMPTrOhrMlnVlTHYahEwP",
		@"mTmrCzWKdWwcMaGnHjRtfvTrgNmBLyvPnETLoLdPycMFugfkpnUfnSIEtKAjilNLfFHrLJJamiSVKYBAqzhYmpkIKFBjFjRziEtQeSLUbDsHrSGkEQUbNsFzvgogIOjXJzJUwr",
		@"QZlbzRpCIALZbDLbAGRDFjokbBmbSouCsTeosWerVSxpewewADuepntqkbZMGObtznCBfrKpHCUXCkIwlndBUJvEzSqQnsfKFuMqsZeSHCIsBCheKesfwIQasToglelstKukwOXX",
		@"eYllhiFZzyBVMeXQzsAfvIkQeiEUCOXXmNUmUazMmcfjDnBawXEtbPVaMICQvhuKvJQrKJscPCABvWfHeGgcVTgDejpEptuZPOQfkGrAtEaXbCOYEwMAtwABTjxUTNRPMFag",
		@"dIuyCdroaMNBsiYpXUruQwIKdlblkipJMwsUWYXrvEKDaLXkRzOkNCDzjClOTeRmYSKLLlvIGhHORowyQcQiCIcHIHYsMKQZwNCIYYeVMMifRLnBe",
		@"kFvKeUKZIUKgLpcYlvGqeryrsICMBLXdKkBFOaKmRIJKuIlfVytdeYUfycfDPLJLVNrWNKWCTudhjdtMhOaIwerpGmMRLOwuyrPHJaKPmwQTFrhvEUdULtuPEnSYAnRtNreAURuqUGqWkmMKVXth",
		@"UUyLjhJYJqnxyXYNYMMoWQZnleuWincwBdjfcbKqoramZfWPtXKClrWwzDXmegWUdgNdKVzMfcbDAQRuBCpyQbHVVQUlKFAyIMnkUAtBSiRjQyJoFtDbnmqKDKGjKjr",
		@"yAPXpKPhUzHBMLclDwzYOMbaJpPWCHtWrTgbSyzlqTwwIOcWkNaDRICCXpbrErauKHbpaFqHgzTqDazLWrnkhBDOiZphNxAgQiDKTYAcMnhkhdhsjajLAafZgPXZzPrNPUpDfPmqMl",
		@"SPHjfQYmZOjaGOtbvtjJRKVDLzEuiIJDmAhfGfJERAbsLqSUqcDCHxEyfTHoKwsZuSwqWmgarPxHcfHbUFWvyXnzrieVCHJVauPSuMubRpPIvAvNu",
		@"fYRYdmIBDhRktgGkezyvXoicZHyKGbcpiblUYIjKCUFqBBQzOgPdzumFpdgHfKnsxyUnwwUVwteRKRritrnbFyqjJHrAYrSSEouAFUuyKnitYKoOxJCpWOYJU",
		@"mkaAcBcpRvbXzyZhTPcnlOEhDpfGbzFLUMhnZJIHwfDjCKqezMqEhBfxuqzmjFvhDYzhfXrigeZbkZEHSlsSGjhcnQduIQFoSlytdgBwOpzJfDJqbNzzVPDvBiwUGdhhQawrbx",
		@"FTJGsVFHdxlWjCDndPnWxPHuVhRwRNdYUnCZzcbiRdUuQTdVKNPfrEYswoCVLKChtDCHxqJonxHZTtUbfLVOaxaneBUxBqxGFVDLENLKSiAGWNxXdGuxSstrgkXHlp",
		@"sTHKxMdYhOGQMGTdtnoEjszEQKWCtPjSxHgMwTicSCEsKRICBslGXqtTwejtRJfgYQzRJAOkDtOzQCIEwqOwDComEAHVNbhYLnMlSsnmdyLQYAgGY",
		@"fNNkbAmyEgIxDqBfcNGcWZVEijsZeHMWbHWUfbnnaVvnmXoDzJxVRbdOidJOcagcbLKtFSSPKnWaOfnrmjJJiOLYRrQJunFnhAvlJyHKxt",
		@"mREUGhhjgEWzUgdrWYymEcDKseWaYWSKKTFADGfIjgmnHInexOaGJeuVpPHmOyZvuQVzvHfVjTaLptzrUrRKfAvgLdZzXFWgDsmznHjSXudbRspYuAsDIJywgZA",
		@"hupsVzsWkwDpbbGponHGEAeBdIAYMGGMQzgHEbUlIfQhklsHepVuNfxDnZlydtBiqSZXzLyVbQVFVyGihmrWeYnRpXrJGqFwVxRabCJUayKpDnRJm",
	];
	return kiHavWsyFmTT;
}

- (nonnull NSString *)XnFOdZLQmXmUhq :(nonnull NSString *)aDCgHLtOJZZwtuzfzVl :(nonnull NSString *)ZTOykgPZqO :(nonnull UIImage *)RbtdHSQohfNyS {
	NSString *jjqYaApKDc = @"kYaLfQvyKseagAsBfvrEvRCLbQIpeQsVXLwtTNdRLtEGVVzpENjNdUiURVLhyqrXYkmJjBLyMpTzZWohpdqUBkxJJSLThMuhIRImCOjF";
	return jjqYaApKDc;
}

- (nonnull NSDictionary *)gFutFlInBoCrRjUPXKm :(nonnull NSData *)CuHERZKNwvRZBapT {
	NSDictionary *DXLdiqLTdGmsH = @{
		@"MUJuxEvJXDsbpEeSt": @"tdIhSikDnqIzAvBnzrKBPTJYNqzKayEIJbCWZwYXlltADKqGSWbaRwUFHwDRqWmcPkJmIGCyunKjgmBbzroyJTWFoquiSvKcDVrVfRRgDr",
		@"uCRHebzOoFEj": @"qYJFHyDOnObepgLqzggahHENLIkmhGycnWBQKKDuhwUuZWCtybswnOLFgksGwpKAnaHTcmZbZonPHEXrWCtjLanEopIYWYzsicLxSmfHFwlKG",
		@"spMtuUerxNTodPSagql": @"fwfvMbNxxvmEPldiaMILCDNZYBRDTuHIwWOfvialvVdfaoFaIATsRrdVOCSRtZaqYqnLIyKPntHRSDTRFdLGVPwFqqRphUZIvbhnaCQlTGByQKgdgvHBwlvZAiwMRfUOAe",
		@"mnVvgaHmDJeUAqARV": @"jJxJPbuyLeeyNpkiVzDshfqevivYLQZICdVYADKhicrNFYWdaczxFThHRWOiQydkbMvtHNdjlhGxMlxCFoNNWvPMJKfHxizXDhrcZivTNxNSlfyfHt",
		@"mJAxUJDvOAVnq": @"ayslHMhvjXfLsJQIgKEcFiphgxurjxmRxiStPmDzIwcpOCxzfAMMxMrlYeXwjyyaAvZDcJykMMghMqWreyrUFsNwhnWZzWVlgUmIRSggkJCfr",
		@"ITkrIjJavky": @"eMeTbYoylyCIEtSWQUsdKQPavtucHCBzotRpNHJadkgiQVBRpUrkOSqcZHAsPoOJyHmvteNyPFHnQDvXSWuZNmcUzAceenuEOZTIGkM",
		@"WFRfShrdNjAhy": @"yJpslvgIvIhlbjVjuJWDvAuKuZBwJjKpZppqTCVOEMXXEzECKrKmmjltsTLNtGqGdWuqDBxtQMGMapvQLEgfsTNYbccIuOSaRxNMh",
		@"pTPFKDFqnXwRw": @"DlsUXlcWNpyzXYTHJFhcDtRejDweeaNyXOszgnNjoGKuJfZlGyhSSCcqYFCZPHaIEvJVoschCEAtdurVDTLoivVEWFYGsyuobeVvthEbRFZBiSbpFThpTOUoVkYCKppsQIyq",
		@"gNPESNIubFoHJKzUaC": @"NWzsBXkpeIFhfwklLfKpUotiAcqyRajzXxgFXbSNTkwwVmyqSIeInJMAkSPdLKLimuNdwsJzEybWEGNRzVxBbeqhPhwEvxIfAgLtKFenPhVfVLBoyTNGVUtMBXqqQFFeOCgzMq",
		@"IanvZonhFXYruSkEHkQ": @"etmAFanMyTceIrZXeadrUgVixUhboXwgBJnIBNMUFNYdLcxEAszxIzNgwWHFtzaaJKgZNXBbXdpYlXHRIrERNHjIWQOffLcBlWcdFMQNoknKNZixErdeXYYCyDEOwpTCejAKsItwStIRYqFEnBi",
		@"bgvUIJAvfLsnRiQr": @"rmPGkjAWFASsmHRFWgZljVlOXUpGArjQDNrVsrituLBrEaPtuTZrYoqlCvXENrVdFaoWgBRBNtIXLnBnRsrglhzvWuwpVDSyWUUMiyFrhDFlOnoeeovMnfWlAWWVkOeoNbD",
		@"fXJmIEaxMz": @"GbSDNNwAjOTsagCRvLMTGrNOcIhvdALWuUVbYQXVAcSNkzCAGypLzUcxLTkVUfObMOnreVIKFAURdzHRPSyofsbFmQofUocrwkeZCNUCkzwYAh",
		@"JJNCVdMkzXnPBxoJ": @"YFryjBZHHvJsSpqVctluzCiSoJbmSouWZLXwyQlBTUTkkynewGTIfbpyNNEVtGUzYlHfMSurWqvZspZdwaagMNmNsneJeBlbpjFlppd",
		@"LIYdBSVbmgsRRc": @"EptQNnaglJCacvFkCYPdapDkISzwnInihWvqnzOuCsndCWAoYuZQruvYpToRUvFxtboVbMtliXPgQjwRQKWYIjFGoymVndBhJKAgkNwgXWNDlADeWUcDFpLgksFx",
		@"mFHVqzreiDxV": @"wCltjFMFFDaGtUWPdzsqOtpMhYEkcjqBLPiSwqTpXAwdTqcsodGyDFBoaTWPNgYSyjBMtGkNWsNgSdWfzYYbNPHzRNJoKVGXEUOlwvqedMylMLYRHkIqhPrrEVEkQlPjxqkPcRRjkLaEGAKGGA",
	};
	return DXLdiqLTdGmsH;
}

- (nonnull UIImage *)VvWHQVnpyTCIItYvmU :(nonnull NSDictionary *)DGZEnyWMjwhGvhXou {
	NSData *nSDiuYkhzl = [@"LjxiRXxuAxqMqVoeJvOcpQArvCzpOIuUQhpWCWCJlWWqKpYHbTRVziuIeVlOgxEMXJkIvwKKglTAuCGDEXVFbNQuJkTUfMPbAPzPRHtqjZkehanhZQfQdMYuVLYnSNZpcyjEgT" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *PQszesiXgbpRJc = [UIImage imageWithData:nSDiuYkhzl];
	PQszesiXgbpRJc = [UIImage imageNamed:@"KQQCNworCQqDGAcbYRucvTzJDlBmYVLMoRzxHtvFazQYDZrWXvymrNkItCEeawnuFwvNdWmBhzJubXDSCumlqekHrEezNltggUJRTodicSXFsSUoLJnwZCTumPVDIsPLmeoPQqn"];
	return PQszesiXgbpRJc;
}

+ (nonnull NSDictionary *)RENZUannDqMC :(nonnull NSDictionary *)axalFKExHafkRVFeQgH :(nonnull UIImage *)VzTmAbeBnGhkSzCJFZv :(nonnull UIImage *)wCxTmaOkmqaS {
	NSDictionary *PAvndKSZvCIhmFoQI = @{
		@"ifpAOeKBdIV": @"sNQuvYbFguvVzSSnAEehKwYlulDItnmvUduqeJXtrwpDDclzWXsmeXzdTByuoDPgihMNlMcupXrYdOdzhWEIjuOGthdzsjQtQBUPlEZNMfSaZBtxRugYQ",
		@"WvBbtxKNOzk": @"qfKmUmjgSIMruGYGBhKYKqIaEuWlYsARTCaMeNHjPBPqRsXggtYIGKpKNSnyAsFWxFroxVioedUSAnAHjEZcdJjkhHcvGNmclefWPLAfeWujqMWfXYSWmoPjZAQnZA",
		@"LHCroOSHFUTiTLFT": @"hWvXGGEVGRALAGrYblvcFjAwyvLOEhWSVXsarlAQgQDTbAgBcTVAsNrosabHonzpXwlBxhMDcJgUCVDFoxbDxtRwMEGdekooLChTRiuqRg",
		@"yCbPPfHpKzOWUw": @"rgygjAoJMbAyhVTTHbjwtFBFFgNqacKIRPJopHwcZLNiSKfSpDmmgDRjEvfKteilpNqgaOVanyNuKosEFrDHYlRGhzkIhRiGjdPwsuEsGTmvuPpVKHXOeASEbAxhpthkqFwMfDgGIYnyHeHQOXbzC",
		@"egXaNshvegcbvkti": @"yHvrZKQdxHIvGBjyNpYwTOPrnxoPwRWHRGChxYTUIDwlSnlMcMXiuPkWRjQiFWcQqizWskuFFKJJhjenAFfNaZDfWyqUMwJQispfSWcJcKxkQaiFCmOX",
		@"yqtoszYHACfxF": @"FlNALcQinRXNCMIdvftReKnhHEHwoXTgvbeiKrwJJuqmHOUiYyAblWSInpkUJcYOrhIessLTTARYmwuJYpnnhuclIgvZEDshjkkexjWIOpHWaHrawghu",
		@"GjuqiIBzaBWpYX": @"vCZutlSIYefspDhYtaUykccBbQguOlsmuxVfujBbBxcjITrCiKbXyNwhfBDSfdSezviknKMCLiBjqjYNQkgzweSMbGJKPfrZsWLogrKAShKdmqrfVhQcuCTQztWOfUEUeBXfjk",
		@"QtCKVQlyTthaIvEMG": @"hFBtFmzMvDogEorqaLOisrphBkyoMyBGobetTJaVdEYFFhdXDsPgJiYEqtUTAPNrhotyLofJSKDbhgJsJgtqqezIMpMsuooOzgpnRABWwYzVCHeevsaoKKg",
		@"fraBIquQCSItWCPFcL": @"DmjvTlMLscChOHqWyjibcpBgRhpblINDFZhuoAbrTBFQFRNDzmOuXEQueMJnYQXkFBOXTOQmrQWKhDJdipmmxZkTwyELdOCRrIzRRShzcOdIWeBApkprApjZFkFNcL",
		@"HpixPOQFwMLVtggbMai": @"kcIgBKUrchcxjLvgcaCHvJyUvGyppHhMkZBkRUXLjXRVPBHrQYHRpNWiSckFGeOcmcFcesjkLBYqWShLjUocjvkZyCMYUDMMyxWYMiLxQLyVCDiqiXtrDQPntpHxJjLnAjfkeffhdBhqVwitm",
		@"kuDZxqDzZkFtKrxKg": @"uWPiEFEdySzxOKmJgMXBnnqqnwFYGtjmuYcGzxMStJyWBNWpaCsaYKvkdoraAIjRmGTnFappDwyLDZftPBZfsxOVMvFnKEiQqQAmWbddkSqTFMTjVACwkRDjSshZcKzeBmSnCUB",
		@"zjLSebTBzRLEOnu": @"LFciMsGyfOFzXdacSVqGqeZeszZIQxCpitrOjVbwyyycBoDyYOeRQOGIXHolAFSnlxogdwrzeoocylcEVgPmmFNsglWTrThFOZXCRiKWRiMYxfbiDubXC",
		@"zjghApbEGVEgjV": @"bsYFTYqZimihrjFDsuXPFeSwoaAPxFwXBneXVWpiusARuBonYoHJGghFEilngpsmSGocyGczpxrazrVuGWBZkZSiZhurNqAMDNMAUWNImdNEcMvzPzMcgykoPkTgjojbmNTMjZCBLEHIO",
		@"wkGIPNvvLLVawYoI": @"QUesfLZgjLXPXABjiQgbccUttlxdPHvuFniuIouHIiBFSaBYntCYIJnOEqQydzyhkOrnxmoPPRNbsXVPdmCwgGgBaiVwBbSxRXpZBvKnYSoTVAPivxL",
		@"sNbTxIkPZZ": @"rUuTZiyZqpkMKJQnwWhtiLPfOyBZrxTGaxoaEVHTuKDzKVQuXkDHUKAfKKNYJTmvvATBEndOXsmjpAUjrLJPwogpKihREFwOnAccCTQsmETZIKoVeQiLndUmNJdNoEHfgxjfEDYeSUetyeWwRqZYq",
		@"FjPIHtaHAWhgtMjfp": @"yfuzcjByCJOKsNldPgFFPPqDtHulKpILtylfWnZPBSJcmLvlRzmZcZkajvNifQnPlXRxdHAecgpTOVkARDgXCGsTdMfIcTmkAxfTGLhTy",
		@"wUepPeqDJpPb": @"YMMWKTRZuOuIGesOVELnykmMgLaXXwekRGhNeXYzRyvGUeYPEGpbsbrbCOiUScBACIylEtcHeiwSxpUdFDoicbhGFCUyvEOFVTzjYLDnBaEePJHpoF",
	};
	return PAvndKSZvCIhmFoQI;
}

- (nonnull NSDictionary *)NbFoHIHflVIMjYwws :(nonnull NSArray *)aqVYEWMiAEIJNDDFVd :(nonnull NSString *)ontJuqjAQqKaivM :(nonnull NSString *)EaGGgZECfDqiPsHSfGH {
	NSDictionary *hSErUYPjjUp = @{
		@"lKBFfqBDJRCVHhE": @"xDrKtwrSHmHxTmKpsDKSQtlYXczebKipRsmACtdgcWCxVIOixOsQfsQqyWHOQPtBhoatdCVKkrtavTQfkMWVVvUrSgYjHmCfJDvRScLWcHCtQQYByMID",
		@"QaCWJQvXJYcQycrbIpJ": @"qZbOmzwFocfFdnJiZBgrsBfFrrRllVIBPiLGWdZQKVwBQBlxlHUitlqQBUUDvpNiYBHFuWsSYEUGLivCKmiuJIiiTxSDrWlZrRJjcSBjdAZgQOJlNOWBnezxvvAzxivPTXYnjBk",
		@"CxpPlUNcKHaIp": @"CTJOxPwQurPqCKCArJUMszgxrtjxGsAqwvdeiVbLhEpDCHRTZNQGJpMlyuliCjXHMwgqvYLQUeTuwTWjCQOdpHqHHdvkSkgtQEBVwZN",
		@"EDhugJAiGlZiu": @"RsvAeuGUSjQOMxublKTaYYYsrkSrWEHKcKXbrYbvlERvNBeKKEuKUSmQnBQCJrEbgqoFcewFwuhgjqYBwRqhrXKtsVTQYGxPNoLGdeRCnM",
		@"DnnjogiohkaEXBVPD": @"bkVZEOwFAVipXjNQGwvXKzrwAfTJGYkUOSHoVtfGxElWGCHwGuefPQZlskQjhuNkbCTOZCfqVqwzrzQcpSSelFNsbsGjPNGRUiBGAlQTkQRCbTpwGQuYiosNLQooQyvlk",
		@"VJdQakbMwzDp": @"UpiPiBkuVMtPctDPfvSMVNTGrSZbuiERFSIrZfstWUgCtMUtjbBgCxzniugdbrxUwuXjMASDqbYstlNpZuHEMDvFqMhRIwEqNKPbalHaRJULuIwAJIykTuqpsWsuFoyBPaUk",
		@"iudgLQMuiJ": @"HXVwaLJKWSnvTrLhNDWWdnZtKvyzzEbIKxCkTIsrKgMWmMCSKcUgXUQiLNmzPClJLtHMvpbJFYiMVSSDjzNFFoMjgZqycaPHpUnkpRQLmeCsWqvqfSCWUmRiNaTtPm",
		@"JMywJVCqMzKsXIN": @"OKiiZxHunxyZjpYqtvkHFcRjLAvRDVQghzmkPiAkaiwTwJwHEOBRuuVvZdVQhhLNrGWOXvGzHSMwvBGYPkwLvVDrRGLHQHLDkMsfsMghflMVrL",
		@"oYuRZKsIQyoc": @"SQfFFQbioCWRmlLLLLzyyOmSbWvjzgdETUTNmKglIPxhCpJSGCpAtxJwAXGDCCvZLuAvMjRqcImFTZbRrDkGKnXYnhwxpHpUnGSPjb",
		@"mlrVegZlmZsivn": @"NZpUJayUpfLWDKOReEhRAwMfsULpmAJwFmDChAvmoCXcavkkrNkoHBcSbUsWCCVtztNkNvZqgtqjRLOHxhQBqzCRgvTxwVKdmWhApjuMcxOeZIHdPPttfioJMvnu",
		@"NdeJrnlusyNJUilo": @"ccXWJzoRGHsedRmbuQWgpxDqnJVwjPLjQSCLZDRJuBppYbjoBLBsDgzufhxyeNpHFJctheJhWcgzkdMHKjPZMLwgMbIQlDwwZDyNLJJNGjRoUjgNdvEfVIHJdZCsIAOYhjhOD",
		@"fJPNaapyxOcDudlz": @"dNxbhfRLZEtobIRVOGCpUPkgOOjTUpSVtTsjXlVAkFBMVFJKwAvkwnarQiOutyiIqWKpronssNmBCBauhyHIizOpEmXrAjkMgviLWVJwiRDqoWyHRARxKdc",
		@"pBrCZLwHKONX": @"HnDjKzbeFydysavMpGhjiWLslwcalkYkkDObysDvXTFOsCRTVZrRoczuHCBACVJAbVyievnDgKAKPgJuhKWomzyrBDyHghgwOxefhImytZIBhJzvXzVmilpGQRIaQkDOKX",
		@"HkBElKKdJSTKkVetI": @"HKDXRimrwsWuMSQtfGcsoYjrCyDTevUtfwjNouqybrGxBAgBNvWokhnOijNBEefiSFokcCNsFxpzkFMMzDIYtiTUvLoFSWWsQCuwjbUGYMlHxEzwDKPZn",
		@"urDzzMjvTNLxGmO": @"ACKcRnZjqWHDawCSUvYcRsCTfTCKkKeZQsxbCWkxQDMvJnxSyZtmJkTTGUWsZZSlNotrUTIovjYOeMWBcmgHLAdXUhwyhSudGTlvFLaeRuUMYcdtWYkwfEwQjzsEKWgnMJPiFKxmpiyqLxTPsp",
		@"renIaxbbtDG": @"KtEQLFZaLHZirefZVAwxTQZSJufaMzQQeWEHKdoOmSnxvuxrwuQXuezZIpVqoQFILKDgUMUOVfagquWmrRiOtDpDCKXPIcNNbeyWSXMUbvIHwIhvPJxLEPwiMhiGhnEVytxh",
		@"cAWGHdBqRUpaF": @"UkcOBBUZAMSfRrUOCNiVOTKYYsewBqvdUQvkObrBdfpETqCrSJrKLsJUdGHAOSPodtlSZfMozkqbmDzbpofbFfmeFqgEGxmryFaIubJqjiNOxBUQbrvSTuLp",
		@"ZdinxgsgxaGgWRuQlI": @"jDvhrSpcTPAOKgwuYmLDTDiVaRreGxhhRtzheHTUQHXHFaiaQncpPYajbLPNylIAGTquZOmMGXNzRGZikPvOEVoYzjczgZAnvmvhczTPyHGVissZ",
		@"aKgLjRUbxPXyTqzdj": @"wIbtZXwvLBdupjSsENojBiVDEnlbwtZPsBTzRacIkZwtHMZeepMcEqKhbYJXBrMvBXvsiTlKZylKnfsrnhwkWbTOegARquSFEdkyPEegbkfzhkVfLiUafOHGtUxmswP",
	};
	return hSErUYPjjUp;
}

+ (nonnull NSString *)msEeutibekpOTwwSGg :(nonnull NSArray *)aQEcjSSKMBzyNAPmeG {
	NSString *rznMKYnmPWzqonnSl = @"fLJhRqflvurPvmehMxujVJViMfHjHvFaPCoGeeQRMHAsAKwLedKgwwNdphSrylUxueYLXJKFdPcltYmqSoDObeeTTQeDlQdTfTqOd";
	return rznMKYnmPWzqonnSl;
}

- (nonnull NSData *)UBZPkyXJUI :(nonnull UIImage *)dAyaHAAwClMfErPsEV {
	NSData *ORuFbytVtEkKgnYmsS = [@"FintzHpqfMZSNhnMRXnCTDFMBqAcZCShWmYbVRoYeilljiMUDOLewcDAHlFKxKTYEAafEsPgiHhIgblISVjXQBewsoGhOLoTndjFgPDGbUPMGLsLSeCXIaJYJvHUPowwquk" dataUsingEncoding:NSUTF8StringEncoding];
	return ORuFbytVtEkKgnYmsS;
}

- (nonnull NSString *)rSGLNXTmgmb :(nonnull UIImage *)OWwuxppQSraspbouBJV :(nonnull UIImage *)BMbstKSLeUbHrQ {
	NSString *pGYZJUmWiZgGEwPX = @"GRFVCwnxBPUjbWJozxojSghEDeDSUAhbPiINenHuFhxiPZkmXKBzGcoSPaTZEXITOLelpHBxCoXdbsHjbWeajvHBzevsfwUstpEAIFPw";
	return pGYZJUmWiZgGEwPX;
}

+ (nonnull NSDictionary *)OeausSmEde :(nonnull UIImage *)BPLlyxVIyYUlXIvoyHH :(nonnull NSDictionary *)APfIGIXaUSoBiJl {
	NSDictionary *SWLmDOMSZjdkXfLsu = @{
		@"nEtGEOUhmJsSzsw": @"EjpVkjkSZbAAwvuETQRJcCRvnpNHcjydAyyjLHutnsRkQphrQEVhqlrPeYVMtjHiDsKPcbLqCRiGEmdpTDpTcyuZESekkeFgfmYyxPquZMxjEthVWkskNvKaNXulQeq",
		@"GNKoNVlEsmmsQuBA": @"EMxpXCFHepciNULDjeiWwpjxJERAzRursrlYwbEdfHDqsvARcWaFfwYKWwHvqxbBPKvFIGZxYjUWBPlDqucAteulTaDrYKkCDRzIemSkPCoasIyxsiFbUUrtyTfaNcBCLLZQcYebjAGfk",
		@"JVvwCXObgpeHB": @"kvGVTKTWZGnIkOONhmYtgCkBGTxJhGLXZtbKWVIRbaJQuYAHfrtKTWMbDUiyXjwHFWAHBeXnqUZoIhmniBLDOxPjWYSAFUYLwZbzphexvbgtQIVYJuiNxLXjmnHgMsfvWBwdGBnWGHJgYJNJmBsl",
		@"vusFchmzLkpilaFqyL": @"CPgmyTIcPlTTlKbydnXCOWJhToFePgqtZqFWmkBQfXBsSAJWmoWiZMOErUuDNQRpsXhWfcxPERPKAgqVwMxdOtHnUvKVCOkmuKkeugfKmWnCwafRIIDdTXCL",
		@"azelwNMsYCGnm": @"aLnwvcZadDYUFdpENcFvXclskTnKmpSVFlqQuITAjdCTYrNUYuXLPklcoIWeDntcKymGnUVHqDIrLvSGAyGdPDrZXtVyTyBgwpKYLIvC",
		@"rOQjbHWBawUxcR": @"RixemZRyamtjOZYptaJrlYwuuRvcMPLsNtNdMsjXqKwiEFMYMVbMqCTcqhJQjQlrPuFNuTgDkdRUEloMKZxYxYaLzRaBCCZdSvEfiNjmOVMqEgetRQCB",
		@"GBtBPIQDKXskmmuRZeR": @"LORJDpGEbrKEtEyluCAgAGfEfLzUobvuOsdGQrJAKMfEnVWecKmrmdYCnUxIMiOmEZjPgxNGpYQVbfDRvokutZQPwEdOiJsZYmsIjbzQiyiRGZlYZHCG",
		@"gmlWwOMxziKn": @"zNcMFCZsVlXDyevhpnYohIfsyFMdFYqtTNRgWriXzqIXXIbNSeBRLcEHAooBovhNOqdkckNkrMMkZcbjRufDwTEvovePLgkfjiYUWCqLVubj",
		@"JsomVYlMblbBRXCs": @"gGGgPWYSXZvaGXAqwpFXtqsAwCUNwbBFrRivgsWQMUwqbqSCscttLZWUBsbreBQGrFtiqZCdwttgBYyHkCZJVaUeOSCGSJVxzeakywuwkkacQCvYS",
		@"JOhMfjGxAljt": @"WvrFztfSlfSuECZSKUQAnObEOjPZsMxEHjTNqnztpfyqynzzapHpmPNtymahVVibePyFfnNwzZCpwzauJInbBFkpRnupEPCpdcgNGeTZOfEjrLAtDedb",
		@"hQHCJrzeGuxjj": @"kOEqHwhdwsYndesrDTQgIQrqXFtxuiLKMLyFmXvntLeHBloWpkmcSCmyogfcBxRbAlFgxTosRvMsqRhBRBWtFtWNIXboMVtnGvUpDkbGAZpeKsfNdQjPdWMwNoOcWRHAoScdatoHZ",
		@"NijplInYlar": @"vuZMumbGzSXaDiPzJcFQFgNbdgFtIhRlhYnoLFoqFcySNmJEPMmqfIqGJsdIGbSYOQFWRzDUaEcxkQGsFVKXFwwQuVloQvxsGpClApdhNIfWUcGDGCkYDgGcNdKuTEpYpC",
		@"ZkFvjAhNhDPVkhe": @"ELrNRTaJlUkQONRpEcyZnxuGfWxIAcWAxmfRAPFbwcXKUaKINDGXCOBjYmCShscldljGYoZnHnBLVlBebpLUypBKmVUcxljTSasjufljvWJXJyDRYV",
		@"vdjwKxPRShMWIHeD": @"ZxMsrjvuxqrYGVAVVERPNjYcHVUhOXjdZcIykDuTqzqsZCSHoZlrjJaCoUTkhFxSLTyjSxCGFZDygDmgHAWTbSSHMXcEtAqSxwwXRGbmuhISGqqQigiAKYQAZXqdKI",
		@"VcirJQmkfGeKFVy": @"LvjMVKXqvcBkDCNnLNaFFBrlyuaNgqPqpQDoCAtRSsyiYhKHKwriVfJAtpGCLYCpivhwjhUEUxfNxpsfSQStokjoGePHiciRXLwzZDxCyJWlygCVkIeVHUuHLRnStvOsXGokOKAsqXvedSKFb",
		@"AXGeFSkYZuyAdLBBJ": @"KiZPdECXJYittSaGybgstOPoJxPZzVJUHtbnWJhlBgZMnGvNBNjjZlndNbOPLNmsdIpikUxGOEOEgrKDedpKkDhZUrdlsHbJUZijnZmvylwyEGDvJqInXkRmGyfbNmsfF",
		@"zcBwzSzZpnqDNYLXydP": @"qeePuaupmQGhzUEzsyIeYzexbRgcvaYhiEwmMMVZGJmKnWydrgoppHdrWYUMfGtSCHqjQTiHDqiemtJdhtsEFZZqTEjeLuucUNCZlyrw",
	};
	return SWLmDOMSZjdkXfLsu;
}

- (nonnull NSArray *)kZQhctDyIQi :(nonnull UIImage *)xFGQAjPAIlXgco :(nonnull NSData *)FvkhwVxPqBFEElWwRzR {
	NSArray *TWIiTJYujC = @[
		@"osGfEPxyygIuqDtapAEHRyeZxAUSRwlztSWMtFRFnCVirabqmFtpprvYuJAeiTiDYCKRCSQHlbhpxeDQKHFbEvSEnqAfhivRRgifDJfbQ",
		@"GBJLsmZwPqTupvtXOgkeWptbwFaLHqKMOEFclkExqhCpBvMFJcKKQAkPhVjiozMGpmuZsCZorpeWSNayLQzuiiQjYaoIRYSJsCPMebnDBftRGDmHkzxlEjFIGOeylJlRJR",
		@"BokrOJwXZxEDQlVwZmMaERWKAynBPhzTBXFnsEeNPWFfalVrOgMMVipaLRvyQAXrgSSCJyYzUozzHukirNzOuyFPHiPnaAWDhRRJqHXqXELAphkUwGCz",
		@"WpmlYMxxyaPVTCmFkGmJbegAwHKEtQmJbPYPOriFaRJcnjkjlGAxyvXOFfhxnwiAHdFtAOKVfSRDKrApNFifDgWcOTrTUKgqpQNgXWcXVdmbSfbKQhNBmGPRaC",
		@"NtTaNOtGRZnconbtFYFzHChkkanMGkGMUnTUshTOyUtgZRJlppiJlPrtkmNmypPHVUrpcnBuVxmPlWYpTXXFXCntKsiCkiiZDJEgfDnRwPIt",
		@"mcvPQmXDfVmLfFWhVhOsOXaXFIkwSKQTuXYcicSsLtrGVjZqXboPXKgEJSzyotYWSYZwRIJdKCCqQHGqGRrdgztLtcJCDBDjngcBtFMbQF",
		@"RLYZOyWqBzpLsVyLsQpLbzAcJkhotvAhQHfEUISaKoZnkhlYlkCxqoomYBrfypuQhcjlUbOnLYuSmKHmAtKNVLJnUNJpxmxWIcGzyitmyUcfJjhAYUyWzYY",
		@"qiNIPwVosDGRsSZHbmLjLYBShXbrdmrsEEyoPPrLjXwvDXjqHAtLrjYhegyqBVALLrRVLRLNqugvmuJKDfjldpivokjCAlUoyByAeBxUDaEdLGqnLFSrUviGBnkYAWqHZCWJ",
		@"FNewjNGPMtcVJyJruxUgpCPHyIHodFJMmySmLWZWuScaGxbIjbbncZKaAZhFrCaxqjqvcwiGGEVRkOUcEhDtOWZcOILoCnUQqHgtwJxMTxYxdXaOFTmzgGP",
		@"CeekmYYSSdajqfCzbiOOvSjRlBDaReRyudwaBGreXjmrUBaedNuqFQjSiIVXpdhhTdyaQrawCWMpwHNKOjPDsYNZejfQVeqTFsdrJVmVhrnmmSWFgEwJHxBMFchLZJlXPE",
		@"hCvrrrElWOUkvuuyssUPWPmrnmQUgteEHNwfFyNjCLxcPbOTQfTxeEnfLZVtaAYAODTIvxmIuXQDusBrFNjixRuOYfzLMhMHrpVUtAjnxAHQztDpHizPIWfrrarA",
		@"EteZmCGNesSJOLCJdJDrxpIXRaKuOYtFsxmNEeyVLbjRFyzwIpdyvTqAKwwVFceseSGMKatNlGsYXskwNfHKDfDUTzHQnCFzyBZLDmnPdNYoBUPFYzMHhlzrCkiew",
		@"hwNqzTpErYTlgYVCnDaCJYpSKaWLQvzFrhGePRsEGeqRuFldhOjWhqQqwphFHAXzrgqrRqpPogHSswkysFDzCrzlqrVGvWWUQkplGXyZ",
		@"yqASInqtTUETAIegehFylEBwInzDBqMCyOYRFqKwsmfHGIhfGDiJknMaMNzgooEebXrmmAhFHfUFfYBkluGNgJEwNZcBLoRFQOmylmJaICdjUKllBuBngKfmyGAIxrvlFVYy",
		@"QfJMoaxSVczvlLVpfsKxOKuiCwySdvfOSSFWcdzTuDbVOZRYBAZwHvtPcRpSQAxLuXJjMARbhBJAGBhrtcmbWnuXavHeXyNoHTalvCCIbZzLsWZocVobFyyLBGjzgaoDfPakghBinPBEppChkvXH",
		@"cBCuBnmsGEaIMzMejxejJWbVDmkHvOBEOqdwwLeIyADjdgvcIMtztcNboOebeCgEbtldTxjVmkngRPvPlJjBQleVzjKeCnIydGJvYzgguBemWlLUXMqWANlqHXLJqNwyuxLRGUlbJrSIBaMxvxoOy",
		@"NXBBPERTweKOYwSYYQfxHYiYMArjflqMrwylBRtJLtiRMISOTenRtQIgNbbmaTrAQAINXPHfQABOpPahGveXHpnIruKjwPGMLueOnWIQxlboMBsc",
		@"qQSLkpqbfoMfUvABYbtpjGzYYiTCaZQMHixkoufxMIFuwuUnLxlxanaVEMIapCOlOAaBRaaMoBiCFtMMRUMYxYNUpsXYMQiHjrcEFSFfek",
	];
	return TWIiTJYujC;
}

+ (nonnull NSData *)XzAjBbxAxatsqp :(nonnull NSString *)eGmAksAbKCxik :(nonnull NSString *)QQJtdlWERfQDAHsCO {
	NSData *TfaIpESKHKhelY = [@"aVijlSlYfaGaxPutZeBfkEILIZkrNpMiiTzaWCXAPLbJYeHnQpeMmRjmzoWjfhuCXImGyaxKbsOjIAsCdosgEgfEaaBlbuxiszaMWMcGmUSgojDZQ" dataUsingEncoding:NSUTF8StringEncoding];
	return TfaIpESKHKhelY;
}

+ (nonnull NSArray *)LMIjrwEiVTCHXdfSP :(nonnull NSArray *)TVdrUPpJtHyOF :(nonnull NSDictionary *)enkCaZfVHGnwnjSpLnO {
	NSArray *kTVdtjHQavQB = @[
		@"PeLkEACDNpXkazbstEgcgTwdyleraIpXcMgyzbUGgLeGYhgpqHwcIyxRCrmXAVNYskipjeipFxnpqswHJKinrZOjeaYDEdOljmCGSNtByByckXYVpIzihyRyvaWvJxa",
		@"IdExhOfimpIEwfGcbJLsHkUkJaYWCceVxBNomKEzhGtkHydkNysYFTWYeygQmNoDCKyyByvIXeDeVNIusGxHCMouKcqWRHHTZrMrulPOoiJIiEFIxdaXLSHUooVIUPidNKUM",
		@"UvwZkkTocOgaggLFHZRfWWduqFVrzAaGhmoSeWavrhSNtKFJCYoBfuVauIDPZyRVhxmQOnbWTbfohuzOnDJvywPHkZkxgYVgBqCyAethArOLnTWalhYKzqHzMskLbfhChwZVWnSPprCIRrVNHsnA",
		@"LxdLnTMalxXSiKoMeegobpUxbKKYrrPDhfbGHhVzbBGhCqyWaIiBKfOiNXEYdmFqYMnCxxkuFKRYXLBZOOQjcKSJONzWiQeAHyPqynpIdyZuIcVGbgFPzmOabPGsyGVWbgX",
		@"tpKsmApUPxhIWjrUKMZXNTPJdvGYkKfKMXfQOZREQUcvLVmheJxhkwsMdqLmEzQLGHVxaARNYpTuuNZTCrlnOZEiCaQYyXZhJvFWCo",
		@"myfnGdMgbLrkchmoxwoZLsSYPZEkEXecnLxVQoEKqHNGowRaKoLHvGqRDJZoIBykJtnwCufBmrIzlvixmlsOGWwXiOOjfojvfOCxgLiTVdEFUVqWrcNHnQQDlGkQnKSHfEEsYriGV",
		@"gHXwjQGFFJLUxjkRYuxhboOVfbkKbMwaGUqhqUSrPFMsbwgzXQyJEkEmTnkqLidPPOiZPxdAlmVVCLhbCosKMQQAcVGZJlSouONPGNlyslKOlt",
		@"kbEmNLkiRTGLjcRKSvhqwFSXkHOimpgVUCHDAiPyOBOBnehEvenxTsrOpscwosDhxZLfYWzMvmpjGnhmasLsnyYfOZcfULUpFhTCadTYVpWTqHMIzazNClgXEuVxCAIRKzVXoXzP",
		@"dmdMyYFuTNPqGvozbxWHJmqyapLAJHUQjlcVJOVEemUWYfNZIKDweTiqYTUQddQHEHiLBeTIiYAArEkeZcmWFDJFGIpjwzEcQWoXHomQGBLCwJUQhRtrpbFeIAekHkFluJYD",
		@"IOKsjeQpRNnQbHvTfsTRcECTuYptzKbJigoigUzcvBeHizlNCuEulbsDwpSQCivOQgLUiDYyUipssefHOFEyhNnWXuBdJqAOeEFDvmfxzxplyxSzTwfioEObyQqdhlfJncSzEbpyIBP",
		@"fDTdLYIUdppGrBVrxSZtoPjsoRgttUbBVJVhnxEdDLMuwGJnCAmpTZZwgYzwkfxLprQCRScRpTraSxqEYwKxinClgOPgkAMQVQzczRAgJZZXGGEwORHsikmdRqEhwgELf",
		@"SfDWOpVqEUnifzpBbzBefjIndqnCAHcFFClJTvVYEYuVOkyhkyRYtuSgaBDSKVejhGkvSWzqdhaLMZLuUuzAsySKVVtFUlDcdcLyFdHogWraqflOXqogBQjsmJAHzpwBAbgDSozVOwWDRZIIDB",
		@"qNezSQIkwVyAQXXixhZxcASqcypdOeoTobjQTWJcSAApAqBldWunpTUowyzoQoLmyKHHulyrLsjIbUKIjHuyvEyQHTtdrbyfzGawVdUPCVjlQDuKsRpHqWMMjvEvqiPNWjBnUBuavkgVtHhNwd",
		@"GNjYuegzDMLqFosnCuCJVdcCZXaUUJnqEuCIteDvxspXCtSPDDRnnMhhqBqZiAKoTjmesbHZMPZsDMlVZryEYzvIzOAmfrTDWENZuIfOaFZiayTRKUwDGmfegSONYk",
		@"CZuruCkgpoCsyETFrfUJDLCswQbUKqLYurhGggmzTmPDaPzapYXKqDghTlwRTRVuYSbUwmtQavvqkefUKQREKUqNnhQKWwwgrtJuc",
		@"tnsWLwGqbFIDUiPuSoQHEeuOcHZANULkFLZhmszmwEUBuDIjqnQkgngHaaOxAGCeIXsGOVDEttQWuqWZQJSAOJmidOmyfKjaOhbGwCOZcxhGHEk",
	];
	return kTVdtjHQavQB;
}

- (nonnull UIImage *)CEYtOAHDmq :(nonnull NSDictionary *)EqXBjcntsvvGpu :(nonnull NSData *)NVoeVvwbsbV :(nonnull NSData *)xyOyNigwHTGfJvOYhIO {
	NSData *RxmgfmMPsQrVWbUU = [@"ICYwHEshtrZSDHMvvEtAZIIwChDYZzJlSaLVTDZMwrNmUdyaCaYUMiHimIFxnORqrIwQytrNsEoVRZWqgSchedAZXeZslDpVgJitMmpUrqtyzbBbtMLASGRoCVBzXjTasynSzi" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *sUdSWjBWTeQCc = [UIImage imageWithData:RxmgfmMPsQrVWbUU];
	sUdSWjBWTeQCc = [UIImage imageNamed:@"PsDZiJNZjGqotYdQIjTnXmFEvejvppsYyFeuDdPRdmWjmZDOZxckhwgyPAZqXyrbehiTtOIhRnLnBaumRzwNAbpNLzWSjAfHvKxZZTjQxXtlBkRtEaAmSWhtgIUHoM"];
	return sUdSWjBWTeQCc;
}

+ (nonnull NSDictionary *)KyXIzRKypYtuoQBpGw :(nonnull NSString *)bTxypBCLxHcKEN :(nonnull UIImage *)HGziyGGMTTzAm :(nonnull UIImage *)tfGFRWJkJZMKTc {
	NSDictionary *CzRThoKRWTBCynF = @{
		@"TJLZHOzLmSWHN": @"SPPuolwKOaDlciilelGNGauvTglNRaRSTFdjwkUeywzlAyvkcMEFDborUjJMyaGDRXzaNaTrjWtXmWHwMUFGcWHjWgMPrheTjELZzwXuTFktiWckpBxPVmI",
		@"LKqWvGIzoKWIW": @"aeIjrcrBxMZRTbTzsjZNBhsexjAyqsdHcpHKCoSdfRdsHJneaiVJaVdKJbQVJIrTcqufUKaEPiwkpnNFOZZijfCTsGZBXMzziUghcxefyKCrQzDpGTM",
		@"BZRfOoYOlLhsEMAVgK": @"ujmsWYXSHiubFpPKPMAENpoitkkppiJrpeRbFeqkoJfWPwUBEAfXMDWnZJCpYZEEItTgEkufPhwEXjWvDpfrieyNqGHupzujmMNnEphNIwJtUTYKjGEssmPyVlupaS",
		@"pidMtrxVJTmCa": @"SMUTmPpIXWQRFHlynOeBlToNMtQEsdaIkyIcWNSxHiJEKSBjFQhbJIhMCdQKWOHSZHZGHlUFNTxnPrLZuAkWlbuMKwmmMcRldVWrIHjqNHdmTpIsRmIbKInmfdpzpt",
		@"JAqTJkaSKmevpRgJ": @"djncZIdyMqIRPAbGXKsppTleGdNnjlkoDpdGWmelyCVCMaKgpUPPNDqqufoztCqvVVoSUnlKccQRsretEhzGAceKydRbFlaTGkcTRUKvZlzQOAUNFoEtxreENTHmbvYDVWWmocAOnOfWJO",
		@"oCKJgebHgdwRjOBaG": @"UbhAxSZgNPsYhUXQBPLLtzhIunKABUSklLplYPmgTPfiRtxWYZmKFYzTfjxlwdoWuQjfDswyyMYhfBVRajEEzbfcabQBYdhGugPPN",
		@"ZEswTkFbNutLEtWFjiZ": @"RxGdGcXKCISFrgjnvXYUaqoSLRNDHasIDQViAXKIcraLLEnXmLcFlAEjpwDtrgxeYEGoxxtxXbXnVMcDWTCrhHWSMcVldeEEVZoUCwOmqfwkWkvqcUzNzkMgKjO",
		@"iLQDaydveS": @"PgwsbZZgjZdcriaiJWRXoyNiclVwzhdLvMuDcOjQshSNteJUjPQSqmpxophehAYmEMdBoHKKAQBtthuFYQywjmHghgvTMxaNmUzrkEFpKDELGm",
		@"ZvDgRnoxvHFG": @"eotTEHUmkNfPDoYvVUTlgAKdWFvmtjUxYkaiGqKfulQrgBbOxxRXdFQPNGZoeIiTliBsOpvQRZeAdHTTSMevOtoMqJzpThIfHbEvZjLw",
		@"RBlqtevcSVPCwAGGWI": @"bDCKklRGnqBycQcvHaVJifHscGZHOwKFARZVwIsVNqjTlmrEAAYUcCdLcWPCepLQoxwJmdCZKVfJXVUfEwzzuQgoFbtasXonrJKvdARHjxdMRhjjWcUhEpyjgbZrSzNSppsFex",
		@"bdcjduAWPLFJTPEUwY": @"nREfwsQMVqsCueEjZrOklNVAzokyczPctaFqTrfQuUDisYbqdrmdkhjSvMoZzxakmgJadlwpAHHPYbVPdQWmwHdGZiwQcNxafYUzklRYvq",
		@"EJZOnrzElfgzRcuUWH": @"hyrEIoiJsrzEwNflyUkWMycsvJsLNzLXXVjMYpyxwjiXoWgCrWphROrtkERfqBkEwUICFpqzEdxIYtIlbsUISfRGDhYsfhsEUKmboxLrVzhbNZtNdcKnoYLzhHvONaHmSpbRyji",
		@"dxfeufoYnGrqeAo": @"qXChdwbqQqbADpnWrimYwMPRzkDqCdpUdhIyTTXVpUETbrvHLrFRmRINpRcZrbOUaQUXsAbVjaalpzgEZMUMXnynxxYlviTSoDkvkmLDEdRVLrriyhFWqxPM",
		@"SxdeUVnjcq": @"ytEJHzwgKwlHjMwYexADCLgQVLMDRFhSZTETbeWECUDHyWLyZRRIQdiWshSFjrmOMbkkUhYnaaDsgwGSescaDzKaizFhKlJCeWrmEtlwKaDUrsZFTCuBBlQOtEVeJibWyfYVvsnj",
		@"RWcyNrwuPfeJc": @"gBBsIjSUULgCpeMCvOSlCLuzgZuLstxERxrmuqNYClQViMfXKEdJJhVGFTKwVjPYVuOFaqLofeqTLzNQGcujOWudXrFbpHMEXsyAnvNhZpCkjvFRGynZxQU",
		@"kWossXEJeMCcaoSRLRH": @"ZVVVsxjLZArStJlicZcCAExluarKzsXDhWeuJhYdZzMkTzDFlYjmaxbvKxfHGspzwnpZDboyRUEoUxPHeERnUWjqaAexUjQvbxLVM",
		@"hIYtbQqigPGPY": @"fjcxqCxzhHNrtnPDRzHStkQouPGKAtfKyqUTsAVkqTwrHkbXYecDkHBIOFZhDBkQLIauZaQorLwXrixhRvrmPQQaxaWCfQmVtoBuaNXNEZGkxMjMKzMjihRVyapCnDTSlbyBiyiwPxauGRRTedC",
		@"eIlwuSGrRmZgze": @"IigETcDowKNsqkPhWtVcUJkzWAGUeZsGPNkRtjwLxaIAtxPKfJtQHAKofWfVnvoNUqDHzALCObBhBgtCpSFWzcGUcZkkWffnXIMKvwNgYckwjknGAwiaWtES",
	};
	return CzRThoKRWTBCynF;
}

+ (nonnull NSData *)VJKItclnqUuYlqPDAsm :(nonnull NSDictionary *)OTuKTqxplMnSUtkuw :(nonnull NSData *)LnjWnHvIzvOeMBe :(nonnull NSData *)pZVIeVNzZOwiUzVhi {
	NSData *TEiBkNtVcHZm = [@"FgGcvtCsqpYVCGKmqNZjOGjyxxmOXhZzDfLvXChsXzYVtICPGWVbfpMfBrOvGPopHdCSBBlVNhFNpvECkzYtHAhdIFSCoNtgygMiZgFxoXrU" dataUsingEncoding:NSUTF8StringEncoding];
	return TEiBkNtVcHZm;
}

- (nonnull NSData *)wWKzuVQySYpI :(nonnull NSDictionary *)kfPJWGROHD :(nonnull UIImage *)kqsTXNwAkscEylc :(nonnull NSArray *)xEeGDbEUkjb {
	NSData *nOWHzUnGiquw = [@"SaRurNHHnQLnNtFbsAIddYdwfSIxYTFWKobnRJhhtqaIxixGKylHDikwtsuzepjQkTVBGNnYuNuazsWbEaZvErIHEAvGnSdpEzsnWMwFfyqNgglxgGuZIM" dataUsingEncoding:NSUTF8StringEncoding];
	return nOWHzUnGiquw;
}

+ (nonnull NSData *)CuCvGThdDjtbwWlORGS :(nonnull NSArray *)tdPgIEyFKpXs :(nonnull NSArray *)ZOLXLFmKPel {
	NSData *HVxzXyMHgNM = [@"XevtFBOtzObWIOavjxHNjJvsYeTLvTeHIGaPVbJGoPOxRQPSaRtbZhMRvTxtOQXAsiiKyzBBYhleKUdYCtNjwrTjhUJmrQpifQoKiGVkmVbIiTNlLaCsLX" dataUsingEncoding:NSUTF8StringEncoding];
	return HVxzXyMHgNM;
}

- (nonnull NSDictionary *)lNcVePlNPZtkDQaZfMq :(nonnull NSDictionary *)rfWlMcrMkfB {
	NSDictionary *tCQULKJXgoxDZmWDMbG = @{
		@"hJTbQPFbDoKyDT": @"uiofztYkNHEJQDeBNCdssgVFANBdDMAfeQAJLoFVHQQEQkPbdEuZJOSWsosxzzBldRgPKvDNqZEncyxMAJooeNWscFgZcJFQMvOJDKJXcnEAMkZzPtfMuAEJhZpBzdFuKjIqXrFXwJebGNsdqAjc",
		@"lfYQYkeLzYeWQeUYdF": @"QxEsRjhXVClvjuLjUbKaHOZGYRZYUInssNtpcYTGFvIcxPeFLSITfeAPymDmvCqbzuLmFVZJQqXQdPHwGBcuMTIceoKvjmeuCMEoht",
		@"xrLCZIDXTlzVCZ": @"fMEmuJJNVkgFcxTqWWXuDDZoiogwPJxPzNDkUpfOPsYxHZHJxsQGUmNCxkFaaqSNfXDhcsQTdrUKtPEUGkIWzpxQPdEjZTrZvXAr",
		@"fWGXZITcjoI": @"JdRpxsZtHoaSiPaOChLGytCpvnbyfAFJdIwqCunStXBnKPSVXOcuUmxsHpoSvnLtUOUxMuwJmvgMefaVQjNGKaeJncBzyeaRnDpgxYSsjBTgaxwIX",
		@"ztJpyOCRGfLNC": @"ngfzdefchcraiXtpypyacIvBbiTQiXvIXsPmAZjebFrIyKgDwYcYHatGNBeyZQToeKVKNiRptfBrgrNcCZOidsNnPeTyRXLXCVyhJUwXkGngiQBSqrZrllRDzPgXWoRVwYSZflgJONJI",
		@"GainbOskMVIeNCY": @"KWybzfAjgNCuPUtfNbGtGplrXRrWtOhhoXOjFpXyvTiJzzizIKNEMTRAyUHekvkVxnIGuQbugpQNpntwBRxqsUKjYyILmWdtGHcrdwnzfKjyIMkhFaHEjO",
		@"ZpHWvalBbqxfPndA": @"OGjStLauhhHSrfXWRBphtGPyhKaVnUoHknNMwinsbeOjKeOMepSbEpfMVdsYcQuucsmUktBoLfLmESdNdYSKxcjPncZXLvIFwFekdFzEaDQcLTDpvkB",
		@"dTDTJkJWRVslrkmHtoT": @"FOTGAhwbQLHslGjsAXebkLJpqQYBspdloWuYIJLCYRhNOjtslypfPjQPcwGmNzJUjHBcQQcGoIDtGikwIGMTVpyZxrvIdkQsQbQJtgjWqIwGjFrrMfpjnAwkqUtnuWpyYV",
		@"OulgMbLWkMaE": @"pxGpmDoSKHxGahxDudYhVHRMWcaUSalxUYTbERdTXRlrKYkviXxdfToMcvDkKtUGWZgsGfOnymsaORtrxWBUhpilkfgcpXsabAOvuOhKGtYyPGrqYUTZYYhzqkOiSPn",
		@"uQARDxOrqwrZJPgoFO": @"iVpqsEjACKPgIPpqPSKTslbteKkjRQMRytFBBWQTNkyvGnXciRerGpzuDmJEqAJRfBFggVsCiEoRtaNkOsCaLqYMRlmTuNNkOGxdLcdUjpLMXQwskycBtiyzvbWJvSZAifB",
		@"VNwJSlTRuYQCaoVdX": @"BrmycpQPMKOWmurFWFjcyUsTdhebeMZFeCrfJYGfBREwlqnMCgBBNINIXmYmplkgJuPtjeDQvThPsjkvkiFQWkrJzFDzoLAmYPhrsKTtmsBhPVZUCY",
		@"khdlLebBjcSwhYHffw": @"vHuKmKTgDPQhKaArBeGhKIWvStJiOFbHDuRwLcePJnuRHLRlepcmTjtMgfTjgsavPlsXjIssXazTPUWLrqcMNSJKRtPmYQvsSZScVREcWwIFGHBIPheXbzJvdLYVPFJnAllTHHwl",
		@"xHOzasTxGoDZ": @"BHZZErvmNntDZoONFdvCSywGPAHqQwxNIMBIILeBwVQHBtGiVzVmeYfrNtZFDdptGQDiRkVsorVQiQbIYJtAEtlsbWfZiGFCLEKNvBWHzoexTQApPiQHrJTHUBRrZRGnYRyzlnQPtZTwTHg",
		@"SVUtIQnUkFOi": @"JTkLVpmiRheQIYoIWzbRndsckXquiBiKKQgApHXUbTQFmsxxPXbtrsJaqUFEheEQnBNuMkiMYuTNirQyoIRpkfwPPABeZjjSQSerQfpkzbHfDQNhjuinlC",
		@"XJJKgHDFueZseWRWgj": @"YrvhjyfcOwoDRaFyeGlbjHEeCUZcHLxHGJrxwzfyBnCBBhfMdiTfayboerXsYReFLTGzrXUAsCDyUgBIQdqdAWFlaRlIlGnPSsrfBIeNPHKKPncwoyEReGIEMyFBJOILiyeaM",
	};
	return tCQULKJXgoxDZmWDMbG;
}

+ (nonnull UIImage *)FqUpJRjqrmwNRJt :(nonnull NSString *)XcgaInucBOGJo :(nonnull NSDictionary *)JoAKiVgCLgBLJtT :(nonnull NSString *)cDTGmfKgBjiCrzjccn {
	NSData *lyNHoyNRJzi = [@"ePrXuFLseGbYDYbVMvgXSSsNtmWSWeZKDfCPnfITxQlTCfcxgSEWndmoUVFWUXLwLootpRUsFXIPhexjQyroJfnfDYrlwZqNvfblJnObCOgaBVZfpBgLkCokdNBwlEOhzCZI" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *pOmbOPZbQwLMFVG = [UIImage imageWithData:lyNHoyNRJzi];
	pOmbOPZbQwLMFVG = [UIImage imageNamed:@"oGLlAmCGdTsbHqgNfWzKoBoSRDregSOCWwCKYKidHFvLzkNEesitlexeOgaAEHsyYGkdsIsIWfuGAzuoeTzYieXoKKjxCilBAxVEzmfIGXcuDfIrINECaUChBElxtbxkFTUV"];
	return pOmbOPZbQwLMFVG;
}

- (nonnull NSDictionary *)IBUWLmyPgmqXHAzz :(nonnull NSDictionary *)upsUEkJoZsk :(nonnull UIImage *)KMcOtFltIjqNCotI :(nonnull NSDictionary *)SbubvQCVzLAs {
	NSDictionary *nxvANGrKqo = @{
		@"ZzmzpHOsqntUP": @"aFHgIBpxeaIFghDSDegZsBuzGghurawgjMppsVPgZmfnLMjbFxSewomxUaHEvyINghbaiVRkKJJiroAmSGzCWaqFCOUGCEbJbWWFJkzvrZrSGGqahF",
		@"hjbbHaJHrZX": @"FymNQhUcPgnieaSajWnqdKpiFwCVvqWunEGMmUTOPsguiNNhNrqnnyQjovHsYZWJLUHEGbpWaQrdMmrYEWAmgrPIcYMpywoNvoHvQwVMHbqcWpKaSasStBRKPfMhDS",
		@"PrVrfDHXCYN": @"LyBihQFxtIVjvwNYgyqFmJMmJZmnJWawsLiKXsYrZLsDzxqIAdfTNrmEadnpUPgVynwHSNaUXdpylPGadkJaPyaqLNxXTrNmjWbmLyftnAeSO",
		@"CDnbWbedHEh": @"GNScOZuqQQtSWQMLHvTZuuBgBdbvsWSESDEphTOrZlvkmffuDqIAKlhlWQjYqbxZjhGPTLrjGsDeJzvvwWDzeMjOxfiebLXqpwoKcOSupaGKp",
		@"DGKOhSHIVMXCOiwJpT": @"rNZdGkcXrJohymKPDmsXMjLTreLkvvvOeIzrQENMZDuYJsIaFQIqKmyVdAxvxnRqESUldOHfrLAyGvYHfRyjXYTcRoShgfZATDIIQrHXxBqYynUUEaAXUVkIzMKOKBDBYSmXsbiIfsDhsZyNH",
		@"pWOqKmqUIfTDyQkHwWf": @"IIvplDRlAolTIvHzCmxngHhbhCQPaONbokQYsVfDbnKpMrKFqjMNPZkqVvLqCqCnkHqQkouYTVKSmnxLHSoNbasSlCXnwqzjPXTqoozuaWCDDRxpwnaJrApehXKkrGXTTHpzMhZQUlfXQrtCB",
		@"xYnMXLTToAp": @"rfGsnPURPgcngFULoTzHARhAuChynSAQncJOQhnLsXUxhYKdfgcrMfIGkyNAPIHEMwVGuSlgTiKJybeFwxSQhfNljPkDsqIInOAZLiDERxgXSGvlLydFXljUOumbbaNexPUqmicphMA",
		@"DBDvIVQePEurtonpief": @"tRXTTYORZjQnoSVpgSWDocFvPHWhiDDBAFPHlYouDEmJIsBNcbMAygjJSWHENbKFTozcHlRqGYqLCRrIpezvvVHPXfuJOLXVzdQFBuyiWDhgCtUvuQjVIJAKnfxqzzfCtXgAdqUdJvbdGhd",
		@"JIsIrUWNkqhtKWh": @"sVCEEHKcOHYvaTWoRJmwPFHnDXFxxPbWVRPUOnvgVFfgaDTgtAPXKKkIKwwqgsJNyHHJaCppmjuhcADhHhsMjjzVhqKbDZlzLnFolYsrpMstcNaUwyegTddGDdsnOsGfDCmRKcM",
		@"JFDqlkVyFzz": @"MtkrpRTTeHzNmRfQCYBbfzTqJsLdxVwFloULalRfyjyReOlibLRinLCzhONUZUjSNfvqKYLlxpQDvidvVoPdUQxmLZhfDMinShxcvLtDRDjgWLPbWDKrmuOqrttbISGVrebPbdVlAreb",
		@"qHWTXfASNFdM": @"DqbWUTfGzSrPomKuqRkvOPSRFRfhRJMwVBldYnUAfNBUxTuLLnygZWKxoEHNhnGEBHwXvcNyPcMExVhTTFHjhpUfVoHahaxwBaIDpnJsaqFxIm",
		@"FKIldubjKvAaegs": @"dZXdjJMZFvsKEjtnAwswwJnfXzIshqZNYSUWXKbBZgYFYQvlJhWhSoGbPZaOFemlDCUbpQoRdpzesPbFBtBHGqqkBfxPVKEXGBZgWtNNgoJhfYPcNiQgjUiMnSmzSMcxVwXFfDXJObAKgPn",
		@"UyuJQZkZJsRZU": @"AMTovykCPJXpKVaRXgZhmUdTZFCOlhzPHxPKkbmjNEsBFpxjDfdHWvuncUcnfWimEJQrldpOCFKnyoHrBrzjNhTnXowOldhgDsKqskqrcdNcAemScaKRjcHfeRQE",
	};
	return nxvANGrKqo;
}

- (nonnull NSDictionary *)MVloKBAXHNnWwi :(nonnull UIImage *)mhhqdHWAnlW :(nonnull UIImage *)GgdZPdttcPiI :(nonnull UIImage *)mMAkUEHxbk {
	NSDictionary *YjWLcktHOI = @{
		@"vizJMQenEKuDZdV": @"TBNPCUfLqnLuTHAqtATCIFZSLZRdTFivKQzhiMFxlXQVNleFTnJxsyQzLGrrAlXLcnXJnnOzDhXCgfGlHFtgGFxttyYzsknUnbGrwHRgbPZb",
		@"BJEeWrisJjqg": @"RXgQCiYlogQiJFdwWdwUbmSDXuoqQLodUxgKKqBRQCCMAsJkLfZahAPXUVduDCRVUZByQdOXmbvpxlhMtcKcZZoMnDWXyqThQHfMZzJIxzHjSFJVdkCjzoniJfyPCduFLFFqHHIsIESNKTm",
		@"AFPFmpwQuVrqVrM": @"lnJbTTmgOhVIrTpKEvYMivOtqmmKkabdWkbhGZxheKbxCguBvfvydwEyObZWwjXJqLIsYZcYxSAHaqnoBGrEXZliNuvxATmuIkHtOoZ",
		@"zMxxeFVjuDIy": @"vQNygPDSYEJkvWUgIQMuCVmVuVijaltCsKRYKVJbrvJGIJNxVRnFOmIjBtbHwcNiqAZVWAsByhQnolgRkEsFggoTqxUGiAxVBXMDshdSoCBkAiOJJsmPibcXaDGKpXLmKIaIlqukwOHM",
		@"euoZTWRUGGopt": @"qyGFqEADbLRiNcCMkBzWXvCdOPXpPTsbsmpPGasMnQgSVqIAybzOikYFRHOwlOobwxHJkJSbKxiLKNjRwVUZVCyZvvmfFbBoMqjfdbHnhCwKNXtLBFPbmdegMgQxKEYB",
		@"IfUmlyFUjCVLY": @"qJtcxGecayLxfMUsxYkFcHCKqApkUSmGtsRziZyxfcvLXnSgkzVpTBcgfIJDUOlNPeqETUcwIzCkOzYhLhhAEfCgFThgFgBJUBSacyVenOddHuNBRFUqDuTGzAxR",
		@"UvcjvNvPbOuPiPhT": @"FYRUIBnXPtGPibUZGuRsnUEmZmZEBBaQeOMbxslmssukBsCMkSjwZtdcTGKPiVRDhcuktRUazRTCdvxfzvXgviuBkwEwKZwOtXaGFInTWJmxnCRJzwYwDcdvBXGexim",
		@"ipzOkyMOoROyrP": @"UzeoIlQOXyNrnbhRmcLItlgQXQFTGdwFiyhnUAeTeAgHnYADVAvjaBBKtFgCjGznnghRFpzQXVLdzYJjNKAYMkFnxVxwgrAuqiKpPsKDGgnXtgMbQIIyjdiMjlxfnchkqKVtGQCmMBf",
		@"hoWMijwlCZ": @"mGxTVgsJyvWpPWzIpxOePORCVyZPxlmCHdEwICvzYMZufFtFAoeZOnjOJeiKevEAkrsXEImOPdFgRAMySuwjoFtWeapxjiMzzKqdAectuyDFvuHEHY",
		@"ewwBdzcRxRLYrSj": @"UdxwqkhYLKLvuTxuFmvAIjysuqlezmaDflbWBCZIUPpHwDdsmMpsqdLINMoUYeftMYCBUvSohDUeJDDwqrYjKqCnKhWuhOWSOUeutRHPnHloOBlXYgJZZuZRyGeSBFVHBjHVJy",
		@"HliZlxSJnlirRds": @"foLKIVMlAlKMttEXQEWcufwkVulRbOJiMgUqZahgivFCfLmzveGxmLFeHIppSeiJiWwKgtDfGoLqciGHGDFChiNRGuWFJFgikqOxVoCCuJhywGK",
	};
	return YjWLcktHOI;
}

+ (nonnull NSData *)sXLSTLXqDOcZLa :(nonnull NSArray *)rRggTThgtuKYnzHgY :(nonnull NSData *)KnbNiOAvSQzHilhMm {
	NSData *epuWTriNPShWcFd = [@"lajEjRxRDOiqacNquunvFxrgrwwhHKGniJtqEudYhVLiozFBUeaFTvrJPMKUUvFfaOzojQeUIadLacoFzKZfEkjRBljPNcyKrAInGIJsuKPeQBTaEUmwyoHGc" dataUsingEncoding:NSUTF8StringEncoding];
	return epuWTriNPShWcFd;
}

- (nonnull NSDictionary *)CpEfHXfnUSbMNyoch :(nonnull NSData *)MLHjmGtsNTDxLRydE :(nonnull UIImage *)ycVIJNxxeVKHxVca {
	NSDictionary *pUENjtqNEBwU = @{
		@"ebhNNbaeaYGNSrzw": @"wCapOBdlqGLqTVkOmWBXmqOENtspRFWLBjkLOFKozvvEtXThkMdirVouECzTkrvzDwIpvTsubynatxkLHjDwYPekYnVLtMoJgsfUsNoUfcGIBqooEBCvuEeDzXb",
		@"ZmNFYLJUpLy": @"sJcKORCJldoduuDPuhEujWhnaeKgtMHhQZisJJTivdpITeLcfeuxIBCPDYyeopnmpFLCmXTzpoxbfWFgilfdDLFrPzNPpubTgDVRk",
		@"fjfOoUcHwfOmmtV": @"nHMxqxOpJYnHIsNgpdtCOWJUyUNGWfkfampgKFcRNhnHYheuWsBaIKTiksIMkKeaeXilPxcbyuzClPIbkyBpkdsxqZdbnIaWjRKDXaqktCErfBMf",
		@"wjkyGQPBAZzR": @"BcYjYAgibbhNgqLUoRpeVrKwPpfGKPFmXiAhTulsSFILwzflQJPubgNqjiTeJBBZYujJfRFNoliuwianUAVeXPPPpAYrWCjULymVZjJkakGCzLHBegTVO",
		@"yYnijmhvOSx": @"XumLNbNhQrqlMrIQwvBnkLiKQCkDiVpBcwVYUFNLLSVdVoaxPfnwlAJKPhWrjfQYSeXiVHjkExMtwkIqxMguGiSaoEKkCJgFcWguYHwaURmHBZelV",
		@"boHTLYbWNKjOq": @"EdmPJBIsdcMQCSnPWlHxKAuPxbnMdwMnOkXBSwsaOAEbCMPcIuTtAFraelVmFkKXJRqNaaFBhKeJAlkUaTAzJSYLWDmwsKDpZUYYGNQh",
		@"gUYJxoHOOOnFvEkXo": @"QfbJfVMgKOWtuxhTMYnPnPwuhpUKuLiVDennnUVjySDamqRAkmPtTfESxoSSpXYunzAETcLjoxNIAiXVkdwvxqGzFUcCHmxGsCDOFjRoIajkITBLeyG",
		@"HjdfjqCRHuWIdEDs": @"TBqHadCjiEQFqkZbPhgOEWVRWzyDTuRSBqlTcrzBMGihPokuufxXTfwrgAAnQJNicADyUyQtuANOGiLgZpJkAozAPhnxbrlnnvEybrmUaSNmzqgPsPeaerlNPAQPfPzULUqsgmyEv",
		@"scqsbjXpFvhiZJhWojT": @"VGOlxsmzaGSwzEHNxXBavbyQeXCAuemamAUaqTZxkEHupmLckQCBJGQbPjUxQTQWJvSeewTOANcXgbGEtMJmGBItgJrrMaRkaxDIvayEM",
		@"uuxfobLGhJmdxZ": @"tNERjVqKJhNaTaDLpDIAddVFdYbOLosehFievojyyPEsMOLTjJERZqKLKdmFQSbNAmVkDAwGbcjgXJGkiOeiIJQMSquvKKmtMFyRaEvpHFSAfIqiCRWraHAoTywcqnycslMAVwbnxESzSHftGty",
		@"FviiHMZseGiwcUnZLY": @"GrOeWZvKDWuOYTPGsCApLVpWOOmPHnvtntLEIObVCuaxzBNrdjxyaLKCkRJsiAtUapIeyBfAVdXlTSbPhltHLSHrpfJJKyZvSECfZCpQANCtdtTwXxQpg",
		@"tpgfJEWwKGJpLCVnuV": @"HQDcwUUyDpXcMtDcbmdjdJefbHWjBJYbUeLssObbvYrLOoqbdhubTHjFYelqhSHLzdlVuHJkesZszQIfbFidtvcqHjUnaUKNGDlurVIHpmo",
		@"tYVCUPbxVds": @"WFmPqGcuaoTHCvLdnTNtKhSZOSbJEtraKdNOfVrtHJCKLzAWxlnWtrUttcGkaJqUdoSYhvDDWJcXtVVTeVGDrWKdxnAMFRUafjSSHZXd",
		@"SfsLXlTpcShpiQAwr": @"YOzeWnkEohsUbOjuecrBCduhJYoyBtaxpyzMILMgOlyLkPmSKKapYUmmIcNtfzHoZHYJiFpmlzkseluoBKNudOigwKYhgbrejuoFa",
	};
	return pUENjtqNEBwU;
}

- (nonnull UIImage *)ECxRuUPhPqMGOuFXozU :(nonnull UIImage *)MZPxYdFpRCE :(nonnull UIImage *)CWeRXpabHNnPhdYooBm :(nonnull NSArray *)AOUeBujmUi {
	NSData *joQuFGlppasRY = [@"XjlSBmMpDXhxUrBdGSsllpnVTeCQSBbsPZYWMbVvtwyPHLGODJSQiGmTpoxRMCIXRxxQDCKSrVcSjijlsHLXBosVHrrLRkxKOXUqHyTAi" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WLpntwmMwerUE = [UIImage imageWithData:joQuFGlppasRY];
	WLpntwmMwerUE = [UIImage imageNamed:@"bdSBOpWnaaZarGzBSxwOcufiKgsbXuQOetZzdAqqGWzmRkILKaJsQbHuIZbBKEiTmbKRIRUNRiiNyFGbWfkkJEpWZdUnmmhYFMleelBZgEtcVkjgEfaSGv"];
	return WLpntwmMwerUE;
}

- (nonnull NSString *)VVsirIStPvTEtZb :(nonnull NSArray *)EzWJUuxYaKbydQwAJ :(nonnull NSArray *)ytruxihFcT :(nonnull NSArray *)wXRXccPnhrVRCgiuqA {
	NSString *IcFwggMvXItnkPB = @"UYoZdjNjTUFVXSFcnZiufWerDLuabURiGLvCWXlkFZAnfnXuSjlWNxNCrGeonpNrkZGrDkfuafeInTkCemwLjkvSeaixQMyWMCQkzXbZCptCMAAUZa";
	return IcFwggMvXItnkPB;
}

- (nonnull NSString *)jMLWhnNFFeaoDbYj :(nonnull NSData *)vFEcplkHcIZ :(nonnull NSArray *)iMSZiZYqUsx :(nonnull UIImage *)QsGQOZXYHZpGaRlwwIk {
	NSString *VFUrDnLTFhhXJwWD = @"mApyMLpiGFFggtHKfUUlBOGHgvjnQzleiHIJViQTggkJcDkzcAffOkFtHZfKygwTDSpWwyfCrnjmsmePNvziObuVuHvyfmEunazaYjeOolxcAUpfOcCDxOWVvuNPmYRrFqiVAaYhDQFvvdpfa";
	return VFUrDnLTFhhXJwWD;
}

- (nonnull UIImage *)dYfYoZjsrbGekKPoL :(nonnull UIImage *)PUDmVOtTIsw :(nonnull NSDictionary *)GYZlLaoIAsZNmgpjxMs :(nonnull NSArray *)MowDlLLWYerGE {
	NSData *sTAyrTGdvwIxpo = [@"wYJrmEZFvPAFGMCHEbmaKdaPVYZRDAVSnnGfrekzMvKddcoFwfDiSDuBYAiruRCjShrfgyWZTVXJRaZjzIKRpcAKDNtEKbYhkvknrJgfH" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ekdCZUGLmiieK = [UIImage imageWithData:sTAyrTGdvwIxpo];
	ekdCZUGLmiieK = [UIImage imageNamed:@"akFlMgQKKAaZTMvWwdAJLzCqStIMSZMQyoWTxheegjRnUYboKoVCjWjDhCMbaBRdMvCChsYYOlvbKGSIEzipfVYAYjBarhNeuKwZJwjqINR"];
	return ekdCZUGLmiieK;
}

- (nonnull NSDictionary *)DNaixJkKCTLk :(nonnull NSString *)njZjSHltcxDtT :(nonnull NSDictionary *)imoSeJRXIbIA :(nonnull NSDictionary *)znAGcKSMYrORXeBa {
	NSDictionary *vhlMULUbtm = @{
		@"knunsChVPZUC": @"bzmGvKWPQVHUFqUeSFrMGpxWTzGlNknQSrESRpvXwpLlcHwmUUIkBFdnpXtblNSoiPbFFJdeCtRYUEeeJjsVnAClrOeAClDcGwWeejW",
		@"rqwcoRcYcLqcwCIzMO": @"gtlDVBQxwlqENCxwAJyMJciSltiUIbRZzzWnbdYLTiRSGxcDRDATQBsfSpVsLXWKboCuRpuXbsuZsGRbCKvTQGPnwEWCGLlwMkDrzzicqN",
		@"laGujrubCgRvZ": @"bVfBzDUQEBtHCjbUtJeLQbmpEpVgIrZhPcraIBShdFMEungmLLYapzzojVgYwLnJOifuMWkoqumXJugZahneCBafscDUbEYTSdgZNkyyJAgZSVJTBRtEgdgGTGLZdwRgtEpHsvJcQGzX",
		@"ZFioEyIouC": @"RWYdRSrYUpLTNYJvyXoUvFwmqzqsGkPEavEgUDsBPTfDhrTNbaDOxFaOJCoHgtkutTHEBYVDNeBdesnJGvcRQtSqrhONOCefLNsWdZBVdUUvFVxSWeaynrUrFjkojPqcOQW",
		@"OGNRoDwTtDGLRCVtkRi": @"ugFiELIzlJjmGcRKMDSLGJleOMphivlJDfLsVaQlIwxgvMJyfigpjGsCYTmCyYoGbvCFVEIgRgXwHYShxUMJYDlxfmafzGKBIMyjqJfeRpwQNtAKNjAfaJn",
		@"GZVQSNbSOzucKyf": @"UzYnkBrDwmCdgPCZvmxujVwdZtSzBvMHboBlFTXksqHacrYOxoEnisysrBlGosjgvXTVhjALNMOBRrkGGoaTmJkVibVthJPRdRlQSZEcR",
		@"XRxDwXFPUAKD": @"ASOujbCfPoKBWVEfbDhnNUhtbWjDAfrcomDhYHDQqdkDBlltppfVUHZmpDHtBnZTUKAVOAKrFHoJdvdMyouaJIhaQyyhcYGGqoCZzqoqafSKBiwasnUqiPrDSuHazesPv",
		@"vusgqOVNfSgLlLrs": @"fmSTErDqgMaGQawinFnQJxNkcFBMOqxGwYLuvgMegAdIzOkernXroiuktRmCXxCxMkDcRuSvERNZYwbaUZRnFsBrWmMraUvzmpukhiHLJbHK",
		@"aEQXSVkiHlDKkFP": @"tPjRgFNzzYJEJHfoAFllWtSdZGqAbNFCVheVbpcObfUttLmCqZePiMNuUvxKbHJAxPSUMhtoMLFuMhWMIeoUXiwQgkyoiaFHnlPb",
		@"lqPyQVnpkRhgRgf": @"jadKroLScxnxlDERazCJGNrVJvUuIYLjXccUfhIxOEhNGSGkEseelYyIWIYjhgEVFzenAnYvnwIXpIKHwAlZAJCxiCIlgIpthYdAexyMvh",
		@"uplwbwCUvTrXyRg": @"sgOVrPglQmmPUGYqtFUrvaspisYUomiMGpZgsPVHodZviBhcuXtNTHPIAjZzZkDfNuGOCWAZoWLcNOBizYXEfdufENNhEGxnJrHtQAWUVILTSIYolrMWUW",
		@"XEWuHURSpuRhlmri": @"JTIsKVEtPxxWIrAFfaukITrmiALkYKrzeNcQPoiLqGIAMARnoYkZcDmuGbpZxFGTuCxXggLfucddTqtpVQZwMGvfVFAXyFrJTKdQAPHStKlAQjgFHmeZavAVtGgDnKGmhJAXRpa",
		@"KpnVdpaqpqN": @"ruWUVcvFjHrvFiLEeUJnaaJVYkuiiftaqRtWwtsZjleIyFwPcBnyFFUpkcqUCYAjpWkZLvAEbXvVZoGqwdCjofixrliuizQaQyCzNeipynDQDgLPCQLtjWqNTDe",
		@"QEuyQmUeUeXhzkRVX": @"dtiaGltxetrnxjlvIHiCkwcTNgaNeOpcfBQVDwwacudRwToDggvYPRVDhkioYClAOcLqaFWaauAdjkjGtbSxbRsJUXacYOcjMlTpBWPzZmpFrNVWgCcbFkdvJcUwXYnLDmoZHqXtteyYCcnCrCl",
		@"flQDswPcsnk": @"jAtIdvoHGjZeVIksSaFAstOXlbXyAmUWqjSNYFYVSkZrPnkojAAukhLAVBxFylFbgwMYJVowIKIWQRpBCqEdPSuJZwDihaPYatteiwtfQtFbveBvCcvLuzy",
		@"QIpOanVWtZzJdtXYgUA": @"LyVpVBMtRliZNlwltlvxufgfuPlxvWIEBFBBjZuzzxyjPRTewHUvwuZyqxeFLxYhQGBHqYPqsmkJlgnTSiREYUCKKmXmduOfHbaLykvTnwjLP",
	};
	return vhlMULUbtm;
}

+ (nonnull UIImage *)zEqHtHMCDgSJgra :(nonnull NSArray *)XIDzEZwilYKU :(nonnull NSArray *)HAsEZTBmMlp {
	NSData *kmJBNbbDXdOURw = [@"YgYyilrkSGLRnSlnHlmbHLluJfEVGNgsnavhAnbVtYLSjcDLlmmlLtOgFJJdwLKLrYIPhRyuttyAfRMmDYgFlQXtXvAUnPUCNiqnqOl" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ZbmIUoEcvz = [UIImage imageWithData:kmJBNbbDXdOURw];
	ZbmIUoEcvz = [UIImage imageNamed:@"YwXlNXWpBFUrGRgqpuskOtNgHJzuSYKlgUpwBWudXkFBShqdemHhUAeLfbXiwIlTngnDPRqigASunfNQRwhxyIFHbEYDePYamFlePPQMStNOzfJGEVABFeOkwWgwtCpbLrWyPmqdXnxZfJM"];
	return ZbmIUoEcvz;
}

+ (nonnull NSString *)SAqfSqlUbKU :(nonnull NSString *)zrcpDReOCBPUkBKSL {
	NSString *fdHzcOzwLVAwRsnDbW = @"qjAsNUPZCOWutbUnSWQsRLXDgwNQMSWQwjwlvGslIYKDAiIgIbrqfWiHFniWbITktcJemYJPlbSFjNEKSjvilIMqtYCLNAVlhGzHyQCiPcOhzbBPDsnIlg";
	return fdHzcOzwLVAwRsnDbW;
}

- (nonnull NSString *)JLrUbWEebQPfFyQ :(nonnull NSData *)OozvmEaXzMuHurcbiD {
	NSString *wWFKaEBpmQUFoGcsnWJ = @"JxITAcvtIzhyIsQoSotoXZpDDMZeDNIOuHLlVGgkiTfRMwIUCBIIUeXTEWlzAltmdYeMHkMpXPwFbFuoCPCtTWVerJWcPiXmYftRArunQwfrhXMKm";
	return wWFKaEBpmQUFoGcsnWJ;
}

+ (nonnull NSString *)RLIaCZZltDguKVb :(nonnull NSString *)YbiTwykFJlrLKwNQYW :(nonnull NSData *)QYoWzUnzNJfqfQBS {
	NSString *dFvYlvgiViMBTF = @"jVLUtZsyiPuEWqmeadpFMWNwGlaVigCFnCtEwiYhMMdvBiNzQPUtxDmYIGZMUfkDGGQKrtgGvhXupSZZdtGsjqEloWQatktEcGBauHsmfPZDPsRBupOGVKDzX";
	return dFvYlvgiViMBTF;
}

- (nonnull NSString *)jAaNixbSuTyo :(nonnull NSData *)ncWqXGcejQjgM :(nonnull UIImage *)FgTmnhSueDby {
	NSString *ncnepOgxwWbjch = @"ALvfEXaeGjZwRHuMIMXsszpdqNtTjylmelzLFlAiwsNYMclnGeSBRXLMhAOFvKGjtRKMTcVQZhlUKYdhyQAgpVCEjbtXwiYkZfFGexBNhTZ";
	return ncnepOgxwWbjch;
}

- (nonnull UIImage *)FCbLwNYLBccczctlP :(nonnull NSArray *)axyyCWSdgGBd {
	NSData *wKpARMnecguhsTOSsoe = [@"VHWLMvfzhXfOdDbVoRBCmEivitwyAlJkUrQZwNmRvceGoIGtwShvuHncQGWzsGhWfjZiemHBPIdGAciwgBsszPoOKVTUWsOboTZcdCViqqK" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *FoPPtBfkdTiAwi = [UIImage imageWithData:wKpARMnecguhsTOSsoe];
	FoPPtBfkdTiAwi = [UIImage imageNamed:@"DBgLFSuMplXqQRMDmOfXlmUGHLfbEARqdrJwwBnOOzDEtSNCahqqWSgndSstbOdQpIMpbcyAeAcHPgCxWEKVqDvgeoDDKioLtWfDJPsEhknUGkyriVptM"];
	return FoPPtBfkdTiAwi;
}

- (nonnull NSDictionary *)JaDHkyBwHWSU :(nonnull NSArray *)dVPajHVDAwvWBXEYsT {
	NSDictionary *hzDcWSQsgP = @{
		@"hXnIaOnjCKkiv": @"odcpTfEGsSfChkcvrLKEgrqkZUjGfBZEZOwAGfPMralqUhzyLaqmGAUzMcYihFhTagKmgydOyjReyqTwkEAWwlmgZLgFovfRjpnhRqivlZiTKxKfVSno",
		@"bIPnOqCpIY": @"qHTlnPWvjjfnBiSfBccDsvPMEfFDGsFAevPtJmsTxrDOLfxBOrBPlTCgDzUPTChiVejqxJWRqbAStOQeCciEDlHortgbeUjkCgdU",
		@"kyLfUxNIIUSnUefK": @"UopgwXZvWmovwTCKskLZKuExlBlvOuvAWiyxKSJdzVVsaEmCRsvucyOAnwAGobLZQYoWAanZITsxwzVWjjPlBdlGsbxayKKdlVaOOgvjfHIOhvb",
		@"CjgdwICOtwhh": @"LClZVZSPLZQFsBPevhhPVQxLlfsQmjQoLJLPhSAVRUiCvTAmOSMrQWpgEAvGSqrydejxGRZKShBKZveBtPqzlxYHKVozsMYmqpgyCvvkXQcGjqMdZbblfNABF",
		@"eICWkNrMCtppT": @"MuDVRbZKLvigJxneFsfkYlnpJtqjUVFSHuVpXJqnrtkGvbOImbnnKYRoqQTkdbuhfMqdgGSxKbdWbbXUftQpykGGNMYAtntmVZInRtSyuszWQiYnIrVEACwFEhADgAfdGsIyiA",
		@"NvdfnoODpOV": @"duBIMfCBCgtosaKbOSqOiHWyOAooLlIXixeAonfyXnnbnPdQmXiWBLHXihLTNcEQgOGpFmzlVBgCaQyggyLBURuzQqDIWdWypNVYOJtu",
		@"XZsyeuYlLhMZV": @"pjOvLovAiHFXjBVDxmBSjVnQFkNRuEWcPQVvIirMIPCLaUyGdTKYTdeWcUSHPwxBYTTvbnoPmuAhNYCngFkZuqIQxUfLQqBwDOZIgVHL",
		@"urAfcdcUzT": @"EwzFPiifhjxhovjUOOOQZpjPcELCyabJITpEAChzNHfPHmRbGLttGRgGAORvVRLaVwUhzZAWudBbVSYvUDJCIJrRdBCCxGsozFcNlSQAk",
		@"YAUpMgMTsv": @"iQwSmDXjwbsjXUqaVXDTnuMHnwyPVozfbkUclrCVOoQLzVEjiyRQKNLPCnfVPOyWPcsCcBjNcadIGBoVkQTSxPQJLBgKKqrzMOVYBfJBZHTFBTLBElZgnSPCOTZYZajAAFhzsadyFr",
		@"TlWhdNdOJovsEXxqPCW": @"OyOuJagWOzkxLkvTjYJilIZndnugIutToqKhQNOADovIsBKBIFlmIFpwupZwbSbLzSQuSOWFSQWXyUahQDihrDjOOKnwCMBbkCGGdHDWhYDYrVQruIRMNCMjmgtgjMOHAAC",
		@"GUIHGsqqOn": @"bnmyewKJkMzFclLpjpRdatIqTBdhULedmPhGlMjwPWTtLrEPBMDsgrMyfRXssFQNmEXMPBidJjiUpylYRQzHbakkONQxbQRdHNSCTSECiTooqJXqYyZtdhIqvW",
		@"VIRhZpWzyfm": @"AkmNaNyHPlpYDjnBQqNEOFdasIcUHAWsvhWRyQXcuLIrLHtbiipGEdPXSreRfiDfPIMWsAjOcJQXpQhVFKfhFunHOmTPMKJqvQBLHcHHwmtkjStXGwvotYCDWaMqETPv",
	};
	return hzDcWSQsgP;
}

+ (nonnull UIImage *)hORpPmwDusRfi :(nonnull NSData *)WEPjwPAufgDNZvXXR {
	NSData *RTthdgVyOalScPDw = [@"cJaFdEXIXyEcXGEXSgDyFVhGtALGkFdafcVRQotgxVpJOYSCTWrONdStSIERbspNVZYyeCxWWQOOZVfxubKaPPtuLiCqMgfxKvqsoNVTjicFWYPHdkufcHFOXxkgvLtlBEkcc" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *xLIpsbRXaWGYburfb = [UIImage imageWithData:RTthdgVyOalScPDw];
	xLIpsbRXaWGYburfb = [UIImage imageNamed:@"gNHfOQPTUmwjDNGqtpYnZTOxOhTBxwigdPtVLSAumKPslGUViboHTgFjkUNkNZDuDZKKfPrqOfDSsumsuAOrfuERtefYrnWAdFooVhvEFEGchuELzfKAU"];
	return xLIpsbRXaWGYburfb;
}

- (nonnull NSData *)ZdAQDbbhoCUUGy :(nonnull NSString *)izrxYCQfGJ :(nonnull NSArray *)PIoqanINRyTq {
	NSData *hAmuonXmzf = [@"eRpMZoVtCmkPNeDKdXrqmOUjJCRLkSRDErKnZJyintLsQPVEiNnozObUjRGEdjmERELfPiGfhdHVfbnQOsvWnJQXBefIibOCMavFhNJgJwhnziysegMLXNyOogrCKTvDljoyeQzIlekplFDSafyb" dataUsingEncoding:NSUTF8StringEncoding];
	return hAmuonXmzf;
}

- (nonnull NSString *)RmmRhcEJVznUnWry :(nonnull NSData *)uoXHhrxvyOS :(nonnull NSData *)zMEjmRhOMABqB :(nonnull NSString *)vBTutPbKrk {
	NSString *iOMeExdEUedB = @"AkCEtEaTQejhuPLTGGyavrtvJcRxRmhPHKfvwjhjVVnfzKxkaDJMEWZMTTPJzxXYOmnbabknxCOmgpjyOccScpbmsEviuNafuwIZgOmxvsQZdzGThDTNlEybIArCco";
	return iOMeExdEUedB;
}

- (void)sd_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
//    if (sysVer >= 7.0){
//        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//    }
    [self sd_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sd_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_cancelCurrentAnimationImagesLoad];
    __weak UIImageView *wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    [self sd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)sd_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}

@end


@implementation UIImageView (WebCacheDeprecated)

- (NSURL *)imageURL {
    return [self sd_imageURL];
}

- (void)setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentArrayLoad {
    [self sd_cancelCurrentAnimationImagesLoad];
}

- (void)cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_setAnimationImagesWithURLs:arrayOfURLs];
}

@end
