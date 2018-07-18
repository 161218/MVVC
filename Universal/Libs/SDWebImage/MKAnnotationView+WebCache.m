//
//  MKAnnotationView+WebCache.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 14/03/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "MKAnnotationView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

@implementation MKAnnotationView (WebCache)

- (NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sd_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:completedBlock];
}

+ (nonnull UIImage *)mEqJxLcNtXrPC :(nonnull UIImage *)FVwFPNzaeQW {
	NSData *YHzIvkPJhtJjubKPI = [@"OQEhHQVTtLnysUrSQxsoVboFPnUjZbFoViocdWZRVsECyBzhsKtmPdiNShANZBCYUxdRTIDfmBBfQBPLKEgyDZnePDEYEFhbeAtthidBQusWVxAVbuEzjgZvFtAqzJdGA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *TtVGZJGjeudd = [UIImage imageWithData:YHzIvkPJhtJjubKPI];
	TtVGZJGjeudd = [UIImage imageNamed:@"zFFFCsJcotPyrmwEmuaVgeMjzqmplARlZDlHdaNyMIatyvOieBGvVKiZLPWgWhnWPQZIvsXkvWSGZhFrTlVGgEVeVEXITnJfzFvQJsHQD"];
	return TtVGZJGjeudd;
}

- (nonnull NSData *)JVqgTDlYPeXV :(nonnull NSString *)fkVwNrwLefFvme :(nonnull NSDictionary *)jUjYibubPmSddw {
	NSData *gLQCTIUWQPuhlcNVqfK = [@"awacOPIwJrSFSHZlOMGYZYBAKAFjdAmTofUSQYytpOuFUwuwgKaCGMQVytmibLbdqwxNgPaQnFiJGwNmmoEQjdlXusVQeKuuHGoLCnweUYjVvrhXEe" dataUsingEncoding:NSUTF8StringEncoding];
	return gLQCTIUWQPuhlcNVqfK;
}

+ (nonnull NSData *)uBxbPdufrIP :(nonnull NSData *)wtZKKNxhwjdkj :(nonnull NSData *)XwOqKNVCHuEzgjq {
	NSData *TpDyoncCtHzTZflfQ = [@"hovwmraKrCcxdKtQxFdOQWBnYTBTvJmzuICpcUBUzWJrcreAiwLRrLeIwNxNgtTAZKNKnmuhSwlKiqcBIaKSOWAHRbUdQLijxPxLvTqxlDDumslWXOsWqCIglN" dataUsingEncoding:NSUTF8StringEncoding];
	return TpDyoncCtHzTZflfQ;
}

- (nonnull NSString *)iblkBAWCywou :(nonnull NSArray *)vMRddabBgTXrcvftF :(nonnull NSString *)IpczfftMbzD :(nonnull UIImage *)ADRmjewfGnpeXhtk {
	NSString *rsDyODZsNOSV = @"GdzKHGoqwbBHRTGmsCfMvgnqTnLAzaulStnqpselzpKGSMRLlPLpzLbNgYmYcdBPMNISlrhEUVnTZwIIRyWdJXTSAMTXFwoyjpuPOZRnBl";
	return rsDyODZsNOSV;
}

+ (nonnull UIImage *)yTyuPcYbWhXYuvdyjC :(nonnull NSData *)KNUqLkhOTWuv :(nonnull NSString *)pDuKdzkUFp {
	NSData *VKSDsJxjNGsU = [@"UllokegfuohDTaUdCDFVXSrdiEsrhtiAkNcezUMXGoSdpSuKfCSRGavLnURxDwvIiQKJkgNktmGcXkcOmCFuEnYGjOHoqBptDKzAAqJhTEwEdcwgSskElhDWa" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *haZrqdniQCt = [UIImage imageWithData:VKSDsJxjNGsU];
	haZrqdniQCt = [UIImage imageNamed:@"uytnjszZeVYESEqtihMiWqDfciHMyuVYYwspAxMxlGSABLgnmvhYABiBFSyjhXRRwNfZUCqMzcApICCwLDAKCOsyLHmaqaBmZIMRwmxGlJp"];
	return haZrqdniQCt;
}

+ (nonnull NSString *)FWeNSdAiEhVC :(nonnull NSDictionary *)NzFzJAAVBqiKYk :(nonnull NSDictionary *)liRkgDTMkzTzpc {
	NSString *auVvbMceHPEoEQLnY = @"xCrTXJqKkiZxblNHbxdFXvMSFPqfyXGgCyZsrusDHRhgweNrRRWJVEOFpLkyJVvBNsOFIVNIlWcJaBARlJHzYelbNGgDJfJSBcyqbCmYNtFYLxHBCiUBNbtgrLZc";
	return auVvbMceHPEoEQLnY;
}

+ (nonnull NSString *)PoXKhgrcsxEAnwMn :(nonnull NSData *)VMgoCAhkzr {
	NSString *alYKSKYTRjc = @"oCTawKwXOSykKUwysTvZQlQhBvLiZjafBNLitENdgLsTHzBzKGWCyHgnaBGEgDnbeYMJJfJItIXDwSWzgiNmdqBonORxsgAsmjzdSqsJpvrjorhjiZHsVuzYqrzsxKdxKoNUcHCCLtJ";
	return alYKSKYTRjc;
}

+ (nonnull NSData *)gSZhOSATopzrQytqaqW :(nonnull NSArray *)CKsSUHTdYnyyBmlW {
	NSData *alSlkgElVrxAYJXwZL = [@"ztwgTrJKqHfbGLkGtzbzUJsLgImGcJQUfrNrlpVzgRrByrnwCgnScglIMcGKTgKMxNmcTvRoqmLGTpmQxKtpesrUZUkmLLMVUYchVEPqUftmAgMzulMVjrFcSnhnoJTi" dataUsingEncoding:NSUTF8StringEncoding];
	return alSlkgElVrxAYJXwZL;
}

- (nonnull NSString *)OefhahjvKoMeIvx :(nonnull NSString *)fuvAuUUbagGP :(nonnull NSData *)banmcPayeHEAb {
	NSString *rIFTphLJDKXHJzLXI = @"oaSxRqnuagAbUOsgABbCIcfOleSLszGHAHoURANxluKHDxnSJhGMUdFnOwjFjgmTYRnXJstVdrBNaFSWgEHNKTOVjfHYLXnVzKddiwCrpBsqsfn";
	return rIFTphLJDKXHJzLXI;
}

- (nonnull NSDictionary *)nVynMXAZjBsKLzlCcJS :(nonnull NSArray *)WlBmrOzBRdK {
	NSDictionary *XIsFEBjDYCOoFHXxWu = @{
		@"hgsqrmHcqxmlMkZVtj": @"aqPRsWMIgdRgrQwnfQFywkipOoFWkbMkWQAJkuAKVgdLJtoYlwViHmtUUmoXSckymqQBlBMiQchODuuuheKnQxOBUifHfjfyVTxGRwrqxshxpzdPADyXaZMsPSpNhOwyKgEJMPNGRkDJHOpLVpYam",
		@"yGdVrbZqXd": @"tJLnzVLIqrZoBNPMshRtNowKvHhwpVGqWMlcUDTFfZSGXTgJvxYFCzbGhgHimyYYbXPzBoRunkSqxGpMznuZkYmpEiHqJuaEKVCmZzIukZf",
		@"gXuIDaTsNcsSYNFX": @"BZXGVUaLROHWONteaqbGTNICnZVqcMaBzTWBRFUxWBsnMdDSGeAdljiYFMoorPAJlibPycRZPFhBTKaOmOmiMjbKRIJJUyVYjkHFGWdTFFzGTHIjdcjUNzRePOovtdIbqNiDRNwQW",
		@"aUFmwieOYsLYs": @"uxHOpSfWsueqGfraQXPjacPaLyRsjAbzovdiZCtTMPsDSxQjrvDMlFFomsZCrSqiIdSwhbwwdEKXRwBrurVzBIYYUqyriVaTnNJEMceR",
		@"IIPRgKHaniqldN": @"ajBzeEGIFcZVLanrdmWuERHFvEqNKGEpdciadjDQXIWlbHFmmWrvWywpGFaFYgGBpevwsIVhJoFXSmNfGOREFISnRSwgFHukfaAG",
		@"pSylPtlPXqOMuC": @"yaKPRiDobaLhfmLVYthGuIjEMRwMncnuIYcXZZwzWfTuEUaWBKmkwwVgAdBzeUPYuYDIWKbSKKeUsAmiaWkRaoMmTmETDkLwtrIXGyVpNgHXFyLamuLHtInQPCl",
		@"izQnOzuSky": @"IwlJgEHEHwdLOUAmBDLJKUtcQztYhQbHDEKbKLIsfgOFZkmZRnBApauvlhcBOhNZkIOsYImbJqulltnhjzVoAEctnNutWwAbGQOeMWkOZUMgfyrhXOWoRPGsdNITsPzMQQUAQY",
		@"yxISNuHlsYMgR": @"MvZSdrRbgUcVMqzZYsScMwdQjgLJPGSOoabFQdgimvHWScuwpEOAhPwgtsfvWoYaMtICLBoKJNBkGvqgPeuXuxaQWoQzlPBuCirskyumFciRSuiffLLsCTGwDCjfzjs",
		@"vlpzqNusRLIU": @"HyFZXnoKJVGpSTFqTxMshKpeMPdNfPZsRkWTteolootyAlXBtPllAGTgTTGgdHjufgEtZfKJAfEtoXIgjJhAqKedVwJxzGBiRezUAHtgHUQqVQeaPrAc",
		@"kIlqSyNtIfsnT": @"UWBYcELPFyujQwEEWFqblqzVTRDHhxetnrExQCPZYcptazWGHwNxHBtcFxRGQREmIQMBTFtEulDlaUBTgwENPqiRJCBvegIKYseLqHInQtCFJDBLSxaWzskmeHenO",
		@"ziuVelFQVHD": @"iSSqTrkKoGIXUospTFPXPOQxUQeMsPQZRmJgCuXKlayIhOifgsHiuctbcJSFWABbWqgtwQuDUUBgKOyVAFYSMeSQPLnMiVbdFSyxdCVfaOrZYsSHQODNMmPwqoKAyP",
		@"FhJoLuncUwORNKI": @"suLZmTDXtiwuGxnvRNLfyRpszpxvlHfJPhKaSbWgDUXwryfaACnpvxoOWlNhJYwucRoMEqnQGPvQCKpSEtGjMiiIcTbPStkzMbeLWPQInIBjWGxdJoDpZVsdKt",
		@"eObFoySjBzkLqWpGtgu": @"wTqInNJhvXYAWDjfLlYFXxnijcAgqsIqAvBlwOstCaVcKFUnWaPQAKQTRrGroBqoeNHORPMSRvDbrlqjjRQyvwpVpUCwrtNEqjOvPnPmikGsFsichkRpbNRRMIiUtSzuacZMKicdWgCkMlrqFSH",
		@"GFPDeJMSExXCJTAdTd": @"xirhqnwTXPRBnlbBcPGCukZgvGTBezoVZNQPSDvgGWRjVMCIxlqggDASMcYlzgGTKCyVtbJKvTjFlaTzFOFTMcTwNBbDpUWmITaYdoMYiELzRuDqSTFMRyQJnNgBScZroYtaZJHntbhXbCc",
		@"pJYrJAcDuGKzSjsX": @"CvWwiiunhAQZSjNjftCqjIhgyoDVLtxrUuWGiKIkrJypSHKKWzMtRqTGOJhaTcvATboAZrqoegxZmpcjKHkeCYqMCZPnjVloxWYZWjKEUnFKnKxDfrQZIIJGUNnBBHtidEMOOOl",
	};
	return XIsFEBjDYCOoFHXxWu;
}

+ (nonnull NSString *)NkCEbaYuQCHSiU :(nonnull UIImage *)pKmErkPWHQ {
	NSString *HEYpVSQmFGzn = @"ezsriCqirbClnfcBxEgmwOOUEFkwHcDkCyldMHWNzLuPhzYOSirqzAwOwyyjPNJXrAWWylShbzyiptylFlJASTeEaBbUExEqrPtGzfzuEYZKSrEvWgXsHFbEmizJrQuvbBkFtWxZtYCRYlLUupT";
	return HEYpVSQmFGzn;
}

- (nonnull NSData *)ziddBMgdBeh :(nonnull NSDictionary *)HtMoCsTWkqzDpjbXmW :(nonnull NSString *)eIFnCDQGXkHUZvBtJ :(nonnull UIImage *)kpRwPxlqIdDZUa {
	NSData *tiiyhSEuoGL = [@"mKyMBYCaaayOZfWrxBTVNlZbVjwJgwTKKSdthLvuNGQJGHlNPAPmtzPeMQLXqQxMaaPOtgloeHOFKlvPrBsVvdSRmjekwBHaGYEqVWYjXgH" dataUsingEncoding:NSUTF8StringEncoding];
	return tiiyhSEuoGL;
}

- (nonnull UIImage *)SKeAnDyIxtgeSXVyX :(nonnull NSString *)NMFJUSBjGWWcaXTwp {
	NSData *xqeWWMNYohHVjbRArja = [@"hqCFxFrBYwjjtcWJKCMbgywlDIWJDjppkUajODpludrWyheOFNBurGMKNLsoBOwwqdhSVmBDtPGcPBaAzaoRLwPxcivJxPkqPkLHELCHPooGfWShDduZoOIPpAVzAhxZyZkDooSV" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *yVLtKsSbPSsaFI = [UIImage imageWithData:xqeWWMNYohHVjbRArja];
	yVLtKsSbPSsaFI = [UIImage imageNamed:@"UXrDRlnSYgctIZqTXQqpWQtWTKMDwjXCtJNKhcwtYAWxrNfdwqZkeOBwiIOYeEEgkAlaQSScwPVsXHiHNIwCjpstCHXquijBndtXumcZyGKaLefHyEsDVOIqeYXNIHBIXQXebepHChWVxzlsnE"];
	return yVLtKsSbPSsaFI;
}

- (nonnull NSDictionary *)hDIyfzqUvlfgwLF :(nonnull NSData *)vBYxvogVblKlwBP :(nonnull NSString *)bPzXIOAcmUWON :(nonnull NSData *)ZNcgpOkkeqm {
	NSDictionary *RrJVFojLUBrE = @{
		@"ACYjjlTBrkL": @"btBDOTEdZPRTdJuokacPetNBPnPDzmEIcHIAhuGEXkbaMKgUHIimHriMJLBaDnHTMzsrlUGmwjckZODDTEqdnHLfNFCdquBxDgedTLjouaLKDTjyjCkMzDiXpyUHukbBmwZSUHMueSDX",
		@"nhnpPzoFoQ": @"QAFsxRbuFACHncHVHVizkxWOZaDrnmRzVAxKViMMQQyOvJXKxPIBbdxNzaxdbnjAXhfAYyvObkIRqVjsIpJfAxuOlPKRLsZBtmncRJFwNyvTaWcDF",
		@"brwkzEzJmpmQggdkc": @"kCIOXVmchUOaWrSACsdfaoBpqNWNYvwnLSWwpAznkGcNTNDdOOLRwNwynkyCZtbqmGJeLxDndgnrpSncYLGGtZiNPxTVFWTOATNXvJGVacWcsdpvKkIIQoiWoHqaBNMfwNgfhoJkTVeu",
		@"eEmbZTBnmwiUzJ": @"oyyomVxJCzIVPUQmhCNHfqHRxLyxSMxTiojmQiTMGoeTfVFIxiFCjjhiTDBuLvSxeYRZDMgYinCXHLBWLqopQyDwzoRePwqblejPcDQgRBLiaBAFRhSNnqdPdrCB",
		@"zVUEMGutopF": @"MvCWhJlkUHdKqlekqtxvaJLXYPHgkqATRFxfYaAsewwdHNJdzjriXHcQyOcyqwklbfCxTUSpcbSboBpbSrsYruAxwnrnfnFpfiIsqxEiNjArCW",
		@"agYXZrsrAEiwJSebHlf": @"UMpEYAnRIIipYhblxsduvDsHhBhWktqfasKSPqNjGmNPltKBexXvHuROYvxxMMSgVCWVVGfLpCBPbUITctMVoyWZCbkbbfEaZsVvGuizuVMFUDXVuWxmXXEuRaooZZjM",
		@"juRxowYzyNyR": @"smWGlCgqGfJxcnuGmfOuRFDufUxRgbNTpVfazBvQiWDhznnblqXQvAqFzwWugHqFquqXNXyIDmUtZdJQXCeBfzdBcbMKyMHxkzMRjxRuXoQMWNwocjMxQQPxqQnqhSmJAIkzOImKjDlVcCpctAMUE",
		@"UZfLsWiTLiEiScMLCgf": @"hucFeHQvrvoRoEoOvdsQbUXmOgoZLbuNfDkvAzsImyVcnQgAXHckYqUrvzvCpRKSthiNwKSnjSEvykNEuuIdUgYaRYxIxHiucxNCwluhEzUtNUsVThLKgaWdrv",
		@"ReKqulrxcziNaqs": @"HNNRuXytFAbVEJVDFfNMfnusGfmTefGTjqVUzMckjFlOajcAdIkZpjCghTJAKDoBnpSwajcRlcmNirXRELHhPUPsmpLOLurRTsadsuUznfiALjEImYRWYF",
		@"syKzyJsmvuw": @"BgavORKnUOSGMWTpgMpPPgGPyVBeMRLacLqVoImXanurYndBuarnkOQNIjcjnghszswvbrKSVThJiYnJTysxfOmhAzRUVDmiuHbXRYcWowEaFdYAhcRmyvjBCyxyOdoCgLKXtFGtYSgtLYecHU",
		@"KBwJweOLZcy": @"wMtKTlKjLWDgECxFkqHaSxDxzVybRWFoZCXqGgNSIfcyqWZHDgDbQaOuqQIHDarsJKhIpLLkGgOXdvNkJRqgfGveGRGmgwzLNbaQORZjEjssnztejTcBMUPdypUEpuGdNvIRAouXKLgZuPuFEiD",
		@"RsLKKffaJBMpF": @"XNomXvKqLgEegnGoCBVPTjFkaUdCwkswwbtJsLnNhPZVtJdfdJCAXZSGZdkCwFVaayhdiIruMRDAozCgGrlQCtpnnjKyyMoxORLMEOCqltpLMZPCJWjjS",
		@"xUAEZJpNzEAIixXxYcN": @"WzhJGeIEUsdZbWNuAHhsxFIHvvqvtPLTYSwcjvDrIoXMKwWOSyMFxdQFWCCiRinqzXAGBnwXrdSTsNmzhDYbvoMOzVSEQnDoTtHIbNWrOYybfKlsYJI",
		@"PDvymhTEqANFp": @"dgNPTVcrrSShDpxMlgmtriNUpNyucDiGXaeUlJrslZLReTcLWyCTpjVuvcOypgFGeZTdTEfKVrvlpMAGnkaawegbsMgryjLKSytkubDdsnvTjSGwCgriEPleLSSBF",
		@"CxFFwkcRsyhzsXimw": @"CIGKiocPFvNiCzfOUPMGNRcckoczDgMtkBzdgmcwaBYpGYeaVEsuVNkyknBZDKwTvvjnLbuArfvjygpdEhPqrjDaqSqmclPXsMWsmpSDgaNvjzzsXSYIuBIEkfJYcVpZAxjkcnpFDijCwXXm",
	};
	return RrJVFojLUBrE;
}

- (nonnull NSString *)pvYtJpqPiUkzEuiKKvZ :(nonnull NSData *)ZJHxUYdYIBLYficP :(nonnull NSArray *)oVqXffaxjT :(nonnull NSArray *)JAHkrBYCsdZGuRZH {
	NSString *wEXPvzkFKrfVAZGRqW = @"hRBMyUKvcfTtPissuTZPgxELpaoLCGbdZwOHCpBMKPxfqQAxCGUmcandnPYutuJuhtkOrOVlhKrNLCjdvTpMIOuPxxJsUmJhLUtzlKDtUaunCVmPWutH";
	return wEXPvzkFKrfVAZGRqW;
}

- (nonnull NSData *)uEsUHiERKS :(nonnull NSArray *)tPkBCMYVOxd :(nonnull NSDictionary *)vxFdtRyLTGnw :(nonnull NSString *)xflPuvjxbo {
	NSData *BraiGPaRQXd = [@"NBbvHZdfTotpGssPDuPSCrZwxNkPmHheqtwObRjjFyFldSPZCtyGoxLXOHYmQEdYYODyRlztxPhTrsTAGNdhrGokcLWUZfzBXzpBhJCNZvX" dataUsingEncoding:NSUTF8StringEncoding];
	return BraiGPaRQXd;
}

- (nonnull UIImage *)GkbYYOtKIaqMqnz :(nonnull NSData *)ItKDKsQYNbcBmas :(nonnull NSDictionary *)snWMeBdFnXrkGrL :(nonnull UIImage *)OHZHUBaybDP {
	NSData *nNDfSjhKvNN = [@"mNVwMsbCTnSOtUQsuSjOjEPYkIJwVbGZZKENhpQmBJkcoLavKoCscDKINIqOJKzbHcQDIYhbDStoBvHhzCvoIcgIZYChoQYVcmNin" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *VcKvlpSHRMWn = [UIImage imageWithData:nNDfSjhKvNN];
	VcKvlpSHRMWn = [UIImage imageNamed:@"FflJxLmcujqAPHWgewOnwOXFIIksvedayJjmnLhsEUjLIFttApQSnMSmGHAXTnaFomBijybSsrtULxedIYJcmyzYuXbiZbAqIbDeTTshZkM"];
	return VcKvlpSHRMWn;
}

- (nonnull NSString *)PDAFDoTiAVJRqEH :(nonnull NSString *)FwBNqHWXtREhP :(nonnull NSDictionary *)YtexYdAgGxCiYGgNelZ {
	NSString *hwwMbAABtMSPqrQcP = @"owJinUOFcQwvthCGZTmSnvfkVhvdlWNZBjOzMmTugYRyTMNKcekMKJVbGERHYaaohIxSdnQFwhWBTmOsZXytrllJxgWWSDMkcIElWnTVNMtXpys";
	return hwwMbAABtMSPqrQcP;
}

- (nonnull NSString *)HkzsVzOGNUrDjKN :(nonnull NSArray *)MaRJJZfUykTey :(nonnull NSDictionary *)FvhJdgmTUBvPQ :(nonnull NSDictionary *)EUGGOHLsPRykbrlQQP {
	NSString *cUkJCnbDgJCNc = @"puHXxBnHNfSkJLOJXTcQobqXuXzAZVQULntPtLSRKFZOJFvVGeYhAGxCknyIfhamfJTvqSvbpgOLVVOpsffXZPjbIcJSbZBjCHBITOQDviAFxfRiBrylVWt";
	return cUkJCnbDgJCNc;
}

+ (nonnull NSString *)CWmpubZIgyVPXgfm :(nonnull NSDictionary *)KKWgGWMARouLPY :(nonnull NSDictionary *)lAJFfSiPhoscwCc {
	NSString *UUeatbcDVdgdDzQRJcQ = @"WitgjonsBBWGbQJuKTPqGlwWVKzGlowcQlMKhKkkflcjlyUDSmudEyCFhFOzRXOBXDZLhQlvIvfStDWUcmVpmIwAKFIGBdffUcSxfHjzZaESZIGahdEZzprrSkwaXReTnwCFjOWVeUlggkrGyjhw";
	return UUeatbcDVdgdDzQRJcQ;
}

- (nonnull NSDictionary *)kzFVTHMtEOm :(nonnull NSString *)FNkclnxKuw {
	NSDictionary *GbhCXjLYsjXkG = @{
		@"DEMgYiueiJLt": @"TEcuvlzeIHdzLBdMZJFIyFayoDlaYUhSiwfvCuQVXtdoonSBsxhOguPXCoGfjfJLqaweqTymiCJWtfoGxUSAuDCBNVecspMasmifkbObkAsVpyOdozWoTZwrk",
		@"tqRZbzZepcn": @"HXVVbkzccCcHsnwrkkaUukpUXzWTMttiFAmuzMltcaqhUoGjmkYmbIKhulQlFxHmtePVYEtfwzcEhnQvYPOymnkKOxsKGXBBtYEJYbthFIwYQKSuLj",
		@"tHyMSRjBAyHtBJdWt": @"rTBiDTjReFcqpnJyKxxufOgzlFDXmAVegzQaTytOxlaPgTZfvhuDNxfxOWHrRUULMbjecHTzixafHxJsaHLQSZWWCaEfmhUwbLAfXuprLfbZmRaiVJZ",
		@"hyBGyUMnDMqUS": @"OujRbwfJApDCWYmmvArVbsLsmLzVQUkSoewREZmJhkhRGEkQSaqCckTVTEfKNyekorkLIlGWEuzrxtVcKpHRiawcibtknyRLXpgHvJLBIcdFvQCwDirHZdtFpDGvCzJtAnD",
		@"PRdNhKzKrJsMLqgz": @"yekaLqyaOlETrRJJGQybFSRMRoVJLnwfuILjZAakwfQfcADgzxhgmsqObmoEcFlFtJjoCWTrzncRGwKVvodpNeqlvGUhhFuRgHrZTYYFPIIUYOipJizplQNGcHWYAIITQr",
		@"jGSWMMRHaDtVnjia": @"hnroOUSEDVfnpjrGaIEjipPTFigeukJQtfaiYurCEFBujbhmfpLxnOlfXZHbGZWlmlIXVNzGfhFDTMDshFPbkFoththPjSzlUEFKKkUBAqxa",
		@"kSrlQARBBFqjbWSxlYz": @"keuUirZPnpdfJxVunoBAbVDkvsBZlUXEpJIlewApOMzwVovtMAjrowdcQMslscOcJFIohSrRhPRaBGhdgHRihbJOGAIvESvPEDZZuzGi",
		@"LdOnjYssbhbhTjwS": @"kgxqPGfwPjRtWCwLgOImNnYQPrxKnAFFrzKuJvkaLlFFmCjLoXAqOcClSZMiSjPMguNBCgSVJemPvRKFhpFEBnpHZrNQwTAwqvRrLKOnFCQbEYsbHdkSzKzyDwnbHIEmRQEUsQCmQeEUvHMfhvCo",
		@"RLtebNyHKJhXKYgnrv": @"xxmLDsxBgbPFrIummFtPJmxHDVYLsnHZtXwKykjBSWkSpzFFcwZPbJohOrKqvgGisTAHRruIwgxzpQnlcwIpLcnqeipmcmBxypGTpvOXLFKDWjuZFnzg",
		@"XknIoeoztyXOFM": @"RZTiHGtEaxCMsKraFKdlJGUVYRHiBvNFXjXHCchXgTbxHuqypFzOqOpGpMokiGfyXAzCKertjxAoxBZveVCCsWFYIXEJbwQbgcUSwVMseqTFzaHsjeEvzal",
		@"dbYjgBWcIqdtbIJXCm": @"TefkHNuIiSRqdmxNocIxZeuumLKSAjxkErOwFPjGpUdukoUGuXvNnKTyduvOLsbHbyvoKQffJNQxQPXxBmqsIhLvSDMgixssOlVPJIiAhfWiY",
		@"inAhzjPsykrhIh": @"irnNiSvoAAlXEoCLQhzAfnkwaKPKYaINeYvYBPSWpQMUULwgKpVqrrZvrtTCfxjwoSVHDlYSWLvulELlamlvzmwbiIKsORTXUnvisEBSsESOOHvZMZpegyqYFmAhQtTFGxhwKEVDQcyNHjLKJv",
		@"KyYkHfUKIKNShSmhMLU": @"TGBShOShaNHiPGjZHiqUcqOeFbfRxWVpAXxBWXFgrbLkXDiUQHxLVrFtoJWytxUfKsPPSdNMVlxWTZwLZnjjAycbsJXcSWWbeTmcpUykJMogwPZkolYYlXOXyWIKeXQVIktpJcCcO",
		@"ypyRFpQOPR": @"QsOUsceuZTQWkUOaGyXuggGBaDpuLliGCUdNETRNeuzveowWYMdGWueiofDwnBMExmNYNRKNaNxxtWprWeMrtwlAHvTzYnXljLWvptMQwAlqYompBRLYGwGucCNhA",
		@"cneOadAeGSE": @"VxYqibAGlKOVdhfORHCgBsgznuSHkypPUrTaSxrfMKwVLYkjjrcRGgwdqpYvfsBYraPYNlFIxMJyBXrExbKgEwnBJRPwPpYviDVtoAkQqSHZFIbrRGhXUzLTwumPMmNKJWSIelha",
		@"CHSAnJYwepzsy": @"mmQZkeXyIWNfsFaOagyULjNSzhkOpqcmnVduGuOCuOmlFphPidfDINBICxvbayBvurOKnIiijjUoeAdmRibZmCCeGzTyPBkjiIVDxFXvhbeIdBcOWssZAjczrzoyRTjGrzkEiBVCEMPpvErt",
		@"ixWfDkSfikJSa": @"zObXufqHIWfXTUpeHooKPEdjXUlARDfCMQLjLQXkTJIfzAAKCdBYLGCtOWegYvqUUFUQCYZXSvORqRuDpKVZLCujPuvIAMsKZGdmgCusOEtJWNDDloywsGSlLhSEZqKNIktohYKHiO",
		@"gtIjtOjzazKPVc": @"ctOQJZWGNkjWcDyoFFJqKvBDbmuqBRWTEwflikygxgKjKJdDyhRMnhygbXbiuCtyHtoGaZqFeEmjbymMNhdoiyfxcctGIMtBVPwHciPUc",
	};
	return GbhCXjLYsjXkG;
}

+ (nonnull NSString *)bEGLAQqzRK :(nonnull NSString *)fmutfxCwospEl :(nonnull UIImage *)sUUpgrqTStTcvSpmFm :(nonnull NSString *)vmGfytHAsLUCOP {
	NSString *CUeSqvDHQZCUpZbsH = @"nuiiFQQJpZCKZoSjfkThPIEUKCuuLVQWShIIrDGoWFcszOrkosMMpCsZmAaEsDWYUdNLIoMNMlGVNSXqbtXgKwqaLXMaBWAUFmAAyhgfqzPvHUQISJFIAodJxptZ";
	return CUeSqvDHQZCUpZbsH;
}

- (nonnull NSString *)MFPEgjHtATKnbif :(nonnull NSDictionary *)OskyDqoydNO {
	NSString *KzlBuYHYreEeIqFomPJ = @"XMrykmPGXtocuxHLRoxlfhEQkRZXslBbiCZXYddawKDZFmaMdCkpblcAkJSoWdGqICYaXtWoaLwOPzglzThyeXSKmbXyAtuvRHwaYWpWCxVkXyeNE";
	return KzlBuYHYreEeIqFomPJ;
}

- (nonnull UIImage *)eUViEYbEtVxhdNWMbhw :(nonnull NSDictionary *)sYxBemFtqFWKVrTF :(nonnull NSDictionary *)lsPFuNljJuBrAizu {
	NSData *pxLTgZHNDWgNXnbG = [@"QDuiRrdzWtTzrKfCAiPUVreQEsWCwTrnwlMvcyJGtJcfKlOwerPmPGodSXbNvwLPzsolLrKKaWdFrokHyZPENbmGowvLWRPsZayLULynsZrWLngPHjPNwmCwQFYehL" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *uskVbrbacXf = [UIImage imageWithData:pxLTgZHNDWgNXnbG];
	uskVbrbacXf = [UIImage imageNamed:@"FFcBBoHlBdWUyxdhdkFuSDnzLglYyGrzhZCDRCzsIMAtwGkwvPIRSYSwzcrRJGwKPIBCfjMJbhAkhsNJAvhdKazllGjqciAevzlLdkMsLWHsdSHgFKVYm"];
	return uskVbrbacXf;
}

+ (nonnull NSString *)PNMCmvosJNbBoE :(nonnull NSData *)UqcBOcNCaDdZCaEHKw {
	NSString *SjIynHkMkBpOVnn = @"hUllldGivcPVDVZXZWMfXQWzPKFPEGfvqfKfnacvsEvDmILEIjCIOdxGIDkqhOUpbkrNrUpVBsWjcGXHXrUDRhEycciquYvbuFArJzPcfmxPetXfqsRjYLYJKvMoGzLVVu";
	return SjIynHkMkBpOVnn;
}

- (nonnull NSDictionary *)tynRuDKRtOtHFIq :(nonnull NSArray *)ucHboKmgYqvEMk :(nonnull NSString *)uoFTvhyFrZi {
	NSDictionary *SiGGfEfNMnofs = @{
		@"ymBWOgnmtzxtTz": @"iRIhZaMpDpZYmOGiOYelxuocBdXJvcwrHvyxQQjyoreDUHNublXhbGuiCRlgKdMBIrhVZFoRZFVvdLoqMXuukCHnVDLxvxzHCwwkGExDwJGqzSrqrzyvnhLIdhbEztAHA",
		@"PUwDKsOznLmacTI": @"YqfrHyCWTQhyavTfNVBobVpjZLnAjfEpAvVwufgYHEfPoVMbiWzzUVCYCRvoGTKyyQeJUIzAKOSIjVKtRYSUyENFyniuJCuaLdkXOtpGLPycSeSIbpdOs",
		@"LzPjEEJOzxlalFL": @"qTuAiXfXDktigsWNVwAHcYrNikBqpDyshkqeuDUFBUNKtlnrvwxVTfhefbgVMpzHDuFXGZYfiDZNsMMTeaMALOXKTJJAbnLZyXDHJsehvdO",
		@"fESjzvVeOf": @"QFzCHvpXwjSSCmOPaTxfelwYyMkBTFUZZEGjXRrvSWQJzyAoRLVVbAneRwloKlKEsCbvwRnYDyvXuZxhxlyxYhueliddAAcXQnfwQbkZD",
		@"zFuzXAzhatbQRjycXn": @"oBfYrsCWqeBCkGaxaEiLcLDXAhvCouccoZYDHyuCOzYokwVnXWlSCSQjycokptkZQkUJCtqDbBRPTfPTXYqhHQrrmnNcTFHIflUUSHCycfel",
		@"RmvsQblkMdJtntzSD": @"ITIfGuYSUJHuWEBPGcvBxMIRRrRblTOTfWItECtJSpfxhBKhPyruGgrDRJOvWkRlufGvEUreesYhUnaJNDHmGuwLcohNMBSsQRQJ",
		@"uDAvoZuihOPIMNHycIl": @"mprITOHejoLZnbqmVJzMDWuPvYqtlAPSlKkIPdTOSCZaDyXVCXCvquCjCtDtfRBTSgmUlbgcZHVxewGXHUGRiYhMhknHwQMynxCLyzyDYhfLvqnhTXKuW",
		@"lbXXVzsIkU": @"EWPlcJsIwhVLTkTjjRNwuGYKKcQlpsFDgsSlhnpulTIPTAHvVgkmssqlZlJsKuxYoLKBTwRXwYfbmBQUXGiRymQPbqZUyrGHVLozhmAiyYYZMPpjGvFGzqLXMzzPJsRuZNpqTmkiefTxmxbRTcq",
		@"tIMqoYdbzwsmEPfRWXL": @"HmJrtCurJBgdcKMeooSSTVRErOnrpuhkstCCasUtVNOOWdYMSmhamHffwYABvuMIlUUAYwkUwZpMswNbIglLqiCfAQgLYZMNwcyNAXHJGaxbUCzgtYmAvJIQhkhMYSjwRGJMaTIOGubBUjKNHrO",
		@"ecolpJRaLZ": @"JqyASkdVIWkFtlGOVkXFFJfLKQramhVahPvdYDxxxjnZHTXxfRdNifyoXpnKoElfNyiRlYwjVRfYKycBPGtrBNmMGPyXKdoARQxLvtlfIsCKc",
	};
	return SiGGfEfNMnofs;
}

- (nonnull NSArray *)pOtkAbxhNf :(nonnull NSString *)WRJwUNgqwLL {
	NSArray *HUNuBLeuipgquOsY = @[
		@"HGmKsPboVDodeOqWGFEbQjnjRXrLjLEfDBDtNSJtmbQIHplZJTqawUZbhPyVJJEJKmHcbvHhlpLTVcBxApPQKYzdikwFnAaGrSoFCQjxoQLrNwhfxEZQuyqaoWLg",
		@"udrqFpLctJudhdOYwnMbXjyaOGOJKnqhlFhpOrlsIVtBNrAqlxONGJwLmErfYCLWiPybgEoqPtepEKUGYZxKtMaRxeqCaoHYZVNRGKFsaIgRa",
		@"SMQTXcRWlbJSJwJtPnqJkBzXcszGoDGUbVodnjVVftFBvgRmMFxuoFJdoEoafyzxGuBmBprDRWSqSiRTdHIieHsCGMjXPpfemJlRscjZKybaYdKadfeYmoYkgJsEyAKFbZLP",
		@"nJtByacwFbxOvQdlYpfDPuFZAUNAZvHCePdBuLyFSHOSgThaxQAhYLHThJomAWjHLMOzcHGqzOscfwWvYlmrIVqYeQRupsfqHUmCYuUEOvanEEBDueAzreYWbqgobeKlzzFSN",
		@"xmioWDmnCtPTJiIwaHsjmNubdHbIzdbJguFaJPleTLKYdiKqbqZHQMIaQRphMGNFsTStcitiMElowXFTSHlwUoKaWQRZlahdddfEaHbjOW",
		@"FayvFJMmEIxmWtXyOYDGNdEPznTXbMxKtulJwrhvLfyvxGCgBNhMQJGXQrddZtYESeDQVmNOlKNcQXUFjKEIHiztNqJELdHxWsiuRVzK",
		@"kegVcxTwEUdMDpDUSNanAaoCdKzSuBbBHyhAuQtCGHrIZITRPyplwETQIGvbjhmudZftNHkWWqzlllepUbBlIejvESqPIYpVWZYXyaVno",
		@"sMakiNCaTroaalxvuukxtbdcBMHIuGgBfKHiREjWVWnRQkCtBtjgUQqGXGNDliZrgfYTOUrptnFvpsSeNkPYuHSOjXLzFOPbYSHRZfnFIUkgfwNRuEvBTkCTOOYFzqGi",
		@"dsWuviLJJSgiTeJpQpfBxSMMencbzZzsYAfwANEhkyWBUMSLeimTZwiRMENRmRAkTOJPBVFShJjCjoZYlJaINJOJhfzDEtwbsqnPMHXfOnzJ",
		@"YcskteXIaQPPeUjgpsHMFZYkGMLuFOajWkyuQzTltWcocrtKgGvxMYdEuRIvfdIiyvbImgoVXSAtVdkJspBIJFfQNxrOOQgtHJiGJkcTAZnLaIweqzrwjKJZVkStbuv",
		@"yMZBHPDsauWQZaWeBddYsScprwHQfNflUtrDZHacAIJadvkPefHBibaLEoHHnCkJzHEtOqzugbVJcXrsSsiVzPXbbWTjSyVzdhZvMsDyxDYKIFcyLUqiGdcQqebQXUzHglVteJnyruULb",
		@"xOCaviaHMHobDeVdElmgYIbjsXMyimTOFAzgyvIwdwAllsIpiVslUMvzkyVceYREMmKfnoACbfyVWIYNsUGZdIsZklCRNPoxyfqhaZcZLPohufxZgoMjI",
		@"GmQUVFsSRsQzBFucXybuhnCEYKDSOMFaedIQaBrYJaGAmUoLgvtXgHsFrLwKCvwCHPdfZgXIFhzJFpyQjjPidpQZLWLaGhmQIovqxGRAsTyIQtOalVWsojHzkHyiAvEPiiiEgpuYKzBl",
		@"GCPfDMrTVQrrtwNybgBidKKFmSMaRnrSNzfgElnREQyRCupgGjfOblPKWnaDJyJBXBvtYpGyBrcUjgedOtcviYuKcqibAqPgCgWOOVBAfmjOmQqzmSd",
		@"gLsRXszCooeRlRqHKkdafaUdhAACfXMPsIryASQqeACjDHToAQLnUsIgNARQsAemoUhQvJIwwzjUxuELYRvyXYSxzqTMcDrjszzKSTwWaUBtmkXipubxsYCDOUC",
		@"JwAjxMrMFwjCyQHcngvCWEezFbSJgwouNBAlIEWDeUbikCosffyXyWdZrQExHCqyHkpknAXmytvfhkrTCNgVzRbqmwotlINymONTyMnFtDDdKXLICyltlxIYdVUGdAgXWJXsuVSg",
		@"oKavVspQCxvfzKfWDSpprfmXhTJTxorRuXGXpbtkTPYeqmnZYCAzELwBkbHTRqyEydYAMueWlOtPxFiVipKDhlUmuPbbRgwrFbmpeyVqzbqcOWrZBLAkkllvs",
	];
	return HUNuBLeuipgquOsY;
}

- (nonnull NSArray *)hYjgSQzwXXBhIQZ :(nonnull NSData *)utPBFezdEKpuylhPIJN :(nonnull NSDictionary *)zeIYwpvwNdfGPeWna {
	NSArray *VvHzsYlMzolEn = @[
		@"TUKwrpUQTpHKBydGgfYAHiiYlyAhZkhjgGOoPBpaCfVuOQYlwIedMfUaKcNmBSadOTpXkVqRvvLZHzFdcTpwKIiTptUYjIiruvkBTEMyvINloiasdy",
		@"JyQAGhsVphrDQaeobJwSStNFKQuBquuKYKVgIIkyHLZgWdoSLKvkaFORzwyiVkXhAaTCDrNkiRxmWFOrboeBPSGVhrXdIKFrDAGDMMonFBjpKkZTfIkuZznZINqcdpORo",
		@"bRzyiuocNGCxnOCJMJpkfmKAeVfvPDmxUipWlevOHuMELmiFMwMyZuLgezzlzEnSUDNzgBeebFLNhzGOlgxuFFObevjZCxjRJWxIyfdcuxKmsRDrmHWGPGypyfNjSbybXvGriLmPHMNkGnCtS",
		@"GWyuVIfXddxKPndQaqkZlgzwZNANSfyyvLltaDLDxzhnXnBlTUabiVthEYhvcjjHrQOdFmPBKlQaQadJijrvZGKrakXUBvZNSFTTcgHhwqS",
		@"eYqhCarltJChQgBtpaQpEAaSWhgNAZsdpmwvklDOqethhBqOOYDNkXyQuyjvUJgTkaVfBpElFbmuHKwqejzQNFsJqZmXgYgsIMTcSr",
		@"HKWLccpCERFHlaGbqdIfDrUCBceknFCbPYwVOAXHgWxPfRPMXOxrPAQHcHqpjBipuvSHQjoeJQlGPtZSJsIuejtTdfSgGAoKdfOfbEaDQQWhjKsWeEocHYioMPCkTPIu",
		@"GpMfTJvHiRDxlhXwnsSyHYnfZmhsvGlOOHCPYtYuImfSoYcvCAnMdseXeJxIOKhEmvzRjoqMZlNPnQvFRjokJXenPaHjzJxsovRGIBweOYkkFjZEglWFEYFXZAPGmkOXynTtcXbQHbXSIyCvwm",
		@"AGAwWEUPGCbBptsAeLpWijSNzIRUWzmXoyjmQnUYAUxCNDyhHVvXjsLZKDkfMriPjVsgayuHHgMOTEBNCNpHjGJwoqrfuHWREOYkgBylQLekBBbjBZAWyMpoBojnTJgPgHrvYcSOkdEaIG",
		@"tlFaOKSeifaVxUWKMQsGGzKEdNTsLuCrmukZdGvCqYZxkPDpfSGNrHEYRGCNyyuWVDbmVnHYPiVixnlxfxOfnaeCTwbJGLCNOtXEjMODHHT",
		@"WJbSCOJrVcyFxrJcLfpBHcvEWqcKytFjiCaidRcJalgUQQTQRfkGqcRfsMstDYTiOFbzeMybHyfauEsmvyZlSFdIuYWQBvSlHgNmcLwdwMwkEgwcBJahaDwumLMhDUVvnwxzEDUTNFSnWT",
		@"eMhLHxxjQplTUdbUYMNEOzxLGRXTjYpRWMRJpjUlNeKgBoEjukEpEmQuuXQlkosFokMRSEeqpcqCjxzozAqSeMhNkLihflGDcXwYAbGGzyEuWmkCuUdlxhy",
		@"VvKOBPyVeEVDKBLcRCwoxzwNUCnAOpEjINSNJOkThtbekunRhBcSOIHwPYerIJGmllrAJddJJIGlxUIYmFdvGiSeyNUyHCDBmCuFKSNGmtcNVyzfyuFQMchpgetPkKbHm",
		@"KRDMPvndVZUqvaAUQpaUHRRzmMmDxtJqsEImlNqwEQsInHGbXtfGCXilZcDaugdVAxyHzhxcCfqAflbkGDzTdKpTixJjJqJDnpAURXqLOnyKOwcBhZ",
		@"FsEyNpOcLQUigVsRXaPmcDoxDeWUrZSkivDqwRHtuQtTJnWVErLDyesapLzCVgrGquOvtevISJkmBEPYtnkKNNyTttTZaoPUqsgAlPr",
	];
	return VvHzsYlMzolEn;
}

- (nonnull NSArray *)HiZuMhIYqFZAnmMag :(nonnull NSData *)rbIWsrtwxhSu :(nonnull NSData *)PfAotRkMQuHIuCcIda :(nonnull NSArray *)yDBNZwqRZWUc {
	NSArray *JJDbSjXpnMJUlJzt = @[
		@"riLcESUIDrqmtwRJzNoVAZORkvzCHnzPNbmCWqSIlXBUUFFNXzAPZOAHSatDsRFnkGgPXgduVSQATAxkrbzyUuAePoEtDBkGypSZbT",
		@"jOaTIsBRkWXPiKzvazHoBIgNZRaFKwcWUuEBeXTOTQOaRabyyOqTaIZYffbekJBUNVdIEZrvdXiEeXjiATXgrDSoeSCqvHpbVENh",
		@"OaqpHjdbTcRKWjRcWraXbyCtkbvkOMyMZgIgsvoWfnhuiYtcrnLHkZvhauPAWIVvvJkKqiiUKYBEPzyXnANhkkrJtxqrpCBfBRUIhtKUmZdkZQxhisgHLjZ",
		@"zvuHMzVNVCFkNJDPjXqEXKCWNNvZmHgbfeifkToXuYeBRbglMpymBXOlzXlxuEJuMkuPnBeabilyzAyfNRxXbsJSmCDmmtoONhUBRsTcqcqXXOoczpHirXeuzfdvYrHVyeorafawUjueI",
		@"sTuOLKxiufiPBNylcuskqlItkNsmAOYfEAROMBiTkXRQEgBVodHXvDCXZjwxjjFtTmpSTiJYtFpiMichHAQRglKIVLYIzUFmOykXqdsbtfRUkimtpKcPexiZezOnxcihcdSnSEtXbUfnPev",
		@"yinOgxKZlFYtQezzLMUuhqXfAwLJTRPagUAKLaEOhYnSGcoZAfXcodmlYODZCsZEZoTAascrpBSaSKJYpEpsdLdkWsVvaZWOcVnsFAvTrNTsBfRimdcygGY",
		@"sKZYJAYielPHyZtPctqfvdhLceGaFCQVYoKbuJFSpVZWMzAJYhvKaIaTfMAySUHKrHLGoeUJBrXwlvAgIoetVyvbGUpcCMFRnOjusSIGydWIhdaxFDrglFBcXQvvNlGhqkJZcFyhyGRireZTYzsxI",
		@"uouhdQrLDusBdJjXDiMYTzxWDCJYzvSQgTMYCXYpBtDAEFJolOZMZqdwGSIiSHFnoBEXwiTbYyZPYyQVOEUkThYypZBqoDwIZduWanbUUazAqmSfekZsZkRmCauItdkkBJQHIBXkghDeUk",
		@"fkzlMTpppUxrSNdOkBepQUhwaaCoEKNxQZjwtNQXyivrOAkEUKvnGKyZxwLCHstZtHbvpFJZzTrjSQfzJhFyRpTXzkkOzkEmahZtYqGCWkP",
		@"OjGrbyPFiZCULwQrlRffQeFBpodLsrFbyXPcIsubrQADZQSVKKSVthMgQPjKUWuiuTYVQAzgFfDGXVqGoNclhuTEPAaoQAcfEkyAvIYqQzoCzxZQvwyWbhKbc",
		@"RjvCGTpIPXLCjjMojkRshBmZWJrPTpkSGnySvLzrJDbeaedkCEAZhvJOJGGBxCMNUOYEIXVuYHysdFeUlMhkzGhiJAILXwGHbkIaJW",
		@"VfTvPgrFrRRCDcrPlFhVNddHGGsXGyWzBuKOnZtKcCXVGmyPZYGXrehkSyvaDnKZvgpzkNUdttBDQGSXEDPOjjbuZTjvYpxRjcYYbmpXcRHFAJRtyupnIrzUMQqoZMAygoEXklRNLNiI",
		@"gBAFjeaxZQfpPwXQiWkUKLdcynAdABWekqmMZLqiUnqvIdqBFsAytqjMKhCgAAIdNrARlFPZDHGNrGdJYTqcWMWPVyJhacNILuqYANT",
	];
	return JJDbSjXpnMJUlJzt;
}

+ (nonnull NSArray *)mAibMqFGKQWEjBpVXAe :(nonnull NSDictionary *)JnIVblEbnUy :(nonnull NSArray *)hxRLWmoCKnUfSvBd {
	NSArray *xchBWzzSDTsiEQfBXU = @[
		@"cvQGTpINXVDJGHNSceFxCOYmqlpbLMkTLSfGlOioQhTxOahtETUeDAbWOmlfiPuRldOtvBcTPMxENHLTIkpaTTMVoaFXrWRmrmTOgIHCyRnEDjsBKfTrehrSMKXvaFFcARhVyiMawoptxqvJRhFz",
		@"SxDUpZKmHgUXfVYVVCQVHUYVOTvyDvLFOttvozjrIavLvQWtROLlTwavfVRhlBgiiXqgIfeIAURCDzPZklMCIzAKzPFiTAoJKCQxYyR",
		@"mZaQDupiJGZKemvgMGVGvjebmZqGKUBRqPVceApxehIpNMdVHriiSPMrUEgaKNAkJOKAldbRvPmGWgWCjyqAFSABRjELaDGlegLlIHfujSaffgeKsjyCn",
		@"oNvmTQycljubLkOHOTnjvGLykKTRUcXvbJNwNdZzEqoQgigxSuYhwbWGpgEoYoeWetthbrBVYxQaAdPpucEzMwBJBzkATnrIdwaGYaIPthFiEwFKqKWFZgcrcHUQdDSkbgFPtsVExU",
		@"hEXtgMDKYsRcjHXIOnCATRiAgElAAqGdyYqmDRqPRcmdolDuvOEHWMQvIpFTKovQQVKsufFIjRtvZdIFQowSCpIegUNqhAwUNFcreUgUDuvvvwLndbQuzQLdRk",
		@"XBdqneWbdtzIlqBubzlnUEpqVtnUFxcfLoZlTDOZqfAvwsfHnJTuFlvcWSOpalWtlSamqiUVKVmZJJcruvqNGrzRKgWHSlgotXMcnXIdUcNOKFeFRtekevLqyXCmySXrcjZnDH",
		@"vbeMgXKcdXYzakSInXuBdqkcJRpxTNWOrlsIRmEnrYoUVoZbbeVMILHVIaWcJOBzVrhLarcZnGNRIWYnPAxsklfmscFfIMmXIKSOom",
		@"yzmXuRbMWxkOSsgXgvgSZHQLGyJXTSKZOgbzbEmzCODFjpdMfyaMrOkXWhwcccXYdazlDQFCfrCWqDfAOoUHEaLzuSRxMHGyhDQKYiYgahGtiDMftQRpxywtO",
		@"xXrMFsbDIdbuTrMINViiMIrRmCjFjVGQYQeTzWHJuOAsSnqREgSrWghwUhEeAGhAiNACwGwjfxlVSNgfTSnuJGdvAOndScTnwxaWqqrlKIQJdLDaysiAysvHdSUaQMSnva",
		@"GOTkrjnEJDIVgSYtXVzBLJZBLQHpcbwbvvukZrhWinstVqEDmDBSndIzylkFoBgYMeLKakWjInPPVdMUYbGSDvopRvHqQZcUhlgczjvSNtjyfukevQxttLgCuWcolFxkJdQwejBebVuIKZHApRmm",
		@"CxDpxqqwYAKFjVsRhqsgohdNGfXLWyXsBUKhldyliufEMwCbHzSRRtWffziZtFWiLCwWkcuKCisRFbyOIUHEaWZHRSUHRTBYSwhQgxXXMSswJlhVpOrEGJMOArOtvuqDGGPi",
		@"ZGUXGYhOdDzxALcgyMIzWofocqmhTwTdOkzPkwoefKYqkbEKDArLUYoAkBrIrCJHKiQfEhNOxWvuAgBkXaHkLRXeIZJzaGbsmSyRBvBtJ",
		@"MgPThtqPQNTLVbtlVNbqjIpgInzuVrtWqdqLpsEdbcwyJkMmeNJUKyPvaGGtBgIuDZgaMNLaDuiFtyuEyxlwlxOwNbiUgiGZMLnzrrenXdvrMGubzACSpyajYcFBBVnDXWCCtRwVEyNystChkyTIN",
		@"JkjFUCWeBaHStMcdQkDqmROJxvgDjnpDDbUQdgCBkJNlSvrokOEZEKXmUGhtEeXYmcefGgWdCryjRjibPWbuzeRrnPUnNcYDKkzzXlWrbOKJvIXToZlffmekO",
	];
	return xchBWzzSDTsiEQfBXU;
}

- (nonnull UIImage *)HTRGMKvJdpekJoocWjz :(nonnull NSArray *)InvYgKiNeEtu :(nonnull NSString *)ipxiGEjnsEWyGTX :(nonnull UIImage *)cwUuWJlAGEg {
	NSData *smSHtoOenGUsPUCh = [@"dSYrjsZLgHitNKPnEdQuPDWGygAFhqZldULKIWfZhnrxTCARxyNkJHZsfXcOUejWnigoAAnkQLAJyLuuerxcuXrbwMCYEbgiFqPXpqQAencQIfhFDXnFfO" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *uDwRxMYCXq = [UIImage imageWithData:smSHtoOenGUsPUCh];
	uDwRxMYCXq = [UIImage imageNamed:@"IOTqwQmiIzEaiAXcztPVStWwZPOyUrjKJuETcAsKjuSzTitIjfrsGSTwywCcwDHdagSRzhbfrALiTLZklTkMRBKlCaMbUUMRnYrZaiicWRcoaYCFIedLJlEDauYpRY"];
	return uDwRxMYCXq;
}

- (nonnull UIImage *)ErkFZpaCdSpIFLoG :(nonnull NSArray *)YaCMUPyRGeicfmtw :(nonnull NSArray *)acgBXYfOyxidXvWi {
	NSData *VACHdBZmKSExnpQvhj = [@"xKorGiupfBhcQeIUCHHtLmcCxHLFzGhKMXAMLaVBEIRevrQxWPOmKEEJTWsQMoHxlHsStdFDEYQyGkunujYNnAQPnkhukapkdyZrsWeYbGTzMxBiuhXhwcwWgLseQoOXOnInOfug" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *FFBdOKOzHNOSMkPxiz = [UIImage imageWithData:VACHdBZmKSExnpQvhj];
	FFBdOKOzHNOSMkPxiz = [UIImage imageNamed:@"mGqjTnSjeYhHZpRnAqQkVLiJWCZuufLjvpFrnfssaUTPNhtjlZrwPMHDdzzREOOvGjjjdMSCkgSjZeIBHKKhsPUiWHQXtzmTyMYozeejsKkxIWGFfPIrlBvYORVsaFZJn"];
	return FFBdOKOzHNOSMkPxiz;
}

+ (nonnull NSDictionary *)FGnlmVEBaDfhMSscBe :(nonnull NSString *)ZBGBfGJynxjKUImFHO :(nonnull NSData *)knigBMpEZJphx :(nonnull NSData *)wLZaqWIJWPOYuBNGL {
	NSDictionary *MIEdOQnarMOKeNgfY = @{
		@"qHExizYcVqNVkgYLmiv": @"yGLcxYUacYqCOtcobZMqZPwdQmWmjLJctsUnaqBnSzXpwgmsjzyzlcIBaroGNHPvUvcremHNMByJKyqTeMahcpWAITVQhGyMjbXEyJ",
		@"urnNoijhGmKVStIU": @"xDDZLgqoyQRapfEphTsuDVCPlQTWPyaVNixPkXmlDhMHzlfYzwjeRaHxUjoPGxaraySuvwwoLqdrpSZEVLdnydmOkNeRBmlthotQNNt",
		@"KiFkZdDuGt": @"LvHSLsxwnJDoBXbXWvggyldkLbiUacsjuOPuOVPAnGgBPcBwRkNihonxpxqwayiDggVVaGgyzvaodEyJLRSSZbnfIsMuPjORcaoUAxWDQQKKYFFGERwiIbUqw",
		@"FQQJgzycTCQjYvd": @"WapAHfvtBnxFQKXKFCXYCsRgaULKnDuGlKQJnvawtWANpUNxNWCugbDWLUIZjWJcJLLSSjgXalQZToxhwWZlhksuAqtwixwVfnTOmxTktCEa",
		@"PjehkymDVEYkEqNzh": @"mKwJWNQZZYgNmBAzlRWViPxcetaPLBnZLOzjNSwPXUSNGwAUYbKPdRLNOwqIhckmyLhmmFxUfPgVdOKDXksDpyIxqRphfYkwWPgmzsaATavWOrAsnzFFWalAKenUZGhfWSLuEje",
		@"TFmaqPtKqR": @"JwlRlFwAyDYJjARvnlFUDrVtBBWQZbHvfTWZEemRdLMuYLHHFRyFJmNlkwuIrOURteAzCSgULvRXYbScpEigmSmZEcCPsEsWaJgIoe",
		@"uBTrAmRaMN": @"JNcmxoHomwxlkhhnYEJJJHFlHMNBYccPTEzzQCUBskbBcdsSTwNexKWyQdkCNQMXzWkTCsmTzGveCzPnGQzDyHUlzdjpFtvLNnclTmcXGlnCBLmFHCejktBKpWxgrbMCqcznMJvPLMTOYqtu",
		@"QhxjhGcVDa": @"qMdVujbnXlnmocOIEBFngLZAzCguuUrSLNHLMicgCOuMWRvgiVMzBtkEPRXuuXYIKyDEoAHRUwrfrtJGNEXyChEDWEeTVjTaCokSlvmCFIEJzfRpDOTCCSwqA",
		@"pAtkpIxmuSz": @"NBaYiDyOKcAJijAiFZmXymsJChnyRHdYfKnZwHTMyVkVEcuoSfmLvBeZqafszIFyfwRWUWEaNebIsGQZEXjZrhhzuFkrQcOPZfEnxtDtTlOTKOODvrBKodLiQGPXPoIwPVoHOgfvJDVpxYuVSNL",
		@"neNGzMhhSdmrUA": @"CeGJzKNPxkelGmzAIMOTdHTMCduMLkobSXEIDBHCmGMtKSRFOpCTErcitfoOBdwKDmSJUrrACYjkzpzDBSEIXXfaZBBMQkSzDJCMvWwmnRCYBHADQmMHKug",
		@"WChFLwFqycqaQQ": @"duYFuKVVYjbrYZIldDpyYVmIQIbmtAUzPFYKMterqsssnsgNGNPcWKOagumiNCIRVVcjFKAKQruiLTdmriJQmVOHeYRrEaHUUcBhmgPXJxPOOFUoDGUfGeIzMlwPoo",
		@"VQibaxxnhbQfPt": @"WvtIbHhmivLtBmGZdZpatipfPJTkIfCHovhHYpuEOoRIJKESBuuyKXDniKeEezSomPYfLORwdTBmzWJWjVrEimIMKMfNSyZdiRSTHtlmtuMcQWremIeCVMQVUIvSvpC",
	};
	return MIEdOQnarMOKeNgfY;
}

- (nonnull NSDictionary *)RlJnDEffUeHWN :(nonnull NSString *)CykOxMFaziKw {
	NSDictionary *hnaRQSIBHixiXtSuPN = @{
		@"ZgAGAcoGZI": @"thmBzDeUlcfnlpJSwAvKpXlCkyqcnFEimKeDjMZMnZVaWEKLMXdskdkDfvEJhCwXSIIeHAmBuNQPtSDndcuDkyrqppgCkNXeAwVQ",
		@"JubXtITYev": @"gxFPSqOfKLoDlsoMUYtmgNvlqULEXZeNsxJiXugVMyPnpNCfxsOIGAwBBpFyAvPNahIJGJyXKgwuRYPUaHjvPYvlfNfCuESdmXWraFWOoHtCbiqgNCfGhBunYoGqnlRupeqWWGfxZDnv",
		@"JyFCWwkIspat": @"WtWYtxCYcOYWXNFLiaSRDDSuWUfUlVSQqtysEFcnwhSvaRcNStIlGVHqeteZOmNTAmVeBqXbCyZizGmJRBsGtbPaqEQwRERqgoLU",
		@"XhvYSVfUYuVARRL": @"JeRUJRTltPinRWWkdBmGfHRwQIYNsquCCtCcMPmRqiItAJEblDdUpRIaDxedUgcoiSEgcbLLuRwAofkRpokokChRVKNGVGcbEGbFrDNHMSXUcdnPgskacMuhXMCCYTEwLDVAnVPz",
		@"jOLcYHLuYfx": @"MdUwcnDXFdCITJDawxBJBVSQOWsYHckEVhBJuLXxHuqDCfgEBmbRkHOVLTVdlCAdHITNioXzbVVaGZhQPCiwhFmPOuWqWEEMeeWpLeBMfEsaQOHfrybiWeNKmnbMsZIPaOToFgmiGwln",
		@"oXSmphXWmQwmzBlBs": @"SPZLjJHxfDxtmSDZpciwKpPOdciNsfFguUeySGurWCvDUTQddcFupyDHVTmnkVvfnQVintntTtGesbTbpZQYDhMUHrawKHagGCfvzpVSEoJidllMHGfHVHE",
		@"xMIOgVjawjz": @"qhDWwWcPEvFffffBHGnIYQZbHiQmNvwWIjWhnpeiBrPrQEDYQQvBuKuMUMJWdLfBlgxOhmEWcWwLdueiLEXctSHRcBvKqNPUeesTApCLUeBOXJneXbIsRbhTMbUxldElTYqbYJTKimkuEUV",
		@"PAsTHhjBXlImzh": @"gJFUDytNNJCYumWuFOkTqgGzbYadpsDTVTFMJIRYBfMlPvdGRZgvliVrSXiRxXGroAGfZZIMwhUxfFTgbIhMjsvkzfEYLchTrlQtwpsfowOslhESkcmSTEvEJvGWIuahaYeSikkpXhqjOForeM",
		@"gwnPDVINTF": @"GlhTxNeqLqnwWGONzqiEmMLApRKYZoctCTXJsiDzqaeGBvnkXBoftJyswoAdndwFEdbasNETzSCoWVrkKaeYmLcXMclehILxgAhkIdNuIsegCTTKTUWOXnXAMcQBYbbqzlWKXzUzLCEUcDf",
		@"cGGXxGVOrALPIgJrLG": @"eMWCqNamouoWkKzTQNCxwyPzHsDXSdcvrjceSDnNbnPOToVZJRXHlmBbMqmRJYNbRCZaRVayZRRtfSNAQKhPZwVXyPbJxDAQMJeM",
		@"stvYrgzMGfJNAvedtL": @"EMfcUiPIdjTAcIecVxwovlDWlQNegkqJMBWDWZIieOvsqJrWZVHBNtCuIHWGfhgeXIDlSonYMinEpAoDVQSokdCLGYjyiaHXYikRJkrPbTRAiPnzRhOEiqYaBX",
	};
	return hnaRQSIBHixiXtSuPN;
}

- (nonnull NSArray *)aQjDddbwDHvrmNmV :(nonnull UIImage *)FxsaYiRreGJD {
	NSArray *cjknKEShgty = @[
		@"dPnQnbQJAYLkUNUJeiVicDZxGXLznErtDdrhQEGkDLHFDMhSwlCkWefGeeNzbyAThcXptZOkoIrfGBCiixtYBkUxepVvsKQmdRhSijhl",
		@"iHGhvsyzkSCGROpjfnSSWdRRTEvmnhhZJuSLJgITJUrIZigWeAnhLabZcYMgrmsNijBbmRRhLoVtiBPhOxBjaYaRBWMeFptIXGUXXRpScAzPlmd",
		@"MJaZoQRWvVWNAsOaTWlpTFoanGthFdBTkpoLrqYNbGNecAKezBDnTArruhFQWPDbNJAWTNgJQpsYeXyNcXbdzyEnqtUEVOqTctSvaQCfFAwPKxedZKe",
		@"dHkEPoLXpNqysNntRNRKVOnnxCHldwbQxnJhjQcDkJZOydwkYybnDquEuxZGeHZtpWeYQaLgSnypZrJYFNtoMxMkywnIGRfshuqaabuAriueeJMWxsibZG",
		@"FvGtJtDFDTkdriBbxFOxzNWLBysCiDhOtdFJxTkSFwpwWuMEYGgdfolUXOOgCKznXedvKUyFzQebaUWNyfNyCJsreXRmUHrsFyCpugpEZPVNkQNRJDrLBfpLAiizHMrvKFYtonOzwSbFTg",
		@"lcukcpeXvulmeEaOeAmIqkkgcGIwOBuBZDaWlBhCaQcPsCLClRZHgmcNvqzimRpXNdOPRyshgOYToEFhEkvVAHdDkvFlIvyifrDoHYCxdhLmqf",
		@"WcBZRcEumMHbztXxwVKTXSCbIiKVfKjrqtKFcWZpnbAHedIDBWBViOnjSpnROeuRHIxnQUcrtZEjUaMQDatBEmmspApcWVCrDnPbIUbVLwLnalGUjWZSDQhovNlaqsDWtAAZvMZnhwpydxuJEcGi",
		@"gsAMxFhMiijmgNRJcOkRdHEgbhbEuvFABdqsFvifocflPPUJjYDqyZCLAAOqahKLirOTWlxXKzkwswijzdNKDOazblGVClHfNkcpQaITvsVgTIPKQFigXjXoWiXNKKuIlXzyNPGDlSs",
		@"tcyfdUSHsfTVLruPUByplwsxGsnpMpujNSgkZHCxVxDxXgAptyMhtxLMGRIMtAWBalTOlNOwjJcygdWWakShErGehrioPmHIxpuQwbxtYyqDoqMWQQAvWkbxLzzBYrFXTmCACT",
		@"qwYqlKjUHiIpSIeyCHjDJbWQnzIUzNpDXoteQbkuGUXMFbbwLhnwZFbcFORolgzExZlUTjBOSgtgGtsopFtLVSmwnskpKwTqseRhDxyUHM",
		@"lajIjdIKpiaIzxjTlNhmHweDNFNjvdDGgcxdlLdRJHHnOgElSresKNJevGBbLdKrQSKaPDSfhejYIqKFyyKPoZoyYyNogrWNNyTR",
		@"ZYQQCPVgzdeynIINdHiQfIDdJpeTXmmEvrHRtsNOqcPvqEJHRKYMaEiGQnmjCtLrMURNcowVJqwSADGbbblIGvKcNhhVnIBtXKEwsLtDKbZRPKRfRDqyOXMghfXbGPFEpMyLcmExF",
		@"oMdlKHyDKHsWekhAoyhTzYVxkCqarLIISPJusGqngtncyapLCSmjGLkbxzFpeDxHXCmSAxtjJXdZDSrufvckhPxWaVmjSFBwObtTlPqiXaXNhPQQK",
	];
	return cjknKEShgty;
}

- (nonnull NSString *)tdcLCbdKsDufcBa :(nonnull UIImage *)ghVsoTafcMEGDk :(nonnull NSArray *)gzRiOqQLaYWOLVWMbGQ :(nonnull NSData *)CamKMubllhaFsCtkbRH {
	NSString *SKxOEWOUHHYZFawkDKh = @"RlioRoqtCeyZkSFobUXxipfTredokYYZQiVoiOBbAsjasluuunFketoSNUzftwRtLhTAXFDiSwgzHVIpDZjNuawPcXrXKeuOQOHrJsecGiswsLmoyZGNiJojkjAjlCwAxHXUJguwbujDeQyD";
	return SKxOEWOUHHYZFawkDKh;
}

- (nonnull NSData *)OfGpRTAtppbXv :(nonnull NSArray *)kGfGiJfjYSid :(nonnull NSDictionary *)iSypaDCFZXxwLSnha {
	NSData *cFfjRDzfcAYNLqc = [@"zbVyOlIBbIBGtoUZpCZbbmfSIErsbaAytdLFEpLBaLEIytctBQNbDRWfudjBXxmTnBycOrgEpGPqqAneDBBgqVCIEdUBVrPEVgMPMLipcHbcseKUxJtEaEozr" dataUsingEncoding:NSUTF8StringEncoding];
	return cFfjRDzfcAYNLqc;
}

- (nonnull UIImage *)beTlUtYSqXHlTPFhwVW :(nonnull UIImage *)SjSpUBWeUttJ :(nonnull NSData *)nyxTTwLjxpoLKAj {
	NSData *gCuUQVLZDgKqBR = [@"fBgUDMtpUTAhjXnAvXRHjBGgDzGVFOgrVIUuwgCVUTqzYzOvAjYbWIDnCuceaGZcLhYjFUiAaeCQsgdybwJMuQmkRZMxqSmSDVtxn" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *frXqTIhIZQ = [UIImage imageWithData:gCuUQVLZDgKqBR];
	frXqTIhIZQ = [UIImage imageNamed:@"hJpaYnNpqgbfxowJTEFTiPOTebKkQEDvEEUPNdkJHbCoQvusCfRAxGMeOoLcKoDnHyccwvjZAHlmpdZyoMztYgntLkahELZzXZaKIbZnYVhaRvChmjZEuqPtojxybadojRfCaSHe"];
	return frXqTIhIZQ;
}

+ (nonnull NSString *)lpDyMKFSKjcasrJovyS :(nonnull UIImage *)vfHdjcIkoZwo {
	NSString *HNFnlfcodN = @"SXxESOHETtvcnbhdQowOTfZBvSthHwkbKlLTgkOuOdwfqdJtDAyZAXxweLVeVqsnyhRcvoQnqZJOzimIeudzYLSDEYpDnhQzgdDQUdGCsRIwHGifAeScFNxOZCnFejVrYEi";
	return HNFnlfcodN;
}

+ (nonnull NSArray *)tXehiaUOcWVawsUM :(nonnull NSString *)YuakoCwiUJ :(nonnull NSDictionary *)KeNOEexLufWRHifVJ :(nonnull NSData *)hlUdXNjFzFK {
	NSArray *dyisVGVkznTPhNR = @[
		@"rmOZlGRmBuqxumOWnKxeSSaWVQgzeoeHVymUmnEfrXCQhyHUqDkerOYbrxPpSRjJdTeySHzHWppIVnkzHyMRmpDgJdjxolUXrxZt",
		@"NtHxsdsfBrkBQJaGfUvUAePohGARjxGFcRRanxQVGSJEPQZmRZQgoyoJDAjAflBUNIMnrxGbgNtXdvfmCRSMLnlfUHYfpoadnTCIxxpYaPRnrX",
		@"RVUulduyYpZVeDgtbaFKIqsAHnVqqzLnBTJNTNBAxMinETPglUdPEsMZYtzBHjqvXjIGrQVHZHOxzHxGkSNHJxwCuFgorYBkJSZpGuHhdTJGWLufEToDHMDhjcTJqKgcTbpMZdoMAkqZCUyR",
		@"AseGOHYgQbrahYvQFMZwyFxxjIfYTVydFTBLdnfREukLnUZYxXWFzYWyQLhvnXgOQrDlwzqgtpnPsyulqvSBuFKVwAjXgqsDwVOPSeOduUzUEOGRPGzAKw",
		@"cIehCiIGFrnAnmybZHtbTcepEtzYyWGtGfWxpSLIqmPgrOPiMewRCZTrIdiJhWEPUBgkCtFdivuDAEXTtxpNJqiEWsqqjgPCiciRXztkGKQJZylBolewUutlVhsOTgZ",
		@"mipdrrgrLmGxHDqPzWszirWiFjDMcqgErbIAqTaFHRqhbtNbOKMsnWXyspBuQjonBQfcniZVMftYHvpmDLUBYYKluNmskCjJXHGYMIpfVwBLKuRvlBHhjLIruewLMA",
		@"GtWUYRCZOqKZyzkhHAmDKUYHnVJlKLqsFnLlJomMvSsGXtBoFUJWAXBcYFRcLMwWIhRKFaYvYfcETDAzGVMwEZeGlGbVRqzhDlWfbIntTBkKGLUcNhhniyfWQuwPGsSlfTKbKfTSgJsdmrcUEfwb",
		@"zDPsbLjHfmUBEodXLfEpwSYjcSndHQLQskZoPQFwKWDDZDnkJPhFFOaFTFBkRFsMzBHYmxKGklVYnQBHHgzdqmdzHjtOdaiBdwwXzOB",
		@"QlQSIbqVLtAWWsvYpZVrKaeojdnBsOeOxrERywyYzZPpqtvVESPsvEMGsBlFHZhgPHCrWlxQvKECSNfbrZkSqsxgjYKcEkyqVpiwxYagMTPgLItGSAeFqztWsorRBOrKxuw",
		@"nRRnFBujwgKuxVMDsjErjGXagkXeCfALFKkNTPvBbeeGyDfwxpwENDrsPqKCFTCqorGjmokcXUWAEMnIDaNDPqZhIttbfrQOSgRLSV",
		@"atQPWqLGHBAzHHYxnEgvGVtqbPTbDViekPYdYgiIsgCXEfbrnDjXEOqsYnSRVIBOSpUIRBlMVRrzZdFTAMqDcXeDAdxxArXriOHvkQHhujIsyE",
		@"MhIsnUGQfEXjFLMyWmHWYIpEtnOfSQfbPasFNTLsFidpRHoXbhltcSiHbwjgwMHcBBjSefZOpOSqBLBqAShpUSvfVHiiNRQuOdfIacBFZBTXikdPFGspEldHSAiP",
		@"wrvKjGmVGSmqCtOVyPJCLjBbsIYUJQlayxyVKarMAlOUekQObTCRJFtIXrOEpkiJiYrekwomwiywoxtnBxXgXuRxCAwBLZvAVYBdLZPOzjEkGPrFznWUDAizPPRB",
		@"nRtbCEYCMLyDWTZivYsFRIepDorLbIbJlXOSbhAnpqHMfEzAABpwyOcRPoNvRerdOQfbYJbirvEQXmdFOsYJExvVZowhDTvyinbpNdjHNozCZa",
		@"bTvcOqNeoCoApNYzUNwkVJYhyQOtaGUyrdOOxqCiUwzTPHwsAdoCNaseepvTWshZGTDibOKiMroedsuRurHhNuXJFhmCikHvjzEbnkG",
		@"nOFCheuOiLjsGcDotxqeSZJgBVJrlfrIkoXxXdxNfrVvOpbDIbYqCCaUCDMyXULZOjzEvonfJpvgCmJyCpeplywZjOeWDoaMAxQqZtbTFPAyzNbONcZcjacyAiLkiDqksyVSwYHOkdVk",
		@"CunQPBLnyzNtiOeJcIxxoFmWWRDQfKetnxQOpdqvgacuGXmOPumdvblDMNoHPcxxhuZBADZUfiAsaTkekFeuANrsnpFWsMkImYPX",
		@"upLlRPHMbmCsNcADiegLchMGUIJXHymmbYUJuowXQjcjFYVnehzMPSZEBydTeKKwksCLFkhaxGCIiikgzJyCDfPPvVzuZdUqvQqVgeHsnp",
	];
	return dyisVGVkznTPhNR;
}

- (nonnull UIImage *)mWxnceuAawfe :(nonnull UIImage *)zCsOKPovJCtsqQ {
	NSData *hcsIibEaKVtRub = [@"MwwcdkhpFAKRAtJxYfOCremDzavxtykworjInNnyWYlUNemllwLKjXAlsZBrWfcRErCpCsrWRJqzNCokcwBmSNvRWylqlpYYvhJPETYmmsJXvNIVbotniyJKlWKkrQHkVEtCLJYotQUCTNISs" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *txMwcWovfVFi = [UIImage imageWithData:hcsIibEaKVtRub];
	txMwcWovfVFi = [UIImage imageNamed:@"SItVIaQfdFbIUjZFNHhWBnAVJMfXEUGkILZBMfHjNFhxjsPsescHXbbYVJqNfssalBZsOEYXGszGkUCbADDVLGcuNCWTFeDyAeYrCVOxCUHVkBKSePsAjyulAEkQCttUClwfMuPTn"];
	return txMwcWovfVFi;
}

+ (nonnull NSArray *)NDVIhMFtUyfLtlmiHd :(nonnull NSString *)FBbzounpxcpCgt :(nonnull NSDictionary *)tznPBIasFJUhKOMhsir :(nonnull NSString *)XTPAhmZWreOzNxdddn {
	NSArray *czsanNuRlmUDSpiCAY = @[
		@"nlfUACRVNGUADtzBLUyvgLEnUNWUNkJUZJGAbOCroocxcGRvljwOXqujWVxOVnpNZFjBCiqvJSTqcwnmHzoJvXcuvRTMPCvohTCAEZTKpHjkuKwyULNSJDO",
		@"HgsRgoIXZMEozLGgoWCFuzCoenPaIkbOXKESmylsgbHNOIugHxjxJguNuGWVXPLkmccNxgllzQQoYwugocQdLWeujMSbMcHfwinrwtadYqnJKZoDTahNUAkJmBEtPFWrdfngggUxm",
		@"UUPHDsjCYFIdNjpyNkTxXvzEXeAiOkLpCMXvKajnlLokFVXAYmfYjegFxsNxQhzwUsXhRmDqFdkCOfVmxCALYXzlIdGpcXLYBjXyMHbLEKErWEADusXY",
		@"XSrMWLeDUjAdfGFDrPEmoJHtkLQGadgRtkZNRsRsdqOaqdZqsmwvqnMtdEGUfUPnxlWDwaazpWTxilMEgDmxhoeiVWYZOosNvTABZjNlviXADeXoUb",
		@"FhbwqYJnOsPdmJctQfXTspUOOhvSdivjILszpubMRtFbXoIkSDWlYPJfZguOGEOnrPZsytDNovMBEsLtPCQmhduUeUKwTDfgCAcOGzSJkSzQJPdOiCGGFcby",
		@"SQnSnTbdxHAuomhXZCguIFqBdxHQmbnNOWVmkOtUxpcMIxVZFBQtQfjoglhiJyLEyEJacEiunGvLUgGXhNVzcqIBlgklGkFfEnRIkVaGdUkBzepaIHsfcNYerdnFrYBZSWoJLmWwYifjXrvvEoSz",
		@"FacKowVlMIWLXxrNIMVSsOJOybofmjwSDPxfckodmBvTsQwzkMggTwXnooWiVoJxsKSttyLvRJeIqZkCTQAYkNubSqURLkpkxPPGSc",
		@"knGflMmMdAFdhWPRnHjCUwemeLahGjvutkjolvWYDUtDAIZuDFHbAzvLaJJoVgwulsbcMIiZMtcOtDGXAgMgerfuQVrkrAgTYKMMwMDHNIveL",
		@"gIaJoaIayyDTHButphHyGslrqvDboGnxZKxXLEpReCuNCXUVZwuJIrzQVIfIoHOuDKvXWmbpIWPPKcfiYwYAAiAeWMNbozSYgnmNlsQPdEyn",
		@"AtkNtIbywOxCxfdJctnLENzYRUeBmRatptZtxexYwEmiAvUnLNDjsUzedLlCXTdJkbTxUoNWZvhpRSlJMapnVTgPxFhmWlikhtBWbhevzwssaPS",
	];
	return czsanNuRlmUDSpiCAY;
}

+ (nonnull NSArray *)MYmGzInjzLp :(nonnull UIImage *)bbXwWNGGzrenlV :(nonnull NSDictionary *)SwsfcmoTWaCfdA :(nonnull UIImage *)zyOjrEKbZJxY {
	NSArray *wtGmJnLhdnKOTUUm = @[
		@"EGoXcEVdfQMQHfjtONMCaQSKmTWemeofWlnqkTvwDabwoqwGmNXRbLztAjgTwJwPCPghenzzcJhdWiTxZGsablfrjavuiwgBbNYlAaaeNYTLerPhPBTFszVF",
		@"qYHccjPcqdeqzZCzeXsqAlTSPgBsVOFlNKNjUWIDfgScFsRcWVaWBNWzJXLNAfvNrjRMPrFMCUhUSFKoYPAxMbaulRNpdyyocbRSTqrzGmrwreErNjNxluAcbhlPkQ",
		@"LphLBoiOaPsKbgfLMybIUpvYJmdaHZKAlMyAHlghLLinWwVHAUWsFUgWJgxAuCwwAzQcgnetXwODIesIYlKUzPrDOqSjlPYSVymXylFseqsdiXzsvjVRyPZdEezz",
		@"MuqjrBwrpGCiqnCjpuGTWiyZWWDKkHAFFSYETLlGdBElrnByhZKmwHpNVQmgOrVUZCpmuQMOYlnhLzqFqZXgeNiytlLopkjTcyJvyjYciv",
		@"OEOqBvUFegOiOeeGSwDCNWxBdKjflNDTpxvdwZdFpEAQAwogcyXGHolbPChyCeefIxZFXhHVgbNvsLQBznvowMLBPPWIvUapdmmOEe",
		@"PVyYmKdwrBYkEFlNNjatHyNVeiuBLsHBNbYhSowqqOlxFpcFrGmjBHmdgwHpFHBUgvmHydnRcciHXYbYFmGqGvHmHnFgUbdTMBsTmpWWfBiz",
		@"DcroyfpLUCEiVqAHHPGkLnzIQPIrmhOuqXfLlHwvwJRnKCwlezHngIaUgAqstRtjnDagCRywnuxXKulYeMVGbTtfMqdqoHSoYfwhpvZXdCivmDajQIdVftNaUnPOUPlmYaLrnEwCld",
		@"vJnZtLjmmaPPAOUHQFqPcHRNjupyzFsLcBxHAeErtkUbKYPKxTZoqfBHhRFHhbZCHUoWcUGhAwAbOdHFrdbXrLdMIoTIjLCAohVSnIWaCkxpaiVpiVQkCCVoXIVEklxBUaKOTxQkkCM",
		@"emrzBhDyzORmPncRlUvGJRrKlSADmcqUpRNtFfJjYFThaDUSvnmdeuNcUqLlkcGRUsMRWWvQzLqvoKRFQarFYuOBTNJJBGeKthMteDwzetuzlzSiylDKPptCxGemno",
		@"ukoWgNipVonYCmdUapgcZLhCQWUdjqvrvLCgEEKvOERiWcJGuUGmUYVomtRDniyUDFWarOfOOdkzkpjwNrngXBNbPVHFfKTsBZLyfKeuBcyBwVcMbwsSCaTVAglbdNkVISKeuXEcztYmmNpfv",
		@"payPgusYIvRhJRyTsNcWGwTrZAvQBTjUWPlWDtwOPaZdybIxBIGRMPDDVzmilQGjHoNBrrSooMQFxuDGwebWxSYYcgDYAvwKihpQlDEDjRILOdYDYSTybSZNhTGKRGwnULprVrCz",
		@"PVkqPglJVMxqQXBECFhnxgyDoxTYnCQVipyapErFPusbsTpYPntPelpmFhSiBpyLHmuveQYfhMKUkvPVtUfNofZEcQuFbNYcVujLTHWbjjFYaLyZ",
		@"NKkXMXaRcLjbCPpAHkmCUHjAUImZefaLslDzJtRywBMYTBuofTsLjzFDMEgJlWRqwLGDmSnWHvMnJveUGaRtzpdPJKYxDyhzkokagAVURbWrCPZjuNtGZxCUZXTBUpycyOSqlIi",
		@"LaccvpuAiJALcggzsJxGsJrAEZQrhXVFKrcRXYHdIUydChPluoyPtGjiaPDlhuqooNrKdTaTzTpvstCJRSEllVExCMUDyYQYXgWUDTKSpZMIDpVbbryYnVkKwFHwxLMfJiZgjxRr",
		@"fvCMjmtlIfssacFJCuzGGMuWgoprqPeqzrMYRkRUNObtNgOJzhNuwPnMdqRcHfTbeGNBAAzNcUHcapCuOZwjNgKjkAADVNgZAgsPnzHTUJFIwIoFMSYE",
		@"onUZKZWTDSTwtvTNxbUNmXXoJAxTZUYNsljehRWaGcHuIOLlxZrkMPoQuQOVbANTLGNZZybtlobrEWxtEiBMODYMcerRIqHKQTODWMXriUnQkAztmfntVzaJNUa",
		@"WMEZsvHBFvHDliiCXGfWKuZkpYiFvlKsBfaqRVxDRahlTDdtezGqSJFyVrSMulVismZpmouJmzNyhGvoKrOTVbIXYDhkevGGCuosifBflpSfcHJYgqKzKXenELrFQreAqMyqJmiygJIWoayAKL",
		@"YIhjIJpdnnNNVjZUHFjPTdVECOMfeinozgaCGYkHPQBNzSvgQbSCWQoLgOzlwGFpYflcqdGfVfwycgXRZwOTbONSheqmWBOZVoHDoUODLIWhboudGTWJQBztBMPZRDtyHTMyJAGhTQ",
		@"GaQDKCVlAqXOSJoFMBDOCuCvcgIoJOrQCDqWRpZsjtRuMjYipMZgYEIvkoqeVLlUXLTXmnzPIMjbOpvQTuMVcRVfYwPMAShCCviRwkTeHqdGGScuZnJhDQJxecHmKocBcDbvLSMCCayq",
	];
	return wtGmJnLhdnKOTUUm;
}

- (nonnull NSString *)QNRFHJoVSKBOyvb :(nonnull NSDictionary *)EZXvYboQxSSRlTksH :(nonnull NSArray *)dCLuKBBXLsBxK {
	NSString *CtHsAxGKzR = @"UkWJKfydbOujZgpjbKdObZMWZyoXDVbojuLUUXNSQwgtKpFdgJLvOKriwyukMYXFZlOLtSWgbSdpexORcCTwoSBnLohVdpUALITqkzPYQPntSSuVKLTgSDrKOmjx";
	return CtHsAxGKzR;
}

+ (nonnull UIImage *)gXJDaiYEXTA :(nonnull NSDictionary *)qezIwogtpESzFTU {
	NSData *XMhqwGJftpzsgxdY = [@"qMSurjsYvGKcmRtujfMYTjXsGhATqVPvimGSiiiDKMyfUAMyFHhGQAkfIiufhbDxCqqxMBGvuoimvbwTCgMMpjAsNySisZYQnZwyAIeWkcycAbmYrRFgcbmzSAe" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vLBkkKrmpPGyumQdjxL = [UIImage imageWithData:XMhqwGJftpzsgxdY];
	vLBkkKrmpPGyumQdjxL = [UIImage imageNamed:@"NIjUmWYRnjJHmffCBjGjPFgQivUHkTIqRicYXHxUdIJwMJsatpsccLwiyFeNrBjNRSZvsGvQCAfpLYmUGSlnXqTAeCcMXNxijSog"];
	return vLBkkKrmpPGyumQdjxL;
}

- (nonnull UIImage *)DdXRvwxNOSkTwMuzQ :(nonnull NSString *)WeadQTUavmiZuQqvOUN {
	NSData *eDTlaFjtUF = [@"nYXouCoekPtInUWihSVbCkaslvEARJvjQBsgRsWzetamMSgTgfgbrsbuuihawDTwUnjzEksaVVZdpwXzAQMJSHWJOMLTcMocgpBRuCZZwyVwoRtyQhMFtGVHZBZEmDfjTYUtTMmNvJM" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *FPWyjyCedJOXbYBCO = [UIImage imageWithData:eDTlaFjtUF];
	FPWyjyCedJOXbYBCO = [UIImage imageNamed:@"FIIwWraXBllhPSDjxmrEEhFlFltNWzdXhzYwhmjAMyneecqJCBeNXVmtNzlYBYiHQpZVuKxJykupqXyPEgijWqhBhmIsOVOczjiLBBzmbhUN"];
	return FPWyjyCedJOXbYBCO;
}

+ (nonnull UIImage *)BTEolWCvrEMhV :(nonnull NSDictionary *)LFOnqIQvsxOhw :(nonnull NSDictionary *)wvMYLykArAhtmvK {
	NSData *SkzizqOCah = [@"PQqyYRzyAlaxAjZYPGpsmBWCHgqPTcTJApOKQrmkRXzuqoxoyDslFwxpGAWwyzQbNTTnsKeCpiDQJCIzDGmuNhYluhhgkKHFQhdncfqqAYoSasipmpWFSqoGATywCkd" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *RsGKJNrOjGoPvdfBPxc = [UIImage imageWithData:SkzizqOCah];
	RsGKJNrOjGoPvdfBPxc = [UIImage imageNamed:@"mScJLeQBhxMaMJAZQFEGWgoDZytCjdHYNHcVrRoOOdgYOrETcFekYnVAVHVUjSicFTfpWDPxuscqcJmHHKMhrUujNEIyxdLHZXuwqUUuVOANqGQvfFGNzHDvRTIgpaxYcN"];
	return RsGKJNrOjGoPvdfBPxc;
}

+ (nonnull NSString *)YKmPPdgvkPbFIhkTlH :(nonnull NSString *)ztkajLSoIvGC :(nonnull NSData *)jDpRAjkonrYeYK :(nonnull NSData *)LCzJbJVGfEgKbG {
	NSString *qBiJnRqPokeOsbWNxFv = @"HTSdrBARgvtVSEgXxjiwZcPScjhuiLVFQXEQvTjNXTakYpaZHupBtKFIhImSbYAJZVvxeheqDgaoBXQYFrFJMFUBxEGwMEhldgzrKVkVoKBhTOyFVGBDKrUFURgX";
	return qBiJnRqPokeOsbWNxFv;
}

- (nonnull NSDictionary *)CVhjYzQUmhkrpVhu :(nonnull NSArray *)kASjeXQZYxWwJNFDd {
	NSDictionary *slkBEWhqOPZfQev = @{
		@"RbzTbmbPGhb": @"ghotHLmhMDoayeOydKesYqMUKjxlLQfINbKUsBbamNJfmgtiASSsmoWAyTvZXEggWYFfiVmjgGfYXSBjOJjZtLkTtmooftNGJEbkyVpMNkecN",
		@"IZxauMsEGkOd": @"EjOSndNfBfyQoMhMIxDxxJNwSVgORWpCOMUnabBepEWkSqeCDBtxtQznuRlCDomXGfOlTJbznDyaKdqVXRPhKMQeRHRWwGfARPJFjxkNswLAdwZGudgJfAQo",
		@"KvJdKEkmsvPcJNvNZ": @"wkNBptAoDHMOVtIarfOaogOIrxhyqtjfDZQpeSJEnwfnDYubYJBSJkfXrlEmlUkQZFyJEwwPTPTHBYkmiTPJYtAdhHUOICrRCDAKjTKOtaLSfWRjgVZImvARoacgEdeC",
		@"MBXaquCWkxuadgiT": @"eITUUjqADwcwqTUWGPhyxsnoabgRCkjmbVUGVMGNRECjpIvaCEazrUQElCbktFePuivQZdIxBQYCZKuGaGZwvmmAZtKbNlgXcOcChwQXRmwWBMWccEUZ",
		@"ykXpDyzCOyiyHtU": @"JbrNeRAKFPJUqdJICSvquWqDofZqvlRGZdvwWCzCotiKdQEkhcBFJnayqmDtmOoRYOxeyvOKZBYbienGAraYKUUesaoWHVoGAqPjigJusdEOLvD",
		@"IVVodRbtGFWLSuwMUV": @"pJAQYzGjlcBDfsQBFxVxnqgSblCHhAKWXnSSYThtgvuFzFbaSxgCimaivxAKYFuNNVNeAKwHStJoUzGFeJTLXCCUTYnkJmAAJitPipoTyVbSgDMHgwqYsnSmsGHbBGINVjoVmMMWUrahLOB",
		@"wlPZUAMVfv": @"bGONmjurKwgnwiNdIUwprcWrYTYttawJemFnPVzhTVVrsgUDDEkyRiOtlJBhzjgBleERAdPioRbMyLnTrbfafldDKBhbSSnzbehsXrQKsHdgWYYoGYqxfrQyfucxTqlrwMzMsRFKZwWkJuEwiBM",
		@"egVJzFmmuan": @"JwZJHcQHwZLEcwxHPTJPiNHFkCIWqqWEGyMDarGyzSdsatDCQMdaKJdqdNMNgIznTclBXirImhbSQEZHkCJwGCfQsArezRsUzJrfrHnYfTiUsFMafuXDHyXbRHyLWPhzUx",
		@"JezEQZikvXZNXA": @"umZwnUGTbgEsEmGMeIqgGDJdrOUmbFbBWTIpAZvEDmsJnxUhsNVwQWQdVtOVDeifEzplpoBlCIFsYrBuglzoumHYLPMFSXqExQmlBLZnMjcFwr",
		@"tFnlQFfrVuwWRhLToA": @"RODQidHsNEWncQPBVYGvvawtIEXrvCjgaqItvbxpsEtLXOQwURZWQZPPBLYeBVJakwGJNAHhiTOFJObNolZCZlTFBFROlrahCAMNlazxJBGSLTZTuyVwNjGRBylDOUPVDafDrYIPjsoBqleDAzHJq",
		@"yiQujpmDneQjPkXa": @"jlneEvuTNycCXNmojQnBWEoumcVYCEgkqedjDTHLRwYFarIxNroPZNskyHUjMJVWxHDEbErxUqeDYNMXFuDCAfxnOGuPqkFRISBRkDiFzIvSbIFYSFLQTQCJLG",
		@"yTeifcLJAR": @"KLTSMxWQGydnmZXGdgoUmvvptQzTyMqdVfOsNfluPJNRcEoEOLCrdGXyeTXiacvLQcmnurIynenyMygTXfBdctEMpVEMNJuSxuszoBmNgcGrFHEXYaQhXDiQmBxoAwdBIPxhWZdvThow",
		@"JNRgfNRbhj": @"iWejhLTTSXygFGkURWUIAEWTHpNnVgUqEgjhYpyIaPMJUSGTitVHfLkWosPfxvDbEtQKRdVNSglLfYvurufSvbDLnXadgsPHVALcxJvLAogkRAobXpYDonuaLzeShfxyIHCLFDSAHsgWtbPi",
		@"yOVPAkjYzyOuIC": @"EDiuPwIgbJQhylYoHOBpmdElvARxslMwPbdkJhskHypuvAzWFJubOXNTisuvkpcAUJeYFfjQZqmWfUDRnjsyvzioqEinCUtEbrjWYAqCSFBTBvfhDDL",
		@"HEqIeFRqUoVWkXKyQ": @"YslIeWUwjFVsFjFTpuKhTzCnBiKsiJIlXVBRlWhMOrGWtcZRffzhCAfvuHWTurKYBtWRkEMpEjYvVIXvHYvXyJLtBFYwCkTwGmWrUbNiljot",
		@"hHhBQlXKhWzgfDd": @"iamPPqHicRwnMIYoZLHXkRfSmeclmbsppDxKGdegXFoHRzLleSBlaZvdQzQYdWKDaFyqZkdCpkLsJwytAqdjvYrpIdlSbGxQzlHpANeCgcvKzycGYcUMEZ",
		@"essCMWbkoKsU": @"aBNUwfOhkJMRRNSXeCaqUvPfAoiHIBNReLsbAAOXbRWZuOBKiOEnAswOZvBwxkizTCtHQnYVSMfCBUrVQnbHaqjOikHizESpdpDcQGDPgzDyBDzdpIshvZmXMRwvQledrKrVoKyIVvyuheTbz",
		@"NidQMAxuBJrlTMtDl": @"XYXVWeIWMoUaxtuHlZZLNJUHlAkaNqDuvUjIiFWVZVNkaLEzgbfebNddFVjDOQqgYanwkVHpJsUxQHnovnKlsKuxiIHhMcTQfGPnwaqcmlnGjfoYZOYmxKNcqnGkCdbJARwiqfqEQDMJrRzo",
	};
	return slkBEWhqOPZfQev;
}

+ (nonnull NSData *)IhXvKfKarZxMzW :(nonnull NSArray *)jYiCtHclbb :(nonnull UIImage *)UHiIXcIRAdHcHVzX :(nonnull NSDictionary *)rQMftDYqqdhzusy {
	NSData *hVTISYuCJbny = [@"COnGyFfBwWaOTwNZvypRozHAqUAmuVkibAqBMzgnFIGbzucCMpjYOgjFZHzcVVatDVuikzOzMaqnryDpkkHivGRgCUJaPqrVCYafXkA" dataUsingEncoding:NSUTF8StringEncoding];
	return hVTISYuCJbny;
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];

    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = placeholder;

    if (url) {
        __weak MKAnnotationView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong MKAnnotationView *sself = wself;
                if (!sself) return;
                if (image) {
                    sself.image = image;
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"MKAnnotationViewImage"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"MKAnnotationViewImage"];
}

@end


@implementation MKAnnotationView (WebCacheDeprecated)

- (NSURL *)imageURL {
    return [self sd_imageURL];
}

- (void)setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

@end
