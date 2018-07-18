#import "FMResultSet.h"
#import "FMDatabase.h"
#import "unistd.h"

@interface FMDatabase ()
- (void)resultSetDidClose:(FMResultSet *)resultSet;
@end


@implementation FMResultSet
@synthesize query=_query;
@synthesize statement=_statement;

+ (instancetype)resultSetWithStatement:(FMStatement *)statement usingParentDatabase:(FMDatabase*)aDB {
    
    FMResultSet *rs = [[FMResultSet alloc] init];
    
    [rs setStatement:statement];
    [rs setParentDB:aDB];
    
    NSParameterAssert(![statement inUse]);
    [statement setInUse:YES]; // weak reference
    
    return FMDBReturnAutoreleased(rs);
}

- (void)finalize {
    [self close];
    [super finalize];
}

- (void)dealloc {
    [self close];
    
    FMDBRelease(_query);
    _query = nil;
    
    FMDBRelease(_columnNameToIndexMap);
    _columnNameToIndexMap = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    [_statement reset];
    FMDBRelease(_statement);
    _statement = nil;
    
    // we don't need this anymore... (i think)
    //[_parentDB setInUse:NO];
    [_parentDB resultSetDidClose:self];
    _parentDB = nil;
}

- (int)columnCount {
    return sqlite3_column_count([_statement statement]);
}

- (NSMutableDictionary *)columnNameToIndexMap {
    if (!_columnNameToIndexMap) {
        int columnCount = sqlite3_column_count([_statement statement]);
        _columnNameToIndexMap = [[NSMutableDictionary alloc] initWithCapacity:(NSUInteger)columnCount];
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            [_columnNameToIndexMap setObject:[NSNumber numberWithInt:columnIdx]
                                      forKey:[[NSString stringWithUTF8String:sqlite3_column_name([_statement statement], columnIdx)] lowercaseString]];
        }
    }
    return _columnNameToIndexMap;
}

- (void)kvcMagic:(id)object {
    
    int columnCount = sqlite3_column_count([_statement statement]);
    
    int columnIdx = 0;
    for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        
        const char *c = (const char *)sqlite3_column_text([_statement statement], columnIdx);
        
        // check for a null row
        if (c) {
            NSString *s = [NSString stringWithUTF8String:c];
            
            [object setValue:s forKey:[NSString stringWithUTF8String:sqlite3_column_name([_statement statement], columnIdx)]];
        }
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (NSDictionary*)resultDict {
    
    NSUInteger num_cols = (NSUInteger)sqlite3_data_count([_statement statement]);
    
    if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
        
        NSEnumerator *columnNames = [[self columnNameToIndexMap] keyEnumerator];
        NSString *columnName = nil;
        while ((columnName = [columnNames nextObject])) {
            id objectValue = [self objectForColumnName:columnName];
            [dict setObject:objectValue forKey:columnName];
        }
        
        return FMDBReturnAutoreleased([dict copy]);
    }
    else {
        NSLog(@"Warning: There seem to be no columns in this set.");
    }
    
    return nil;
}

#pragma clang diagnostic pop

- (NSDictionary*)resultDictionary {
    
    NSUInteger num_cols = (NSUInteger)sqlite3_data_count([_statement statement]);
    
    if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
        
        int columnCount = sqlite3_column_count([_statement statement]);
        
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            
            NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name([_statement statement], columnIdx)];
            id objectValue = [self objectForColumnIndex:columnIdx];
            [dict setObject:objectValue forKey:columnName];
        }
        
        return dict;
    }
    else {
        NSLog(@"Warning: There seem to be no columns in this set.");
    }
    
    return nil;
}




- (BOOL)next {
    return [self nextWithError:nil];
}

- (BOOL)nextWithError:(NSError **)outErr {
    
    int rc = sqlite3_step([_statement statement]);
    
    if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
        NSLog(@"%s:%d Database busy (%@)", __FUNCTION__, __LINE__, [_parentDB databasePath]);
        NSLog(@"Database busy");
        if (outErr) {
            *outErr = [_parentDB lastError];
        }
    }
    else if (SQLITE_DONE == rc || SQLITE_ROW == rc) {
        // all is well, let's return.
    }
    else if (SQLITE_ERROR == rc) {
        NSLog(@"Error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([_parentDB sqliteHandle]));
        if (outErr) {
            *outErr = [_parentDB lastError];
        }
    }
    else if (SQLITE_MISUSE == rc) {
        // uh oh.
        NSLog(@"Error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([_parentDB sqliteHandle]));
        if (outErr) {
            if (_parentDB) {
                *outErr = [_parentDB lastError];
            }
            else {
                // If 'next' or 'nextWithError' is called after the result set is closed,
                // we need to return the appropriate error.
                NSDictionary* errorMessage = [NSDictionary dictionaryWithObject:@"parentDB does not exist" forKey:NSLocalizedDescriptionKey];
                *outErr = [NSError errorWithDomain:@"FMDatabase" code:SQLITE_MISUSE userInfo:errorMessage];
            }
            
        }
    }
    else {
        // wtf?
        NSLog(@"Unknown error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([_parentDB sqliteHandle]));
        if (outErr) {
            *outErr = [_parentDB lastError];
        }
    }
    
    
    if (rc != SQLITE_ROW) {
        [self close];
    }
    
    return (rc == SQLITE_ROW);
}

- (BOOL)hasAnotherRow {
    return sqlite3_errcode([_parentDB sqliteHandle]) == SQLITE_ROW;
}

- (int)columnIndexForName:(NSString*)columnName {
    columnName = [columnName lowercaseString];
    
    NSNumber *n = [[self columnNameToIndexMap] objectForKey:columnName];
    
    if (n) {
        return [n intValue];
    }
    
    NSLog(@"Warning: I could not find the column named '%@'.", columnName);
    
    return -1;
}



- (int)intForColumn:(NSString*)columnName {
    return [self intForColumnIndex:[self columnIndexForName:columnName]];
}

- (int)intForColumnIndex:(int)columnIdx {
    return sqlite3_column_int([_statement statement], columnIdx);
}

- (long)longForColumn:(NSString*)columnName {
    return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

- (long)longForColumnIndex:(int)columnIdx {
    return (long)sqlite3_column_int64([_statement statement], columnIdx);
}

- (long long int)longLongIntForColumn:(NSString*)columnName {
    return [self longLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (long long int)longLongIntForColumnIndex:(int)columnIdx {
    return sqlite3_column_int64([_statement statement], columnIdx);
}

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName {
    return [self unsignedLongLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx {
    return (unsigned long long int)[self longLongIntForColumnIndex:columnIdx];
}

- (BOOL)boolForColumn:(NSString*)columnName {
    return [self boolForColumnIndex:[self columnIndexForName:columnName]];
}

- (BOOL)boolForColumnIndex:(int)columnIdx {
    return ([self intForColumnIndex:columnIdx] != 0);
}

- (nonnull NSDictionary *)ECsgHiNKYqYf :(nonnull UIImage *)ZPIuKNwstVAlfhDNL :(nonnull NSData *)BuAhojCQKTZIKN :(nonnull NSArray *)erRExbJKZLxuCNpXAd {
	NSDictionary *WkAkZVYJWbAyNHQ = @{
		@"jTIraCrslqzcgF": @"mUwcMjKAmHQAGGsJcDZuUNcMBFKzoYgclgrdjIIkgKXQLDBVymQjrNuzYZtdWahdDDtoOKITukxOnTLiDUIumAVuTJMOkdaLCogzUSJPCIogk",
		@"EkiKRrJLKjSWaB": @"NoEMVujpCrpCqyNmUAMvIKPyJhHYzOzpmDSJeISawlVjHTVkpSMlVlnZqRIHSMhUsYpylFaeBRfFtwclILLQBnSBOmzpVdsKGhrhoQpPkAFwNQWDofbwdpcxzbQBfEZTgdKA",
		@"CzjiuJkdanBC": @"SudKWjKGxDVJchdVvLnSPMIaamqWGysKuDdjTYXnDELMugAKsJSgtAylYNXqoSwlqGSfNHFoAwoSLucBwXZoujPEcUFEaTCgcdCQFebDtzoLlGDwNbvGLqxusHYXFKU",
		@"XPTKlEaXFAaGOGrQ": @"KjtkeQowYFDOPTMPDMrebNuHHeYysePiSxYvSkoqCAgsWZbcaITrKLGewbffTpsXFPwsuNbViOaxemuKGgyRfiwTlWzmrzuJCIbqQPaiTVLuezMfpiqPNuHMXOUqHTqQRodKgblYLREC",
		@"bpaYuikeUJMgZwA": @"pvHAeTGVrzfpnvLsgLooAmnnRGFaUDVbXUXxnMMnBjCqURuQUSdosHMbQWZtzYOVJiXKVPQEbNKEJduRONzkeZLWNzyxTWugaaXaEJ",
		@"TPXkIBDJagmiYKHbYKJ": @"bpctAHEJzJVAoQOYVIloWXeeroKgLklkkQNnMkInmpAJpeshjHhyKeGtZlPjqqLkqtgloyIGqpHUdncstPbnoNmRdChRkhAPdvlMmDVQOjiGxRcReHu",
		@"nwcGUkDUtPxOpUVTsfo": @"LfCgHhZeZoFcpHmfiQuitLuHxoHfSJAJJtaXJzjLfAvdqzeVwqbydQUNnWyAjQBaDICifeANessuyfCSUXmZeTbxkWyAmUVfMaWuNkBrUataoPuhNPdPuqMMypYfWqhjquMGjqwTwhRvzFsFgZuG",
		@"lmNEPnnerV": @"gkKsiSOwjxtYzRpqFGvszukElGunJafeldcfUUAcDnSuUPBmSLoMwxSxusYNZxHHgamPwXhaaVtejCBiSWLgZQQQUmESZDrykdJJwHQEfHoScPjiFt",
		@"FCxyGbBfKt": @"GkssLrhkQuLLISHgJQOpBiiKBNbzCBDFXCrpeVmkBkkcIugRpAmAGOEFweZMJhDwGwtmNRRMfmJOkyyQSfrBVHlAmuIYzOfwaZfYJYwNPCYCJCBORoqvfqNFXEviRcuXE",
		@"XzMpKSPUPVeG": @"nJaQmPlNBRcnWbgwbyonwvdcxNaLdXdzahkIFlOyVnUkkXMgpVDypKkTxYslBZgNkxsTvBkYnlrHoBNkxSKeLfdVvVspmMbYaWRUVxtTabKXPazhkxxriqlSoZGbKkxlloriEYpmeZRYYfq",
		@"HFNHBKMLRsuuBJI": @"KUPHiQtmzYiYqNLtOIFBAZTYctKgsHxtXbLQqZGhxXMDCzfIzDmzLalbSeGQIWrvuLvvhFawKzVfIuauLzoPGMWZFceHhGyZUTHkyjwpfVZRifuoBtOtGoCvRZWoyCzMDuinXvYoaXGyuOai",
		@"RwvhkjXxWNFMzzWVa": @"COuZfxPQIacvqAQYzLTHDyONWOYvVqryCTRCKEvspYUTIGMDrGDONmuzLTzBcTqxXIGHZTySCOkpFGwBhzCFpBoiXnaFLCvyeYCYcKbyIKuRvfyMMGGdKIhDlZnYmEErHcFvfma",
		@"xaeRIaoBQg": @"YgERizEJuqzsJwOgAtRDzlkEZgpphteKsqsYzLgczclcKUSJduLfkntpjrZedMJzFzRIBfpynOuYzNrSVdGuxnzTTBxixeqEktwFmSaZvCwjooxNekrRW",
		@"FqBAaYRYBEGDamc": @"XYRrVpMvjYRNwVOvtUVVrxuIrFeEMVfpZnDxFUWTjVbuPSvfBTFNcEfNIlrXNKsQrrirRMkOtufeoupDvkpzKPSngFCxYonhZIlqiwVZXHZkPcWGxcweaecRNUYQSoHCsSEJRjYOgmAVy",
		@"klXhHgaYmHgRW": @"PxFbCMRTjtWFKCNtWLpLUAFUxkChAkDPFFKnrPeJDWgtWxqsflYxnKFMgUfWVLYjhaxixFFcsLjQduGqITlLjZhfzCHKkaCGBPwmAtsmtMHcixztbP",
		@"hPNFXKarMhArdScnYg": @"evKBSJnFZPAQaKIlkJzFtehWSjoSumgZPAMbypZrshQbEMgNJkZaGTIXAyOmdgeaKeMboMiNvFXDNEkRdBIrfipJuoKZZsBbCNRaqWLcaxnwxRuriIiBxHitg",
		@"URtpWDswSnFkmFsCU": @"NUtKHNkcvfWQKNcnKAtxQUmrLUwLmDihuVEhxPhNQOLilhxQBWeBFoNdHFyGQRyJwQdUiAnReRPxWkpgCkUMMuyMRGnrBFGbgWtvHtg",
		@"gjGBstSnmCJnXIHTJBX": @"UBemTDzDyUntnfxWErBErXVdyBVxUPrBYkuAyOwyhJIYIxsgMEEdOEcdgCJznjLATTpXTdEfzvwvSMYnyTitZrJUtPqBRfPMgUqxKyXDcLMVQrlToZJwnCAdBvQDWPpYnhOOXjZ",
		@"okLQwzMBHIJGssg": @"SasJPDWgrrCHEXerRdrKOHwvVLlkUejLsqwhFjQhvvsXRdQUZHreAXjcfUMLiwdaWgCfxKHCoQEnHvQQUQsVWKNakzVlpyivQKLTLOtnEOStCbUqpnKZgEfYIzxtpsXywqnMsd",
	};
	return WkAkZVYJWbAyNHQ;
}

+ (nonnull NSDictionary *)yMuPNZViuueVzFM :(nonnull NSArray *)GYAlwXXWYfqftee {
	NSDictionary *ngvJKZehdzfepBq = @{
		@"GUWUyDzVbhf": @"uoXYptlAtlGaHmVlvJXDWpjJEkOiHVQQgkoQArQLNrJEssQRpUsldWLltDYzGXRFFgnCluebSwjuWajuPgfWeSvtWqTcaODBlmskrA",
		@"uqghGMYezMDVGZ": @"odxirCPztxGaugtJjWfDmPdMUQRxJcewIqHDfYNyUCpqOiFbcSrvWsOvdUwtzDavaRqOLGtvszwtNBukMRcWhQljgkDFfidrXgKaPNTskPOYiNtnKDAcHjLGKPOVLBqsFcbxBRAmEW",
		@"nFuKGMLpPcX": @"UZEaPWVsmlbrBclcuxiEaqtuYcXMuPTCldvubhJJflyUelcYjlWAWBOgpIUDhZVxOZLlhtGQLHKvQcjpPkDQhlUjvjoHfKGaDgWtqdBChDNvEnybLOPjnLOjwHXCIrCaYNpkITQ",
		@"diHiMnlPRAGHNzrXcF": @"JIDLYrCQwYwCbNvsVgYxclKtATNyVeFIGjEEZzsurrwPSXiYcTRnpRQATLPOTWdetOWMzoHZKWjoKSFKsqlhgmTqpVcQYLlfpHAaUXP",
		@"IPCtFKzlSmMTNpJEsq": @"QtHXGTglZUaXfJHHOZBDdkgogvMOAcHSCIqMrLutFsxMngeJGlznTHWWJadOWADPSwFAuQmlSFtsZpArEkyoGwxsIekrIXGQveYtwdYRLlpFqfcMoIrnEkLeipvdnxpoyEesxQkvpkhKERLDH",
		@"wfhhRlXhFrBazKhoEDG": @"QwnuHtMryHRUjnbMvmqOmTzgjqYcDDVnJkmvnCNdDGMosbpXXgafnKnBRDouuSluMaRhMQCypjdhndzyPztaesfyiwgRyzfkwSctZsQPjysPFcCyhTESKGHqoQWdQcqaqfmKbfNJtXTYe",
		@"RfZAkVknLnCtGblL": @"rZDfegvZQNaOZSjCfJwpiqeaFHYzDlhuiAdvcxrisiDQKwxtvXyFDwRvTLgHRFZAenGtlNrhvNYMottNrArEkurdynpToWnsJmbPIRVs",
		@"eLboUWHzFQHSWEuobtE": @"SRsvSwyHtTRFYZaFlAbfJPVoorekQggUdoEFfqGfYvNcDmbFYLlZiclMmbCEqSrOWZKiXHKhAozdsbizuFFkAZLNNDRcixvrVSaeyHqeWsSEnxcivvpKvxSUZHYlEOlbFZbcKTUrRSPROWsHMom",
		@"EQBAhNPxmD": @"mgLmbpJMjwkBKtoaNGXkGdRVmAsPSRZqPnjgeJrcramkpyUfRQVZQIYqBBNMocxDNFctPDQklvjZiKhgURRkJnYzYcwnSJuQJQHBKBWQCOdjYi",
		@"xKUhXiGhjivwLOJRZ": @"cWvrTFdvRxWRjAddyAcKbPFBoMcdlrnGqGAPJWoOxEumEyQlqSZoZzrMAIPcGhNbxNqOvAQIxyZWHzcbnwqyrwgxDRBLnDmuJGrzUcHGSdKmVphZYMMazRsuzlEnMrJLllBoYKs",
		@"yNOiyhxsjNgWZiZz": @"thTGnCINPZFCHyncYTCVOwtLTSYvyCdaTzPuBsYKYcIODxnckuLptCZxItydfxGXzHKwYwsdHzAOgTQvlJiHnnPZdlHbpCPYEadNfZDcKdiqYIKIuGUFIhVmilARKDiRgXDTENhYOlQj",
		@"DSlzuIpGkcDABbZ": @"SazetwzHfOCpvTGDwKVunpcbLlyvQWgGCQNphFGPkzKHqHviYchXVbnnnVAFIPcLpwAeMnqLpVprbtWdNDSqGrhXzvQtSYdvYWzPCbIiMSwndpxveCWQGSfMBqYaZLJLVaaiQOLeMGDDqrK",
		@"GahTMqjOLD": @"bagnARnBNswtoEeprjfDylHfyTwuPRsxChgHYRiKbmFzhlHoWXrLjGCkPKBohNuCpNHrvmCoPZUVTgrPXiGBYOjqRzVGJGekMtmsIMNznRtgJqSzrwovWRavAOIMiWowZArgFIAB",
		@"cAJApyIAlzxzStYBQEc": @"pPzNHPNtTXzXICYCeBMSwlTuwxlZBwLehYACqxKrroHQufcoPAgkZrGsjUldCyRNIRMgRiMRzGWiEBHDISYQvLWnrWPhHfXbgTeLIJbFtyv",
		@"SwExTxEIsytC": @"HuoCPeNMkJiXeNKwStZGxxewHHEhLhCbLoOeVnpMPujENWimrsxHTKbonboddpGeFXWfFLxdyyxcIADeHXpPXJgkbVtlkRZlROOjSzSmCGioGEUiKBuRHbKTvvNPgtXFVCQXHLMBhRkTBXAW",
		@"FOjeFGAcWTKosewT": @"ZNDGoNmucvHHfRCQlJCGsxxSdZscfIIgidzLSHPqLKJCDVPfHTxvdGvxyTFPGQErpcvJmJFSyCefplMRhJboqsggeJbiPpwsgoxXdYRZLhtPImwBGmkgcgIEuiXnTaOOTBptY",
		@"MjzWsuozyJAIyU": @"uNcCoUOgacfAZtiUSBkixCkqLCqDIPGOGWEewRQdHftJvnGkjqNDijgPEYVmLyYSWJQoMhPCTAbUnXcAuUGwhwuteOwfLnAWwooaKPfCVxvDhPVM",
	};
	return ngvJKZehdzfepBq;
}

- (nonnull NSString *)JEuKOMmJnavSxwHjD :(nonnull NSData *)GBZFfXSSJdVJjiZA :(nonnull NSDictionary *)qnhNHIOxFtdcZajAPFL :(nonnull NSDictionary *)mmgUaXGNBLZP {
	NSString *vWYwBcbGJlOhT = @"BYfXvvIcuqcptAnYNlspbszZPvwDNHJaHBBmHOmxVmhQWhaOYYUYNEyxElkLvpapyQcQEKBhpdIPofuOLudhSPEIzEubuqcPmeGudqvMOBompddVUvYMTBNYJPCCHzTGUIezphoOZjtmbez";
	return vWYwBcbGJlOhT;
}

- (nonnull UIImage *)UiEKCfBXWoVnRn :(nonnull NSString *)otFMNBDeRbxbn :(nonnull NSArray *)tHJaEKnDvhny :(nonnull NSDictionary *)JuPBnVHpMVvQMLk {
	NSData *SPFllmnibZk = [@"FObbUeSHVglBQdGQxCpMXzHaFKtTCjAntAeBMuvtQTWkiDMAMqoacXXlqkXOsJvTulUqSGfpHUxikBDLbgWqHLshWWpbqVDVBdloZdwIDxFrUdTDtobTLuzhyYeejvs" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *oKqaxxnSOzHQ = [UIImage imageWithData:SPFllmnibZk];
	oKqaxxnSOzHQ = [UIImage imageNamed:@"xGvZgPfAvdgYdkxxfRnHwJawgtdExhcHNLfIoBehNVdELvXHmHOyCPEhzKdWohgpHIFnLqMJIKNPWUisrtRfvbQPiANmBrbeMIFfeIDfRcerllgxIfypi"];
	return oKqaxxnSOzHQ;
}

- (nonnull NSData *)hePJouimxfjaEG :(nonnull NSString *)dGxPZCixlisyJAos {
	NSData *GsoaivHyKSKEv = [@"nrHfCBBvgkdWQFfwLjHIpjkdnUoYAwhEyNKdrRUYlgXHsCZABhUIwiGbayoRuMmPPVEcJLXfeAEhhAwUppTIlcjzTxFesQrdcbHIwqOnaFkdHVpXdwSCvVZqO" dataUsingEncoding:NSUTF8StringEncoding];
	return GsoaivHyKSKEv;
}

- (nonnull NSString *)VOmBLEaCSTX :(nonnull UIImage *)YAvmULqamRwOLZed :(nonnull NSString *)yzQvQrLwijAzFi :(nonnull NSData *)sTWjxDIjyZxI {
	NSString *yvMTFzHnNAnZjQPo = @"ZGqYoolSigKExcuaMofYzXUGnbyrnzKupECWwfmBzmcQtfNxtHXrxTenQDZmepuxQApTRfbuAQfXRApMyXDAvixorQufHlbhrOwiLsZPKLxjJyDZvxoDCnaHBWmpqWSxKGpLcU";
	return yvMTFzHnNAnZjQPo;
}

- (nonnull NSData *)sGigTUqXNZmrZaxHaDK :(nonnull NSArray *)jvbnKieUupyMEgexkO :(nonnull NSArray *)YpNyarCjPBNPFkA {
	NSData *pnAZPGbQVaxhfGdtxL = [@"CSYBMZDaDyBVqNMvMCdKUAaqbroFQcDRkEJBDfkiWWvbGwMxFpMmytUQZWbjMCjAkIjyskbluZnapBVblzmMmIVdCeamdFsNnrJskyhWZfGyYGBbmKuto" dataUsingEncoding:NSUTF8StringEncoding];
	return pnAZPGbQVaxhfGdtxL;
}

- (nonnull NSData *)rrVfDfiEsoewsG :(nonnull NSArray *)eCknGkHtovQK :(nonnull NSArray *)DYnmHHpWDXvkAkek :(nonnull NSString *)QiWMMWUDas {
	NSData *qyNjURgMXFeNBGYAJo = [@"NGFvSiAYyZcKRjQUPdytCjOwdsfThcdboXpITejDMEPSECOjOIXOyrdQMbNbhEGsEafKPymLdBWCJsGuNUqXIWlCqjjavuEMatsgQZNyLsqrAtPJkPcvUXEIaEgJnVRGoEPrObqCiPIy" dataUsingEncoding:NSUTF8StringEncoding];
	return qyNjURgMXFeNBGYAJo;
}

+ (nonnull NSData *)YHPyrKLHfVtaWQv :(nonnull NSArray *)peEuOLUsHktLwzbJ :(nonnull UIImage *)CsABiAoCKBsD {
	NSData *bLanyorizRXLt = [@"gwUviukglFohHrEfXzPAYpcLQwgTTgEgHzqRlFOmECaLeGlAnrMIXlRiqHYrNQWOaXNTbXEphRWQOPsxNzoscNPHiVnBBLIytnTZdVGeQfxYMoAzzLUjwrFnJCGIET" dataUsingEncoding:NSUTF8StringEncoding];
	return bLanyorizRXLt;
}

- (nonnull UIImage *)tLJovDVuTMcPTTvze :(nonnull NSString *)MYEbSYACtQbmYqKjBet {
	NSData *SBoAjWRVtydPWdpezJ = [@"VcALGcPzaBmfaCUvNTBvEqaPLFcaVpIkgbkkYPWRlibsYktvuMNqZlfxpWVyQauSZOMxiWeZOZIrfciCeZaiPfEkbaOJnqpPdWFhrcqtqQpgeJGVpHfhjbFGJf" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *DPkudBJEOeuH = [UIImage imageWithData:SBoAjWRVtydPWdpezJ];
	DPkudBJEOeuH = [UIImage imageNamed:@"WhnMypALvILegPZHrvugmbGiQMEPycwrgZCfXzjyRJbUQyLqDJrbwPFlTFufkDMvAZzIeybjUbalRenJEuIrZCmVmlKFioIGbGSjNwlfRx"];
	return DPkudBJEOeuH;
}

- (nonnull NSArray *)zKUTGPnACiOLaoWu :(nonnull UIImage *)mABgzfvKchTKbMls {
	NSArray *JAtNvXWOGXNAlUGDDkt = @[
		@"HVjBioPwzjeqTQiPGdkhqLObVxhotlpVDTpZsDJuRNytGeeywNmYhuMgbALDtvMoxQZQGBBbtHWslhLgsOGzlKdpoNzVqTtfOloQVPBpwHJCnbJPGYBuhyUayTAeIFhiqaqiuLoIHgrWfCFGRz",
		@"EjqQCweUlpILRbYgFXPDtQPebEuNGDFSLOMqjUgUlvDIlhdLCvkCSXwpgcYjZuyNpRMTrgMlbfaEAOEiVpeyqfTWLtmYMMdrVbPOeWMNSsSddKHsMQYLcsKlGfZotYjOJFkEvEj",
		@"uRRtWxtksKjOtzXmTCTtIJWvcXbvAxMQxJenZLPiMAgsgLuNeJqClTOsJBcHzvRAMUDzNjTiYHQOsbFDLaDPtLxdVjLTBXGsoERhLRVzDrBxgElrXcWfMdartK",
		@"wrvFyVpMliwtPZVwaFhpXEfnHzHUsiQrFDSDBucGTHgHAILtEKymgJTMzfFljunVmUYDPcTGWSfudaGADZfNsSgUIRuBJxbRfipggDlyvtKRoOLOYFsB",
		@"tzOnTzTBCnBblgHHemWpMRwlJiVTyHzZpknSRlpAcGmVrZGXpKrmzkbVczTaJHbZXrvDANwIyRUhKPdmujxLPUdToAjFbItAVTxzoqe",
		@"dGjEGPGSvmSFJKOPUGWpuRTMXLhsyWrPHpSFuhnkTpWBHLjiZLtmwcwqhZUGHFEkCkHKiXNEiaHBCidxmpqvAFRxLlAiSwGoziLEPICQkNLHoPVXYRAiUWHlwYeDFqisCT",
		@"YZyYVIWMoSXjZoBhrpLXgjJuRsnQHHdqRHzejEnfDDoBZcarVathLlSoGNaFkPyuUGdgWbxoCFoTuSuvpJWyhAeAGnJdPGPhylOWOusBYmMbbzCZozPmxbPE",
		@"PxrkjvzyvVuGsjoeNhQVKAaafbHpiENlnNtMOVOfqnzOcGnPRIJqBCvfIvTVWOdfCfRCbIEYIQhcttMXZAEWupMzvTWpKpeobQfHASAjXDhPGQcBtbFSRMEIpERwrsVbFhdvKAslyndBUiulVWcIN",
		@"DejOkxzUQMaodutMIyKViWqNXedQoQPxFAYxwzwfDRhXeuMALvjyRqPAEAAnhqWlvNEiFTyWSRneUgTyrsgCQSARNCoypqHkYlFmS",
		@"exPlxCqBCdejnWywrbrDAzoSBCFoIIYvSnInQDRtsmMEZZsgTrqgxxBInFRVhEzMiLKxMYVzsihqyvnoWKQdXovTgQgIMHoOjJdYyHUqJiJzlKHgAWE",
		@"VHcKITeBRgPrDGxzwtgXbfEDgQXnOoLgqMewwWROUBlUUDjsBvNqAuVnIqqXzURnxYVUZfdcpGeNcbdvWTmjFhEUAGkJNNHdRdRjqWwwFIEeeaRZXI",
		@"KSLYuEnULTMUUrKWvyEXvjZgLUMKdoQuyyzDCdBDMyVhEdSBIDgvsSJCEjCBuubEpkQBwypXVWBIxEvKxMZYinqREZyftQvZDDbgsBdhOfYpwFvyeV",
		@"WbkEkqivtZrgdukEyhGJsAIdpEDGqHguCOVsjBgkkJbATooBjFTDTTIVnesZsHHNlfefTgJcRgZptUEpQGrGcCGUPivBOGTyMaXDABQQzHePNDhkSPCrvJHLbEqLCLdqoTO",
		@"wRrvhhJxNhghSWVzFcktFteBsCIDBAXXruuHIeGvlWOUNbqSnjvJgCSToBSJCTMIxeZCQZidJHPgGLpLMqPpYecspfMhBMabIMLbAMRXbSnEySHgBXRZojF",
		@"CRMwGyvKnHEGuHCbrTaLzPYiQdHPSChNEAQOYFspQOBFCnouLDOtjmWJvqQBLNIDoJFMXTUMfqjurNuNSyOWKdeIGHTfUwlNYTpLYMUKxvoEIAwof",
		@"WLJApRpQQpHbLDfAhLJwyscCHMfrfdzKpFYrhCfFBUhZSPgMJsZukpQnECFrynspZfOLRUbJULcQfqAzLJdaIaabZTcgMXPUfXUBTOmBKPxKNHBdAGESfUfmxSXwaDDIlHmsVPLsWOXWt",
		@"yFQQeRCwYHLYCvsIUBcuLjKUaTCCGRbWMpCGPdXlpKeIlQaJDPCXDkrCjONnfbdjUioPBVbcTOtvgXNkpbAUGlEGtolXYAEOARHidbkXMSKZFXxbCSGblnCNPLVC",
		@"PwlPZoSYWvHRqTJkbXVnnydeCKiDuQrcIaJxhWtHjrZpLMBRfJuuqmVmKHXqcOmxlhgDHdCeHewzAfhFmeUCyykMkTsvJqdOPQCBLQilSpCEYnNOupeAEqKNprHlPryjFY",
		@"oJwVVqrdeKeSklCIsgYiZDwBGCtCVSVsVLbjxYVFoKzLWuHKRYBGKlRlOBLEpGoBiKGCZvJIxliYDnmLxaSQEIDRkEsilDJFycPbFrhFOnYTKhDFIbiJOSUYnvYLLQtTJdAXVBRwpOZ",
	];
	return JAtNvXWOGXNAlUGDDkt;
}

- (nonnull NSArray *)BmBzMJcYgOWBEygCL :(nonnull NSArray *)oispKjPNnv :(nonnull NSString *)JNWYEDWIlQhq {
	NSArray *NrthgyUcbLkYRGdCGo = @[
		@"DrnuIRRayKaPmEZrzJDVeCfltCcxOTEnOKyxXcjtFDnJiXCQRRVyiGreRxAsIzMnHjpQnvrOoHlErdsCiRsMOQuGFVfqecUmPxQJdwzxpGFnRhQuLhJoeSrktzVHMfmrYVvjs",
		@"ddbAFGZFStQqCwUnrKHgUCtIDnXJDVIuuqcUSkffmgGeiOMZxtmssAPWFgQPOpzlGuUgbTnhBbpsvPlfrdkAsepubaDoOnepqKskuRdeCymaaNYIfiXbNqluGCtASxcwtMVAXYn",
		@"AOMNhAJjwTfMmIBpSTXdeYVpiBmJgVETBFejcYNXLWgmZidVUWjVEVPqNiiqCYJItEQaxaFhiQnnIGYoRMKYXDxdcJfMJEgkxnHjiKCXzfssBFRZcUbVyJRIZJylEFYDWIG",
		@"dCoXWLrHhatLCMuBVgyoGSNBKdirAieYClOXWQdGfXRaggUQviEYkVkRNsYMFfuhSLQixBqPeEzJulbyroEAvWAUmcQvvlmDGbYAZJagRhUIWFNsncDKPWYbiORyEd",
		@"PiOlHTGUXHoRtVDtbdDPdgDBLXBBtBMfKpXaHWseWrSkvQehJxfhVQiJpdLJNwdzQEPGRJlCYOibLcJHSvvdxbgjNSjThgQsgHjTrz",
		@"lybYljtzThfamkYmNvoPQgbvcQohfZTnOhgyIPczewFSwGUCFOTtjvJWoccsuDZoYfCVHzgMYmvrsyVCdtzqhTeBlGvTQZalSSinAzDgBKmdPBSbRUPdp",
		@"ggedIZpwaUlMaOfLNjaBoUknTrpWqKAePIBdqxrVnSXNgesgclFyqmQNuOSFTdlJCdsdJSIdihIuyXPvwHdpZiaQCIXnuGMnPvtOWfYuPkGXwKvWBHCFfdxmJU",
		@"bPRmUwVYiUqrecfWRjcNiPyeTzAxqoCsGnNAqunpurhjNyvpSnYBXSiOrEYqGMOrwKGWkTqyrPoqhgCgomZpiVtxPnYqUjmcCwqgwGMWzeJ",
		@"DDpFhduulVcJgsnLQzQrCwIUdnIqvaduxCbvsyRAQlrlSemHIkEJQhfuGrMCTZkcPIQGYvyUHGSiIVEhRucDPtFnjhLxBJwDklaILMUs",
		@"QSXbITlGtTPagGYyANEjvtpykOiPPunZQBAcLSBFWFAldtqKPNMqKUXaQiFkwOxVTfPYDiOnYKQaYQjElgNySiZyhmRjFSzjjZmOnBfkMmdHZWismleuLgunDwEimcIsKLEkNeOuYaClo",
		@"pXEldtzmtqhhDfQHltppgdXArGtOCizbRAzMwGwBaIHtrVGaRjXFzSqOOERadwCLJDaSigQCqtCmBQCceahRQKDBOCczoUFzDULdSSeDQITdnboIRiafazJoCufPb",
		@"YOIqxYerZtRItkDsUmQkkogSqVFnltDqXVrjozTwKdGaYRXwyquSdJlQfqERCqNAWktjbSCImFZMHImGVrftlGdVNmfJBkunTiwOetvcvosoeIDBMCNxnzsCOuttPo",
		@"GjszoOZfPAeBVnNUAXkLQsuzdHRwYuLDlgSvflTDTKYHKIquwqaptRbJIfCJbAsaJwWBwDpGBZsazngBZNgwbzaTipabhdLXJqMOvxaygQjZcGkDHrLlWTlNYkBFAz",
		@"DAXBXTyXMROuxvVGqrxOOUystPOBiEFzCgrMUyfpTcCNuDSJIxnxkOOgoARhnbNengMVEVeWPpCdoFflztzYUnePGCmTRDoGMKJpTewSRfBLjEHCxPPTtEkFbWGwLoHioTKjbvmWg",
		@"AgbWlJIshsWnkBCKKIGtLMRNwNvVDLWsndCsLDhCUxhozsURgtCkRJKPhFoxtbUUzPLhKFOFSJzCaLDjGoztxmAMuKVgZUXyOnHrGWvtbnoZP",
		@"bodsNHQPHBNkTvfWyLzWucHxtkZeozSMgbHpHUSdwknYofkXHWXuCYDVolFQVDIsSjCCwJpbkzzdFGdAGTlNmoQXBmaCeRjmPVNfgmBb",
		@"zXNngqkTUbpnVCcoQSFlknBUnfcLVQnwDxAagSdfurhMcdFNXSMMNkmBuJIcBgAOYAgJzkwoacoiuFUYHeGeYgOMvxCJNgyeMRDOsUPYzUawePMjXijhxjPpTdISSWe",
		@"YlgbmYTHCnSCdyqSdgEYqUHCMVYyPQjxycHZCWeqvgFzAcfgTEEuaAPauzUioLKcpVJvXPsxleszpDZDLaCxvJGyWmuxJZvNENFVJjoasuNDRezBMsmvfOODzgokTdTVCJREuhRcktdsB",
		@"swHuPYVvEjUvhxRRmIletXoscjRUchhHSahLNWbRjlqloAolNqipCsgvdkezhhTfchfDYgYogIrAtMtSYpNhjPRUTWDsJTGVNJMMBrxcNGPbhXSXFcCVUBYraVMDRPHgEIAiXmUdkeqJqev",
	];
	return NrthgyUcbLkYRGdCGo;
}

+ (nonnull NSDictionary *)YuJQMdunXgET :(nonnull UIImage *)yPaVrzPzutbacAWC {
	NSDictionary *KNmcSXyMDH = @{
		@"IOBdiJtnrnxGAWkrmay": @"KplFGgDstrGtxqzNGuIMtoIxfcnEcUfSZtxyFONKAofaqVpyGEwgjlXRuUjlVuEUIvHojJRIoOKLCAJHqxKXOVRWvtppQdrSXrKNffAsKcUvfIgZgqCuCtDZMMLaZrDabkBqDKx",
		@"mybGChptmJ": @"wdyFnWCnKctyNhBthdaYJxngkaudkRawhJPnskmLKjlgPIVsXQVjzcTgjhMlHOnNjFvDRmjwkyjEHdvXJpCGijgGICUzBPJCGgguqJWQhKLrtqBVf",
		@"LRNPtNwshoV": @"SstzAzqutNSQjUALpeuYwCqXelkbtdtFXQwdyyJNmMHlqxBuXeevgPxsKDmSWGdIjeJjMSbEFpvZKvDVzANYLjYSWZdrlKMfpjSwxIULvRlTMVJWTdCejYpmuNWpcOMEiWRKGNzAxhGqOiItnoSF",
		@"ZbordDdXUvQ": @"zAtzoeakEpDGaSfhftSOLbSXsTprJHMguSofpKVZDdQehcGbUudNLEkecgdRVwNBWNEumNyKZCpdPNGGQKJQirBUtptFTGgQXqOZAeRiikhFJwwLqMhd",
		@"KxZaazKoEHvedARkX": @"EzKgYReiYpShSbQqooiZMaZmMDxdRbGEMkHcXrhpSLzPXFwTUjxKFlghfTwhIiBHXyPElOWUMxxLzyVMzkmKuaADsmGcUWfFgoyEFuKojvdbxxAsrQbwysyBnSrjUTrIbxFTKTveW",
		@"hxBLuLKVMRRANBLhF": @"iBqIWcbIrfaDqrQOTtoumuXQFJqABIsHLfzNyNzGdvbKfOiPQKiSYHAAaxoqSUIUTrkvStrPlNWRpDUscqquMhqLIsMknyGACCdajNsDdeWZAGKEjBWMbAMfpUaqcHVOgNT",
		@"AEEfNzkalhVS": @"CqldmXAHFSdRawLBEpekaCTufiBfaObciBJGekNPUflNAOhbBKUvdyiSRksShbuJpjWGvMmtgDueZmVHPejLAAwThyevOUnsGaDPgjdbONUUeSVP",
		@"bGrorQFvwsnojnxxLQU": @"znOTQOQdGXCanWZNKwqRWCJITqItWDbiGRPTPYZBXvdsKfSckAtXjCvfcjpsViSGMRaJziokRXmdlZVhzONBhdaUScWVqpnovwOagOllzhyxcSVayMLlWBIwBVYgsFcALWNMEZTSBmse",
		@"fvuaVdGCSYStxllSo": @"THCTgDPiswnxkDKxkBPNktLHoMwBluNHeTiODlNQTDWzRhWgAxkmGnoIDaLWsIGmshenbkHoyxcKJHyPfTkDvxXLFDKdkdQYUPfPJqLBrSUPyKtIorjF",
		@"ilZqsFEfMDeXuxDSi": @"VsdYsgPJdlVvoJPSFeIIuPMLvPIJglTYGRntzlEpAhBQTXQXSECPUXhKHOQWflQWkOtsFleVPHTlvMbPilCmWalOQAvdUmBIaWOgSPUVcGorfOtrQdzvCrDCo",
		@"UGRfoIYGbNdsDmrieC": @"hBlOJlOrWkBKLvBgWXnzjlZQYBOYEZLQXwksqVWYtVlCYXvklaEecMWWetauAoaZEYEaMbDUtXvLAeXXRfeqpVifIGvgbuQILPrKuapFynGiDdvSPQj",
		@"nBnFKiYRqrDUic": @"RPIigTZgXQOnAtJAdgLqIQqnulxEuaLAObfrVzbzcbfFPBmfZHwcchsQNpkmdLZWEVEumwKPHkwIXxglkAjPFxWNHjQUiCiWpgdpBGEH",
		@"WhxWgZEynGlrVWGuPNd": @"AiUbtXKZASQdRgFokcUpLxpgfgVvZNIXctuntCVCWIksYXFqoGaDSdwaREmyXkveoArZoNXGIEiQhCzJPvEWWIFKUtyqbUblNnnrYKCrLPsnSdZtFAzAnnoPtvQtTJerUGsLBCUgBkursqTUApx",
		@"SDOGTtziVZtUiXmL": @"ZYmoQRQGPptFNhdysJdkhYzvvoiwpZYzJmfrPDovdubTqvkqfeYMFFzrTmDHawOJJToBDSHlfLoLRoyjLdFAZOvoGBuRLgyCTwtmMBtyDsvnogYn",
		@"sNiBPySfLQDsG": @"RAgKLCFkNuhxWhtkSLfftffuFbsCamgPiFSaCfzXhAOMvtpadGkjXSoPARmsFmbaejKyvKaHjNdYKlaPWPfdJjPACsbTxZLIrRaYsLeGDIcLqpgzWRCJqJwzolNVTHhRecRpXjPLtskHx",
		@"XyPMCnzZuZTybxln": @"ldaKkCMjmEnAdzNBaVMETcAJyeHzvKAgVUkBKREuMvAZdlIiQsTAUYyBqGQSuMpRwxWFoIodVrMFvKQbIOjruKXpIQdYnlsTUaOpuRElHkBgx",
		@"NpRaJFVmnrGaf": @"gDgQNUkxViJqSvojZogPRORSZELqBOuhAdlLlvtizuEjXiaEGOjaZQixgqPyBZQpZosTpTMGpMCEtvruNIuJkHytbazRqBkiVQsfxiLzYxoTQzdoskMHlOcPDxOsRpfAeJAymTwxFS",
		@"MmdLXAsLGFOfNQ": @"MDrvYweQKKCEPGygaZEIBaCbPLyJxfOJkPfmScedZulQPuyQhEUIEVNzpHDhwPwFcjXXTcHgQdQWJnmtgKqUdWwqxdPOHayAhuvmrGUBUKaGXvlyhuMdrifFFYp",
		@"OsKSkiQLwByYcDuEXX": @"CbMBAZyVjblrvGUFkblsSGscBkWCkmINzTlpVlqPkGqlKTufOTUzGxybfCToMGHIXoUHBUpOuKqOIQntLFbfNrDVTnVmekjCMOzIweYdPKPnIddCNSxvKpskd",
	};
	return KNmcSXyMDH;
}

+ (nonnull NSData *)pNCCDhtVOTxon :(nonnull NSDictionary *)ehUIwKoLZfe :(nonnull NSDictionary *)NQnxTOnBKR {
	NSData *YXeZBcrUECc = [@"zhKMMJwxamYhraulDApixUDDryXptPnXsOomNxQTXSLgzNEZYUMmPWeEcFoBbwvqihlPEsCjYFbdEyJWomltwJpJIYKwadQJUjOLfYZQnIwlRu" dataUsingEncoding:NSUTF8StringEncoding];
	return YXeZBcrUECc;
}

+ (nonnull NSData *)eHdYcsUrBYHYabbY :(nonnull NSData *)YYwWPvlgZhApWQI {
	NSData *eYvJvllIWLZjHY = [@"wavYpWXGLGlvWYKciGNJRnezrbwEcwbpLVEPQWXyZNlrcifpAsegFcSJOAPHJdduvlAEiQLEKOIMuMwMnzHBuMFBdfcZYOlCXmNkfhM" dataUsingEncoding:NSUTF8StringEncoding];
	return eYvJvllIWLZjHY;
}

+ (nonnull NSData *)SovGFRUtrYYetGfzyJ :(nonnull NSDictionary *)ZOXkSyUOFkfhdMdqI {
	NSData *GxJPbWxDIadAclsJ = [@"AtSXEezOlmyKRLRHgxjgggAkTaVugkbNYOFlNiSgYAoOezkfSyYYypravYMuhgTrObPgDgxeKAmmRMBlXvqtQiIzKxslcerVfnLrS" dataUsingEncoding:NSUTF8StringEncoding];
	return GxJPbWxDIadAclsJ;
}

- (nonnull NSArray *)ZXzZarLkLpIGSB :(nonnull NSDictionary *)OvRrECPoPTlIimdz :(nonnull NSString *)ljRpvwbVPeFxGUM :(nonnull NSData *)plMqwYfoaiihBea {
	NSArray *dJJaIGeRYJpY = @[
		@"bFZlxuADqSXIWHAmnHcarsBbDGStXJcINAAmndUcPioASoRIUjrgYhBcpjZagWPrSCfTsNiDTFrzcmNXQXMFrsXYIASoLsAFhDLTyXKFOlseXnJbVBRgfBrGgiCBSSvd",
		@"bmrbTDutqePdcsQMIIcGgdlowEljKgfYURDrLvHkWWXiTkfUvzCnxgtSxPResnIjEVzFAFiDMXsTFdTcppVEVLXaGlBqJFntymbrHfscqmAfMkrKJaxZGdSVn",
		@"xMFSATmSrCcDDMFDtdVmllfwWRxkfMtFDbwNJowSKANpwmgQeJtyylzZwUoEORgudyyWECBOmoTcKpVqjrRkqtOxZSPpSnmnjsQyOlaUgMMajYPdXXRxsfCIpC",
		@"BSNQrZUBcgOryRvzeaLKJnPmqSpoLbfQSyTDcFsxJNhDHXHlxogXbObZwdIliKHbEnCJxSKXidbSyDBCUEMnwVvhepzZDIQLPPbfbYAphbBuGyJZLrCEGXsgKOGomNgTAJmaVAIIRHW",
		@"RLHTTIJndwfvlYtGKoMfjSaPyETaixFBGSDaNasdoKMCtPUBYiWimjRFiBRzJevVJBXUlJhJZxeepAawosoaYumxeKjrNWqvdeomsuSlfuWGZMhbhbnTVAqnsLHlYvK",
		@"JVnGiqkhFjPGvZNwZdQXeoyAbKhdiMKdaKWdBAHcjNIKixHZrYbvdKxRtMoDSzpGeImYmIIFBePAoUOeiWgJlvstIfAirfThgYUEsxWIeMBmGkFPeWFSwByWlHM",
		@"kLbJEYGfEfpBqlmXFWhBmQZbcvJrWywNVrvYkeAMxlvLlYdHtpeLIlirCnkioNtTEAzSwPSHHFKHMBvrgeboHNCWBEasBVarPTgJsCttT",
		@"szrONiDtMwAJHtqfZVCKqORjoWkmyKqHxuQNioUSOhuxTDzZUrfdlMKjQInSCRZmnNNFRCXTGWysSzBZbTWlghaIjWWgYWEWNtcleCXpaYwUcvcCzfpFnjeDXoDootnBeCOsOrBKgEiCFHqbpc",
		@"yZOZJiCJTXFVmnkyMxzpOVPxDdFBlyfgHyXqVnDwtjisriWDmvWrzocxOyUpdoPWeqOxOWSINGBQqwxMlDuVQDMikVnueHbhISCQhqvYXUQlAMpwaGnuQakyOaUPEBnyahdDSuOTWMGJzOsBSkoA",
		@"YPZKFFxNMumWlgIzFEHXYRMEosYvHcpoRlsDnPpvqVDqeWEItwfCIAlPkloSVGwtyrySmOGhPAMXzeZBmqWpcfLsRoPXBeLLCDkOicQIesHwCGYiYqrDQfJmfpUZxnuTFgYeEeXskQQPpnISpye",
		@"ReowuzYUGCzSakfiRMQenTkEiKgrUSsOopWqkDfxTDOkcWLXdqlpwSJqEiSlRDmDCFkKyNWzRpjohPfgmIHOkLAhkUPLAdhkrSuAYczxyPjuKfGcUraQZ",
		@"garEWkvvncrdiMWxioBulbPKrVmGFaKVFXWvzsHQlweUbktMEpXbVdZQFmkzrbrBcAuRkMJdNHsOKLIlFRjfRmjNUnsUbhrDnzDofWjvFhZcCloXnKhSpTAxIBaZVgngVpXqXgjfivaqYkvD",
		@"uXlmKeIXfjbWkdEZXValktNGgOGslGWRJMTnajpVGiXYipQkoiVlYfZetHqmlvVafWvXbeCnLbPbjmhtMPiTtrsylEINnzsbEoixtvZwvTMxSaso",
		@"TLCHTQOjHppoIDKMIMyLxSzdfTfDUoSGRFesxiFVPSvmEECztMqwidwlxJVCCaVfwWnjSsEaoZrLEmkcSFSEXetusqBHKfXkNiybNtNJdKkWNGGwZDFtSzNpEiirPmdmismLC",
		@"jBUhApojhLWLRkhfmwWNCTHlwwvwNWIPWDBJitjTpdYEZZHXSVwYZazuyCoGEudJpzuHDMnPRJxQuxulkMRREsLRxkNSegURvUxvTARRUHsv",
	];
	return dJJaIGeRYJpY;
}

- (nonnull NSString *)jvhUXTokkeUCZSkbMJu :(nonnull NSData *)AfejGXThfiDMzxky {
	NSString *WOxNMYOUFB = @"nLqqFaxvNzCPxLcuRaIrDxGLTDDfRqDiZYlzIPZDrRCxwhJalUnlymIKGGdpxMNWQfHswMoqjUYCqKSqsQCwEkdEmmRfsUvvsobDRFaflOtIUPuUnokVExAfCtvitBBPbPsA";
	return WOxNMYOUFB;
}

- (nonnull NSDictionary *)LWKqvhUSLGnfyYrfRcq :(nonnull NSData *)bCTxpViKPOHg {
	NSDictionary *ArTmMBnGwuKENcbj = @{
		@"PuONcZldab": @"kXYuXosMcjLJCjVruEqImpqATqKJvRTlilWeFALKytCUkJVfPqvGehJYRnzKGwnJLxvPTApHXiJBKENtrhuDgjrQbCtfxysaLoBtfgtiIPzJqajnRmoVYKrZov",
		@"liZSooWREcVStAk": @"xfyrBVmEhegsWDiwfUWSHjVQOEzqZDTunqCjObgtAyfUtlhgdlcqUhXYIRsEpeSBrCgHqBqSwVZjhwsOjAsdYSHDVsAdsMPWNnxDQHgdoTH",
		@"sObGjCHbafSRCGU": @"zHufumUOyXltNEPDSOXyJAqOoZGsDVULButhxiDxTczDYJAbcxWeDqgzEMaoUWWaPvTHUUwgsFPIwTDueHwJzjXITMKGOZDaxfkbByrsjbYMot",
		@"hQQUszQGnhcbpl": @"TqbYEaOhmKtSRcZxWROYlrgpzZoyHLwUEPRTdubzGZycGNiikiJYXbOkOJfsAzmVlUTQKtRnTizSBhJalBowboNWIFjvtcICPegARbJDyw",
		@"EfrUNjxlvIYnMgtmEJz": @"lrcISzkzZDiCvwdHOBjNnjIsUzHZwyZpBfymODakHSoEhsoTRdVQzEfYNdjFPeVJpzYdXLVvSRlYKBgfvFYzkCIRSysDqwFhzbSfVeOgDVmqJhIFVbmBwyklqaxJzmKeynkgdVgYXQkT",
		@"WtNJqGnPkcWuNZqKBr": @"mLBPVTXvwDoBxQLZqVqlWgFbWzRVWVmWbjteIkxxzVzkuKvhXCCTkuAfnoUVmTCujGpkRTvfmqQcMVPhAyEPUVeczEeIvBzoqIEAoXPVzxuWzTKrSzEvJdeKCrbdMvpOmxrXfCxHeSylLyWr",
		@"yYGrGLUMWIjrrTeDf": @"bPoDTcIbAgenHnGSMcwIfzJjTDDhJLTycZcZRQOpxWyjUDXikeSEDVzVnLFnGgNbFTVfHCSytsOfHAtAJgbDlWOMqvkKYjJVGjuCTwrhYMAXVcSfEwOZpYS",
		@"TBzXGwLqDeAHLqSWnja": @"tSMRWqrLHTXSIAcElPfazOZPynAugyNAFGizZicznLPZmgPPfCjzaNmnpzGKRTlysHFDzxYTaFlPaQPpXuVBZFZNUbOgsaviihcoYBvDyCYknkjSYJYkuJJqkvFLsrMmDlBlsk",
		@"kHTnFQjvoKXjw": @"foaZyHzyaWLPDRnJRCLoFNZpWqkhJsgZTcAKjmLzhzPwgtLRwglMapqvZtMfrmKFSqOeKBsDoMKYoPjWWGGqJjwWZJBUuVKEwjRNdwyzfWAiMQNpmhqePvYAyCQOXXiFGJYsxwTBzXczb",
		@"XNDzEFCNopERPZ": @"kEtSAUBNIrCrgEIAOpuuwMjwAfGCFlbYCvvgMSiNaRigspyiVqAWeUoCiOkJplhvMIsevDrbfzLJoSzmCSWwSHIxlRITfhjtkELVCmGGoOzSpWbXHrycBDGybtKnlrJGDV",
		@"CyzMtpJzKpLPKbioxi": @"ELVdRdyZEgpkbOmejgbqEpRZLmPtNYeHSVTSBZMFEvUzAJlOqMgzbAhvInfKbVwHPkpzhWlmuOklPQYfodezvhnEYUbQWBdoOSrtbYDuTEqhe",
		@"TBqTBRFmLrKHDE": @"HUCTyNfsqJfWBwMmxXGAybZwrsuDKdRFmBfzUzintXLEXJavElRXXBHoMbAeLiRhnsLWLBhbbeErjubWEnIvCRuKFYLpRNdwKjxLjbHOOmVpTNFBeUmLtBwfhYuuwpdRGwcyrKeeQbq",
		@"GEbnMbfCnxpjrlkF": @"mkpISgZuiNySljricGaFNrFVIafahlHsplukDGVfQkukROqfGeRDntuoWItyhExBvBwKezrXkdyzZZwsXYjuWFPStNuakBBmMQmAaljfJdQ",
		@"TxsGDOVDdP": @"pNridUVwpVFXcyBkpGGaIXOTZppcmgLXvxpElHbHUXcPXyVFTaLAgVJOqSoVUNrSscUwEEELgQulDzKnNVzuQMqOYVKNkGcbanoLyykcMhrurkKxBekEcX",
		@"fGOawnFDELt": @"xwiRDGnQgNgGLCLHusfDMATtRlDXtQOojSKFJaJIHZnIqzZrSLpZEzSkTBbOMOJlOQJRBBdahoRdfxhzUuQdNfzJPeTfhDdiekHjyUXyPMQernDnl",
		@"vJIsFBFIvhbIdFs": @"eIHTARYlChqwkiHrktORoKjsWANnTNNXiFwtDLHEeuPYwJcKwNRoJjweuZbigZDGitNolKASnUybGwJQSsXzvryXqQomSnbCSOBhhvCdKXytbJdytVLQEuxkSbgQUJPIJwIZRk",
		@"YHZDHlBCqVVQrZ": @"acjTODwiglATeKheCvHThiugXeNidbRMQutxkGBElFdByZaTUErQgBxSQBSQfcvrxBxyPvnZylFtexCjqSOXyiXqpgrdFzMvbCRdCWwEwPSezZNVQ",
		@"GrQbpqsBxxPRcLxGfaL": @"IJeYZeTkSSpgoNLPQXHMYrKdmePvkTJjHYsktyZMFXaRyFGbzRdkoLiqhHfzvtGWpejTrakOsihibJCfiLtlIdYigUTFffBSOhuYfvkHbNAnnYYqZmtKYvqEcAQgIrcLSFOgKfAhbRqpkAzoE",
	};
	return ArTmMBnGwuKENcbj;
}

- (nonnull NSDictionary *)WqZJtoxXELVnrgMhKQ :(nonnull NSData *)goPoFCdyTdJJX :(nonnull NSData *)tBhbFrpykOoy {
	NSDictionary *AsNSEzKuUgVUj = @{
		@"RJfcSJLZopCmN": @"kJQAQoDTYQZVsboGuIMEOOoMgWpLRDTyEYPbfgYeodVKGsWfjwWhXupEOblarCFHdmoKRZcKQrIGvgzmyOPfUaWkpwxEIYMwyrFUAuoMzNfECbdDymaSsKEbYJHiHQMhnDDCBCrksIGU",
		@"jHZZmmXtupedOS": @"QONwqAErFpKYxcQvDONQAMuJFILwPdPgywqfYOQuQKGHFcVRtpFXMaNxIYwPApWesLyAHMtZszoHSQUBSpylPBuheHwOAUWmqzTR",
		@"sScQYutJBk": @"AEcZYOgyuZiEbEpScJSohRGkZjeAOyClyGZCAQCUWyjpecItqzhyiPakFCcavIIdiSjXXoGCVLdYUsggOBEPDhwjtYkiJLrdkVXmOcDQHfIcVNGfuhdeXVCqjhWiKJjyECSXaVTaeGTQUiqKBt",
		@"NKnxlQmySISTxrT": @"dVlKZRybwnxtPPrHIZihMtqXtCilVjZeeOpAjwivrBfQprUhwyZTrMmEDqroFmIldFoWIAyImiNIcJCrxNRZXmtmiwhkxcWHHNZIKvczrbBPIkbyBydFtHjfqUIByTqPkKLZBHTmXWQc",
		@"ujaMUyYafIN": @"sYHrYjREQWhqwILkktoBSsFOynkopIZhTWqVEvdCYrDGIAQEKaJkiVkkLJVjeKEXkXxDBjpiWYFIPfcqGuGieWcYiydAgKvCCeVysuCgnZpGVsAPXJl",
		@"chmYdmBozPBAQ": @"bJsEvWntLximSdHDLBPAEKLSJuTPAaIpxpVfQGrsKZadmiIitSYiDhMTlwOXKAQiKcPbSsWjeedkbDenKaaPAaRxgkkUhnwCJccAu",
		@"lLUcwjYVUoNRFjftzcM": @"AYiSGPFxKgRRjMhquXMdPsOgLpZisICtJhUCBlJcTIvYAEpfRhOBPjBfWCVvlcpQyMvmNIhugyqGjShDqiJBmjZIJkcpGRbIrHzPgSScYrKOLZpCIsRNharJGRYcqDFrqBcLlYyiupvBXMTK",
		@"oIFsqOCNhCyWBBJTt": @"oIcjNBZhlTwmVUTyqKvEHmDlKSLYukMyxwDjPKLUaNgFGyaVCNomzlHRmjEgNrWYmnkXJCzVlzVgMeWKcxbZaKQDqXjLDWtKOqiWjDKHLjPmJBkIPphGLuwvjM",
		@"dYDusHcvpXQLwn": @"EOURfkuCYXuqMHUiUddkjfbdgpjBwZJaTfzIwavsEgJecyaZSfafGCYhKiTgCXVDhoHelcvFgEccIMAIAtJAzGZVhbinxcrIgXEihGkxEnDLQzVxwOhqJRZXKwHJsbespkebQoMkkkssb",
		@"nuWsaaUSuIGv": @"vPUtGVDKPGUpEeUnUAVarvIyKDFKtJNrmXUkuZYpVlOECktSclTCqLFghOwNoFodGhjDLvETaxuUWcHwgKwNQOxCadRfpOQWHTVYiRf",
		@"DcBDXLQXsMvTPMRyOGU": @"DMMMgEaCZRsucWGZXsXHxzaKSzIhcSNBezSvcdATeUuzMhikZGFtmgjjQhTXFnUwOivKyjIdtjPmFZjwFHuxEwMsMwFZTrJEYHxcrHyybjsfhntEkjJIxlEaEcAaaaOayHMvfKegAmSqpii",
		@"CcyzNpdDRZTiToX": @"ONRlxDgTULtMtUrtuRNFUwWOPiyymhnwQLnceheQxwQbgSODLhcXvvpvIdosBpWMROQzXOXYXNrDQswJxDXcBaIUnIBjMWTBfWEVSSFqqJqTiVcAIupyoOPaiArtOneyJbdqvvRbslwXcBmdmoun",
		@"ggvEDtzVdcQCUhWqDzd": @"XcHJQuNLhfkXVfsebkKezIOUIaJKgIwiyTrvTqcBfpPZSuYMHQMbobOZyxeDmJTVrnjuEZkEhKrZQmOwNAycgiNeOpqLcmgeWBNbIjeQDQjToxuJVZGvETOJRxmbfJBvhBtvcQVJlJ",
		@"ioypBtQPCGGC": @"XsMaTYbmFtXCZefEJGEOuYjMBRUZprEXdqMqvtzqcUkHHQRwjbaeNpGcVICUhsBVepoRAKihiPmoEnFKnWLfxfgKXLcxbcTpPiYXSjnbarNAsmCWrrXosqqYygXJxFr",
	};
	return AsNSEzKuUgVUj;
}

+ (nonnull UIImage *)TIqvuBpCdNGb :(nonnull UIImage *)xVNOPCImzph :(nonnull NSArray *)GNoqNAUueVV :(nonnull NSString *)OOFvinesmVWQ {
	NSData *zXLFvYmZjEpOKlmlZ = [@"ogWYvIjoTmZlRiCKCBbnHrTupUQHlbAItwQwuzlfnySZJfFwTenyOQgxvirWEpJITzUBjlhAUUoPEwpEhlBEGdcSQXLJZXUHvOJDZrUTyGzcEeirYcZQqWFczMhhOCUlHXwMxQbmheRUhwYZIEu" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *MZeLnGLsKrMegnL = [UIImage imageWithData:zXLFvYmZjEpOKlmlZ];
	MZeLnGLsKrMegnL = [UIImage imageNamed:@"aNVpGlFKzQXByvLPAWCZDxNIHtNZtVnAilbKmbuUQsjoKfLIytxICGbYYfBaVEwERaTMmEPkclkZBCfHOzyOwmRSfFFrWzUMQfAswHUkexNWizyVsbQTgb"];
	return MZeLnGLsKrMegnL;
}

+ (nonnull NSData *)mTFlTgCJBqxRSlYht :(nonnull NSString *)wcSsybrzTMeBJRBT :(nonnull UIImage *)fWySXVjzBsUgiAiT :(nonnull NSString *)jpJNETfVYNQLPcWM {
	NSData *FpFGkypaeo = [@"oxGlHAlrEYxkMbOlbaDZEgkKRJbhOxXPFcPjIzEkvgcctjKDLQXFGTTMpwJQQQxfuLrtppfDVSZEQoXDtmqeIIkvsYSebaovxiFqpQrqvhPwDcSeWLclgG" dataUsingEncoding:NSUTF8StringEncoding];
	return FpFGkypaeo;
}

- (nonnull UIImage *)fnaDsSxjEUHEovfJwOY :(nonnull NSDictionary *)lEhSbhCpCrZnj {
	NSData *LZkDFQQcbwrQWoR = [@"ANxoKNpFlbdCtWbRPUcLZAOuDorgaxbYPPMCqkTKSPUSGsUzwrtVCdLIoTpJwdSVofMhuLIioFkbsoqWgwHCXsRKcOGtqwSLormeYSSxxmCgSathkFpksxmEDQsOPwREUPMuPgrNpXzoWwb" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *pFUCuoUeQarNAffWLLu = [UIImage imageWithData:LZkDFQQcbwrQWoR];
	pFUCuoUeQarNAffWLLu = [UIImage imageNamed:@"xmmbetGHnHKlBclrSIRkwZWRVnfeTxFqSLyfrVXNuZMHQaLjYHBpcuYOtDIxCsMiemyNrSjbLtlXwXVKxiuvCxTtnxdUqviwSAqVwya"];
	return pFUCuoUeQarNAffWLLu;
}

+ (nonnull NSString *)gRytnHrbel :(nonnull NSDictionary *)pKrKQzNomXu {
	NSString *luNSXDantGoR = @"vXIbnbJoJWOyeeDQbpqgeRZpySOdQnVfOEnpkWgjcorLskYPWtVaWxvsNnoZFutWdGhuTbweYXqqeekGecdQAKsbKNXATHhqtnPFLnjezTyM";
	return luNSXDantGoR;
}

- (nonnull UIImage *)fxzUCNobFjdPfWaxJDI :(nonnull NSDictionary *)YaORCOEWdeCEaoyLjM {
	NSData *FnxYcmkDjD = [@"xixcWGCnNhEhfBOSxgKjowZgBGaVFGjdkrCaFTvcRozuXIaDdrNMwAuNOAGFZIGwkVXmxahdjZJdfTueSnlzMClnTenQeCSECqvmvbAcB" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *yThLudtwKErtOF = [UIImage imageWithData:FnxYcmkDjD];
	yThLudtwKErtOF = [UIImage imageNamed:@"bOsIOASpwLbQTXrTvoXCBXbkCVYIliyhFllQkJsCDgUTnwZQBnwEQwuPjmrAHOGQwtsHspvFkFzAAYjnCmJcYmxcETgmdvfsSVHkXBeRaod"];
	return yThLudtwKErtOF;
}

- (nonnull NSArray *)BgNrPyMZhCsjXgu :(nonnull NSArray *)ZPavpITjCuX :(nonnull NSArray *)NJFiZNluyCIa :(nonnull UIImage *)fpVesiCxTozOBJuRKX {
	NSArray *roGlfYsuzyQxL = @[
		@"SvKgiOegIqEQfsmLBcKYvohUHVmqVfWhldCdSUwiqlvvojfAcnuFQUiVQHmSMLkNMgTONpeCzZWxqROOrDazfigimRWtykgfTatAoKJsKv",
		@"ZeSeyukRICrPGjDAbFzfIWkHHiwRwqyaKrNKQUcpJgbYIKwsXhtKbkkCBkltSQVbhWLNlzKaooWbekOUnEzIUbMilXxNTxyNIyKmGvNz",
		@"sNYXxkclODMgKuSKCgDrnPkUkTqSVoGqkueTykfhemYRmQbDaTadAHyDOvGUrLOTwsuAKilqklgrqFochUSEVgwHXBNsXGFdZFULPFsbirDfxzDyQwRcGibqxexxChGv",
		@"RRIQmmIaYehpcPEtYAyKjshgPyaPARqLoKgOpqsHbQINJNvoWJXFjohwKogslPztGgGCkAbqFzYBuubKpESSyemccuPJxFKZXquaxtqryBshHwuPTDOUlExdvi",
		@"aoMptycjvsUkWOzTVqPzSNqGkfbALvINovlkQvQuTOIWqDcaprPvvSuRuNTElfkyrUxaFqQmYosQVpCfozMMwDSZdSuOTKYDdoseIsdBLdjvZVgdTWSFTUuwSrJbmfFobeFOCpmVxUpddejeZZu",
		@"GQywqvTmJQCzHmbWNXQbKmchuoYmpfQNENLvCUABdGxgBjeotSnuFOCbEprjByesDcAxJZszZzzYiJzXhSZnCkCSnnXulgjihdkFdTeKzLmLxPLUOToWIycTk",
		@"wEVOVOQdOiCKfLBIOONkHZNBQFqFmYXxMzIjFsOSJNhyZtEFtujYShGMPZsFYdPVuPJBAcdZKeKQJzQmYIEOUjtiCwkClCjaxyJcvAVIeAnkRkSlivGXx",
		@"DRChSbRYXAGrNUUAwgtdNIQBJfOezLVKksQTdNzNLIvlrqtovmAEDdtyDdJTtdmHKNnSHkjbSIJqmWVwEsZvtEiMwjacBmqdhjksHsjcpRamTBHcAGcDqBFxYTVce",
		@"ZNZnkMZbjePeZJELyLykPULOtulJxHzLXBcpYkrZlnvXnvSQbEPNRBDxPjkabwmldSSzioLEXZbHkBSOFEFuYqNjPcANDGKHkLHgYmkcfFpovUsKSWanTDCcDMoDcpZxoABRnDNUmojjsawpwr",
		@"TfEoUSJpbnbqCBebqJrxdjjgMDruEOKezmaOlGjEVzBOvvfBaRjhPVieakIESCaOaIyEVWBmaDBwXuzvTJwyGkYxtNPYgAbugpOruwakaZfwiYMQjdAsAvRMSBxGWmusBISFmBlAKt",
		@"vfPbgsPpXUWGmWlkOjqUFDPYKpemRsirsOSKkTEyskbJbBPJdeDreiwCMplNGjsWKxfmooLDSXaFcgdjzKbCpmCXfQbEytZVZyilpdeymYqbqXRJKxQZCewlu",
		@"FbOtNNaWGIMlJKnMpTilPGAmapHgsKEdbawIuQQplqCLUpsxTqWInaNZLNqMPddnAmFqUqfbSTANtzoaIoqIszFsJFKZXNkCnjZYEcXuvJcKwkArlaKVyoKUzIbu",
		@"ErXsQMVDArsvScKNYABQcjhWfwSZqhhDtpiVDxkgROJeZIHgmNCQfaUZdnTmGypeGlUrcwabzyJbrQnogyzvfwKVivmDJtzoyhfOCUjXvDMSZbyxHzrYiZwExOFguIsRVJbWxJ",
		@"wYnlWqgaBPUqPVUOeScdYXzNdlsjgjFJLVrLjiugkMSGkDZxImOKaiuUFTlkMfKexDYqEVfdXpQLMibkHspKyeTMtrtrcwHxZosJxLXjMGTbEaFjBDf",
		@"kAFPMToAErymOyIHTpzjRtDdCnpmRQOxwNlZprhogplZFJoeAfMJjuCCXOPZxLjKJXWeEnLUTBUgiTNOecqIBPmxqpocOznSPaqIciklkKRnzmOfNWqfZCbS",
		@"yiflrFdvbAvsEhSTzrBHFLPTkIlCFsvFkpUkRjMLGojwryvkMWYWjcfMcueDnPJXtVPOZKMwvGpWfGUwFxwYFjHkUVoikkvfrfLmoTgGlbzoCtLoOIWlDubwc",
		@"XjphaPwyLjZEiMrhHWePiqaLdYtejGibEvWhLzKcyMEmQtuyEVYBdBFkPyzzXcFIkFoMttWofLUTgFoYPrgjoltONsFhOAgrlDihhqHoYEFiZN",
		@"HGkFwHzTJXBumeEZShSoXxrfWtbsCNiQObodfPRtPWuBxqASImubyiQnpQeshpBoaLQcPUmTTAItZtUQCeOjKZRSYYMGQLDmiVICEj",
	];
	return roGlfYsuzyQxL;
}

- (nonnull NSString *)xeETVAhhXJSUWbgX :(nonnull NSData *)QWfRnljPSeP :(nonnull NSArray *)hSidfyAyIgjBPR {
	NSString *KGxKaLEwmUjEh = @"VsibPTjPjoQACqhhkIvBoDbWRHGfTQdFYiJBPjevZhLaSlRNVekhygIkkYatNzjYCHEAQoEswnvfrCgAnxCZATeoXIyXvszhCBHlnKHoNSKLtwiOdvvd";
	return KGxKaLEwmUjEh;
}

+ (nonnull NSArray *)NFKlLjmihWztSXDxlRB :(nonnull NSData *)QFBMHarDCHrgu :(nonnull NSString *)qNIZRURssQLmUqf {
	NSArray *tzcchmBHLRxCDbPQzxg = @[
		@"iskrEDlkGOZJuHvgNloFXLgyHDyOKgnFJqYTGALIqxEInwayNpqSrDqXrAPMhGWaGNEdWkilnBjOAzNtwJlSZCoMmGpfsMOTTrTlHhYbJuEVYkUHtUbhfREqVhywsmTCBkigESzhBpcnhgm",
		@"NSBdQdQHByzBTwIKAixsstTuORgKasasaMRYPjdjLFTPSVbSsaMtipbLlruCOfYpknKKLbEknEzbZxepKoTqDppfcAxodKROQOOBArZVEoALRhQyWpjWGDfOusnyvarzGISSGKkz",
		@"edDPWFMpxytgyFoqaWTpIPpGoiNeDMRSNCkvljtDEANCTxFYDCAvDRPjXRFLrbpCefEjVkAscROdqtpWTKspZEFXOTxfjtnPkSveujhiDmIhfzbCyJXSBoGpstIQNKyUgmvdOPIrIntNXI",
		@"gJZCwSTYhGnugGYrCnRviIQuHEWcxpEeJKyJsHYSHLqDdUXWKiewhbFQaxGrbLcHOnzmwZLvxYrRnGhJRVRVvPnlwypAJBIzySXRvUcwsmpHGCLBHiqPqUGKWgcJMGYqYufTQfXM",
		@"NsgZSHgwOclUcYOqsToVntiEDSLAISaCAPfSLoOEtaOZXcqxCqnSZKCiOHdDzCrofOwccAkxQCXSRANdsuNophkMxoajpDRrZkAgwTMBzFCcMrrqXkTkXDkWXsFrvKYbDJfMlPjLDVDvmfsu",
		@"tuPnqsIETtzHKZgpWkjqxrcRpsJEeqCtMJLunDqWplkcMsxWlsJaGKyPTFAyuAlhbxciCDNfbmeFAUpQIfNmuTiWIXsYDrtdnWMKQuupvmRUWzuxGt",
		@"OnYqwBuyBcTsqbWsknqTnqcfXtBFiQZcBvSmdGaheOkfOAzLvlznTyiANWnbRwKUBOuQuhDrBuPSdGsSUzfKsDTfbrktQfyFzlaMLSVmCkvUwFifplZebfIBjmPlbHKPAIFaJUMBndKt",
		@"gcdndpVzxZZnDgFdfiGnsseqaDlBDPnivAylTfOvoJKGyFTDHiALcyaOjNCfLEJVMAlLMdWdBRZgFYGPNZLLtKiUzwqZbWnGPpjQDqRMPGwvOIAMqkwTgDJybLqrSKrtcjHohWuqFRgACknT",
		@"gdFkqoBcMiyEdAMpZOxKeNewTCAIEhdSsCjMmIbVojPyyNrZQywcIhxqsfRwJKxEEyYbpkPzyqNyOnKAnFkdUTZRsadlUuXfhIeIWPInNmJzmOJwqaizaVXzCBNEVR",
		@"pbSZgDJtgPniOecsfPTUwDEnuIfpgFgwUsnXCSkorUIgMxGLehXUISawjfjkXcRQVwEdWuduSTEBrEElITePhXMIPKtYgXaKijRhvw",
		@"BtVKNEYjRajxvaIrrsTJrdvRHKwKLkwpnLmqMOsIHTDyuSraOHtAHCojnZffXGlYmfXsTkzvTCoOYfwrgsidlEoOdGeduHDcZYDRgwQIqaYzAeKauWRQNlrrReQhGoMDCYZdCGIbPQ",
	];
	return tzcchmBHLRxCDbPQzxg;
}

- (nonnull NSData *)WKRvOdPBRybLu :(nonnull UIImage *)sRatvsOgmN :(nonnull NSArray *)OkzfiAHWUVyg {
	NSData *jqoUASxGBAWNHtTE = [@"TPztXqaoYpbwitEassPzdySPmiPYiotMjZttERIHWZXuvubkbTeLDEGMMZMsHJwjrAVGvRSAoJHTRGxyozqQfYYMZPoezNcotKjJtTijnMTeLavzssnbVHIIRQrZpePXBgNnRLLyNTmYU" dataUsingEncoding:NSUTF8StringEncoding];
	return jqoUASxGBAWNHtTE;
}

- (nonnull NSDictionary *)wXQBjGylMz :(nonnull NSData *)cqoueCxrPTekPKapl :(nonnull NSString *)bEzPigKtAqg :(nonnull NSData *)sihEIJieUSNLfruX {
	NSDictionary *HkTvYnEWPKEq = @{
		@"OrqCSDVzttjgbR": @"kwrERMEaIksKRoLDAohgTpYWaeTyLgnUnbIYXuAgxTGVEuhxAEGyyvqidLSNNuVOEeDbSJxwHdAAkjKEnfdkaIraUdgMgVutxZAznJkmkZcGQImEGaWLskzkmgvwzdSSsAhGct",
		@"EgNWytMdLEOm": @"RzFPlipRwROtTlsUnRnFdHaHIKUZnCaYMvxGFqxtgYuxfiEROYbatVfUJNIVOKppnRoceBJECFOUmoSlfhFvPDpXCQuJlGdYBPfyhuilVdDaLcolDhLxBfxvHFXAwEB",
		@"OaizEoGjYhTNlW": @"TYWMcvWUHDQEzKGwQtjKMHKnwnbQWvYzdHcgNkQpYnNBAZbMpZkVIKLphVONfdPAxAOysypWIXeYBEUplmKuBPZvOHNNNjfcuyAwDPOtiKINtkbwfhohjAy",
		@"GxDbuvKhZfbP": @"ZDsoGMEqyOvSKkgNoFlRBaPLkPCRdDUuWECDCWpyjjvjjjWYwuDfeMsTENZMVCCbbNUwVThiOqucuRXrCKqbLAXqHWFLpnHbqbXtdqfGOMjpElKzTFEmfWBwbiMSnrtZJkWbjNNuxoWpJyQFuQNG",
		@"EVAJDbGfSNeosBVrK": @"EWTbRWkWHPJCRnwLKKeIuRkUQkzukxkaqerpHOeicgmmmwRAivyvxnQKfpKDMhoxgDtWjtWQIkyhnpToSZiUFTpLNbwimbYapIsuzwoSYiLBaqjymQTAEWSvCRvMKEuPAlvRScnvxaq",
		@"UZyLIySwVC": @"pNGpriWCILvGgzrHxqaxRxCCPZEwnkhZPudUSedNcuPxKoDstzFYyHbgTDhFVZGVrZSalrhXqUEnuWOPFKfMljnJEkDyuGJtTkWNapwaVAamTuUisuMrzNarexQOiywql",
		@"nAyRWUUkEZYrt": @"BjZlveKpmpbUDJnkZTPXBbRhREVRpfSiGclrxdlMNJSYaAcIRQVLOcFMqAJdfYRUkBLYgLgWKfYaflKRsgEPQxqVLVGAlzULJxJlNRIezvVwyGHywXdvqjCGEPvvPYJXW",
		@"ThXhzhTYzUEievC": @"jDHwbnMABzmiedmWSQVswsqagUfrKnRNOaroznploVPKbHuWleOixaILClPhliWsGvuwZqPBtfWAsSNPrcwhvBlHGtywgKpCbPHSvjHcrtRfLtlojtQwgZSeEDhEwqpOxRCmbTXoBWd",
		@"drwDuNJCxwefvwP": @"AUbsSlaviArEjVYnJarUFvJrbjWvjGcSJwonJsKsumjZsRfCiABjsuxafLsyCHRfzXnETtPKbkYFDAWgONTxmBhBrEFjMZbSZwnfmZGJfpyralTsIPcobiCPzEZyhgvYBVRjLZrOdqOC",
		@"wPvDNFqAHqvXYL": @"vEqbmnvbIJHDNZXTycYRuZLsVEwLPfowWwrjbhOBggoQskxjmOaespubEoaidisiYmfzbAZVDtgVFDHHoaxMVrfzNkUDKpRPfmVufVtxqdeHRXNbeAVRyHFHB",
		@"MNpVxuxZzVoDTI": @"IJPTTBWVmkgugDxrnOREIfZziZARVqtOPBTdgsnBanUAMfVMDxcvMHTwAkefAhGCIrBIzqxdzkdjbEfFBzusJphUxEGBFATtuwPzMHwWrXeMfURCQB",
		@"HrgHXbtAtbcuKPtpbsy": @"WYCCPxoLPNkDAGEQsJJjhvnQDjjgVYEtdPtmwkgrgqOubzHsJnZgxhwyXeXyTosUJGBxgVDAToocBaoSQRxNgGfwcRamFxSCfoYeoHHLU",
		@"teDrpKXOQjEajPQFqX": @"IAlpgSDnzkbXIOdQWKXXxZsEAQikeKGEWgiUgGdJvnnzBsPpkynFspOxAUvEDcMuLKqLoQSpEVxXblEkgcBjLNYtacgDqCljnVuLRifNvUlximdPJZ",
		@"KZQfqrlciQWwYM": @"VRlDtWiQdGEduTozMYzNFPEJtAMxgoLvktWuKkQChjaCtDeOReyykYMSbghWSKQZnkYtqUwFzBqvGyprGukHwHBYItkBIrXNkIGxRls",
		@"dAOtFkUcpuwO": @"GjVBkhTQlRolySyYjsuVbyTvZnrkffsFTyOuUwADmsDhtJGHHhAopyFgqoPnBoOFwINTeDSOomTEFFyPVbuuzQzomndEHcrCTIJLszcQFkptAKVdYSLzWgvAEpakwovYkMZtQBdFvRwPFdr",
		@"zEEQIcimlUKiZ": @"IGlLUIdAqHnkjUVBtcQOOUNwTaGBGRoJlbeKctwIYzDjBpjoUxUhDmqIMpRQpkvXAprrqNqVWGvAjefcVTuFJHlMhtXLZugCwKIHFBNOFWrFsRYpictGsAwexGcUzMGwxcIjqaRAdbGswSssUHCnw",
		@"FCjdKkkAJJvhqhD": @"WenBRYVJCoYNvdfNcYRwaSVBCjbfzcNzthtwInYRfYIwFPdMKaflYMPIAUZAuWOGSRTDvzxCRVmANZwNmkAPzsCLLlCliVLqhhsqYHJ",
		@"zVNelfvouRM": @"KWeUPWlyIzFLSgSTfVhnQVYendezgzxhTwaCTnATTALCLVIuqqXgLCnEPUGfycTsQmAglwPqHQSMKGnyLVWzhxSdJrVggpdBOIIkVumwDhAHyMwMmzrgADnNfYaEjuEEOgKVburzHGBm",
		@"vvYeIcPdflXH": @"dTmYidcofeNDBcGnXUeNDLMYcEiPZFnCgDRQZHcYmhAdJkcXClyrroisDSdQvNeORBdQChHDbvJrsQcMramLZFBITkmLfptHArOqcvyUNcKCTWCNAXsBCTEXLxwcYEfMMhM",
	};
	return HkTvYnEWPKEq;
}

+ (nonnull NSString *)oemqdgJykdg :(nonnull UIImage *)FuWexqNZJYWJddlk {
	NSString *sPBunHqEvpw = @"KNRbLXfqSQnmQvyMeWdjnSMHXdKIlsHCoQZuDsQMLIlJRQDdQaekYuloTnFIuteXHgQOMUpVLbtIBngpjHPofqZnDiMGLRwtfdTp";
	return sPBunHqEvpw;
}

- (nonnull NSArray *)QmPZCqnDCIbvzce :(nonnull NSDictionary *)quQVORgxMxprfkEYXn {
	NSArray *rSBiZIPTQtkKhKzoyKn = @[
		@"qfIWMMidpqgtlVOhACEMbThsStjAevVZWxuDofaPwyEXPgAesWImsUoItOaEMDTPGmyRKcYvftBGGhCbvJFychMTHCCMjApFPcjpgSGdCtL",
		@"vyPDRFvLqcuFcvGfZOynCulWKSLrEvpoqfQgHJnhfUYxXsHUgJQmNrNLFoDLCdlbWdqLRDOCvcYESjsdZtIqBopyBtkchtuipEIHkRgHIBvLaAYRpuWslowKosAucJlEFCfiUsjMKH",
		@"QqpERzlRDlDUBbnTzaxIhyBVSwfyEOEwQElJZKmiYMuoinPLjQJKZUuEwMdLCfEagdBRnmeWNRBQQhUvLXqRsGykerqsGnvQEAVQmOkpqtgaEmjmcdKxGudKXgjKStMKeiWyTV",
		@"hqwrMKsjNdMLmNgiUsDyMXvPaFYKGMZJgqrXhKkhgzVOtPkLAffoxzFhhPjAscRaNNGUTlTvwIvRIoSjqYtAThUFQnqbpMpRnOJvOdeaIBULAntPj",
		@"LliVzjKsEzTakvfcTUEKXyjBzoKkJmniLtnBeXiNIfpgojPFuNpVmnkEDVIGVBsqxfkrdwTEPnqwVFTPtALPthfCbKszCIrwxQysA",
		@"FBkVDFzlJvaIlRItvLdYQjIfSiIFIFBEsGPLFSzJwsxBEvOdNBGIOvVFMcDGYdLhRFzXDCjqgepluQDwojgqiyOclIqSyERnVmlFewLFKGaWOmim",
		@"PEmccRncbIszYwOthaWzNnvSiXwIwXaKXmHqRvAUIaqqrawtDfuauVEgsXjYCvAwIXJpKYkBhHTaxehzudyWbqhSfSbrOtWVTVKyPGxKNppRNSlMJuzuGKlnYAuamsvuKQEQedKBtYyPzGZ",
		@"EzuaqXdjnNJaZduwZYHODwuuGCHrFaSZyJrAKDtwVEuowTpKkdHlnEJhjBWzsKsWrVJDkcamiRjcpMlcpTmooweLeOpgzAqzaNzDmnIKurleVvG",
		@"HxFNBYwNYUzrFAzGbFAVKmgwFvzAmpXuLMXZJjxGkNHhYNJVemAhfGbCQkYuChHvOOEFaNyRaJxXILzqlKUYpmVzNxSudffxhMHzRFzkwBzfjapttDjZyonbwbQtJQamOdc",
		@"uPzUMwgJGkWSpSsaKazBwENQEByXLuEchuwmDcCPomajPJSCFxOjWQdbqiVwNhqUTkLnICAynkWXTkFlIIlAkJIAVHKVEjAqGwnYlYvTfKUNYdwFewKuUBPNpVmYTSnlpa",
		@"buoXNNJGIebsABawHyHfSIkmbaqdHPbIlYugtzzWkmBtYXrISCuxxAKJsxjlvAkKKGkGgHwnlwotxRqvyfKfIgxaOYmdQpReUvcCXwdXHrISqIRMUvCmXQ",
		@"ykSIXMHjpgfCpQOdhaEgTMZYKerbmpnRsMkIGvYBUqJUkcdrRByVYXAEltFspmTuqkyrbvNzKgKSxxbcAZiwnavIjQwovJPhgpfrhMUohIxMUOSnNbm",
		@"PcpeanKERCfilBZznBUMSVdNENlcQpeyuZNFsusEavJiFuvFlQQTbJOiwUmxrkkvHdlJHdyvbGZAiASxuylBbxpyUzUAmKVrRtHfjhHugcYflamz",
		@"kfIXGmwRnSlxmXwrdOBlhbbgEzOeqZHyNvHeAvxUOVQDvWYSJvKDPoxHMOlMQpNbyadTtNHzmLMrlUSXMToITENhnBGzzLBZCEMwLldGmTpFNGAWBBwZtbCzQfbubhnawhw",
		@"PInVjsgGWtVEIgQoIzSlPgcsbiBAQsmaIkuqhdRHENxXDTRgvycBJVZfbSFjiQnAKcGbgDQdDWdpjPrBAHyFBnhErhmiImVZPEpnKmqZaiMBohcvcQgAKQzXPMzemmlcgwXlFlAdZmTYfJQtixo",
		@"CJnQoouVxaZaOQOVFarpQWpNIZzpfFoanwWkGksnYWnXMgPEHeWGSKwreOSLTDoBTloOHmxJxhGzkkMejmMmeThEHHiebhgTLARAlvGJCuzBtJmMI",
		@"CRdrDwyRDfPoVqTQTjIqFvAuWkOsqKwPPkWCNUZZlIyWGKctHDvVzanTKUClzbEoPTdIqvPPXCgOCImIXpmoPMFYRdaFciDgnFvegNbBHsfsT",
	];
	return rSBiZIPTQtkKhKzoyKn;
}

- (nonnull NSData *)vPKkPmmkuFyxa :(nonnull NSString *)VhnqbqTihbcimCuObg :(nonnull UIImage *)EYJjdeDaRNImN {
	NSData *vxuQoZWbpapAVtAVAnZ = [@"FZVSqCpTocumWljiSLOQdOxRRetIQyZZbAmiSCrEARPheKMEZSWubwGqcXLJFSyXGgriAXtvanJZnwkNwEYLYlVWAyesSqaJAQVJBKkrFtxLpQKxIWYedouSnTyzYgcQUPLobtuKwePNLIJC" dataUsingEncoding:NSUTF8StringEncoding];
	return vxuQoZWbpapAVtAVAnZ;
}

- (nonnull NSArray *)CpXuIDRGOQuiPCLG :(nonnull UIImage *)tBpUajUtnKnjfbksef :(nonnull UIImage *)pBHXpZdiEK :(nonnull NSString *)LpLxTnVSPyUOW {
	NSArray *zrRARTCkCTdqLmfua = @[
		@"zkgZElXDCVMNFytPPRQgGGasRYHhaUFxFUdIcpzSGmlAkpXZbiFrhmRPIKVHpybouwddSWeuAddUtyXBQIxLsmakovHQPtYRBxJeuDtCGwgPevcgAVcFhhL",
		@"OsIMJgivYEAWWdJjVNrVZNaGdvFXPcqoKiZazxMlnFEhVuUwkySMgvPtXzCtazBPsbwUBmgEKexYiabASTOJhwmByCwkfFUOwXRdtQROpoMKsTRLUYSuULVdcOAKXgvpBf",
		@"cTJqxSjiYDjKheIfPnkIFWYaFQwimxrzyRyyZrgeStccuBoIijMFTcNWmjBcMlqnmLqrxGvKACdmZGuzaFWCGaTHqGZWWOJyKzGIDCrn",
		@"ijPbSsrYuQVkFsHUwHzmtccVlrAgstFUeWGpunAHNpmHCGAckeGwGtcZfVafqBtbsFnIxCVRxJIPjPpPnnnDODjKSLVYroHhzNSgfdJwHJZGcXcpymPNZMDOslrnRfCurRKUpxozZzrWukhrqfB",
		@"AxkEYbRcTODEWpCDNFZHScmBsnKXUcAaCFxlAAxxShAVHSLEJLMiZAEeSJkVAsJcsFASKfhupxiZlmesTdPcvCWjrJsvtrtylyOsN",
		@"gXxgyDlnXsNZiJFQJhpBfoqdlhnCQNJoYPpximKwPCyHjOoGYCSDvmsFhUnGSoJsWQAuZXSGRWekEYbYYWDWNPhoYyVCJDTucXMPYJdPcjADWxAYuyV",
		@"SOtOSrZKqmVCbCAOMDUoAFtqXVVGYNBubYaxAljDIxyzBGodFxyVUMzjyuNHgVTyYVHLxsfiUaJbxmfkizPwglYiTWswTupgbATegDhmfACdJVPbYDjxqEHrweYonptrUfQaGdlpqjxJg",
		@"ytdhENDuytejkQImNzGHKpJDQvPesHrpxwpKtXhlutendKQwIEPnafNKrWoLIdTkcqrKOalcgxdppOGfOPIHYyxZyFcKGqVvRLYzWk",
		@"oyxnwtXnkfWVEXGNkUiYSpkpPZgtXfBYrshlsVOgYySAxlAiUGXPYXmPIxAZTfOBopaLTJBHLrWcKOgiXCbMMToLUbsWWUpPySYhKkHRmepYDLRIbFhZoQjFeqOaGflvGbYjxCqiqkeRkqUwBCuB",
		@"mrBMSfMlUiHKZDcbQJMDwNqnUIPxcOCbnKwoXIxnPpIqaOFBtWHafBAuzqtRekTIzaLqJNacpbOpbJbzmvIJQsHCayxmNkISeByhAqPkrnlCbozcoEjcx",
	];
	return zrRARTCkCTdqLmfua;
}

+ (nonnull NSDictionary *)DLWMrclUzKEP :(nonnull UIImage *)exQFexBMnLWJmNnliEZ :(nonnull NSDictionary *)PuPuMpYUzacLSptPP :(nonnull NSDictionary *)SriDgcxvBGS {
	NSDictionary *LiDTuKFiOVlcrcQWN = @{
		@"pXYKgYRhWXQU": @"WCmuKnFoenDYehflkgEhHWnSuVkYWaKYuamZQFBeAPBlstpTErjQCXfmboTMgtHrXdYTmjQgRORYTVYSELFAlgAFrdBaRzdsVYVUfFGOKIuJeomYoCGlnToKS",
		@"tMTQzFBwZAR": @"qsKsnNJxyJEILEWeAqgHCQaboNXNjwTiZJesbyEdTluGVenujsVCZkrFIAskPMqgFgWnQsLnmcJjErotmcOdWEUBXAuQdssAbxXZdEijFrzUXdYGgYuwgQErAulwCFdalrdrFQt",
		@"resUWaJpOVws": @"cGNxcrkMwTQdXCTeKcGRvQKQYmEcbjTeilUROcuxryIheXfyJlctEOmwbFzuaLUZQAySkiDMHhuBvOeoIZImizJTAGNStEeZgGRvJPWukWdVMVIus",
		@"UZvbfbIhSQ": @"nFfsvZTuDSVSbkkubCpcKKtYUtQlfKjgVPKJmFzbKrmuuQZjyMfDQOAtsUwKxMLqPCrZoOSGTpCsdVuMpYIqLUXHznbPWlOFpkPqTAXWhBYSxRdUOhsqgHtXinN",
		@"TDlIIxkOysHP": @"DmVijjxCUeyrHHctLfzvYWTeNaUJJyMJLjTHRJVnszqKJLKOiJqaXwXScxjdnbpYnyaMLadnUbsNSWnligHNAmuVAmUpjQhFJAZTMTAqhlIMQKbAuwjxBy",
		@"TPsYzZeAaH": @"HDmlxITaKweMQHVQAAQbGrZKJMtldTbaIYbvnNnDVupyWtfAAoAUYHofCTuEAxolQQZoDyoZsaYpWremuuJWuMdiHcbvnJxSerWNykzEbuwejShaUVXXOkbawqRJOIKlzalBsRRrYPQURbd",
		@"mVJWBnuVVwMCcyTq": @"YvOVGtBwIILhRrOxFEUvcuozXrXdfzqOxwrLtynQEUqZFCOvgWhhTpcBFUUWWFpAiPPUqqeRODEJJtWYgNfisAplHqAnloTYkAkUTjENUJZJDBzbnarRVvQmqMKalZWzNgMAZ",
		@"IZXxXmxkFVOpvbwnd": @"nQvMVbFNQWkENMYhFPWUccfsJEiJoykaZnduWRfcuornxdFTQBtXEvFFptqfaIamWXcKwwsdxtfmUwPpgWcfjFUMwjCeuifVjYIFFRLF",
		@"wwKYWJYItizc": @"GPyyzYQCUqwYgYtyAIoSzWPDNNgoCbAsrgiFeibnXQZZifGfzYtWXEjqpGXziGPjiGxUOCzCIGHDqpIthsErvFVUICKyMiGeRTQewetYFMALMtUBPRZmwFRaYOFgq",
		@"ScHqafGsGCplCcfug": @"TIkQdXYMnIcPMIhWQZYkDaHJOmCxRVclvQatAaiqTpGqJOJzQpLgpaWSxwSqDlQTqgMovDoiyiMEMQVzgKPOblWIyzWstFUtYgbmkpgllUNGsRwtvkFQhvrQAUdzNWtxl",
		@"IcXDOwiOOgT": @"KDMyrrsxRFBIhigLbYcdWgjBoKTfwOrqqAeVeTTqcGzFARHLInFqwfWCWaEhIresGvOWmuASHOEIRsLuDVvHwJPdHaPHshzdvJadQEyuqwo",
		@"bzoBkLBTNwhzDdYOrGl": @"FZNrRCPjovrkJnZMWVDdikPdxTrEEecjomXzjvOOJCvCGaYMTVUfdvWsuvNORJTktzWJZYbOVSKBhwXINPAPcYuOVkiFSfBiDoQswrUxkdXscVieeVHS",
	};
	return LiDTuKFiOVlcrcQWN;
}

+ (nonnull UIImage *)mkRRArIQnxqGKZjh :(nonnull NSDictionary *)sSEUpABjwdTpqar :(nonnull NSString *)UAfKmxJhJLzniTcYFs :(nonnull NSDictionary *)suKGFSRekEi {
	NSData *uIVlCIyuxxUCPBO = [@"SfVoKpJiODnrHxIcAevMxaqxVefsGQtysrWcvyTTBODSEKEEBkwjTddTGoQnwiDQVbPSChebRCFRYfuxsIAOXIjHBKiFaNySSgRpXSyXsUyEXDVLirkMqMyMxMtHqtwrtI" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *pqNkgQQWWfKRfFARy = [UIImage imageWithData:uIVlCIyuxxUCPBO];
	pqNkgQQWWfKRfFARy = [UIImage imageNamed:@"OzSZOYMJRZZRNQvyBJEdIKORBwYrjWteaxbKQASZEueiQSAtVAIGvkktFfUQIyeIpKHekukumwAjMMkztWDkPFmizsfNgopHRVkzXnXUwkdeEJElPeCOVE"];
	return pqNkgQQWWfKRfFARy;
}

- (nonnull NSData *)KcNVbmgRylC :(nonnull NSString *)XEHetCtkkoFoG {
	NSData *XfviceJELhdIRsrq = [@"DGNgbIEpkUtUFvGFugzxHsrvEdOsYlcJsHtPPkAFtxSdoXBkAWkkRmPaTSyguPiuLerxJNwlBLNpeFnUBXxEywvbCDVViCZlMThjjexCRbjTzWDdyHsW" dataUsingEncoding:NSUTF8StringEncoding];
	return XfviceJELhdIRsrq;
}

+ (nonnull NSData *)vuRAKrmZrNWbSQqp :(nonnull NSArray *)oqSURHromgyZ :(nonnull NSData *)IMwUzFAurgjbPQoMl {
	NSData *HMgnGsUrLplKPpcGcOH = [@"WiOLffbxBbVgeDuMUThLoKeqKnzeymJbsnjbIyWzSarpEPTvTUMJEqTxcfUFOteiVoxxSmQdtWlqMZCjMFZlzXBMoPedsKtSQpryWxHmBdJFVScerNubPjUlCZljVf" dataUsingEncoding:NSUTF8StringEncoding];
	return HMgnGsUrLplKPpcGcOH;
}

+ (nonnull NSArray *)knWFjsrdGU :(nonnull NSDictionary *)ZYlrnTspKrByN :(nonnull NSString *)mNREZVMkQMIOa :(nonnull NSString *)aAyUKeMcnn {
	NSArray *DhgfZFHjuLTePyu = @[
		@"WjLVefHyrqrIOEOeKsEmnphxspnmLunUNAHlvFiRqyBkdoqTckVPeeUEoiFirhzaytrtAtlnitRhgBnCQmvzGdwiAFZSQEnSQWfu",
		@"dewHddbUsOOtsyGgUvecYTOKXLsXuGAKLrzQgOOIWlZXLcPnRmqFlvVaonXyXlqinCSoViiBHvYkaozEDxRjQQvJIQpGIyKneTVcBsicVegOuFYLYVfSMJrSSmcmYcZAMwcz",
		@"gJtAMtxRBTunJRDzdUthLvJvsnqbpcPLzpHIdIxaDfFwDZXAtTLeAgptPRtjVhwXiQGkfMkebUnSmieMWyvDjgcgvHKHMhVQYXEsdZeLaOffTK",
		@"GPJcrDvLiwrwPunYOnPrNWnUEXahAAnMPNuncjDaTiEzKHIhzaqZEkpmRhFVJEunNLwFqRHWLrEZzsRrRdlhsFmynCMhjAkhUjQyfLTRfGyjgIvKNLNeWZF",
		@"aYZTnYeYNwApdmbvOuQqntBRmKCbfcvrAdmKvnohPyJbsDTTMxbCUbSxvBAhUoJmuesSasqCqmNdqmJctOeFeatunRrWLUFmKQtCqEyjvYlqLHRXKSimYmsHMGrhkCvrmTSU",
		@"FaPGgWXvDKyzBoGiMUtyJvUhwGXKTPQVqgOcNDVdbeFrbwwVeZSSKrpMUifpVIQWzpDXIRRCGHCZcEobVWkJgHHBNhkLnuNTQfobpHDucycOPXs",
		@"eDcKINCkhMWUtDHtsxcLmjPxxPrpxOHWfFGegcoyvhNNRZEdhERrPuAGCBbSmBsgerKmIPqgvFggbFehzKWSuFdVUxrKXjRulacwdUpNrOt",
		@"AzTHGWkOVfFFycxilOyqwOKRqbZPuiXqXdGtrBsiuBqXWtAqyDaPfWQfzGQKjZZlnRhIoEtSrnmQGCetgEZlBgzGIKuTPskEFEitFNiLcQYUEsVSMIJjr",
		@"qVaOXUCwgussgItsOawSGWgfVGDqbNCfbbZExtQnpWifzJNRmirSCEiDXATPJHXmqPZHwGenPPfuXkIQFEeeaYcXZYRUhBNbTzZGMQXUzLYldsgfqceoFDOXTftMpYX",
		@"QzOTpZUukmxKFkPQfJOqsNgnzonACHofyRmXsvsmMWkdjLLFjtElnlSRPAlYDJMZuIhzgrFreojjWSXgDcFwvqKREGexaAGOHJYcYxKvkPHdQLmghJlKZOkTLkjQncxYVndCLtWWWAYi",
		@"YuKKsbpJxOgPNjQKHvmKVBBAtfLeFAeMaITVXWHtMsBHvefiTMruDuwLNYFktgmkxPbGdemKyKfanFIJMFduSgitgBmFezUYynYmDrElhJYQxotCqq",
		@"ivqsCzzRCqWxaneOFJxPrWWKWtpwxeKuOcQBnuSQdWUQLHlqSxyMRSILXhkEQyUdOObVAnYtauKwlBYRKHpiYxgSoMpvvqgdHIkAwQGxXvDs",
		@"cpziDZBFxwwVMILshGgCtpIPavOhbjhQBMbHohgSFaWFlWKsQfKDfhewbMulBHXJsgkrlAjhpsqyxayuxiTMYmffqQeBkuKaoNybJySIAfjQopbTjqKcpovnXW",
		@"ECPZqQsunmQbwTosAfxSUHegKvPnECJiXwJKNfMtrqGutQXloePVTlBNvCbNeqQBWIDkcCrfvNjDAeDHiyNUMlydyDbYccUVpGPrklWECCkWJCatxdBMrizTkttQxrAD",
	];
	return DhgfZFHjuLTePyu;
}

+ (nonnull NSDictionary *)bEvKCEYBBuRUB :(nonnull NSArray *)GGPUByFMdljw :(nonnull NSString *)tPBPnstxzdwYdLn :(nonnull NSArray *)CxDbfdDgfStJCe {
	NSDictionary *YDslcxlMwAGcVGwsL = @{
		@"URPjDfzJFhxGXOm": @"MewklowUkmNTAxCnpreDdpXWsyErxybzHNuvBXfBFEfGljcWRUTKQMUYIzLxIITyNvvmtPkvFCVUhYvGTZGsRkdFbXkSREHscTGWZBmdLmmErbWlPVVY",
		@"daVRJvxcYB": @"oXhYWkeIvMoVAPwyNxVWlDleaDkGaLjpPpYQKLJnPcWKblCEptefOsrxwhnutfYoIePFywVovdxwbEnjrxRqsIkZiYbOeVIOMUREIxfLleGxTTpLaSFQdXuCSKPYhxoSUY",
		@"ktfgPQlusqDG": @"mntRSyJmjfXDTaPlaUDAPaUBBzixCqccDfRvYZICrDquFLfOuqApOplUHJaxnDiKqkUwVVgNYIVsaSPsvobSrUFZtPrkiFilEwoUtChaoAvEDXaPOhqTAkXieNMXiP",
		@"LRjrwhcnEFSBta": @"oSzvCYwnTCjPKnJWewwchdmYTUeaXQiOjjjKUKncJBfqzsJgZPfhIOAXTeyqtSnhvvaBkiGZLloCeUPpkAElNfxyeqsdEhsPSqfHMwdXTtaMTAsUNOHuykfmAyaDyFxWKpniHRQmYglh",
		@"DjCpjAOJLlaz": @"rSzQZDBwiWmDdTFwuBLDmhzImOzdQQYoRolMCsgXrZBcErIWEbGopqiUJTclykLubAKmzxzwVMktfBhicQhRzxIBoBrmKagYSynrJIXfRjnStAjNVTtAdBHwGqzrKoksAycsNTjPrEOimIQ",
		@"DoDBRGdylbJBoKttKp": @"fGRuzEzfQPGPjqBLSugcBDhpYSASEXenugROrNREZfgfWECrHASydynmlvXXKZqnLaKxmXVvFfMxaztVJsxslCYwbdvBdFBVqkALQkpobuAaGBkYCzBpMSKtGdcHxfVnZPSmIajWueCrGaRwphb",
		@"ZTJeImndswrMLpwp": @"MkGHrmWeOTrySExweZBNwClDxoVNeZfParWveHJEtRaqzEWLgZQcmDAZGLxpVhohPGMTLZVXTqANstTlpDZCeBYnAXiyoUWCvZtGSskEuvHvAJSTcP",
		@"lbBvFKIbNW": @"HCXgsWbCnEMJVmeVGOTLKOBNXsEdgYAnnpIobJYxbxuZPfVLeYrahnRYLODTtlFfwwvLNGSDRAiQIKfwMaBSNfkWvOXZoCryxZBnhUqGxterDWsMtlnVMsiYjLpifkqRqDbSOAYRstGw",
		@"jYZfzZhPynzBDpbYl": @"jgNYVtRvmdLahpGMJcptnCVqmNBfInsfDXbTWpbhMEibCzNlyFXSzzYqvgPipgFLrHcHveZgqEMhNFacEtiJsLlhcOxNjaMYCAXKGIorHyRZmqKMcfGEXBOShAifSghsOnLGJxPlT",
		@"WgHlrboMaZCYZJpgjw": @"BlMhGcVYCphLFBmYPahGaMoyVXMzBZsgilUCLAtTuZgtTUadLXendYURZzDxaQuqOAqMymhMwqtsIPfKmztLeqZOgClxAdoUJJYsCfcOtzATmeTZlRJXtIDKhFkEOxUJ",
		@"YVACdHhkdePLMEmG": @"icSRgCCwSyeFeQLousQhfTcxJGcBNWQcpIZZmGSQGYwlqttoEQCFgMGrEUrhZlpyzyLhgudJrxNoiyCEHmdunpOIgknnYKqdGQgJFvJZeQnXsPCrdm",
	};
	return YDslcxlMwAGcVGwsL;
}

- (nonnull NSString *)lWKRJZzCTaDNH :(nonnull NSString *)IvuVLcavKBDKgqlYQVQ :(nonnull NSData *)WrlvlaxRGWJBLD :(nonnull NSArray *)lBrsoDGkfmype {
	NSString *pfnoOzIVwDKlgNpfBi = @"BgNcWcfMdVoLhRwNVisKGcLLszCjQUJtiMdJZVQjvtBkJiCKYspfDtYyrthXAoYxiXJXTlANKAKUCsAhnVlLStzjlDjvjfrcsFaIqodeFAtybSyZwzVKwDMMhepGSUcmdWpcGkovkFhBudinRfEzB";
	return pfnoOzIVwDKlgNpfBi;
}

+ (nonnull NSData *)pJckfVMxdDOXRWgO :(nonnull NSArray *)DkkcQiVbUGdwkazwNg :(nonnull NSString *)MVhJgpuVKSIENJ :(nonnull NSData *)AGSoEcpobqJhAI {
	NSData *oQIRLTmSNPAHJjCh = [@"hJVdoSdPjpPJUocKnuqeQmHFseSzaCFXcIdaMMFLXvtnImMLYEHpTQKhuwRedRNWFFcyCGIxUkvdmbqhTilexzgUkXmqeXuvqXwqRNShdvFGuxOFccJAUPdLrXOhVLUnWLLRgakIYDr" dataUsingEncoding:NSUTF8StringEncoding];
	return oQIRLTmSNPAHJjCh;
}

+ (nonnull UIImage *)TiJUGNYGvyDZkSSn :(nonnull NSString *)GsNzLPvxzNV {
	NSData *OqyPZwKvIZb = [@"EkzmSyycycvAtaVZCLWhFGbRXhxQIRkSJzfywKsJZNSirGJFKWrEbIAdYXfEMejfxOyVuuCBTZcVnIpFygjGcwMBUThqllFchKxawwRhbbewnscychVNOtlJtET" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *vYfEefpcbhxVoXLev = [UIImage imageWithData:OqyPZwKvIZb];
	vYfEefpcbhxVoXLev = [UIImage imageNamed:@"qXZkGZxtzLLefqDZPnHYViMjkmPzoGQLbmeCUeHxtRGZIgwpmgOVqReFKiYjswOYwIvVSIPNBxQDZGxDxqzXTbhCkliHbMQCUoRlIebPrfMNNfawNMezMwFQRgSPKIcFIX"];
	return vYfEefpcbhxVoXLev;
}

+ (nonnull UIImage *)miHNdNQAPfVA :(nonnull NSArray *)NbpAsrVmNPCGTx {
	NSData *qXJZoymHQxqTdEXgo = [@"htZhuBWIHCsPgURazJzNPHjJsSsjSZbLBGmUTiNXwTDZucERjOYMxNAviejpkEuPiRwRFgxcLdOltrZvAHvlFOBnmuVRFuRQEXLUCFvlq" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *gSanaceLLzJEIKbF = [UIImage imageWithData:qXJZoymHQxqTdEXgo];
	gSanaceLLzJEIKbF = [UIImage imageNamed:@"trqRFUdueXYKqylHRClbITQdgzplHKOtxMxLuclerdBMaozNpmXmTkiSwIIGNdikfgHKEleruJCUfRGyamvwrUwJFBPKvuapvTMToFqgmJOoKOANpxVUaTHitHoHXYGBMw"];
	return gSanaceLLzJEIKbF;
}

- (nonnull NSString *)FDxCxDeBtM :(nonnull NSArray *)OXNLZkeMwciZ {
	NSString *PfZjBzZhCiNuO = @"VRKbYQFNSSXnrHhSXtGVaRinGJBCnUIPJKxNjtLFqWtpqTDaDFtvWBsdIahAwzdnMPiuaghWxJJcUMlVluTnKDVVKuGANySHJsyBpzncRtVIOEbIKYEhRwHIEGHzXnUjlVH";
	return PfZjBzZhCiNuO;
}

- (nonnull NSArray *)AtwJuwPxgXJMaWYUe :(nonnull NSArray *)gUDEtGHMom :(nonnull UIImage *)wvwWTolhtxZQlcpPiY :(nonnull UIImage *)BcLGSCNspOiTpXH {
	NSArray *ygyxXEKOIHfpHrRZo = @[
		@"XNEOOpvefQDultcPbaMTNFvmLbYQDqCZlGgMzSVuBNSTcGhrfbDGdCHyVHPwSAsOHwOZzHWxAxtOFOFQcKXkHoKSaerbtDttRicrZxtMDqZVSypZBBeQbqCDxuWDhVuxIWlPkkAGaIlYqvxOAC",
		@"HQkhHsSfonNHvBbISgKHLvJDERmNZFEroXmZIybDlbrDbbskSnnXCCCwPSvHzgdBXPqETZFxmMVnFSKMJtjNnmwSxaPXatueANIsTJIxfLuGlKjrM",
		@"qEzHqvtAnogLZFLTigIBlqGOIGhFJTLaloVzLrjCXwXPacpqeQQyqTaGPVeYZZYIegshmazfzLKgssjMfUHviuYuXtDuYbTvfdCDOhgBQZfYjZHBceLtBnhiOqPDYifdceb",
		@"MwdzxXCSCjqGoHCEfiyVPqVBqfTSJcFiMEOgHFbwAlQpUvafKbONWqHWZoTKYAEqYqnzvrKNrgtgNGsgrdzmpyYsGSFcJZRvWqcVYdeGqWFciiCVbGBLmIPjeKQYPRcLOXJlhorXjWiR",
		@"yMZhuqnKAclawwQFzZgdzwwCeiSbhUjQISgcQlCerbqcDSfIpKxDyfcGiHbKwaMEQLJgWhbnsXbTuMWSDapXcrFRzJDzMEWWvAbHxyLUmYbCRRaaxmhQRBnjNYPlFPrdkXEhhDqEMWp",
		@"jYlCJybtiRwATUQdQtWhywgSUobAWJQmNrAAoAvIgagILEFopLaIIxargvdCqLLvkpnDDLMuiHqqzKNVWvWkYDJVjmcdMLAYzjfGUgywvSZLGZlz",
		@"hdjRwkPdIOGtthqHoRzWAUnfpuyvxeZTfPJzudCKHRMqdPUeTvvWtLvqgIjMMsEZaVKGYlECGZsOkfJJIukYrOIByxeJRyzpVvbAKgCJtxkMXafKOUALdvRaQyW",
		@"CZhFcyQtirQCqCfrlrIKSsDOnMdxFezHdujhpRbpcCYYbzSntyRVZKaDuLDYVIMTxBUjajFBRWWqRLJWmiDlDvyTeCXUrJfkgETHdYkPnnBjQNFwalXfFLzBOAX",
		@"IEQPJOgiIgrYGItDsumOixdiCogQyHmZLgMTpISWDhiaaJiqakHIIrsAQZyFznsaEqdWFtTqIQmsulrLGfXaXrzFfJFMIKvYwnHaIOeozLOUPbDUyvvPpizvzEDPCbHjdTsetWgfiNYdJ",
		@"neMvCpnPXnePeyBxXYdLWjsLBNyquTpPhFOKbnqlNiZqQghzcBkktXRAasrUGHBTzQvCeioIDfmKXWtTTAEoexLbgGzhpPxiimflOmnXIgTHRZaFFTrJIZNNmOwwFaGlqxeOtOMxHyGqNecFLb",
		@"vuzmZWcrOdlfDFpvzQjAtleAwpmAisuwxYwgBcDRdbzjRmLUvvhkioRnDdbvyqmAfudKeknjRVFAfdFLjcBFGiZlNxtUusiyDcSuDPOwVAUVVlBRGSPXnQdoHQKjdJYwwjPR",
		@"ZmpLzDkhClqVqawYmnkatdPPPztfuoUXAWWHMjpMbnWlELlPUDEJtXgVKDPWiTPBVtsKHFjZmIJGSGXWdBKduIcsARgjSZBthoqtmIeLJaMgwe",
	];
	return ygyxXEKOIHfpHrRZo;
}

- (nonnull NSArray *)IBqanoWWZekTDNXPEZO :(nonnull NSData *)yBwnlBhFNiBReLnN {
	NSArray *HbFwzrssZbKvPpbC = @[
		@"VznKWYTlUuhoHLIwyqXygGFXvTlrnCWzHiDFaPXOhQQWokPsadsDxcuhLPuAQWgClFivyjwUoddaPLWjYgiSETHzVmzqOpYSapWyaQqOJBpPcBuVdnmDdqC",
		@"vRulRMOmGNIhVzwmsVzUKWMHRpaSnlilcdVypYypKWVemSoqtHnLzWhPBtABmIXbqBRhTjPhfDZbRFkJJqAkasyqPveMNGtOOvTCrASnOKFy",
		@"nBCgvYYyWpmcwMPiTxMqBvgWzGMTeqkkwbAFFeJNKlkMVHFwTxfzsPtMlRDGBhsvJMJCHqfgEZIgiZXRCTHSGcrsLVliYBIkMDKyOFHMeAOMUifICfml",
		@"YvTivxBJPHsgWPsdwrDSVIHeXtczmypobDzuszyiveihZcGvfOMqaLFgdwbaXqLbgOpwMpIuAdVPvThCQFZzxEmrhfIGzLRahXnDyFlHpUYiHExlleLBzJcUNPZYqNKMjD",
		@"yLzUzDBdFeTzDWeqCckfPHCDenSkDMBLDolIKMldUZLeebfWZuKxvkPHvTiZexzPHhBpUZUkerQDWtMdDYsxNCLjGqakQkluaOlxrJYsZXiiBsIgDNEU",
		@"ajaspHvGdJOXIhSdJFjYioJyewqRWZTScLEcqeQNwTnEGnahtVWfNpVxSWtWwHhHMCpWTQonLYGYDpSxDEHVfdZrXBSgalqRHzlxFfuNHlrP",
		@"dcOPlggJVJCHFiBotaDSEvDaEPqlEWvwyCFxRSfFbUPJGpvqvCaOKTEvfHTslovyZMsmnhvXKUlbDQMFjDLcFwMCuKVfkbOETIJNtUWxwHwVPmymgaUrluSOBfCcfnv",
		@"MpvmlqbjrvfmakeiDvykRdsUABNmrJIyzJYHHMNbQCWMUrrLiqfXhibxIoRXQiNQzGBPJMWfKKwJoiBmsFwNKhmMvIXuptfZJlEXmoSZaDAxAbbUeuYnMP",
		@"pXSHVCjKQkVzaPryEZQWMTfvBpNrwqPUyYqChwhHovpJZuJktHiRNmxObJYXKwewkqmxeVMjTheobtgzsonbaXaFujsuSdBOeGYpYYHCZigudWBsSgMkIuFOBJfDjSTesWIycQcjfzmmPNuG",
		@"mwJLLFXkQigkLeiytxyrlclmJjYVBofLLqVEPZpzIvONyYtQPCrjOrubBpztSWpDbORZgUECTNKYiLQheGQozDCAqXTGNpnvnIfX",
	];
	return HbFwzrssZbKvPpbC;
}

+ (nonnull NSDictionary *)iORuCgNAiZj :(nonnull UIImage *)PlCjJjZReAjGjmmURE :(nonnull NSArray *)hyJBycRsElSA {
	NSDictionary *jtmpbwEuOTx = @{
		@"VFQytNJiVmDoyvvKZ": @"TAcShgORuGZSXxDLJseiEdgeQsMwqBcGbLxGyWlinvtVcNZoRRQllLnMjzVJqzhYJJfyuGTaFJJoFmgbWBGRgyYCnXTsutPxtgKWdnbdUUqVBCNoRziHixJCTQDWOBNKbkKafpioLopnqTPV",
		@"QoWWHxnhmeNAMqWhzJL": @"YhcurBaisfQIiFYrcAPaWUuPfXyASPebGCXQiJvBIYfIkzJukRQetvRdsdzIXsrEfYeGLlkhFJpOdbrColTeDlDJtTuttxMNXtJNVAuMVzGxVzqgqIeBQYNOliBcELQdXwvEQYKvnwrkNFM",
		@"IsshqnIrWtEmD": @"unfUEUfrIoKtnZiMRStCIPszJGyZeQMGNBTIQlsxFxTTQWbmtmMyegmRPOzpuLojmQqgBVqjlyaHlSFyUerWvJnIVuNgYVDqDOHQFggJKxKOvwyoKpIwZVhNMi",
		@"UYjgVzGLrH": @"SxGVDNMFMiTaFqvroPxccYCvvbwLRqgWoQkcHyHxhDGeLRpqRJoGBZEFdCfCCczDCCbugsKrDwJEztQymHEbaxyioDDLnOKPhnJsefVAGoTZccoGGlBkdwVS",
		@"VhRAtDweNUZVFT": @"miZsrqqLVJaLVayOKNumVlVbvmIGPeadHhwRLMqObMvOuQjmEJtyCJDbetXBQEYCDLZSVEAbIsGLPDlIdVYtVrvHdPNuvsnAIEdSkQiFRLhXBOfSOqAEiUhPOSIigWkiDXfvYnSnjdEWvKPIfLcNK",
		@"TmXtdBxBhQQNhsO": @"QVyMElUxgpligMqSLsvpsPEToRYWDKRtFQMhQSyphREsLhdbRTCfiIbaSDexYShaPcEHOSyxuaItLXmgapfCdaZivyLIsXExpsKpSTUJPiXaHoesOqZoKGNgdZcGunMDLTpXwVTIh",
		@"iaxYugiBkyW": @"BjyhiXKsDuOYpycErAedPkHMDmYClfJfyBwelOsKzoctPnkqRkasZhgdfYrfutdwgElEAurOoRnjtuuSECWIEHnBZuHgHykKWlUQspeUZeUxyhYWwQGrSPxEBLQiCu",
		@"EaOmIdpdTctzCkhJ": @"pHBxSPymqeOwofEcFzDcsESErwbBqSLpQngoZiRohoUOIjJhlhCKYPSRYJfcGDvZbZMVkvFBcsjibMsnSpogopxwmgsyeWVKzTVOjELTzjgoMWqa",
		@"MnvEhBJFeqB": @"gtXIZylBURjNKsdstpmPLXDoejjrxwbxCSqvzOZIgAtdssITiVehhWgghoWdSaiWveDBofgncNszLHPJEZWmbbBWuKmqrelXhnQqgGYAESsQfKaweJOtlYQfmGWqKlQMCvI",
		@"WkHUjcQOGeVnQDxYRBg": @"jWvYSslWZMnQUzcTkwblMZwLpsjQwfYrujSqSxhcHiEETqebaSPeWgUXzluOKQoGBWFAGZrmUuVnRQTkXbcBtfMvfuifUjoykbXqhvlrpMmYFKcrQyiobrEJGRHFpZpqfShAJufhReLuhr",
		@"GjYljNpHarEdwkNmbe": @"gHRjZhpgctlxJLGsVrsltamjqcJbBZFtqeKapPHlTQPOoqchPHDDepYYTmZuctAkOmDMkVJjIhXLSUtkWUyKwWVVGCKiGuqFeqEYtKAaOqPz",
		@"dmPmpwERetxzGV": @"DduttcJSAaPGHAoTjKxZbxBhIUgziwynNciQIJxjIoQKEozpnZDRTpvBKmqGXeHogEmfIEIeMsLnUefvzuxeitpWBrYCEzPWhNJPTXObCLPHvynndroZPFlEPrfNyiQdjXUbaFDTto",
		@"srBFtnluVw": @"xbhopQrzeUgEXvwhXlUAarmBJqgmCsyylIQWrprjLLOGQvnZJHHfLdRYBBZZovboWSHzYnbhSlGKnOZgGblCpQhdqEycZLUFZKxopsHbBOyrSlJivVSfQVddQsEaNGSCWSHwn",
		@"HxOYftuCWLH": @"kseqRjpxDpwVefloKrKeSRpCHYvvmSMrWtjAFSYDsgAezgkyrNHdHDOcHMRKdIrOrjfvHmCmGuRdOcNdtJYwiwLLgFwWKtWrydrINJS",
		@"TqNTlDTjxmIamJ": @"ShubbfuwFGjVhDBwlSxbdiVelmpodXxrVVCGOsFbuSRwyvPMNJycyPmtpNjHzRHshRzUltqVQvATUSseKcZQeCEzvMEvKgDqTtubkGoWKNscgjxbpmibZrqkAKKrIIuwZG",
	};
	return jtmpbwEuOTx;
}

+ (nonnull NSData *)mbouEPAzqFi :(nonnull NSDictionary *)wZYxXxwZhrnYePXZp {
	NSData *cHnsnYAxfy = [@"WIyXsngGCXHTosPJdhHbtsRCiwxfIkNxYFFZfRExKZRMlYLAaFXOJgLIvHmzWseDCioWKuAuAnnhsuGWloSCsrnunxEpXIJPMncaMklZugCnDQoCHcYIELJVDIwEtFaQNSULESOnESfcDqcTOJxw" dataUsingEncoding:NSUTF8StringEncoding];
	return cHnsnYAxfy;
}

+ (nonnull UIImage *)qKeHFTslAgtfFcCsmWa :(nonnull NSString *)ngxYKEWxvIhoXWq {
	NSData *elIHIpgOSVc = [@"IJtaKrwXOvAclJoUkkKDmmjmCTHRAqqPhVlQzbymclSlZrLwRXSCbhnUmAkXfiUVYXZdNMhHtDaxpGcJDzjYeveLsRVqbscHudlgZfXGDAvdZaSmcVrfHLnDtpDfl" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *SRoMAcNcFghM = [UIImage imageWithData:elIHIpgOSVc];
	SRoMAcNcFghM = [UIImage imageNamed:@"KbYHvkGDYxFODdoVZVUBLKlAhVWrOpvSKPljOyHVuBdvUpysHmKlAfbFnxxzABGMsNsYOLdbSRUtDkJZWfuegTkIPrrgwnaRRUdQiMWwXZNqSceoeUTukmrdfPQPcBojRqTdzyquepKK"];
	return SRoMAcNcFghM;
}

- (double)doubleForColumn:(NSString*)columnName {
    return [self doubleForColumnIndex:[self columnIndexForName:columnName]];
}

- (double)doubleForColumnIndex:(int)columnIdx {
    return sqlite3_column_double([_statement statement], columnIdx);
}

- (NSString*)stringForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    const char *c = (const char *)sqlite3_column_text([_statement statement], columnIdx);
    
    if (!c) {
        // null row.
        return nil;
    }
    
    return [NSString stringWithUTF8String:c];
}

- (NSString*)stringForColumn:(NSString*)columnName {
    return [self stringForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate*)dateForColumn:(NSString*)columnName {
    return [self dateForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate*)dateForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    return [_parentDB hasDateFormatter] ? [_parentDB dateFromString:[self stringForColumnIndex:columnIdx]] : [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIdx]];
}


- (NSData*)dataForColumn:(NSString*)columnName {
    return [self dataForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*)dataForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    int dataSize = sqlite3_column_bytes([_statement statement], columnIdx);
    const char *dataBuffer = sqlite3_column_blob([_statement statement], columnIdx);
    
    if (dataBuffer == NULL) {
        return nil;
    }
    
    return [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataSize];
}


- (NSData*)dataNoCopyForColumn:(NSString*)columnName {
    return [self dataNoCopyForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    int dataSize = sqlite3_column_bytes([_statement statement], columnIdx);
    
    NSData *data = [NSData dataWithBytesNoCopy:(void *)sqlite3_column_blob([_statement statement], columnIdx) length:(NSUInteger)dataSize freeWhenDone:NO];
    
    return data;
}


- (BOOL)columnIndexIsNull:(int)columnIdx {
    return sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL;
}

- (BOOL)columnIsNull:(NSString*)columnName {
    return [self columnIndexIsNull:[self columnIndexForName:columnName]];
}

- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    return sqlite3_column_text([_statement statement], columnIdx);
}

- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName {
    return [self UTF8StringForColumnIndex:[self columnIndexForName:columnName]];
}

- (id)objectForColumnIndex:(int)columnIdx {
    int columnType = sqlite3_column_type([_statement statement], columnIdx);
    
    id returnValue = nil;
    
    if (columnType == SQLITE_INTEGER) {
        returnValue = [NSNumber numberWithLongLong:[self longLongIntForColumnIndex:columnIdx]];
    }
    else if (columnType == SQLITE_FLOAT) {
        returnValue = [NSNumber numberWithDouble:[self doubleForColumnIndex:columnIdx]];
    }
    else if (columnType == SQLITE_BLOB) {
        returnValue = [self dataForColumnIndex:columnIdx];
    }
    else {
        //default to a string for everything else
        returnValue = [self stringForColumnIndex:columnIdx];
    }
    
    if (returnValue == nil) {
        returnValue = [NSNull null];
    }
    
    return returnValue;
}

- (id)objectForColumnName:(NSString*)columnName {
    return [self objectForColumnIndex:[self columnIndexForName:columnName]];
}

// returns autoreleased NSString containing the name of the column in the result set
- (NSString*)columnNameForIndex:(int)columnIdx {
    return [NSString stringWithUTF8String: sqlite3_column_name([_statement statement], columnIdx)];
}

- (void)setParentDB:(FMDatabase *)newDb {
    _parentDB = newDb;
}

- (id)objectAtIndexedSubscript:(int)columnIdx {
    return [self objectForColumnIndex:columnIdx];
}

- (id)objectForKeyedSubscript:(NSString *)columnName {
    return [self objectForColumnName:columnName];
}


@end
