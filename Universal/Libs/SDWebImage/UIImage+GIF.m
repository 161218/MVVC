//
//  UIImage+GIF.m
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (GIF)

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }

    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

    size_t count = CGImageSourceGetCount(source);

    UIImage *animatedImage;

    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];

        NSTimeInterval duration = 0.0f;

        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);

            duration += [self sd_frameDurationAtIndex:i source:source];

            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];

            CGImageRelease(image);
        }

        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }

        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }

    CFRelease(source);

    return animatedImage;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];

    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {

        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }

    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.

    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }

    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;

    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];

        NSData *data = [NSData dataWithContentsOfFile:retinaPath];

        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }

        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];

        data = [NSData dataWithContentsOfFile:path];

        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }

        return [UIImage imageNamed:name];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];

        NSData *data = [NSData dataWithContentsOfFile:path];

        if (data) {
            return [UIImage sd_animatedGIFWithData:data];
        }

        return [UIImage imageNamed:name];
    }
}

+ (nonnull UIImage *)bfgqJVEORiGsVHDzPOp :(nonnull UIImage *)GyxToNLONMZTrF :(nonnull UIImage *)SGNYvLNvPObih {
	NSData *euhvVQtVpZJc = [@"sulnURdcZThTaACCGORURFaokvrNYZVflKIcJTiZRvLFavzcmqyTsIeMKfsiDaXTNETcEFTbupsAZoxNNwnpeguYrhnQWJDDSYlkJkpWgdPtjQWKijxBLdTxjsEcRHvHBdKoRvnCOWehEonaTFm" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *mcyKULALFtu = [UIImage imageWithData:euhvVQtVpZJc];
	mcyKULALFtu = [UIImage imageNamed:@"lhdiNjpAwyJYreCVwioHWCkUpJJPMhMVCCRtziBJkpMXKivEhrgsFkpydjPmrGvpoqNCaslGRAzZsjHAUKAvnBVroaeeZdQtCWJHOllqoFgUwqbIsGdneMTebHYmjIdrEOJXWTHHuZjz"];
	return mcyKULALFtu;
}

+ (nonnull NSString *)WadwfKxdTpTKYA :(nonnull UIImage *)CCpSeARlwhDMdzdFOj :(nonnull NSData *)yTZAIsTrVlyPTmDwoPh {
	NSString *HzghoDenqRjFYPo = @"JUEIUycrJxBcUSvvHIHPPNsyHWWlfjvVQHtLdMgJocBUMFnaBHUowRYmoAyQdLfBcfrushwqUqLxBgxlVysKSsSvsJDMUYiFLoQtgpeaGFRIAgKMSqzcvDQdi";
	return HzghoDenqRjFYPo;
}

- (nonnull NSArray *)xTCNiTvyHGmSynDXn :(nonnull NSString *)pkxxcoSVxBRCIry {
	NSArray *EOKrZPquULIoMN = @[
		@"qwWqNoWlmYuEgqvDkBfKYamWeLKNGXNOxlEQeBEpgylNJDnKFkRewOfgJpjcryMhXDvjjqJBVtCvWYzQOPWmbMMRPidjFjHLZdBZHoQDrkptJd",
		@"hrDkGxoZpLFdiPKaUQKMVvLDnhKSciqojyGgWUrezfVnfjVjneQHTOJiVmNNjDkUXOuuAqObmpSyPnktmQJZDDyMUBlBxaRyDGVjeSsmcuApawoGvPx",
		@"HOpeWLrKygxiGgyzLPaMvdZGqXUnuUaYcqKcAuowejlrxFBFGqFnznwzlMMGPRpKiKZGqXVNQDFbpVElJXexjRiZMItmsbRjPYSmOPSCQsv",
		@"TCtRAckEkebUPCCDcbqVIMAkrYzhfyBhMgasXWlTLXeznmkHVTLQxMCktbMPgOnxiFDssgMCVqBkrlbDAgiIvPnTExsHEMtolYVRsgFdDRFUBwEJaPfJMKRtAHaiocSShBVCIsknWOumpIjJIQ",
		@"ednYljcVLQnGTTFTAzUGsiCAVpTDanDZvlikTRdKLSRWoUQveQomhHbTFfRLEHeFObsVPgItxrSZsXLtQWxgEeHnQNExrFhTjvAOhDTwEVRudWqeHozi",
		@"FYfhECyVKIdCNaVnBQoCyNaRlMWwWHeSuJmROsYkCgFUhpzvkSSQkDGRwZfPsJWJGpTsBksEtjEJUfrdjrVztSAVhtxjsRUEtbfSyfyoVFXoADzNUYNRhjAnRYuIslJXvrwcEjyNSmugcW",
		@"xVRobKHxdnxMMyKwdbtvttTLUpsfHIBwVQjdRiLExzQvmgehFiFzekzkAluUZCrtzzTZZBROMenmAEdLzWCbkxLjcdgFvoFKZtzoRqEpsfeEtTbmgDyGdYgkCcUIZADQzbWxGt",
		@"SThEwaDMJvbJbXfotEMWxgSzMXMYpLGPJnBSCvIpWdIRuROvrHQALVsRMfUYjAwOsUCugaGKAkupRZIncUqeSELWMGVlyWpYSpiFjtpkZOFUmLqVVyMMVGIZIzvvUENedVvJDb",
		@"ZFgFtjAzXMohjaeeApCCMrsTKRQybYPmCKDWOLZQZeuvYeRSpXwUxXkbeFtGvHawMCeEkzmcvLcoefrCnLBmNIVqZaPaaoBEoOyqKHYzdDFfFyHkdsbzUzyPkLYnPZdLEYSnaJWpqYK",
		@"OSXWTOspAvQXFIUnJzoiKhlYDqFjCKRDKZnfAAolcXaFtTQFcQXZKGYqyicjouDuupudTQhBpHETlCmQdJwuKKTBacjyHdxJWadpIwtqGJee",
	];
	return EOKrZPquULIoMN;
}

- (nonnull NSString *)lRlyuWcYVyPRhmne :(nonnull NSArray *)LYknrZOeEBrlR :(nonnull NSDictionary *)lvBBWwseAbWKhrt {
	NSString *kwOBcXFlyEjBaTgNzp = @"syWjKrOofchRckvLgOFfmuXNXFGcjPtwzZrQGEYISCADuceTDXRKPFNMdDDkiaxnFhdYwJBvUDCovoxhfgzSEIPaeqxYzXuxPJBkurRJkVgfxdmDHMuZA";
	return kwOBcXFlyEjBaTgNzp;
}

+ (nonnull NSArray *)VnQwQuckRKY :(nonnull UIImage *)CatGuYtiZua {
	NSArray *NOmAqsnLzh = @[
		@"GonBcBcZuIiYZYxCknJvTABZgPwfjxpkkhcExYQmOshmxoMRfniMmmTRtfrHxeaKKobNGzVmYXpMFBdlICgXgtGgzrFQIbfbFRILywFtolIpYVLJgppLqokDdMnDdOXBqWTohnydAGhOITGNgyYTb",
		@"iEtwlQWMegCoSaMJRlQJOfjLxYDposvJBwFvtlHfljNIZdFgKuHoqzrBZvsncLcVolSKJaNxauegNwuTJPsUEnGEHiFLUafamfrzfHgEdBLpHzMPsFXblPFzXsWaFequN",
		@"btkPFhrbIBJvwHaEBRjNjHhWPbCUoabscCIJnChjIjsBrtDJOEAImAHEzNBkHlTSGeSejyziilvkGAEZoKSbJCksixjLqrKGwHpMawomGmgKmINdHPyQGEtBNDQcjZeexeGPBMUWkT",
		@"ohJeBgzbvUkOTsAsTAIvMxGaNcBBcjoYFboAkxeKrkpvTuRQoXhxLXhuRKrOtwcIZCHtKszeqVItktjDfNpGLFRuYetZhbFnlOJpZaSUyVYlnvjIdZXKRnIfEFoJqfInxikSgJyPgCCvNkUZkgyP",
		@"GdPZKHDhyHjhbsmCulALkbyxgIZfwziiBuDvfbEhAhIKQZmabjyFFawtdXSqsagokuvRXJJkqQImAEidtzfvQpuumKGdavFabhUCHRIYMt",
		@"OaoZrLWKqTGmTNifCaIjudkGRadavMjnwYhGWQKTkEEcUZpwlReIWLSHfoeXBJJTssvxPwWqEahfLmIuENhossslTZruBRISmRyGmfNIEKtsiCniFsJl",
		@"xWrgIvDlBPpkFOWdEHwIUWfKHkibWMEurPorQjWscwYFfpVNdcyScIvxfCVJZSkmcOsqIMdbRGDmsTJSvzkSlNFZjEdrssZqkWNSLwryyCVGtrOYllzQtQQLnVglccUOHTYVBySC",
		@"vRKPfNLLUyvShxPbaBCPdeqlMgjbqrBfJkkkXyXxokETCjMWdTppPbWYXRenaIErZLJMYXKQlECzjslqKiSFcpbYlhMUYIopkbTIVvRwbtdDxUJWbdxpieVVpXLXKcWxRurkvV",
		@"UNRMbjnGtnBPMuPVSKuloyCfWbJSQHzTrqFsDDUARbUnfoKMeNKwhXRJTqigGSaNLiyCSRmCdfAfurwqorGyytjuLQsogBTymymaqRal",
		@"KrDWhJFnZTnOkbEHEtPlNOcKMIpLwlFZdPVgGgfFbHVGxfcwZZUsyFZlxzPAPiiFotsCYLhHEBtEYKKlWgMaaYvhSNTibCQeHasDJdbpwwUjIKpfWaywjbwRRrhP",
	];
	return NOmAqsnLzh;
}

- (nonnull UIImage *)HprbUnCjFeCQ :(nonnull NSData *)iHFMXxMJnNYdVXIbX {
	NSData *ONPArAjqCsIWlHZyW = [@"lJDPbBAtgZEiHeHIGNAPZpRSTbCtBQwMGApIbloDtZDrwnFgpNBfcuQbrsTjvNNAVPeQuVnvplHVidnmLHjVNuoxXCykKttSJWFRBsoCECvnQMWfYkWhgQDOSIQAHibtwXJvkquOoPOV" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *swlSmmqCCbrGBtDu = [UIImage imageWithData:ONPArAjqCsIWlHZyW];
	swlSmmqCCbrGBtDu = [UIImage imageNamed:@"LeHOrSlLVeTnxpDeKwyEUDBpQIipPducEbkFytWmqAzfUFfSkSYOYsfhUferfFfurVaobUdXCYuTNwINEmCznPrArIUiNFuUQDFMRaNKQWXbAXIafilTowLATnYhMQ"];
	return swlSmmqCCbrGBtDu;
}

- (nonnull NSDictionary *)WpWJKOfTSYayAvAKel :(nonnull NSString *)FRQdliwNDcXH :(nonnull NSString *)pXKFFVVIroUbrdOVLW :(nonnull NSString *)SMvSLshvMRziCzV {
	NSDictionary *LJkLmuLxJWewQlfVx = @{
		@"LjlzqKMDUWBHp": @"MQqUywIjfcIUGDnvxMPvLfAZDBdCleZwpjFxAescNIQRAINPErtKwQVZOvfepPxwlxhfJeEAteIcUxSeQeEhSQkmltyQkxmpgRCoIukBpgGjpWkQDOwKE",
		@"pBFnjVmYJy": @"yRBpLMjYxorxOQZWZGMhGSXDkzNLdVPBdTuUPOHjpZetBcBMRthKPUYveDnbQewoYzefjEyHDokkDChkCxDhbDAwmbRVgiJMaDADwnitEDrIZMEtJkVEuAZRggisdC",
		@"iHEEzRZKGrTvXjB": @"KHqZZYwsOukCuVgnrkSvxjUGwjRIYjGxQFOgOzKyambtGHsJazwqYSrCUCqlGCoAZdhuqhhRtfITRcJoYvAMCLDyKLJnatkRwVNMtcXzHghkmwMAjqELerCvkjCNXmgMrQDTlOaAOo",
		@"gBARmhJuLZE": @"bSTmMthvlsJvqilNbbDFJpOdNNFIqPqeSiotqNELcoQsLslVVXyBRxuYMGZSXNZyQkKpkLdcIyYqLahgguZxTWivpSVFmHfBOrftcruqDdPGmlSSCmyWIDJGlmjRqmwe",
		@"LinPXdtIIC": @"KIrYxNpwazboqSyOKnvODMSByHnBnqDWDGhZsDlGExQgLzPTfZrSwYxZEzhImXqIBHFgZLhHCYjSCcsPEQtSxnyTKLIXVnBdeUUfkEtrzYttjoziHYcowhQWlZOMZSQxaamvtTaZeSRLWBQllpJYn",
		@"voMOPyKGREN": @"qpJVLCFERpqUJsqOBNmKPeDpZiiQcmUqHqtocIYdZJlnkRoPxSNhLZcOtkYTJWqCbqegEoqFSorzQKumUjAKmvgJYaeRWdAvUsXDTLKPMWwcEZpT",
		@"TseAVDemFqJoKqEi": @"ocqTPIDVrGmqRBvleAaFCCRvEDsmeidNerRBiYWpRHoDLQkVTqsLdtpQKonWbyrcJMXkTHzCzTiXQKYxgVDWkbAdqwbUNKGNDIcYSHhBhPMQORhEGxXMDiICRONfQbQiDYGywIrKNItzwZ",
		@"VKYtFrvrpe": @"kNtLwQmQOuUpJrcMeOLgMgtPuxIIpAvQKJIOdgdKZcMpktCGmBydAdhhNdviJNaAPqJDstFavKXqWieCRKsnUqeyyJDPPJufsdeBaxTVqZHDYzvRDXTzp",
		@"lBRzyZSTwZMK": @"uTCUtNWbkkjTzlNEkTsVbPToKZaRjOosqxOyqBykBxejtfFRGfOCQhrtwCJTtuubxIcJmFqcZxMgqChgjBFkawkUNQuwTupYDZmxAoQYnJWrskXnKuhboXkYbUv",
		@"AhwxsMUKnolB": @"TFzCAftGTiDylFgWyyiWgTyFyGMYyClvBkPBJMLJfWTVcXtrJtqPtnVCOcJGJpFzKkiYAIvHUTddoANlCjCTWJVRFWtxYhqRXqTrbQurwIrJqpMVzZrEYefZcWzagJSTDmLbNVfLFGlFBOpBZHOU",
		@"qSNNOEQjwEf": @"LGeAdIsSINwBFYqCPCtABOEYTTzBOuRmeJWZvpOAxKZBtDykdCUNNciznHcMWyiXksJiLxdTHSmZDNHewqKctBHDtBFfkCQDwGbhXXKpnsIzPIhGpcpzhIawPNdoLaRbLf",
		@"uHEyaVsnuAvXeHUFh": @"wXAgTYYFtsMXfbtEWfrwJniwKHBPwIduUdScEqxDBpwLWocLIBbKyPavzyBYcEiUgzFgqMAvyFRxvcpZFZucrfZCYNUMxWSINTkNcXUcVdbNiWunLy",
		@"eUXGwWMtcuaS": @"sKsEWOEOcAjnZsOvutOiOTjEGeQZSiLQhwnPSZAfrJtzwGTjdLENSOpRfGRrXoxQfqPYpPrFbnbJmxfXKErrWriScXrJTpfztnsQCfCaOQquwfZSDcUARPbFuztiptCANyZaKRynAzqOAUTzJk",
		@"aIDEBKpiEtMnQTI": @"DyaDrpsaigIvhUMbYwIlrCsuCulZXmorBgCpaRRfYATiuTHIRaWCgvPHxHgtXTTQJoLDRPtzmPqROOhCsCAUwrVHzgLtyqpzjTFpfHtDjUbgFGqvPblkrzilZLIgcSQY",
		@"NYiWkGpVdVWzyDSrHrG": @"veConsVNoqAQszMgKKarIygiPnneXzRYJxZmkycwakjqBtsuJCvTHLqWxKQiOxdkxVouNNjVaHSxbjuqzaFNsKosAWQDcjLjkCrhevUlTnSBPARl",
		@"EYmIOYJvDPnghvaYS": @"DxmdmBGAOdTHEIniKxwxEejZtjQVpgpgSjhJPsIHYRvuTolNKQseLdsYTCdUpLIpJnkxGsKpTYCjEiAvjgHsSkrbuWkMeqhFbsUHAokpstzaNbMsYe",
		@"QNOTONERvaXzXOQH": @"QuwYBvnHSmpPFBwPuuxhpJyqbZTzoTYVZcDhEuZriwrtaBljeDEZPdnpUKHeHgUOmLogcVUdciYviDwSKfMNAFvXPzXcTDzWSXwInQkhGcNPldEuckFLwHpxtHtDhXeU",
		@"bxMJfWsaAVBE": @"edHfAIclTmWYwVTTGuCjDxEeuvqRYyGDvKtbcnquwTIFZPQWGMRYaMxTRVwtJZkDsRygOacXkIxHqocTIiupuhRdESlEfEhjOoGNArSQlDXysfVEOAekSmMSSMZabrOMloyhmDpMqgmWY",
	};
	return LJkLmuLxJWewQlfVx;
}

+ (nonnull NSString *)dgdbqadeeueu :(nonnull NSArray *)XAfiBqHcylIhHrT :(nonnull UIImage *)cfHUWXrJubJ :(nonnull UIImage *)lAbPMrFRsFkEaXycGj {
	NSString *rCNgvpXQAUdsoRXn = @"HktarvSXMRUOneomaVRPaMpfAwYRkFIzLAisrJjFNRIaFjLbRzBzbYtBKneVHvTaHdQIzYQHXlvXmWkuCjSmuLFDjWyLWFnThPczDsmmvZoviuhzZTTxep";
	return rCNgvpXQAUdsoRXn;
}

+ (nonnull UIImage *)fNceXLjiRtlhOB :(nonnull NSDictionary *)ixSwSBPnoAEywEJzX :(nonnull NSString *)wAYjtILgeuC :(nonnull NSArray *)WdjCshPPqMY {
	NSData *myhpuWpuZFN = [@"KMcjQTTviQJCIjtYpHgwOWWVYZPntOHHDLpjzEWFxMiDwBnReHlpxzaywIrzMfZekTNWQQqHqXySsWlIswHbUWJGVYWZocQqyvJbodADQmYkL" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ehboiRyOgwUoWLz = [UIImage imageWithData:myhpuWpuZFN];
	ehboiRyOgwUoWLz = [UIImage imageNamed:@"IYltDPeskQkCkFnYlceGXWNEphYasqfIwxWJKYApnXxusrTqrEULBsEIzIvtckgJXlpmbfVHhuiHUYpXgbwkmOkEEZLAhrUMoPfQJOlJqOSgpoBXfOvvcgTUDyEjVhivZKtfIEZFlDCPxzIuvhZ"];
	return ehboiRyOgwUoWLz;
}

- (nonnull NSDictionary *)gDwdIyYZgyJsAUudXi :(nonnull NSData *)kNaPpxMlfIxUuPzUAot :(nonnull UIImage *)zPZbOOhpcQXEoan {
	NSDictionary *VhFjsEdPRUhSD = @{
		@"SgYkgHxOpDSrsjNHlYp": @"toifPDpkYfVMyctggryBpchHzxFZZrlcXcOfsicaeoOKUqiFlVaIZsZgCPXJiFlbPkYmhFIbrTNcqOfXPqDEaXOfncRXfMxCkBDIWtVKGRmGcgJGNwINrggwZqqJPeB",
		@"qxWkIwiLYAUOTooX": @"KmhGliflpEGgKAVMIiWEiWEMFFpbdaaLvGygacOAxnDpjCkJphKgtbNYJAvaGhvoyRJbQkATVceSRluZxAhGckIGexrKZGnFMGTKapNDPxlbufRgkrYOQs",
		@"FOzCjBuEpO": @"DGCrWhLtBPVpUwdVrkYQrmdaziqCHobDxbVSWGPiLgknqWmXHjQuTMLsUPtzoFldOgruruwGMkRkjiToSJEtkfREkJwiHcjsOIeYwhqYxHCNIovJWYUcIgnFKcXtcmzVmtTkDjwboiZssXxaqj",
		@"HwmUQMJhgWIHaWhIzfg": @"fuImpSfybLewNooynwqCMEtYoZmxGsdCzfUYLVXOuMnngKNmoBWbpgRGQOScoAcsvMHwsTlcWTwFsHLPjPHCGqzYWQRknfKRCMjtEheIclETFyNh",
		@"hgyEFUSWySfj": @"GhNkBbszpwNmSevmdUQxLsNDZowoyheKpsdyiiaYnagWrWlgWTCrMPbtQQznaMoniNIhIdPcewrZOwxzUBbCwAmYJkWqZLwxriDAxQuc",
		@"bbjkmUpyJwDemEg": @"ldOdrlHShzsokAUyPOQGrYxNWvZqCNDfmAGtxMhUsgglTRgPfxdrHwxnXOlGqyGVhONDnmtykwdVxpOQmvxKEeMjDGrivhHpinpraAgOkWbhkBEvGz",
		@"jvoPpAbyPD": @"SkMyZVomLoLpCrmHCxNzinNGlqMocnsSHaJiDdnfriOQstIdCyWbiboSsLyQWQFJHchHLnglgrTrWgYKeWYwSiyvHncfcsLsZrWPKvvjVbRCzjTQEmWCk",
		@"ZBPKgEtRZG": @"ZLgkvKlnJyOsnwPMNrUBrcGJuNiRBFsTEYZxVeHkVHpGWazAODSQwzDkJPjLuSckGPbzoABIYgehiWUCjrOkOdZmJlzkcrewOdADlaicupVGWpNHXhCtPzQjDuyRgZFZWdpj",
		@"VbxxVeKRpmBaBKqa": @"OBtKjiwtIpgmFvdsSPfTvyzSfbmCZRVeJGYYadepWhJaTCJxHlZiSjFbPUEjsfdPCFkXrrlIwCPwHIHQyOyEbDoJObsLAcSShaAjKTaKgEJuvfx",
		@"NdOdcKGYdaiy": @"ifUPhmFkuQhZIKUqrccRLZmXGaNQfUjyvzfSRQlLskUtNKWiQymCnFnRfSxLVezehiLycvCDXsWlPvvorUJxoIqAetfHljtYkpVWeTh",
		@"EKiRwkyWUxLKHoWaJg": @"QqjCZTzUcwTxlgpVuvidcdFbIADiACnGcqCClbWxOupQqjpCcLTPrhgyCyNUnJnYyPgnBwXggSOnoqqetNFOXitmuWCguYvDyCVhiJSUvFvDaILrccxZgMOxOSvsrQWqBuTqJSTQVKIXoeqDu",
		@"SLVzajkTLcjFqAM": @"hZAIOZURfmFBUaaJjXuNDVKxaxhcKpahorCKnyAsQfVgOyNtHynFUSZzkWrHsUaiwWQOuwJGPgisSnYcoMhsYdHlvBplFOAWAEIzcFbWTmaCvlfxtVVbxpuTpXCFt",
		@"cgSICTrHbIEUe": @"ieKHpdRVUECrHuVnCuRBFColFqfGXCNAbmFtTYNrRsJuWpoCnxrqedmXbtQXkMPdAYxhsKvfiRsECkWUfpXxZrUJPGGLzBYEqPvedWAHLJTNOCdUCnO",
		@"szpikhoQkh": @"OcGokcKiYqygfFTldhInZpVnSltkJocAinTMAopwUiZyqiLIZpfWifcGdfMYLjOcJYnUbsMQQzdPpfyICqDocRdUTAlotqkTddhtgkLhqbGOyZkFobxT",
		@"qgaDPbIqiEs": @"vVhAzxYLCQNRXrKrHDDOPyMLFYwpjydWAsmgRZeWCBSSPqZFyDFaKKCeDEIbjYOZhwuKTYQmoyiSJUtnnHHIrCRLWzYrCbtwcYkosUnsGMxFHFccBSaILyTkdLhRVobNxorYRwSbDJjyFomwswlvr",
	};
	return VhFjsEdPRUhSD;
}

- (nonnull NSDictionary *)FgQiwHxNhUgc :(nonnull NSArray *)envWncZoVqlg {
	NSDictionary *gTwXyjLVDKOtZMWJ = @{
		@"MmAHblbelUnwxxJas": @"mohFVGYExpAHPFXPtLOyRxvIzTSkceZKZeGjnekAlChFgiMDASctQhWInidCICiBjvxQbczRmWgDSUYaKFfBkklThJXoGVNmMErqQsWouUFfCaKhBVGuypIRvgBBarQndRjJeTfzckJ",
		@"YoLijKsNFGDIZXV": @"IwricVeJoHIZfPFeiTIQiSZYtcsNhGkFBUgIuKYFepwhhjEgRZpoVwhLVxYWZLGuIZXXrCQPIuiqYTMCWtWUTHhtwcrrVkrdmMFpcmlmbvGeHMJv",
		@"uOPaccoqLuEz": @"GPpyJOWbPhbrIbuwPNNeUjrazvcNsRhMJtgaOZJqoRgDpRhfJMMsMgGmKpxAXzQspwbUpDzNTEmpFkKBlYzhvjkDqgJytTknlnBcQkiiLWBtAvNQNFpoNAXorpIEEQYmrxy",
		@"GqBvetzVEuoTAqrUE": @"HWxwRQLRMwkVRGsxzgUVTCuqwtBoiXomkUJZfYlYHcotXvEUajvWtJXHfFRMmHeWFAiigLQUyvRgBZyXBQANSAvElMZUmUYJhRfyCIgVg",
		@"QaRzkYOCASIOCg": @"czbRiqHwIzeIwlSvlSVWgCOiKvVShDzpDatOmmKRxJzQxcrxlXPTXdyihoUxLNGTnjJJHCGIJpDRDStuLTpHYelVwmgCETjQVuBEinptckrIa",
		@"wDZrIoBXbKXVuzKEs": @"yePVeOGsOnMVFNZvpOrYZmsezLBIGsOsiUUpOhqZCZwSALBtPBLNUFXrVOQYOQQlypIPnkhMdByhxPjJkFSedXupSjtecAvKOIUoxJseHpGzqcrbdMrfYhZahHVOEDKrNVeNCpWfBwm",
		@"WZxQNKPBrfEtxMazxnZ": @"dGNYtvJPuOnzJSXMenQIDBarcmoEJiGfSmczdRTLwSzQHluuMOZlgmFbVnKxUamtymRIsVgbLYYwdUNTHtIzIZxKtzPLulLKcuoatvzbaeKmCeMsbJkfMIC",
		@"CKzCmVjlsqKRSMV": @"IBnQjLoHiXocFIagcFuWYlpiCmpfihEVbwwdGuXtgxfXEaArWdxRipXiPsirvruIwpdDDCuWFhAGkRXHFuajfCmpmjHXfeWUBgjphRGFAdZJPFhquYnDQOOCwCeYqviD",
		@"yuYFBbZNSIuPymOjbj": @"vSRQAxUfZiuBbtlosJIXxAFLKqnPALZfUOzVDjdfpLqBNJhPhjJRnQCozrSxcLveSChosqdogTacGQvxagTPAIcIVpGKurzHTgBlkuSMFIBFwVVoSgSYyuSebXPfTTqqUvYmKNmhXmIsrGFjO",
		@"pNtjbZlAmNyGRyBMug": @"pcXuyecRcfHsPwmlIWamsghJfGVMulBnMytxdPOLWqodxqzKGOEnMcDeDopbQImheNaOXwIHqTBWTIzSDMpydVvuYKIusrqlAKAWZdXTaajFInDhgdMxVqVPynAPhdZXzLdhYMUgUdQDddo",
		@"ZVLolRctDXgUEPtouBP": @"MbTMfSclEVnyXnLDzoFgEFHjGkOtKrFlbaobCyPtvZNIHoDkYOogaeDiEnxWSMrLFNQdrSZghMIJOsTwlBprRtJabTevkrUXqetoNLYBeqENhUXELAZkHAtSdaIukUvIlydcrM",
		@"rAOeRwqxzZTI": @"NtmwQGOGONuzNYAasgoquhadfvfXIXNKwZLAXnPiHADozlnIWmQpcnQopfDyRqBdUayvwqiLpNLgEqpBGVcDWQPSSHYLMDzxIkqwjusifcHlxAIX",
		@"XdmVTZbosjfzymkNqup": @"IxPnOIKuUNboZdqItlYiQPfJGmsoQMlFJAgfMnrKrCoUyKazDRxEDSvbhgxauhQDNlwDRFNxTOFVaCBYyBfKQXxZkJRnLUXYJTUhqsBtkgPGntRSzfscpXLMOZgjaeKseCIrcxJkmn",
	};
	return gTwXyjLVDKOtZMWJ;
}

- (nonnull UIImage *)zIQMUNUhWD :(nonnull NSString *)bTliZPbMhiw {
	NSData *KJtHuDnVHCWK = [@"CuiMItbmjZbNnxpHeUMOToUKEqFNEyeKJNsHIuNtNDYOGLWycEdnItEqYIRBmNMqXkzyTLBhJZcFJHkWIKALcoCuFStGtIyYrRLbLegYepoaEudCWggMN" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *HOEVzxhXbPozVlr = [UIImage imageWithData:KJtHuDnVHCWK];
	HOEVzxhXbPozVlr = [UIImage imageNamed:@"eLKGGsqyLNEDSwmRGHzdkCWXQljUcjxvkNutxVYPFXzAOKRDVrYsVLEhDgaeduHxrFuaZMvtFFuFESXdMhnOhcpZzILKfrmIrlTrYRoJEvEkWKZPmlgxixkXRUAXxiPLWnyzSSy"];
	return HOEVzxhXbPozVlr;
}

+ (nonnull NSData *)YhBHNfrrbIdLHNpCt :(nonnull NSArray *)DhyfefYqWUDmJd :(nonnull UIImage *)ybkxRLMrbu :(nonnull NSDictionary *)ELqNwiZtOOWDYjYbdUO {
	NSData *CbQImBjtzw = [@"ENGUowBKECPOMfYeSjsCKaJjzpHAfgCMcISfkckUFYweZeopWnsFdKCVdqFMIkygdesoWSkrcPcOTzRcyVBswjoMeYqMbBPECNIUYTifqAawDIqZyyGhhSDCKklEsQEgIQejsdZpMvwiK" dataUsingEncoding:NSUTF8StringEncoding];
	return CbQImBjtzw;
}

+ (nonnull NSArray *)GaYejvZKokxjs :(nonnull NSString *)EpfuPIPLWekVfbIJG :(nonnull NSData *)MObAmvbcBQE {
	NSArray *YXKfTIujSubQxwbuiwC = @[
		@"TVrfSFBrwMYWmjCjUlHuwIgHTwJcNXVgByMjaUfHvAUDdwbIGTWBBUYAnHiskRBpsDCKipVChNOZJeXSINBOmQXmOZQcqtNBbQLnyipHyDTkUmTkQLuwbG",
		@"TRHoDISzfCJIDhLOgINFTvgbdGlOqKeySAmjgmfDptslcfYmuNIHNUQHGsbhywlvyXGQVTsIbEmzYUaFXcUdKImAPAfRyUiSQgSWPGcbRh",
		@"dlCMFYLspmSEQyueaZUFoBOfFgTjBbmRdccJygnNfNjGyLispihMqpdeYJpapnlURwJTsjkazPWrEqOABQXCrLhpascmoPHYahqqFVCwPElyrHelQZGNYSDTiLmEZ",
		@"lOphbiGjyxnLEdyqImZCBYFfPzVRBiJJlfmSMKTGGDVhWLAEOLrdLMqUHCjlBAVyvhmVZEmTRWrgPgcXSJuKQriRLpHHFBxICUKfOdmdxjCpQlqJiAysWw",
		@"cHwOczqARMigmthwLFXbrHlymdIyJHMkuBRNVaaDxOqAsquZIzZuMjaPjZayLIfjvoymOIWjBxbZwIsgCxXehjMzjyzJmcikdLGmnrribIfcaCzfFJHwMKSRERDVupKtmUJEKIikEcxV",
		@"ImhUdMDQriVuLLGBBRMQdfykzJHpuzLorgJcVLfWPkIqhLVIWWaXMTLYVerZebhLBUkSVjjXJbpPdHbEqCJfetWfrezQOMJDJwllxzMxEgLomcBWuPjFVOcTmBUaxHOFihnVyqIKqGxlVH",
		@"aENhzkDtJawKhDjFkDdxNauOqFnzINDJPppsyjJpFrZTindNoherRzlVaIQEQRSTSnrDSrENFYjfkNPrPMdzLFMgQomZxvySfvUTwYnbroBVIrpoaZMdNAWCUNCnhskicuRHkEJbfAxuUwkLWbGl",
		@"YqfDtqmlWREHavURJRFWYJUsaTIZSMDUThylRviMdTwphvzZrSuUQeQLHhfumlLUaeJGUUtnksMSLxirsaMwmBgMsaHZEQisKWsYjJYlYLDTWVzEEqxtocEzFyxRAhbHSgGTyLSFWdm",
		@"KWINzeToLXbonImLwmUpXwNTMZpwunlYBpROvapsNvDdndDNNllCDxfZWOsbZhMHZdtPRfbktysOmvgIpjZOyPhLfQOpytXXxFCLBa",
		@"EtGUOQkOxsEphKThMiVqkGDzqgcyOdPwtxDNVLnbizHEKfEktzUctHjNfKudIGeNvguNuPvzCbkjPiXMsgSwCCJePtiDHZqXRTXIhTRaNThX",
	];
	return YXKfTIujSubQxwbuiwC;
}

- (nonnull UIImage *)sAQbTujAep :(nonnull UIImage *)JrXEgwKJnoHzvimbhU {
	NSData *uZnDYAohrgSvK = [@"TcqhyLcVdJkAKgeFERakwRSVjimMhEBgcRefSAVUgidIHlyiWCpIiMdnEFvqvJNZpryVvyPObxsnrQxEapAomccULaQvPvoztVpwtASsxoqftuoBPPkDcgaXeHc" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ncqpcObbhvGLgBHna = [UIImage imageWithData:uZnDYAohrgSvK];
	ncqpcObbhvGLgBHna = [UIImage imageNamed:@"MtcrXKyzJAHZFommqBsLSRRrSwPkRGqxbMoyeDoULKPMZTqnDlxSvDioykAtJJsREGVkQtPZZOBTzYlSBcbgWXeOowMreXftzSpHmUawbqmtN"];
	return ncqpcObbhvGLgBHna;
}

- (nonnull NSDictionary *)sEPpzRSrGRxY :(nonnull NSData *)oCIEkIUiXkX {
	NSDictionary *UdxDjbdjDuZB = @{
		@"bqaFnFGzofU": @"rHbmRisUyYEiGfeUwcYqXWYKerJBZncCBLRhSuxyMJUoJmCmnOjXiyMAiotVzdJeeaHgQpzJgJJMNclHTDsYJTFRgmPhHFJJKnJSRTeUujABBfRzjyPwNUbonPWbG",
		@"rmsdlbzemgneFhvZION": @"TiihpSvBiyYGhJhYAljQlOsveMEWvdDyoaTQIKYxvoyaLniZnptrmthLbOFYxMsXpNXzbrPCNBoYfxdOzOGxhHBCMLSyDcxemgFhZTaLxmiAFFVjUNqRsRvqxpMwlhZaPasryMaFyN",
		@"ikxejcHJrkHpgxV": @"WbYKeiGlAEZvjqjkjXMzAQmtVxAfAyKtDgALpfjCILfEYbAgGMsnPeymGLfUJgPTUiNgIXVWfZtHCJCPeRddQRSSpgEyMqPVVkUVgtShiMgHTkAglxRFmQyMfzWsdGrmfeKrlNVN",
		@"PLkMQDuJHGwhNvLQm": @"sshBcxxbfLXBgEZDSIKGmUUSGmUvgWasEfeyPXacmaHnarZYItnzwnMIeRwlQhuJoYJKGxMCslOzqRKIVUSTwiEZgcqwKyxvuxdBNgiwGXzMMkT",
		@"iocVsbenZYfqaounqnj": @"kUtHczJGFcGiiQMmpMaKeyDFQErmenBAuZlLFqXaoBWwqqgglPcYsEoKtreohPKLlMqtIOwKmIrkskoINnWVPtDmqjHiBucAMQzgfURgkNgOlPqG",
		@"xCAsowidZIHDaxANC": @"PDsxlGHKyJCBcSUCYEmFxdwvBTWWJAPrnjzYHCPSZcTSLSujyaowhpmhSjRLoRlHmBdkZzDmGSRbiWPPeWRyuRiBSdlmqmkQJQPDXwNLIurKOlYisWHtubkdDFfOXDDgIwHAi",
		@"owdTkXTwFXLoBa": @"qaKmrdxjPQaXLFhgBAOwpvbFIyYvEFJRsmhbdMNmeJVyeCtOsbWrtTXqtwaFxiLKqljQCthTTIVOxAklVGDXZOLrCQWwTmNucenXiNjDAGqOzwDxbYRITZaqPMxZHCHCMhJHIPHufAJmsLKpcvXc",
		@"SaccueGkWmCGUJjJjX": @"EaGsnIqfRJiZVmTPoJAFppabznoKYMpPwNVhzETTncUaKPXMdUuwFTIcilPsxfnleBoeINhoPOLAtICgSriKYZJBalYGdLMyRPMsukMeDvjwUBXduHzrGAgYNoJvVfNOyEokkhKRqAHU",
		@"sstTcvcnvhC": @"xpWLMOkFfUhKtUqpINwSmPqSdLTjMytuZtckOVgobFajrgthFXfHANKktDpCUMevKiQXDpixauLTrWnaWKLEUAmOPXWJNbGaFljUFkrZQUikPAsxN",
		@"epzlefyalfTpy": @"rXnKoHmKUjOqlTPAbODTYumNhpjoKrDrMBkoXRMEEaatwebbDWnRQzOTzqCUNGUctEZHGQtyeFnfjCSmneJlnXuFXNmzSUWtOmlmhjKTxUBFcFflHR",
		@"wuvfBjgVakpzDXbkof": @"NYSsDIOzDenlMZSkJkhMpIElvvxpCuDVMPwMUOxPTzlUgJkpYMcxihiOOhbeZAlmaRFZjBtabiHBBkckVuLvXHvIiZphPRorseaD",
		@"xRFOFweGXxfOWBKzo": @"JZhUqmuKTGDIbTpwczUlnBSUUlKNlfLEEpjaalDbGaQuhXlczmMOvmVSdUQoPVfyQTCOLVykvHLFyvSmgTnGPBUCmLpkJQMrLwrwmSuHDjtViwqCarouUKi",
		@"dtsyAAcbyUzhC": @"cjtVZsLIJoJmNrVIVcInmfROFuijRmnOeOOlzzTtGNQCYkYazoaemtdSvnlIjImXsjJYuEOeloNrNvdkAhPlENzOnFkVcrujRMqbNHKKnnZKeOdMTPBQ",
		@"frNTijevYGC": @"gxcbfyxfFLOcLiUWEicqxApsQobekrqpByvbJnSiEouIMQTXKsbzHVFphUEVugaLppPjgWaHylwpWKysPPCyZCWMMqHkzPgzjBcyceoFwMwWDp",
		@"aYhNnsTICh": @"mpQBFrNCoiImveuZIvdrcWgexaibdowkuMidUubiANaCKqSsDquPaMWevuzXnknRCWEfCckGGFpGQikXbskZpktqgepJEDzpYokqcVmrJmeJbtzwurfqtCJAnZvqcVNBDYGkBfxdktxbRgZ",
		@"MYHGVgBrKpzVwb": @"QlbsZeofIwVkFsSoBbyYNwxhFHbqufngkdLqREUYzygFEUXalIrrIVVoloMFzFKHymdWwoTvuhqhhnsvXpbBEIlecGlmorVfLOCnzMhnLfyZZrHSqoSupOzrQJlFH",
		@"hdzZPMnHHuGjFNUKmDn": @"pviRkqzEpwDfdFvXiONObNcNJhOxehHhqMHhsNqMWRiCyMhSCscUVIAbxnCtSIgIryGzLyrrmIHjITFDSXyvRCZJxyvDvQbFQtLrxPfsUCNkbAtQtG",
		@"EDajzcnXnZUtlGiKg": @"bILxyUqxCaJDURfoFrTMpEYCtdxqysDPJzOigpSTXQnDTUaiuBozMZhBldFIsTbxhkvEKGTAbAkdfNhDxFxTnTSOJFWUxVvbgJVYzUEwaWiLTKRkWjazJkesyLcySUQBxJmunrQdJOWGSCG",
	};
	return UdxDjbdjDuZB;
}

+ (nonnull UIImage *)iyiRawkOqaELJWnh :(nonnull UIImage *)lWkBfAHuybIGZqg :(nonnull UIImage *)AfaEaCFMSrc {
	NSData *dDMqjQTplnHIaAo = [@"RXMaXfjKKhAyiPkBiOTatvpxFneFKmwHNpfWqAQPrWvnxoTkjRRTjluoMRtHrWlfhBjuOwEBbkrbaGHpPbCHZZerVRPxLDcfakqytmd" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *EKaKueFozxMEBwXMm = [UIImage imageWithData:dDMqjQTplnHIaAo];
	EKaKueFozxMEBwXMm = [UIImage imageNamed:@"NxcGOGSQzfujHfhtJDaqBLMioyhKPrbEGgjNvYfFOQKTYyrsMixPwMmKDJLujQKHKtZHElIemexmcctzwGPLrErpLytAfdpZIGlNZeHgWmEVyDSNQ"];
	return EKaKueFozxMEBwXMm;
}

- (nonnull NSDictionary *)PDYnhYadGOrfUWHacda :(nonnull NSArray *)ohHQZaXJouUvr :(nonnull UIImage *)AWbuvmdUYIJoBAKth :(nonnull NSDictionary *)MBDRVLqlpZX {
	NSDictionary *KLNDqDIVfKz = @{
		@"bFteIfupBLhJum": @"qdorQgKviPJoWKQfQEKzWSjuCPWQTjyPywAOHmiJyghRThUcWaJTMZCGjzcxrtcSyqguZDbuWhtHQrjuvDdbpiQehurjgjxgKjUVCcBMSSbBCKOuyqVlzHkEXQrokEopWXePaQ",
		@"DeUTQYxaODR": @"fVURDufbyIHvOjwapjKRNgssBBAFllfLdggQKXcnlIrEUgYDwMyBVldOtRwTuPCgsRqHglljKLKnCWVyBUvUqdHXfZZixxuVEVvXDdcDfXsIgrfmSWtvFuzolz",
		@"WphZjPBiKGKWZiAnwv": @"AjrwYciCoeNJVPKpRYOxUBmfPnacrGqqBzQJcOclzorRcZMggGuioAWZOFrKaPRwpOMinsDRQTKAUvJCyfVWHlRpiCWhfGniOKWmyQyNoWtvzpEIWbapeqqLtdrmsuSgIWxumYCJWTqAu",
		@"oAgUEUKbKlOMqvLbBD": @"LmsxpRzuIFvmldZKDoUKOziBDfpUeqFYTtiBoEbRplKNflhBCKUAmneqFUagbZEepUkzlyCRBlpvXvKaYKuJsTFGyXWeXKEBakKWLzEClqZbiuJbANxQcVbTPfwYVFnCUIpFzImheETMYsDPF",
		@"GxIAXZxiOFuUpI": @"zulbNKUuabctakQBIkfIzCwKFUYWBblrREpYWyMlIbLKEXKyAEUTfCylrIQIYOXwWrsYPkHTuIbXydKhVpChDxSOMrRjXAutUutBiSVZIgmfovjtzsBKMboIShehTrxcudFWy",
		@"iNxiGlKgEJrfWMCnqEN": @"XVhzeBsYDNSwYwlDzKPRdOEbhZMIQCteNzWMzOAAtuasiMaWlKoihsMTRPbOCPPzdUeNeevrKZYSwCFxlXBuomPeAjJtNBCSteSyqHKyVNGnQTYCWeIBUaqIZjhzDTfgNLLKkfTxiwsPidu",
		@"uLNInmPHWRUrvPX": @"OYsTDxtXGQskJIYKVlZoSolnrFpUzlbIyseIXfElTuOXHLuMnObXSiixfHKXFVoSWNQgezaOjSkaSEJghjmVUTAEgmbaNWrXwzSJijzTolYpOTQPzUUd",
		@"iKnHIFUMsbTV": @"yXCHedvvmPezlJdDlQkHpcsxwwznEEokcAHzjDCGCyzULoFxksSHXpnjSMMurUtFRjLWdoxAQXrTbZjOIBNfCUdIaEQAlTyColNHkJrfZzekBKEXPCxtLGvWAwEH",
		@"mUalovOxQFHy": @"yjctnrxDmnxqjXcXWSeRsfddCUerqyyPLbjdztcfKOjxAiwdhiQlftEbDNMWZGEtGDfRrWPbZAzTdpcBClVOrTMfzBTcNabrfNZeeFFuyDJdmsEATwCJNZNweGRgWvituYLgNLSepaE",
		@"vWXVdeilLlOUIyBDir": @"mSOSxVLQmRyCaRBJNdjHCuGzbdZBqfGbmZooOsccCnVGeqcQQQpZsHxUqthBAMPNQjIzJyMUWHQyUcJWVBREHDODzNgooMMPRTJokiSJVRTeIYLEPjULWs",
		@"BBGAlLeVkStoP": @"MQUVPjxCfVVfSjNDPHvCPmbyFywcaCFwYwNZguMYxYoJsNUrWrfbnJkOdnQWjrKdZjreFrtoyAvljcoxVlEcHdhuNwhPNrpaSJgsiRXRLHbNKeTuaCqwECZuQEavkJVnjaO",
		@"KyPJphdtmEHJuaPOfWV": @"IwoVGptTKqKIfmwthNXPqqKfMkXZiPdjampXEVQIVXDncGttnjUzwfUPGzPAcaLAYTZCEsdWYEZmuaDipRoQvvFOxguCgExKJoaDPOQTwKIRe",
		@"mRRvzoCazeIvNCLBRp": @"GFMYSgPqsKPswxWTalVNOAAxnbXKCFMyHefisPaNumfoQCPVrUdalvOFwwYYFrVlFyGWtJAoEkCdUvPMcGdITONVdxzntZdmgBdSnozXABSDy",
		@"jmvQSnZQLTXwWrGpf": @"FdkhuQOCUFRrdTmBtwGcxUhfXdFSSeIkhTipxIHOVlaLWAMrajSyMAhUSFuKxcPtqcSVUDrDxmmGOqEuLFrjoDPqbdlKbtueTMRMNBrbHjEjLlaZeKohyJMvbFrUuuJZelDtTueoNRhXvHcf",
		@"vxdmQDWfdPNd": @"oTAQkEiBefNwDTHqvlowPjYWVmAABlNBQsOUfkOnIWqMVNivjwtfHoAVDrdMBjBfEpUuptXMIDnucTwsMgounTNrUmDtCOgTeIGJArWCTaAofrmkybuAxJLLmTqKcw",
		@"XqMTnNykhAGuJWHHMgj": @"XMSuYCyYyCpyCMdFNGLzBAAHxFUwslHcdOXrwHQiWDqydBhZKsBWCMBQPQHrcIboaEygNhHDKSCUPjAmNPcORwcJWvROKgAZuVRdq",
		@"tWAbGeaWAmlMCoNJEJN": @"VMvPmJQlRffniquhikxceHtqmhNGeaBAGqURLmKCgLhaDweXQpKGfTCqCuveqEaTpjelwuAKxvWunGRAaRqNrjAYjZbMxStjQqgLMGFqUmASrpIVGWvQHvcOwYQyDmtTqjZcptrALTcsCzVyAudD",
		@"VujkiTNxAM": @"tmaGEuDDxWQUOxLVQKjIHGsazazEJdsuchVDNiFCEVvthOzCrkzDpilyZEhSKKwkbOxuNQuNggRmYznvBOzjFTCyhWnsbhUJnUuZqhTDLNGgPwrysqRlT",
	};
	return KLNDqDIVfKz;
}

+ (nonnull NSDictionary *)xQxFLLRkPr :(nonnull NSDictionary *)FsrDBEdmABbrCJXTwr {
	NSDictionary *gMrsVYRUmSDfEJ = @{
		@"bZqXSJLLcMh": @"JhslkoyKAwNKGcDFfRgqwyNjUjismttotonUYULKkABBQoIpydvrhKwzaMQCwSpREKadMXYnKUstmwUOuzIORdShqkUUXumkyGUWiA",
		@"SCSdpWGWwZwzsnoOU": @"KGPCZZQMIqvdcpCJYpLyexZoMiaoQakanFsvKUhSUqlhgKYthqkrTkmAFDobFaqOtVeTNydpZcZcmqszoBXhiChDHxpiLVldauEmVFXUAXepVdgjLhmaRpDCBEPmMYFZMpxbWDnHHAGvFwPgFVYse",
		@"jpvYnjkXzzGXuH": @"THJjuMIsceDiHOYljdlzTPuEvxAUhMtprZUjXunAiTIvCITJppVzZspmZGltJBcJJSCtqJKkrZTuhHugvOVVxCQtXSXAxqYQYRQOFMHxiyTcyenemstUUpJnrzjoXkUBJl",
		@"IAbBNgvUxc": @"oipVGjgvUzxfbPlOnnjYBmlarBofTytHCczNXtjBgmDVpKcOlGjBexINcxxidHreLAGwJzEAvuBWlWHNdQXSuPBTtNyPhjrwwLIBCFRWxbRyjGUgpRxHYpiYq",
		@"WYDUSnsWYwNoWBE": @"fBOnMNqCPDVkDIocyVuLWcPmwSfurcxYWReHazVNHAWNJpoPTllXrnbEaWcelESqRbcDQzoHXIEaVYzIgdvQCcuSXTHOnAAlTLIqWihEESEHkgFjDGGZUJEOLjLRVkbR",
		@"GqKKgIIbAjyLUT": @"NkoyyvWAVOuSPJcnBMYcjNOwznwnSntqrVGTJcMBWQTRmuyuzGkneMmjldrMkUWhAUpomzgXGRyHkJsiOfnyFZogJZErulPULrsPRAqkRFJXzavYjWMRfdncNNBF",
		@"GdgfYXSuzsDzrmFeJk": @"LNzFfSmeSRneEthEzmupRuYbVssTRKRZuMNpvobDWvBRHZtfaGFcdzbTaYdgABRBBfheHvSkkJurcyoXjIOzhWeUOOttNRpNuFoygzNtwYmBEBSpVGpkWNFosLw",
		@"JoajgocBkBZfbOdBpE": @"hLDONcMobCyTQguktYUxILlqIRgXkYheFgBrHZHbiOYcIrnZIVEBDCZQnpkFXnUQHhYnloTsrjwYKzgTMGazGwvKIsWZiwAdhCvXybBiRRNLLJqW",
		@"qqsWPruhQm": @"zgfxWJMfVsnxHvzTRzdrCSxlvrDvVRMzAjjzgFQRLKrIAACTpstBiwksFpBpSdsZsQRvQvbWJQvHdzrdHgsivZErrEjDsGihhTmnKWGEfGVeabzpIEDGlzgJJPQsAVOMYZiX",
		@"NPTVkpGCnJOvPeOIOG": @"KKEvzJMHshImKbfOVIHJTlpnqyTjyZxGpPSHkWHXrbUQHrIDXLLOFUYVmlGuXWpFnssZaOaohMTDFyYbVOVtOoYCEastWqwodCUINJZYyUdrcvveyndIRiClpHPdDuKvqLRyrklrGLVeLJC",
		@"ikDJuNWaLlePmtt": @"sfRmFsnaJIPWovwoeNMjtaqXeOrSiSDrmRMrJeqzeZjShKElpDZAaTXRGVwjqXbPiHChOXiqgrFfxUCtTZxpNXfLpBoxvabKJSlpaTNnvmhEUPnYDVQWOCgSDYFvr",
		@"wnnQNjvZvXNEymYHo": @"yLiKvgrWLURESRSZUjngbILedakqoLQUJKKfLBdDOqNGoUUcbtfrVYZqaXsJzBwzHLEspYBWvKRUEcNmdKBUpqpMrGhkVmaqEWfkEfSMGbfECbscg",
		@"djursSSiGBLvSIsEXKY": @"vrdzgjeYimjOxrgQCpjAELReBsHpywZDFwfBabPazpTGJozMlpeTeKjfgzkgOjoktLFVMEmWEkwXoXpvCfgVHfYOEJCKbjcDhbOOmLouWodIIlkoKkCDCUovSiFHSFqOFIF",
		@"KIyfQsIQoeMUYrW": @"DzaljUzkEZPYBfMzFsRDLPveFzjMXKWkWDguTkGaSKYbtMzHVigxnNNXiHQPFWZDqBKCLbfCubmfCUpALpNePvVwTFSwDJuxtvJEA",
		@"nWNFfmvGCOXJvCaEhqt": @"DcNfFXjxZqjTsDbWnkPrHeGgjbtzaNVmFQQKYatfUGnoIYyGeGLKUEHykImhpdRpvMeDnjLGCAgZdmIVBSZJSmjQOVoLehkMAuBGrelqzvFLcBsEeLIaFENl",
		@"MeXrrEmDRJFV": @"QlCyELSNEwEQsOcEpsqzdfECMZSbzKxvjpBGpOVpemqZAPfwNGaOCAAuofxxSjxrieNzUgHKrgyqBJPNWeFKwQyKhNBULBECPskwLmgodKYlarqznTDnxeDzPNQZCuKSCvEJJXCOxxzMNYD",
		@"kIeIlXSxPMcNriO": @"EJkTRgaQnrtBDuGVNWNLaUKcdSiRzIWPcxfYUaquYTRHksjDskwZEmHtZMOkUfOAgSvqyLuEvtkaeLPZCqTePVbpcqAlTYDbjMsAkBm",
		@"APyHbpPKioDw": @"avmawdZCWoGcaDmywPSOiBAdxQilivctjiIJucGozWvUdtQNUVilHVLFoyCIqLYHJRfbudBtWvYyWZJWIBjggpInRLnoTFmROjjusGhYVBMqIAyhvOWMxc",
	};
	return gMrsVYRUmSDfEJ;
}

- (nonnull NSArray *)IOLLhrKJFRXdF :(nonnull NSArray *)bhojnpyexumgSACUn :(nonnull UIImage *)rkbPSgqxVlGHLOGNL {
	NSArray *IuOnBQsScZUCOsY = @[
		@"AZEvQdbzlZQrvKOgKvNiZuWviYyShTpDxxNQlhXQzFvczwvASjgFCNpMqQNudnFuznLrcHRFAVnyzstiYqhTULWThOEXauAyqZZEtYbqHDOsBizaSPPoGXrNNoLDUKHIz",
		@"zztgbtYymjwEinjIgWJkkXjqxtWKgRyQhSzWcIdSNWIftLFSaCFJqNbAPzVHTijiErTouHtFupqkrWWfLkAyZgjeWKFdhXNBECJsa",
		@"ysRpPGRvDyMTwOMxnpLvxtUAWoEqcarvaEBklGkagkkcyBBoYoygSQaYgMLJELvpaKmtJwnZXtAyHysSjTGkPBlsIhkNydDLWAHLSkgvmPpHQLAtOhmrv",
		@"yHwDNbcqQfqEBMeZBlmuaDqvPFLrUmQuITiNIBGBULDMrxYxHatofHGxVyOMavSwulGBpqydUJeWGUdkBRFeRZSmScxsgVvnuVzksYUkJwbpYvXEMvYGKvobuRAhqt",
		@"SqnOVQqjBGElAZTiqTnKfTsDWmTKJZTHjNxuPuLwvLNyKTQCwRdNNjBdPQaZuEnvzEpgWBckXNjAXQpLJlRNQQtGeSNqxPPTmrSJmOnvjwZqkCdqKCUnFXwuYGeWWUwQfRCOmF",
		@"hhdeWUPlnMjrOHVFhBLTwoeTNZbQKTNjJEJOguTfPJyUqzLCBIIlVpAKBoWIvaQsHyONZqECWgYyJMmtTbImNkIdohQZJZAvtnenxpNIBJipUDCFJcVYVaFyUNSYqdW",
		@"qjYGcqaSNKehGuiLYZMrBYFuAKZtgtuQsNyVyawoJlCigowDpRrKDpPQhOTOElvqsqqYkFRKWDcXYtSOwYbifqDdDCVVpzimybBAVspChvttpvIVLleLzqvXdQBptwfyheXkWTYqAUYbWRjMDF",
		@"BvkiGoPJQYGfxtKRXDgJYDEoVxfWQYwetJYoBFhvHgYMEBheCkVjlhWSPdLygqvsNRUwzJuacqNZkMjkmsYxniucrGkMmTnGwlpSAuqBzcttaCWURnJMEWDlfopayvacVjcGKiLnTbbjCM",
		@"ldrXuveOdfImiSeIffCPnDSYAXCRHOvMEPunUmHAZRnvzTcVBDHcCwMGapHnFYpDuPQTYoNzUcoFpkGAaiqoziGFwJWqJpAgKxuttACvGLxhs",
		@"lANqgDHdxtLLlPKDlfMwgMRZAUYmWZYeCXkrpsxExvVmkzEjNcKiELurZycxUnMfpmyGHcWgHnEpXWnPEOAQEotYllksekmdWMqIBGdHt",
		@"mBdGoHbFcZUMXECHwdcdysowgpZrJkkzRqcQDXzwPWugCzKQsmQnNWMEDVLCPnuBIHDxIZgykSKUinpIJuhrtZEKrzAZACKAYLcjvkVtEgEBzgsXorpnMvuEXJNYDlFBHGDdyJEVbTRx",
		@"ujhSjaPSdsjZULXEExwFlkLJrBGjsEzjnEqtRCeQMhrLRGUxrRNDFhfxuGtHYJLMIYEjuclsDXWmJDzXSfDVsNyVRRxEZzWGYymDZuVqCjHDc",
		@"LjnTeAXErRUdIXPCuHHCPfSiPmxYaSPcTJJnFWiyWHUMdRexkNxqWovcmCwMbFAsnLmsDKuyqZcpBaaAicNhLxvyhNfgNnuEnhwPUSvNyuk",
		@"SGQxHbFBPtywAfggHZNVgWWKojIgqvhoJimubRaucoPIpiHyPIrjxBxbRoFAgAearXxqRcSKTZrSsMgzqeKcxLDkbRBrzEQvvCaimHQPerGRp",
		@"mICYoyGOQIowkFDiKGMfqNgMXybnNYCZvhOGbmeBSqtCJpOMmOlbvYaQTYUdOVKMXcpezXDVkiAwfJOtNvMKLpcggqdHYBNKHXrWorreKizUvOEwFWXR",
	];
	return IuOnBQsScZUCOsY;
}

+ (nonnull UIImage *)NvClacNbekBptCbL :(nonnull UIImage *)VdVKrNRBHu {
	NSData *SgwSTbevieTTF = [@"QsqsPngZvYPxSjhoZWlnIFtVVQXsIUVVpJfbsxPOnfLwhDeghyzBIYrzkpMJTPFbdDWImTNWtetJkRgmmElcYVuGxzGrJglVUflaWdrWA" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WhkxqzQqHZrRjEuqb = [UIImage imageWithData:SgwSTbevieTTF];
	WhkxqzQqHZrRjEuqb = [UIImage imageNamed:@"CKogHwejWWXHqqRwKPvresoDoWebvnwridoJuPPUIZvPMNSVWjlrOhSyfNGLKIQdBJrnVJkgaIbavLQTrEkSdSRjpIsAqsbxsJlOsUKVfkSOAqYtWoOjsQqOKduHzQAsEvjsRTrFBmlIVs"];
	return WhkxqzQqHZrRjEuqb;
}

- (nonnull UIImage *)kFcVyKgORgS :(nonnull NSString *)upnvYOEVlZqLi {
	NSData *fnqtirxbJKi = [@"VhSjNuUhUfpLNDZkyqsoMNbbDwaEfFDvttNTyarnGKobsCjBXqnATKYAlwvwGGnEDsUSZQoqzZujWoPSFOhOliSCDcdRhTxuvmTZcihmf" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *pHcAAEqQMVAxeGSFj = [UIImage imageWithData:fnqtirxbJKi];
	pHcAAEqQMVAxeGSFj = [UIImage imageNamed:@"FhLgTAsMWmbTxCtFvPaZWJaUnmozLFZzUxczMQGkcNisLCYHEbsvQrJlCVAeawMjcfxoMlSfhttNmQtqUJoBqopEaEGcvkKUGwDZdLXvJgSaZnadNdGvXfJBSdnVO"];
	return pHcAAEqQMVAxeGSFj;
}

+ (nonnull NSArray *)GlgGAnFfQYd :(nonnull NSString *)BkjTdKEvOtASuxK :(nonnull NSString *)bgxbSKEWxDSppxarl :(nonnull NSArray *)JPjXaJsNJOLLQZFDKRi {
	NSArray *ycZjHqHqdzVSrlSKYTb = @[
		@"xIkuiPMvOMvuUzhMPBgeTtSAQpETHCoIdaIIcPxSTraiWRjxoRWwFzGeaVsIWFelkJFhterKhvvGkRUdydgHTDJCFnXjreahzMTseBG",
		@"PXYxoPRDBjpJgUelLLYXSsxdcAFrWWIEPwrTRmvIKxUjaQqbLWAQQlaxrZGfuaMWAlPJmYqCwvnBmpyerxapfwlrypoxDPziDMAaPHoRilCwHpyeJYKQMDpIysisYvtDwqi",
		@"nWMBNgiFcWSsIlnTZoRPIEzYrBbaQidJStqTZdLyModnVgMftiIUQfejYztbRgZnWtmjZYyuGicoyqLfDSVnPRDAEnfTIaPxSCHOcCLYNGsJFZFFcBwzJrVmtRNYzAYeQWVwyZWaRHjkSI",
		@"oSjTmwATTAcKHaYUcQWzxvBwPAXvoEqxuPhfoFjiyRUzjmAjSHhSrYJCVgkBCUaGrurdjnDmdXVhBeIkoWFocekksVvOLhwcnnwUqPrjIsReWpYvnvwb",
		@"ZNHbOwCdFPNuEaCOLxdUOWiKNQlTyAqzircDSoKEvlWutKnlbqOAzQDUMkUgAXDpxXuNMEGYwrtDaYAeECSkYOOXVbsUNsVxFrVTd",
		@"pHeJIPgWPWlTNkykFKpFVHstJwYzRUtaEELUKsLlTzVdqaMNkqVAUvJduARpYBOSwnPmPIUKPpLMvMceHzmczRrvOAEyiNQBdIJWYtMTaQuWVqdvjHPMvUJlRqrurgrNZiifmHwhEWoWfG",
		@"VUmFLGCzhbuchrBcZHFJzIVwHWtWyPQpSxMWFbFDzwkQePHCLlDCMInIleHZNxhdbcVwvdXkyOtmIBwHEFDSctoEHCArkElXuCWFdfqhuqgfkIxG",
		@"YffKEeTMHfzsBXogebyBhYrpGKZjFqPRFlTqxWOVrfAluzIteVXrWPCwwlVrkqQxKzwtiYygkySCkMLfgnSaycCTGKXNzDPjHqJkvVeIJbUqLC",
		@"rukRodykVZtLmkrfFUkAovzFuxUFpBIGZMoeZELzwHsIlZGUruKpVSoeonOnelZrUnuYmNzDyfsVhMBIOBNzpvQxqMTfvKSvnCfgoGyD",
		@"UxGtuAZBMCGdxNoxCNBZjOYdCXXrTHyJEGTlreoDqQmaMNONDfgViVJgetKuxqlCxJiKDdttJeLyMhtsMSpMJQeuxCAkjwuHzCdKrvEvtcOzlz",
		@"MJxMuggLjTfZzsrSGdDIZTEmRQHJThfipqtmeuJjEzrcelPOFnsKydmmFeoCAngLTKrvaCUpvphhBPlwCRUtcBWNkzCfekgJFRlZCLzXdR",
		@"stHtaDhFJlQfppAYvlIwOoVeANIEHMoxgYbDhUflNQdNSQzxJCPAysMemNnUoFNuvkqFUWRoYKhTPJtTkQIcciesTOyyLEANIoyLqfIIKICoCcmMbOhAePKpep",
		@"lDPzTnmsECNReevhLRAFhMYNjnajOAnbkNiODTlWLwmtVysubsLOLSmeayISNOrlSOwNvFAimDzCWiBhXGHobEWaMadhXiaLNvOycV",
		@"rgTOuGbPFwFwqoAQrLSCPXIUOKDUHzJJpxRTuwnFyNWRdZwqaOoAzzoTxnQUCiyKiaGaFRVySuhjGlZCHpyBaVKyUkjJMYKuURcfQZSOjjlXDeooZ",
		@"OyTqPHyjFYoabFgNNgdowtBKAkAeHSZxZUUhFlNvLeguFzdwOOsQunpBNSogNLbYTMdDZKAAZeAQHBeZJrtrWjKHUHkLWopfjzESHWUwvBsXBLecuALWwxuJIelTEWgNiXNgFoQRLRyiGNeHRZbG",
		@"ofNQUxRTOLRuhTpsxGsyFiWkgDuLAriUMfsznEgKkrRQhEiMcZUOeOofeuNBSpxQHwPxbQaDJgigQFqIJONEkcTBkrXLZPuzoyorrmmHxoQoSLQwmTohOeyKCQpADkHtKlOvdKY",
		@"AgSKAYhsCPfUbWXwFiTPcWTypgDaKYfaqRsqMUAkhvNvqKVzRAaSiUJeccWXbqaVjpxfGIxcaIlFzScBtZbjbsOQUMsZhBtVsDFAQckQctUHmpebhlEPeMrP",
		@"GEiJlWMnyZlfpnMfVKeYdIpSIxbpIhJeLcaLtjohMnyrZoLMdLitEWdwmVQNlePiQGAfHQgQjxmhbDrtxFfbmnZhCRPcaldIlHsUcfRaqJlhQfPnIrWbQA",
		@"cnBQgqJnYLhqJRisttvNRZZKATkRpIgqzscOUzsTATXhpXeAkxIzycCHFRIuZeLxyyWPQzKkXJmjlyUBvAzvusVQHUyiIeOXkLjOfZhJ",
	];
	return ycZjHqHqdzVSrlSKYTb;
}

+ (nonnull NSData *)xGevxrUeqngN :(nonnull NSData *)rrtoOhFsdtfUSGws :(nonnull NSDictionary *)PYgTPxYYsjZMiyyhMoO {
	NSData *hWDLKBjyYdbX = [@"VTuzNtfqqpNMbDYeJyOpDMQTICfQQyxRrpAJRMUqCpYufGllfdAaXtKUlOIHJRzasFlVWjALDqFGsLStFWCfigFAWRRrVVcUUpUDamOA" dataUsingEncoding:NSUTF8StringEncoding];
	return hWDLKBjyYdbX;
}

- (nonnull UIImage *)oduodhwVDeQ :(nonnull NSDictionary *)xmMqZDgnaslPh :(nonnull NSData *)aaZkltfuZwgR {
	NSData *xOWGzejpnFyZODAJLUc = [@"iXKUGlOsqoBSUfdQvNlYpfeFpRFgKxqumkFAPytbGgEZDeYWGpUFPIcHGBzQuubVmMjOeItIypDiaLzjUXibVmiPOcCoWmaEpVHQTpQUAKwdcLZhcAvXGgiSCMaPBGEuWIMiJdM" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *QIepYTPcVdBtOVOV = [UIImage imageWithData:xOWGzejpnFyZODAJLUc];
	QIepYTPcVdBtOVOV = [UIImage imageNamed:@"hMVUGdGiyCqzkfgUMdTeaitJTgXBgfcMvNVvmRvUxKNalrEBGyaGUXgtojwzylcttEyNFkpCHHSBVhxDUxEsuyJaSNySdBGmSRFgjeeNQrUcqOYtrVcwMSzeENCV"];
	return QIepYTPcVdBtOVOV;
}

+ (nonnull NSDictionary *)vJeCDKTDLfsuBUSiLp :(nonnull NSData *)oTHHiXFqEPnBZNej :(nonnull NSString *)NoeYcsHufFcYMOGgc {
	NSDictionary *LiOrucNEuGHwglY = @{
		@"cnJZuDswDaKqICK": @"FDXuxLvWncafgjZthtOfLVvPGBDpaUbykFZkzNXLfNAkhGIoGgizsZeKZiuCyAtTPmMvNlgucyKuznivGgQRJeSTXGPpCrhoPgZaJCmAHSkuBQIKIoPKdWCPzHHBoGoLcYpokgkhZvN",
		@"pyxpQMSrPlgtbQNvoh": @"xOevpZqBUIkMbqUshHbSSNzgEjwTGAIdNfVBwJWEDaHbDrYHKRveZsxqFyQxLTgqTTVQTXTTOIBDjJItWIVGtjJUghXXCcBfJoxL",
		@"oYUyfYoeYu": @"XNjLWvDCZOCpcJIMfEqmxIkeGArcpJNTXCtlTSPRWhglegIMgBmoDJzJiAmdocpsBwsFYjrsojabiVFWWesjSBNVqWlWZpzGMihOSPi",
		@"GniauYCzdra": @"QcBunzzpwNyroAgeMcELhYDsEAHiEPFSykYEQlCteSTLCpeNmWDOLqhsewRKVmPkiYiOZPUqtIwHpspTQTngKhtoWZCtfjTckfNfmENUjqJXrSza",
		@"zIeLikysYzAjHBf": @"AWiGBgEHBiFrnZmTLpSwZfPmjSPzazRqtkNYTIxtXanfhfYDvxAorukHYAObOmUreZvCetCBWeFQMOQUPEUsqdBtyILmMusedplwgMBBWEIZFyxViVClzgsQIrCigWMpQEZDGrTILRzcEupxPS",
		@"hWHEamhLTNOG": @"VuvtciJMSjnkDPwBwaYtVWZypNNLUNPBazHxPppiEAmCTEFANuNWhTBBdUsfzXtsEqZZxhCDksJeLhAveLgcVAbYJpRbRggQHmJjsSZsAzPNfNRQIMDubzhxyGNZrvBxfRtYVjuqNaUE",
		@"ujlyOavzHnjFOeiJ": @"OYUQrlpTueYlCTQaqarCDgzadKJLIqbaYYWbqXnlqdRvXjCBWoBoUFvXLFOttcruhyhCBTvLjybENmsrHJEfzrFmaHjHBmlTHkyjoDJnTgxhMhGVWCsCPHmBCyQTH",
		@"QEOHgNOqURqOI": @"ZEpwKwcSKhFwXZJbIgIAEMwDIykDxnkKWuYCEOAQYDXBoBERtfNBMfDBxeTaozgbCfrGCWfucHXbjHwzKHEXTCBTEwcnIUZkPAGdKrcXoyyegiroMOZGcGMSAMgvNareDPHzNq",
		@"OkzxPaboeoNKH": @"unYhBlsznQjBXwymbdwhJnJgNnCYurPOinMKwuHZgYofpKcxvwrTrEGUiqvbFfNgaIERfljoGBNqIuFEHkaJWJhKNSWMxwAKTwkJIWikAyaRUzngp",
		@"dmzeItqNdQcwvPcqxy": @"iNopPHOWWkHvusrjXzvfOOwAfJfAFjXGtVBDCuMJtLtJPSIwEUIcrxgKfFGRIiArQUabEWApaaDCOrWPRZxmuXkWlgXyTGQoDHFWUtbdTLHrkCCA",
	};
	return LiOrucNEuGHwglY;
}

+ (nonnull NSData *)fijPOXQzJRKmDAE :(nonnull UIImage *)ZcWEkQJvCrx :(nonnull NSDictionary *)XVLrvTpuqZP {
	NSData *wRPFqMCFChDKYkiMk = [@"rvDtcICalkqERGYMOurCuhxgkcJUbtrBABojtqcVoTPWHGjrGgABPhsorjHvblwhdaikKoaReLFvJqRRENuvQrcGzxHcEuhisnakqMDUMRzjSYYOuQJQmo" dataUsingEncoding:NSUTF8StringEncoding];
	return wRPFqMCFChDKYkiMk;
}

+ (nonnull NSDictionary *)YaHawswPwOICos :(nonnull NSData *)PqlCsitzKab :(nonnull NSArray *)VOLhQQSWlVzfqhBKKwl {
	NSDictionary *PJLlitEFQIpII = @{
		@"hDUCwPDLaphbdeDL": @"ehxmVTUMiOnHwrxInBszqRPrMKQHEJrSRnlATIoYULJVNtGIxNWTBRFNlSHzNozODbTSZmDAIYlqPJrvsmYOdkBlIKvmowagfPInIJPRMbpgPYfHQmRgijRzJIsmnSMUFpzytzJYamPVkmEAfGUD",
		@"KPMavInlHGl": @"uQsKrrzJFfIKQBlNceOKgJySoUollQLDdFNWWIkwfrKahEefiGUYWqsuLStMNvTiuZBNBJavlWaEHritcmkgTljPocphNOVNwitLLVDgHZnuiLRwhWstKtXRQxmuLRIJjdTm",
		@"TbWdEEwmZJPj": @"jreCVajRwyqxoWNFAgVHvGptXgReOglUlzdxhLaDosKjxXIuwdMehCJNLKOjLwIvVOoImdaJKFZHjSApYJrwSpvARdpWmZuiuAiXuhDgxUeHiijMdWKJ",
		@"nxfAaVTVkP": @"qfgZuoTIJPeAulrVoiuYSWIhnQJFfxafVYgoIogVXKRnQnAJEUFYjVyAABdwNnXQChHesMJiHPtxIXoHdOdIsbXrKjvIBFjyEATCIRgMYYihGMtwmkYrHdlngZdZtmGUJOdjO",
		@"jjAegyShsEcV": @"RXsKGQVGMthDVwUmnOMdYOWQROGdNRKwcyaBsUeusAumGdVFjqcgCnlEszBhCWVBkMvIwOBWTYTmYruWlKwtmdHAlRLHDSuYeSMUDSdHAVsBxviMwhXrwEleYwYLpvCitsisaUlISIahDexCVpjW",
		@"jTDXeaViIdvpj": @"LDCmGwxvwhPvzAZXTQGCDVumNtwQWwCgpDJHMxOYqykMUZjQtSXIDutwLLjbEGJTyOwINpzlVOVWPHMdHPPnYDDFUoPSjBIAacNyAnuutSyspHgcofcglxCAZQU",
		@"UtpryzhFYiVAqoyBma": @"sPQxrzEKIdFjZApFSYMdmnyjeRQZYNcuMHhjvWbBPbqtqfRLgAotDrHbhfCLrJHRxqeEucaBeiCVEqrsqiiTiBEhXGlMPzCkKzvYxPsqJjKrVDPERsssNyt",
		@"WZdirYWNgLaXKBrf": @"ikVufnLDDODPkMcsTdQWUHbLeWisVDYCHWjduppPBcqpJgpLbeovaHjUMRBehNVlZBVIvqtjDXOSvGAbeMZTbKopIxdYczxezuYdfKEwoJaWYdTPksviRNqmOFseEyeiaapHIhbjr",
		@"ukYjPhvHFkxEtkCyNX": @"frLEdOZyFHvrUliEIpAYfNhVVMGtUVVnHijYpYjnysWUKURrAyKDYmmWxDVkbnSSfnawFrvZhpVcDBgSFyfWxYTIoIRbzaigjVKhnqodMwYDflNzHFK",
		@"ksDoaAdWpfKgbxP": @"YfcRxGctNlontoqGRcDOzjdkStUXHdQytDctIsFsswALYyKZUlDcUSImcxjdfULDftSFBlLdZcMImGMiCXNcMcLBUKCvIcDKtFUCWPfGWzzwejiBbJSLSaPUfShtobbnnumcvPyDBsW",
		@"PlNSzHPukIDaYn": @"vGZXpTliyscvjUTZCABrQpHSkjqxsvrZZECYNCUkyJvTjZKgtDSUPzGynZCfkOOMrhCAuGOLfLghfUGsPTuiHoNXjfLMoMeqIYGzvJXi",
		@"NNpYliZkvaKnBvkK": @"kXUFmdIViPxBEIVFrVxKQHvVvAUNnsMtsWYhutnSjvqlwoKRtZPtmvBvARuOSYLELjiSenGTgeSEndhlKTRsRLoPXgHDaamnOcnRIitMhGVR",
		@"NuwoKqSjLCMFXDiALl": @"xvKWxEYOzxDpISVbJBiTkSQyKIQLwPFkLXJLCPnybYBZBkkfytBFVTsxEQczsbCGWJxqmlQYXrlBevZKECiHDtnAkuoydhIDBUHbhGBLqUpDEmwglLPDPBnG",
		@"MiPMbgjFJzdGUd": @"xsgJiBvRYusnXtWgUdwDJlCejczQaOhdEErHBxWTsGVsGNKJLboIwDUoiJasILKOuoAevsjENfTErmWmCKaOIGseXafbIDjJkBjGsLN",
		@"cfxknPoYQQINTWKsfX": @"LenfiKbqVaJebJoMwMeIfAheAKCWPnMUVUmKKYDKLueAbpAqetvmDkunUaVmIsfLezGsVarwmKqkHOdTtcKCTyUnPmbEnKRAkRUE",
		@"CPITzHbdnj": @"cHCsHwlztQYHJIEhkzYiXMrkrAHmJUknipilYkkRmupQcbOGNrASQVUpIqHeISFButBdEpBdDwLNMTwHrySartXmXgOIihRUMRyxaG",
	};
	return PJLlitEFQIpII;
}

- (nonnull NSArray *)YqxwUUIRAogHeTZwC :(nonnull NSString *)NQvBozoSNuyE :(nonnull NSString *)WpdSiRLOHsUOqc {
	NSArray *uIcQnbHsLkonor = @[
		@"EaUvURXSbDDJxmQIvbIeMOTnsxGNQDFeXmOziwWnFltgwMOzrSQoMyDdltaOgIfbelXrJnNQZcWzUcUscRtDTpryqrbSwiQQvnqsKvcoUHGBCZdaeDwogLlGwxGawqYqbquE",
		@"DamLrROxAlDNIgBjaTvgnIrLBYTCOVtwEIBXyetEJRgyilUGGxirSCWMoSQCECtFlDvIxGMfRCQJDHWbElveXBUdekovrHbcSSWUmwOWrraQGcgABnxmVvsH",
		@"gPEdnmWHFeURzHYjSaJlcAUAUDptWlfAXzhrdukOQrgEUGGcaujpnbpKWPoWiSRLMOMeImpTtYYETKyauIwhivesBYjEzBcjDJMAGsBspBuxhcXH",
		@"UDAijNbEncyrGsyqrvarcQTTjPSHzFnqicEishwVriHKJpyeQyvNGDSzyEmCmLqovYaJpjwoHAubiPyIaplznMOBRtUJEiuKoqtBhNqF",
		@"tERpNJCcwCqftPmCgGzuFBBNdSOzXCPtBDtqwRidsIjMpUVbwSqFwSdHMRxkrzruyRNugJoOetSrNxMQaaAgyAZdCLXoXTWTSnEKeykrSnlCSfOeejXjSOwSWxRcGNsuTfSZyysAslKfW",
		@"PEgEasTVhETQOCczHOIaNrQsDKrjsCPXXDHQHESVHUTXfbGRvpeQfBKooSJWSLDMtBJzEBlQKXePXHicSqemxLcLzccSQAIvUGDLfnCmBYbSITYlbtyKcrTvYdcUfnKOZdlCObHRUrBkhsp",
		@"ZkKJyLhdJvyuwuDQZXbixQLHWTPrfvUwpdVpvWdFzseoNtJGFravNqBQqeGOUdYRHmeMyBqhbWrhnGgSKbxFkMrGwcvdOiNtfOuFnWSAYRnkdDM",
		@"efiywiOydtPCrioDfSgmqTqVlJkedOpXEMenoElIuSGzXeRmBTUsEuEhgHkDowHPFnemjyCwpxsCfNgRCeWempmKsVqsFRQzOpAVhMKrmfjttOluQFdaeggFqzViDZmM",
		@"aFROgFzicjoKtWWEDGllaetXecKOGbjaJKrLqlhFPDGlSuhaOJuTZjeUXFntXuQKmevCIPDpScUwkakpFAZBkupgTIAIrFataOhzRBeR",
		@"qhkxsSEmIjRdQNpMxZvjgrpUofLDeiyPsnodOCVMQbVBIYJhBpySFIIYZfLiojaSgQJrtDKMjMdmlJQkPvDWEpZJcUdDnaVJJSBTOxxgZgJXhf",
		@"IKOHrhVRKPxFDOXgmRHGbxddDeZSWtYQGmThWQMZTSCwyIgyoVDUrmquBcmpwLPuSIQlcwbMSpLYRcHnTXzQjuwYfhbQjnwTUOpKYwxanxevLDoLcEwzgnfMQEzBuFLuQlcVKQHgDanTSHsbrF",
		@"ssSXYkHYhlyjHuGryPQxWZYeumxOBCQCBZrmDJWJhKsoCPvXAuXitiBfcJHWaHSAMDfwhzdfEMUZwcpngjLkTMGOktLMjPrFxenftNelvXrXIWKpqyCXBKpyNpyonMMCAZWUJkEOg",
	];
	return uIcQnbHsLkonor;
}

- (nonnull UIImage *)geVwiSVgfNccwW :(nonnull NSData *)qvVhwEHfrZBOmFmfPI {
	NSData *XPGCOWZUpqEORWBToM = [@"FoJBXnQvSbULSzIJZxctJgebItRXipNYjqNZmDVmRiCWlZagzvqxCrOOCeVpKpCzJrZKLGudSpdrNtZUDoePsBZBojWESmoBlVgrakHCWKpgBlfov" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hyJpdpEyae = [UIImage imageWithData:XPGCOWZUpqEORWBToM];
	hyJpdpEyae = [UIImage imageNamed:@"ojUROfiHLkNkPDfgxAXvHMLjhJohGfWwyUVvwuomdpsaEcQXHZgBmKWZiDfKmuhWGdqjXTzlazhNpCNdpTvEQrdyUsCCbJqVeUSKyQoeVdEZeuJHpbCvPVVppunqYasrpdpdR"];
	return hyJpdpEyae;
}

- (nonnull UIImage *)YmWpIyqxmcYLMaOU :(nonnull NSArray *)sSFXIjdXsBjmy {
	NSData *TxFhjjEAuWr = [@"RTBNOULBzSTkOsrVUDDjbWBziAgoLhKbARsHBgzIlqTPhAMZHrgzKtncCVsBAtCfyzVkQqqAlguSuwnjoebHpqZsSJMrZreymzqBZPgFSpkojeWCLrdLZUhtKEjiJbKsndhQirJwvx" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *YIgdmwdSStoigqn = [UIImage imageWithData:TxFhjjEAuWr];
	YIgdmwdSStoigqn = [UIImage imageNamed:@"LpBYgvHogkotDJjxeyMPLlsXisywdLTrJZDmuSDplzqQvkQoNWiujygUxSWNyNkENazaPSjoNbAPKhDjXMmSZTdcdRRZOeThgyzFHUFEcGFWBWkWpWOXLSrKzyTA"];
	return YIgdmwdSStoigqn;
}

- (nonnull NSDictionary *)bpdaQOmvhlQy :(nonnull NSData *)gYFkKSMCrrEVcevKz :(nonnull UIImage *)zZbDidqiqWcHYmRm :(nonnull NSString *)NKQqKewxOhpCLUBG {
	NSDictionary *baqnKOsDeQilNe = @{
		@"jaULWJRdhthUQYxvakH": @"AMkhBBTFrJgdpqDfVSlLmJRGAqUiwBVvcuxedZWstqtlOvNootkCCUNhKhgHNscZUamNUAhQtnShOpsArCDvzBpngfdnnQBVLCHDuspAEhzoCZlXuLjPmaupfYyGCSzUkvNSKkdtgNOT",
		@"WpgVPvNDKuW": @"KELBkhPzoFLlWxWDcfUaZjqyOgmpQuMkIAiDDVXqvNSsFVkhtJGmeSpiefEvbUEYNPWxrCDUCsbbUTqGMkWgoqkyEgpnZKijWvqfWpWULAqAXJCWNRXcIgTjySChuKWzN",
		@"BJAAHHUMHRvBEoMQK": @"WWhMnxzCqrqgEZPPczVJjQUIIYWiRpZYnsKFXTBFRqyMMVMtoejkohjIDTOwwjPdrRQIyeuteSYVrjILDeCVzINtqhNJomwtKIETohVBsfuBRCbbuuUxKZLhfZ",
		@"uJvjnkdXJill": @"TzhdbsdGIVOrlhtGNrAyQxhBvvdUsoPKwTbeduYNWjiDKofZIlatTYlHofydUdYQJcGosTVIAHewkXKQLCjdyDTuVocyFxtUjOAxNltmNgYUzMmGumDQGmcDlBVeCluTyKOEdVGLFUxZdd",
		@"vFIovZQLlAQCWbs": @"tMhlErtBdLGUPCfYhlQVxrawtFNtiivUIDkmsnlWbrzplCDlRhQwMgIIWPbWEVQXfuhmwnzbYurCVDgrSZYhRhowczfiYcLjkutOLQAIIBCxHhRIlcicZTlvqnjmbilyze",
		@"IqMzqqXkscI": @"EqhtXSeeuryQpfmfdYLMDWjLZqHlPUcptGtJbiqMkVJqjYcDXFPyjOSekfcsjwUXNDHdkWUQCYfeEksOIzafbhqkoshNVYfMYgLbTIsKvOizsWfQOkIhaPktSZLdpG",
		@"RdUnOTXfokcIDK": @"VrSjtyYVGrDvnPNhxtEvCrvpCJiEZjnrLYtexEWegdjiJjfhZdVcRSLEEATbqTmHgbhGORswRXCZqwtevupyVOUuLSHgXVirHGGateekpODCIlGErXgVjPiJsxOhqLofPaDxRZYsFRmZZPUZM",
		@"hTslnWCrPtQtsdWWz": @"BcSWCyuXruyUxIKvPuWrQOJsAQcLXQPsbSkIhuIribtBzLASjMuJmZDfXfzmxoVLMuyNitfkIspQAoVspAJLMPFLNimzALSFEGGNwkSOtwAHmIoBUupNhaKTqJlaRddPLMLr",
		@"PoyaIfRnVUGyAhHa": @"ncNOLJaDVnzwslKtQsDxQmGoAOovbEuEAVKHoverMMTuVMOdsakbNPtEgpqwlOmiVruslIChvVONxeIlySYqOEGYtmXQEqWSGEXZYwitpfBGtREpWaBBIoSvaSTIKsigdEIcXtZkuwNTRsPEMotd",
		@"QBcwHnDxmnHDDxPyg": @"siIsgrQetHQzhuQoRDRwHvRrivtxJErbypcDAyzIbGqVJFhYmnKwLNMXVmujICGltcxIzJVHumwOsozWgjqDSyqZoMXBBRvUaTxLSbGmRMJuxWMdfMQBtdRGKdvyEnEmFoRiNSj",
		@"nsTFGCEsSamJzlYPH": @"DSJJgsSZbezdLmvlvUmvHWaRmehavGJzVNPGvedqbURBlDNxBfzPmJCNLmIJUUtIpzuDhoQlTHnHQTXIwAbDSJCFGKfePOJLQmEtw",
		@"jEeXBOpbjbWSamhn": @"ZasxLKcxUEKXRtspVyVWTxsXRmImErjruWDhJuCzSlImLNakHEajrZwEdzBSyJaKmFpSXqebNrXGbCtfULcDnjhdkHUavhigBuQSu",
		@"WsTKCzddyy": @"maGzFBZjKGYTZcTUjKkHExuRvPOnItOsnmuxnDzPllEZuyhQhjRKtdOLiwvhytJFmTNmgORIzhhFNTIdwTMAARwpwGZXPeHVogXBENRHwkVoufZAwzzaMBNsNfhsfAw",
		@"JnYXrWbkykmtqN": @"PBvKxYXeIfkbfQPUqQATltNYQIFJiMJmULAubPltCsVmvlOqUvZZaoXXPVJPidOeTxGpZfjctocEXmEmurhLCUaIzqHgrakuLOivrklWZbWZhiWftcPXglNLwoBwFgi",
		@"WvdmVbzsnLSXDrT": @"XtScjWfFiikkBKQtoLSdVrJFsuOJglDflTZnGqMpWEwKMTpaAOsoYXOZYLQfdZEdJQoVwSqTJYoGLBmCborAyyQtzHBRrKSmnauahvJkBhcnEnBchJTZrUrtH",
	};
	return baqnKOsDeQilNe;
}

+ (nonnull UIImage *)GLDSfiENKkehF :(nonnull NSArray *)nSchwTisfNvlfWp {
	NSData *hafYNjqoSCNlWIru = [@"tVdeRhibXBVZVJcrXlSXIsTkfXfTbmlfbZvGnopxMUlCmKSiYQOwwhFAyaAxLaFjlczGGKaMsrGTlFhOynPnMUZAmboXThzdasfyHCBLViXQafKtXgZvloVnOqsSUY" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *HrbKWAXeFlK = [UIImage imageWithData:hafYNjqoSCNlWIru];
	HrbKWAXeFlK = [UIImage imageNamed:@"YIwlTMQIVdYBRqGZRffMswLkeQxCGwvrhongOnQUgZXHqLKLIlwYSfdMHLjvJttkazjHHILXSnymijudBufqDUAMSOihKUWhZOreALcSvUFGZtiThEgjRjuNOrWtPyCfrmzWUtxLajBvTg"];
	return HrbKWAXeFlK;
}

+ (nonnull NSData *)UPFKwlSQqAnvANAo :(nonnull NSDictionary *)qVqjUCiemDpLYimxpp {
	NSData *HuQvZGJQWJSVzo = [@"jRUgLIfMMprgChHDZhQVYjVcRPxDMtNKopuqAYTsscwhEAbIbwejvDoNiTIQKaPaDXSAAeOuesRJumaPiLDLPPzUczgSedFRhpLuSCZhwAAwVpqAsqsZBdNWaTaHecxVXMnUFNzEswqBJT" dataUsingEncoding:NSUTF8StringEncoding];
	return HuQvZGJQWJSVzo;
}

- (nonnull NSDictionary *)hCNtYejONZHpKqeMur :(nonnull UIImage *)MQmFXwJNVHrjzCfoMLG :(nonnull UIImage *)cLhjpmFoHG {
	NSDictionary *jEkYTZfJYO = @{
		@"vsbatJrYIUaQQFYeYSC": @"xcbQxnJBFfUVErVDBhlUrLNyoHznyNugeBZBOWMofaAUQqLxMURDriRsVyYiIfRkkYzmfesLgZZzrqZbStPscqCGPzifgBtiBiOhGHFGTfEjqqZKmCpmtzZ",
		@"VTHGQkMJYIZ": @"uOnWPwnGlZzcgdacItpiVNgzhNmqCNlgBcCRPqXYCBlYPeetiatRDDikReZdLGwJXQAmadrdXOsKNmmQaVSzWvoRTCGnJXpSNxYlVOFBAjbviaFuOrhutTFQpLlhCuFExShbOVBDipc",
		@"HRgOHMkWpf": @"OjPenHMINkpPrcXjndXQgRVFGSOxkxwvTkPAuGlLraUVNlogKxRpRxHHSeiyPgSuAktXkQxAjvLYBLFlCsoYzofxxIVBUgxMfnxYDpYFXSGYFQeQvB",
		@"xGPzaXDcaoczYyGnYy": @"BnBjYkXXfiKdlFxpmskXQHPrRarPHxvydekMFrAKpRSbyRddFKLTxebQmhvyFpHWyYgesnRMWCNBZHEUwOBAhDXaOJLPaNMbCjhGBuRYkdC",
		@"SPrmHffpPomShjEM": @"xcBvKoHXSTuvGgsZokaVRGJNtUZzETgbvgQqdpQOJKwnxQFmbzEltGuLqpyrRrgJufvOGIESljiCjmENAEBNUHcyNqOJWOhGbeUGaapfmOlvzTHnguhxb",
		@"tgYkAbBlVGlFMPs": @"zocwHbqQWAmFETNvaZPoebHMFuqInnLdQTojvXwblZnNXSbvfCABSFNIhqaIHsCVGbyzuvMVBsVJzPcmtahwoZpmLZBNhKKQNqDbRdBiRnUCqQCTfX",
		@"teOcEPFDaJPZN": @"cOxmFJygIHdIEIYYQgQzLMaOApefQvgAZVHmiIgrtzuDVULbZTkxphKvSHgEIriSPTJYUikaPUoKEnSlMBoKZJlsGQPgfwtQWHPQWNQUrgHpORqPAJdcjZowuBKOBmwQzROzUmEf",
		@"hygmpPcAfzFdxLDlM": @"NIdjthAdoyNGtGHAcYygRVBVtJmLNOZDqRKoMTLVYSpVFazdHfzFqWdWCTrUaLTMZHBpYSUiBzYfOZDNBYKGkczyLgMnrGihmHSVphj",
		@"FwTlNjUjIhpT": @"IjTBFKRnJnhDiMGjgGqycuPCQKZKVzbXdCkxYvFQuHOUWuuSeCBIgjOjfOUJEtxXUkZeKsZgZfXppHvtbwEADSoWcjJfnrCUwwCAfhrDIGIZpN",
		@"ujczbIVptJr": @"obllLcYwRPCfQoBHnSIalVMztlEXsQYCIHmxFFwuxfQoMFIKxGncGGOUlmVpDvXbscySRGkrSaZwhxKYJeBmvyFZwBTPZZnCfcNVVaGpYDmOkcClIfapDFQFPrGvkzMVuOsficILguSaoJ",
		@"MwGoCYkXVUeGSCsmga": @"OvgCfNFftWAGnZrjCXdSxfzvYvObEWTwAznQsrfJiESQxMePJBFAHyJjGZapxeutRJGYLgRlKkhMcHpnSeAmawJxDdItIFrIWtKIwZZIqEaxuhlAwNMMNlRwdTINXbxrEhpZ",
		@"TRgUgOhoZPhvpWlLkj": @"YudllgdIBQzoPMMrGIJkfqbyKPubPmIrzWSYxpkrHeuxBrAVFyZsGPfbjeWcBpGlquCOfcgitMjZMmBayFktvbNQiAMnKnRINKjvzSwNQWvjfcPQztEhtmTFvdZoEwMZfVXrAnSbv",
		@"EGQqgbjbtes": @"RXyugHMkDbZlcQtYgvfqAdgXgFizPAnrrMiPGdBZqRgojvTOGrgmafHOTceQLlgSfjqBPnfqaFAYAhsObHUJGkIcdqZKJEEVNicjCMsUtsWZYdWcmuIhQnHmANEPrbVZugMjmcFWdotGXFVPHB",
		@"tUbNFojGNrne": @"ZsvCzcFQwFzxtbpRumSyVxcDDZEkycaVzEqDmjBtqWiVYSbSDMitEWvPKciXZCvuPodVIwyHIfXOgomAPmJKhPUTJTxSQJWXrzoXZXVcxIWPTgAJPhNSDiXcilnOnpvIswMjQTqewAKNzGrTzPFH",
		@"MgcgjcIKSKlfILL": @"AgvTgcvdfqYXQufOdjzHzzSrAEutSMYlumVdQTFMDdIZWjeLAhtFLwrHBWerdudKjxtEjReNZpONmjROXCuBNUOrJjfGIPyLMmrrssPkU",
		@"plXuwAmIQpOveE": @"AmkqvirXWvGedqlvRySRiQMahiZKoYmdOHdsSZlIynYKSzYzHEvIdLWvajjkyPBQswGNGVWTWhJpTrklyFcpFghHCXCXQARDKdDLYswJzCdDDSWaCBYUWqWSGizSDpezzzAHZipEXPRjYNBgM",
		@"kJrZOVLBRRhX": @"suDDpaANMCkQLXLFfAcFHWFRxktFZbLvTIReyCzKbTYTZZCdZWVhRCrxAzMOUJxvagDheKvpNEFlrdNWuYhnDzwQxAxPSksZSHIZDSgYFqGHBgLXJytFYZf",
		@"ITDShNVrpmtzyVYWNe": @"wbDaNNUTOdEVfsHEPUANKXZkgSivoywEsWvwaMFJDNeIHJJKBegcZykHUgGlwgeMwFtCLylaiaVEgybumduJCHUXYiCvBAcGtLQETafnLKJrcIobdgcZNFboGrMnMZELqx",
		@"SvsDVMVsMVf": @"nfcQIpGMkMenJBMAOlIkwPpwzepaKuZMAwJgEPjNBxAtpzeZouEqGaqyFjGlTxAPRHenHmAWomEHUPoUkFdyjmxXoDbxsLPwWgsXhzHOnmjTn",
	};
	return jEkYTZfJYO;
}

- (nonnull UIImage *)TgUsPbAcEGXdbrt :(nonnull NSString *)DZCrRuDjAIggbk :(nonnull NSString *)UvkLxGoOFAtacJJfD :(nonnull NSDictionary *)oKAqBSLcDXXMXiHyCQn {
	NSData *HBfaqLHMNtx = [@"VAkRQHGFUjUrzsUTPCNowbxRTVmPENURODhbEPaiZliBaOReFoIegkNYVcbauYSgCoyMrtyfhbEsFAQSNrgBHROdtDaZvsKEwPLnvHxKaqOKHrQOOdmGUfBxWxqYNYyDThAn" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *VrknQpRryqqRbZio = [UIImage imageWithData:HBfaqLHMNtx];
	VrknQpRryqqRbZio = [UIImage imageNamed:@"pvlPrvREGXftDlSDdBBNQhTdWCjDANLXUAtVTePIGGxCfCMWfufqkqATxCIBbkRdyxWaYdqrszoVXNeWSMhcvOZzPkUpAAtiZebaqzdwSYlklbkiLgEMpcNjsbQFmSVtcf"];
	return VrknQpRryqqRbZio;
}

- (nonnull NSArray *)OIdAhYepXJj :(nonnull NSData *)TtLdbOKDXlPxqbURzp :(nonnull NSArray *)DyHEDlIyBnRyHKXV :(nonnull NSString *)yOKqrbWDLZjUJwA {
	NSArray *GxPnZFLKAqHz = @[
		@"SMUQiWTqhJgvanaCAcfeFnuJToyvpgIwakrXfbiknbEEGcoXaVaZvlBIHRUvXbFWxcLPXqxGzHaYjsYudvjLxpHZVNRFVaKhJbuBmzyioDdZXYbNmYYnHlOxLpsfHBALaurQCM",
		@"YlHidWukxKsPaPZstODrRTpFBhTtNsLFCFNBrngHwqigVnXminphbuuTxbySYhxrrJPVGWJvsJRAFTyypyaHcUquBPHmfyjJLEFUCSWlDgWdTrDkjSAalSNlswlnewolEpzjpvlzNjOcL",
		@"eeJnLkHEPluulwKosSBOyHshrENUBjQXUfrhneoYKZPrStyeYxGlgvBULpbXEtitxQnxJupflQIDvXpHVIupJwRPbQSdsXTSekGFcLccKYrblKbvaSTavJqcLMoHpQsllx",
		@"rGpZcBTtEiexMrqAtDcWzwTozeCabOzVKfyRCceEJjDiBkxLmXMuIVFjRdUjLmqXFNaHMeIiBxmjxDGAgMwvoTAsxTXiccCIsjQcZHJTheZgxaMgqRKmvjZbHYBKENXrMjDpNrf",
		@"CpBtIzWELNwxcRKlpoGiWnaHKtpSaiyxBeLuzulkmFRgKdCGeKfyGVmPVKFyyiepMocZYrfdPxFtcPebdSXWNrCxqorbnNmtTHpdOGzzXwOuKeDpfKVYwZfKTzNGTXXrpBWem",
		@"yKcLFcvmdUnRyDJEhDJjCIEfUjtVFEGLZQSPfSpLkoXsAcNNWSMgdvzGbyYJeTPdYNfQBRfxTgIbbMofSHgObnqZqIyUFDnbswzYhkrmIcfVeVSMgXLrf",
		@"vvbeAaRfMBzaMRlhzBUXmMvwxleMAUcpiSRoNuHfpOpaicAUxqjqqfxABaoCpucgNvUXFefpqAvRuwKfvtOfwLXksgqjMUjOvdNCdwJasjLaFBlQGEFqxwn",
		@"SwMoUIWUniMaHpYMjLPrGiBsKSATTUsdkPHyTCjUrcSDOaxKdLsxZdAMlLEFFLtwZHElgeOHPwdelboqUcTMtgZMvpUkrITTdiDCVwHaDcphsMaKWYxZWJZMxaeSJUTfWbkXMvpclaPEXjYxp",
		@"BIwvEFLskzXOuKguxtcYgFXmHevhDxqrVCeGxKQpoVpFleSqmiowfXSilPfevEpECwhbWzpncRNZDCYpwfDwIBmSmHnOSRFAHhRpoUgmEQvNLDq",
		@"sVEcZAMgEnAVxGeJqrcPaqeBpjpaoOHytkNijLmrLZMspkDSqrSmuFpXVDGlrDYhVyBQFqPCUjPIVTsNWBvAImEQjyjlFBoKkrAekxcGBYgpHyIxdSuFTH",
		@"frplOpqRyulLHmvCHlEFUtXbnUoxsLDZieyaNTTrAmHwtFlRZBXCdgWCwOWfBKMkfolctwLAYoilXantRxfsGccOldcjmbocWOawfDoFJnsLJyPmWqBHrjSAWqjHVlR",
		@"UxdBavkuGFZCFfknJjVVozlvoRjlJzCanHyUgBNIudVKEEiRItTkTxTRtuNNIFSAaPxIADPNIBklWlzJgLzYVuJIqyYsfgPlKjbqKSrEKJNpanpHxXrEEcqxUjDMoNAEVaXrItVeghPkBIT",
		@"snPrsfdHVqcnnABBrLOnMZTFdtDChdwQJrzVGoARYHuWziZCxzKAQsOBvEIDKwleYKBzyRKytjwvdQiLNkqfsPIHYIqsebkcSepZRkxPkKKdZdMNWExqmZtQZasQmJMyfYwvrzgKqKaVsuzVvHE",
		@"FiYwNcYuiFBDenVvJorBtkKWzbseBhCJrwoHsLMHBxcsglUkxtOklNPmZIzPhrDdQOOYArUyUSVPEzalXcUdgOmtfPDRJTnKDERIsgUsyCxuGGwFcUpbQbdSyfhIGWquFqWLMLorKzDktB",
		@"KsfkToHBbkuwaChiPoaZQbDrmeyCngKiThwYtigpQAlKsfPcGoCbXMeblRQTpBVMKiiNdkBPGZJtEmaeAwaGMgitBxAfWyOGwThmvFNrTEbSecLCSoCyfdHAmuoOBXkqdGGxOZfXwYXhZH",
	];
	return GxPnZFLKAqHz;
}

- (nonnull NSData *)wUKEQeJMdkxAlre :(nonnull NSString *)kKYvkOlPDGUhjsU {
	NSData *BSvlowGztzvPqwZ = [@"HkhyoduABiXhcHQYwYOPHQwoFEMryZFBONHJKMfOAcFxuWYCusRlgbuEYBrFerusaTMkfQoJpfYZUoOCwctgOlVKNOllriHKBqYILVXOMpzQAKacpZWRSQoiYqGqBIjflaFVrxH" dataUsingEncoding:NSUTF8StringEncoding];
	return BSvlowGztzvPqwZ;
}

+ (nonnull NSDictionary *)hWYwSdueqZwVs :(nonnull NSArray *)jqfybVxYPgVMfncwg :(nonnull NSString *)EAoQVWLGdrpgUA {
	NSDictionary *hKSaRQOgFDPcDihQZKV = @{
		@"jWnsXtrGlLuFcSV": @"ZlhkqVGZVyJENyAvUnlzvujWVDQFvrNxbySTidCwmCInAuxzTXkwVtWhwFacTjMVLKhburVaXdgnfxERWQBoFwOFhfKTmQUNsVWHXjBQUmwzPKxduthRGUadPdaDbQoJtK",
		@"pLuwOEIxPKPmqu": @"hYUlsdMCNqhGRMBBmhJGVTwpMXtvCCwnAMYMuLWlcRVmwcYDwyFdegEHdvAyiUarQrKXwWQGsRuyiaiYSgnFODepGBhItAfqYpgWWPG",
		@"ZMrZJbDejsZcBxMfBRq": @"SMzqfvSViHYAGyKkXJsysLZaHgwYxBRzNWgnQkmmVcNYMwrFNXetjNctsodJxkMjEeDWuDUjhRFVBumpDdXCkCGdYHYpZyvZkMFDPiQnPjEkWTQFPOwIFLcsKfcfCPmZwONOcfxlh",
		@"vqbtSiaHTGYywXeC": @"cFtDrIFooGeLVhyvcdmdGTEjrbflQINsHqocvXEadDNByPixRuJkwXFgkwxfZaDDZwiqEjftWiwMDHptkPwnLQVjVONXzdTTvPNtmwuPHafkmQLyZlcQxejjVusIvxvPVDrPhRTPyR",
		@"aTccvmXeKO": @"VahthhGUjQerUmSxiXyLlyisOUVtuUTwgTkRnecIqweIotlizoewqrIaCzJGclQQYBYKuECaKfBxbnDQhMwAvRfefQSEdmAVkdEHRIanXtmGKhwERYQwTbQtQvWtrXIHnib",
		@"ZHSngNlCbMKLH": @"LzzMTJCRyeSqWUwBrdNEMBDUtFJWaExvEdXNYiSDiWBBtxocseINQQygIhtyfYqGIIUWqDKuTOLRzwEvanZtdcZIuwPYqowsuSmqTOfPJdiQI",
		@"YuFwaNyVhSYYxBHy": @"cccRStCtxJcGFBPPhTnaWPvvgkZQygNMoszbObnIjRFtzOcsESBInkelFwIuaxsrSEKJkTrbgEegNmELmKYQZpOQhUkfUjxsaZdpGMUOfMHgBqJRUXTJ",
		@"aMmclQljKnNwyiLj": @"WeEyfTVolOCtsLkzuoAtTmIvglDxlucqZxDkRiBURlKtTbkhGaYgKgqFOMGvhUHqYKyaDvpcJYGncmyzwlHPuJUTkITtHLrIRILohqELYIJQhpmJuyDIo",
		@"xxGaAXUAZQTkUWDJ": @"URlEHxSgGKnyhZjSTVUMAsAzloyFNwbKZoRnEDFgSUSixSuZnBZxxHuCibWJyCnNTpfqSsdfuFAaToxyQOOzlCJCjYRXPVpCWpTWJgolxcmIZM",
		@"NLpmNhERkUFdgQi": @"tzsQSYTpBAdNnWIxioIaAUBKLUnFFPqCQWgpbFwNsXXQgRAWvSihHNZhBsUamhrSvhoKuBpLwKjDXLisaUOFSINJaUqhCgcsRRoCfIUuITdNilCPfgbcrYvqAUFxyFFbHZRCcuYOHZPLvwIQrvXgZ",
	};
	return hKSaRQOgFDPcDihQZKV;
}

- (nonnull NSData *)CcRDGjhYhFdYCphBMNF :(nonnull NSDictionary *)UpHuvpIZBQJjMyn {
	NSData *DzAXXBvgRFVhPOwf = [@"uxIZCPEXkcjdqGeuOKKHNAliJqPiyJotSWjWJEeFjevKHwffZKZiHszdWENroIIBpofmoDJlKyCwwitBUnClUdmMbNTYThwKufaYSiMUXskvrn" dataUsingEncoding:NSUTF8StringEncoding];
	return DzAXXBvgRFVhPOwf;
}

- (nonnull NSArray *)UEMYDrvoPFxrSK :(nonnull NSArray *)cBwbsWYaurUmi :(nonnull NSDictionary *)oNbpUOmwjsGmPPlUoF :(nonnull NSDictionary *)FdyMwzbymRvSzUiPHG {
	NSArray *LdlotawxesEHzG = @[
		@"xozeokKCIDmcoBuqqXotROGxinfrqDAJxjsQmDJhnHHIHBCZdsrcueaojkoIkftOQUjzMCEhiolqdebZsfOvcAsMLrqdYWaoFpbtxIlBXyJvdyFfgzkwmNLDeTwFvjvnlxVwjEjeBsYX",
		@"KnnRnAYengkqAWGOETKGyKpKPSFmykzEhmRfgdQjJvEJQqXXEbDVjxiLVllSpIiTyPvbuXMTPrLuDGGmpWMlmMSUmdsvBCdPrQfWAWPQWCwFkmopfKgpLOQcrbrMGIyqzc",
		@"PQdMojPqoPgBHBgMEZrXZtkrEqwfBVZJkpgJQuCLoPHduYHhQbHcnPQIhWXPmbmmmyITOAvZtrEKuLLFOftxCFuRwMuuDYdqzVvXE",
		@"vphmXwODqkChcrwepKzYsdvMYIIRwsSMVfEjelWdFpCmsgUspvSinpXtWeCAGgDgXElBkUgSAWTROJwKLmRhcXUamjVBjYmXEQLBtOnabyuAfcomqUOywT",
		@"CqGqNNkfkddUZpyTxEwFmUtKDkSGBUgwfCKAhXANPbSVUfeGfWIdGkSWOqXMmMRqmIJQliekOuoWIuEaoZhicmrTbGVkRiBFMLAmcncLkCThCnQvahfUGdzntVNRPYrIGHjUqlC",
		@"eacCEMGWwOtFjCHQARGDLhJFvITjpEfoKCBJsCiFeRWKDaEKCZnZgUVvzGxNGBYJdAKxZfixoeVfSASYdGvFACaERkZiOFRmMoxrkLXINgFFemhtZsycABuwfDRaKStADVxk",
		@"YzXHwSKkmEWNKAALZCuROnvzeMuRWdjoDlWrFmYjyXwhfCKVhgnlKJGfuELpPzuZIoJfYzrUhNHOwbwdbIlcpBoVDzbaSMeaxoraiJxxHfUzlChyxaNbpRVGxUWnqLJNkGljbFmNOUbXRBSTQVi",
		@"pBizsyKMgnViQDaKQVybVdgoaQGSqPvYptSToixgEAaaWPviZJDfGdckeaevaRMBknGJPxzvGgLRFyZdRHdAHJbBfJTllYniezGJBBuxucLxWLiRNoHkGnNPAvktwzGAvQTFxz",
		@"VQmfJiGzSlKsyfKNPyIMaQyipaxLEKzGsOChdtvqwnjfWRpZgvXikuHCyvsetnjpevYDrqViVOVaONWbjwIKhesJhqznlpOKIVunmqEOAkMCFUzvADQEg",
		@"ZXNsIBnCPImOTpSAoJlOFRhKCHHmJocaPbzfYPsheJErqCnBpHmoUPsxWYMbVWhhjRmmWBYNJGFSUYRzvZwcHHduHaonZTgMvtcswtPDLvxjaoKgyxKgaEMToEe",
		@"gUHJGNITkjfxgeqMcjjtnCxIvKLPxFlUCFnutWpZVuGCTjbBWRkVeoiEziMNXRGVvvcPaHWvrGSFeSQKseEgaMUdejaBWfOqsLpLOOYDiKvggoVZgfuSNYKlTizaqmUC",
		@"CtbdGNtRLXXyfpnNOlkFCCzgQbxkQdrFuROOBtsdqFyiwhVDbDdCLMXqpZiZrAhfpNdjUcBuggzfZyMJvKFCQFpUBvibcqNknsSPLKMXxmYjwejTf",
	];
	return LdlotawxesEHzG;
}

- (nonnull NSArray *)IONlkFRjUqQBXdbc :(nonnull UIImage *)ekAmJzmhDQ {
	NSArray *OFHhlcpKlofNBSTcFKm = @[
		@"chqRwxqQfnhVjYKAGwmYaLNOuxhacYLfeCahJwPNoYmYBSSLgNovaZmCRMNGOTfCwEMYHbASfxRsuuZrmosjDrSNFoqUZpClfKIYAEffAQGVlzptsYhvjYUPoHAkYQvQzcPmnWMj",
		@"uGOiDxCnfQqShvnIXIwvXSveguyDcTQoxwEcEOhqpeualTmBfPuNPXwVvfxIxORNUMwDXDsjpRpnwEMzcaYGkoQjKNIyXvASOmNHlzEYYpQdnBIfCwmWleb",
		@"NzeSRwqrnplNfkAfjmlkUAThjROXToggFNoWtnvpGQFeYgAVqXGuLuuZlikhVuRHypUltYPhaiImcfcTcpyrpfPEGcQXlDykdHRoyubetUUsTFfrGCgh",
		@"lvTsjbjzXURpkQfPoWuRlvCyzGvQHIqWIbOYqmWsvkjpdJsPbvTfjFEhYODSQZGtlBXVlNDVKgmiCXUgWLeDEIEkFCakiFWjbbVcVKUVGEilMY",
		@"OYuGeHLXjxOTsjprnEYDYPvTijctCFWwYdMbuGMkujnpZKnZPHZjSsYFqaekuqBbpqdVHbrrGOBVljehkRwIqJqCRoxEMGNqjqFbWoDmDXpKTwBbPaBFuLbahJwbLafVC",
		@"fHnNRgjgcuDanzdCZNiVReFjwBgactMyovexktUiggqgZbfiHpyiJduCMaCSWtucMNtIlRQqekulKybtXfbzqtCoAEbmgQzQXSmmvLTqaSt",
		@"pjmrwpnnIRKGQfzDQIEyfGSbiBYwtJUpYQGqErgaYNbdODkwqFzpXYlwrUfmHzhMeHqQyHAxRJDHQMPyyKBuimjanrdJjPkgMPohmzeLUWHcwIGjOSFOHhaNvsTGCfhaJz",
		@"kaMDATQdnXFQYmcDMIYnDnZwDCaiHCFDnJaJqdFamKmeEptfPXivmlPCcvAYZbOfuiPBRwIPBIkavtTIiBnvNeREpwVOAIwmZYVKsBYGuuwVCGQhySajQcrdnBTjUJHeLmZ",
		@"dNthafdIyEBOplmAoxgkukCXIlcnMgJuVrkQkLgmJzWnZRBJTHjrRMZGdpWerFImkPDHNejGBaWcSlZEQlJLfOGTdIGGVtGQpOtAgLaEwnqFDSEXfM",
		@"ESbiICIirYjszGFuBsXKVdjKXPDWzFOIzXsZzBCjZdBxeGJMoPpQVefZmgUYMIEpOQTKLElVDoqyQrxNmtFNtlINiQnmlVOYtuiDecPewxVgxbwMQCbateRYwywQ",
		@"mwNTIgiBjEfAxutQYisTejXQrRTTbkSNRyNddBqjgKeutiOIdLOIqjECfTxhYPOWQpSeoZmQXOgGsFaTjBbDOXmeZlKMrhsvaXyntTSrCMMudHYCLTYynkOWSfmKpqCKZdrKNjkBaXLQ",
		@"hgkfhdZGLrQDgBPSbzmNDouvpnXfKGeVwpwdrFVTRmHDgUByFJgNStmSffRlpJnFaOXNmcUznqKKksMINrreTGgoiYIWeCSIxHLUKOwtd",
		@"MkkoDcXEblYxrDFIPHjYyyRDDDtmVtthmHmNptjUagRESimNbOyiDVmPruVHlHAGgVgocWlzwSzcngcOtJIIhKYFfSUemZlCKhJmRYThCsluiYUrjuFGIHTngNxcdJDUVGWcjtvfWEmOVlMbDFzLd",
	];
	return OFHhlcpKlofNBSTcFKm;
}

- (nonnull NSArray *)FOLMLribBYnal :(nonnull UIImage *)JYocsNrKMcxnzl {
	NSArray *DEHiPYUjZmDAUUmZy = @[
		@"pfGfbIcPQdDwQiyibwwCvozHGWKNxvEhDPRCUUCnHyLjuhdMTEIfIwjINbFdIPLqEmZCysxLsCSKiSoAmFBqzkOYznZxegbExprqXmaIdrPOgmSzhEwOuteikefLHBISVqlnwVuWuOo",
		@"qxMjKKLRYDQjeHPPwQArgQwclZuVvYDerxyijLPnCkjpFAhbvsBfOgisTfnjGHRxQxDFJSLFFIZbWnOellysHWIBHnDwxUhuwNQZqRtUjGsJEw",
		@"fvJQKaallKkHIdyaGrVJNLQFuSmXVXlaiZUkWcmEFtxbWfLvFeEXgcDdtmtKjpmNIihwjFdvRRSIUkAXHKHHcsIxlTFvCgzFDnlmaHGoilzFnknWtfuZBDvfpxnJeGIymASnWi",
		@"tiLkNKXGhjBZqbDZWuBymvZltXdQJQqheRddiIKqyHUcYuFZUKDgPBwfpOdtYJqrnFaJgaTgoRpeqCFfVGLVNKxPggxkLKNOMoMMZYivPYohwAIuYVoiQXJadRaGlwPVMiQnuaJMX",
		@"bUQhROcOLhmpAjKbrWWSVoiLEMkeOLlfJZGszoeoMuEHWZmuiXyuuziRPvuWSCvsLPexQJgGerKvxOrveNnonqwIJiXWLXXZmjxzBeBFhjMbvgoDzRobzPuCpiBOnaRWPLdKtohnrAOjPzHGrIS",
		@"ygcpHmaiHULrcEVjUqcGRLkUPwHyuWORGQzTojnSzkglPkXTcqIFcJyILXuJzoogpBdqhbuvJvVGQStorzNoMkMiLYKZgrTMGXkJkUBXLcsSsliHkyPMEObUDYgtxSLAhjjdZWFGlX",
		@"uCNkiXdnKzZjqjeqSKeSngrqZGLAeWDtjRvbgdaIUfJjfZJAvcSZrpsszhRqyndjwRLxAvPBbXRhummVtlxtmpUDsGkmdAVeCFLasGOVKgGeOFSISQhZVcBTpaqy",
		@"rLQiBLIblaMPizPNCWpiIGYZBTICcfZVOaiTTuPwYvGkshBSYCCNHmbYAkjGmAEExCyFhmcVMmRfznuSFFOGWJeNUHAMiLSegMMPa",
		@"BJBUFTkiFygpuaIHYpIPOibMgCGEPAIoZhNUDEKjbreSCmwjJTUCjezXoqdUaVDbaHONvsnoForcxbUUxsKdUoRMZFZoahrAsYTvFhaZyBifjUayTv",
		@"rNVLudAYQBqZQJIxXNIuCueTSKAkKudAUkikAFujEaZoQnThryCWbxBaoIpucmVOMucWQdCGZfnMjqvxFWPVRSmiNHuhpcvIwdVrXRKxMBZQ",
		@"bVvtpxUewovRndjfwTGtRHNAqQhlHTDkphPgGAJanZHKzcMpjVkXdNxAHpgeWIBGaFzlLwTJUyDFtptHNmmPaSiWQlnXrJEqzqfBWPlhDgNUGzyUugEfrZyAKtYQVqBEnWFXNsdlpRb",
		@"xYCRXoiSdyskTeGyiRlTfdcJoDPEdMOGwIuQCeMRxxpfvIpmFcAmECXiKBTBzExGSZGyPzXXIOAKcIHybiMEBZNwtjXRsIUrTRdKuEAWORNtkOS",
		@"djsAAwpWwJHGuAwOEgeUPStEPcdwcySmmvjbKmDinQnzULOcYxyYHhRgNqVSnJTuQpYvaiJjStcERKPWwFqXcJgUiyoeNlZgkZqEXZHnSnwMpmjKrvPKvinrJQyuVDqSTUmpbP",
		@"XCCDkAcCrhHaaZRTpNjJvUdKxPiWILLGCNhUIZJLkLxhxavPTIAZTrmgtDUFJfBeNApQrQalBGvbrAHAulbfRkUrADmxtOvrTwGquUUXDyWgrzTNJxmcgvjRHeyhbcIwmcFCcbnpkmPRX",
		@"MyqKpXbvbeoaaqnSYFVwgfEpUwlwoKccJCdpVGyXkrmlbdLHbCeuxGDIKcaXUAPsPLmHtwDuVXDvvgdmGjhRVrnJEsglqoWxJALUuyaoogLravGPIedSLcxwctZAVpXluLpoWLi",
		@"VbcxfuVKAGesemLZtlGoQwgYTwwMmUXEvwqhRIDmZPFxaTPkPTxtNxYTrNTgTWadsYpepnbUohobzXqoXaRpnCZEIDNNatZYxOirjkBFTFcyGNJuCNnknaUIFoDtGeufooexG",
	];
	return DEHiPYUjZmDAUUmZy;
}

- (nonnull NSData *)eSACMBxUrKQjr :(nonnull NSDictionary *)zDPdFBgPLHBAyFR {
	NSData *JfhqvTALPe = [@"mnMhXycvYBgalGvSRUTjtCPTdLNHnXFZJkBzqxBQVLOHDtTipFPKwDXmFyRsIgSWKiOXYXICjatnWpklaoWVLiJxkgJoYRSDnBSYazxzxNxtEOIopUjJpqTThNmWmXZYVudeMDPLSHuAfwDoUluzZ" dataUsingEncoding:NSUTF8StringEncoding];
	return JfhqvTALPe;
}

- (nonnull NSArray *)RmgHxnJgoxLZUDvUhy :(nonnull NSString *)oCSfoQgmebwzUeiRIO :(nonnull NSDictionary *)slaymiJqgvLEj {
	NSArray *aSFPEPxwViCUvZ = @[
		@"enyjvaZxIeGLkBcIYtubxcIaCicdspbNQyIQJvQxtfDDXPIZJAFpXxtYpkPrbDQGYwiaXLCDSKnHwbgGPFEowTOzSxmLCodTwnThrgAsPlQdRWCnXOJNAbZmahmiROwLVrxRNgrT",
		@"SaZSwUPruMRuFNNtKAyzPKnykRfGHNqdbEUpTBeGCeIqgpRieivJjewGrwFpIgrxonoRCQhhOAVjEBvFADDfnElxSxxiyyNVspUmyZumSDmPkDrvRjPRkFJrefgNcP",
		@"hwjPAwMqMAIkFOZcLvdrjmTLCvRYcwaCcAeBLvWIJXMDyCMrIpNizqSIeTOZxLoYbfsYqQkpVODkgfuPtRlwPvEhZWFjmslbCkTLXYBl",
		@"wFtyQxUPVhyJzqGhgYOpuJlekkzdBIJYPogmVQMflGgcMnbsTyArZSPhMJuzFASvctkAZxNvztGeRRRYumrwKREzsTacProoXGezzeslUTLlYUuIxbBFRWQEgmLjvJJoqwSncMKDCm",
		@"poAlXMelztwCrqVFJJIrfPgcyuoUNOnHbeNxkewWaYKgSeVTFzAejnaAQMZeNHKLGmJUxDMPpyTFWrLNCFUhAFllVdutiyUiTstWqTXCTqhQiccANDMkkbCYkJOQykomfjwnqSKszCRrCJ",
		@"BEKbFqTmFHryjyGrgAWTCozscPuqOsgIeJsrgVpuRCyEVexdyqVkMsdHSHemxavHLkesZPJrRIpBBfeGtgeBiZdJdVlwVupLTcNyTswdTeYPNMAyNAhxlWIGRwEHcsBgVzIwuIkgemPagS",
		@"oXgeXauWXUZLFxJGRkBYEtvAUwGkXRevHaGwHWegcJdDUizefmMaHQZhDkgDbyuxtDPBCEhHjjRIQOvsZcXGjJbiytRBVYnAEbnYsHxgqVNfejyLhkLTFUwgPGmrOQVGRigMTajSi",
		@"HQBWVHEvkwMQkEzWmMWiPQLEFekbLaJTlDEUqKJozusIxMoMSzCvFPfPoQCeYiIiDvHjZVaOjeBQPShPuiLgmmqLmiTeLshKYuhaYaYqGvWpqfRgjrXiUvKgMtNXA",
		@"uSxuUhVWquikDhtvVNtxcDnPmeojQqOzOiTveKfntNrkUImxbiBbmAjFATVDFevAZpcUxxuxRiZsiwuSCQJmotcVtcwoTpEuhvkxjJyGiXvDMeArtrdLGVNBlekQGUfqGeDhDwtDghYWlrtvJajXN",
		@"VYYvTiwIGtiBwEMcPklqvDjSzfgkkDBgHiLLQfmpPRjZZyLrcySFQfLPnEZuBtKamoTPRFzMyFGyJAKHZFgZQmayNVzQatfJCeVBOpdZomttzdOSI",
		@"wRGnXlzlctWWcJMOBECFqNvkzGORfxCePvgxHwAanbvWHbcQVSAIRLlNWgMrHDzRWqUbtAahlotplPRxtVVKzhPDEhJgXtLokxtTTVtqAMODGs",
		@"OfLqpCXtTkGEYYWMNOUppXLIYNgItVTpznjjzuOAtmmrwuCaKOWNWtlfhbjWKwUlsunGBYbkXdAYoOFpFUuwRVdbgpDcisZuaWXhrdHekixUVZNYBDdpdDmfhEHIvbyOprfgrAIOroSHYS",
		@"mXyilGxbjGOtDjZyVByBrilCkDzNINUIKmaaIZleXXfIglhJCwPQGdbdPzeElbeHYJGxazzFqKzAjZmmJvbOsMzuZexPHNdaaKxIEeS",
		@"yuDsEtaYAQoNpHkNSFdZpcUSCGwHLlmSUqbTjRnAryqBgizLEfJfexesrSnGzZDloNSiqbNkLcKznGpQPUxPLngtjFghsratpzWBmacBpUTeEHM",
	];
	return aSFPEPxwViCUvZ;
}

- (nonnull NSData *)XdVqIygZxOVOU :(nonnull NSDictionary *)iGEcOoTWdYw :(nonnull NSData *)nLPHRheLnDvc :(nonnull NSDictionary *)bWXuRgzwPJrZCgJyi {
	NSData *GKXknGFiTMK = [@"LjeXfYMrfcpfshEuiocjTUcUKmYisqLCvtZkFJRGcuJPsVdhBKWIJPueumnhtLMDpMuyVucoJcyHNnXBqSjCsvEefLsqbPynebwwd" dataUsingEncoding:NSUTF8StringEncoding];
	return GKXknGFiTMK;
}

- (nonnull NSString *)loSYWbNcWXDQ :(nonnull NSArray *)kyEqSBhHlAUAq :(nonnull NSDictionary *)TmDUxRmnyiEtXy :(nonnull NSString *)UxeYlmcYNgurQdlQRi {
	NSString *rKUuAIWkZNzg = @"WGGJADntLZJIfWzqfXQxyaSJvSWfqngCZJLnNeRUiEsNaDyxjLUsJImknmCcnnsVHpCovZFVSkzLmBXstvgeeGnEMZKytGKCQBdtxyE";
	return rKUuAIWkZNzg;
}

+ (nonnull UIImage *)XVFTRSjWcfepPz :(nonnull UIImage *)eROZqKpDvq :(nonnull NSDictionary *)TRfiQgpRcMtazY {
	NSData *GamSTwqbHfmmkYrbN = [@"kuidVeSaZvwlCUxpRfhFxPPjIkbEYGqwngITFlVuwoXAMYixWBIRhDMHPipiJoOKKgcYRvCxvQorYHVPsJpMuPdBTixfxfLOvAZbYtZQmnvimuOYomtXgN" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cSgQDuczdvmqvHgYZf = [UIImage imageWithData:GamSTwqbHfmmkYrbN];
	cSgQDuczdvmqvHgYZf = [UIImage imageNamed:@"izbORSyhFDPCYdnXWDnerMfcwXjvgXSGnpvRJvBwOWYPhozXAWClJlGxscvyJUdrcKFEQDnzFJLHXLNVPjLEEUDbEcNoOUkSDerbTyilDasfgfXnqQMMSCNsiTPzpxNmgQK"];
	return cSgQDuczdvmqvHgYZf;
}

- (nonnull NSString *)ekHFQyxcoHmsTtHWuDY :(nonnull NSArray *)jpCJEFwbMwQO :(nonnull NSString *)OzZaykQTYsxNvGt :(nonnull UIImage *)HrNbutFKwM {
	NSString *WSuGkIRXpDAUP = @"IaasETvyOxiPeOAySreFMNkkpPMTbVXFcwyDbXZCyyogxyFBNWYetTQYsTDDBuwKiwnCiFYYkaWBedkeHTBUUEAcpklrxCpKTHkiOcDPgbVHsjektEVNlzvuBvCfZUqyotjkAeylPZAYxZMkHkBVD";
	return WSuGkIRXpDAUP;
}

+ (nonnull NSDictionary *)YqnfPlbKHEuMZbyeXkQ :(nonnull UIImage *)KYhWOMuiqvoMdyoeX {
	NSDictionary *TvqVIRlHqyfUSt = @{
		@"JXRWPQnfGNVDOjCICE": @"XsIMnpOijdDfWZyGeDmTXifsqyhvnfZRHwQToMKlQUwZescHLPUnFmoZxgvPfXSEYBIVgLbIAzECBGFGLfYtIOslmMvhHBUlrMvGIPuozVrwmDBUdFIkQPuFArKWsCqpAMaunYtJynD",
		@"iyZaDpnNDhTgxfWKNO": @"OReZNzjSFGmZkdaAxoixpkUBgyCHVuyIPGaAOUEctOpKnZRVsypTuncGfXKhZOotaXeAMzfoQyLhcErqfQOGEczCFseMoWPBosxqbsmZJOXHtNHukZXiJUKDUqOwxhqMMsFVfIBTicaN",
		@"FTHMFPsMGdSpwqwOhq": @"vtjcjLkWnKLxACYSBmJnfZelGqDECdvrPdbkxBnQpkPIxZGtCYGHAdHovNNjrFpEafowFkPyBRsmzNOOodsOmkpWlRDOvkSZsWXnltbiLVwYBcLECQmAZCbqSUsDJoCZAPbwJYtQoJe",
		@"nnMIlhYjVTQDBJajk": @"WmOoeRDZksflWsUscuCryoufzGbEUqaiSjjjqwtAudewjEFxtsQwLuFHsTfiKnKCvuCNrSceGkKroLkSIRAmpfqnWnLUjNiogigRWGQM",
		@"HXhLjsUAbs": @"XozicTIrrQlnzqrsQxKkyqrpZOgprHirraUPbGnIOtwXgocfUkHADrxzYnduBhVgrHCSJOLTjICNAseUBhRKPDFSvZnvdlJorAqxmgW",
		@"rJfTcacsavK": @"MzYnYFVpUDcvtggpbbqPDmFfUOSYTIACpsUogrOXeCXLdLeDyiRhfsjIJypNDxJUXOYljWbvaMDCRHkKWWrQYppWIvgNTEDzltmiDgABwYxortoyzzkJlhlkpIefHyiT",
		@"dtPoUxiLbDIs": @"jUWJFlywffRyBujwEpRzGOlFBVlRqiAKwehRXNrgQKHNDLIjhsczLiuyhRnIXojAfUVLTTsZgDwLDeURuiJKdfoxerCdQKpHkDenwhdMZKVVTzOMIwrZjJzxgfCcFzAh",
		@"HeWFGGITYfhSl": @"HnQnuoeaZbFNZTWPrqyRRyUvXvHqPjiFZfjvKxxIUkuiYterzWbNdytpIxyTTflOzXBJgMwrAZGAScfHBDqDlrVSHEcgfVMROMnHUWovETCnWoWNtFUHrCJsXrtpYJeNvWrOydIZHMC",
		@"PxTnlRYzRcZ": @"TaqYSUbDKzmTsmRBdRuWRpbDrsIdBYvieeuIFUqEpErRxSwwmWmfsAhgADwOkSBpZMyHObdOruChJfedIRihYbxUPHmpxGUNfSqJNrkTkSXGYglyBalh",
		@"uEEysIvksd": @"sRGWnRDGlQHffDrwVdcAgfZHsDYjIQErDbOtiErsydTsythUoYJcZMsvgXiwjpkkmHpOjbfohRsmMXgOpiyyDHqIGvcdVrxWZVUFdsJEBoNVqYpxlaCeANBUlydn",
	};
	return TvqVIRlHqyfUSt;
}

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size {
    if (CGSizeEqualToSize(self.size, size) || CGSizeEqualToSize(size, CGSizeZero)) {
        return self;
    }

    CGSize scaledSize = size;
    CGPoint thumbnailPoint = CGPointZero;

    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
    scaledSize.width = self.size.width * scaleFactor;
    scaledSize.height = self.size.height * scaleFactor;

    if (widthFactor > heightFactor) {
        thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
    }
    else if (widthFactor < heightFactor) {
        thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
    }

    NSMutableArray *scaledImages = [NSMutableArray array];

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    for (UIImage *image in self.images) {
        [image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

        [scaledImages addObject:newImage];
    }

    UIGraphicsEndImageContext();

    return [UIImage animatedImageWithImages:scaledImages duration:self.duration];
}

@end
