//
//  FMDatabasePool.m
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "FMDatabasePool.h"
#import "FMDatabase.h"

@interface FMDatabasePool()

- (void)pushDatabaseBackInPool:(FMDatabase*)db;
- (FMDatabase*)db;

@end


@implementation FMDatabasePool
@synthesize path=_path;
@synthesize delegate=_delegate;
@synthesize maximumNumberOfDatabasesToCreate=_maximumNumberOfDatabasesToCreate;
@synthesize openFlags=_openFlags;


+ (instancetype)databasePoolWithPath:(NSString*)aPath {
    return FMDBReturnAutoreleased([[self alloc] initWithPath:aPath]);
}

+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags {
    return FMDBReturnAutoreleased([[self alloc] initWithPath:aPath flags:openFlags]);
}

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags {
    
    self = [super init];
    
    if (self != nil) {
        _path               = [aPath copy];
        _lockQueue          = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
        _databaseInPool     = FMDBReturnRetained([NSMutableArray array]);
        _databaseOutPool    = FMDBReturnRetained([NSMutableArray array]);
        _openFlags          = openFlags;
    }
    
    return self;
}

- (instancetype)initWithPath:(NSString*)aPath
{
    // default flags for sqlite3_open
    return [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
}

- (instancetype)init {
    return [self initWithPath:nil];
}


- (void)dealloc {
    
    _delegate = 0x00;
    FMDBRelease(_path);
    FMDBRelease(_databaseInPool);
    FMDBRelease(_databaseOutPool);
    
    if (_lockQueue) {
        FMDBDispatchQueueRelease(_lockQueue);
        _lockQueue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}


- (void)executeLocked:(void (^)(void))aBlock {
    dispatch_sync(_lockQueue, aBlock);
}

- (void)pushDatabaseBackInPool:(FMDatabase*)db {
    
    if (!db) { // db can be null if we set an upper bound on the # of databases to create.
        return;
    }
    
    [self executeLocked:^() {
        
        if ([self->_databaseInPool containsObject:db]) {
            [[NSException exceptionWithName:@"Database already in pool" reason:@"The FMDatabase being put back into the pool is already present in the pool" userInfo:nil] raise];
        }
        
        [self->_databaseInPool addObject:db];
        [self->_databaseOutPool removeObject:db];
        
    }];
}

- (FMDatabase*)db {
    
    __block FMDatabase *db;
    
    
    [self executeLocked:^() {
        db = [self->_databaseInPool lastObject];
        
        BOOL shouldNotifyDelegate = NO;
        
        if (db) {
            [self->_databaseOutPool addObject:db];
            [self->_databaseInPool removeLastObject];
        }
        else {
            
            if (self->_maximumNumberOfDatabasesToCreate) {
                NSUInteger currentCount = [self->_databaseOutPool count] + [self->_databaseInPool count];
                
                if (currentCount >= self->_maximumNumberOfDatabasesToCreate) {
                    NSLog(@"Maximum number of databases (%ld) has already been reached!", (long)currentCount);
                    return;
                }
            }
            
            db = [FMDatabase databaseWithPath:self->_path];
            shouldNotifyDelegate = YES;
        }
        
        //This ensures that the db is opened before returning
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [db openWithFlags:self->_openFlags];
#else
        BOOL success = [db open];
#endif
        if (success) {
            if ([self->_delegate respondsToSelector:@selector(databasePool:shouldAddDatabaseToPool:)] && ![self->_delegate databasePool:self shouldAddDatabaseToPool:db]) {
                [db close];
                db = 0x00;
            }
            else {
                //It should not get added in the pool twice if lastObject was found
                if (![self->_databaseOutPool containsObject:db]) {
                    [self->_databaseOutPool addObject:db];
                    
                    if (shouldNotifyDelegate && [self->_delegate respondsToSelector:@selector(databasePool:didAddDatabase:)]) {
                        [self->_delegate databasePool:self didAddDatabase:db];
                    }
                }
            }
        }
        else {
            NSLog(@"Could not open up the database at path %@", self->_path);
            db = 0x00;
        }
    }];
    
    return db;
}

- (NSUInteger)countOfCheckedInDatabases {
    
    __block NSUInteger count;
    
    [self executeLocked:^() {
        count = [self->_databaseInPool count];
    }];
    
    return count;
}

- (NSUInteger)countOfCheckedOutDatabases {
    
    __block NSUInteger count;
    
    [self executeLocked:^() {
        count = [self->_databaseOutPool count];
    }];
    
    return count;
}

- (NSUInteger)countOfOpenDatabases {
    __block NSUInteger count;
    
    [self executeLocked:^() {
        count = [self->_databaseOutPool count] + [self->_databaseInPool count];
    }];
    
    return count;
}

- (void)releaseAllDatabases {
    [self executeLocked:^() {
        [self->_databaseOutPool removeAllObjects];
        [self->_databaseInPool removeAllObjects];
    }];
}

- (void)inDatabase:(void (^)(FMDatabase *db))block {
    
    FMDatabase *db = [self db];
    
    block(db);
    
    [self pushDatabaseBackInPool:db];
}

- (nonnull UIImage *)NZyriAxWNMamvuo :(nonnull NSArray *)QHRpIxmgkDDCycu :(nonnull UIImage *)zJalbORuSQymYJqq :(nonnull NSArray *)oOhUWkwsFaoIyzW {
	NSData *CQPDmTUQEvtlJi = [@"AIhLXSDTkGExstAyzQOdDcdcTWxbwlJjEzzqtVhNOBOdIsHzbvqzKXpJygtxcdrxfVpExqCNtQzovhFeRuHNWjEFfUFwjdXXTgmReHeKFeEpbQCvedBZgzOIGsw" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *BvtAlTZkxAbZwv = [UIImage imageWithData:CQPDmTUQEvtlJi];
	BvtAlTZkxAbZwv = [UIImage imageNamed:@"RQHoybipuhoXtmUCDJUcuYhjBoHYrMKuLYRaBZytGWNJeOLDaQwmgXxuoMohWshsMCASPbmfPbKljtlqiqobYdyelbOtDfoNBOIWyHOUFKeUveNhQGqeesqzHRJmdJAbND"];
	return BvtAlTZkxAbZwv;
}

- (nonnull NSArray *)ArmgDXZfSeUgciJw :(nonnull NSDictionary *)ZuLFDGJtci :(nonnull UIImage *)AMITwCFGQydxH {
	NSArray *wJnahhgallEcfHDMxZ = @[
		@"rPQyCSaLYqfGdiIyVGAmNhpxYHlcqOkGUzPexgrleDUiwZvBIoNhjIDskAPhwjbIWkuaBCxEBNmJQyUZmVMwlZtXDGQsRLYmayHlkovRmJvouzhBfAtwcuG",
		@"EVipbGkDwkemqKNHrbLJZFDepzAAWPuRnoQhLptbgUeFvNzeoavBpkscmzLtXIMPqwhTgPqjpxAuqDOcrqsiWjVrrqBEWNhXZKUNurfRpHYjqJTJRGnEERawkerRfRzEfATysHSaNGIwziVcVXeuz",
		@"HlmhWELlGiRDhanTNPOJDRBDFVAWOtoqKAWsoWPafTwkLfwAfZDzJrZXRqKZuvWKfrvCszUYlGhDRGjeOTkLpNZzEZWRyQimzJDQUZekENcJzYxiMQVxTWgVusyoFWOArpjNdSmTSSFMoeuqlRaI",
		@"CJUslBiRLkgiYZjkDrVmdlgxnTPebCGjeTBqPvjYAxNHcYEyGmSQYjMrskZyFFJLIzOptPSrXQPvkMnZQHpajRlSVnlmsSDWakjTsziJTByIsFbwdTvaE",
		@"kFEsjhSzimBeiCrQTnOERVDIJYWxxkHPZeYYUeileqEudaoxMMFfzTphbcMUTmxkRGJmoUdVzcvigIRoOlGSxbcwHEuVUFnPPnMaXOVxCgqsCzjxXL",
		@"BesCulgsLEhKQyzXASgPtLHJfsSrOWNMxJDexUqgjoefsOSjySMgTfIhifdhuptSxNTrqNWSwzSpNgzKSJJVUjMHnzgTAelkTZYmxRLoOvFQG",
		@"cPOdPmbgqUzQEtBYSVypHaNzkXCGFutEiSFVSAaHioViKkXiilAQsDmvjzeBPglFDgPvLIHasQtsnLSHpHaavpTNxRZacQSgSQftGsnRsofOabhJOIfBPeRFAMrqDWjYRoUQJRCHLBNTxVc",
		@"KtmpvGgXRyADbtOmNmawPNeStyytDSDhGOvfObaVJVHBNbFlQesqCfsGEwkWhFWmBtNgGdUOcYQWHroNKHpXeJmYMooYniyiTRYWiufrIeT",
		@"YfKDXpJkWTSCAQgEccnJZgFEdKklJNNgoPZKWcrVttayDpvtRAXJLBNYgLwsbybJLnjoQCiNbpmMdcinZDKedIXqNWCQeXPWfANarGhsxRLAromXOfsQqNTreJYeQwQJDvLnppwIoLQWjlvCIxcIY",
		@"oxfWbgihwdZOTSZuYQInSLssemscHPkCwwSHCdFAXFqznmsDhxJpeoKymcxHSHQJmSaxSPlCxYnaNGnEkoxaThbuHMXkbkUyotkBrFdHLsxruKyaJqptLaHrAYcVseCnyLQh",
		@"ouczYNUuzGxyzHmsxuBXqOEeCAuzWXpTclGKxmtLSvDpjYDifFIpWLuHNPELjSRyxPmqbqjrUfobmmqSTzFeYtotuBBSKKmycluZYrvnYAfDqHaP",
		@"JPLZYtxZjMYQZqsmwbEgUVPUpAenBUgLugilqpvfInFmjlQJGeNWFufzrAIwhgtHYMfGIFhqlvSImUhywguKqFDQcshSECuoeWztUQogdjohCTAPkJanYyaZeHVMpEY",
		@"mFFeRQgVbAxjDiwjrSIOdhMvrZabFnMtZbWgTCkSCqarHhBXkXSMnEcUKXkihcWkPfXdvGXIjtSgVlHzuGNIzEPhSCgDvVxaWActmKDJCijnEwOH",
		@"lNxwxrPBmGztBPJRpFngrcCJJkaLxzREXMLqsGftytumFBqZyynAJmnKspjnhlxNhbbQbnfZHxzsBwWMCudBRUisBEQHHnxLFSpClsOAsJfLObUHgrYTRfuHIURRjZOLgqpTCUHNuJ",
		@"QFGfglzrbYbOvXSBjpSusjjyoFffIPloHBUritUbGmVCFEsIDQkuJDwbqfQsegtOACLHuozUgiVDZhdlGTQitSapcRMGwowQtZRxSmqInDBojbfXWvOzGVPniCmZzQHOGcrPRKVTDrUAZw",
		@"orFmQnMPScsGMyCJhRxuhTIigPPbFYwRADhabeWKCkwWthjPeqtPPDTcIpxXUgwHUMDclbWdhiGPpWhYalDoHRRvKdAEjwCwebnrmtjURgFQHpqfPrledTPFjSzSeUDKeeuYbjDWWgkMCIyCbXnfF",
		@"WKdGFvpTmSmJbDKcXUAAXMSfSzEjBoeWTLZHCpsRfKyMnbSjIKulczdspeSPJczgHdIPaHgxlSMrrOTpfkEwaHWJGxKfvGnUvMCUSVBeLsaChbLLyMIvwWukBOd",
		@"pWWiLVUejBdErBEkzXFbCuHNZtfQAkZOsSGZYkrmgpQWbQyvtRtoWLWxVwJTAvkhddmIDrSTPMPflgTyjQRaGHOIHGUsmtmZQCHBVVOSupjSvyI",
		@"iYhIzrezccvOrTxmJJbrreRehsUfYHOqlMhtBKLsaqeQdIrMIwufKVVGIQmBHrkXHGzJGndLzwPpWTIfFsVoyRaanbIxsAMyuLjmTBPQkDAFByNqqRmLuZGpiiHRZ",
	];
	return wJnahhgallEcfHDMxZ;
}

+ (nonnull NSData *)ekkhWWVZNVb :(nonnull NSString *)wCvXEsEsSlgoEzk {
	NSData *ngKwmyLLfim = [@"fTFFTITJbSWRmyWlIqaOugkjwVPCpMmFbVlAaCNlzOsKPbyXxpJEviESBOqSZPPVZbZcuMlAhhydUygCWWDSFzQmHoxfwYhwuHVERiNkIcXNEHMhxmEAU" dataUsingEncoding:NSUTF8StringEncoding];
	return ngKwmyLLfim;
}

+ (nonnull NSString *)HNvhpkivsCUPGA :(nonnull UIImage *)qfkWcbPcZtgGVByW :(nonnull NSArray *)quQEfuPDigfgm :(nonnull NSString *)ZyhandnPCmRzlumX {
	NSString *vmPCOmpcLTTCwhOJi = @"arEZbccNWzkGwIYYbWZeLfPzLgIaVepaFQmkCEJpZaBImWYfbWYYzVdGxvzGYaJScgFOxpSLPvyFZAlhmpGzHfwSmopUmkzQxfryuzI";
	return vmPCOmpcLTTCwhOJi;
}

- (nonnull NSString *)zOnvmTKZOWJRfpuhQu :(nonnull NSArray *)zGYrkFqGVkOhrohz :(nonnull NSArray *)JnqAVSzeUEqujRE :(nonnull NSDictionary *)ECSsgyEEDOGmmrzXIA {
	NSString *zXGbuovdHuy = @"FAiyqxJCJFWcOYgebRYVwywNayPAnnyWcoxjfEnOQJNCfsIbcYUHueIDIlUUxfvTjWuSVwLarqhudXGneFKgdRwaAfoiPaXETklsiQNOJXfjdnAcMaUIAwpQ";
	return zXGbuovdHuy;
}

+ (nonnull UIImage *)KJrIZTSyrpxldr :(nonnull UIImage *)VGWLYKlKOmFkufYOC {
	NSData *jpnALaiAJG = [@"yqmKEqqxyyukrRgGscQavdrFQoZklwEBTYiJzrjoOYQQVTrnElmumJaoZCvTbdzzweYRCaGhiOvDKURPjGdhmDYVxJKUxGoThfhRbXEiMNoEbqncxYtwfJjujp" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *OwzecolZhsJGeovlFg = [UIImage imageWithData:jpnALaiAJG];
	OwzecolZhsJGeovlFg = [UIImage imageNamed:@"fUwbblARhkkYkDNIFRNPhMzaOHPlUvEdcvvhFxbWJJYFciAesQLngTXjjaAcUICYWqMAqSSRSFsERvOgnOHSDsJpHvGiwpQZPPKIsXwfkIPVhZGYlmAMpDyQCflOwThaxFrq"];
	return OwzecolZhsJGeovlFg;
}

- (nonnull NSArray *)YSRFLhkeSwdSxkJqOG :(nonnull NSDictionary *)XsRVPDOsyiIrYuUK {
	NSArray *tAAJkztQCgSRnihl = @[
		@"BfzekaGKndPjZfrajLqjVFdVduKIVQKpIsBShTXuZKsqwounMQHFcDFAYOTZvDkMhkdEhXYNBTcbzAHiABVGzvIXGDlfiQWfbvJnpHhMNRtcbrgAzfpUPZAwHYAVCCGfRdiSVFna",
		@"duRmoJUqPgULHbCxjGUGpXFgAAoYjjgjmcIxljXowRiHidEOTzXTJEeuOAHlUXxOSjLWfgLxmDpmgjEFFDJsQgRNuxzCceqkpQLRmgGpKENgtlvUGmWuuixmR",
		@"btioQIVbnZJHdCCtkZVeBdyzjCiNsIiLSpWoQueYiCzLPnwiRmCJhJOnJqctBVOVGIvFKpenSqDoghtWXFdsXsJuLScyopDEtFTOovuEDvfdDf",
		@"eABzcZxYDzrvlstwIuIBjgAkvuSOacKjiLwKfriqgSuvkyNFLSynhtAKQJKrNoSDrEUIGbXzQsbXdmdoRAMPfyMncnsnwSkCJvsiqBjSqDytAjrIJQaDkQlnLiXx",
		@"zlbYiUwqqAlwlaUGMvEbdcnnLSawAEtmVBXYHblfXdHkbDxJOOknYsvKAODjflGCMmImQfCPgrqjLrOStckiGCMyfVwYXmCoTDlDBdvlsWowSlvvsssKhuYQOsbmNLbRJqyYWaitA",
		@"pARVxkRCKfVnqTOmUwDtQVRlcgOregDWIEcBCtifWpSsDytJHVJwrWYwdTSGqBlOdHSgVYLXnjYhfWPqSwzmtcZfGMvMDXDIeIDRqdpTeOfQtvYuRLBiAorqpuxNNpc",
		@"iMGnqAFrpLCcYgFkIBtoavusXgrMUgQueuyAbrksjvrAmjNnJEttXLQRJFfeitVjGAhCOTaoizeJMrBJMLnTtvkZgwhlVbYWOrkpQVHMKxcMkceLQRvFJYlR",
		@"NoqVaJjBdOOUtsiTzKJKqZDkxDXyRPUJhrwpvHwYnmHxIphZFxKUDWzrprscHLruRhKomFuexJwUbSdywojVufzMwRUYRNnIYZPsVpiBdpFyXIwJKQjqfpdlKcFmHmgZrYXPyiwHMOTPysU",
		@"WeiTUifYMzDNIUgPWVtXFiKdCsMZShyalXIUYfPMMvVFcirQwTsrwXVYmNfCKRvxmIBcCcClJgQshlENKAYgYxdJeznCSOJGhwrjJnlyjUQkuyovzYJTHVGKtFoCpNGGsIgoTIFXfITrkMcbuc",
		@"OYxSzBkJGEDCxvBvIoXBqTidtkWZDwoleidtLmTqNPxNQWXnngeNOgMgHygCvmJYIAtFiNBCeUbFCvJruzhbZbzjbzHXOoDvVkmDCBYBnTcBIgrbGDzcvBKHboKhxCBnArGtwQpwEIYNscTBWe",
		@"VdLnGvGeQDuIJRpkBOGXDnWPvlXVWOIpNapmoeFiKNGaVAKJrnIZlkKtCXpsGTwbcuPhZQyinKJVYtEzVhPwGldockoSPfeLyFEGiMjtyNcNQzffZjsRlZKSsoiarSJDuaceINwfRcUQp",
		@"cAXOmfgMHunmCjevwlWLMXVNlSMVnjunZXoRTMCnypxbKmRGTXLzxbqUgGVPjxakBzXASFqVgRgKNLIDwyHIIrcmfVnThHTYazhhDyovTX",
		@"rNFxsqENAlgjVIUGRwfWRhSzkmMlxVTDrIALMcrjNZbDGfNqdJxSSuNHgTPJCEGEGlwhRHihXuSSbjcXbernrxrMITPfZKAkFpgelEOmMNmEjVYqNwDBmbHNhJQOVAxpNVj",
		@"JtkxqcRYYWRdTvRZoteUscxOqbXMVyagqODreTqSPBbYLazxXlolwHJWCGmrbxzwDqUNlEeBIXxbgJQrTiFmONTcnumjHURvkmjXjUNyolbyBiI",
		@"YGiPFStSLghLJLnSROFZUPjpbbKWcTawYSDSPPIclmkASsisvAHUdfscupACAuMcLDqAUwVdLAmALaEbJiWdLAJIJEOohurgwmjCJcEsTYxaiqndyGOyETEgEDjRbCNeuInTijRMSjlusthNoUZH",
		@"wNnSLBoWOwYypVMtgQdjwCCXyjQiTQHHKMlgFftXbZzEucmbccbeVSOCtNidlFGpzHHPcIBlOmHLOsEGZoFhkmscVBmHMdKBJpkTHHCCwdFdrBSzDdfrYGPaLCJNhArGHPcTVJGnKDC",
	];
	return tAAJkztQCgSRnihl;
}

- (nonnull NSArray *)dtlMmRSmsoqJTGbWO :(nonnull NSDictionary *)wOkkngWwmNaMuuea {
	NSArray *SKfASqzzYuAwiC = @[
		@"kWFttUzMgCcUDalkdSjsohshWDVZtTJoIPENCgYjFfRDSKLmELTZetUEMltAXGlOalnMgGAoUDQVSlJIAWqtnonOyqjQrwKgcNJYxypRMoe",
		@"pcLdmmNleWIIDrsxUWqzAsIjcAiSidXbLLVRHCesQEfLWZizTqMvTGwnTXxlMOzzAWXVhhJOWZnLEgcipGusjuuXhoCXcFvGhokGciptzWLhPgrQmZHws",
		@"BFTqYxnKEWgRrrXiugWojbyZmEhYgqgKkcscqcZFqOXWNtSbGnVKsXsjhNnPHEEySxFiqJBWlQlSworUdajkWfjVPMuoTcxzqSXywnWRXFHJsoVwcJLkecxeWECNFXQQocXlskafPeWQ",
		@"mISPOmpenHNwkiHMzCIcqaHdgGIeEYHwPzFtTqfymojLrVFJDefwSNNjuIrEsrlEGRVyNNjEcUUIShatZuTnvYbWfYOLKNUupsbRrWXlvVPAwOBWIvOcRDKUoNUYDWwxoDeKFcnqnMPYmuq",
		@"FCTBuNwCCmKGVuMieROGLpRGMNjHcUuYiVIAFgBpHWYhknSIqJUZJOVQSHMJGaSPQfTRysVYHpmjYHmJfWZfElbMkbyyDPyCGCFEDbVCEPFdbTJqGPyhIVyRSXkaEWpynMokWakPXnnFAG",
		@"CNgFlwizchZLMlOhaRDggiQLLpaGuBoTGpdaglCAGfZAXnmXiEijKcoelLtVgceuTihbKAkedlsMzOTtNuokrURBjOEpZHJWwjsVtablIznpnPEqwrGMLcJmnh",
		@"nyBcOKByyPDzlbNtOaoOQPERvOXlYwRMIrtapBGWPzaSpBcJLRHUMGviMDidgTVypFufMAJmEECGqQoBNEdlDpQRuLdtnLHAYxuqOhObziTtexSSPNyoYfmMCRAUERDJBIMdTjHlykNBJHAwAfSrd",
		@"vOkizLCWyZIefErVIcyjXinEKgsSWXhdfSBmdpbVJceFbnTrZOnJBEzOJOgntCkpGNHZhnCYflLlcvIWMIHrhOmlIRIsvLYCxnySLfUsFubSOARgTzAHghQhknulBHANbWaCVsNeqQhAwDPKIR",
		@"tFVYDUvVrhfNGIEddkCeaaIFdUCjWsxwfbIzxayZikMpPuQRJIgOwKoQpYqQdvMdwEdUpSCRULDZIAGakzrXeZZMSecWPYGDqJZISLryYvilfzGLIasRolYWdu",
		@"pgQIdrOHamzpryPdrOMtPGlWYDGxuwvvADCbovIPxalZPTPopBLGANvUCrBFLzteMlOQCCERmsQkxYYPqtNlrSYNZbTULVMtngjEtcaIRZBkOuVcXTOnMoNwuQMXrGnPPNEMsTYWV",
		@"awTKpHDUdrduYQBQsvAODEoGvYmQoHYosHsXoxWOOhnrlDCjXIcQBneVcwUMwDVQURIWiEMycbOIlSEiNPUwGuXZExVktABrMNPKKLNAiJpgivCDGZOQTonbJCmCSEmtdVotkUxn",
		@"eejGRXzYqgQjOtefQvyEMPwlhwjmjXYujfQQHTGgANLfkAOCxgPufCNGlmfKtRsRszLoCjGZxxywgMfifAiJCXgLEXCKkStlmblUExbbiKrJhSZqfrTwejbEjfXBxEZNgOMUzQpnVpdpgJNEZjOJp",
		@"OgdnnRrSYxsCLJcBmSWiAEdtYHAHqvKpuKzCBlMtKarFCZguJyriVQmeFdkQWIwZYxsmCacWNPWsMVQKWJIHKzKxqERVMDKrymYNKmtaulTrAFGOeFJjhWXuaGOPUhNjmiENLrabttMcZtN",
	];
	return SKfASqzzYuAwiC;
}

- (nonnull NSArray *)NBEJYAeChkLU :(nonnull NSDictionary *)QnjsuWUWdvGTEemQpD :(nonnull NSArray *)OvsaLyxcDDNzFWpxUs :(nonnull UIImage *)hHwkANhRMp {
	NSArray *ZPJvPXzTwVpkInfVDcY = @[
		@"tIfvvavrvDIuAlPDckxeCFAQcctdrbbLscqpeOVPxiINgiXUMIVMFVkqTpmhnpzSsEMAUUjcPSNISviZwsYNyCRHxQUDyyYcbPPVJHqzXADEDjEiuVgVIeaGhaRmenTnZDeda",
		@"VbQcEkjpzROGtnuyfVswcAASQBxKMAiHVVzQDpyirajXTPSIthTNPtgjFEhzZrcaTbEPAVjRWHwImYsJplgOmeAjANoZmvVqdEUufauMYXiRTrRrIsyvDLjDvMaK",
		@"QGEfaukTCVswToPkLYBXbcMvnychCYLvIOCQaNOLdgypIYwtnLBoKftdQckymbgvxiNrwExigTjzxIiYXclLOIBzDfSgPpaGYLvhnFaiBhjPuuEoptzNNUKA",
		@"wPkxWeZwCEzxDHJeSWbjustglZQZrirQcpiXJozXsJATTbneMglBaiXadUoMdeSgDuNikNNwwVKbWNnAbVaPTaGcZDWYBGXDwhpOHDbadpAfmizArMbFojkYukDexkgjpOQbwJnNWcfumUfsmY",
		@"XkboWmetCJHPpvnuKEwIRmSzEhsvSwxIHDmfxWszLDEtsXWdpRszqLiRFXbqnPoURLAPxiSUHmPdZiBoZdzIMzrmOfisqnudRuHLuXZtDhImyyCrDNzJGLUPGxNJ",
		@"eSavQTdDhhFXqFuBCplUTAdiBxNUEpnbQUbmFuOJfcdsGyVWgnRkdSuiiBxLWMbGPgthYphjhYTexyqpIUAainWrXCMQfqXcPYklzHXcVysywDFMUHj",
		@"aToHgGBfhJxjSYxAKrUcryuaeAwgyoekCgzMjUPAPtYDGtAOWaQYtPvpcjrZJUxmeXMztbGBviWpDWHKagCUtcWSWICozBFLMOafJPpCHSdFonmZxLNbwIUfxOmDcHZPs",
		@"CiEodAMKqCGveqCJyKtkZlxlYFHhPoEawBdIwacooJQibMgTDeDyUvEVQqtZLdKhGUDAHiawxtdKYjtCriIfKYaKqqNsfIWprigzlWxgmeHRkQXPBAaE",
		@"EeRpYPPxxzTrviUNkEDQoNHrfTZDOhlrmZjUvCTeFCnfkvzSurXqiCVzjIAiBrRhbLXwaGvRZUZyzSBmxIzpLmSmRKjUWAslugMZyLuApwtBVhnKsLUhVmCMvv",
		@"bPsMcvGwuavjLMnTWOhZZojkdNIcPpikmGpuaosrCVTOwibgYfJGPsQUvUztuSWltmJSqDUFEZhXbNFKCVMShkKyugotiSQXxvUhiNKtohPTsGCkzGrVsHwJnFneBNCUktjAbgDOYZ",
		@"uIuwMIdcOsrmZMvGREnWgNWAwXACxVZoZlyknTPhyroOESuUOsHFOFYfSAllCVQxUtnJgHVPqBoiBaiXbJhTmYPPgxWomRJpytCJfnRHDyCxwYpUUHcqCpFMCtCdksIhUxHaLFEsIRxE",
		@"jLosPJPCuePaRXTbMGLeLIBSaCRsPoWrvheFCqJoIxYbQUtHFJbiymBGryEyNPczCSwdhyJyNNIkDWPHHBnmRlNxIoCMVwCtgtzyYdwrWxgLHCdyjJIlZBCeCYPkNdmrWBHBCsuYjoHg",
		@"FyQElMsYkJWHQPqMkllxEeQrLpJjbANihYuevqtTAkZNLKAlcoKixTVwiGWacfsSZHWMFykhcNyTkHwjINmplVUdzeHCvqwAaJEzkydlYeQtRJHYUBLTzwXiVDlO",
		@"BntYLVygvcyKdzDYByLCVrLXDRbhnyBifxAcfsvPSZqeyTridpLwJSTcqBrvHnjigpgXHGQedepyvUeNxyKnyuGXDbcryPZnRnFwkdtftjwSK",
		@"ehjxGkdjTFMGQMncaZHFNKqktnsYZsGSHvfAElgWkvKiHGAdqDeOUVHTnjJzcgdeVYJlBAlUaiPaOGtmNYCkEJmePNSVUWigAICxKJkzXsoVnZyEtLaXbggx",
	];
	return ZPJvPXzTwVpkInfVDcY;
}

+ (nonnull NSData *)wvzdpeTrgpvFr :(nonnull NSArray *)zNUCdrLpJTEkQ :(nonnull NSDictionary *)zGYAkNkOws {
	NSData *kIlUZqFPPs = [@"XAPQTIJHfBmZwwjePHZznZlMPZEMtaSkVBlKALpwchmxDdGxxDnKmBXIPMrOPiVachbmJZRnGOnLIukPJTLlYoXPjnwNdYpKirpzSQVNALARYUmShwFhUmeSPIzqPCq" dataUsingEncoding:NSUTF8StringEncoding];
	return kIlUZqFPPs;
}

+ (nonnull UIImage *)SEpcJqjOvHzaNR :(nonnull NSArray *)XKiAZCXhOtXF :(nonnull UIImage *)ThCnWqrClajFu :(nonnull NSData *)XMYUXdeqFJm {
	NSData *SuUsQgiqPNsNWXwvF = [@"spCMWAJTRQyqfquKKfmHUAitHJiBtJxhHnBMyyonxOVxGjQLbaYEvxfTwuYZNpyqxLjsCuJlYhTRrdtRhfzNZrXPDpOILMxSktTwPGWKBNOsqAmKUThMaYclfJJnEjFBTJQyIaPFaHTpwiTwj" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *cBiebtAfwQQeJzjofnE = [UIImage imageWithData:SuUsQgiqPNsNWXwvF];
	cBiebtAfwQQeJzjofnE = [UIImage imageNamed:@"ZJnxEUIHadBsGKlqCHJzgIJyhPDyabLljwqdaDJzTCJUagmbBnMWXQxzqgDbRiUdrePvwNOhzCOCCNykxNbckUiUKVJwyhCxtYvttwnyYYuouBiwtiubTzzAMK"];
	return cBiebtAfwQQeJzjofnE;
}

- (nonnull NSDictionary *)ruWZZsdidgCkLkAJ :(nonnull NSArray *)LOfHtxbYQzS {
	NSDictionary *ZYpEhkPpLMWRbtUZEIN = @{
		@"OEAAicKXnTimMvR": @"yuvEgoSnDxoeAyIaKUANhwIPXQdfbXOCnquDVctRzNnlIwNGyClaCpIBWIEHZqLINuAkZqwiVzdsZPhCrvfeUtSUbktunhduPUwmLQsDWSnPjteMGkxbhPxNgEIsfEGajWiLqCubMcAmuAwNxb",
		@"LxnYMBrfTloDM": @"iEnoYwcGmrcMbhodOJNcUJakKsOmyENQTcjYDhSUiWZIffXdUxXZIofGByAQCNBsjsJEWRZOGFmGAZdDdoLNcJegnyIujNLCWTGWfGumIIvdTXrzlfwZaDqL",
		@"pQQjULcRsyShaPnJzu": @"bODkUzbdvBwwdOelvQQIHbxxRFieXojUpzXSsGDZLKkzFXQlohNZnalehiGoxuHqeLAyMrYcavkWvYWdZgjmZuMCTCXliSgsSvXSHuaUPMMgGigHJ",
		@"QKKoZAGERADM": @"QTWeupFTehSQiaJjlGFtjSIovMwugWQxqRWMVicWlLXytyRMGydKwbrEqCBierTKXYoSKYuICMXoVbqKJqpOJImxvnysunidbVPSjuJrSDVmuOnluvBpgJNZiqCEQZqSYzZihRBxWUPTbciGjyyx",
		@"tzBDetfMwtVzPf": @"fcfOzRdgGhHufknHWUHKboAtkEnpJXQhOAfEggKWwqokvEgreSavPdjIgYmttCqsTjcmjtVUTIwOqlAHhvIGjvhyhQAodsZgJWClfJKpLxmvMzZEeGQzBeNZWe",
		@"ouzFMlvxeCKk": @"qKyYoPeawhStyOzNUodCLvlTxZxZxKgMvGIUUQcwTKfqDCZtTUmNOXAUYHuhMKYUIjLigMnqEclpahMkborkBFgOTNOYNwMfrGXroWrMxEkzklUtbUNZDVqaUurmDkrUGskGcsStYZD",
		@"zGDZeJNOjmpiEl": @"kUMQNPisyJnfthFBkZpSmOOrLKhBiYxLIfluKyWzFRQCpwfzTvjyTJXdqQcbHLcZJFfdRvutjkuuisRBXbEOgxVcZKCiopFdSdofqvpwHjsqPAJAqqkLKMrTZUeXDniIjvM",
		@"MtMhhFGEfRwUwx": @"dtxAYvQAjDpUkSbMMWRgjMAspJzSzfJzTQwAMJjyXVNhUxOtUONvufMQykvLBVbHhWAHaQqwjYWIAFyLbzEBSneqsHPZxBiZjPmwoIOpNvXR",
		@"UvnYRYpuHF": @"dsRDauOnmTIOJbawSGBnNgdbIrEThELBgFwkGkwrMIjLHIacORkXNrYKQUbcvUnasVBczLQetvfySsRgrkUAPqKOayonulrDitnWqOdnNUhZBkSaAZXiNSNHG",
		@"bONRjXAFnrkXA": @"oGxQbcssiGmpZfrSwpVyDjdkVbmkUoqgQTkhsxuolqxfKWDyuAhPkxxnonGywFAJLmhJfJgIzyyGQsXaZVHnXlnkhRGihkSzbcPIzgj",
		@"tseIxjnlmP": @"NkjmKzuiapFzrgDHddpCQPzcNpunrJhSuYXeXsNmlQzbYGntGNqizCBDWXuGSWWLOPvARqCrTtHLXwJkhOjtOtXLFcfUjpaMuoPyDGlVeHDNGwdKCLwhQjwCtznuvwGNEKSyeYDbFlr",
		@"toskzrnEnY": @"OvdgGTZcSPQuVvDHpCmHXzmkmQxGhKNKtqyrgVoCjJHyeJUEZiXljGDJTxhWVMLnLBgZhZCLrKBJBBMOXBvFdZKVllPHAWMdHhcYjUV",
		@"YiEJdQHSMhvFO": @"QqzzakeClrInogHFyiMlKPyprLjZojoFVybHgzOxgQBJHGmSXpKQBPxHssAjcaarLqyowLIirvALhIikQbYskFEQWUZmscecAfcajEZTtDVi",
		@"ubSKkLsdQgW": @"CmLZnbLYOaFpMUrcfDmplECrmmJuZyuIvMSBqUxIuKidPFYjNuEXrSBqusmCCzgleGlbiPkdDXECxqlGOuVHkUxZlHPGUgQzfHoCsYA",
		@"RMneBhHUhIA": @"RvZzSHgyWnTIfPOOJBaQdlqNjixnczZXStAMfGBGrhMFWOXAIyuAsfqZCyGGksKRKpiIBDLWptcgoiSzaUlHsufxnOItyzvFObvsgJzgXtyBrLFuZjtGJAdCGtxySKSPlYaZiadUnJF",
		@"bgetGtwKujPEBzGRCd": @"rToouszhxAEcmWqgOyTBbyIbFomVMGHBJKEeAYFJuBBYMpdrwPXCegYBMNrzAdYZvqYbeHYjlaWmbzKAMHnPpMNVlgPHuSaWzbYgftilCEFLVLjQNCSeFuERCQwY",
		@"sKyKHYgUuzHHn": @"notPvpotfPXPoTIXhXzIrBCrCEgFgQQwwlTOnWvcltmoHwEjQjMSnODWMnNDTsotaFTvfllafarLsdyrvNdTIlWywYqxdqjcanHNopCrIfBXfWTiSsQDiH",
		@"mwfmdzdGkohCGTc": @"MelEiBPmtQMkbmXFUhVDwmsekZeAqZgMkDdhQjBBmmITEydwKmgqsmDgJjHRgASdsOddcoUrtevDSciytalKaVzteUQRCbpRyKnCCZcbmFaRgcEyaOSHuqvnkMukWhMyPKNzArbAClQTmZ",
		@"vjkUnJIfkUTfzYbiH": @"QePYCFiHDOETxDiujwQOUzolffTdmgWTJeWpOevyBtByTwbILKsurKFJZnJNLNhEbUjHTIoTypaSqDlbuHzLlCBgiATujIogUUtjWaJijFXl",
	};
	return ZYpEhkPpLMWRbtUZEIN;
}

- (nonnull NSString *)XvIbUUSpbbYEEj :(nonnull NSString *)wHXDdVMjSnFhWByjoRV {
	NSString *qlzRORlBJcdzGzPbl = @"EYZSwRwcwaPEFEDlqBHQRRHqDNruppyzNbyJFhBZhNYQWomTfovIfUOrsTLNbJauwMFONSMMPINpvmmFqTYwATdrftVeASuSAMGQYLRhQGkhKduSjgKPAhObfiPUsWf";
	return qlzRORlBJcdzGzPbl;
}

+ (nonnull NSString *)wkRHCuRIyBjSwhyJ :(nonnull NSArray *)OtcoBnzARedUcHH {
	NSString *JEVUbNXdtBtd = @"VQCtRzArYnDHqPnTeuVFwhhLiRVlJIEqiuFKcwmxzdUZgdCRoouzYNXMyOKdHgNgZSUzaUqnXAHdzhVoDNEWuXGBlQScUiANCKKdmRAmPRKhVq";
	return JEVUbNXdtBtd;
}

- (nonnull NSString *)QUdKAmXhJdcYe :(nonnull UIImage *)gKLFXqJcLF :(nonnull NSString *)UroZDLWRtu :(nonnull NSData *)fAyEuSYKZYy {
	NSString *jkBBQxnanUSRwJLffxv = @"ugoStjoJAFnSHeGHcUwAjOZfGYDqWGcBTqzeCGACCoyLbSQgQlafVJPaGqmuDsexjbnoYIkxjzOuRCgxkuPAjhANnTehEkwjUEsxoncunMwOtvqPOpIHunsSDuhfETIYNavdDpuioch";
	return jkBBQxnanUSRwJLffxv;
}

+ (nonnull NSDictionary *)SLuhfMKXBzv :(nonnull NSArray *)HRNrErfOtFmoqJUa :(nonnull NSArray *)tuzqSmmlSYWsnqcE {
	NSDictionary *VKyBwtindMLhttj = @{
		@"yEBeIWGHSVKeQ": @"EtIuzKpZUbPJRPYZwMzkiHgHBZJmqsMcsDFkwlAMIRuPlttquTzBsoeJRoACnmxHVJpaCcosfmkyvyFXPTnNgydKMxiNWCwlZjStnVFufljjofDoDqJdltrXKHbzxcdvbuwNEaMxuVRoCQ",
		@"GPrAPUiGZlgRdkYtyhe": @"DXTruPHHHKZAwKUVtooMaLkkFkgaVKugxkSnvVXckhaoVwrHbzdzdhDfKWaXZVPmDcxApLUznwXjxoYmPAGNeLkHLAnCbHXOcKpdpZeepWqyMORFowUvut",
		@"blqSUEtWVmEGeXl": @"uSAXUmiMKQmuAXyVEFLqracIsTHqJhcYxCZLYtbaCznvhXmtzvJiaixKCBCiOteQouJhEMYOWnEcTUeMDpttCfvfKOggYcdBSoPtUoVLmjPhzXrrBWHQmwZNfmZdWFCKk",
		@"nlckZHlrbSbpBhcGhk": @"RDFbMNaahsuhhLXzyQZuBTEwlEyTVdseBntYGoRrOvyHjsspYWFsiGUcDbVoLzbNteKdmyHPrUInEVaMChRplRQYatzgKlKDzeOhoZkFhghtqtKfLSWLacByKfhnYBDysHAKpNOeSMfa",
		@"SytgPTsxXuMCexf": @"qoZQewjpECZvtmahNulBnEXzKAjuGKAYQvOHhmyNlidrfrxrGEoFtLaqPolOsjqSlGHLpnaYTKNgmlKyuHScyrTVaaHLkWEKprhRPgwTQduCBqdcwYqeMusBcYZPfBKZWSEHJAnLqWMLLNLnd",
		@"zLOUrNgXAZumTBzQzb": @"RopAysenIAgQozQWMLPFzGgroiiFCkfHwkyekaikHCOecvfFttEAFPVqVqHcZuTiIPcbjAEVaQuRfTwWPCupKOZnTYwdLRZdncIKCaZvXWTlFlftGmxUXeMRWpojjkoPwSPOvviq",
		@"CsMXKJHLtJLxLh": @"wOwFUdKoDiXjTqMtiOcIvXESlCrDRNRXxFrlloNuqimFwsQMxIdtMScBbTsLzoazHclpcanPpLrmdOuvqpISmtOQVtlTLWkUbhGaOCnxAlDTVyOwWpkvgcyDGiEpGIPbrGqAyTyHcwXDN",
		@"cmEAAclhQq": @"wgqnzykplNOlQrOkJBItzTScOLWmNYRgeayOegeRlcjJMEPWvjJzYXEdDvNhIrcocXQSZhPyrJBRHxicnLXZPWxRfZxYgRajKSTkLFuhzLaTURCbOIOVoAfORgplJGiVJ",
		@"zAsAqSScsT": @"wtcTMWQbreLPYgZdyrqWsSRaiuVRLaXHLukJOnxtejgihOUnYuSDSIOjepYLvfyPrpAYTivyBqgSLXLGbPncmXEOWCReewJLvGAdZGbdelFMnBiQEEs",
		@"vgjvncDaONobBIkhTGr": @"QXRAznVaZikaTBnwrODhRKUKgehVEkUlGVdpEsZJChvMUwfRVJZoJLrLsDrQONxwUkdkKtjtqQURyyYagXaASfLsBNykoQqePcixgzTVslSJGVCLUSWzYoiiOiwelwLHLWsqPGngAA",
		@"imXyukpzkW": @"dmcCDcOpxFUlyXDgjSjoXkjBJzCAjQAEfPyiHrczJqPGUlwkIWhaYHBWJjpAVrekAZPdHkNDbPIeRuOkpblGWwYmicHZfSGXSsXErTFvcRtOfXKHRKQPoFYMXlZfHotr",
		@"sataWMZaQXrY": @"eRvpZtYoYvdMhTQOKbMZpkUkBlHfUfovrPVSdZSaCLaWWgdSidMyuEMsxElDWvSKBxGumFcvnoozVgYZBMwAKlUxjazaKyFeFjLPzeExjogtEYyfOQuQqDxlHhjtALzlaABISlUloRb",
		@"TfWueZNsFRnBZBYESF": @"HHWkoCGCfBTWJHcVejaHZlapfiPQCOKgQXrZmpZiqPDjzCzzgPSvyzbkQzALYXuAxHzlpxyXawHISjGULTyHekYthqyLmuazXyoGuoTzDIGEwzkARWFGapsqpzbvEnwpTy",
		@"cnqPSyJkpbUHwnOVOTY": @"hvUYMysRsCNsJTkDjibqZfiAaYSqODmxznUkVLyYLEPfMmDAimEOfDuzhLqYAnsiUvoTFHwApkcvEbBceWFGKbxfzjmjSpReiJDPGUwJddUNXPSjdZOkLoxYGWcutGRMjvAokQVbMyKgol",
		@"wToxAbchlcrK": @"bWXOWTWVxzvXkIllqZFQoXJJJLdOHpqGgrMAxhnmggYuilMNOdeJLpJSpXrlGAzrlxElgLrOmMhtGZwcyViULeCuffyCCGPsGxFIdqOZfViNJxZSCoNWPPEUtfSFuraCzKiWHrfVObmiGNAqaIwB",
		@"lJXNczGhRw": @"TYscDWrzyzRaoXVtrttSGTUIMKHSboupNzJpHRGPzWgIiqJZtCzxBUQibHNUQyeqFHjGcKttcItzMRxzFkPGxGhZLqszrtPVVUtEn",
		@"TaExBMNnhMEnwulY": @"jfAEcVYGxOpfKxYtCWDPQIuZbrzUnuVTDmwgzpQHlUDKuxujKsapNClLZAbbbItopicZjXNQbIkWRtXHUuUDtDAxSHKAHThKkDlSDPQGDiIDFYNWfrbMVCfFrxKXjeGXmopb",
		@"OjfXpMDPyoGAcTIhp": @"TXCovFAoLRspgbBLtZDjiypuzCsFxpIyHyFdBlClDopdXLLzbzPZLPPXRrZInXYrQnHlpQLuzNYKwRUUHqZSsILzEDyIDBioVQoetcwBHOmJcWCW",
		@"QGBtyJbUsgYJ": @"PpoVkOECffLjYjFhpjOfOXbdrpdDlBDVYNmwxdufAFhKweLaDgoxnFJERXkcqeyZLTxdwhJWzgVBEAZVMJNpZvEqNDxsYbjdPLJydjesNXJZsffevLLJVPH",
	};
	return VKyBwtindMLhttj;
}

- (nonnull NSString *)qOmtMFmmmmtH :(nonnull UIImage *)IKuaQNciQagQHDM :(nonnull NSString *)rRbhSUfDaT :(nonnull NSArray *)eWvVmuMDZPZSA {
	NSString *mBtnaHfXsAy = @"vPtyfRZnZNSgTjDRpgWXiZCOfcKwODfErWgAuxRrMjaTlylGyrSenPDeXKxBxlnJqSJrnyxHcBkFVQvgiGFKgDDsJyudaXBjCuQzPaJhgKrVUzJrilB";
	return mBtnaHfXsAy;
}

+ (nonnull NSData *)AzMvsKsumks :(nonnull NSString *)OnLsxJakuiQzfKvWyam :(nonnull NSString *)hwEreYjedNsKx :(nonnull NSArray *)UGkkJvvMNaNgwTrqnp {
	NSData *BuxUVKcOyQwefUxTAIh = [@"YjYjZPgIBBAiGzRqWrzCBpIXdpkMkIsNxOlBRnxrILomfkTmsVPYbspIOELggsQbvbbVcmjhTpjWldOrjHnHoSnNsWqRwAfHEWKdxxq" dataUsingEncoding:NSUTF8StringEncoding];
	return BuxUVKcOyQwefUxTAIh;
}

- (nonnull NSDictionary *)KlkFLfYVkUdgEEqNL :(nonnull NSDictionary *)XYRUNcHyYfczWgfl :(nonnull NSData *)KcnmIUFqsBiOfKtoFig {
	NSDictionary *gNTYHVyugW = @{
		@"cRMORdTrcw": @"wIaZjmmGFBIXGNhvCEaePtwLAtFKzhJwdrzbFOEnASSEZJgOpHWZLtLxdoMyLDbBMhIkwBHaNmifHsJypAGxHznBEoqmfhizaqDUMoHlZAaHilVGFjidZevvjifkeNieIygWvELphp",
		@"gIuJalGpVRG": @"yxZzAjcSOuNVpopmNPuCofoMeQBWupwJQvKZlULcSDitUPHkOEbtyoxjeZpkwIvbIuMSQbHAZifYHvlInvtNLIYrDPvruYbosUqRYpsKJqMbVCPoRvcEwUbcyAfPItcPUqFU",
		@"KEzLAFwTwlixO": @"CkWIUPlpinOLEkkqeNUZPfhqwkjaUuMXsKgSQVkCBAKfQlRLJYsywqBFdLeouuLhMqYgvMZTcPSTJYkUnpqRGcRPNZCBqtJMdklgoHdwrWdHrCAd",
		@"TZYjFcbrvLVjJhWp": @"TwebMuMGsAgLVoNwxNLucABJxkCTRTiyaENdHQpJWIvjhxgXFxAqlnAhnqHzUISokntDnCrpgirBFGpwkEvqOABraanfXGmwYTieWLbKUGbqAFEUHTBvqLqARKxRH",
		@"XpXPwXocpbVhvQrNcc": @"SeWLgDzrZYODSqsEnFURHgeboMCjfFTLuJWKUvqyGJoZMHPfqAZyWYYtmhEhvVEsSkZUGatEjJuMktnuzXQeDwEIbieANJdSPUaRDFFbryCeUFIvmEecvGYuUncokQBD",
		@"GigDVJkeaJfrfh": @"RNyQZqFldTfmYwjWBEXGpQEWGBFuvAusrdZHzltuqTlMeRprJHWbaGSXYMzrUSQkcKSYwrmQVZNEsgYFlMnlgtGQhWKJTbZoWwYXjwzDRkixRcuhS",
		@"aIUZawMZOz": @"fevnxRLoThaueoSLsLlPAUuKKbyIDsWbKmvTOvpmdQPlqfLEAYaeDZqlUbPWPwCWuIDtmuyIrsmYCAoljEnnpVjEcCWWAhmVzMmdprktpYbEqblxmWPdUpIaUKeHrUaGbjfrHGRnQ",
		@"qepobYGNAOk": @"SXlBCgodMfjzYGdupWgZjFgZpBodRlZzUGjZOXjNMxcTLhfSjqNJTYugFZlzOSNuRoNWxSLkQKYYsPPcLvjQgzRIOHjxYsOuvzDqBdhxtVckE",
		@"GatTAfHFKxWGpsZMqLj": @"pXldynwZdZjhtAOjGbBFXEqieGZIZLlLbGUrxomNOdJvRkoYEpaGNPaeyWRDfpWwJjpOtTcBeWnRXxkFNGCkekCSFXLXhSEJasktFconuXRCUZNNicEkQdzOCZYwYhzSssLQrhSLaOpBNgg",
		@"FfcwvecaDIeM": @"vDGRPlqXxbmKTxPzFblCbLCzoAtNbuBhvKhDWcbWBVPEjRLwTeGduZetuBWqAFuBEZDGSTILElNKaiRIUjzEOkeAgXOtUoyuzOqEepjjAhzzDYvluLtGrJinWrJDDOsaO",
		@"NOmuQBhWBymmMhHCL": @"msEFWyYIWLpYcbKzKSuPtlPgSmuJXItHifQIWcowmKIVXTFwMvKrxqBvqfrCSIBsBLkGEuPKXFCyHCpzPSqfRJWBoTfarFIxWGapnACNXTGRvOfiuqMlpXyURmMZoEajsKyCRCvztyT",
		@"jdoGYUegCrxO": @"AyTmShtxsifaWYdvokJRzuPRoyqTqWAKtAcztahPKlQbBkSYGLZoYukCnwLLmAqbkLZLdzTphTbEkPBNsAmUYJLtHgksUqJbgnFmSd",
		@"kuBiRBQbwBDNvNZtaLP": @"SMvWfcLVoBXFwLbnytGVhXQOYSElxTRnLSqeDqKVwXZvzYVYbxSuYRlpmfzMNdFiCRovQOhpeTtzaFIBjOxBJlosCOOZSGdeRrAfsZfFKYkcFyNLdeQVtMfNLbwoZvbXDdwdaPQrsHktPnzg",
		@"CJUnQdjdxRLVjF": @"viaomUGLhvUXrlnxONYOQrlXJByDzdVnlUglCsoqGcntpsZzTTEmlSAHHVHqiGKpAjYQRBDFoFWgKYYeLeJdsPLiFfIZqijZRiQdfifycdatStNxZLhPAmtBoREyMZ",
		@"FwogRhlNfK": @"RkHMOvSvRUfOmLSFdvniFaYyGpTAWtmxjBukYFYSmTVDxrxFbwVosOUAawbyMhgmzeXtVQemMsRBMfeLXzWVIAXsKmNSsJczudCpqAftkfFkCOwKpPHtqkiZcthslWyXtKBrpIsZwAviFMVfCSqwY",
		@"KJTyDsLaYklMUNg": @"PEvsQzZOEeQqudqVWdFnUqpeQDbUWBndgrdDnWwuSlrYVxUhlUbOQqLhoArIRAIrgBseTXFENmzXiDgrRKTmTeyeNmPLZKyMUtDQIcnxyrUjdSsXksHlxjtIfatNL",
	};
	return gNTYHVyugW;
}

- (nonnull NSData *)lCdjaWppdEpNe :(nonnull UIImage *)WoGHECOsxhvLTEDhvOF {
	NSData *avnXuAGcTDg = [@"iaoOASuWXPeSZGZKjXsCnJaKaXnqkOweFZIEncQCXbKRStvawwScyGMQBDIuXcNCEIRpqbVNlldqLSphfDZPhHZUWzBcGuZYMRxwIpqRkwOfLuWyxhJFDgxSCHMissJTyGBdEjElNcypVYAx" dataUsingEncoding:NSUTF8StringEncoding];
	return avnXuAGcTDg;
}

+ (nonnull NSData *)UaNmijiNiMuOF :(nonnull UIImage *)nMXsdxTWrfX :(nonnull NSData *)QdYwRPbltClxUJsZ :(nonnull NSArray *)FaCmBJADUUwKkqAqh {
	NSData *UstfEmxsmWSGZmMg = [@"GHruMkMRvdhUsTfUHRbSqscyqUrKDdrukPfbSWUYOmSAkNPBbkVKhwiYiVcIOyjvgPLxISiGNwjYxujbLMuBguyWvlpoXLnNlhOdKqfZjUVFxiTftsmo" dataUsingEncoding:NSUTF8StringEncoding];
	return UstfEmxsmWSGZmMg;
}

- (nonnull NSData *)gUOaZSigziduhE :(nonnull NSDictionary *)SaqUXxZfPTyd :(nonnull UIImage *)zAVwSsnorvkl :(nonnull NSString *)pmmihGHbMl {
	NSData *ezpCtwrApy = [@"NdfjabmJrSirPiIYDAFYYzfEBAvuwxdrFAytolZMnKFVltIPmXnptqfMlXgxfWneAzZmzbgyGKHBblqMFGOxLbrqKPFCLApoWjkjSgnZNjwXZdHEYBrEVuUdXgYKf" dataUsingEncoding:NSUTF8StringEncoding];
	return ezpCtwrApy;
}

- (nonnull NSData *)SHJGErbMPjsATHMewr :(nonnull NSString *)SugbgzPOBre {
	NSData *ryVwJNpmxzxPD = [@"yEfzHnFqMthADfkuqLyFtZAtHMUwkniLSVxZmRwMNePLZLzfQsVoWNuEHEqIjxqjwtiwqLPdZymIlDAuqSqrnipMvwIGoAgbMxAfphGzleMWceprZwQqnMKCn" dataUsingEncoding:NSUTF8StringEncoding];
	return ryVwJNpmxzxPD;
}

+ (nonnull UIImage *)bsYbJrBIqon :(nonnull UIImage *)OrrqhbrEQeiuF {
	NSData *SokdRMiKzcAl = [@"JsuQQdEnlyKOBDkOuHjoUgiLnPKJibtWVaArHkldnbOLrhPwvZdbPENZFuJzFHWjlQgEVTBpzExaqTMVJpLwZNQwFmDMFkPpXAkCMnVoNbdgvBWLHqwtzteXSolnNTztsymZBomIAgy" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ncSgwlTXtQX = [UIImage imageWithData:SokdRMiKzcAl];
	ncSgwlTXtQX = [UIImage imageNamed:@"EgFCSfHyOBhCdCLVvPssnbjwiWpEQTfQuXIrDSMldhiVOdiZmLhYCkzAQYcARPISTsqBaaAxakeHTqZREIPNBZWpSEEITDDQwXUlomyyZjTjAoPQuTmgtidYkY"];
	return ncSgwlTXtQX;
}

- (nonnull NSArray *)usnimVLJLRK :(nonnull NSData *)zLaUrlmysrL :(nonnull NSData *)PNRXXLyYssexlHYtrrU :(nonnull UIImage *)RplWgDRdiRRXWiMLOb {
	NSArray *EeQIMVtJfnjJCxTOOJ = @[
		@"DNRcQRrwziINjlwnMxouCmAthFiQivcoLTtURaCqIWPVtPGrkxaRsdiPlAmQXBmgBmuhbDWYfiuqLrUuggyMdDqtrkKydlgSyJTbNUEzcEiPcGFvUvakIqCKkuliQeSWuwUdXkY",
		@"kdtgKOgWWCwFTerZKAsGzYYAyMmzgZkhBAGQwsRSaRBChVyiihjNGeqpWQkUEBZoMzebwwWhWDeXZztekDPxJavzzpUURmJZPjabZaW",
		@"mtixFhXfOvbSdZBmJOtILSqzITkXkIAaZhGZbvPRfWpzIPLbIKsrZbDGbelXvcQDUGDOnNyAiBpwGGPuOWbSdmiBgWTUpoukGiICiJQdrdDMCUZHmjPhrMmHPBu",
		@"fjIzaSSFnFAJRMCArbVKuAiWSwSJqkMmNuIoGuIGigvGrPRzWbATDNJkAuodtzjTHwbWZsgVJItUfRKNiCsyJaMKkkvaJKnfBRECHvbaqNv",
		@"adnnhuxieWFpyrkVQUqFNrRRNLhyVtsTCIuFEjSqIhDzETaPTDoWKAiROiooinjJwhTWDYfhamZYNoIorFirHvWlcWYJwNboBSWGinfhMLVTmgBIgWikuHMIZJNDqdMKHuKCmO",
		@"yjmTbMgIIXGsrvRXHqifwuiFJjmTPXSJxcFtSPYqxNsYRduIIDddYSsvphlMHnoahYyquZhToDHKIgrVjyDeeiaDrLOlJybTqidBDpHYuqAhYqoJTBe",
		@"gpwcTNdSkleCLcENGJVrnoIjJENbHhXIMjgSFMvIsTsVhZXtYrNQMeduCuyANzJAWDeItqhYAjMeGVGxwjqVtNAPpmxpabeKLBaViVrUwcvBYTkkSztNZLlZLYLhLTYTEQpBDhPyOXRnGKOGBSv",
		@"lQGsoFbpcQmBcgQyLDMKPWbZutOcXIXXIxhSPqlxMyOHPMkQFzeBmXtiCxxpCsYsfNnwYkVzBqiMNcfwUPxnFSLSSSrVvCLOoscXK",
		@"bJyzNkYJecFjyhZjrBhPqEHMfFrLHlXvttZnDwtEkOFYBzmvTOjkEhGrrlRtmYOcAghoBHmzfOKrRGSLtjRghEsjYPprloeuVvKgTodpJLPAVWwCXSI",
		@"QBehaEpvksvnZstfZtkoCDPbVltSgONQgGQyTFIDlZCyMBvMrvxLqCHOUzpEOZztgTnuaNStQHBAMBOeEXhQbyxFWCIoSRkJNHqPdw",
		@"XOCYLRVAZeEEQFzfrGrMRiNCuVCGVzNViWYsCvOgcLrRwLOXcVsFznbwviTylBavyODTPDsBhditRUzLBpYkgAucrrBbzNaHSigYXKAIyKeDQ",
		@"ZxgGLXtLIHBZciRdMNFuFOFIhmTpqrymPmKVxPcQApLXQVYLQgPfeVxDjlTauJELdneQktfkfOfitDvPiJQHwZLskOoQShFCdhlwGyOqcNkFGRcozjvthyFdFWzphyyhTiPycAjyMUvB",
		@"QzXPDaqXHqfyvJnDUjhWiliHXFaRAVtWseNzyPLbtLaPRTjdYtMNOrGfvWwLkFIuaeMlYyMhwdIPKQrLyhINpBuBnVgOYHiYNkTbH",
		@"wlpLRxLqkDnwscHLFTPZYEhznfFyMRkmVBiqMuPJBistWYacOPgoFkoOcFvUXRdgZECVLvCclZWaYWFvCYmuvGAeITIvBFULsBSIRpakr",
		@"jSJaJRdytajUwZBcIuvyfEUwUinVoUXixWGREiDNuyVPkHsuVOaqMUnhHlfhbKuxRCqRtEecdrJyQsowEsQQfLryBOkbbXKEJaBsgXveQTycBZJemslJIDjqXCMskFLrYuBfi",
	];
	return EeQIMVtJfnjJCxTOOJ;
}

+ (nonnull NSString *)FXBbszLUOAVUccU :(nonnull NSDictionary *)XlzQtQuYHxXAvhgb {
	NSString *EsYjZFMfpCcvjDRvCw = @"ZtgZniMBTPKjURHoHqTCvANjoxlobRViZVmTJFMMnZnUCpDKIRpYvfWdrzeUGwOLpbDJiXiRaBrwrYYfiyhpQWVVOYjdGDUbuQyKeOeaXDzwvZdlgbesqdhj";
	return EsYjZFMfpCcvjDRvCw;
}

- (nonnull NSData *)HKooyAAgLtZz :(nonnull UIImage *)aKiaQzFLgsag {
	NSData *MOMDjIjeASZVABhTsGW = [@"baNjiCkfJOpDeIplAOxIzooMvAshgKxrqdmXCJMccySGkcEoGVmfPcnCPzahJDIXLGWAPXfwVrExRnLPzLwdjFpEwctyJxkadLrIAd" dataUsingEncoding:NSUTF8StringEncoding];
	return MOMDjIjeASZVABhTsGW;
}

- (nonnull NSArray *)vPSnqrlamNBEDLSEBdG :(nonnull NSData *)aXlEoQqzMCMKbmr :(nonnull NSData *)LNssydTqTdAahmeO {
	NSArray *xKUXnaZvNMiNP = @[
		@"wvPfzNnMnvFOAinJebmrHkJImSLMCVnyXzgcAHHxDEYzrymYbwsNFELXlMZLjTEmrpLxGbZRcSGBITcuUHtBiKEydJwSDwYTrVJvefzxuALWvxYlVcOcSNgCrXowULbxMja",
		@"iYqIhkPgaFLlFlCWsFMONMgbrHdCakNNFOmkuCduZUdgjSuuYWbJmbubdhUxYXBJpGqHwEhRwjJFABMGqjoLafEdpBnLReAIOduEX",
		@"RKUsJonSkzmEgqQvMUUeXpHmpEdcfHqjgPBhvCJZDRdxeYiMYpQQRODjsFQuPFhZjTmUduwIprfqmoHklZmRyQZDxVoWVkjvEypLAohyHZqxkrqpRfVjULMcFFQOCrLX",
		@"xQXNGQFetMXUltbNiTIRHLbJqBdjjQzIfOosqBkfLBznCcIWBQdoAluyFibilRErWORGtqtcMeNnAAUdfROaTfNuBdmSmpDNIhEjRsU",
		@"LYMsaoAwcTSlsjWqAPheYDESXfGnIjqGqYXIefsvYPvLsNazqDYpTOPIKFNFcjWyHFPontIAvkqllVgRKwwoiPGktDtylLLGCLqhNOeAm",
		@"OSpwqmegBZZZNovBunsEbonUeQSejjWUXWTdzmmTyhgPwuPlZWgHLVsDcEKChVRffwuXIgvnXHjzvlndJPUcvnNdnrjYhZGbQRxFZan",
		@"WMuDNvALewyLXWRhOSEczvDniYmLmeJylcbQMJgeaKgtUpJvNecWkfXYEqBypfNtrfyDlsoMpjqFUXySKEtEfnkbVfWwCYrXBwlyAILnnmDwilZVcSSl",
		@"WDMKhirFmaZgUmSVZanVBXXuGsPZCuSyiVsXlRcgbUbLnLXFgiOXfTqafeLzrqKAOmvqquruMCtspkkcLPZpmEVcdvuzzQCcxDMBZVfRUKqTwpxzRoCPEiUpfnpTeNADoWHGXuvExAnCuTfnBAAZe",
		@"ANOrNoCYVUNoclSSDAhESGprjvERtfhmunGqkXMYiZTXhMSZERAUrLgZsTuxBqzIGBqFhRGnsUSsyjdXpEGwCmYpFKpuPSgrCuhDflDlvDdaNsKQlTWIp",
		@"pJTLVmCsEDEMJrYkCaZfjLcWXfMSkDuRAdFHJAymyrZkcfNilVlxLDtkSwzreqfoACErcdUjTuHEUgCIgLlkFsijcHEQxelaZyNUHPYyiQdQAnXlAtFCJzXLvRx",
	];
	return xKUXnaZvNMiNP;
}

- (nonnull NSArray *)OluDGPOhqa :(nonnull NSArray *)mJkIxyGNYMxguBatH {
	NSArray *JEPtjjEfkv = @[
		@"rNKrCvRnkGmDARYFqZkqVWwyoCYmpUoTZGhNOogYMrFIgratVZwphfVNMnBtUkxEJWjKxtPmvmDbMYmqdoyuBclZYltTqIZVfXPlwZCjpbiqdzsLGBcDPBTmFUvRvSZnvglsvwsqSmjGr",
		@"waqamPhLMGnqZVFPEEvbcngmCgvDryeqWJfoBPMKOQGJYaZRkycYbFPlNGJCDvOkJrzmCLxHIkqKOjtaSrehJTwWSQDIRiKTUVElIzA",
		@"IOOlVuWcRrBNFLHumWRUkJqkVPfodCcEjlWzASIXwOJRcgbMvUukspTMWHDGMsHyVgLeLPxsJATLyaxixciyffEIZKaMSrYIhcKiBECqqtrJmbUpAStsCuTTslVZIGZOoTT",
		@"ybWrxnrXIFTuaNjtGBEvGABfQrJZleFihPwzalKHsmPgMbpHcnhoKkpyEJZkzcdJCRqlArDTgAPjlvuKKNMyGuvNEWSvmNkYqxDqrsQweMbBZNBzvHOBnwXFIOQS",
		@"HxJdWbfArmXfCklkXIEcNwyNvpkeLicZqBehOuMSdIIEgnTlkVXJkJMLsCPPQCfHcdJXwQGNRgihXvpxgseNeYGkJEGPbRaxtbHzlkUIUNhueMVAFldNuzRTM",
		@"OFaVyKMptqwdAdaXHvMtzuyjkzkdsjvKcKKgRmLjiIAOFTXCaTnkdfRMUsAoDoHhOruQkJZklMcmQAsmwTvugZKuuMJNyXSAMiogeBLfkYrXSjBGAKOx",
		@"EULvqtcIixSCcvDaXHgvXYKpzwwuOLkhhmssIWeyZBGOVMIfZlTEzQDVwDSNBbovGjYZMOTkTpIInlEhQehSTxqtaLDrWIqyQjdxS",
		@"GBPntobGYqkLBHUMkfupFUeeEFsNCAANjXBxqkrYbYwOLlbIbldLqFFOluMfEmWfFWFlRGQkRXGvTYKyKbDYWfByabCuaqegswMHKIhReBtvTTcUiDiQmudjACzTEGs",
		@"YKdOzHfMJFVOkxceMSDpJZqqOZuwITghJRdzfbEsFqoIDSHYWhBWANJkMstPjTBNRayNDMpXgCYxRqaKRfWkqsdrkDJWDbxAyKuzktK",
		@"suMakMcUeNiGYnfEYqqKnyrjRBFwWtTrrSuCFUaAOHgjMWHcWmcUCWxSzyTKGFjzBUIMJzyWWWixeIHXgDDqCrkruAVmjcNPUaAmlRNOFCmrnYpjIGpoTcbulQB",
		@"nsiDxywUSwzeulEZNozGuvomDVIGPLWhAQefeGmRrRfKbcbkTaxGITrSPodfLDliqEevqRnLQxSwXBPFVLtOoAvYqxCcZGEhuzwNeqoPvBFKfKocMReuxDvLeYGFRCGNXqBQPhiWefH",
		@"RNfPxOiDGOAjeuklBhnTqHgDrhMuimsaprUdYAsudvzYkTvqwSiOJZmJwznWhnYADAsuFVXXqOHZkBdjIXkRKCHijbdPFldzJnJRSVmRSmVpzEagICcpIAZAvWmqFnfGvpPcFydvzuLlLluOv",
		@"SrPhCwWTyxCgTaFlSZGOaibuayYoYazdiBrhwYNMXPLxPZrWVYeUuaqfbgKpIGVMuGYahdHJWmXGvgWXhIcXtwTMVkYcjtvaszccEFDJseeKIUiMMIOGTmOnlPFXWRpEegLLdcPOcHxggQCfP",
		@"OBQAULFtsIlXvPCRvmxijrxbTLoLQJrBhOeeLtdplFgvAtbsPDCmDUfDSeZqoUaKAPxZFPCTZryAGxPpBovgfXCHgxzVGosHDbdRCgvJhpssUSgndcJXqhzXnRfIVcovfrJHBatoHkyTUtwblf",
		@"RYldmhUUVkccLJiMUrnnZbvKECayofXmtDbyOFBRTTVGZTYJALABPLFxXIUmpmzJZAnpXeitasPJhdJZQlRBTaWdxjQtLcEJENqCPqLnPunkIoxXOboBiTYtwbahAzed",
		@"WPYkznqljobkvCFiSwYCWqUvsdQbsKhUtvjawnsgqbohQLftRaoCnclRvXSCMvHncOcTSbTrEcvnxvrzBPMOxbgclFMHlwnKJxaZhqwUnhINSvMikqNUhFFGZtpYObiP",
		@"GnPAIIrIqYAGWAzgqNMzigwVhGmdbnFyZUkAjRkAEMuypTQMbcThsuSYvfxRUakqGwKkJFHtaLfPDwXMivKamRFyuZWjxCTPjoxjGNpfAEFZohrrEjllBMgAuKZklNBpshForanrNbx",
		@"GjNVlSYADVrIDCZbpfNNWUBmHYfARUACiuLYPYIyurKDswpJWMFJnOiQqQsPwepqCqDCTOoAHpOycFPFfuQIPFTXRXJINiXliSzMyJDOQJmIOlxzNYjormulVVSIeXdOHlxxkWiPJsKMOZ",
	];
	return JEPtjjEfkv;
}

+ (nonnull NSData *)hONyyXKoNrzzmrS :(nonnull UIImage *)gXRDaWGlNk :(nonnull UIImage *)GrWdrPUlwXPoKje {
	NSData *IUIhXNbgPNBUX = [@"pFqmOkilrmltuyzjuijyyUKuLTIlVUFozjVgIldNIQJwLvFeCavlvnSDUCryxXKXYiNjhRKEgWdhODcuuCRvBlEZEqYInpFoyOrvpueplVMHXPKRYxwUJUbNzqVLFHFCHYVIJoBcSRsGgLUFa" dataUsingEncoding:NSUTF8StringEncoding];
	return IUIhXNbgPNBUX;
}

- (nonnull NSData *)azmhyAYOAUXrY :(nonnull NSData *)kiisEZiXaHVySfmRQq {
	NSData *WUceVLDDcjZMe = [@"bPekBGtRYabTOkYsaeKepVXWJWNBvebizNKUDZMZqRzBWgguRjAhrhzkkuMmsPlTraHoCiVTnLgUNeldVQOriqLdGBtNliodtRlKyYSvDYQxCQXsMvgIPFt" dataUsingEncoding:NSUTF8StringEncoding];
	return WUceVLDDcjZMe;
}

+ (nonnull NSData *)YrpGzPaWCehlDt :(nonnull NSArray *)micjgZpXyWhZlHjcU :(nonnull NSData *)cQoIMhHYeOHOI {
	NSData *jppuTCFSHNsrfXzO = [@"hOeGyOvRjGsYKbFxrLLiEPLTITgNlXuWVdaqqLivMIsouvgpxTazvVihIHaQRlyFcsfILgpUbgpUxIQTVMmijSlRFNJZhXFxNtKdYRuGcFVpCUJmpbBi" dataUsingEncoding:NSUTF8StringEncoding];
	return jppuTCFSHNsrfXzO;
}

- (nonnull NSString *)ykIFGUTIGTwY :(nonnull NSData *)oXPfzlXWBjWak :(nonnull NSString *)EYZUZAIDXTGC {
	NSString *VytAIPLWzbhJXaoRmBO = @"fjZChcPGAtivycbCbUEdTORFbJjbPqZycSCeIpGVorKJUeDyiyLZQnNzlMViaWWmcbpnrFfAujfRBukJPTZJvxISFkAhlFJOjFQIU";
	return VytAIPLWzbhJXaoRmBO;
}

+ (nonnull NSArray *)edBzEqPSWvGLvu :(nonnull NSDictionary *)erqNJImjelvsSQb :(nonnull UIImage *)JRcMZvAFAhaXWl {
	NSArray *zhgcAjKKEttMZXZeyOg = @[
		@"qNBLEthndJOJARZkopihsLkVUNBgXqXkGMmBFvhZAheJjoGdOPHtlljFrfUtZNEAUsCwdcZjdBhTcSwJeJMmEWuvdlmAsdOwnydJoVdweIEimonOlsTJNNBvVVbJrG",
		@"CzucEzAXcXWzUDDYcplLMZeFxjkhuKJFxdOrjBwItROEGfKLaprywvBCYqmwypnJoKquUnxjBHjZQCKVrtKdRJZLHJTzCaieSCdxMPOKAHPPKpxQUnoEYYexFBhwCv",
		@"aPFLSoMtJoyilcVaphOKSiXmRjBLjvnQMmrDxHRVNYvIkDoBrAsgxAGbQBdfzqunriTJAZvYlYRIpzIRGaruVDOtDeoBMQdZaUluUpdeHUfJtLRZ",
		@"ZsinzQxblCNgnxBvbBoUfJJudIDxVNVLoEpFtHVJolakmhGFlgnAmoSpirgRBtOYDFcyDPHIKnqEaldImtgVnVzjbitAFBeseHBnMxfJhHqbOIIFJJeFztvvMITVBhDnMpzlkXiQOkgvfdqQVIhC",
		@"uHNPudKZPHQzeCJIfaKojSLpahofkEFgWMPdgQOuSQlAYiAhqCnKAPExxbzXvjWevdmmEMhOorNzzllBWlFUuDtsPuhwUitaUBefGioMImvUMUKxLtRwPIwvYZdpYDNnhPoqsu",
		@"vPLIXimTkFYPdmqMMlfOlCnEYrLSXMZiAnfvkNyWsSeHdHHwWyzGadHEazVrSDpKqqaqGuTNZzhurmaUOWJVZqhchIvpXVILQnamBWTPRBTdIxpKXWVtoSsDrAnzUsXmDGaclrgz",
		@"jzPLWiMDVmiPTrOzoFjJqsnoOXfiAmEzcrdVNYKIeIeSvabyPdisZkNoQUOaZxiyHcwsSRTBkxQhUcxVrbhksiwudvTACHdNECtdVQbZvSXmBN",
		@"auLSRiKGIrBlxvebMMPpjltgcqRcGKiHHlclOnpCsoaOQeqVUJPzYJPSvzZAyuMrhWxwJsLbCBCUCQhHAbcVbgCxWdcdvKkUGIROfkwUkFoEd",
		@"kbiWTySZItxyEtflLUHERbtgkiqLOTAetUhLUgjEASsmWqTfgQwfoBUwtWcfwGpSAfFkHpMJHUPpyPcxwYubzQRIgavZYjYjrcEAsOVzYjdMDperBOKdQab",
		@"bltewTpiKBzoWXmfXgrGUWhOeNHCQKTuWfHJVdrJVnBnPriOwkVXJGGBIGaGjJVgdCOeFFniDafJrtRCcQbywaKBfPDbelFxQCieEWXflDqDPUcrSoLlHuHZiRQBlMTmOokBHE",
	];
	return zhgcAjKKEttMZXZeyOg;
}

- (nonnull NSDictionary *)nNvOeCvGLifDtjsWQp :(nonnull NSString *)xVAPbyvazkuBzSHLr :(nonnull NSString *)KnRyucnuEMmQ :(nonnull UIImage *)aoSXzHztcfPrYh {
	NSDictionary *lseeYvmudNU = @{
		@"eJQiNtiPNtlsvsgI": @"wuVeoHaVivaoOfavsuORQxyYACoCZvQdldcavZkKjoHIhFZdYUskXSHtHsBxPLrzfDCHrQMIoBhlcvcvhHbOfrhLOXhIGuxozJVCpa",
		@"nAiUvZlQGfQQ": @"jkYaXUaLsIYsHspSjNZdgvJBAPORHWdpeFIwREogKDiDaBdDSBZfjLeMdVXbjVvNGAFfkYMXUlkGhKhisGbUntdYPfWuPHWYVQuBGfubRGlqETWPKSfwSkiYulEsnFtztZzuuPFv",
		@"myCHbiDwxxci": @"xSHDRtZIFyFfVjHMoimqVoEaOkGpXgDuYyOBErYezOezPFQUGZPcIeZzNnnSQJVvkkYPNfOtJhMWgOKmYTNcnWNzaNdSzySbyxLYAqwFHwhEhrMGnSSQqgelFZnDuKYDbQWVvxVNV",
		@"IsZFQqjZOfBngZras": @"dBzsAzJqoKENraFCtZUeEGWeEsIlHPdYgzolafUQArzMIctgqLlLwcDEIAARwrGMSVwHyfwbqfRfgrQLTsicpMQqSZLacKaUUgwJyWFvbXJRfKXOiIJRxeXxmKMCwvnAgzqCBQg",
		@"NUklbTfaVHhQH": @"mTHnSILzWEVXccxqkKpTXPyPWlZdzxSFITGMNVqXRjvJwwEixTmiJDrZbNroutWCHjNTkntgQgEyieCjlEbclIDIOMmqMHqQCVIpcAzxcMzllYIGOqxUxnEKCUaPjlQwUbQT",
		@"mRmuilyFrLn": @"vyNuNYdtTwPyTyZteddvabfIhFoEpKABQZtGWcZKePAqaucDhYKmTYizGkwinEZCMIiabNUGUHCNCykXYeOlLIYOxDnjoXmxYxnsmybyf",
		@"SSMYSfzOLiwjUWsisc": @"nDbSpDyzzZuWpnBkLMpxZtOjUzuMlimYXVcILHNBsWdCNLIrtSyLHlZsvQoBSSULGWKTXKnqRViFWSNZCWlQSQRhZBgmUSxaVGMPuSWdoKzUFyyvNxRwrifYVnEtEVqvZUHjClXurniYOvnsOQXBI",
		@"FFeNgTwnjzHjiXaR": @"pZMhuYhmNzQmkALbgIJvomAzjiGqfPpiRmNvubtchDrjmKouffCFNAQWjPLdUHFfSCByIVKORisSNLPTgfSvKnsHpjMbPvZqmrnQMsPCwzeejfbMWqOEiJnTqHNYBiYlFBdzlBcIsl",
		@"awxKXnAZLfgzezRU": @"nzkShCoxZZCYkXBfiNgjdCwHOaxfBnkUqBqRffIPtNKAiIYxKsFgJGwOWhmdzyOWStBLvcQDrdSniCqWPuyEbrvmlMjMsZJIVikyYmCHYLmVaDxWsafxvHrR",
		@"EbrpFMHggOlYeCoe": @"LhfPJnsirKfWobIwEuPtTJdLEfCwRALsAndnrYeQDfutLBXLrJxSkLVtWNRNNJvAayQyixvnGMHgncUHFpyXiHlnpqKUnkSMJlJKclKuqRRWJyGLjCokbFeB",
		@"hZjlmSvESRxfMAwyn": @"HCZujdkAOMkLMzrJQMycgJKvmNASqghXYLQmYMiguzAFCaUAbkooSdmsYFZitZBxYlJROpXrXCOWbxTzYZeDrnHVEaPUXxonVOinjUF",
		@"hDonSJdSDBdH": @"WOcGtliSnUcVsoCTDeaayHLnVaiUsKfqbOGjmkTDeiIZXkVHIIuVXlmyRoGgJLNgIrSjxcwtmzazSAZNYVtOTnGozsfYqBZmLFjtoKvqDxbnyUJjqrCHYEJUFYXQWiaDvQvoHjX",
		@"qxZbLdsDaiA": @"zvCkiuomZTvBsMWvJBRytLbdxfEKbATVOXdetKUpeUmsZmiwWgSzRFBWjSBHqKoTdaRJbQSCyBwrYZghvYLKNPFcLyqDGrYEUkHVMiIkrTJHUWyJztARXQeJhUdUcxygYpMpZYfZh",
		@"UDEqAtZRNBZkOj": @"RuuNmsnZrDVktCRRXcpmTYrvICHXQluDPRThrYaDPdSYEculhvUThiIpBRXuaQfreYNGXZXEcyszzIJVOQdFgNwpUpyBpZqCzVncEKVzDAvDqpk",
		@"AqAgUhyQNnJTtKWOI": @"PnesELBKsSPuhzlDgFFwSGVnOJZEotQvfkyiQyUYMaJRYGtWJlnBqtaYIqdCyUrBbCidlqQpqZOpRfotUdqYuKPlSvgazLiUpuMyiPwOBNhBuXAVyMvGLMPsmbMJJfLhnTNapSIXTwI",
		@"ExtsxRAnVHK": @"VeHbgMMkpzZxuOBYiXgGssvPrGPnwfeITIFFXJgceUJqqDttamTKIJxvgQrFyxmGtQHRfTbmkxKYMHiYunglTTNBjtKNmgcexnylQgBLHgayeMkUPraoPegxGgd",
		@"iIZGohWhvc": @"TNgFgBJQfypONUjbsHKoNAZapQpPXtOJzTBDfYbvMDQtUGWgQOPXbBJxyhhzrUuOGgkLxJuGQqkIdIJhKUMIQCyTmaBeCBnOJHJuRPypYsPfsinDWhENONtiDTOQgoJBVdBKRjSEFKy",
	};
	return lseeYvmudNU;
}

+ (nonnull NSArray *)DjyDjJzNiqVsKDz :(nonnull NSDictionary *)wUyncFITDWOC :(nonnull NSArray *)dCYXQfHIKG {
	NSArray *JhnbPLqzeGvVBaBvJ = @[
		@"JVfZhwFUpWWqAmoCUaFUSwCoLtTvXFOPvBgQsBMJeeLgvDeACCdiSNArdDCCImcGgnoUTizZldyLEAMsrPPAtAbAHZumAFlXDzcFuJzxxVyAWRnqLLSlnAwHB",
		@"GJgqQwGIZrHEmFeHfDKYAePDYjHWbLAnAuYKdeXusvXfqmoAvccHPMcBridoYUeHecFLuOkinydXSSiFwMUXHPZPgWFZixsiyBggqWJTnizaHUNyqkaNYZlSetDeAnJiLetZxAOt",
		@"BeJulkCrTLzdTzkyWbIwakKmMAvbAdraIzkRbihOdJNvMolROqxdOLUrgTKEGCZicWQPDIAgsHLPFfvVrrEgHcLZnhDLqRCGeArMHJgDJZdQBLhlEK",
		@"kKDiVJokolBLuollTFNAfUMCQePLUluqqwVJlveowrnEPZLNbrDyQKdUxCsmuYRQxYHYxMpVwoQkObOFkwEeleAKKxbbJTRhimEccnlZRWugQmXbZcQyUjzmhBepJ",
		@"GiXBjbNpPzUlUeMqpEjEfYXugpQxUtBwqoyeqoQEZnhdBIrEBGiIdzeFbPNJSnWmsNBDTCbsohEmXGejpVcqfedTpzPWQzMEaPrKbsHMNuHAxiziBprBrQzpyZVNdRxRsikidVyVemDy",
		@"FTDVgALqpecdWnlycFzHrPsBQdjZkxXFIHoYPxIcvRizsIitHxlgXHpEvrFIzLhoOmicNyUZrUfeMnBwSNVGuCMWikjqgxVtduwxhvyytAjLkfYuWKLACLWFhmNSzMa",
		@"KoJYNQjYjitoXJTbzXLzxaNAHAsOiujjtukEAdzEeudPsXxKcrZepypOcpXcjanFyzqPTfwXsZUkDnZiHXeCmAocQaTwrVrtWvAIZdsMNgnrlZhrDqUJogGusvD",
		@"TwUfyLwtdgekDGPQJIrRaSQmfIgVAYxnErqrGnIcCBBXePSwfOGwbWhTsEPmDsqehWNithAeugvxIwxkoDUMSwAPVdWYxdXgcezURZFNUvuZxizUdeGOVxdXjiwTQNAVcwATjcRzyFVoHICDHBi",
		@"WkBYLjFsCRuOaFKFTTEDSSkZmMhFxeVzsRHYSSVCmEbAMNEGHfrsUDRlaewLpIxynlglfOBprKASGUhiDSnfsStRRgduyBxiEhnOzCqqgFENJOGCuYmCBY",
		@"OSvblrvzTZvngBsYJeQPQZTnmWYbbaykDXlHsGWDUcItAGfTXYfUSTBhoVHhGylyDhybOPazCEdtXhdkUJngtsuiMZOlyphmvLxacAV",
		@"gPxawtywFBuuKOWSKxRxeLRibtvLUNatBwIddtNhOufhhJuMCnZUlSrEwuFehCpZFwGuroxMdfHkaZgnzPmwzcNaghjKKFOWLUBnzJBogXBFyULMUHLHLOfbacBnuUpNkNfYowTguxieFMVTH",
		@"uxAODmluucNNJsizZzEFkOesCIGYkYkwlGtxeNcEyHBoKItzGDVZiRiRJoHByFFMHGVLtpMfdaCfHUSHpPkrXgkSmqApYpLWuArPJXwkLDJlsqsOlQY",
		@"JAszQFwmXFOwNXNQvpjFJxuBIXsxCAHqopaeDYMIqOoZowjxMZKqqsMRLllndhHWTeEmndDStbSLiGluiIsIdghCuBRTraNiXairieSJGPhKdfqraWRsrid",
		@"AcRtDouMMLIhTtmSmUCsoTbpUSpSWfOFqswhiyEvavKfvjyyGwwMfhxZhTSVAjZoIsQkQtSWByIqoUWcUudSnTqgIewqzAiKwfubDFP",
		@"xdEgsgNytVvpcZzBqWtpKvTbggLJEponDMIXdRpxaDKeyaJxmbtCricyyNDcCUpKvhQshTWtrqsCZkvJClsdgBXbTyvoNUiwasZuSLq",
		@"pwBUMmnXpsrewUhcrxWbPmKCBdZEMByENHZRxFpZanCwCcMYYOFTFsohvqDaaQzYaHXGfxtGBTUBlfqPExUthIDDFWbNrhMMUOBrLTjAiMaxiHKoPZVExptR",
		@"ZbaxfOPZqdEwEkSJUxiEctZMolodAisdGwnQZOZxXxKWIWEsfVSxqPDvqZCZsyzbXmoZZzARWFxbJeJMZBrKDvUJFDpoFxHXblbHpfOMWMJtPUoRMCbVkQpBbgdvadOYv",
		@"eClPZaOeUiLDirZAhkUCCZxKwmKFBZcactjYGRtAEMTqVNGvkjsKuwIiHtrgiTFCaAHgyAFsVzOptttNEQClQOmlyYjhWpeYAqtsOnamlEJHobxzkXfSwGVzexJMHVZr",
	];
	return JhnbPLqzeGvVBaBvJ;
}

+ (nonnull UIImage *)VvojcohfeLUtAVt :(nonnull NSArray *)WOLgTCLpbDy :(nonnull NSData *)PFEOVjblEZZfyqBdRk :(nonnull UIImage *)mMzsZKOuWTxI {
	NSData *UzyglOljyHIj = [@"ClnvOAXrOudxzNJOoDTikvzlxWynWkYSyKQLrjqcwqolSZREemUMwmgDXXxeNayzYjPTCBVpkMUXxEAhYIOykFIuUbahtEFMGMBZ" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *aaBprgfnWdNxZZpeIo = [UIImage imageWithData:UzyglOljyHIj];
	aaBprgfnWdNxZZpeIo = [UIImage imageNamed:@"bifConTLjDuOKrFRuVTvdoMTMIHUcIVmWCtiziDILaPvSkWwkadBNqZWcDGClsPUpnIyDkDuLzmEGOnMISzTVGiBvCBXLvRuUMiXoFxwasLQxEBGhRblwTgVfHfYEUmOWYvn"];
	return aaBprgfnWdNxZZpeIo;
}

- (nonnull NSDictionary *)bouTtatTikLrfX :(nonnull UIImage *)BJfRnLCTdOAeBnIHF :(nonnull NSDictionary *)gChpqJBmMlLlQZtB :(nonnull NSDictionary *)uleWHzjSGHi {
	NSDictionary *XhLKhWQHmoxLuDjRw = @{
		@"saqfJuAxpb": @"vEzOaVnuDYPSWzsPoDJdhewWvUOYFZTsdjACfCEEgKqUxfJySegqpuYlIJMqsTAEfLAkhyTpSsFTnNeXOFrMZtvcCFGdRFmCnVAantwSjmyNixxUHuTVBWOatEaFxRynQIsKThRAjspP",
		@"cVlKVGSgYROJq": @"cjUDQhDtMBJsKxIWsCgqlmnJmyMXHMKJOqvLsZXBtRvHhDXwbLXPJoBnFtKMtKYZJKEHoIqoahSKxlzGXtwsIbKEuBGvrSyaqlOJYMRIzIPkTDoYQYFbRfcOGDALqiE",
		@"sQMmiVYjmVNRNuoAG": @"IUwmRrhcElyiRvRXqIVIeIgVOZDbpiaByIhuDUnJVlEHIwhvNZfwcPZalJhUQBXPTwZbYwqsIhyEQlGpIfZCSaKtFVkTRjRVPhlmHcyWHUPSyaEtyhqxOzJfwpYriAhzGqvDpgp",
		@"NqDvhDrVWexippyrPmr": @"RsAGSJbXLfwhVKChgNQAmcPMzjdirKIzRzmCIdrCnFnhLCKTVbExHMxtteZEXVtWQBGXcQskEuaqMFKxuzRTWtJItcgZDXtYRZaKbPrUMtRMd",
		@"HdRZyKCXvtjxprnXX": @"YYyKcXalXYCkcRROIDxZkmrWjHsTPSXVYGFddDZMgODJgRiBhzWDXEZgsugHJNVznzAEIANaJFiIxsBTgmxaJSrONuiGdWEBNCrwbCsCEtnMpjKwqUUdhZGXNGULJNkifqwhyTBdKcMfCUZq",
		@"NLstqFFGgU": @"OTXnIlVMmsmjiUqZxqINuvAfzmQyncfjzdgtBeTRPfGCtgqnuLonNDxHbXeYzDGimkABJNXLjSGjVFTUEYkYjtwcDHLPOhAtNJaIcmxtkXPx",
		@"qFLHGRxFLeLHRjpa": @"XpLIqLXYmfhSgrscoeZsGNKTINcnDHyCYQdXLZRugZFmhtEUqAqPyNAnEDdAONtfnmUVZmXHAxKBkJtfDlbqyFUWiyqGlfiLJfYYvmQmbyQADoxRxmiQsvBZZPOuosYHyAdxBUL",
		@"ZbPkumcbWuRc": @"wWfpVMtNXtOTNOyzFJiERUCWvTajqoZJyifneeGZidOLIMGdaeweuVlmZlcCtoLuqsHezkvpBHUsLGrlTRUORuPeQdRpFbZZSyQFldjgGLJJcBNTcVONMOypBcPpN",
		@"KAFVlBBztgeHSgzTzwQ": @"qqvFrxFFssoDRysWsmAlFhmNRGaZwWHZNQGDjnRgKHDPHdDMXbxoRiSQfdkumszJBZdJaQELkgxYTOTNawYSVGLMjXazKvvcIggUtptQ",
		@"mzMDqKNDbigE": @"xRZdbfnOzhzOFPaVkNbimEJLdTyFQOZvAPOyKvwXbezwUZxCeNbzRGnFmRvXtxOlQFEfVwPXQTfYeBdqQaOzTVWDhSoTFKjbJmUErObJxTEkyEJsDIdpi",
		@"pELysxRatW": @"SHVzNAeeCVsJIpnOsLfUgLIlcMXQYiGAqlZrIORffDtTsIsYpSukTNxPQtjoDStNzKAkLkvTEVHfqrSUIlrCtvMjnAPDWqXwQwkmpzjHhgBcuIsEsHBUQSZVKYUU",
		@"UNaJMwglXkGb": @"rnItOUeAFBUkkptTdLMIzDYCZRZacvlLkNbqcXJOsCllTaxtczUNhZlvDVsDQlFWrLKNLivAWpTxHjoFObYRMwLOfFMVxBehuQdGiViE",
		@"EavAVLJtEeTuISeTOUQ": @"LdeZpiecErCulLTHdcgxHJXJFODfAaIaOJCtHVloWBTIrRTOFlWHXgIFNEpgDjqHXqaLGaDxVDbyAAqMmtvJbWtGYbfDbTrdQGnwdblxiEKVzfiNmuSeGsqSuuTGDGjJbDJWjMzfndCxSxepMs",
		@"fkYnobmYmToy": @"aWjxeBahjSUbIYCGOakCpusyQudaaHwIwMvocZdwouNNKpDlrOfqcaxFDUPqSTZKANrNSlAopPxXGSDZtLUXfGBWfkeMdLBryFsXCeoJnCmoAmOQtmmRoyaVAcQsTCvYTCGDO",
		@"ICNUrchDvW": @"rrYtkdoPaCcSflpztvtrIofJAppTDtzaLVRbQMCsuZaZlxlnEoftFEMcAAIYSEFfouiLYRSvWLMNpQmKXHMQrsDGQLsodNTlHKLjodBuwszvMCLiiepTxDgSbXajrNJJYYQHNSYougCNtSXTeWYXe",
		@"mwmfivgypmHMohmLzt": @"BjqsTWhpdrlteupyHMzmcLtqhSVxaMLTNSQMsvTVSsZoxYWdcGKcACdkHlQKJGwZyLsafytZuggmQdKqWAoiYtAImsBYTiYZgcCKPOYKfZjDEqDvCfSQ",
		@"ZZOJsRwesTiJsOxe": @"mFEPzWfiwZUpkWcykkVUGHNdOWeoIgwlhyUBEexLLFHQinXwhlpDQwEzWDFSNYVxWGiezufedWnwMKNoVooIoUEUCFdbOJSumiTMiiTKuwgnkcXanIdZClmvpsUBlIPFwWcGWqzaTIHn",
		@"INQejmjaKpO": @"phWLqPQqcNYmyrpvhsjscfVXuXzMuqccXMarlWbVpCMHihfhjcWkgLtAhhHmrzfvtZVLqXcQoDsuLtoZlJNthSsrJuSXkMRVcKDExuWjVwzJtRBwEIbfUzUUOupnszyDMn",
		@"JVkBAGtXjbybIIpPcgi": @"HLqiyHuKfftAtmVUeIVLUTjKfaCTdSOsffejQzAwVXUeFmsGWOVVbtyWVfzpdnfzijssCUeCUPZyNlHElEpKKtdtWUgZYcoixuaokDVfzbWpE",
	};
	return XhLKhWQHmoxLuDjRw;
}

+ (nonnull NSArray *)CKPzrTJAUQ :(nonnull NSDictionary *)iHlVEePVYhMrHHF :(nonnull NSArray *)RDQeSvLNoxEwAZmnSt {
	NSArray *wloCWQEAtqcNoknxrUO = @[
		@"NdWriRhrvkUAheKYmZriGegnOdsBFosPsBzkYCFktrDFuhmSCCaxmbWDOvzaEemHUdzmLcRiZJEEDxnmlOTWJcqQdbdMjOWJAYiPkrlkaopzHeWQqetPUGmfhcOCF",
		@"oXFejmWAnGOrUZuJjHnlxJBLKXnMDZzQLtVrsjbZcrQgnkFQwrVMRIJMlaGaMhLhUfJfOlQCKkshcINPJbyYojEMNfJeOsIpJFuzHAHhiwTWTCgYEVhcAQAJwAMDUnz",
		@"JReqauCGFLTcELGqbATsVxHSiCYgLrwQFGcVrzVHWUZLHamNnEYhOZYyiOwrqdvsqSMhGUTdurzNUvwfjvpZdYvVJNFJIDHzRNTlnfEOYMIaStkkpLWOZMbZKESdfdwCOdsDUudTJST",
		@"PZfOajdIIXvaqzSkkscofiGuUDeTdjJpmzrXLBiuZQPBMOrjcghcsRfJrbIxZRDUtPlnvVtpsgLnsGJAHwcclelTPIxCUbetKFnXVnVQsPNhAzdqWKWzQoltBqNhkMygWWHroGSsN",
		@"iVwUQEAnqlwqnVHaHKCWgIqvSvJpbsoSFERAxkOBCqephsIazxhFhTCXBkdvqecEYVvntAWAcUcMOxJLAFpUakICrNfrfrVxSCVUIamzRJcwkwteLaFftPmPVn",
		@"WJoiRZddTlmbzTBqbjyNEYkvRlubBNdQBmfUcnevvDtiMJQFRnirFADaomcQOxOPLxgTryDdZRnhJfbMfgvvLOqzkTDnZocCMRwxjFnVGCILA",
		@"aTukSzorhgNqSTJTSyUGlPojXDMPhoTsfewiyaVmlcihFEqtpoZgWwwdXbkZFDibcmTyQLlZxkIYwwmlQhfxiLOxwPJWwWCAYUbflimlCHGdcXfeuVXOsVF",
		@"HysQVeKRpcPuMiOcVyaVuesChUYvXwzBQRzYzrWTXLSWZnTaXszybCtjAGHCpdHkpSrWENpsytMKXMksKVhBXGpcqpDkboEcvDnrEOlbAHqZHcnKJweCKzAOzLG",
		@"lbkCRxYqCcVfULedlnnFdSAnZrszJmUwFOozVkPzaNnrPfujzWiGxyMXtQeAfPAFdSPTVHqNWADibFxptpSmNtoJUXsQqaCdFuDGESoiIhAtwoDZcOK",
		@"zsBpQqkeKbykvMfBgrIggIVqXRfWGLEvTxUTQxEcbuwLKVzAbbRyVEAbGpwiXfeOIdKlgNeTfzlckaqyHijtirVSAimFxQBETxyJmtPk",
		@"lxMTFiYIvJQBJdbvXeqCHdJHxzLbWteZBVtSEUGUHIvEBfTRZyaVGDmYumMKTuowGYyRjQEsGWecwWTnAYsClDuEfrPMXChFwsOqIQZsAVzCYDlZvlRHhnUikomijkNJFbcRzmPMkMTFubw",
		@"lshnsBuKeFvShgQHvtSweFIBerbZGbdRBhHtGFgkfKMCcUFDIjmzVscLrKmRAkALSGzqKmCKtYpcUDiEnLftpOKtMNAnyrEbswZNEEgcEkqTdXYNDNFxCZivVjxJhYpQzPauNIQSEwVK",
		@"fidwmzvHiCTvNSAdzAuvYSMPTeUhwifYVsSnJrKIabhsVazzDmxIIubRqAJjnMUjgkQYfuiivZkPUgXjoHPAjUNVyBZlYJHmsLQxjkmLGiKpyKJmxQUjipwErsvPBnqTzTZCJHeDzOCPIZg",
		@"sWcFWTeHfzzpucBnMlXvDkYuYOjyHxdoYBbNQRJOkyUiDbbeORWWmmgdNrAVEBuVwSRQTQRTfiIQUbXfrpxsslLkXbOfdnDOBDpNLYXzuDwxrpCYnwqkjEjdNblXlErUnxXqwAJJdRlwMxrIhapo",
		@"sZbdqYRbNzfgOOjyrUXjyFnzWBAmldwIxajKfaHSJxoaIvpKuAFncAcfLYVUVpNWquWwIXoRVHZGwfLEpxdVuIFYgbqqGUfMFlBxdAaIOpdLOADBBoSYFFWrHvODXQngXPnEdLgdGKoxqAGgiic",
		@"cYPLkcsGKcVTDuTxeWxiYOqPsDadiYltRrqKXdDodJFtCgeQevLgHvTNFHYdcrhLQGqyBvhGuycUAUuCivQANWxSIZlKxiUFsLQIwzB",
		@"WokJOOLNngkCcSsHTQdBnrqlxKbbLfUydYVdWFnHEETMYVRVxmUuAjUeBxUXlllWCWMRSMifkiIMhhIujHfEnogpQJztHIkeCxphfHsJmwDTLWvwHZgXacbypWiyYUsuQHZon",
	];
	return wloCWQEAtqcNoknxrUO;
}

- (nonnull NSDictionary *)EDhnjuGHCetRItZJ :(nonnull UIImage *)APpImWzijVBP :(nonnull NSData *)qYJcopJUFEMDp :(nonnull NSString *)vffMAmDileLKhRBItWy {
	NSDictionary *XgpNrSzZYJ = @{
		@"QiDdRRCVaMJFTQrhJ": @"lcofQEiMIIpDSkgzhZEjnZOyMPVxsVIlZAOuhQNfCTjVimperaEaCkKEzUygxLwLlSHwoMQNzaXjvYBRXwOKAkNOLOiZradeVxooFl",
		@"dIIpVMWQRrADOB": @"oFiiXSoRkNjlXrbqcTrZyxRrolFGPOqQJSOjDpKqvlfjbgUncmkawaWFnTvRDgPJJZCQAQpJVAjCJgXIJIjFNgETljOwNxhQFDNCLYaEoUs",
		@"kgMQqTgdLc": @"YiILXNrTnFxyktnJeKqJzuPVneoCBsvGHeXfhkFIaLbSTLEHESajXjqLopjTQkQvJlZwaxjHtYvCizCykyJSmIilzbexEgvGJecvWjhoDmYdpPqFmDdIvEAiTjWLDpvLXZpGnwrywsfKoWr",
		@"ylkxiveYvIO": @"BLRYnTSeYLhVGajIbXsIAYQxpNDNhnfwjSgNsXSwJmXclwaxzxIwqyZandJGPAkHUSNVDRoHACRlORRQtRoVPelpFNZoGzpRvZUC",
		@"oGVtBngZlaJkKngHFF": @"qpWCnJffDXogUpmshbBTucAOluJltzsdXtLBUqNHOMJwZSvDgJxigvyCRlooJBXBDRKkstlsuWlLZUYGszaGFTJpIIZoNqUZVjdXcOIzScPZTNidVrgIQtB",
		@"CoADhANrQrbOsV": @"ZWwjszhMVqNoWJSXVzWHVYxDpYSoGfGjVtfdmlAmzllxZpeRiYidHCQHTPUKFJCiODLzLeqbnNtkAZmHLsDCTaqgbMxWqLDmsXcJlGiMOKJWjGDUEztwodafYvKwAmTNSfvE",
		@"cqJcNYnhAN": @"epFkzdjIDBlJWEFAdylYTpFddZVEJLvZzshuRjIpEWHPZRSDnRxIsIQEoomEHduWAVjODhXOivwsZHClTXGIuCTQuOzmaVNEODuLaBNTvWptzbdqtTHgEWoWCcgFWSmXxbfMSStvgK",
		@"nbDLoaRUFhTS": @"XcSowRffPzUuTcpLOOFneQOcEMFcUdlXZhaSCxCoimYjGUyrTmjqBTZRjFCjBHjHTAVHphhjHLpCZnVICvSvovHDslhPpWkXUCfLyyYjpyOzuzzxVUGOHxZsfyGxFEMiQMkwlwsEyQwTnY",
		@"rcMStmXuaJjBjyg": @"lhMGdwJDdWFabmPKnnSCcLZRxNmvLxhzYcpenwUkMQsLDzhaaDbkgobAWqMHSVbZHDkLudUJRyqcVeTlWtKGXVxSnwTNnrBjijKyjkYziTMxJltIwqBcivFcSmrEzCDltXxEgzUvsWQfOq",
		@"UzYdEJFTQfGOrOUIVU": @"NwXdSlVBktGijcLbynMJmZrvtYXWoRLklaptHGJNFwjIEWVmHcYIOnqJOPcTcmsevTXGbMSsibLiuOcOYQvETYKSqyJZBnzVBPoilIEQBD",
		@"RknmSBQCbnjtVkn": @"gSEZlLhNcHdsibltZEpygRVYhlVvVORxkFaZWoWetssvxUxdmbqfgOBlnDPleQHPYfZcsGmHZHxcFgyhbINYZzwCpBPuwwJFgZJSCwrETfmAJmUxbnZRIPvCKAxki",
		@"esNUkxabrocZQtNOYW": @"XceVrXARPsKOQUwRsSSvaQPEMpJyhOvWjFnkfzIYMlXLTsHvPGdYncKsuTzTxpaeTfluVhZEdrIAMgsBykdjKGRELHtNdCBLbqPIVaenzMQahbdn",
		@"cchwoBJHaOSqkg": @"TuimCUpxPDKEySNUSfMyuHeHzagtSaejcYnpEVoLVmrOWqjQFkOFQpZAxBhvOEqvoJYoiqFgblYHONCLoKwRNgbQSIjVNNtFVQkVnRVhbkEKWwyOETAqfEPpvIVz",
		@"tizqDXpUKsXqg": @"UNtKGNPkqmOZgKLUEvEZzhbHmohSZUCdXEvpwCuGpemHtwsDSWvoueOgVnZQRIlRHgjgIPCbUBnNLSBKYoSFVrMztoXtRPmSdgcserZGLKDHMYTQHtHdcIAwlRLGKRUDShQXWbZX",
		@"tZKhpNGuBULQov": @"FDniJYSbbXJXcOhjxDPngEikpeNQfZQIsivowREDFvGIPLotndAEMbVnPVsAfyKLsokAJjqPfHCFvDzzYdNKrfoFVPueGVEtzVIyojWwdzxvPBEKrCcBBLjuTTJONYzMuJQIihICFDgaPxUKrEUhR",
		@"hybljUTJzMBDO": @"PEYfDXeeTaORkfDScMCeHyJQqamOcvMlgstGEnFOyAXfQGbttVSMJHEUOYtAxksZfTxNBIwDZIINRAtUcIFfrdvXIKCVXLwfdJZqZTNZLcfCOVjpxwI",
	};
	return XgpNrSzZYJ;
}

+ (nonnull NSArray *)RvfEZTyECRSCewpQrPy :(nonnull NSString *)JDSYRAcjVQ :(nonnull NSData *)ckaTYCWhiLNoOcCN :(nonnull NSData *)yIGCuIfWqcAz {
	NSArray *xUwIYKADfNtZc = @[
		@"YHKKUfQdXnzTYEIjZsIVbsmwjPObxvWwaBTLJvtAuJruDPnjcgCveyGRfPdegGnQcQpcOJdQQfZJKClHlLxkHpeHxLcOLGRBwwhLxfMoVsklzxUgvkmGqahcVrvgGDqSVYZCaeHfApGQF",
		@"qTSStIMwZbYOVdfEkVCgRgTeoyvneeplwXwUqyOHZKUikaYfhuZMcbJrxNKumxYFhhkVnnSSdPJuVbqfrwahTkEVyEAnUDoOaVCopONanqBEBIObGpiAhcSVPGtQqovBnlrEbZaNOKPpPORYALSdo",
		@"CPZAotkRlCEeuqhMlBpMUcDNLhfHNjYmluUfedTwosdxCfahVWwnYpJHnQhKBpCZFvlaVJrOvWfmLylvOkcBJwqYrCodusySnPsUmaOvuUlPblEEWWvNFQMrQPlCrvVApY",
		@"tAmOjXcuOPxMLVvfopivzMBfAbmoRFvfaZpEDSGLjNcJfdiYyJuBLwjZixyKtNWuGLVmxnbJZmBvFOaAzfdKpmoWwAlAXDXSEvIJvwestHJunXkDWsvDUOdTFrJQeOwV",
		@"PXIPjkoIGqREXaxBfHsPCURVPohlAYOIceuRHbYkrVGkoaWrpLdxNOjGXjZDDLuvCDfSZYOoXhMlGOZMdbJbaZZhnflgjMqwLWbWuovmyRGkxGkGrotXsssLIxDNKuL",
		@"ZtuhomQfMwgXuCteVBywKuTlcStJgoOhFAIVAMqQDScPPgUPsNnsOdnOanoVMTtloWQLvCMqrTxBHDuVOyyPJPhbgrcoZvPRFTdeeWzpyoKgXhDgJeLP",
		@"GCSiEwypmjlWOGQtxUuOulBkIElFssGhTmXSjBzUbvTJQWFVMnDFTuNjInIhKiFJcClHvxGQCiRHjfKUSQcxogszTtYyfebcQDIradqHjTolpMnhNeiaoWHvJMbOTOUdpp",
		@"JncShwnQObZGmnwhxVHqGNyJgJKRvQvyBaUiwXyhQQJvznmiwdZsNYMScYpRgKmNFdsZPljlRADEQjEdhWfkYpzCwlvnNZCdHMHiVxgRrIKAZmlcylynxyjzCAzkTmmBFqZLaT",
		@"rZRbwUfqVvWrtWUHkyLmpyubJvNexBJhCfsZGgRLoTvnAtJlLUrVGaCsWrsjDaVRosIMDrCtAsLiMRoiCevXOaOexWYcNodFYuKCweBewKjCebgOSiRUHkVjkpwPvTokocBVxDnCcO",
		@"yWMCgJRFFMhkbeGawftcuILlEGKsRURPRalKBapFzDpTEAfKgbnWpMKmWcLSbLeookWCpoKTlIGjnwvnOAPXlBFAETKETBCcWbaenJmKoMJ",
		@"VifJYlpcazmhztjiDHseBwMIFSnlpDcjcZVLHNVDuzSkaIrpTBMpLXWDJWsLSAJhirptniIYBRgVuvqqKVSDopzYEeLJAUocdyynx",
		@"FyydaCWYDZDJKLESNbTLwooqiJENFVjllChuWFpcBeRDChtdPTKUXlSLZzEIQaEfudfyKURuIeNkiyEvFHQjQkuYAemZqtLiGkTdzuKvtTxPFCDjXJCJskmudQCePPzOAHgyXvbwyfRPTa",
	];
	return xUwIYKADfNtZc;
}

- (nonnull NSDictionary *)gJtUDgAldAMOYhHSAOA :(nonnull NSDictionary *)KtUfdtvgqwnt :(nonnull NSString *)ookgwfiMPTTfMwXZbE :(nonnull NSArray *)vqMMkAxydbY {
	NSDictionary *GdNfmlHMUSHSpAvUDYn = @{
		@"KnYiptafJHaY": @"GSzmZRUpBrWFRuZVfKmtVMzsawPzhXqaMXgSlximRsJGTmigwwnPHtupbkktwyVzjjopYleGSnMzxHCKcrDsukCGluAGzafIdtMogmnWKDuDKlzMSrkbhOYMVOYTODoCSIRxZnTPgcDN",
		@"frPolgKyTcIoBqV": @"zwUjpZJqInYqhjytICWhTQSLZifpHTuupCNBAoSptuaVDHPiGBsxaILsOMRCUcNtXIzxYrzeoMiPQNrhBRWAQrFOGLxbJZCnTGlgnMGwkGGRyDhrIUUmSZkHHcDgSSRvzFKpZeqShddZLmOWKtJ",
		@"eXvFSeOzncKxtQ": @"vuHoUVclqKbymRkiklnHyJKeTbEPXqJLRodzIklPyvWhSNCZgzZExHtnEwtIoUYGbMPWrQTudrArpGnIAcbGqbilUcvYZBXMwUtXbebahlZmpLLqQprLKz",
		@"AmZRiwDVdWGlJOtF": @"gXOngMJyBwYfhlqZNejhrCpCZeQbNVuRsHLNIxzzkSrPwhOYvAdaaiRmJtBuJVsbjdFHfzUQIAwKmnHFAYRJlCeMKXKOkqSmkbDIQZFkHIIhSYrSbDxIJTyATQuCuTE",
		@"LfPYTyKfgeYCFp": @"DbFsxSzTrLqSSHhOmECOriwrMkNroMKMNeoOBfpuYYzXGzZmeDFjeJhDioEjNcvuEHIERDgYkMtCCOxtYeWFQLCFEDwftwgRKkFWIBSGdCGVfJDlJz",
		@"BKqljynbVjicXHqLBS": @"gyHlAVxMvDJuheTuCRynkArRMhCSDbahrCgiUaILGfTdcScACUKREFmTmKGcQWTEOwXoeyIcdgQliIozQEmZBefINoiInAreJBHlladKPwyQwfKzkWvDUVllpdZONPQfJKVwcPcc",
		@"ZRYnEGPQSQowNHtGI": @"rUDWRKjRwQsWuAWCsJaXSdImEESZVamUsQpAGFSQSpVKCthOgivVHQiuExiUOjqqiGDUNvpUYcyqMGNhevqWxWhqmesARPzxpJSxAWzWFqZryBbWpMqkpwuLrgukoVHGrsnqNkDqdwd",
		@"RVmpvRnwSsDLniTOIu": @"VVpNbfOoSZUaoyDOzkRjxIYgSULaWIudxlIrmOrmezWumdOlsCzXCBGSTxQOjmqXejSDaeGLbxJRwdSsrWiScHbYSTnfgfIhnVGVWdoTBmKkDxw",
		@"TCEPfXzGHTZVCMDEX": @"nTCxOSguhRiyVaDPuSovdWgZwzcuuQvmWixSfHWZlPXdHLiMwEjJCcphXgDFMdotdcRBnzTdejpkAMXFHwlkjwyCikRujrkdwURMmjORZaTXFkDeAUvZPFDBFt",
		@"gDTlHrJNmAk": @"kCGVzVuOTkWWwxjemhblluXvodxoSkkmosyOsdQVepMMYzuqSgKZGAkJnWSUENUQdgrdnieGQTzLUcDonbyfHsTNOrYUgrPWNnRefefspPywMptwIrUkGQETRDJSGVOeNfbZIhLQLYttvqIUMWA",
		@"wuUWRVbuqRyutpYAZL": @"UmbBsWLlYCtJaKJUEEGGMGYItpwtcWikWkmvnEEHBmLnWNaXPfocIJbtiwILhVmaOkJVGAvEuNcIzAgGGgmaNTgnHqtXJDGKakQRyNyQgjWBXbcUZcSgBtqMEsTkRwGMNuT",
		@"hALwbiCcgZ": @"vIMbDOwgYlBrvnqNHjaAjOwusokAZEPnWDGWhYfwdohUKGAWKuQuEnkthZbxFrFoATpKHcOnZjjucAAMTkExdTyPPAKgDiskMoxTQTFunDBSfYGrgDYOtA",
		@"VhCkiKNTjKmY": @"fCJDhMkiiRTkMEeoYzeuhhBDICBhVHavZotMgawvPGXPvpbVJCVoiwdIaIsLzNDEkldyuvwiGXGGSfXzCVbLRzWmtTeYOpAiCivSj",
	};
	return GdNfmlHMUSHSpAvUDYn;
}

- (nonnull NSString *)QWJnsVyqKWXgRbb :(nonnull NSString *)GTLyPYQSmPi :(nonnull NSData *)flRqPqUoTVRXG {
	NSString *wfHYZewZDubSAYQfWSF = @"YNWLfrzPVyaFoqNsYqcSUwkFKHDdsFAEXXLthYVijzvTepmBHiWKKpwHpXCIxalwlBOOhgFIRIUQZSMffuJeGXWpjzLIKaJyBpBsJApgfARrXSRyVnMljeiNiMKgxEoVxgdxceDbBvcBBDpvj";
	return wfHYZewZDubSAYQfWSF;
}

+ (nonnull UIImage *)GQrHVaHSlQJdPVTrvuQ :(nonnull NSData *)UnZAKmdbGi {
	NSData *cvJFYKIlOcfvzpGwz = [@"oXXIpJbCWmZmrMCjCARZxafsAjiSndVFNAWxhxFgZzjCcfLIKkVDVRFNFhMdNEJikoMLvWrkOVPCFZVVrzNdqaidbllCLxlpNJEtBObbZMZpaMve" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *MgqgsMHDUaxl = [UIImage imageWithData:cvJFYKIlOcfvzpGwz];
	MgqgsMHDUaxl = [UIImage imageNamed:@"DqLaYwBNyxrBKRefwBtqojTxnBJpYsnQmPpOfvfWQIVGeAAQQxiJQFNBjErHCrlObHfuovFdWKcRYgGrxZCiCWlaDaTsaWMnbZpjcPlMoreQnNTBv"];
	return MgqgsMHDUaxl;
}

+ (nonnull UIImage *)MKDzEPyZjPUdeAXEiRS :(nonnull NSDictionary *)CHwCXXdyoZCJAuPFlmS :(nonnull NSData *)BnAbFeaQRXilpMdX :(nonnull NSArray *)zCtSxoIGXKDcRdR {
	NSData *TExNckBEwZNLqo = [@"OVAZTYyPGLUkVYXcyPkInckEMkPbbOiOnHJgKxqeJAIgtwTBBzStEBRBFbbAQXHXYUgxEdrXGSJdoaVNYJuOmzXbUBjsYJNSVhOJCfnQSdCaMcyQOaQXpLCwKGbzZLtQxSWqJxNSUWYKYbxmHV" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *PrtCiZLxfem = [UIImage imageWithData:TExNckBEwZNLqo];
	PrtCiZLxfem = [UIImage imageNamed:@"QNYbUWOPOwPZdhwuMLFswDjaOzrPyfczPKLCetBWLQVRqhAQlDDkuiAxXZVGjVTsoxDZbTPhKFUjngVWZmYpePcMZMgRuChWhRyUSeqWEZaJuCcBcUeMPv"];
	return PrtCiZLxfem;
}

+ (nonnull UIImage *)JdQnJpyLdIRgx :(nonnull NSDictionary *)wtSBMXIHqSjbm :(nonnull NSData *)fBQUdmnQcaRogxH :(nonnull NSString *)HkVqQDnrSeoiWLslv {
	NSData *LtuvkVuUZcJcZo = [@"FyQiIhRasETVazJMIJNFNSyfYdJxnULkObljYEuGrBsLTQNmHqfXgjUurabIQCPZJcHAAuzeAxGZiFqetUXrgfpZPcyHxeNfsazZlgxehALcAdCdfHRSaCwid" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *sAKQHEjfKdCAOvNXc = [UIImage imageWithData:LtuvkVuUZcJcZo];
	sAKQHEjfKdCAOvNXc = [UIImage imageNamed:@"SbnuCihEOctaGJjWXdSAnHhwjrIkMirMQbDnPGGwRnsjAvzaFvdgaspOgxUqmwpVZMtnJHixocPLbKCmFaSLXlnTzMNMgQbcuoVqKcPb"];
	return sAKQHEjfKdCAOvNXc;
}

+ (nonnull NSArray *)GZQfZAWOTzfgmQbpoxR :(nonnull NSDictionary *)McVRJBmfGLHhF :(nonnull NSArray *)WQJbKrkDAiDW {
	NSArray *rZqnnOUMixoaUXOykMe = @[
		@"jRtAzbsAvYXbuqVVHztVUcSXThrVBuIkyApwSkWmbCJDYwGSenaIbzwkIaylzTljhEEtQSkcriNYWAqyLzDIomUWHtDELuCoUPZcdndbIDzTRlFiBACWKZP",
		@"zFczDSifiZxnuxEoYmQXNcHFhHIBYrHlPnUCXoWokUElbyhEGPStMFtrgVRHASAbmXDZyupZiYBvkHnWtxzbzjAseFgFZfMnkGDYDPlaVjustqAuSEMNcxhRsMNrCpBIPO",
		@"RdpkfPTLNLZBsAALYwiEcuHrXtsyMzLXjdhhUHOiHUddSeQaTrWzpfqwcLwFBLUyFPMLOTfoIKlmXVIUaHiTwJANoHiobatFbcbxnBualOotTJdx",
		@"UDiJyuwOdiguFOSJGiwDtZSDMppzCvjlBLEjPwysSOxffLcUEzWGtIjNDkjcZEvylYvmjvizikbvCSeMEZGgeEvCmIOeVDlDJdSIkzCmKRcEdbLJaZglZxHVQFXhybSNdZOnPmPx",
		@"bScVqHdcopKuLpvQqqPIrcTVvIFeRJuFrTAhwuBJNlRfVCJqNBARMuAcZIxhdLbHzmhdmGNYffUWtohFLkLAfssMsYWWiwmMhWKLjgSWqtNromytKYfMeplbvMJcBla",
		@"ZdUKyvyumGHoQmFcZOvatEBErfwXqdvNmzTTUUuBZAJAOxHNiAQqkpkSFHuZRPITNRzzlYSZjVAxKvEEbSadDjIPjNiASwLlPLHUJuMBrjZfsyeRhvtLlUStFLWEtIcoAHimY",
		@"cesjmGIVaRylhddhSaJAzOSzEDyYbCVJMNeQVazHxRorusQoWgYzUIWfSQRBOFTlMmhPUtfYMkNvHYLejeIyYMXWBKHASqldOFVoIbXPMSdpppRqtMu",
		@"iiYAjmNCMigmjcPkzInxQCDcWHenzdXEqEenQOQRGemkOmHGtZrspLUhoyDXWfNDHNfAEgVgQQgfnvKDDPYfCGMZIffFzKrkJxch",
		@"sVYLzqiicZNAtXRtMGRPCglfCgaHZpTDvaKAvQUHadImQBMdjSQKlGmHZfCPGSwtJwnnPgVrxVtsTqEptnBoJGRAlSPSpeGSEieAzZeZuQcaoTvvNtxWLxxDN",
		@"VQCSlzFVHxEePcaJUREntBEYTLHDQvQRnwcMHwsLYJLAFthjHBmazhJPyumbUumamsOWOWVjtzcFuevKnkvDzVDbrSvQOeyvhiPCGUuIpkRJynBOXURfhXFXSXzziObJeZodheMaphqLslIg",
		@"DvPaEcuXUrTygfrzYmeXRkDwiDPLNfybOPVwpjwnnPOXTkePHTnzvaQklljfFrrFEmjKgqKKHcWLwsAyHznLENysXplcUzTMAYqgrDa",
		@"aYkWyZhCPKoUqUZFbbasqRblXjETwJuPbfRXqpsoKHLdQUdINDfZgGgBmFmiHxDoPuchTTYGnOzAWmqBrsqgIlsDjPzhfsMZgvbCsZmaUazJMLdSTndBlLlfmHMutdYD",
		@"OAkzPApvqNiKHhYNaUzsmkTOETNeaQDtbgFxGHVLZlhZQOWGkmZDAKtwIaQDrQLMvkyahnLVnlXDmdMxkOooKQlXvcjNUGDttvhLtuMfAUNUeWUJjJTavKrYwwnr",
	];
	return rZqnnOUMixoaUXOykMe;
}

- (nonnull NSString *)gXbNYkHDxIgMRfv :(nonnull NSDictionary *)BdSwhsFdku :(nonnull NSData *)uzRmjllrVaBeGmT :(nonnull UIImage *)nlCDkGaPAqVonLlvXpz {
	NSString *Wbuobiuwtu = @"zahEPmaRpvyRGFuvCyMUEcGFRWspgScDPAytLuwMgdrMlgtoFcjjuFWdZgqjMUeGTESWViCdJkDJOjxRoivmaocFXkzNfykOEfHOawUmfnvAFKHqmSHhYqczfMkWDgazpvQSZGanJxJELwTGhDsQM";
	return Wbuobiuwtu;
}

- (nonnull UIImage *)sNSxWsotrBW :(nonnull NSDictionary *)iKbTQbiCicAuY :(nonnull NSArray *)nMJSwZjJOQsBe {
	NSData *rieEhmFZHp = [@"eyrCrWUXGsMRuyZSrTdJojzkBcDfIBSNKPaukuMgwgFDVIIkaLBZCiqWViVivLfdmYFJKClJHxYPMxUMaLjfafqxEKXWoCaXapKWwOVqSzJaxmppDruUioIbGNpWrxFEIb" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *dRuLZnPhhWVeqH = [UIImage imageWithData:rieEhmFZHp];
	dRuLZnPhhWVeqH = [UIImage imageNamed:@"IrCiZnYZNHkxhIIMRWJRYmHEhLHJmAxrCLenlfLFjZQAXdQFlvNZUybSpznWIyuRzCBcBusSGOHXephRtYhTNNlBsItmmZUKzhTVmeihIgWZiFjONJLoztNWDEJXyYYVRgQrdYPNEe"];
	return dRuLZnPhhWVeqH;
}

- (nonnull NSData *)HTOWpiEKFZMmzKjiR :(nonnull NSString *)lDHMpIXmsCwpwRPtvc :(nonnull NSData *)nbNPPiSzZJehky {
	NSData *kbulysEyWO = [@"VNzsTwnHZMzXCygcpBlHypVkTAfAaXovAZmXUrdUHymKXbERGkzGibosLEIokwBYfQqQTfAAznRrlhfeuIYYcfhzOVJsUhDZwQyTEZ" dataUsingEncoding:NSUTF8StringEncoding];
	return kbulysEyWO;
}

- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block {
    
    BOOL shouldRollback = NO;
    
    FMDatabase *db = [self db];
    
    if (useDeferred) {
        [db beginDeferredTransaction];
    }
    else {
        [db beginTransaction];
    }
    
    
    block(db, &shouldRollback);
    
    if (shouldRollback) {
        [db rollback];
    }
    else {
        [db commit];
    }
    
    [self pushDatabaseBackInPool:db];
}

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}
#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    
    NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
    
    BOOL shouldRollback = NO;
    
    FMDatabase *db = [self db];
    
    NSError *err = 0x00;
    
    if (![db startSavePointWithName:name error:&err]) {
        [self pushDatabaseBackInPool:db];
        return err;
    }
    
    block(db, &shouldRollback);
    
    if (shouldRollback) {
        // We need to rollback and release this savepoint to remove it
        [db rollbackToSavePointWithName:name error:&err];
    }
    [db releaseSavePointWithName:name error:&err];
    
    [self pushDatabaseBackInPool:db];
    
    return err;
}
#endif

@end
