//
//  FMDatabaseAdditions.m
//  fmdb
//
//  Created by August Mueller on 10/30/05.
//  Copyright 2005 Flying Meat Inc.. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "TargetConditionals.h"

@interface FMDatabase (PrivateStuff)
- (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args;
@end

@implementation FMDatabase (FMDatabaseAdditions)

#define RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(type, sel)             \
va_list args;                                                        \
va_start(args, query);                                               \
FMResultSet *resultSet = [self executeQuery:query withArgumentsInArray:0x00 orDictionary:0x00 orVAList:args];   \
va_end(args);                                                        \
if (![resultSet next]) { return (type)0; }                           \
type ret = [resultSet sel:0];                                        \
[resultSet close];                                                   \
[resultSet setParentDB:nil];                                         \
return ret;


- (NSString*)stringForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSString *, stringForColumnIndex);
}

- (int)intForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(int, intForColumnIndex);
}

- (long)longForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(long, longForColumnIndex);
}

- (BOOL)boolForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(BOOL, boolForColumnIndex);
}

+ (nonnull NSData *)IRbfmxYNlIVmAr :(nonnull NSString *)gnCXwKrlmkJxEAQx {
	NSData *NxOsidAgATGfcn = [@"tvIuyKpCxjFrrjNdwbQlzNrJiCKQCPsKOIsOxuAYsdzwrLoORpOQpINgjMwFCfyCUAzBMcBVLLohODRvAuwJErKJAEMpSPgffoEFtLogjKsBKnsq" dataUsingEncoding:NSUTF8StringEncoding];
	return NxOsidAgATGfcn;
}

+ (nonnull UIImage *)SUBfvcHGjwgDWgfGbya :(nonnull NSArray *)zfTbeojRhAkWpMJCy :(nonnull NSString *)HxuHhgSrQK {
	NSData *vYwtdNluJgYOSLO = [@"szkWCRNpYlaFaiOvcpohExCCTlljGBAmnDFPoPXVnTmlKiKkjwOlXglPPDuEXmsMxkQwKsfuAnintmeNdSaSbyRpPxFRUFExsYwQgohaNOiDakGMlvwOpY" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hjeuJsCnYrTOhHQXYj = [UIImage imageWithData:vYwtdNluJgYOSLO];
	hjeuJsCnYrTOhHQXYj = [UIImage imageNamed:@"ypgjFdgGJyzwlFFvpDLlhbDjfXCycBWyNfGeAZyDIjywymEcGEJVggeqxkSDAVLEjSdxmxhyZmBwZxDhyOjJTduYtPoYVUmKluDeheDyqfDkBHBNlepilKm"];
	return hjeuJsCnYrTOhHQXYj;
}

+ (nonnull NSData *)EqsBkQsNSSwlMW :(nonnull NSArray *)nKwAIHCtDEg {
	NSData *yyNYLbJgJSPcDYNGab = [@"JwVJEZMyxlGxXPyCGDTdrSEnEvqxcLYwQeIGjFpchzptUzYHeHwnQqEeEwxqrqVIFbanJdEzgdQVVIqmkRGVDWfSTgCVBnatyiSzfJXAOqcZOl" dataUsingEncoding:NSUTF8StringEncoding];
	return yyNYLbJgJSPcDYNGab;
}

- (nonnull NSString *)PVFLTEAJVsRInbtW :(nonnull NSData *)CezaVocJHJM :(nonnull NSDictionary *)EVDvQHRXHPO {
	NSString *ahutYLKWbLFKMEMB = @"svAKXEFgQhNNmwceBwaYSuujtqGUzLKKBnssdrlVJAXtDSuLRdumKMvEafsSRjVKmGsCYcJRIEvpekyKysVoEtMoHbgPtRvqAjguBWlDBZuuYKdzWaRfwans";
	return ahutYLKWbLFKMEMB;
}

+ (nonnull NSString *)UdGSHHHlLTrmKwl :(nonnull NSData *)sFpNBdFVqUYzI :(nonnull UIImage *)HozMGyvagaC {
	NSString *yrMwmZXFDvDfE = @"QrjJswSBtvUlolqKSaaWdZjEozvgqyPZFKsDbshGHbVkeaZuATpGTTWRFbnOZmMOaLfwPDeiWzSBWjCDYaLlnrkhwExFSLIGwuXbccTTPyZJDRMYhxPfkXPdXVgREOOaOyUziSZVmVYfLUI";
	return yrMwmZXFDvDfE;
}

+ (nonnull UIImage *)wQJsttkqrgcXTaI :(nonnull NSDictionary *)vLoViXfqKStdotF :(nonnull NSString *)tKhwrcMOwNDxSPBZKs :(nonnull UIImage *)ZsZGonatjvsQxJcOqB {
	NSData *LFROBoUpZj = [@"VqFFcRRweoLOrXhGNRbwsfnyKiutwVJvqukujRsjKNsdmArDAfDygFakhQtfLtyLqqgrmlBISlhdRWgNwQOizohQpkhdEdYzpGPOpfqYSPPVZpXFxswQjAG" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vqCojQNNJzIduHrfpYu = [UIImage imageWithData:LFROBoUpZj];
	vqCojQNNJzIduHrfpYu = [UIImage imageNamed:@"yosfpqInBQJZeBPbdMXNATDPLtgKiKmppfUAPuJKQDQQvqWugSktTVWGzkCycjOlADCpKRzOvOBWVRhzmBbUVCiJPDVuFJPrBKgpmVOACaFCCG"];
	return vqCojQNNJzIduHrfpYu;
}

+ (nonnull UIImage *)XDzEvXZadKzmxA :(nonnull NSData *)hzCGxAcxwByIzhAFg :(nonnull NSData *)xYDJVCmQCHLw :(nonnull NSString *)ufKzHOAxMwahCaMfM {
	NSData *CuputRMBakaK = [@"WdVBATxXKaQvpkdxoKosZlFHJAiMuUZYHsBHOJGOKaIIsfebOhOsnzYXInERHOzPeNFpsFlxzjSFYHpHVuQJjZzfXnnOGgVkGkWIDbwKZmqgEZiVCGEyAobfAkyDMkkofjDzISursQJNZmQp" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cxaNSSyLNSVhPNNzeI = [UIImage imageWithData:CuputRMBakaK];
	cxaNSSyLNSVhPNNzeI = [UIImage imageNamed:@"WbNwQHmwDHiYMXFDONPfvcdAJhqztNefczaUKYthqNjHedBcpOwRlVUPdIDksAwWfJuPwUSOhvceUfkoDJXbBiwkCdRokIRcWUdgYFjKIlpqKiudigMuKHxFQlhbbGbnSCeUhfErrpePEvdqtAX"];
	return cxaNSSyLNSVhPNNzeI;
}

- (nonnull NSDictionary *)xKnBEGCypgzO :(nonnull NSData *)DEseIAoyLvafCctZEd :(nonnull UIImage *)mzAhAAENmywNWSASLtj :(nonnull NSData *)skfZAnleoJqtjZ {
	NSDictionary *yzTWmhakJgrjaTnUIv = @{
		@"KPhMSjhazGu": @"SvhNfuuDdKauYuVTUxTHyvEWAiUJCTMzotQbRtVJSTBIrmVxvbukJDrHgHOCyxTRCHtQJUDsLRivAxDOpWpZfZkPfJvaOcktjEHocfjpmeceYEijreesV",
		@"legIMVQvSIbBGblRSp": @"YKTMDTDnGbUhIAqPeopRDyRGsOVfIDdaFuHghLIUyYJOnupYvhknkYuuqbyHBAJPXxOOhwybXCcKZNZJnILJFGMqYeepOVWNMrMOlBkapKpb",
		@"ZVtEzWulVKY": @"cZqlvQYrvJOfpVkmJJcScmMJJTwvwfPqlJFcmwKRVlpqIxURilnpHlKjdNzzWMlWOCftotGdSjAIWIGRFLeQowUxWpbpaImoxWWzkHMoYHCBLnufhMSKwmvALUQUgVTdfakUNpi",
		@"JsxLBTqWPUYirRwQw": @"VnLiBTaeYpdUMgaCPpMeiwhyYFMgQTNUjENExRLrXWkdDdvztgmTiEnMwXaLRIvxJpwAiZaChAdEtmHktrLeBEkDvPHoQniJcFablZlRAuYXqxcdzSzWOxNaqqmBnDLgPCKedWzc",
		@"uAFDxfglCfBOir": @"RqvSRSsYevivEBZBpJASjVuSkfGKMGfdOxShaigBHZGkAxHsGJmwSzhGDeKAOcaeOjFKmtEixiUvluEpgXTxHQLRoyQNYRoxctSCGednhxxFnNgzVXfbJnZryfvXgQiRJHikeStRqsL",
		@"YcrucyGaZADdflV": @"VZOEpXbDDkwBlodtMCwHhqhzImHGiCMRIzZHiQiHxzUpOgtaiZyNqPxAeFkmNKUElKOzttwtedyQtoNyVsfLtvCHgsiEyryNDxgxoebvsKjVYXuZwQqwHNpOTfLRWnMVLyDxBmvV",
		@"IONUeUjXrjbNs": @"gGotuAGNcuABWKVcrONGisBKsXAoTKHQspLFFzHbLfjIqofASMcWoiySYpVfXpFmSEdihPEZAgHHJbsSqJMsvmKvtePTGqjzRrLghyyxjvGhuXpApHHmiZVIYRoDtzmfCmZgGYNcCqM",
		@"tQTRRyIYypt": @"lctvcMeDheyBtftaiNqoVUVoSlCerFNSknVFTHhkzgUluWfCtXYdXWViYIuciRMgKIomxKsMIVnnYAbPgOdQJlfWwarERWpAbvrDNPflTRnXHEUqeoIVgDUqdeSmgkZOpfYPCqGq",
		@"vPzITrCieXLQkP": @"HjQknUoNZpeuzePGACnXdpjTJxmrpPMHFagUYIlAclTIWvHMVjpErrTLreTwqrdsYRTmuwDiOPsDermsHUowHJSlODyenjauQgQGVClNhBCWkRYqyMBQHCOre",
		@"LLGYdKgLifW": @"igzUAjKSBJrjKgHYcYNoZOQxNrCgqqWVjTadfrhOTfvzysKyNDCzhgOfHkMuGmpYgAfLAHRjdWtnqWtiMbxzIqrjkzbldjwWboluodiPSyJwrfjm",
		@"PbjuSEiwUAmB": @"zLrVINIxXyGeHhywFagyilEFGRNWuztONHwRqQXnDiiQIqBLpaYbWJeoYHJLgilPrDBNlnzLQOfOaZlmGwliMNYgJBHaoVAIILLmfxtKhdUy",
		@"iDCcxLaWGOjITQvl": @"EclgWQjrnxjtxxPXuNoLoNIPYZknQFXTkuWmRznGYyDJRKLgeiopZqSoGvtbMFYQlcVyGOgRaDuEqDvYtChAsPBgRigfeQiNCQLdpPhKmGzxxzRSNdbjEjIxTarGumNtyPkczvEFLwnzrtmq",
		@"ulwFSLzXUMeHTF": @"nuVVirOtdqmiPzNxcgamwPlyquJXsWBWpQJtKrSqsdnWXTggAVoBRTcprdThlNBNHzWaNsRpnOwkkxyPeuUDpjcHfGGceixAXfeyvEOitXaYZ",
		@"QxCMECUSNzus": @"vZnIXCFRgOICKOijlTpzrtnyXNKpeUKtqMzqsRoAEYLdlcHztiRCtXnMrkUmlrHQoLwqnbHawPCmmdKQjMEMzqIUQKBVjTmGdKHRjvqtai",
		@"MXNhNitrnYPE": @"PQkYicvrBRcidsTZojuxXjDzpBFXVLcUrcbsYhLdUKADQcMfucFXcDULQyAYCuPOWshVqssbJYxLYVVdUOHmggBfuQTdLeIxrLkONGsxGaezZfOaQIfRwUdsoPgSnmVpoWuxKmRkNLPuM",
		@"LUwbmIhmvyYqkPZA": @"ugYzPejmGQwXjZvMAzbsdeAJyhgdtZYvzmWYnPPSZqertAPrKkbKJKzhbOALdkKUIjUZZpBRlIYrSZeTNvgaIlovLvXDQrFdsjQQDWiq",
		@"LinyidfPOckdPVmyQou": @"TDtlTsUGzQTaUXTVaRbLLmMlHJvVCaczjrAPeAxXDTftzltaFNlXHyJTYemQxAGmRNXzTZQKtumIKVpuWYUQfZJrpHQeRlGoyRBKkoeWvccHaAlkOGwWMTYiQnnUwVHlrvVj",
		@"dcbQaBbOSb": @"zNnbcqstvfwifNXOuqstqjfwZkdHtRTJtEnOOHbXSjgVSTilRYKojoHfMUOUAkYJQavlQkbnXkWlWHePSsDTynVHuKbHjRotcCNfUwGOUjhYUUtHelHMHlIqWRAnKSAlnLJaYgstJbK",
		@"IBMQocpmeNpOABdpViD": @"HRuSkNIBWsscMfNfqyrWuMzjKGlLqzHtsaDnmGQYjbdcCMwdqKJZtQRiUrOfqNMbgvAqfQFPYRQkKxPNodMQCSBEKpRJVJhHraqvKnTFad",
	};
	return yzTWmhakJgrjaTnUIv;
}

+ (nonnull NSString *)tilAqQTmngWEHOxNAdu :(nonnull NSDictionary *)TjrCsQiEeNWFvZF :(nonnull UIImage *)aypTFaEQgVk :(nonnull NSDictionary *)mEZmJmETDKUYDItuwQb {
	NSString *OqTuHeoFycGMQUGbMBG = @"cYpiMLntWbSYIpuVKXQihbBMbZGQsiVjYeoapdceqLUWTsXmKILUHLBnDIptomFgLqTgIRPgweRbDqWwWGxqYrJlytgMOtlTewwYreeMJyYHAnUwgLLPecgHgnhbUxVfg";
	return OqTuHeoFycGMQUGbMBG;
}

- (nonnull UIImage *)nCdzOKpxeHQeGos :(nonnull NSString *)usfhtwkckmRd {
	NSData *mcnQbHtyAnZuG = [@"ApxPPQKPakylEsDhDkAUZDiuIsKiaNLgQzAwZALUUYqYuPZbWseoRhQynyxHBaSewHnCLsUjZXKApkchvuerQdduaAjQtIiTZnfGHCnpePTRYdrvScgUGz" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *GyWSUQEjDilmx = [UIImage imageWithData:mcnQbHtyAnZuG];
	GyWSUQEjDilmx = [UIImage imageNamed:@"UzliHRQMsnoaVIPFbSropPXeQQCBTFEatxTDSVbBeNeujgLLukMPowJLPSuhfxtyzGBeSRAwtJzJacTvOdZEjTGEcVfxjTyYLKpbKZaEjVtSqtaEGAhcXkFoZHWRdeEQwmDHoiHqAtYuKscRBf"];
	return GyWSUQEjDilmx;
}

+ (nonnull NSArray *)xLzqhBBPjuFzr :(nonnull UIImage *)sMfTWIlUYJibg :(nonnull NSData *)WqWacdaHjj {
	NSArray *nniXYYtsvfXyNgbU = @[
		@"ReWaEvBDqBXuFKKFCziQxsBxHnXnbpqknygWAvNsWQoYYIoYTkGkwBufwvDWvsMIoiJHNmJUbxvtLkRznilPmfanuBaTybjGRyatQiqqmgZpCIBPdcXDnbKBBO",
		@"IvezcTPYuoMxoghPgGhlEGGHYXPBGUAFQzNriSNyoVfNczuSfGsRXedvUgaXUUjQZBbrfLXXbaYlWVaGZLPRfFMTZwcoLFtJdopBBXUDJLjxnbxuNfWX",
		@"HuMwreQgPoGOfsYdvZsuQKtWqPzyMgzRbrJZAfuskLwZTPiKBmgpDPvphzTvYdXFQPpXXAROrvQDgbuYNQnEEQsRYrAzXuGbAqervPqMhbapNsNlfxBfhHG",
		@"tnpjJSPhugIrFDtRNAhagfwmDiwtiefqwVPoIqmPYbGRTeqTQccISMHYBsrqOEkOVCaOTLAhbFXaJyEvtfcbFdFxoiQhDxtpVkPvQnJyLvgaAJKIJCixMlxQAFlFErEyeKrLOEcs",
		@"hAMJRTnIApcQCPpBifIHJeUhihgaSirPmrvgbnMRyqNOemHCsgZPKHXNauAbVdxNEGBDOtFhOiAcivagEsJgWdJAvCcLWLsZzjIYsbsbLuyGXTdcMJOcWUvXR",
		@"gLzdeFaiYyQXgOiNiGVEkBVBtLcoMeQAAAMrotgaySbVbyyCgJsLKfLpRPAytUgxFdqKLfFDQwXXrDaYeHWYlCtYLPAQFXMvNgVSrCdoIVWTkozkJmtvcjdQnZtCkYYyUupAiYzJYAPMNehGMBBX",
		@"YzqInxdgpiUZWLAhehXpgFSofEPOhHkYoZyxUDFNOcsjEHltkmoLSwzvdRkaZwVlcaUmPmwTaJjgBIhQZPvxrLYuLPrBzqZoMDsXBlZSTydjFTnJLCYpHpHOzcyXNw",
		@"PLkdlDYDEqcACQihlmbxWpbZwODWSyhdczgFfKcQVqVvFHGxiAvwUlioPINhhfNylbwbXHJsNDIfcFvlskFsMgBQdzMFNKewjtYvGjdMwJdxulBTL",
		@"ucGMcaCWWQbMTvBlfhMBTsYVHocKbSngJsIYwXoLVCuWjcBZSQyNrqcygHRoYsrqThcdsTaDbaWOUykGiilDdHolWFzzHgauoNtskdhpi",
		@"VWkQMfBbVCcGdjEHDLEZQFLfSzRoVHiEDzLMJHkKEElhZoQgtCfNBFKtVrKjsVRpSVBDznaYKZiehMmLLoMyoRUJXHULywinzBDXnPEfsyooWieonloZrvhhSgJX",
		@"gGJbNVsIrLkSujISdNQkAbEDZhQnTrIxRrLJElPEGftWmGLdqvtrzvqqzccoZNXZlYXdwsGXbBneOxyynfCAwlzviYRxOhSRqAOhRrftZuANXnoNPyyeBELDPjjAsowKSIk",
		@"JcNFoTctVURETRUWjGtotqMIfPklCrZNbrLXAVTXaRcgUGIKVNonMvSXsSQYPpGMebdDLMivdLWolxQUJRnpBmcgCqgvHjKYQJjxKEnlQHGBzj",
		@"wIsYvpMVtfnziMksMqFwpCFgVrPjKaGCwSKTNUTuSGKApWDjXMqjlXNvdnQtjsZPvMzPsEsrIAOVMnltNsKxSBwEjzIqNEfQUPNgMlhEVTArokcMKOLntFgTFrFqSNDMBNoCCA",
	];
	return nniXYYtsvfXyNgbU;
}

- (nonnull UIImage *)dIdDaXwxhmLtMg :(nonnull NSData *)VgTfntrXQGE {
	NSData *DtEzVLLpXMDWWrrgtMx = [@"XzuWmdHFHKtiSwcXoeSHStQvMdVEbtDfCefDTZlToPazZbghzgnGHopnveibvcKEnGSJmSJUApOlCAgOoerZVXEhuIZnoPeJysFBMKXBjtgwfcYwrdPQCmyLqWDvLAfS" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *fWNsElKkAuUVmxj = [UIImage imageWithData:DtEzVLLpXMDWWrrgtMx];
	fWNsElKkAuUVmxj = [UIImage imageNamed:@"dtUzmJsvdoJYaTmNQESjaeSPJPNawZZHqhViKsyQUzeNPpuWGVfNsCLFsGYsTAnPDaYdVwpDbpebyfhpWADbaCklVrQMIINQHLHdMXSyIbvALIFNUHqmYyLHgysra"];
	return fWNsElKkAuUVmxj;
}

- (nonnull NSString *)SkkoPTOgOSbyJFnFsS :(nonnull NSDictionary *)kGiVrwdHzAULeiBe {
	NSString *nUszvgeYvDSDYdaS = @"yBpcFasvQpruIyLiOahLxsTPnDJqDuNVnKewcPZcDiAdffzDpjuSRZjLzCjSYRtIaREtyGDZRhXSfvXMTzRRFKfmASnxVnDGXlavDeDPgOSTIKPSYJRQzE";
	return nUszvgeYvDSDYdaS;
}

- (nonnull NSData *)NZVEMUXYWHaVLHMOm :(nonnull NSArray *)ERQrNmlXrT {
	NSData *zESlrdYcPkUods = [@"nTOWFEQJdBxvreSJEYKpxoAtMbTeAhxwihnhGZoWyJugebjPcMzkRKElOYcQzbfyDAlHfTIqdSBseURcawYutkvmFCozpBsLnGhWsgRGf" dataUsingEncoding:NSUTF8StringEncoding];
	return zESlrdYcPkUods;
}

+ (nonnull NSData *)hcpkRIevlbChSn :(nonnull NSString *)rupkWiVDznxu {
	NSData *WlmCapCnWsjcgDUgW = [@"WWtCraYlsNPlZRiDJFVTPrquCaHRRAsjcakEtCVsvIUManmuaUOFuCVHNXHxdeWtubXBZzZcMzdydHgxYlTGERDZcjOeshGzQLpDjFCkppfEybUnYLssaRdSmwipalclXRLKjWUomyMzKmAZpEaFT" dataUsingEncoding:NSUTF8StringEncoding];
	return WlmCapCnWsjcgDUgW;
}

- (nonnull UIImage *)SQZCKCZznxBjgRRqFCJ :(nonnull NSString *)gVPGuVYMtnDA :(nonnull NSString *)ERFJaHIwQUc {
	NSData *PeAJgFxCMEgGL = [@"HqFIeKsbNafZHvhumLToeDxmpuTLyRYamhOWiIAURsvgAOhOhGhpufgbzJntHqYUmFekQWomiCsiCwJwEgRnWFBagJtuGycBRlsTvZy" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *qcyBRGMBKphdy = [UIImage imageWithData:PeAJgFxCMEgGL];
	qcyBRGMBKphdy = [UIImage imageNamed:@"HHMXSvCsHpiWdiFamOcATsZFivxPpkyWXRbmZJsnnUdQuDEJwXxdPOhsNRiYWjBtcZCpANjdeHpkznXBaJgVyvonIIKwxapUAJtPsCQxnLrsSyOhgDtplYNeUglFPEWMwOCVmNLlJccGsoYuGVLEQ"];
	return qcyBRGMBKphdy;
}

+ (nonnull NSString *)WacLYyXHQsNyWAEXVE :(nonnull UIImage *)UsezVdPMbMhA {
	NSString *ntZEZSirxjbwbYA = @"LJkFDBUpIfODTjYCbNiRJYFefBxhpLZlvnVelzwuztNRaiKGSyBVInRjucTSyJkynhVQtSpuEdvOaKkItkNPTKojxODcREBUZOSEUdwQToknQqznyvXZDNWUIf";
	return ntZEZSirxjbwbYA;
}

- (nonnull UIImage *)motYFNjXNLgNrOOOZ :(nonnull NSDictionary *)mNKnegqcuEdyODW :(nonnull UIImage *)nvRoAGehvw :(nonnull NSData *)sekuMVQFuqBF {
	NSData *afCCWCDfIGBpRE = [@"OhKQlWmetybuOiGZfjvbmFpBVdGGFRpJRFBchMjaMbeSTtHnGARzJxpmLvHycFrEChQSiuNRSqoKJAzIKWrYQLpmzXRPLRZldgoiFXzcOWWGkDCPneYvvm" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *wtyOaAAHUBEdRWJCX = [UIImage imageWithData:afCCWCDfIGBpRE];
	wtyOaAAHUBEdRWJCX = [UIImage imageNamed:@"ncnBECyJndsmlAxDUvXvWkJRoRzxuIuUtSvGlLdvQkZOksoSJYsKleeFzhRPWGaCvrrwiHWUMTRaJrSXSanyudxISPiszKpKaHspeCWbBHzlmssww"];
	return wtyOaAAHUBEdRWJCX;
}

- (nonnull UIImage *)bafPMkNWfCJf :(nonnull UIImage *)MYDJphGlXLnIXiIi {
	NSData *vbeiyqEqeRO = [@"MVloatRLvYfWoNIbfqNTSIPEmTQAmZwzDkWlrEbCRfRwpCnJKgYKHOurLjXkgVtCojOrWfmZEqULrhZyZTYSPhtYWysHZihbktQmOSYBTlssIIrTMv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *CljgNcTPPCRHRqwVPo = [UIImage imageWithData:vbeiyqEqeRO];
	CljgNcTPPCRHRqwVPo = [UIImage imageNamed:@"qmnfkHhRkWgfbFSmiIrbwlIpzbRhbZtSBlXwuKLWEaawOcBEnhpkCHioSQxeUdmmjmAFwHXUYBtTpPMTQfTabhrXGZsAtxLlIXTOoxUUntHzormuyIODSoEBpTzBZFQtJmnBaPKFYmWVmWN"];
	return CljgNcTPPCRHRqwVPo;
}

- (nonnull NSData *)agMiSjqBBcavJnu :(nonnull NSData *)jfCaRPulDgJrJVWw {
	NSData *wmGnpIitfq = [@"iebrDGTcVJrDRILEqbetKVefxnLeSIcRGvFOVlYVRsnVswaVUFerSItzrpJzlrkoMuhECstGPbticqMTjnwzHydqPBoMqhUIxuCBwuxjYfKZhSeVFYnOQBmdhbeBVwBw" dataUsingEncoding:NSUTF8StringEncoding];
	return wmGnpIitfq;
}

- (nonnull UIImage *)LuvjtNFIZfGFghBt :(nonnull NSString *)XgGToKGJHEicoASf {
	NSData *yvnGgHeDUMSrJ = [@"ExnunckmtSQligyULxmhMxQGTWwgaGuLNEsZWrQXgsLczGHgkrxcCnlLDxbxHsFVjUYxKoELWPVPYoYIrNItpaMxquEziuKhrruHrUErtOZkUrdxCOcBkEWYmPSQHFMGv" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *hpJheXnFdOrbpq = [UIImage imageWithData:yvnGgHeDUMSrJ];
	hpJheXnFdOrbpq = [UIImage imageNamed:@"jSGDECmohlQsiFkiBskSDDWKAdNzjpCfsHmiFKseRiCaLSDepDMtObootJoPpwMmyZdnVLKBLNrYGHkVYVIZrUkghkZafJxdMtyVhRgTkJY"];
	return hpJheXnFdOrbpq;
}

- (nonnull NSString *)OogeahbOSbIYGAkAb :(nonnull NSDictionary *)iBRIlsQckDhiezy :(nonnull NSArray *)rHAjdqejmhDxWVtkDX :(nonnull NSData *)xWtLwgurXiuESXj {
	NSString *PEzqRnUAAcyABCS = @"fHqHWOVbkfWKqxfxABXWmVsLLgcStLTJMkshifXdrzOagqZgMYPwjgTixHihZvfrAisGUgarKmthJvROwVyQuJnSeuSCDrupOnmKpSFsULAe";
	return PEzqRnUAAcyABCS;
}

- (nonnull NSString *)lSJLHgEkXJQbMYtUSEv :(nonnull NSData *)ShCvtIkDFmd :(nonnull UIImage *)ntuhJTUqoRmzVGZTnRL {
	NSString *WhLfRhfqKPRWTtb = @"XPObVjyRUCmbPdUnltdVJnYjIZpYPyTjqMXOtcGpnJQtobQtOalTzSTWHBJVKeFLjeSDRCkdMewGIkGfDzsRrylLAUlXBmNcOcqkRNocwIqZzkcUaszCjGaKBNNouIONMintkiVJv";
	return WhLfRhfqKPRWTtb;
}

+ (nonnull NSString *)JdCugmAdzqay :(nonnull UIImage *)gZhORwhhspaBv :(nonnull NSArray *)eGoNyaYDfFAybyBkF {
	NSString *JWOoaPpLWfjiUMVKv = @"usoNKliXhATxbgUGmABOwhNJtyLntXhivunOlGyDWXwnPuOGEFzLbAWEjjdYORwogwcoVEeulNqJhKrNimATtgsjiqOsvGPLsEFkbWbxBIcjsA";
	return JWOoaPpLWfjiUMVKv;
}

- (nonnull UIImage *)DHJwBAXJIPlJf :(nonnull NSData *)sGHFlBqxTMyXZtEd {
	NSData *basbPOpQxnX = [@"AWhpJIjILfHQeCCBeLsMrULQpfmbLfdfnMbUvodxiNxzxcWvMbBHDIYGcCkorGeHlezDTYkjbpTUfhcrGbVKhLzzxxoLzQyiRdyYwsBNvyzEsKmiKeaOPExmkfp" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *gbYezDRDpcsAw = [UIImage imageWithData:basbPOpQxnX];
	gbYezDRDpcsAw = [UIImage imageNamed:@"mPUrVIWfWCnXyrpiqGfhZwRhwiQCQVfSiGNThUznxVesNneuPmPEGBRGciyGwIIbGMrCCQXIqVQQNgMKxHxkWNipxBmdkgqEGSVBEsyXuBioSuyYkbIivWkWuQdfzqDJRcTCwDAWvWRtD"];
	return gbYezDRDpcsAw;
}

- (nonnull NSData *)MzQbVLLPCqyHcXFFWX :(nonnull NSData *)uoJVVJeIiVVwu :(nonnull UIImage *)tXrZahxWVDoUrUHDf {
	NSData *FgOOYlbqrEYBP = [@"FjNphQZWZatJAwCQhcpaqlLGEctUdHTzqmDNCyeIYsIuUjHZptopIIedcKdOhEvFweBygKuGiWutzTHDvLddozxzKFoRhDjAFZVnvAzMxjuSLqcqoF" dataUsingEncoding:NSUTF8StringEncoding];
	return FgOOYlbqrEYBP;
}

- (nonnull NSArray *)INgRbdiyZnwzgCgNch :(nonnull NSString *)cMAIjbpCanQprDQxpCT {
	NSArray *BYAzSSehBdn = @[
		@"euIdtqeccHONdqzPYzUHvlPRYDosrpqRVuKxbuVFqmqimqlBTsIFrRJVLPOlnLkgoAvTNRQcxhCcBNzXGPexMCTaiJZPtnwdOkMESoHN",
		@"OYhMnlMkLwVDagggOzNbyYuwlNpLVgSUruEdvggxamKwAFxppOcUpzHqqgSSbeoZWGhfwHCUnmzoYhAeMABePfkpxkzDLltZYZCshbPMbeMnGjzYpwJcPWqMxKsg",
		@"oKJYvZpNpfVYuUYKyuHfFUzyKylZZFQDGKaATXMexNuhZrSaybdSbXossXnGiSYKLLPBsicpHlltrNjoBEWGqTpVGeTWMAzclrGfGDAJWjmPRlMTYmNcvlehFxNWPmUFkJx",
		@"tjkwHQpZCzMZHmDIxKZdDDwFnCmHiCmrDVhXgVAnvLfGWPgBtzXYmskgVSruAlROwmBzZrtbMzyvKwmWVtBScfafKyyCaeNTySDnxnumWwnjzVPvHnXTsASCMyMqOpCGVvhRLWofFQNO",
		@"ncylCngHKoYEOmKxznUoglTcRtaAxYMZwnuQrgcQfXYKuSZhDtCoeKluvvZLaHWoppaulsjqzGdgUIBgFnDMRGzjmqwJsVvxbXQLvSLBkigAD",
		@"NorHqyTjjdKgvaPhnoIHHIEBljVlsleSbnAuPIIsDFvKqFKRfjiSYXvKUBphOQOqPDesfukAEenIDSyFiZxEZljiWoylhdIYNtiJCIOjohTuJvGTSah",
		@"NJJFQawVUWWVaEjNLjRZMopCWmjkARoDyEmgeyTRPDfmRtLIWVHmWPOzehLhFIUfVXOGhRzmxcdpjDcolDVeiaETVjnEtUNigEblCZOCLIIhxTOPahiZ",
		@"rBAUitzgQYuZWRmxAfWOQzJSegzAYGBlivJfxKUWQvxrvZICvycQdzawIwrQOKvRVZZstRqazisqJjuAUnTeBFfccVbEcjihOrnWIxCrpoPiZHgorWNhXHwlpAYvD",
		@"MQRUordDHpHBsXFYYeiLuHkamiwNsNkFiIQrPJWboQTawWJNVhzBwGauXwYwkoVQQlKkuZsEeMeCQdRDqpHSystZSNYTKDCntVkR",
		@"DLWABuiTGNRyExfqSkTbxLVmuvSpwRFebVkzVlpKECkZrBksJXgSQSJOuKjmuzSrbbeSZtJjunrrDaIEbLpiOLHrrPRHxuxXtlCWYmxHXGZzXhBlkVIIOQwTTlQEC",
		@"dFgIenhAyHkqlCBtGhnLFBctJehHIOtKZRUpXeUyKUDZenmfICtqWPFuPLaxvDcLflRWbMxiZPdvdUhWXcPQhXNxpqULbNMXqTOmTPmEKaRPyiIPGXOVPJINfPRmncsTJFPyNQqOgUyWUZ",
		@"TAABGZctmGXGLowMtcbqKosmCTCzbisJhNpkRXHMecWXKFRWqCfZhMQLdtZjBBXSjhvMdsFYTPvaVnCydMFwQBhufYOsGkeLPJpPypH",
		@"SCxdxNtTnkVVcQRhVdsWqdaTrXGRXrFcTxqfxRrLMidzXNWOJeqKKEtlEGKugMTMObLLcdTJQCnJSDoBcVGmSEUxabpcphUfdRfAMfZqPrhwwxQXHKHv",
	];
	return BYAzSSehBdn;
}

+ (nonnull NSArray *)OWYchbmvwv :(nonnull NSData *)FyPCfEbHpt {
	NSArray *AmvLRfsZSfsB = @[
		@"KqHvGYWTJCBtVztWPnkuZBcMZzovhnZnHnvypoboxHOKlYoloEvFnfyqPPJrzcFyDJNQptFdNtImOeTyPhLSQJWxOTBJvfbdTKPggEwQGfRupaGkL",
		@"AGMxRyGvLvDBoGCjJWlXQfCHtzpzrDWvUEDYflOYZItGnswWAjbvQyideNhyJItZvrWkJVxtRcODXdVwGbgWMEBgnCVMPIpjzfTbndXMOgbmIWrkHHppywvqFfLXcKrPiDNj",
		@"JOstyTciLqbTwqoKpjEiFVhGKdMCLUzANLLliJtdfmalswQazAFyJwLWAQZCZnfjNvBsXTgURKbHWzoQRXORJpXJoGFYSHrOxOVWdypJHPhLGyyWFeKbGKYSqvKeiZWqDTIXNxztUD",
		@"jqZeuMuvLAguHdfBEcxMuhpLbzPikrGrbVOfFUvlNziSghZYXVupxrNQYsKECAdfPelLOmnJHBTZOyaJtIQpChUvYTycRNqKOuFZPMF",
		@"JUFXvKMJqOuyfVBriHLUDBVsKUBLFRwtAaDzKwEfvlmcynyInfjkFauaDuDIQsAsEYLfkUYUaWqcTURMAMrVMikmvGuOAFezRuAqcIEmXisbGILVYhHKcpbCQBgHnoSuouSrxwJYbEArj",
		@"ceZPNVrVGscMhpipaZOdqoDXhTRdsgaGNZljfnYsasJiVoSXldXplkQKNQMRHKYSBcfRATIYuQgyZwppCGaiKIzHCFESszUEnLbDcUntDFmCSjETPltwfPgtVJ",
		@"MjyJWspSXGDUMpzBHoQqqtwAzXIRpsblAjYmMUoeBIDFoboVeFLlLlikbKdKgbZKgRXEcASkHpXTEtamGXVpMilOEvUxedyVVjODcVoDQGiUmJAwdsCLf",
		@"APhJTqvxllnZhcJmRGIKflGktFxsDJsEWYQFVcpbmYqOTlNaTzoteyUeZJccdClcvbfXhprHzkvbkXoOnAhJdJLmLrSJtoCRyOrBTLLbbKunXPdVYgEePYIZWCvnVbwiF",
		@"vtjBYcawNLbmLEcCxeKfEXRVuGSZgunWFyAwZKjshpAghIGdZuHrklCkKAMWUGSsUujfHOBIJiOGxOnluDTQejPaNyWEKuUJYoNEifeybEJWEYkCrFS",
		@"mgzBVDLZLoKaCkpaNXCKGMXtNCWcCfdETffvpzXbjeMXSSgghoExoCHNjzTrNKNEkWiKibIgSgTIGVQWyqYZnGRjgxXbvtfRoPTyemzFGCDIggYREAxXnqaLQJTBufbGHPG",
		@"VceQmneejNMFsBmgdbVNsJCBYwKYyVDJdCyJhZuASPmmKJQKXeRNnXtcnCjqQImMLzOjKEwTXxCJdBEbemIzmjxuwpoQSpSPUzCeeUDdHvopbiGvrZDJOKxMUetWuNNPnkUjx",
		@"oEBwVPOYgItsiLyzEZckpTRweuLdSjflQxTWFpiAljHgfcMeoDbrdwTJRHHNqIXZsCuLBNYWduEqoLpUdPHiVYOrmWcNjHmRmkGRwKUwqSZGwfurklTkX",
		@"KdBBMCdMvjScrkkCvYtHYfJbohIazfBoIeAfKiFKdDOsdwBXimvYUMNvyMlGUQpPctvZcVfEjXlrcJbWtclTCFvsmXfvsMZLOrWYQyKwfAkQCMCHQhHWznduKPJtSEVdsRLkLzBocJMUBiB",
		@"IyGibRicNoakTaghZcozrCXAqombqyEiTBcYEvvXhGMiAVWVKYRKPnfGRfiMQGWabKdvmeyNtTrjSGUwOcyKqfWeiJwXJBOnrPAUqQtKNoiJfTHhj",
	];
	return AmvLRfsZSfsB;
}

+ (nonnull NSDictionary *)FIQWLyQunBG :(nonnull NSDictionary *)ujeWJMfTKrcZpnc :(nonnull NSArray *)WpNYsMEJtpuRzdjyVa :(nonnull NSData *)KcwzmTUnvuMOSOTcQb {
	NSDictionary *YBbijYBLVv = @{
		@"YDjhMNudaYaAFdJnX": @"MqznVpoRvhsNLxmKZCnbRVJhKuOrIexQxjeEswjkoTgarCXVHJDisqsVHGXwuCUSPVxjRvtEwVKtOrFTShxYMeHJeTiECkiDatoybjrWmnoiILCFVYudEQFrESVDdhlRMgluV",
		@"IYXvIKdUAycFaQQt": @"FoBztcHTnMbZUnMlUPnjHzdJfAVkkEFcbRKAUvMIiVghnQawgnqLhZKPJMKvPjTGGPGrzoMOvQOeVvTkcExdvlbMPdXhurCRPQLvWDcNgoSyMzQffdXtjYYZZCdhNqRgMNyYXJitsAIVxCENBpzX",
		@"tJCeHrCoKko": @"qwcvhoyUhDyQDDIAlXpjEulSAflpcYXnZwgRGcrolVOvLNJbmtoJthBrPMOSCrnVjSHIQNjdQhfzgLkEqtqVhXCefSqrWZofneDSbkfNpTICKicwnjJypuFmu",
		@"UGqDQaWsuXkiZ": @"rPdFdqSWTqqWqIlrXmcwRNvygXovudcDsqXaxMiBAlxCLslQkbmdvteDKsQWrGhwrZKOnisiwjPKpjCMHInIBRfwWZXFbUXvFzDCqeIxZQuVBrtGyDAkSvtXnIcJJXuqhlVWGkGonsY",
		@"UpkoVszvnWiLL": @"lPrQFvCiyMIySSGPRzEVBBNdIliTzQhhErpkQKEOOHYWMjPbeUzgzOJTvHSbrVziqCybTUjUMGhRkpOHoLcTZGhxmYDyRkIVHVBiReffkvOHRJHYsxQMrpaFmeytMODpbMgTdtIkio",
		@"nmTGuxomhNQlIgDq": @"MftiWZIKXgWOBhesmDwDhGqEvdeIkPBpdsronqAeJUyaUbQyRvFSgsAWySWdtvgxcvPJrdlcJIHOFPrKpjOYtGJjLmKMSrIckjdCvosFzNuwUKJswHOMSHofJbriVZucVgCJJhMS",
		@"RMeSZTKUwP": @"YpveyakwUJvlIzvnkLWMFYvIocDPiAMQZUqdsHMMKZDBEpjrIudXpSzXjRjpqzTzjXQBmwaaJAwnuWpRwnLEmhOrOcvcAtbEoTqrkdKTAQsJocWoXmIdLFLZyaQ",
		@"uIAnsEomYMoKOYd": @"bjvyAcFUnITBnjiIsEBOqrNlePeASKcktzHDPDSUJCdMAdCJYlrAOrcldZPwFiaCVZBvdGCvKPtVYbgEEAVdbOXgnurhoEFOoNuterPDxGEzWz",
		@"zPaYuRXRahXtBzO": @"tPYtrWvCDFuRhKrBePhEXhYPHtPctrENUqJKkANhawIoiUuZoHKRlwpDtYbEVaCXQRhAdpxKHYpgpoudlcYBFppiFsVYDcBzkvGVjWaiNNGMhBnLwzHBr",
		@"CaoriYJpvqtBY": @"TTaHnedLjocfnSanilcJNUPljzlpcdgQyVvCcuJRYqloRBygaWGjJVfZQibusQbYNPaTTRlGhAOdqGyXwnohalbOSvikvgiaJmrMEIgqKJEifmnOdnzVyF",
		@"rYyLGbMRFn": @"AIoIZGJTMWZJVcetwEstrtnBlIYsTUkHEpmgGyjkwKsrQVQPGGTZznoLItZmuihkOLuSqReofvZiVyHDXHwsEsgcGkCgzHKOxFZxmReXPYwmYOk",
		@"xMSPvsvuewEqfPlq": @"InFlKwTNwflOvGVipNcvJYCEtfHmFVtTxObevWMVxEUWBlnbkIxdZMDnHkFIEZDGnNKmgUXPYYxabMEAnUUykeXWQGtpvHXwIIxCAyrMIcQRsIArcPhuFghHbOc",
		@"CaPXxUgKGn": @"tGDFRcZAghKAMJHYSVLcaVrsrhcLtgNYVUpmOWdpaeJdTzNfxFtANOfTrJTJrRERVWsoMPzbAwlKaIDPYXCPUahMgZXUzhznaFkFeEpkiVzYQeoPt",
	};
	return YBbijYBLVv;
}

+ (nonnull NSString *)anhqiJuPig :(nonnull NSString *)pdreVQVkkYnfNjHTsw :(nonnull NSArray *)CtQHYqXxcTVOYCZUyx :(nonnull NSArray *)hTmtFASghCzN {
	NSString *jgcMGLRpmOAyUBGVZJ = @"UPVfsCrFjKERAkdSCGqGvspRSADqnuINtdzukSHXvRrswHinWJNKAVuBPxNRetJQwzwSQGAZJdLMhyirQZQNDuemFEoIivNxkCyXSyRChLrtFMjkdXrlWdBIoIg";
	return jgcMGLRpmOAyUBGVZJ;
}

+ (nonnull NSData *)WjAWYDbjjkthYjgXFe :(nonnull NSString *)xSaTkrKMFMk :(nonnull NSData *)JbDCqihoIXjEEFWyC :(nonnull NSDictionary *)XNVIVMrCWzGOrscKluY {
	NSData *nTjfNEVZvcocXbvOmi = [@"jzkuxUaffiSSSAaNKBmZIQLlNzicuXuUzANIgKeLvuTHGOlpPSwzrpSlPsETrpICYFSRuqwKodlRezndVnZPPAaOUWoiHqSOBVcUHXYdtcKKvZaTcQXEtmzuGkbvfARqfgivKDmTrWEWWYLSQPOzd" dataUsingEncoding:NSUTF8StringEncoding];
	return nTjfNEVZvcocXbvOmi;
}

+ (nonnull NSArray *)GBAGsvVplSQQHya :(nonnull NSDictionary *)wxyjzdhQjxaGj :(nonnull NSArray *)IRKRwAODMTJTfB {
	NSArray *pDyVncCcnmCW = @[
		@"FBVNZBblEEgPphiowMIvJknneQFzGVPjdNYqNztYYkHJgDNYbYLwUJrpoYcBKuiHahCmTGoYRvDadpwyKeZXqDueBGalJFQiNbqCSgyFUwMpzYfnkwPczuJlIaNyIahyVSJNhGYwVjchhc",
		@"WLQCvcqXuQkPclBevMhIgeBmIrOHgFJVtWZxqqbGYaahRlFNytydqHIMCORctjZmxrvqatjCvgKgJRWcJhpBxsvMsixNZpfuGNHNJcEiNRQPUVWxBnoTVXTKXGwkLzTpDXT",
		@"ReMTAwvqAGIysgdGXdzJOnoSxnlrjVBFgjGBEQBFskhwjrxSWPNYVEVOyKeOWXfAivoPJQfpBjkTEYAImFiyMRrJDBvOlnDzLOIgDL",
		@"zCRtUepOgvuElQlSeILlpsnsbIopNRMoygvnKFxiIeAeiPAHLdkWdzIlbvfSdxotJeFCiBqXZYsVYgUjiDIvzxDHHbyaeejCETSthhEcplFCYRDVHMouoJOZy",
		@"XKhkhblsjTYJPyOpYhTQnRPchQFNDkwhsCDhqaIHszyYHUoQsizrPKCRZfrODomatzUwSAGAikikqiaCTASjMKliGOZwxIZlujoXolwuIBUusffomWzxScpvhckIopWeStar",
		@"ERyJWaeXcTMUwMrhyAqRQWaUUdiYVrZezfifwtlULzKNjgwjXjIdcszQLGogFeJBCzsquCYlkvUIsHkNlcLlLmnpWZtGlZzBvZvudIzIELO",
		@"BYlDqCiuRHtdDzcvEqvSsklKfBMZhUAFDsEMmNqtNdyiRtboDkufpDPvumLGsFatFwMqEcZUfMrRoQQiZxiKUYGQNODbBtupVtNcgLmoIfbWkKyuTFfTvuJMGxw",
		@"iMFokiLwFsEjVnZjWdKQqBjkHcpwrVGBAQckXXSibAlFDiNczyVHMgyjdHgXpEgVuzXFnEBVOxRKvqpMiKTqiwSNgrfVbIdGWhHbjVzhIlHCEkAsjQPHJVyLjPcpBiIkeSbZWbB",
		@"FUFBdqUsicZJOtVlHJqmKswLpULGspQXudWOJwqeGlvoMZEbnJwmZWsVQMKjndLgtDRdAvesuhBAbzxLTrgDRubbqMBPKHoexofAW",
		@"MRMdFVLODfoVIuVpMpKDYkErjlZruhyOvJzYxtkvydwLaXfISznmBEbDlCFnHnTkhNKPLrnnahnjnNfsIbAWzvaDFNQqVKNtWnXzuHOJeOEzzIKjawIauPpKVK",
		@"gLKlQhSeBtvifcHpcGDzldZEaXgxxJcOAkYAklolJXlOLjuFcLXNjzfSNhMdzhqkomnkGJjYcOshutnKblmnRzCEiNDBBcoYUnkGUv",
		@"vSwWnNprfxBETuCdRHowadxWSHxVAufFNPaJtbpGWbLAiyqqmniAeaIeHKeXScFgWZLgBOzULEGKHgxPMxsLHuZJKpQTQPQCFRYwngwwomSEtSaDPPFzODsmwCYBZpuhuxjLGecymXRynDMIM",
		@"DTPFtkvWFWJtGQSUrvcYTBsmzZNykfeUQwoeOYAXaUwuZUzQNWCZjoVqszFtQfbefKYqsAGzQtPYmTTFcXLhfotfRVPsyQAiWlaxAbHj",
		@"moeEDJHRNknLZSvJqJTUXAIfiMFXCQHyFQzaISREkFOacjDjqeZujvJbqvWkYcJCbUIdKBbpYGpuefFNnDNUfZhMHzDDMdqxGkXvoCVSp",
		@"RnXGtaHmQEjpqbDrhXnRhCqHLTTMdNcuYsGIbftqGGaOmgHOHHSFYHOVzeDHOSVTfOXcwBuHSQKsTmLgNnuhxrKGxtfuLDHfRMMHCBvQuGEEkZsutJeskfBOtbuhOlugTtiAwypeexkE",
		@"jVOTqkgyNDjSkgovVcsDEllfoiyUJWOhILbyqTNkgTYqJFoqDaGfWsHNBfHQeYOXErfNeBqqgurFASqMXSZOMYmMCYtIyjhGnCMpvJqbJteFVMKubIvtW",
		@"tRrJkvfXacGjYHNIcUKqAtLtmWXEmITmOpTvGtkkKOhUVcrkbdIUiLFXjHdfgorxDqkjkTJFcYzhKmlEtvgOwipzNhBFMmtXFwCGpK",
		@"QbhHgnzUTcUfWgadKqQKlBzSGacHdgEndzeKKWUjFIoShfbvbtemkhJuSowweoUdnlEQBJKugjWFlbdXIVQOqixHeleqffqqkgoAcx",
	];
	return pDyVncCcnmCW;
}

+ (nonnull NSArray *)MuuNuEbYIBWfr :(nonnull NSArray *)JeMiDVvKMwbDq :(nonnull UIImage *)ShybAGuMffxAYB {
	NSArray *PhRxyBdwBvEYuqem = @[
		@"tVBFadLLojsiqyBPYviYdxHkULfUEypkGBFMfSlUpENfPaoPvOylnmhtHjWEcllTZcQunDBygvFfmbBChSRDtKRUEfwzBkvJLOcJkZdbWBdanbqCzXoDrmqS",
		@"EViMSjvCgcHeDYWTtAelltLMGPBKTWueFLmAPIAEckClKkEqoHRRhpEbKKfTSTZUstJHkHXhBtsUnkxeAgywIdoNJxuEReSlBZrusFnNsC",
		@"CBLcoTjUluZGDaCiDxjhahUJRqVkixxWwZMxpJlUPbjzSAfyuSowfxSZJULUhQQsMRWduyHuqOgVGuYTMMrDtVbhehjMWoUSTKDOhbpCQPKQfBiSKvjmrPG",
		@"dGNMtclAEeSDvblbOxOBvoaPAZzrSMbQVJjBdZdsMekATcqQalGgVNSGKNxvkOsftMfpOQBATuNXXBlxcEiIYuwVTccxwucQxKLCrBVxhAjaxpWOgUSlB",
		@"UQbYElOsEIlUFrHIXlxSJTbFUYBqbSBxzhwMySqcEQLgqRvMeoqKrWcvLCwjdjZQzRzVlgrUnIDPRSRrDGtBIiOpqCfjMMuCOMdsQamrBsjyzLCxgoyNgNzDosSuTLJTVAYse",
		@"iXcpqatmqMTAgqUeBwUsdbVNscqaXrdoGMzfnOhnzbDpccBBVVZJZyKKwcevrHyzQlYBdbUHcLKfRDiMYujfIjNZnkUnCmFUYgYLRETRkOTSOEeATMmacbsTSDuD",
		@"ISQabUxzpOGKuIIlVAidYLHwqOKVhAtAjhavGBSBtJFhHVYeGcUWLZkwSgQzhhKCFGObcqMFuTBzvfKtmLoGvqxIfuvDUvnTIgMryhNAKtFaIOlIGOUhnRWXXaxfPleNgGDekydhqAHx",
		@"eZSvsZlYHRZFiPnvewXDpeaDAgtEujSNrCcHcwaeuqWBWUJgKnRpYhXsfqmaQoinQPcwmJcWdWbYLJLqwsKaJlgJmFcnIDKeBFIwXcsInwOEKXWbOhnuBDbDYlyxnNrjbTjTHBPLtnnaebqkswj",
		@"BZIBSLhbMRrUAqyIVUhvsdGHBPoMOPBNZEgKPExSJcoXQlOIiMawJqvcoCZUXcQMpWYGoMmZpjbnmktRbQTmzGzydDdlzmbEXqagzfsJGsWzCKJEwMXMFmzPpOVuQLqOzXlHpdtGgfHFOqBnNYvA",
		@"vUdkwCRryMsWKMSXsZutrdHpHGieIzuWKudSsEiUApOUyqRpyROsGYFATDxrnLkUzMggPXPWoCoBVDluSqZIUeGWOHAzKTifebczNaGPgBWcamceXmYTTJXrtjVXu",
		@"owScyXxJvtBYfqyZmrUxcWfKxHpZlvKPyVQtgfnCDxxkbUOcMZGIZyPbeJOYOhIiMeRhUxWxqbeupTRcurwUUEZUEQdKMSuhiyouad",
		@"lgTKcWxUgmOwHbMoUUhNRtoTvoxegsAgzqcfjWdoIxDGyojexVFEsXxckaOlILatSOEDahDatNbKDJtSUhJZmpInTdkOEgPoAGGsLo",
		@"jyUVQPYxyqhRPuLeyucAaXLhlYknhIqDkpUODWyHSbjrdAknuFiiHeZUGCKzHwykNXxZhGtelsDYurCjnHlZVGPOpJvOYbbKsUvodVPZJGPn",
		@"BpUhThQhnOLrVQBzSwrcLNGupIDnzKSAWfkJbowgzFymQKNLIHLDVpvEzJwwKKcpIADHFbBimuzxFSaUGBoYdGCTCHtOBrERNSzBb",
		@"GjNFKWzOSrNERmcuOKwySKxeoluSQnUdYLEpokgnzxaYztOKkDYBDvWNCqgJKGfeHlMOJNxxXgtxHQuotRqmEXpSPhbHbXtpHfmmzYyG",
		@"vySFEPDjihOcYwdgFCovvFgsVvmIfDbeKGtLDtXydCkTSkedLHKUWaZQnGkAQOTCgOWATUDtObtdYPxlIVvOZIWsCuCTFKkpumslxrnWSc",
		@"mPylySNVpyqHHPwPPZCdSNdcRYiVEMYHEdPwuiUaStaUGijXzkkJsXxkSldENNCPiUBhdOYLkhuKFAIDCNBJmzisTTMVhQvdrCldIFsiSXIRFKpSBVdYZcxozOXp",
		@"ArZtmDHHXwlfRstdyDinUxmtrefvkuprMNZaNwAdiVrRQvgNKlowrdylHzCRTjvUmTlzcyVUTEiXkXxtIVHSQWStCvdofYqFqoKhaknfGilCsnZsehdfnxmmWOYrHGzBvQbgULJFCmnbVkPPjked",
	];
	return PhRxyBdwBvEYuqem;
}

- (nonnull UIImage *)QYOsJILvRb :(nonnull NSData *)lYxYnHhcXtSJoQ :(nonnull NSDictionary *)pXiVXPGfoNgQBtxOVnk :(nonnull NSDictionary *)MWIbFxleSFoncju {
	NSData *XoplbCwPGllLzg = [@"YtJAueAOEzpJXVBnKHFGWWdsolbukeVxuwNIyTJGvWoipLCGXQxRwxFMEpQwYBiXYswUTgpBGBnXUoXrfDNUwYlXFkKDrIECkMppkCqletCBhjZH" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *qBuiqmwFENz = [UIImage imageWithData:XoplbCwPGllLzg];
	qBuiqmwFENz = [UIImage imageNamed:@"oMAyDkZcUJOJdRFsucoqugpylscOCwESNdXDDHOOUaBVSUbwyefsmmphhuvnxbaOilEYZiidlyOtumdRJBiLIRRdsCplRgvyiwWNJCwxHMfoStVWEOIfBpXHOSamwVBYnsHjvCpswFet"];
	return qBuiqmwFENz;
}

+ (nonnull NSString *)gWAVsnNxsnKILjQTej :(nonnull NSArray *)gOXIErLcEmC {
	NSString *NQyKSzJPOHLsvOei = @"nkJCBwuGTFoHhDfYguPUOnjchIZoPslztQaqlxpwSXkziJKQpKQVNETOxYbJuBKptDeFnVdIIVarFHaJFMZoGsZGLsiLhXUNrKhIXSNLsAtSwHdjiBUbfLgpurLTqwVcrhnmDTvLcqkueDOD";
	return NQyKSzJPOHLsvOei;
}

- (nonnull NSArray *)WHTFQAyvSVtabFhXb :(nonnull UIImage *)jAAFztWMGKLlQtKxjT :(nonnull NSArray *)UcmAlxEpOe {
	NSArray *LdqWztYNEvo = @[
		@"pQxlEVjBxFUaYrZhhSASLqoBMacQjOzKUlBMsEqqgWWaOhqFIxOVUkSdajlVHXcQlqusWClOGEnumOKhpXiyflkhTtEWlfHCkpcabKzemhLRlvOSWNJnAiOrYFKEPiNqWaLObsbj",
		@"MfAGOyAhZhVxNwFsFDFIBWXGmJUqYzCMHGJJtmXBElndSdhaUZPfoKhQJVYDvyeYCcrAgLRufNwERttkgCiZjwhclrStBRYQQXiFNitPEiclPPApMJVTkSDZCGqtGtfcNXrqruHaJxfrUMOuM",
		@"HbEaKCDTESjWqMGVlemzXpihzXsaqFgZBIClirdabhyKZoRqPmeeHgObBzAEvlvpdYYWpLiqTkZhFvNTTapsyJEsDsdeZymIMQAl",
		@"hNUghIQogsPwekszzxylXPHSrlujFoFNNVUObMyWZihYcXeYdCufGsdLsMbPyHQuHHgvhtsltBlPicTSfwOftLtLVhKEAdvKTvwaAQoKmRWjwBSnBMsOrmzTg",
		@"ueiOvFpgPEHJgpYVvzoXVJGCRdwnZVCNaHDXBGViINujYBxMPiedRTwrhHFKUOXiVGIRrCUhVvICdEcatBIpkKWkcYcexXCpLFxaCnejmvpLKDRYbmrmgC",
		@"rYBqmFyRxZgCOBhLPMydsyjFKExIqVeqWQmkLcrmEREOOLUdeerRKaWRsGdvXlOPYSDAkkQPBdiWUUdvFZjNeqiuYDOrVxnpoSAOWqeH",
		@"bukQXQoerenOWJkxWvwQKCOGimntoWUwTyiuaxUFeixDAyoZsdUMtqJNAHBTUDiBGOhVwIfDluvIzeeTChszVidXGNsTmjOqmLLGsbPZYahzEZmEwMfWoPJdSrHcELKjSnjztC",
		@"XpgzvxXzjpyjdTfTQUTlOnwFTYkIfuUDkVvvtDEnsbZIvcXPcAwULBdExQhtbpoyJLWvLGbYFjvWrdjyIdeicrlClZbeoRHCNAkdjjCFjEGAKDcwNqDtXlWpwYcsyGjeMmtANl",
		@"KqTbylyKyNZLpJRctEESeNUHreVYcaRiCBNOIpOOLyxzikCNGYjUdDeEwSNjsFUMksSLPpjoKYVvgtEECMPuAUQIPRmcOQuittsKmooggMWRy",
		@"yMHcaVbojYtjrqGebUnuSaxnHntvqOTOMTtmgFSNONYYAOZlSaUbsNPDMFHyyJtcjwFZNIKlBHZIkOzoOYoGvgZLwHjtpdtNmiubDOUyTVGWESht",
		@"GaqcZgKfxDNdFzBfkZHkJEJdldMSOdMLYIoixYcGwWjtoovRDLGQPXwBgwvXcqllvyKIrcHjqXvrGLkWfzhzxhCevKRbkpYjGxMGjrYOcxYejmsauqBQXkGdfZTaAKPSzJy",
		@"NHYnIxcYCMmauCvTYIjeVtOyONQKrmdgpdspzWiTVrfqTCpVDZDfyzuNUyPKYRKQfQBltPnfdgOgKBZVXBInZBISDNphEQWhOLNvECyhLZddYw",
	];
	return LdqWztYNEvo;
}

- (nonnull NSString *)HKfXNsJERdRhNwJHK :(nonnull NSDictionary *)poxiiMVZiHNl :(nonnull NSDictionary *)VuEwxbKUolHP :(nonnull UIImage *)zsYJDaOHpHRSVGuRGyH {
	NSString *eXzWXsDErJvhzV = @"NwcQpsNOauGreahitthrRNhYhJigvmxGYbKEAnscDwhcbzlaEhIwmwiMaPuVycuYAwuBRQdyMJEnRakgnigZkJjZqbiYTnrsWxNyTgDLaiWYQVcnHalNjZK";
	return eXzWXsDErJvhzV;
}

+ (nonnull NSDictionary *)XsJIISkIzZUGKIbW :(nonnull NSData *)aNhFqxITeRI {
	NSDictionary *SREEUGtxEIa = @{
		@"EzoTcilxczYtymEQdTd": @"jnFmYFvGnmWKnyTjYdAtFJAKXpTjjUeCVhTJbwNgEaLYixRYJiskqNPykdCsxukGHehwuuZGzGWyThsPTLpPjiRNeCGarXcqNzklYpgweJfi",
		@"xVPYIpAOvdjhAaJ": @"nzHKzWDUaePgFaCrmGOboTDZJBUnKViukatdHalcvHZWCyCBZWouHzpZQRaALsXIOokCoxuFZuGkzNOOxWTnUbjLioSiqhBSrUGKjAIYXHaMEkYTpDyjKTaKKwllGli",
		@"iIDNPENSKEThVpvRDf": @"umsqoLuCrUolsCbZfXNZkERrpdHEppjyxfZltNfviafmJqYssfdjOVjhEZTMpvVgxYVXuJizfWqCughDEOifHKwSTxpPIceTKYMZHywhvUUltzKNiwuDe",
		@"iGVESSArPd": @"HbeXMNQIauUqkOQiwpnJusMOByCAHSVYGeiKbvDUAqFntxagXQWktqOJPKbIggmFlwKuoOypEzOoTELtJzmSzVTnXIlQujAQyTPkkLDuxGEEPgkMeCfaAEZNrwqszVwZ",
		@"vTrkdWYCffOMQER": @"PTEncEYVsKeUgJvgOFsTeXWUHOBtQSJxArXEYIYgjhWGqPoQhjWjZDXMmdXAQEuyiGtJlJzbUYChSdrxCGxejRlQbvrDWQqpZxWG",
		@"ueLXeVfrSdnW": @"HLOkYaNwdXaQCqOmjrvOhHgmSDplPAsKPWWnhWPHoqVWqQzzKcZLoqjyYEULJybkJiAWqziqKpMVToRYGoHwzpMnrIhIunmLPBayBXfzRdKLtFuxtfqgmTMlZnTYr",
		@"sWpAKDBxMLmYybbzweK": @"XNHfootOvVCxIdXPJTlJZUOcllTJSRJiNjvMTXplPorDQUicyzgFYfiVqUTbcSUSysSBaoDGCSSkVoBiMCMCZkQtOHmzCqbBVZMnrMOkU",
		@"ODqDhbxQcbEyTeDH": @"XVGZjXshxdQNIQhRfeAAWPeKIOgmMgunstwSMtKeUgwrNMkzIpzMZmTVozdARrMDUMkCtMRFfPrPfXPShCCUOZucQzsSswoHRrMhOvU",
		@"pgzFnaLVDFuFylxqdNn": @"ctcjXjwPWERYLlRIBxrezZftrYHoGBLlZstmQDgKmjpnjSroOYrxrvqHVyKjNMuoKXsuZcpHXYujcoFXRgTctVpIYgevMFpMivZmyxgQpLOQyZnNRCRp",
		@"sHkBsqUkooSJlPfpe": @"vaIrrJVQmOyaFfLeiEGLmSlMQqXGQCUoCzkuMSKXdAcVYEyEmSoUEGJfKBCnNBVxEsgNswosxJflfBPEghvgaDipWYpxmMztITedrA",
		@"RDmEyDWRvqBEnZ": @"xWtspjagkemlDEehYsaHOxVzfPTYYjQKqLmhMlGAqdwnwWwkfjXvvMJTxlPXazVTsqaCFanjZfRHlxikYPtVrrjNeofOiQbzHKbRHFW",
	};
	return SREEUGtxEIa;
}

+ (nonnull NSString *)UluAFfERtbcEJGpf :(nonnull NSArray *)aOIxgrtbWWqW :(nonnull NSArray *)RFTkcxwpNMdits {
	NSString *TDkSqjzAHTiUVd = @"TiyKDSBblBykPkpXBYCREXptUZtCFbkFntbqDtEgWdocZWnprUcRRpjEgRTqCpHinaAiVsQiaOGrhFeSTpSAEitouBOBnrafXEAfyqwgKhEbvYDIMgnogzTtsENBFklDblVKUwkPvvGJkxA";
	return TDkSqjzAHTiUVd;
}

+ (nonnull NSDictionary *)uTTIEJIcNxFfnSnwER :(nonnull NSDictionary *)SliCCxlRGXx :(nonnull NSData *)whbgxEmcKzhflpHt :(nonnull NSDictionary *)fYxhlGHEyZEzNMb {
	NSDictionary *sHgdGFUBMGnXOxBVW = @{
		@"lqNsJpjvTN": @"zlkBTcolIThtbimpfXFEJYaaJidLdABVeqYWYeEjpMnlYYPHrLalYyoYxgduuZgbXCrjRTvDnsnCsjRjBUVRYlQLwpievYJTCWApPPSkQtoiBYoIzRQRfyZV",
		@"LXxnAFJTMa": @"OUKmEBBYxnwrtnadPhqmJMRSMbcnsNUAFLrMfjlGzyAthJPQzrWEUqJXjIeOHPRznANZiiQoTMKpcJuFlocILKzEqAuaNzCcRaTqmQPIS",
		@"xIJHJCNFLb": @"QqrSRbMLhCAUFNAVwEDxlDyYpCRcAdhxhQGvHBPGPYiGqsTKBZcORbWrTagmNzXdNqctUxToLafFZvOxnoFwRsvlxYCjBiugRWPGZSVsbuHZkRPXSYcCfznKdLYXrCyOgh",
		@"ZriSziufnKxPeckkBNk": @"WwLqnmVrwFyJBEYJsKVyfnMkbJYRHTUNgcyhkTrpUSSEYPsMrgzCLsDQsVgEeuZTxiLREZrIPGZtZphWpNLKtWLffVaOXXOZZMzVnOmVtTUXUhLihwsSloONvIejLZcpSmbrlkwizcYc",
		@"LOYQtnvWJMqIDx": @"BmXAVwqTeBXcEbkbRItsqCcLFEfgKjPQSNVcgAqpIZhXCjrhrovqMPctBcaxhVDlIJpcGzEYbWdyaiRBpgzDMAboxCTLLeJBYAaM",
		@"jidpEGrrkTHiRJRAST": @"LHcLVRchvZKFLiRpoQOpYONFzLdgRBwfaodpXuSyFwvjehdjqxNeSMtioxmtQPDOSscCikBoTrjdaAfnJzkPCcTSQVBsdXOdhhrnAONuwHREzzPcvAVJSCKbXcGqHfzPkGIpxcepoXvGZhQXZiUU",
		@"ofEZaDckMVNksW": @"vaUpHiPgJLbRWVwsFfabXkqUrpRUNyVphmXWaPuePHhzsrwmuUvQGVlSVTKLTRMlvIQWiFbNuHuLhyXCTNFwEsAtKpgcTCfArGuFQMPujqPmZjnDYJ",
		@"CMJTxJmRsAdKyjE": @"ixollcLncMCQzWINKXPOnsioTLYEhhpktaNwbVnlPGRMNyDlOzYVtqtQsPeARyjcNuUAyeJpKFTDiVNduUlWiRglnbLFsuISSdwLEfughHqgViKEauYpYwlGNGySDdsbjjhBFYgSuwqsLAnf",
		@"iDpHbVBphddqfk": @"TPXUuaNuhHoCSLgVxvdbDcHBskuipWneMDjWcBdqFhzUPmFpWpbhsRPwJMgNeEDoBKvjqadUnjzXHUjWLvzKnOsrCpRRhyAMqSEcvEJHdRopDqEwvCbIDWMylQiTMdaVDla",
		@"pPkUQidObr": @"zoqwhOxRkxdSiTaAmcgjTVHwSQpYifHhPkXNvonCaFJUYcsLKAJYwwkbcqoEKjARTLyWXYlSPbXgAurdOjrsNikCdjgGUUaWsQShtiyxMHWiYMYIldiSBBHGhHCoQIyC",
		@"DaurOHzkuykeIDLhlo": @"lAeNmhUpIFrrKNtCbkJfGnSeqIweqIgifnrhQsRIdUtgSjnaqLjxvyEoOyDrAPtpchGmLcZAzcBHWbRNuQQzDTjqANTgXeoodmKjWznoHXtKg",
		@"zbhndJNZMlrpuuy": @"WXPZuxCzjcYcJYwrZmrMRFQhubyDgpMMFhFzREOgswSUbEEXpHNTqlWeZecwdMyTZbKhHrjXXViklKhcHkKpLayUFYIcPWmmSysEhaAVBdxgeVRMVahuszrbqGlS",
		@"gZIeWMRhcQXgO": @"VxTXPBgvWavmNbuMbuMbxFJyTkXaEsxMQGXFgYmIoGbnuJLCREfTNITojmalkckftlttVPlyKxjIsWJUGQHMVhCnMYnwCPIczZgrkTkHywfxBkelOEmtCwzwEJDGRoArIwD",
		@"EJeIqUIUPfc": @"XseagXhYFeLGXkvdTOOYHXtlDENtRljomUbNKSZzhLenEYgrgIUVAuYHkZRBZsldUUKQTAXuRVtaOPjEhacNfpmnhMJTtcAwsetLyqyGxxboKxAwwLcnuiEhhhZShXvnkrvefPUqFUHLDm",
		@"HKyhRSmVyGyLn": @"CEVzZQBtawffNMauQPKkDcmOIkSRjKPnLpUXBVpypAgVGoAqxLRXqibuqHjgxBJXkHnRfqmwBpszAQPRbYJWbZuZzYyNyIRJrYxgujLXTnKmaYtEuQwkVteRECvYEzxuLAJwoYUxlhZ",
		@"vzSkLHYUKwFTZD": @"UCbturBwvwEIofEHvHADDupMgvyZDwuTeOBGTOKplrsTnQYKcFPuPIeqgQfPCoZDMqJvYjQHYllvPwOxPtElEFgWynSJdlJmDmWONkZZDtvTIhoPDjwGfiYHCJKSF",
		@"eyOYwnsHNDKKNL": @"CZhfqACdpNoBLQMxrsFPYVyTWBwDbctzpmjwgdbeYaxsVYCePhlPdvdoHxYHWDNJOYkCKtImKZwDIMVGBvHvwmYCJRKIspretJVNyUjHpfUdaVYErFrzwjjj",
		@"uIjuGMdlbqYg": @"pLhNdVCYpcNFvwQQdcXkKTXAJxiiSVqvtAHlqEQZTbIwhCKVRcjfNDeioPOuyxAjJbhYEmtOMZubnWZCeOMnEMumInCZpAsRErMNUTzXUZVczMoAgECHgEVecZDyzRqBC",
	};
	return sHgdGFUBMGnXOxBVW;
}

- (nonnull NSArray *)grmXyohzSmS :(nonnull NSString *)TccNjQbgDsQ {
	NSArray *LDIWVWmtoP = @[
		@"YuIujqOLrMOVlZtlUTnRhaLHfvDqHgqFhabhGwTMxzTmEiQmUHrCskfSvUnDPDXNxNSYUtDGxskWczxKabyAgFyCbkevJDoLDvSDUYLQZHReGWFbHNDDhIhnImlZYxXpgJpLYCxPVaravyh",
		@"JCpdhECXmEQpCKrbPSJrFaSFQFWaoZlCXslYdvlFAayOgNuuIYNzHFscYGLuiEKSBpJhtuQNMmppcnjvaqemCdKgdzSSVuSyBfZSZVUNGlgZEXpltxtvHNWIiBZUTYfPw",
		@"WBmZiLwJcHqErlCGZZspIBbJEvQpPGBnZClLcbjflEiLxIGJYaYHdbVVaNSccxaIKKVKSPEmEYUuSKmLJGQWsPQbWlezJbUZSKHrnvWh",
		@"pYnXJQcEWahZneBMKaOYuEYfGHwiXAHlUZSRuHPrVhVhfVvAwRWiVVQPQfOwNFkPgGaiyaCjpZenuBsMfYFRFaOkMceRRDMWZvvezNUsmEjpYdUPfMpPQcRhRESkabLXHhyFxI",
		@"RuZTdFOQZPqwaGdYVnAhqSghllxkLwCWJBqJZofVFZxPMMKUAlSDGuUjgiuwGemstjAjrDUcIUFYfaiIPQbStMcBNcderWJUODrhgMyeJAJqCUNcFUtusjfSPnovxaWKrwxXvaJMpUgg",
		@"QOGHrMqTezHmjCirygQUQfaUPHTVZdvhQkofkmknnWEMdpCzhNxHxxjhrntFIFmIqLujiYvSqbKolsphVjNeqkoODjNmGcgtLrkAojrzeegBbTmTXtKgywVArAqLNfOEyHnDQiedYmoGNNsyfAJlI",
		@"WGRMJzPcjtZmhiCNnYdcOkIUXgZRgoaCliSszhRRvdvMcsQsaxLQCppzytiwRyKRjxpufAFpbyMnWrZUKWYvxLWevJwgKRrcpTrGkuEpOffzgYlMvebvcEujsHMOWycxhcINyVk",
		@"WzyYeqXYqzZxFNghpqhJQMGvbpwzrpgQNQCYJngiJJnBLnFcVZCQzefWSLGnbVDcbeAyrMoTjQbYVGScuZfzMJagNgdeINaCbvZNvwloknLLFlDVGbErnZEGjYKOR",
		@"FFhlddkGtnxiFOwblqqHqluWzHDMmnteMXdJzyfyoPGNAVkccNBmIFtyZBjMcfxxylPHbEIqdAYkCJEgqpTICUsnBCofNKqVFLJmkdGchCozhLrdEAqjbSCzICtgDMbsOnXALhQrjwgJZzduD",
		@"bOOPeGCRzxTNTExrStJLJUwIZDPOIcsPuYRzOorwTDXqQEXatWhDCVXzCzDHoRUWBUpkXjsmbvtetjQXhCJuQFWeVCkSKTHJcImZhTcHfVeagGCBbuM",
		@"AfpQbVeiClUNULwIMedQMImlECQFKrkDuKOHKznpkegDujsKvEVzDbbQUQvuwlNvnYGTDSAOmWAmSvxPlShoHGWWHmmGFovCJKgddcfQPiguiHWCuyfhPSZabaCfIHjHUZhzFOpj",
	];
	return LDIWVWmtoP;
}

+ (nonnull NSDictionary *)VdpEKQTqYrfLXH :(nonnull NSString *)BnFRJZVLat :(nonnull UIImage *)xXGrrwIwwvHDaRLOn :(nonnull NSDictionary *)fiXvpftyguJOJAX {
	NSDictionary *dHeZZRdojsvnlIz = @{
		@"aCAYLYrnZNy": @"NEdGSSzfwwcmDNNmswtPtkILTqVasJhPSjOVQvZvJMlsVpFIQObvWaYCCVxYFiBTOyrgUHFqsxklAcMREyKtsJNZLAsllLItPEFddRhUqUXCSkhLonG",
		@"jwphhzpkqMXL": @"YXDRvjNQUcRuhdHEnbNrTCgUjdxeWFrCcIRDzIzxeMoYxEDGETVmVhlfUZrtvHsZmFgZRdZfTQwjmSmTQyDjKLULsWTomNfrnkKxzFmXACTmBUWzxelOEMnElacnWSVCQhUTFPxOFLMghCivxhP",
		@"FrUFihViEt": @"RKFMDFKSZaRLKBysEAogtCjQLyhLnuEFaGNuJWPElDHwZXxBwYoCLxqDviQriRUQRSJuVlLsAnAmvQdcCgIhzhEtaopsQTHtLjSxYWSCbhaKW",
		@"mFUmTLpTLPTjI": @"vQVMkdKJHoLUGdMfXUfEKyVRrYTcTAPUtihORJRqmEPCEBcNMuBcQBvlxljtfxpAwrNiotAYZLoJCMuJxhRLsqfTYrksyTSzSUJawnIoaHHEXEWGDLiU",
		@"bQPWasKjMjT": @"idgxZiTajvosaYBIyLgNwVodAlsEwQmMsbADDtLqkoQYXxeLEOphALIyqQWideuAWVvOVeVsZYkjtYctWZbOZmpwYgGPyTQhXZzppyVzHKxvfPEzGPInCyJkWCaAsLEIKaXhBnyTgRBhgtbldlfH",
		@"KpLGqSSgKOLFArY": @"IhlSnRocrxcLMWNVcgXaGEVwjfjCYORFwotTFhFWlprLaOSjINgPPXIRYpJZXqRcYtKyhMWIOTpKQKuzmrIqmDtygNBVHxthAoXQlihWEyZFnHCqcwmxGnekdttwrPrHYA",
		@"lstdEmLBjj": @"srGbvfxiDaMhqypOxIPtIrpgpEPYoDHyCIXiIgsVgMzkbtMAXbXxanAYofsQkoKiYcZMJLoRPAnhZtvysBeIzquhOZHwzSVUKEBhDxRuolnRPARLkPoLVJJJOqzHxsBdIGd",
		@"sjmIVfGeoPgkG": @"NagCVAjJNtPspOHvpftmBxDcTVPFDiHSHHnDXdwAtElekzlJsAaoRGbwADfXXHKKpzuADquhcbtzWXZbMPgkRHEFPXvTzaGDgFQAckBMSOpxdakqnBsCPLgirwrmyZGDBoHlHOufZxCvN",
		@"cviIlwbJBtHIShOWTHk": @"LCwxkTtOrNLCHFPpboDIkfLlSgKQbMLFQRXQCzdXwKMuzKQtgCoZNkIQujHMldLVrpuflydoDXImGIeEvluKbJYPMTlFizMcJZWDZrNtPwzlWOkNDhWWKCqtNagtbRDchlbzyI",
		@"HVTChcYHIMAKOoavym": @"gNTPzdyRFGnDagNSXxgXZhoiBFOPkuRVGSirkWSbDTCInBjdHoMVUcCZKdAKUVkoZXxDHtVQkBnbarxoSCPOoNITmbRtJsNWiYMGRK",
		@"ulCuFYMqzkzDUcp": @"ewsDNJtEGBVjxrxczAzEpzQHUgGEAWqWrPtevmvgLKcBARQzXoVzNPYitPITBqAvLAlgPBLSFoxnRZUZxQvNCJvXiNrNwNldvwnnECkXbQVGHfERVwYZP",
		@"SqYLPgZpdtMzNm": @"UdgqozKjwLBgAQZYSRcAYMLBHWwuvSKOXOGEQThkhEiBiHElRqLcLmkuHjqVjHOuKUxNGKKhwzHKKJBDmzGfJNCDmhuZEhSPDEoM",
	};
	return dHeZZRdojsvnlIz;
}

+ (nonnull NSData *)FOVskZXoDgWUxTT :(nonnull NSArray *)jWHDnNvOfe :(nonnull UIImage *)SlkdkaKcNhmr {
	NSData *iplFpxCBKQntS = [@"WfAhQUaAehdjnlgZBrqdnQoztmPITslXbyqNTBfwonGsYggUMQEXJzjBZmUhOOGioOloDDFptwwPcVoTmLiMqusFRuPPQnzEwdsUrqdtktgcrvoOSVV" dataUsingEncoding:NSUTF8StringEncoding];
	return iplFpxCBKQntS;
}

+ (nonnull NSString *)kzvKLKJVBh :(nonnull UIImage *)wzzVcJbDfCl :(nonnull UIImage *)MgbdHBendkXqUolJA :(nonnull NSDictionary *)nBTHldCTKQ {
	NSString *EtTYxXmUGq = @"MqHptHexbUficDbNrPzGIXHRzKInpNPwzMEnBzRuVamnQJCkkcxZmyCjgrHnPnLAQNkwtLtvUeTPzHAKVjZuJrZNfpFQIJSKxWZjfKwTpisnSrftCnwSaVDY";
	return EtTYxXmUGq;
}

- (nonnull UIImage *)XauwzGLlHlpTmKTPiC :(nonnull NSArray *)qxWZpfudLx :(nonnull NSDictionary *)wDjsvXAeAHeCbPwnd :(nonnull NSData *)FeNCqjZFqmoAmtYlsH {
	NSData *TPtPOqYTtswed = [@"aIAQhPqiFpOFmXJLfvKuqwBgCeENEzaauOJHdxVFVROawDJqUvIQFPRTFbgNIhbPtbiVSjQIOcPTNjjjtEZOXlCyVjSWxFaQqlEyLtwRFpgWzZlsHLUUuQHsHuDuRbYSIcT" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *gFcUGfqMwTekONDhpc = [UIImage imageWithData:TPtPOqYTtswed];
	gFcUGfqMwTekONDhpc = [UIImage imageNamed:@"XJkNbYokLolQIFIeWOBlOQsFwtcsezVhqUEzMEHXDtnQchuBQFkqEiTwUemlGprAEQpNowaVimwHPFkqpPOcRQvmyEzcrLPDKAmwwyZPSxxZpqegJtcASFscDgWTRIUyTeCiyAMXCmEVgHfr"];
	return gFcUGfqMwTekONDhpc;
}

+ (nonnull NSArray *)OUrajMlyMSbhDf :(nonnull NSData *)jgReuUUfHzDsJlxWd :(nonnull UIImage *)NIgZEqtpUsfaLy {
	NSArray *UzWKeoaXfsTnPkLrO = @[
		@"lyFaJvgMtYOcmvKRXUHvwDUFfhlIboSbdwJEqVcMiCbeElDaKwkvElqZmdIPANmjMRUPIGxPjZEUtylnhJroZttqvquWuhQtltOqCmVPIlvbDhWWiscWOOpqlyeURUHJDjzTGYi",
		@"arPaLIIYgmiUccOwJWBTQqabWZhHRoVpYiJOHcPjCepKUKVISGqYnDahoWEHhMavwIsaqpgxTTCevmhDttzCJiOQjKMSrLihvenaGOqaXldzQ",
		@"GIJGxjRvuwARHFvDcyQqZUcTgJPPwgTeIHcBtEKxFokOiInUgTAAEmPOnaaVzHqazkSpdBwsoFdzHEnQIcThHPqVzflWXqVwNYuEPrySiuDW",
		@"TfqYyMLmEeRsSEqiWqcxDzyNHEdMxvZUSwVxyHPvNOtFPOrujmOkAJnwjTPKOmfiXXFsXmmSnUjEpXPWfLhPujFCFHotQkXGVFmBwniYOMFLLmDJFrwRFcfsxJAFXhMsXlgDLUFycBOThl",
		@"tNYDYhOlKqSLYOrTsUQsWThAUvOPlQPXLGcMFdlNGLLvpfpXGLyZHlfiuJVuiRHWzVuvliUHZdCedwsYUpSOVCXItNwkQrDsaBgEJIrDhnPzzTMRY",
		@"BvjJSwmKpHhCLhntbKvanwAylAbKVvPoahIVnsDfrlmeXKhmsADEcMtICSuftuwcjAWHPlckYfrlpreyHqWgealiCjAJgZPDQajMpqvYVRDpqzuAIdcAIKRwtZvsTWoGsMVIVzPdbsUNg",
		@"dcKykDcFGvfnFcbtUtPHsZLnlJtDMIyzMIMMNDpjFDJrncJgxFTZBRPBbIEvGDBsXPqPkvWlAZyqSpnVgUKoYUerCcbSNrgRviaehCeJyjTfkFoDNwzlfmDxZVDIQCmgGPmgop",
		@"UBptRZpnZejLMWegemNvfibECqvrfdGKiyFmmcaXdkJhfXSbWPklknetrtoJGyNwmgvmRxjqtsCLRGONoXurEkYnorkTEaIpeEFvcmpsiSjkGmyCUnKhFBJBSIDPWSZQkjkgYksinDjFbTf",
		@"aRJcqHGkcEJUCTUbsYWXWyvGlTxtIKNSdHTLyNjhToGKlNsYfAvUEfHwvsrYxoekbWuNXckGevdvpxENozrqjOhFxWKCUOtFmmAOpepsIX",
		@"vbAeYAPitIKsxonFvWoztFoiVhQjJDxFoHEPLCbIjLOGlRKCvsMzVJHwUELxGlOcvASSyegTrvFPfzuJriyGtpbTeSbEwDZtjVoqqillfUMjKqelrdoZwMzyBceqQgZXBI",
		@"cieyTnpyNBBMoeBTDKKfIirizrxiSFTHkCRytUKCKgEqnPCadDvizUftskGCkVEGbUeFqThwCDsgSktTfOZEFwQNECMpyIHoqAttwuXicLuLCAYUyLCMzBhtkxDMvRDHIdCyBncToeYyvcVjB",
		@"dnzlfZYaofZfGbmVITYuKznAZsyIwkDRAWQompOeebOzjQpUOFcIPpGQxSjzBUlnKrMICCCptOdbmctnbrIAwnyokbqyMwJnuRHvxhMMbRgQmPqhXMxIylZSyywVCjrhZZzsvAKpCByzB",
		@"TgNQOdIsHHwHTKFUyDrJbmvCFXfJrxfNizthWiwMMlDicKKokMGQVjRnoXpefMQjdjsBIrEUyUctmoIXiyNacZeDAjmrZgslkIQUMOEgqiACiHAeiHygRvEmYoUjIGmjbmFOvbCclLmbErDQ",
		@"WUYWBlURtBclEiywABfgNcrrCFogjWzNhgbHzZXvurYTVUKkHRSmIaSTCxhaZrqctBhVXsgMNSggsYgTPgadvSXaMhebEmUJwwlgZIdxhDMjjkbwOYvPTZINzYuLiRLSAiQEgResQVwcrCbCI",
		@"nhfhWBRiVxcPnGPKFSGzOjgvLMqVppveugyAyldthOOvnZbGPVDDYpHvTrEbtxSMuWOpYvqkJhzWvhWGiRxvArlQGUcSwhQhKQNoSWwf",
		@"cajMuSxUijEEqXthXiMelVujhCQLVtlSFmdiDldTRBAbwgtCfpIBQfDVeICMNZKZxiuSoFPpruSeUlEFwkLXGaEnzyEwhoTwRetxD",
	];
	return UzWKeoaXfsTnPkLrO;
}

- (nonnull NSArray *)dJrxrcYpjfMmJQc :(nonnull NSString *)gkLtedGhnxr {
	NSArray *wiwagzgwIeMojv = @[
		@"AaLZvyYPblSbxbCfPilXqagVvzapZGHMhaZtkYwivlXXcqzmyobsrBzXGnnVmZmigmIOvDfBxAGzbCekOlYpqFvhZjzPWTobXkPGgnpYBPnXPnTZZSjRFZVoycxpc",
		@"ehxBgxPrAhQcKlvxXVxUspstJTXKGwIpNSGAkhrDJtWVdXRChExJgcLQALrjpkWvOighbCEEfcBGkGkoMjFWFEWTniBNdiEBUlccOwRobPWOOdqTsdlXAvXpfkMTInDXrqWuPhBDairpHQZWJlYHa",
		@"cDDxdEYEJkphdqwnCcjDYtXNxzrKQgqixAofConZjtrSEInFNRUBuqYzWQqsLFYtdCpOdgkrnqUwmjcRmWHVOUdYPSSeorTYSrNaycHvfsQcOiEayeNvwgSkAnKZmtfKLcTRTW",
		@"UeqbRebelUAOYQmUGdXbMOFHCaTcVtiKEBeGOTddjxPYXsbVJUohaDqIsvFBadNOmvRZyfmxxBoNSxQAQRTyypBTwXsoqrAKwwsQIwQmDbyBzMxTXKDpwUAa",
		@"QYFKdiRQWceLKHOjzNTolKuOZYyiPPRdrclVuSdcXsrzQLgeonnfaFFJIdjmoBwDLZuEhMtpnnYNuRFzolFHqhWsTzUiLhQglqFNjbhJnpbQytYDluHvHNprvSmFBOJMDJjmpSJpAEdVnzhKGR",
		@"CxodUGCsdwBIfKNVJFaunlBoeCeqwriPaGGKenuuCIqQFrAiltyuoCCRxsqpiDHIWryobczzAuVaajaLVUCfRfnFrGpnkUofQgbHIKomsLTxKSEcwXWHNFFiollzdielsALjRtWsYRRxIFWroZYx",
		@"cOTAwKCerERpSRCPVgZkJThNaiXgcefHFDJolYbDcbIQbFlZQAJbMlXjZtPMLvhbaUEiAjAaAgjfHwkNeICZTMyLeRCWwptMDkpbpANqOHLrfGPhvBHAB",
		@"IeGpaEFYMaiigINTEYCGjfwrVEjOfrJPUeJToKPXoiZzzMSQpATLrTZYPXshfYJLsQnbtiapwiPWjXjHoHXSXIYqGzmIrcAxldidyhpxCteFwgPutUtFkZZUgTjHLE",
		@"yMwIkOPZsGaDaOCoIXKMDSQEFljfiJoNYCVXdVmfFUZtJpJbtiDwCKguBOUiaCVCzHJQFootIpknrmMIryNyzUaqBkUdHGEQkipNdxZhiICNwUFuXYFF",
		@"CVCQUXisQZncGRtpQAwCpGXlMeCZFMQMEdVfeimlktummzYNibRhvcgFwuiBcdsEQQrDAYNLkeRAgIfExRHYawuPEhywLPwWRbPUy",
		@"FtQJdBpNpqQRQfrmQQHjqWMEsQnJSYnTeGRYBvOCQiDwnzuGBnwHLCWwFrAFJGyhXRFUcxuMomvVvQIBCEUvuXYAkwRJOHSjSMFZPXYnsKQiGUqBToCLLPEwLumUXjWUfeKTLolcugrcXuZkl",
		@"axYfYEcTJkztQZwSeEewLVBRYAoUqSWqQSVBoVKEEQWTfkoyRRzEKXzorrmULJPJgdgsOWYoRzfrYyJpjGTkugtnRRleiRddSmtdMYYGZXRmedZPrDbDZIrAFEHbyGpNhMOiwlQkkPAhrGCP",
		@"rtJrjIAlLnsYOJAYGNNNIrzpgJghNZXcPScWcPgxqyngLNjgSimkGFnzNjPFVcmhKHcojSJCDBvzPXByNIObRYMIsojKXfgOkgJdBSnRuPonUcXhFNyYiGNtuLkKbmYg",
		@"vbEZPtpbcSsXrkCKtzieIyCVMzPSDBJPEVUfZwEMWXEFZOhckqcjNlaBJjiasdJoicwJkNnIpwXxcYADVqkBaKpOJFlzpdzXSNpMedJoxkyjkvLYNxpEn",
	];
	return wiwagzgwIeMojv;
}

- (nonnull NSArray *)BtnNekxRixo :(nonnull NSString *)NRPuxzEfLai {
	NSArray *rOxpFUkety = @[
		@"zfYGGuMiGHBPiXKejdCTYGDtrTeicNrLUUfCJmOSGGzchXexaoDDqHEEkhMjaDyFKjDzUtbxGpyYTlVbQuaSLWCHeQWHvpuLeSfJXkbfpCZTHujCxqwdjcuITTDAcWn",
		@"haiyAZZmNBVfsQNuqgFEtEhGVnNOkshokQyHUeqcThiSdsOmZaPYWdyeqfCnHTpSLAnJVCVTtBKOElycCBqZYavRwJYemUzDpYWbKgWiKj",
		@"HrxqwqFZCojfmUBRABCAlSfRIhZtUyEmYXxlgygNDPhFdoOFcftAGWCJRstDhHooCuvHtpdOTZuDuNcbWITIkifJUcKXpckbJZsoP",
		@"cSAFxKmrzEivNWWQlHZjFCziorDYUyFzPHJZVRRShQjKdiRtuUvnZgbyjsqlzvDUDRAXWcMKlnztJEllMtPtxcDopIfbCavwvtdjjMx",
		@"WafTqBwByYmKwLCgesxPPtPTYEpEPzMafsYPAYlwDrxCAqlcCDfDkCvYIBqDZyOslJjQEswrcsIOuBWCQfCdaCrHzNimSUzCbMRjxHYlRsdRtLeDixpWyURBUzSvtiPEEttrPqXkZK",
		@"pNvkCcYjfiQXaOTRcABiUtZVmPdnJkXIrjaFKIZzIQIvYXyHLKdEKebuOHIzBHbLTxXNiUXcvosfYqaRsDnAoASaILlkRMtBraBkaWERLkuHDHPjYGPUTgg",
		@"kwhoskLbcQHYNFkIFDIzTJxMxSCrZIYuZHsYcZUhfFpyBbHNVVKBTcgnqaPVruLNCAfcFTVkkLKhCuKlgGagqZpcfKdBweXyItIYwQJVeOYGkFPgLjFKDhCzVdRIiyixkuALjpzZoVfMR",
		@"NsDimxfvLVcleuIgOlrFdWnFUAHvWbDrxkEVvOMXexhCBwBIhzXvQiDSkyRxMJeUZaPhlWxGZXQfgGjFoNKDHuYkCaxLsHAHiGPSBlqaCRjiVnNVOGrQldgvLrGvfpTFr",
		@"NFQVYwETCYloblxjTOwAMZZUiPkeyrmShAFTYsfaWQqnayPpkzHVTFaEejTBdmrsLDGVPVjhpZqFUUeuKrQdjFGBxHGrhalaZktrdIPjzJycDbAeNUGNR",
		@"PuEwatIKxWLjQQMVZHxwesJivktqzgQxiRFjdYAGcsUCKuFRRcrdzkZXFSkxbFPnVzVmRLAXUYzHACpApcJdEMuDjqgKHltShqDMihhYjpjCwJnvTzFPyZlewqBq",
		@"zfZTxWSEUTqDbLCowoCmxnLQlfeQiYDnHkMnxZlHehHxCHHtOWhObrcThCITwonFNMZFYewEsNhKiGaTtFjkGqbEvdUefDPUeJtibLtifNSdkoupAkflWuSWWxnTmXyCRFBROSe",
		@"IbnNbkxWWyRZwYaUNyKebMTycQXWUBVXjCnzCRFYnubZwOLOCdpkJcshcdydYCwOfupsExcLgLBbvevnoAevVLClXMTaycHREDoEBELKHrDLjCcXJgYxqncqzlkHhPMAxsZDFfAGfNczGqsUe",
		@"KNkwMvsORPeXKNyMxBvmfbwGXBqvfytXIydlRbzBYGHnTntozzsNoHNkMrehUCWVADJKyoLbSgobpmZJSzyBSbbpqLAreWJfJKklfdvHXZsqoBlvLA",
		@"rELiSmLfOBcRtRFKzudrpoMmBFITcgYrrDARtzQguoJIJJDUIbUhbqEPsxTDDBhRXzaySYNBioEtKkEHlsLhJkpYrXVMfPlSEVDHSuKMzFfanZovBBUNRgfDrYkKiBmFEEkwmKccDV",
		@"JatlsPNudILFweSqTwuHpIsTpUBbkVJxChCudsQyEXHxjLbMOWLztpqGQAbdcZVkLkdZYDoDalkSOHrLgAVtYlKgZWSmaERCvTOyhVpyBxhZAYWwqWiXpcFqQqsc",
		@"ULOQsxbeZRMzgbFCSZMFXtUoPuJVsIdVeltpZwnRMEkmfcdWIlfRnUmfAGVLJzvIUFLdVATlocUGrJfpXOUMpSAPUOLhCCQlNyAenPiWF",
		@"lsEfsREockhUZnUAaMjhyYsqKyirIkwhJmaWUVDqrfXziyfBhivzVoqfJUFOrqsTjzuReLmhqlsLuSehxzCWGlqkcYMpyVdRgnseungCwuMfWSMZjPnSlZfoPIo",
		@"sBhXGVbqkJNHdIHLgVJzhthlfbmzEGokbnOxLeKuKFAuutYPOEJsmzXfwIDYsjuZAAvEqWfbvjguDErRSZUDgyPJReUDsHYrCvGRcpQwIuJKQrsmv",
	];
	return rOxpFUkety;
}

+ (nonnull NSDictionary *)BpEtleSzXSZRZZg :(nonnull NSString *)keCztphXGZHpdLzf {
	NSDictionary *dyqmoYqYKQHGr = @{
		@"wJjhgTAJrBeIiinFDI": @"mZWDfYAcTThSClaVIxBfjtNjSpSqcrSMxJkGzrgJLDPopvsWjBSUTaAKYvBIOlccFqkVCYHEztlpAbftAzvkKLoVHPJdvVNKWMrS",
		@"GhwQQEuahI": @"YqBzyxNCZxMANFcUfZPtOjwgrUWoUCFQSTlXbrSPugHraMtnvcABPohbcccJfXgIPNAGeDacnwVQEJpljWDuyEFpjutQsZvgOIpXFLeduDUIeJxVBCpUzQDroPiKRTkBaRoYWUuNALwte",
		@"CKRElEZEwehpLLn": @"NDVHpAnwXIEhUVnFwiiOSgcrPStygTVOBdRNUMCGVBRRlTcVKkLgUuBEZjYIemwkfzmEerDCDCUlDzEtsJWBOdTVxEprXJMrysIyZeUqz",
		@"zosEmRIwgF": @"NfrzvKYWSAIjHoUXbWVuDZYnSFZElwHBDUrjxhOMHRKFapLeGSetFmEVYMjqxBFBrJlGYwTsXlvJEfWBBtnaGgeFWYxPTkFcMpjGUnauphtMqzvQewexguBzyJbNopzKvJtFOiFAzNafgqprU",
		@"ovyGGRQHURKWYKv": @"UHSslnlmQCLEhjbnpPUXOtoYmsIpQxRjrvOSgDsCaiazUwzMVUcSSpotERiblkUCUcQYwTbRYltLMSrKpOLnpDZFbXqTKlGHugcBuDIfVNkYhlglVAnveoRkeThlTlD",
		@"DvfDdkruOIYAgwwD": @"KOnVRhvJDlpyBJrPTuGaBZcEkCLzAtJOOKofziyaxxKCKIkHuXcKuFEwjLpkraUZvccqmzqBDFMRZTpmLDAZwFfjNzhNeQWVufxhXvoXjFW",
		@"NjsfsIsvyCUSAWg": @"JtrTqkmtaPslxGVXVPMCklvCSshWATmJEyGJxYunznwnzyKhgbQXnJKNSIrvpqloshFFbwvEifNlivdKdSmQDQNOipGDpYQmCOYUqAefsLkfPKfDIoclaIaQyDSDOd",
		@"TnysqhcJiuz": @"vaWegbknQvZFhAmChKyJZIFSXoAKYVxnVhRLhBpdtQTLmxInLIoiSvureNZYYpfkjzNWPUbMEBIBQUWtPTYFspbaDhujjaePPqlNpAZqWrtnceCPOoCmocKqbiaUjrzSOsdiIQhionwDARg",
		@"ElgnOvpkkzOWDVpCMG": @"GHBeOhiHpcIjsmzKbjqnedkSAIvtdFZTTfMgThTQtfBdTAjbtjVMxgaqEYxredBYgTJRgdIqjrZVwzQXkcLDjEppUAqtuzZmRQNrAejhtcJfuptOfYqRWlarCuYTKDX",
		@"uysndaBqhSQrLxFylqE": @"KDBLpEGdkybOvjTSXZRWPihMqcKiKGatdoILiDBQECaYlShtzIexUGfWvLRhWHrQrZOhzneFmFzPJeCHTXILbinIeYovVcHprDAUTWqYrnE",
		@"OvUOhgbgETVLaDyio": @"cBrnAsKiOxGUnSAUDELoYVMmcAkQijyofDyjeOsqvbNUoJKrPWsdpGZuLQrWmPdrRiQwDHzJhTPZxdWrIpOjFKtxegDmDYCSatSvQpQNPATmNIKAVUwfUzpovHPhBUCBStNcOLUmYBjuhtz",
		@"uWcdKQYfQGwHAoccH": @"LJsWJJXvUvRlTXKmbnLcusGGtBeVLrYhynthpaxjwBNbuBlMnqGzEAhUkaEhHhxaKdJIGZPSpgYoESNamuQWvJMGwJJvuUPFxazCrdnzKOpJciTv",
		@"ujprNkrqYWCyinQBp": @"hvDquwWeLAyaGuIgHJZCjSZxskHvhnKXmmBcGTOstdpWFHLaXoOuyRwqnbKmLRQQVhwscVjQroCaUjmNQxwiceCnhAvwEAIQwPlKZNVnEmHrJz",
		@"WuTpHqmkxgZNiS": @"inunPJQxprmGArltPHSNQuqhVtxPZeyTLEcrqKpaVYxXjHMvvcOqUhrQMHBiGwPWkleSiNKIHuwUVtHoCttBWcMkgHlWiDSoQMRPrrTRcaFefLUtnICRpFnwBSiqONcplHmNugF",
		@"DVoSLddTUUrLHQgLj": @"xEllIaNoNlpoFgHQhJBtSQRAKBVOHSQxFRKBaXBfqeoGxBEinRVclEPtTAmMPfWzZOlUHqFlrSZNRIwjVendpLQzLvHykVsDkSpDMDJFZtzQFHYTLjNiZXfrCI",
		@"GqDoEIcTTuEtXCR": @"dpXwKsgrhWjIDWeJBVXBFLEcGsjIewbWhgfnxakaIPYZAWdyghVrxtiqMRIAfsuvcRZTKKcHfaaIxBXQrIosCiFdtUTEoDgEqkVmdhHjcdAKxUyxzPTanCaGAvkQKiquYfCSUUNyoyyrSqJdjU",
		@"rxUurPUWMzM": @"XHhvVlJngIgnVyihbiMujrPKKkfHtpOvkfJFQslQIpdhDNJRJflzKRHhVeEmWOuwhTkHdWZaRXjEHPUZclqwiiYeIFnhDxevifESv",
		@"cDCPxkxMkICKAVtou": @"kuONFMRvPLFewSxdAoAgcQSFDKOPaNevSyutCjtGniFtXXITzQpWsnMdjCGOmnKjpLNIQskwLtVyokKCgaWPVKybzRdaTCCRXQhDCTKfbbSPQauTvOMUjaPNFVrUBkGdbnKcBgBQMpmwfP",
		@"dVGDSLXHVBoXT": @"MsSXpMzSeePdaQrHwEGDGjHDyuVhBzgZfsovYuwrTBRGLZXRuuMxyzFkvDZwiwqaFiiuuYzHhRInFpgfOebRErqZFGALoNzSthlFWOLkNXvkgyFkGNVNoYHzwmgIUbSVPxjDGUScUhsit",
	};
	return dyqmoYqYKQHGr;
}

- (nonnull NSDictionary *)kbeNiArFgEwmoQoDYNb :(nonnull UIImage *)RsuuqmmLpGGGWnN :(nonnull NSDictionary *)koUHueXZaWyhEQSvni {
	NSDictionary *iavNFNZJWA = @{
		@"wXjuopsclJeNmzqScJi": @"IvLAdSVbbarWdUFAJKcOoKfvanDKNvsFerourWgBTQqmonGQJiRUovIilsPoQofeiHKRhYSnAeTpwilTmgSgUdgzRoKitybidFMSRqMrL",
		@"TFFqaSfTGnpzuyUrU": @"amwSXTIKVKbNKEXRuBIPicmjcqyMglbuUoWqfdUNLiSDTQVbbIDlwpXVyWMzkuCMVUgRcuJCblUGGwiGwelyiLCBCkwlCfxAkyARDWMtMkJptprjkCJXEAYKwpKQcUHDaKCQRcDFXn",
		@"yPremTsMmLLwtwfD": @"hnHIHHokmfdRpKHcDhHlhbhUZOEwqmgcAqvGREDNZZWZhqrPBnhPbIbGNhabooCwZGdauKjatfxxMqqpmZPUCztJxxVZxYdTeQZdPtlPrqIOPTcCLoXQpGtwQBxLkwymdh",
		@"WHNByCbwccWmVe": @"WuzTzBcBenYPLDMCvqQochbmxtbJYMSsdDqQRKSYwyHxdnQTqerKpNYMbyaVrggrAvfvgoLyqXdyTtijiksFkdBscpSqdAqNlMkSmSgKsdZwTBcjXBjrQpKmbLbs",
		@"KXukHasEeSqwdKc": @"CjicspncdgmMBqxbDvPeXHZnXNTFDvGvDbVoYNUFRVSpVPZWjmfqoNclhdPSeZQQBnGlxwYtXlzLMqJlutsbjxcxcWgGupkBzwejOiuIUVHeWdgHRbyGNtqAJMAdOmVMAxStov",
		@"tdsLokoJQgwRKkYyFM": @"LNUAKwzmJwnrCOCTllCejXQQxMtXaCCaIVWRXrTixRPviuwYuIMyoFDQaNWwmJwCnKOMZnWbAXdAAJtaKPQuFtgDcokIOpBpUSvJHrMfJGpTCw",
		@"oxiKXMRpnPnUjAttZcN": @"jgEmOfaXJxzHwkSfVtvWLgRbytDTkxntlgWcbuefgDvIYfVJWTJTXISAdOSPgyQghDDotvdkwnASiGSKuQrNiHUYJIMOiDbYvJKmjGVXiSWYjkQaUVDPRlnFKsfHUJNCVdy",
		@"ZzCUNwLiLi": @"kcZNSensOwqtLWbHSvEPjTXiPMPNjdqWEdMgkqIbbcjUYYMIyXJglptukPgBONsJqbGRusCmiJoFRlfPmJldEBDwFEqxTMQyAYhbSNUgoRLlcNPKozE",
		@"gUvNlXoVFHGsXHeX": @"YdJDOXameJtwuCamrYPBXNpPIjMQVmsxXtmeNLiVlHuXWzLkNFtRkOLEGvDcFiBivkdXboHYouDISjtGSVIceNWYiAAXjOvXiJfjIuvBojOVzvcDvglvxMFfjdgxvnRyYMPC",
		@"ZVqsPOtlBkbtlbooaP": @"SgGxBGXWvFDNLUOsgPvWNZVzFkSdUzUlmHEUcmJnICRnWaTmRiJXgHxsUgsIWSUgNvXsvSkrtDgaleBdtSArxjlnCFVXJaYUuggtvGWeESLwtZIK",
		@"MbHyyoUyGjCO": @"SsbDZmWPIYuKpvizHgUKZdwRzJpeyRNMuOiUNRfvriJcyxoIZZvotJqnHAHJdfRtlYVTuYyXxKBOOiRdMBBNomnmwcLgZHJvJapMjzoCkxRgdmUYmvd",
		@"bTBmjKJyalKy": @"CBSKdLkoQmIwGkkJwmcelesDfdhYeRcQdhjRXyfVvSBHCZVseTwgaQvksrIcoLTlArnUNgWsEzNmdYPtcIfxugifymJRNkIXXSXJCmZlPQjeLdJWFskyYWbOByBWCzuSMjcbgyxBuFYuIIZzV",
		@"WcrOwMypxkgTljZdu": @"hhPmJGLRvwyVRAuePQeTVylFWewBcfgfAXqJnnGXtdNTTgHDpiNrAELFVcQKqHEmnirTCaYLPtoEXepnPToOPloisAYZxLIFwkxIAUGLKCFGkSQqVIkIMsXOQsDIFVVixSbbOIKjdYolKI",
	};
	return iavNFNZJWA;
}

- (double)doubleForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(double, doubleForColumnIndex);
}

- (NSData*)dataForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSData *, dataForColumnIndex);
}

- (NSDate*)dateForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSDate *, dateForColumnIndex);
}


- (BOOL)tableExists:(NSString*)tableName {
    
    tableName = [tableName lowercaseString];
    
    FMResultSet *rs = [self executeQuery:@"select [sql] from sqlite_master where [type] = 'table' and lower(name) = ?", tableName];
    
    //if at least one next exists, table exists
    BOOL returnBool = [rs next];
    
    //close and free object
    [rs close];
    
    return returnBool;
}

/*
 get table with list of tables: result colums: type[STRING], name[STRING],tbl_name[STRING],rootpage[INTEGER],sql[STRING]
 check if table exist in database  (patch from OZLB)
*/
- (FMResultSet*)getSchema {
    
    //result colums: type[STRING], name[STRING],tbl_name[STRING],rootpage[INTEGER],sql[STRING]
    FMResultSet *rs = [self executeQuery:@"SELECT type, name, tbl_name, rootpage, sql FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type != 'meta' AND name NOT LIKE 'sqlite_%' ORDER BY tbl_name, type DESC, name"];
    
    return rs;
}

/* 
 get table schema: result colums: cid[INTEGER], name,type [STRING], notnull[INTEGER], dflt_value[],pk[INTEGER]
*/
- (FMResultSet*)getTableSchema:(NSString*)tableName {
    
    //result colums: cid[INTEGER], name,type [STRING], notnull[INTEGER], dflt_value[],pk[INTEGER]
    FMResultSet *rs = [self executeQuery:[NSString stringWithFormat: @"pragma table_info('%@')", tableName]];
    
    return rs;
}

- (BOOL)columnExists:(NSString*)columnName inTableWithName:(NSString*)tableName {
    
    BOOL returnBool = NO;
    
    tableName  = [tableName lowercaseString];
    columnName = [columnName lowercaseString];
    
    FMResultSet *rs = [self getTableSchema:tableName];
    
    //check if column is present in table schema
    while ([rs next]) {
        if ([[[rs stringForColumn:@"name"] lowercaseString] isEqualToString:columnName]) {
            returnBool = YES;
            break;
        }
    }
    
    //If this is not done FMDatabase instance stays out of pool
    [rs close];
    
    return returnBool;
}


#if SQLITE_VERSION_NUMBER >= 3007017

- (uint32_t)applicationID {
    
    uint32_t r = 0;
    
    FMResultSet *rs = [self executeQuery:@"pragma application_id"];
    
    if ([rs next]) {
        r = (uint32_t)[rs longLongIntForColumnIndex:0];
    }
    
    [rs close];
    
    return r;
}

- (void)setApplicationID:(uint32_t)appID {
    NSString *query = [NSString stringWithFormat:@"pragma application_id=%d", appID];
    FMResultSet *rs = [self executeQuery:query];
    [rs next];
    [rs close];
}


#if TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSString*)applicationIDString {
    NSString *s = NSFileTypeForHFSTypeCode([self applicationID]);
    
    assert([s length] == 6);
    
    s = [s substringWithRange:NSMakeRange(1, 4)];
    
    
    return s;
    
}

- (void)setApplicationIDString:(NSString*)s {
    
    if ([s length] != 4) {
        NSLog(@"setApplicationIDString: string passed is not exactly 4 chars long. (was %ld)", [s length]);
    }
    
    [self setApplicationID:NSHFSTypeCodeFromFileType([NSString stringWithFormat:@"'%@'", s])];
}


#endif

#endif

- (uint32_t)userVersion {
    uint32_t r = 0;
    
    FMResultSet *rs = [self executeQuery:@"pragma user_version"];
    
    if ([rs next]) {
        r = (uint32_t)[rs longLongIntForColumnIndex:0];
    }
    
    [rs close];
    return r;
}

- (void)setUserVersion:(uint32_t)version {
    NSString *query = [NSString stringWithFormat:@"pragma user_version = %d", version];
    FMResultSet *rs = [self executeQuery:query];
    [rs next];
    [rs close];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName __attribute__ ((deprecated)) {
    return [self columnExists:columnName inTableWithName:tableName];
}

#pragma clang diagnostic pop


- (BOOL)validateSQL:(NSString*)sql error:(NSError**)error {
    sqlite3_stmt *pStmt = NULL;
    BOOL validationSucceeded = YES;
    
    int rc = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &pStmt, 0);
    if (rc != SQLITE_OK) {
        validationSucceeded = NO;
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:[self lastErrorCode]
                                     userInfo:[NSDictionary dictionaryWithObject:[self lastErrorMessage]
                                                                          forKey:NSLocalizedDescriptionKey]];
        }
    }
    
    sqlite3_finalize(pStmt);
    
    return validationSucceeded;
}

@end
