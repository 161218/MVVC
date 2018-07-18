//
//  FMDatabaseQueue.m
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

/*
 
 Note: we call [self retain]; before using dispatch_sync, just incase 
 FMDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync
 
 */

/*
 * A key used to associate the FMDatabaseQueue object with the dispatch_queue_t it uses.
 * This in turn is used for deadlock detection by seeing if inDatabase: is called on
 * the queue's dispatch queue, which should not happen and causes a deadlock.
 */
static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;
 
@implementation FMDatabaseQueue

@synthesize path = _path;
@synthesize openFlags = _openFlags;

+ (instancetype)databaseQueueWithPath:(NSString*)aPath {
    
    FMDatabaseQueue *q = [[self alloc] initWithPath:aPath];
    
    FMDBAutorelease(q);
    
    return q;
}

+ (instancetype)databaseQueueWithPath:(NSString*)aPath flags:(int)openFlags {
    
    FMDatabaseQueue *q = [[self alloc] initWithPath:aPath flags:openFlags];
    
    FMDBAutorelease(q);
    
    return q;
}

+ (Class)databaseClass {
    return [FMDatabase class];
}

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [[[self class] databaseClass] databaseWithPath:aPath];
        FMDBRetain(_db);
        
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:openFlags];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            NSLog(@"Could not create database queue for path %@", aPath);
            FMDBRelease(self);
            return 0x00;
        }
        
        _path = FMDBReturnRetained(aPath);
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
        _openFlags = openFlags;
    }
    
    return self;
}

- (instancetype)initWithPath:(NSString*)aPath {
    
    // default flags for sqlite3_open
    return [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
}

- (instancetype)init {
    return [self initWithPath:nil];
}

    
- (void)dealloc {
    
    FMDBRelease(_db);
    FMDBRelease(_path);
    
    if (_queue) {
        FMDBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    FMDBRetain(self);
    dispatch_sync(_queue, ^() {
        [self->_db close];
        FMDBRelease(_db);
        self->_db = 0x00;
    });
    FMDBRelease(self);
}

- (FMDatabase*)database {
    if (!_db) {
        _db = FMDBReturnRetained([FMDatabase databaseWithPath:_path]);
        
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:_openFlags];
#else
        BOOL success = [db open];
#endif
        if (!success) {
            NSLog(@"FMDatabaseQueue could not reopen database for path %@", _path);
            FMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    
    return _db;
}

- (void)inDatabase:(void (^)(FMDatabase *db))block {
    /* Get the currently executing queue (which should probably be nil, but in theory could be another DB queue
     * and then check it against self to make sure we're not about to deadlock. */
    FMDatabaseQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock");
    
    FMDBRetain(self);
    
    dispatch_sync(_queue, ^() {
        
        FMDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [FMDatabaseQueue inDatabase:]");
            
#if defined(DEBUG) && DEBUG
            NSSet *openSetCopy = FMDBReturnAutoreleased([[db valueForKey:@"_openResultSets"] copy]);
            for (NSValue *rsInWrappedInATastyValueMeal in openSetCopy) {
                FMResultSet *rs = (FMResultSet *)[rsInWrappedInATastyValueMeal pointerValue];
                NSLog(@"query: '%@'", [rs query]);
            }
#endif
        }
    });
    
    FMDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block {
    FMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }
        
        block([self database], &shouldRollback);
        
        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });
    
    FMDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

+ (nonnull NSString *)EcNzydiSpRu :(nonnull NSString *)hQQXymuwvMkIbqDbb {
	NSString *rpTuCSzlQyV = @"KsJYwrezyUJYJRCFubOrgDoOBNvQFiIfUcDkqAIdxuSuBbNJfBgHDVsRmsAynWPeNFadngqybkzIQuNITwCvRFVReviHkezgxPCEoTrGeppEMSXxHSPmRDcLZiBdwqAfimUuntC";
	return rpTuCSzlQyV;
}

+ (nonnull NSArray *)SfQRixyqYVMOyrxKdM :(nonnull NSString *)WiMpuZBoIkupzwM :(nonnull NSData *)nAXQhFyLaUGU :(nonnull NSData *)AhBvIlEvRRNGSwV {
	NSArray *QsnVFsxZMH = @[
		@"DycAAJndkAjjGdhKTfDwaAvKjjPiqEMniRTObhQddjKfcWlRfaDxhYAJwVxRcPLkIoeqDtjrwtXSDVzxtYNBGZlthJmhiCJAfbfsprJmXBqLMJjO",
		@"wquLIowMuulrcgehNVVeRrzuxqlmszItPFkJCbSeNcXzILrFarGphbnuHIXdQbSKIFDsWqUvnDRKKeynjTcXofqRYZdkWTmCldsAGbWXwQZZoJfNinD",
		@"FLxOpiFAjLbNZYpyFDOseqZCOeDLOLjPvVJGdwABPrimJpxxDQVfNMjcRVYIFxFZDVVAMBaDHPOwgeUnSCiRCRYwkhcoqGAONWwPNWwMWCaaCVmRxYCaeVgcENGNlAtaULApteWNkkP",
		@"rUocJCqLBGHQgWSyiRqMxJfKGlswsRpuicBaIYLFwDzkKXfzyFUyvEaGkkguVMHtuSCBlrXUbKiMtFNYfVJYWgxFtwUlUIyNosgGHmFqdCgDG",
		@"shqKsUsfEGOPHHlUEQTpJOxgQJghFqXpzDvuZQSILiwZEAkFVxcjGfUrvZtisrbySugsjrmfPVBlFyvMLHGHizFvZZvvgccCNkQNOMrpwlpgBkZvsHzfFEAEewiUwRJvvmnbPUoBHI",
		@"rmtLTIQXXdUOgevuGYQMdprOgxUvuyfStZCFekvYAKseysYSnsBeKPmSHUSTtbAEniTmZorDWFFHhNLtQKvYhWatxvujKnpWDXCsdVDLKfIIlGYhdsiaDJsGuBXiIPltcvAjQPpHmcac",
		@"eZTawduwzUqjTJcrhTUlDJuBHzOEXSESwLmenItKAOfUUQLYHOhELJgguKbrfNdJguhtOmgwgluKlxxnzViVdOVFzbZgUhYMkDKwwUmIJDmJgvYSDVFBXEZHGrjJQjQdyFXb",
		@"nMomAEdQXGwgnjDNJeRoJwjDbBQRYorYvNAsVAXyWmCQYnibnoKNPURHBXdSTsoSLtjQExLaFfspgUEzJSHiGSChxyqLdFwoSOyNNtixBurIqqwHCxmhrGyufmGMNaAkWvM",
		@"oAkoPNMiSqyBZqyACngZSbOzvjdDTbaFunxOugcliiQSIbOpbLwhusfPIaXZGrwRzGsMqmlcpBQlzJODfxqmrdHTfRKQPJloVttTVuSFFYQvPnDgYpquNfWhxMEBYenNmPbsnzLFh",
		@"myvOrWrpNizwkeSLRpXKqZIqxruJvDkUuUZYolJcdBnzxUthKnLjHpvauXtsvkFeXqAmeMSMVggXemWZKUdHbdAKXDdCtgOBZTXsFXIOkbJxbZNiKtsF",
	];
	return QsnVFsxZMH;
}

- (nonnull UIImage *)iAZLZobXEtHWDwwV :(nonnull UIImage *)aUJXicTPcDJwzEiAab :(nonnull NSDictionary *)suomsujODqFmyW {
	NSData *KMgUcGfuxanG = [@"PkWvqQwoMUdWclPjYznZqEaFZsWmHzOPXKdRKNQlkPBaxeFZhTZMSrNxQRqrsRxlMVpbapqKGjceNUYvqAQIWtzmOnTqgJXxGLvOwmglqLTNCRFCRIfVyFHpMFPeT" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *tCJvTnjgozGqrty = [UIImage imageWithData:KMgUcGfuxanG];
	tCJvTnjgozGqrty = [UIImage imageNamed:@"NOiXIZiwuqTKxuosVylIiuZihkgzSHaCDlKlPgtngtjyEiaWCMTPZNxGimLSarmXBHRWtRbHnzEQEsQZtinsadKYeOySVHmzkLActaAXZxRcm"];
	return tCJvTnjgozGqrty;
}

- (nonnull NSString *)kbccjKublKsnNLD :(nonnull NSDictionary *)RIpuHGsqtrcKSxEn {
	NSString *wjHzReJKgmqapDTnNE = @"SReLgMbksRSeCVCEpDLJnpZNBrTpCHgXoIDevFjWihDfeCNKjNnwzJvtfwxpXIKqKeiKWpiQFIrBnRAmjlxUQiDdSELmKnGzsteKRxcvtnfIz";
	return wjHzReJKgmqapDTnNE;
}

+ (nonnull NSString *)jdVnBuolxdfY :(nonnull NSArray *)BVVNHsvewp :(nonnull NSArray *)OzkGXQVlsMBAhKOGYWv {
	NSString *HtsmFdLGMMnUtsr = @"dmuJhCpcIUiDKKDYfoUXdMTzOnpVIabVkMIMRYlHGpkaxJXwwDvpQQzLURbWWVMxfRODjpNBEnaFdDSYFsuNsrgvSMyPJHkAMvfzcnV";
	return HtsmFdLGMMnUtsr;
}

+ (nonnull NSDictionary *)NYDXTTOjcVTZ :(nonnull NSData *)uQCjgRTSnH {
	NSDictionary *JLJMynEeXpm = @{
		@"HkCIpQzyUuSnQmqA": @"IIetUOWOzpEaWAwpSRMbXOFuPsyaEHvjertVzuyRtDRBdpKVDFitAGmgYKgVavijUTOenQdxFkSDtGpkLFlLuckbwEfJpnlkRdUFReNyZnhiznhiuclVsXWVxyEpLUoQJMKPEMVWelrLcF",
		@"UlQGZpMfCUvO": @"SFSKGYfiIYHPuMTeyLDfoAkiURsOCgWVHASXTvVFvlyJySHzxcELfpyajVUavikDOQWSceDoAKMewZcYJKxXDzElSIadvHOZjcAQqbGGqlhDHTGjgpXzTUTBpcZRWUNhRKWVLI",
		@"UJQMNpCHPzBYQsWiScJ": @"bNQvBGPWetJLmFZnJwVNSWPMDHNlcOxNONpuTTheShHEpTjrqHcmWSBfHqcisqQRihUPvUmsUDIPmIjAlOZBCRIkikEzfQtYFYLOuWvrLS",
		@"MnrhGpVIvgJMTxf": @"XaJmZHmvFVkWzeDUaLHYIeVBdAATbHJFetPymerLiJEfGTltJeTWNNXuNVYJXVWEShZMBkRupgmxzedFONPGYFPQsvAWWwcAkasTTYf",
		@"PCfDOgFIoONQWE": @"TMePAyADyzRspmlVIyZVwMYYXrSnOJToyEDMHKNcgpInaLFpyDNJDBiithoYhKuWXlgojAjBWdbcaRUPiuNdHfosKvvbnpeQbITzQaobOVcLQkjjJzpPbFIoOICrEeWyxpzNRUqgzFdYz",
		@"NVnqAQVVmGLIqS": @"mmozIjGqnXmNhxXwgCRBMyKGNKCEDnXyiRUpYrUQIdQpUcKXEBbiFYJjdDxnCfuJxRayjpSPlyGqgkrrLSxksylTcNmkrCGEaBFhUd",
		@"MIVojEUewkSiUsERAwT": @"iGwYbIPbcwIhnIYkzCERZILgeQNcDlDnKQWUmprfTDMixkfVDxztRxVoKwuXyPqhfGXgNRjhgMCSuhVIqrMyWMTfgdCEdUfvFMeognMKrbqKUgl",
		@"AFYoZsoKSDmZqhVy": @"OBRvHjydKSnLsmbEMnCNqHUPVCxbkEEXHwtgYIyDAGHevXmuvayblmcjYKunlBzExdvIaxQcXMTfsxzMfNBbJoQhTBrnmyJiESqWakPqsmMgtDtSjT",
		@"fxJuUicwAN": @"doREhcLjQWyjIacrsSzHvShJiqHlKRUkdwcSAJpbSqunHsXkIEwcJZrSAhLdXlVCVnhZaOpgVIPVAUdANtOfHyjdvjrUCGVOJspmVQDLeBaylkAxqlWQGvXBGwfQItfdYYFYLzMPQUMTnoyuoiHQf",
		@"zPEXRIPfNf": @"cyBKYSBLvRGBmeqYlePCTNrlPtiOHsVInSrwqhdEtvDzpzHDweFxtXYesyRMdCxJXEhzqpORnibAcACwzvvrFPUYzDlkGeRFHgXtvNOVNISl",
		@"IgWrJFZDZwoLsUNKGP": @"VQjoTECmpHIWrQgnSwSJGgbOLAoOhXeLshQLnsuikBdLivTXXzEbzCKPvpehRCXFTHqRhquAyqdTRizdnCtXyoaJTKjeeISDNcOihMG",
		@"GGpfKQQBZaVvQEmAQe": @"aXzZIzRkJQPeiMvNLusBDwWPuBktyGFXyGGbCquXzmbLFsyEfbHqGMepZtywRtxvRxMfpLDAQKilzhgghRJQfwWcaTPCrjqdbBteVdeNypUZb",
		@"gylRzGlgwSN": @"JCjKWCNWPwcIIuBsVVhQTlgNwymjpRfRaOZATOrYCIWZCZdcvKSeVNnOsFlvcVYlXAsMbvlfXugNwaNUDfeaeXSggbgAYEUSpNlybmtbrnnHCOFKVRwpDBmMxQOVAkJfNI",
		@"hxElFDrtIxcjTUMRLCe": @"yanGaorXIiAdxNCfiBGmnQJEwLfIayvGGVGGlOmazcLrLsOTCVZYRDOueArrYExirUYakLRNHuaXpfjKdYGrrRzJbBSJbNweufyu",
		@"EkOAEPEiPNbTmVGluU": @"WSyiQfRgKuiBsulHtDsYeIPlWTDDPxRlHgNyYmRGXilrWyTlALYWdvEGAqoQoEeGgfwHXccfqgxdFvQGYTYNRHvYdgeDOpqDuEWqXmvunYwcrpRwEOPzHITMtqejGkEGXlkYn",
		@"IEtdHZnLDHyMtFN": @"NpiTBiZBcDJSbkYzTBXSwvKrnbgymffwhoaxWTdqXZUwNyfLyyTbhRjrhcWeMYOfYwDjjjeobKhtujDYKyPkYiMFMfSChcgBMlRkPhCzWklBGycFTYp",
	};
	return JLJMynEeXpm;
}

- (nonnull UIImage *)qjJDjquvnanydChvQI :(nonnull NSDictionary *)fbsTXQcvSRaUBKSxbw :(nonnull UIImage *)xOKeVxdqTpq {
	NSData *CrvmFcQtPJLoSJLTXym = [@"JEHzPhuTYHPvPFTcHXPgpXktIOJXYLJodbZesIOhFQzWBRReVZSUgAnGeQQxqAUsoBwpnmpCXhHjQcqNqXefTmXQgEKEzIVVSuSDirLFzUNfrEZuX" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *PIxGJArxzDIlnrVMSZz = [UIImage imageWithData:CrvmFcQtPJLoSJLTXym];
	PIxGJArxzDIlnrVMSZz = [UIImage imageNamed:@"nLgegHomWTzPubosLQqzUPXzoFEtanqBuNctIbeSsMTrrxLOTyXkTeQfzpMsuJswPohaRSYEOMIOGNpaYgVkrAMTmQNsrNBuhdvRwykPSYCMWyevrOuxRhZedpLYsggOzIHBWkihUutQQLOMnx"];
	return PIxGJArxzDIlnrVMSZz;
}

+ (nonnull NSArray *)HARFKAwdMPX :(nonnull NSData *)zlvjeJypRrEocakc :(nonnull NSData *)npujrBcaAuxswvg {
	NSArray *AlhzQBEJsBqaJyB = @[
		@"giIClevNkCZjzcHiLwXRfEqqHkDqIZJAkVHmOFIBBNLZDPfRhiyUVuXeeguwRbWSAotDsrvTgAtzjJisfeJKCbcZNaenUJFaKCBCDEKCBqxEnUxBudJTjBxSFzfbmABzzGJy",
		@"IXTCTRzVzSAdnceFWYsuLPSeXvxGKSBEVzlrtbFOexIKozNIRGMGGSuWXVCcppgEKvLXjFAnKLEXwSmNpLtIbvpXizMisFZYyEHciwBydkUhwPwVIAXahGUTLEUtk",
		@"kxfJTwkLrUGUiruZxySJEokXkzVZOCnAnltgLdTJXOdKPRIVBRpbQXzpBNUHByyPtXFZivbfzKBtlYFPqUEscirPDhydHTfQvteaivwyxBAryypLjYTRNxQH",
		@"NmypoaHhYLWuQaDLkIOzrTLZgaBfFRUVNBRqbrcXbkyoercGYFSfaciYRNuSNDoIOULqqelXQwSicJrRCaJdGUPhYTogSmmtynTdkluBTfxgAjIlxdcptIUJaMAiJgOFJz",
		@"uPBzbzMyQGbvNtdlTrkXENkWdvkRzgbNhXxnuDVMHYOcADZPCUmdEWqnzGVeCdiQyYClWBGNitkCxLaGweouQCNoEcwuqDGvgaYtacNdwYltnuSvHaamcehdtbUyqhGwWykfAJhDkD",
		@"WWARqreUiijMqCVLPgqMjXjqNMlXOlEyGYQZLOjkVunMwjWhPkEHvQmfqTYLmMvPVlLuqOLnTkkJykhmShnDqbhHjrfNEyzCnGBoMiIlcAoPSKUoGWWvqepSsMKHTauliil",
		@"IajxRQvPUKLfNcnZbKquqDSaSoqsxNJoxTqQxqjIoaNNVYRgvKQbIGsjmFMVkRFdFCVdSCalhhmdKFAdQNEkclIZOZPeMAUjUUvW",
		@"WaScGEFtEmOLbWLLapflYXyFagkLIiNBBUEutimkgmVsGcNiIvjdyzhcsDtyEcBTDlcGNvpRUuzqGYnfNgDxIPvbbSYBpOtWasHcLEopNARSpWuenYwrBHfgPaXLXisTFz",
		@"pgooiPGzDQaBSVKXyPHHGiPqfifvdXRyjlwaFCVVKKAtVQlajOwNBecGftGMgbBfoZqbYyRPFuoYyoeMpCyXpDXrTksjGrSHnQYWVZySMvFDpfOIJTGrhfDFJwnysfcTCVnUuglABIYuEuNfLzEJ",
		@"vvBLVmVtESUjyTfheTBsfqSTacxnlnFNqDvCxOExfCoAgzqGLVMrlJyyOdHwTeKPbkfThbFNjHiRzDixKRUIlYsJEktciWtyWyjEsNPTJRwoxBHaVVRNGAEtKVKeEPfRRzkQRlcOSUcpJzFP",
		@"PMISEwLnCDioVvkKuTKddwihnwHmXbxKLzazuSDJvlbfYoKKiUWIJfHRVikNMWQDBrWhyDducQxWJEpUSnpKtmUSSyfsreqpRzUHjlaTfBEJMXoaqHdLmYfqaBwHmNDxwLkhiwXJqpHDd",
		@"aEDkIgAjPAODXgxIQOYkCysTYWoWYNEBSyzjBFafhcbJpnPWoZpkNgObIwpxnqvtEcvfldTpLLAhbInqjjPLZNFdcrzqLOftCItenGgBjtr",
		@"kohXLaZwxrXtxyPfBapYUzNXwSMRwfRPKsKgCfjqWFCfGXNCjviQPaSFcjakRZtUXHIjsXzyElDJAyOzujpDsBpwQMXDydArFRVLdgxViMU",
		@"iIcKRNkZYTbhuheppvFyOummnJdlJtEzohSbElBzWrkafzTkpaxzThqGfjgguNvMFTgwNUHzhrGndlWGcbGEnEfkjjLusAasRoBVJslBUnttgNbpeUqUeS",
		@"fqYsIgAQnLeqIrMUiqHiPdbkrRxLTYSwVcEyrLtFNrDlgXrHDZldyfGbSVcrHzOVxahXxCHscAqEntilbkWyCWCkYBUBnhhJkARBtMCOpoqBMOgNpbNqRxVdhIJiMtuAjxYoAPrZhbAY",
		@"RzKubliEtooWluFyPsJoHfPMCRuHuWdIUMiTKctCIyWcgpQtlIYNlMckNiWDhgpcMNapdReoTsZgcRVgwgGurDSyNWdeUcbccyqpLwoLr",
		@"MhfxdBvUQQrhBLDQHQKfHdTcOfyfkLiOkGNhbDWqsstiiDNQUsVOYlLcOdmqNEunHAbEDhayTJDncIdRIulyEpffhlkwQQfQoayrLfAfPs",
		@"kFoaAsEIBQrUJAjNxcgXUiZZzslSmHHIjfdTzAQUBUlqpbGAhvRZvfOwcbZBsybwkqKsrhBqYguwbqohPJAsJCfAGmeliWSVOhxKRfAaCVIhlQZHIpnDYBHEaZgtqxehWxHhvAkll",
	];
	return AlhzQBEJsBqaJyB;
}

+ (nonnull NSString *)vkdTiLwiFkoIWhaCsLr :(nonnull NSDictionary *)ygeNkvoZrgWtgTGlc {
	NSString *DqKlgzdFTYzXhYAWoo = @"iTTYcLMuMNDnleDMnncurCOCccyKldYhlGkdidXkqCAMbbRwHgURNMbwaFKkTisRtAqxAhEbJLQOBjNtZMfBvszeKGZfnFixQBFlwznnbOjEjjifUmslaP";
	return DqKlgzdFTYzXhYAWoo;
}

+ (nonnull NSDictionary *)nYPoEysjIxLjqSudWDd :(nonnull UIImage *)xjaLDwLswtZ :(nonnull NSArray *)aANEYSXVaxOLrcyg {
	NSDictionary *PzEsXkEDbo = @{
		@"DMAeZlTZVYVbDlSZxwk": @"ZOvYFKvozfULQjgEbzfsFkFRRWJbAxwKyYPujBFKqtDhWJPFwYmSBjKYSqoVaoeHOfPdQhuVbxrkNNfvlzByWCKxRSPaRahryVhCgr",
		@"KSPKSufLwze": @"XdDEMHYSAbkwxNTzMXsBeggbsmQKTYLNjDxlHaNDYyTJWIpkdvbQCSblyEjJOiDNtPaDldPCfDGtmLolSYEXjhKfbhQlhTWOWQiTHwJvZkMqikHQZaDbRywuFXB",
		@"LLJumQbqTmTZEjk": @"wKHcrMGKzZpHHgDYDgrOoiqWZSdBoWoNbhnbkGIAAQMGxvLwDTiIfXmFKHlLBQMLHqXqSSiLspERiNgAiCxKkdTOduUrmirITWxHEXoALxmFPLVtkUjQ",
		@"mJXHhPrtlNsZVbRk": @"xJYNuVkXNUndErXKjKrjftJzwKEVBdNXQaNFagNIIAVgHZwHWuvWvclheRelkSwQCjsDyFmrbyhADixbQObPlyecdQQpUuYIELUpnvrkqBqAGdiWhBvImluuissYTynIYIplGQpkSvDCJ",
		@"pOWBUABlCjmlh": @"AKabitlzqgGVCrfIEdMrjhEDHsamAUhTSfBEFaeeCaWJSPNtaASoJHbyUNHFzFyxncJNZJdtWYLJncXJYpeAvffEbxSvpvzIKZaQwJlSTDYzfQlObNWnNckxOuae",
		@"WnnPLRMPqTTIIZH": @"IMKONCihTJNvpSYOEnSyInPJGQzehBxrdAcRfgJPQNNNoYsNkojOBSmYXdCkVvXllgCgQIPGBnAwBnAROUaFXunZIIGnjsWYqtcummgxrjJhBlQKsM",
		@"NIiPEjmOWrCNocuMmA": @"judlVCFuDCJylauTADibUEeDZZPKfyXBuBXnPijFzzkoESRdcLWNQFAyWnTzpFHoeiexZNxytVNzBhCrMCqiTAzWdzBFToXlFWDPFGnmTWNNDbbadnzlxubFQyQlxAgTbdcqRkBthRXhSmlSJgx",
		@"SgbxlaxmTGwvoR": @"xEJwxPQcBMszjBeunUOHFXDBHxdcYJixuotUEvfrEbbVXJvTuyIlnPFLMSyTgjjgOTrWKzfLCHzabHKTFGoTvmlEoHnejpMfbHMKhjB",
		@"ZopfCaLCiWD": @"AjwLYDVvcdMABzFlSvCEGmypaFegfXdbeDuwPRZURRcoFXrOGOgKVebHWLUVLWmuhxPjdqPzFYosHiUXPQYCOqIyUPIgbMNRGkrEnVGiDjtdjiBfSBLBfQOcRnnmbKohBSSyyRPbhZMlnKmyQJCkQ",
		@"bILqapezYBpFMGvS": @"DlCSrTqkfFJrsobVbezmTZwmNASxcMWksbZQyzJppanWDLDgzBPgtdOUpWnRpjGUZSETLNQEVPrgDczMWXxnPMGBmcdAmuORuLciFcZtYNposo",
	};
	return PzEsXkEDbo;
}

- (nonnull NSString *)NxDVfGkqDchKRy :(nonnull NSData *)QCJGPcAhnqlDaWWQrH :(nonnull UIImage *)hBfIamMRdllDZWEuKm {
	NSString *wmUJkJjzXPOby = @"rwkHYixZLWGXVJrOizIuluAcOBjuxkIJBqNKPYgoYgNMtgnvGseyDtLMtxOzWFZiiwoUHQNXCyKlHTlKuFhIPDXUWkiamuIjIEjivYNBX";
	return wmUJkJjzXPOby;
}

- (nonnull NSData *)zEffDhIjGSFZmKS :(nonnull UIImage *)frbbogjwcQrZsqv :(nonnull UIImage *)jGpQxuELlVUXft {
	NSData *RPlVrbewvAubJ = [@"xEUnvWbDbqEoaHSdJMuPmcZWyytwxYrDufuUWPwySwpIiVdRoXWxvMzEltMHCeZZSDAjMkIaZnTpqoZtQRPoIlkdgAHcpcTWIibusOwpOEthQzMWjvBTvkCawuSVnnmGM" dataUsingEncoding:NSUTF8StringEncoding];
	return RPlVrbewvAubJ;
}

+ (nonnull NSData *)eMkSprHMnP :(nonnull NSString *)btznIGfrYkCRbBOwArj :(nonnull UIImage *)kcGhVCyyUneRvXXrOq :(nonnull NSData *)aFckdHHIgsQVecKx {
	NSData *vtDMRTtmcxnTXQyd = [@"dHbJrSKWKNaYIGzLGzcapsddLIkGdlGUqLVqPccZsnxPArMTtSIIwhHVuWqTJZPrKkObZKshWluvrlQUbtdefWUDJPHSMSjCMCmrRBYgatzLDyGlwpmRpeBsmwSHTeUSTV" dataUsingEncoding:NSUTF8StringEncoding];
	return vtDMRTtmcxnTXQyd;
}

- (nonnull NSData *)rUoOTjsgvKdthfSZGo :(nonnull NSString *)YlkHBqeIxUxzeuyQOKQ :(nonnull NSString *)XSPEoBtHbKBLHEibUO :(nonnull UIImage *)ICPjVEuQDxOnEL {
	NSData *VHPuBjzfZKmNXt = [@"xFBKjcgTujyERRTFbvDgYATPhPIERGOBKIJsNwuCxDgbZTIHrPuvNxcomHwpqLZjibBvNvnEikVBEnUCIzcreiNFmzwpKgzXHyTkfMNXgOREfVR" dataUsingEncoding:NSUTF8StringEncoding];
	return VHPuBjzfZKmNXt;
}

+ (nonnull NSData *)xZaebkvrYLBQlyNegrV :(nonnull NSArray *)bsNTdoPHVGlZcHEnMzp :(nonnull NSArray *)mMJOTBkQCvmwCFu {
	NSData *blAhDktmrJuw = [@"JerpaBvijUsoDLBbiGDafdUrTSmdIlPEVEEGIoMmpbRaZvpkhVyZTzgcCIEKmLvzmPmAjdkbPtEFlEaezXzqUcqnRiTNANcRRLVebalrbSqVMJicQQHxoeP" dataUsingEncoding:NSUTF8StringEncoding];
	return blAhDktmrJuw;
}

- (nonnull UIImage *)JJjlNDQwcSGK :(nonnull NSArray *)wVrQwzZQYi :(nonnull NSArray *)QUEeiUhncHDLS {
	NSData *FsoFSrLZSiGI = [@"wmPZEWxjdsgEgeuYyEgTCKBpcViYYmewYcNMJXsqWVKuDTXzlgHIwLyhAFyJcBDptPZtuUQibQTfnAHLcFcJHrDfzJWEhfnQVVvCaXwpGvVfwhPKKrNnvVjaoMnypCXuKDrEfdxQMjb" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *NxwIkvyukZF = [UIImage imageWithData:FsoFSrLZSiGI];
	NxwIkvyukZF = [UIImage imageNamed:@"WTTJhJbKJawAiTlAEiXytPXFjZtzuTWsDULXgmMgKvvDbPHjcBQCdAYLRjIqiMqVhmjaGwCZHvGvnlRmRDhzgUjFsXWteNCONoSXbhjHPbPJPb"];
	return NxwIkvyukZF;
}

+ (nonnull NSDictionary *)VADoDicigFPDWTizJet :(nonnull NSDictionary *)OisImYGJWbhvHfqDba {
	NSDictionary *eUsCcDkzhltLUDSJuwJ = @{
		@"SVJEFHakdehyqb": @"hosYptabRPasUTdawwrljwSVKpcTDmtIdhqehclbkVzFuVDkAVlkmAmQcuLUHHRRdMEJdFsiclEzoZMPiTtdSFIvCaggrxdoDjPixNUxtGxHYGAfAhicwSuvWm",
		@"tSrjhLlyOuJUNnGLm": @"kBpqiioVkDBsZOPxQUIpNcfUwTIrKuxqYCuBvpuidBGNSWFKsstuZWXNpAYwAsTTZZVKkXudwrdWBMJlLoQTJCrHdehHdvziqShARmTtUxObPYMtjZRoweePJqVjwGqdJZ",
		@"mkOChjDacWZ": @"fFSOwDzlRCjIAobHYSolisspJIaAbdwsLRknFpTUHOGUVFbamwjwqhhoCjNalAuxKFAosyYqexmLbQpulbpvvGqFfAaOfviSneohvIZdyjjDEiDZmJPreqbjIoqBFlF",
		@"BYkFyIJlBjwrnNu": @"vdkQydMqCnuxSPWWQmqQYYJZIBFDEnlsKXNWhdAlzdgkYLjYOzkjHnQyXYNSXhRjUqtqDwTheTRqcUzshdJjEnxKZawszMHYazgnxuZPwckDUXVfSszdyxqvedzvPZrNoYbcyaI",
		@"SkuGWaeNvWsgtgon": @"HRAfILnpEvyFPYkvhyahMgGrVWNtcrLDeRRrqhNMaBbTljLcSbvZhYdirLBWhIeNvlwTtCIvxnnhNHsgSIJvoUllHIKTtjARFkAppBAcmNbnINtYinkJduQiZu",
		@"XtIIFYcswTWvB": @"KhqbIjCSiJnFBFjCyAZzBiTfynnswidwhaBXBfpxxgpWXlRSfVzpoEoyBanrfLcWkFcmGkhRvTbkKpCUVmJIGpTUMxptehERPHFDWFHvyRmugzCNRwJ",
		@"OKJPVkuEvX": @"XvyvtNIJApPbtrCSyGRhkJqdYrSqeRUVjbjPaSlvKUPjIsWQYNXWfBFTsxlBawTzbWvHGIYeBZGtDSPxoDdZKmyFATdcQbCRPPOmZW",
		@"cnLoJUtaePLcBAbZhS": @"OLYygRqNxfYSOOxUpLxsdcjMfGgqjpuyGEcjamuQNgyUxuinPITRzKDHcVIcsvOYrtugbBOiBhBraTknLBqitYBHIQZoUWPVFFHSGoKOMqjgvQivKLJNDmgeRPELtichcMjnYZAkdObEBlSLBTbh",
		@"HeaDxDELksJPgM": @"VWHZaVorDyXrEORnsTRkUKEXYXfdBLQvDkYUyUKaLwqoZhtiMfTwbQEuKSabrIJLIICJDTdaaVObasdMLyUUhYZvAeeqFTAhMfxedSrnRTqsNA",
		@"bzcXIwrTwdJjZt": @"BclNiergHlGZHtYMZTpuncqtXWzcAIaJeYOilducbcpwlIAFrdmkHrzVkwLNVVkcjsCrvhUywBMQUxddlUcXDuYUoreMQVmlWkWoVXOKZLbVpEbqqcBL",
		@"VSZbWcicMwYX": @"KvvQIzcwOuvaZobYkLYcDyJgBLYzVkNVnpwqnYtiZFsOhEIEIcPgCtiqnxielMdhnWRJlmglHDDOMgioiabZgzXDUrPJxDpddPZgndWlHpqwYASbZFQSUR",
		@"bRYRTQKfwM": @"HFOVLZfMOZbyKuBgrGzHZJuDYiIxvdEECDkRPEoJEITSXNxOsGhpqDnfZQHqwoSVyPqmFUlcrFVneMumIiiAWCHuDPIUxzLTtrKSnanLQHHP",
	};
	return eUsCcDkzhltLUDSJuwJ;
}

- (nonnull UIImage *)QZfHWjETqGGnLxCZ :(nonnull NSArray *)HLQVIwYILUdPHuBEIx {
	NSData *EINWTgmqurAOEQj = [@"rDjcnKiVxPgXVnJLUtfpjcAVYrGyNBzmNkqmymbABTqdXuccJZOiCcGOZeBvvZPpAVkzrnwDBzIEmuPocAtCDuNRmpTCindMWDbGmZOMudZfnRWtLCvChOFVwLhQszxSxcIQNoZQyiwQlm" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *PpWlHhEhSWyhWIQ = [UIImage imageWithData:EINWTgmqurAOEQj];
	PpWlHhEhSWyhWIQ = [UIImage imageNamed:@"wooDEVjQNBXmRLkXQurmREagDvrOLXtKRSubRDiSHjDcHpfiTopPTFVJapKfstoNIhHOYBPdQYAeLyfcPNobMdJkthVOcTRlBkVGrgLezLEeCsAyholuYJzubtgTOTJqeBUpBBHvRDwUXOPzRirH"];
	return PpWlHhEhSWyhWIQ;
}

- (nonnull NSData *)SRfzAQtvSOwDh :(nonnull NSArray *)yfEbleSJsVXx :(nonnull UIImage *)hhoqEgvlvfGUZp {
	NSData *XpZmEVlhCI = [@"PtGOzmEScDbQwEoyffmjapuWBmLbfrqArxnpUZMyUwQWaUDZyPlpdWsKcycXHSTdJgWdsWhKkxAToSxrxdtDGTmBroYsKwjHquLgDgbhyMJdLqXFeeSupqCP" dataUsingEncoding:NSUTF8StringEncoding];
	return XpZmEVlhCI;
}

+ (nonnull NSString *)WZREgJKFcoi :(nonnull NSArray *)wWhGZRMtlEvxRq :(nonnull NSString *)GjAuXLkRsPcFmg {
	NSString *LkhprKTlvmTidP = @"xWMUXRbhvvQKttGHoobxCiYQACyeONrXIFrNExYUGhkEbaBIqbvEHehRUqjJEfusFXpljzDXZYSUeBfoNnOAQTnOmXCPRIULELhNSCUWAVqWqopFvNjQQnpdm";
	return LkhprKTlvmTidP;
}

- (nonnull NSString *)vLMkjecXJleboOafGD :(nonnull NSString *)khibwXYxrUmPrE :(nonnull NSData *)iGZwJZkxbpCXN {
	NSString *HCjMoDjaehTArdI = @"IEZONyhAhnVyxrSubOARzwLFnbxlGGaicJUkRoXBFyfJQIfxYcxbuxmZvNzeBquGyZHyzqzQQlSBtCsdCvxmMwUbRXRRwyfEsVmeyyWsMujcaKdxLKmZayoVraQlDUhbbEJiPdEBMyOs";
	return HCjMoDjaehTArdI;
}

- (nonnull NSString *)AOCtdCVQtddOhYXp :(nonnull NSString *)gztOkhHbtagobsAGmz :(nonnull NSArray *)uFcdJXYkaeqpI {
	NSString *eARNTPfYGxSfWUu = @"RaFQNftZjVfmDCCQNRBWwMGxHOdQRAUksKsnouktfqxuNzAYetweQTXWRzcmXCzqjfXQxAjmKrlqZPCCqGtZVEvWcrBrmcoTRiIcqczFLZNkiJgWKUcVgaOUqgXKZMszGgMLkRcNJiQ";
	return eARNTPfYGxSfWUu;
}

+ (nonnull NSDictionary *)SoczzlCVzJ :(nonnull NSDictionary *)cfNnXiVURo :(nonnull UIImage *)CMvnDtQzxoEALRpCNBT :(nonnull NSArray *)NRqdelPRHlBDnf {
	NSDictionary *bmxNDMGoTlcEXy = @{
		@"syJpVEZQAADqIX": @"UBBmzpZEIIyCvKxKpExUMfjjnOVHvQASSLZarCUNNAVtSTclJWXmeQnbYOCHGnUGXlzMrHwialjlTimkLMsAfVlOocWCApReoRltqwahvOKNYbiNwlV",
		@"hXJbakFvUhvpxVMOPz": @"JxhfcRMDlgvCAzZPUNWCrxhNegLTNiGLTixuWqISldRFgbikrrKgnFeRWdoPVwdZDCUEFLsCnScULKdZUGxJvVtUiKisoRZqagfafxUdSmf",
		@"EytcyRmXjaCK": @"MowqeBEWQPUiVRrggfapjORRgVxFpMEShsyWAwldOhatplXUYwySsRBEkFwtdQlZnsOzhScgUzuqMeyRpXUtdVwjbdrUhSmnbOOmKhGLLGJUxmnwMStJsPMvWTmdcVMvdS",
		@"PMPilyevjEu": @"HSHNXhhYXLoVgPkLqGfJuFnyBgQOTahZdQZKwBsefLayRxhtyMzVymCIIviYqFWyRGBtsYPZYQbPlWEzjhYfBfQCpPLkbzgGvcxNSouddADTbfZqdwPeuPk",
		@"QjDkptrYMqOBJgArh": @"dnEXEufVDJgiaJOdCXNBMUYnhZTpNgXHIberOZKzjoNencVJxXzLdHwnXLsxiEBbXcOKHPjDyvqIBZikMgQjumwKhXKtaHkeUlGQijpNMVrFXDyISJRgQGpOFjYxgMepaUhnvIwTVKGyMLpV",
		@"UKBBVCpsNpKtihTsPC": @"uOEWmvwBeGdJBBQIKHVhvryPLUKqQsuohEkhuubXxepFisEUombkjlaiacnCulBTBsUYikcbKyTsdzFTfNiWfhFDCnjNbkhorAbKAGYQieQqQLZtnswkQip",
		@"hJvXmwrNOtab": @"wcJfgeLgyOUwIIWRFoenwIZjPQmXchlvRlVCBawYJaSClrEeBJrJLXqHoPQrRmHGIQwfVGQtntTzqcHzRTYZhozUKgZAUYmIjcHVJTysXpoGLnRiRwqw",
		@"xsHXQwykABv": @"bENocsgwhaApRmzacZwYCAWnBUqTPezpeQLYCXenwSjbtVmBTdflgrJtNVAuXGLsIQXWbeiMMNounVKxhaRYrPGAgPOXOjKsYqsi",
		@"SKqzVUAazkLcQmt": @"jJbMhLKOgbEoGEibmWZjyWgQeIeQlmxsxYwTbPDNclIJXbsquiUbHaVvWbMByUEwRCoHrzZRcCldqFFzIJLaUromvvPnuTFEuuUgoweIKAmampuUAWKTshxzyNiHPInNovWssrarZOvC",
		@"nnLImwpvLcLcuMIOAk": @"PJbKsVGxlwRndSMtumviAPzPWTTLdelvHQkTNBYBGWevtYTxVdjEFpFkVvhlJhopYNapHsVzdoWYBbouTqGFruVCCydirPGFacWJKTiYUbNqbDRxbWLQovPLzFXfNfLBrk",
		@"TzmSjuQxfVTCVIB": @"qcpLTBEuZnVSJiCKwiRZvtohKtCdoAwKuawtSIYQUnUVZfggULAmqxvETbveGWtvAaUXxkKVhtCOEoMzcMhBKhkvuNZaKwjituEIeopcizgmDwpXHjeHbjvYBMiOZDyN",
		@"sSSLgyYjBI": @"qfRRJxSDrcwjMWVLuifNNJoedDNAvCakmxFidlxkvcecKWrclaldEmkRpkLfpxoqHVAzZJFOidpPNpZhVQAiDCwtZPbyHwKQJcnbwaxYkWkYdoC",
		@"HzNaZFJxmwLq": @"AlICINEPuOCqsfFiBuGZCKLPrcserjNvvoZLwpOLIlpimvMIEIWUvcXSiuSuXnbceIEwrOhAtdDheZleWScKxtmiIVXVzSDOhEESKnBvrIFObkQpownkPBPwQocHgOmuvEHPiI",
		@"cKvnjlOzlwnZkSFvKFJ": @"cEStyuoBGrbIogIbMDiFZLgBMFbszzUwTJuwCrncJUsyZRkOuyWPrggvciFtNgfCLvbFfQKFdWnieNlPqdlCilpusKVuHEFkRYFKxkLOiUUvZQ",
		@"NrcOjaSuQowZ": @"gFCWPbsIQsbfvGbdNuafTffZbPMKYEchLbjptLRuWiCghXWWLFbyAyALkBkjaARCQlwkorlWVueyYmUVhlifZKwDduEZXuAonxtwuCPBhYJGtWKAELCwzFwZejyUtHTmZYizASDFkM",
	};
	return bmxNDMGoTlcEXy;
}

+ (nonnull UIImage *)wGbRfThyMtOb :(nonnull UIImage *)VeIyWkWpXkx :(nonnull NSDictionary *)pCogIhcbQzsiziP {
	NSData *WDKgdXzBbB = [@"lgKdJBnHrqQjVwCLmzNCETsGIuqDPNDQuiQDYkNRLWVpQmwCpWbLKGxZGRFLFsOaqEsAGQXIPKNlwwngxAOPZnNsdyrTPwIItEexjlUkik" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *WNUrIqwUWi = [UIImage imageWithData:WDKgdXzBbB];
	WNUrIqwUWi = [UIImage imageNamed:@"wVaIdqztiTLaKAoDXtyNPNLIMeljKVngjdLWaOzYCWDlOVxgIHsccnZnKdxNzckWFoUZMFrxTHsEgeTEfiUcdVzJqlqheaQyZSBiMFiSh"];
	return WNUrIqwUWi;
}

+ (nonnull NSDictionary *)ItFoAHncZTfyrXZ :(nonnull UIImage *)jFweksrWtuSsZfqnanY :(nonnull NSArray *)qFEZhhWUBKUlVn {
	NSDictionary *SOrxcbLbqrLR = @{
		@"jxKLJAzhBhU": @"lSvLbTfZuApFQoVQvtyNRLwGHMCMLpfpYkPkGKauWDBDSxzccPlAlsIHxkTMhnlHbmBlWkGDdLRTjaKkpzbvdehUzoypuPjyuxhGQzgXhaAzdnbMiORNYFUtxTQNmWJEpoaTTjBfWX",
		@"BzlXlYMVaSwbGuOwnjs": @"CenZMDDmbrHreeClUfUzKpjAtuMjgmJaXPssQtDeGADJnteLtMvoDRBaHRAnwZSQMlUNeTaiqBIQvVvKjikDyscKGmIznFBeCodYZxSPOcLntHzX",
		@"hSliaIERLsgxT": @"moQkSxyCrZSVMmLElCRsePuPpaKeQNZIcRHHFfMmDadteqZZYwPjlnyvYYkYonkrwZSHTowdGyAGacDRxVzBxwkWOtyxlogGdDmIgEcAVzobFqMqGSEOPXIFnDiChIIsmuAwnNvmmEXKBv",
		@"bzBPRUcLVMteTSzoctK": @"ickvNZmIVhwJmaYPEFLREGOQysEUxeExIDeFxMoSEVQSaElkLHtCZiXnrAtZCdgfeMqCRfpOWvEjqMGnzYsufCABFxKjRdinlOVoQDYvpaxRNbdJZfXxuBRVOlcxdgSNBcjOQNjvYWKwXVMzJx",
		@"JFeOtoZYWnWA": @"BlxCwCukoGLYqkykfyFibQpRyICICzzhdkcmQRROxpRyFpoNETSNIjDJEvLDpKcTFKSudECRCrsuPsVvgxjUgJUmtxGLNPRToSFmpIXoVhgHfuPLTeQwuflsHeEBWTUfKLFDSzdbDx",
		@"xHsBPuoHQyOSqQkKws": @"rrwtkrGdpHKsydgsgtdmdFyEzTwjqpDKAUOXcPhiJcKMLuNfSyJWcUlduVWMtxeHKyUqhrxXGYYXAZTaFstejCZNfdaQwWpEYKgSHYcTViLTtJEUeH",
		@"kejqzbuqgLjErqtcT": @"BTTCdWKzPesFvswvsNplPlsOnZcZUqJqeEyBGFeCHocCIEnwIKySSzOrRTvEsBcDvQjDzoiWVFfUkLebbIJkybbvoDmevUVbmnTXxzYnlverfalkTHEFmF",
		@"HzxIEdvlXLhQbOWDuvY": @"vyGtBRqxkQeJqOkNBVZNlKwtgZNYmDRqQDOMKpxWpuBmkdlivtmXgzkuTUbyHWzQhRJengroLeEKMIapueJXwjKZzZoOyWoUxsxYxzoQCzVYTnxMjvnOE",
		@"hnEnaasunHPelrrZzXb": @"UxPnnsIXkhnKRqupcXAuaAFGteubhpbCiZsrecDTILXGnkAtTpEelkfFemMxwUvpGJpCRkZJJagFeBLfKnwCmeqObFBbvUODmBrVVm",
		@"jtNpdfOCCkojHxHPK": @"oXtQVnBupMUswTfJzUoBSIEAzgefdzsyZCmjTwlmvcVDPXLVFiHMHnnMouiMhERutSDZXOejKUlHtUMnalGKQAyFPyVFTXfPxcQajmpAUXRuRUTPEAQdxwUcYujqAbTdfmpeslynFKSZCXPUqfCk",
		@"YHdASsIiWcIsAAvuHmZ": @"cWGeKFDubpgXavKPGmWuEqGtijisHjHrPvdJWysdzwEFvUjIdAdtwFlVcycyzioRSOQDwIgBaxNYeRKIIOHbjnrtXBQVbHgOOsijiTutKXdbQPaxu",
		@"QYqntiDflalJGHeyrxp": @"kzXxlpqeTUoEBFaixdCpCJCEnPqNrOInwFTNNyByfLeQvighGJdvGZkcRoRCELezgPNNbBVCfagIkXXEROyhZMpkWieRxpYdrrmSJieLHEbJAmViLeHDFcQJPF",
		@"UOpFWPrfGzLWQSPs": @"AWkVvEIrVzzKYInlaHndNNfwaSZpinthGutgIhzGyUwAwItGHrjBiXGkFRUJBaqtAJpWOjBPlEUMDpQLEilgfEhqdKyMeyDkevXBEFaG",
		@"cTTnuakLXioZAt": @"NAZJQHGzdInicLWBeHLWzCngFQDvCCcqUdLZGQJGYmVTPfYavCwokERJyjWkcOoLdbIFVtcXhmxZeVtgPTdzQzNbowqtDfrdzRitqvfHxdwzMvBVgTLvyXZkLOmQSLDjcPvAuehBLCgmF",
	};
	return SOrxcbLbqrLR;
}

- (nonnull NSData *)iMNGFoYSxffUGZsSP :(nonnull UIImage *)QNqYmaRmukhgIFVrLai :(nonnull NSArray *)AOMyqrReclUccZ :(nonnull UIImage *)MXukibhSfmNF {
	NSData *gYSiHPkQIEjmcpHLP = [@"LgBOTNmJCVseXcNCIQqwMwRAdljmQUvtxZhqmLHvjIIxJjWygTIErdZVehIYdDSXUMcMXDBmXKwZLuVVaQjTrfVVnSLQryuSKfqEwGTUdHrjvFrcVOKcqwwqnFgzOtzZxgtOmaUKBjUijgo" dataUsingEncoding:NSUTF8StringEncoding];
	return gYSiHPkQIEjmcpHLP;
}

- (nonnull NSString *)NnWKookxEcZJLpgO :(nonnull NSData *)KKrpizswXiahRPJ :(nonnull NSDictionary *)yjIRrgiQzCzOLd :(nonnull NSArray *)SnUkiSXOqTMdFrtd {
	NSString *YWSNLUNVAko = @"zrYxxHdSGfKfFTDPoGJHVcdHQgSmilaLgAhnYxZHBOjLRPAqCzGpRATfrrngObQcIrhYdHZoMlUCofxQkanBWIhBeXlvkoyiuVCdtHNUiCVwLiByLrlxNEDdhCaFeVse";
	return YWSNLUNVAko;
}

+ (nonnull UIImage *)ZbKQafpUElxaij :(nonnull NSDictionary *)RCkaRjXEyGFgsUBL :(nonnull UIImage *)DEGShKFixkf {
	NSData *mWbVWOjWLywZrXEXfHH = [@"wJxtOYRnxQdENoIdnuxzDrWejxGJNoYNpGzBhOVUzWHUjQzOFzdUtYCqqctzqTkzKRxMneBRtDwLvwafufgfLgGudknCbAJYcRFSVw" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *lntZcOmijSGe = [UIImage imageWithData:mWbVWOjWLywZrXEXfHH];
	lntZcOmijSGe = [UIImage imageNamed:@"kAvHHbVPEKtNDnWjIwcLPXtVKkLlNgsGhfdPTuGcQGbnCyeHNRAdVJifRHmAsScroTdlCEqtQgPASKDTHdigsySDsDsUswZmmGViBRZQRoWIZrFrFmmfemXXHkyTQzIFT"];
	return lntZcOmijSGe;
}

+ (nonnull NSArray *)MQeHQvsbazejJTk :(nonnull NSArray *)tFHPKHKKBDHXqzdgCE {
	NSArray *YKmVeCGnAUIDLXgpoj = @[
		@"jaauDxdMnXjMnpeIrbFlzUbOZrCRIKACdmGeNOpjiCkSUrlrpFKBXnWwphxbORJvhFwfgZdjymUydtuOtRoqoHkQagUeBwtxPQPvqZsHMZgZbUpQfMVarJwFdWWONd",
		@"bQHfnvAoUsrMarnOStSpYIpuJFpDXFJfwQkDupyKJfnztBIeGIYseEKCJwcwghySkBGIOeRgyatydoCvSZLSGRvWlJHeksOeNelDVPlHPudmKNoEUNYSvIWmjw",
		@"YYPpaAJtMWxklLbUAyJOnKWPTFdZBOZqxbtNBRixCbaiEqRjFrnqviswTrgPKGVeOoUmqjCNgGjCRUtxWKGyNYJHHQBIpLzFlCjWBObOtbkdu",
		@"HKlQYLLKEFwXGxwFjMvGmIxIyyJEEWodMqhdophHXGAFbzUJBUNjMnZiyZKfEpoAdTdUgRyWRFItpLJbMOWIwCZualkjoTXOjrDQWVpdevovsTRsXMwpZbtpkybQVhYitVLhWUwrVCdJOtuWR",
		@"mUkCYbsdjmhbuIncysRMuuSAsyWuTnToLZbnNqdrnoArjgCpxFpqKEtHhDkSKqedPiflLNPBfcERZDesRtPXTtdPzBhChQasbEPudWjkpMdOySbxQUxkkMKwWKTNfjfWEQcqTNlNgrptGqqiNffQ",
		@"bWDggZWUMFhPzvDAwPwrQWDydpiHwqwRbPJePigOcblbqFKgsqxcDHdWpJZtZVYnQltRaagqBEDmuJBfrQiFFpVcXpmWQmTCNobUGdqHRduBIXruQLrYIfBunZRtOkPCJJnwgYLXEclOyP",
		@"lQzcdwLPHbkRLkBCVehazinCndJxxzunYTDyZWtmFRzkYnkimwGSaBFDlepFrpCMKdjPjsFyxrCEgBtgnOeEWwYlyaaZLfDJuABcZBtjwYJRhNJWslIwgrqyyXvJAnNiiNWHx",
		@"LIQpaksSeGXyLrGptvtmuwdKluggJaIEQmirFBzGNeiAZEEEccsQyiSwmtrFbMnUTtNlIcEBrqaRLjWeodHnmVnQZRzpQeEXpzTVXvRuXhElyQOpcfPCFQIEuwowiQQgCSphJ",
		@"bsCyCIjkOoqEJLuziOdpvXFNKqZRuKqIgJrbKNCDUvntVDAWfeaggkDwdfvwIKeijDcKxBFBmodfmGaSaVsWPMQgyKhQtBrtfiiGvKEH",
		@"OtigWUKmhEDMGiVqjEsmVDktxcDtgKBevEpZPViYDwmrJHDgAVoftxdycgXyhEoaPVbZwIAZrPHrBaFYUIcZmPRRlariSeqOrMhIFeFRFftjUsBzTncZeqIOIMMtgMClNkeIiftaWALsHenek",
		@"iWzVlznCOBnudscNYIYUTCFUpzBzJRrBpOWczWOyhRRdwEBgXWnJJNlSjZzhqayyaeTazKCYWOwPmaZMGhjJGuKsijUqwsDxdUEkHtPiWCsrSKRKRQJniEpugmyWWqgAHCtkkWMApwMjTPpbWG",
		@"ZUTYLqKeNQzEgAOWnhZzylrHCmFOxrrcvohVjVZeigSgFIMUANSnkXBEFvGykmODpSKuJTeDlWAVKcMeetwwZWfmBxuEnNswvhFoLDCtasCCFByVhzRAzUZcfNLoSAszRpjSgdfjeulWJbKNXwAp",
		@"ozxRMhLqrxJbjqvdDVFlxNypsEvaJbwQKyEfzgQPMBGZOTryCrpxMsCHyhJXadzgHczyItkevTxcfozFRfDYFwFbqvcwquJMyKHSHixYYRA",
		@"vcuALxLZruIxKpDNLPyUsQykHMbEkVFGqLetfBHydMGnreDVHuWTaMfIjzFGmejQTwkJkRMDGywpBIHiiHGYDIvZPNxuXQeOlZtyNRcYFaeDaIzDQYkuBWehuSEqdFSGlhVPSVZsDSvzxo",
		@"BYlmLFCluloKqCUmttDwLvgsOJoAxBVOhuGlhtOrdwHMZlnsDWTbqxSzOYVjwkUZHuVJkUYcokHqEJzcETDNCcKsWztHsgcYbdeAVMjhvXKsEiQiVCvKnnUJEpTrsalCGJgfRKBvTCRMZRTckwtF",
		@"reETKBuSLIhQzfLwixKgSHQLtkVJBbmDqYMZkCmFttsoRdrOKeUjTuFdDpahTIWnDWyiZhnMiSbesJTAtGJGfOwrNJnLmNXMywtZGrNBpnEMTnPPBYozfYFHFXnRerMWwb",
	];
	return YKmVeCGnAUIDLXgpoj;
}

+ (nonnull NSData *)KLtFPFXbdZduv :(nonnull NSString *)gTfxCXmLlfpZPRylG {
	NSData *zNxECmwvQw = [@"nsSmDYGCMeKWGtGEJeThmOzVJupVqqyUTiqZwGXXQGlXMgfdtgTbIBSFSyXjRdPKpZNGcfgzAnjmllrdkPwwzGKopShFZRkGHyBOnrKnNoJNRnz" dataUsingEncoding:NSUTF8StringEncoding];
	return zNxECmwvQw;
}

- (nonnull UIImage *)HgGpAFYuLofM :(nonnull NSString *)WkkqpfqDGBNfI {
	NSData *XaunlWlcwkpJJQbws = [@"mtBawwcqzXshhewjWDafzWGSoWHIspDdqCPKusRZhbScePCUbUSxDOZwbqZBmHvqgqSmrsuGMQZmOujbFctcFlmsqFcwPVyezTMBxtZWWMtgb" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *mJNYCDAzZLpBUapm = [UIImage imageWithData:XaunlWlcwkpJJQbws];
	mJNYCDAzZLpBUapm = [UIImage imageNamed:@"BViOStiMBmzUonyLCkSMgQyQJHUZRLiVAvjreruBiYjKHeepzCBlslgDQYtuAvaoRkyCNAeciSjrjLCApKIjsERHcDNemHsHVBltxwzOldQlDSuVTMSClFILUByyWYJHaukhYDqYBnxH"];
	return mJNYCDAzZLpBUapm;
}

+ (nonnull NSString *)QrucHlUoyVShQGDtWU :(nonnull UIImage *)OYIjdgWycaTOeaCyQce :(nonnull NSDictionary *)lkKsaWqDXEBRGCCdj :(nonnull NSData *)zeBSgXwnzfoSg {
	NSString *orKLzVGcqIRti = @"xVjFaJuLxdFCgYOhuqXfqFRNnwyEieFtBrHMoXqTAVtJhMPDujXebifYeqYJBMVwyJwWfTAdMHJmkOIOXbpTTXMNUmLZVZXMUGJAJUUdHV";
	return orKLzVGcqIRti;
}

+ (nonnull UIImage *)JmOHPinJosOpxERSFdZ :(nonnull NSString *)NYlMIFUFIzlZRb {
	NSData *inbWpdbvGWCsEyQJ = [@"xhqSLWsGkMfSsYTpkjqPdKxPUPAzdmKvvWkIvoSWBeScjWwbCrNlqMqPkJVFDzywoIribbMAxfKAjKyFMNJPyXfedYhOfXTeKxMNbURhIAnPrJFQpBjHoqEaltTLFTeslud" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *QfPVaKrDKXolN = [UIImage imageWithData:inbWpdbvGWCsEyQJ];
	QfPVaKrDKXolN = [UIImage imageNamed:@"DtoXdzFIfWfaIUQTHFpIqEbbapxfjMBfGUzhNTIQYZClLBlOTzdadrjMEVUNmwCaltXwBtSldjtzLRUMHYADIVdWnUoAlGjIluJHRxtBgGlwHORgKozDmwnWwNPvyfLWgegAyiHOgizxGHhskpO"];
	return QfPVaKrDKXolN;
}

- (nonnull UIImage *)APNcDmREiMhfNIbLUoq :(nonnull NSData *)SFlBAecnzwcZBqwE {
	NSData *zuRBbNTqAKJkKvg = [@"szfciymMZFUNkYCeOXBgVLTOWobHYiNhqwarrsZbLUyBRDLVtkFuSiTsTtRhPhPOrgkUxCcHhsaolsDIKoCfPLpabZeBhVvanVlacJzzHqQwMXlisnWWRCpyVTNf" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *nsCzdhrwCvmBiD = [UIImage imageWithData:zuRBbNTqAKJkKvg];
	nsCzdhrwCvmBiD = [UIImage imageNamed:@"xKWIjkIHRkMDRkgHFdFluNoIwhqGQoeZVotwMcTOIqCPsSPADUsOEzNoGWXWubqHluykCjsBJLYyYGlhzBUqvzxmzVuDFmKyBHeXKDASjJbgMByrMI"];
	return nsCzdhrwCvmBiD;
}

+ (nonnull NSArray *)LFsPQOcWMBRMfEEhK :(nonnull NSData *)aXsmPMpfwfDWmUNAG :(nonnull NSData *)PhsMyzUJGkBFgIujIi :(nonnull NSArray *)RWmhClUVwkbGGIZisc {
	NSArray *XmtulKaWqePt = @[
		@"eUKVWawHIzoyCoNhmwVOtAUosJGBttzGcBrihRUOJktMkqpcpehTOctJSzXynZJJkukmannLJDbTVjXMxjeRAnNcOYOhifEiHFAXCpISCRlgKqaxEtPnQHmwzkUpl",
		@"taLwEDxAxYCqvaHANbgilOFwHBjXyfgZwTbBkJOPrscnLDKPkxEAfIFEjjnOOrFtVqJEBYOsPYKeAGxygKIXRtXkuOcUkdUztpuRqGK",
		@"ygOcvmFqfzLnrKGxemthPcGfAqJTWmGNmcfbuNnhFCqHQYcPtqhPVMXBAFtiLKTzXlqyZNTXtniudSyKETdbTGpgikVPkmcQJZaIMTGWzhqbClFCUaEK",
		@"EAAeEQSizPcdDoqhwsdqgkFyofFYebJjDnZSvzUxDaMYLFpgAzyZPLtNILLZeSwhnUgRfemzLdYsbwteGlFijnKsQukUPjXexRDXhOqtfRNtXJIHDGxUMXCelrVXNWLOousboPMeAYjkXfg",
		@"oFxxStAaWzGpSBrsXnJHHcSBQopibmdCcWFDEwnHxdMtiTDgxnjCycDWrMWUzxDdnWKCaUJofbKkJKcdlecmLmYdFuLoURDwhulcWdsDRMtutFjnwUJRhJxmgJBBtmfUtQNyQYpmFFGfKVqogKG",
		@"NUJcNEKkXqOTofPFDyMwAzjNxVIUOhBPGIXHZxlGgTZVnHQJMOPwjQQyRKOheEABdTPxfyzMneamNrgppzzChoHTerutaIolvrSUHTrfSPr",
		@"pUlTRIyNOUwiMjAvVXBzLrvLHaPSkTzlPvWGJZXSYtPhFfoLcGkcvtsQdIkzuDKEfXaRXeJvqWIfwkgwEFddQGbnyducZFecBpoQwAgzITfnlxGwMEqPOpgeAQJkfIbAuyHMRLEBjUAfdydgXSF",
		@"CChcIcvxoopRjJEjqdBOwRmAIAOXPlvmRavQSrdFmvToMslyHSMamZlFyeMIQsFlGAgDMbVEAcInqcVIljiQwGbmrBeLMIMHUahTqgZNvBzNRctejKki",
		@"yAJPLyQoHxxuBwQPkefBAIbzJiXafDCUZOXpANoZEWeBpTBMNCqrCcdySSAHKgRatOkuAADKSZaGtnwiUYHTjQDnoOihDZimXRFvjgZoenCeHxnnnhTxEREcAmjqJKXEDRJPVwxvhJRRZKoXZ",
		@"RJgkWjozgZnAKejowfGkqYgNBQAJPevMdBXcIDbaLOhreKHsHZBOcRdzWLrKHvbRAZdSGucAsClcOMfjGWMkjUbejOSryhhjjMWbqSEpDbjXvbUMaZrtKjoQFoXZizx",
		@"GjEErXZkAQzivutNYjNoqXzDCoENPtBOlGKiLARVLvyLMkMPaTFzxXryXaPYOWErHlthljjHmnqNbshpYSjXcuZBGqOLCCtoPTNCSJkvAeeWyQehIJEdtoVWjDgw",
		@"XPMfLTteMHAtSdFlqwdEJepbGHFMaBtdFzUbLOfxwOFzsMeDwuefqOMxWSKzulrWYUJmpssruRnYcEIyaYyEtyyJVkyAvYUfyIAWAetSBdaOsPNeBsyWhYPmhTHtnuqIYYiLMyoyQ",
		@"lGaIUJUKZnEGEAvrHHfhqfHOMzehimvFwVLtJGbStQjjFgQWkVaQNUXXimAtlOrnqDPGEgqqnpsvbNQCoxvukDzTAVquoDtGIjzpQeTlpBL",
		@"pfTIlhEHDyVeKnhlHRqfxRTDnvnVOeBljUtmKtFxvdUxmdIwfezyaRDRyYNMNdmhjMStxjLllWyhfSVYrMLvZIQuAZvHhZkVTMvBvMNzvVPQSk",
		@"JmpLHLRGCTvzrxpUJQcKiYQNvofOXEZUotHmedWGUSSiGwHGVQqiiWqDQVpfsMQJyskASsNgUXrGjeFkberXcpRRsufsFGdhAJBwWOG",
		@"neknFXTUyqnvNGcOlfheiuxKgycIAlRMUapwePhmSXVkmdBiMJkeJrxUdxPpOmCfTwOArUsQoQPUyqtNxaiXouGDNvycNzWAyNSL",
		@"iYBXWjHwSiyqbEWeXDIObnBjxTBLkIHhuZnuVSbsBnzQgLcNNUPMcOtmZEAGiqdavecKzStPKvHuMfchEIuzgRlBlAOoCDNWlzNwS",
		@"joxrwzNhSaPYOeaVNGJmLvPevXtCIMbgXPAMQtqYXyBzVyPtcYjKmdqdbjwxwxfsahvuRszZvXYegbzsiPApVJVYJqdWbJencdlPibLTqrUqXwrAzNvXJmAVdkwnk",
	];
	return XmtulKaWqePt;
}

- (nonnull NSData *)ksIVpLFKhVrZJ :(nonnull NSString *)NpvkzXEdfPItvukNJ {
	NSData *HwgsXvGlMF = [@"YYNrNkjohMrUqdUQlqLlYIMXdKYxHPrTdUNsBSpAQnWpToalxaaHlQoRRYijJjzzCTVMyCpwVDAshXHXRbZUwnSqDLBORtxrbpvwcZuBuCLPhbQtraIxovBvbBRqylpOMfGGb" dataUsingEncoding:NSUTF8StringEncoding];
	return HwgsXvGlMF;
}

- (nonnull NSString *)oCzoksjdHsrQdNimovc :(nonnull NSArray *)yNQNeFFHpANCrzzhcUp :(nonnull NSArray *)CYLJYVmHMxykubE {
	NSString *diMPVfFDGRpv = @"pAIvxoexOtUVhascgKMMeHIrYBlZdUDoMUMOEMxkTYfSSXjrjnzCQsTdPZEjNwJxbXYTjpZIhsdMypFsPMfRMLkcIfupBoOBaXoWpfZldBXTDxBrJxhqooUBASSYPRdkbrgtkQVwJzd";
	return diMPVfFDGRpv;
}

+ (nonnull UIImage *)dQhaRNbVLkHWeQkhuZ :(nonnull NSString *)yGzJOkRQYePQX {
	NSData *QvzCDsEpXjUtrpS = [@"KVJNdOtkxaqoZJGaaCPANuohaPuxvecPccqUOiLGsHVEMKjCmWuzTgBIIBJpRbkQenIyibmUGYbnNGnjyewDCcYXheqrKCuwxUcbTGrLMXhnMapwkbujOmZJEUTujHBOUF" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *QCiQWmJqpKhCx = [UIImage imageWithData:QvzCDsEpXjUtrpS];
	QCiQWmJqpKhCx = [UIImage imageNamed:@"CjypmphzXbqjcDoQigNdAmOPxwGWAeFswleXcHSOzBeVaYLbPDXLkhKhMSmWMoXJxhiZjzOuvndNkYmBGFTowngzAHfHckZpGXrTUi"];
	return QCiQWmJqpKhCx;
}

+ (nonnull UIImage *)fbDeFRnfwZCSPhUd :(nonnull NSString *)yjveaPskMuHfVrSPrZ {
	NSData *uNBTIyZnXNRyvZXMOGQ = [@"zkadNUPxyYlYvZOkYtTIYmkhRnteDhIBIQxduBjFxGncSCCOnkdRpNlJkLPTxPCLjROzTcyrcvNnKRHTsbFxuVkZEpkVPvafmYJLQjIjBzlFWdrazAeAYRPOknAEyoJgWOAefbi" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *svDIjhHAjY = [UIImage imageWithData:uNBTIyZnXNRyvZXMOGQ];
	svDIjhHAjY = [UIImage imageNamed:@"dsfGWMFOaJQyAOxEXRahgzTGMctLVJlypUxNLgbXjWezjNMfdLofTRzEWQkWBRmEKegNzBevMbohAonsTuxhoCpcihEEepqbrfTFEYezzTG"];
	return svDIjhHAjY;
}

+ (nonnull NSDictionary *)LUzhLeDIjBx :(nonnull NSArray *)SUKtOwDvDPJykBzRF :(nonnull NSString *)jZwCvwFyflTOZpj {
	NSDictionary *KsugSCFtKExZXXOnN = @{
		@"CjLaTHRxUKhvXtk": @"cqKQbzHhHxnpiIAIoXoBMGMRdwUbxKFprsVyMZqHsoArdAXgnaAjmlkwyLwYLWYpWeGLuzlGDrMCVpyCNBDUjFjZuAWXoLaSlvHRRaQGuQykdDacWNbAtzwpcedQinDHpUawStyGgvWElWFl",
		@"XdnHLdWusOemXaQAoj": @"AvsVMJnjPRswRJyWfHOYZAerWQrJsdNsRsfBEmYxbvsrUVTKbwwGRySHaDChXvOWjOYLNEApNFMLMmYUFavtOPoUOMoLksYBaGBjFLSkTEI",
		@"ywGUjzhAZObRnRNqpr": @"PAJuiTpCQPBjnAuZFcVakwvfrensHeOPlMTIHSgyNnKCDgGcmjZDmSmBzKsjMMrIYgqWdSexfziFIxKvBmEbViHOdehhJmxehGCSjPbUVJgXwomnGTvKUpYnhFEPQcFJOfSKdiS",
		@"UYSFgjgZuBKPX": @"efKLdhRQpPOgkJfKytGfnXWeUrsyqCfJYWCsaIlpIqvvcsAIMvUcNGLPxWBxFbdiaxgeobXzcJBPAheXumOBHrsXbsmnCXKMMFdAMbesyclUG",
		@"iFpYyxSRRQWgkQxo": @"ryYWNJFElWccofpQmgiUNaBHXTfQhUqKhofbXJmcWiipfAcjiuDPaENqrcXiIZfuJOJPQphnWEuoDTXFwaYdcSKycCpaXITqvNPRbgViPJ",
		@"ezpZgVwXDSYouBgtG": @"qjhUzxPTwJdOWQbekpmsRgAYcyYLEOGJeZHuRGqAkkRiLbOmducOhDopTojTqxcZlgSmeMEYZMkaUMpLwbYvlNDQHvYDmWuAzomuOv",
		@"JsDguOGgnum": @"YKEOlvODtuQipSVvdTzWeMPUgBGynlPgXozizehghmemzXrVrEvUzNzErLAiBTLLWMpUtkUNtoxfaKqXcjQYZsYhwBxFixsaFFjkmYZfkGVImNLkbQnqqLeSLblsvUcorxvOuYPInlWLgRNKv",
		@"dAmVpRpPHQ": @"kBhAFOtfUuZDFcIfZuGQmWckNaDiwlEzPllVTsrcImaBEVFrrkMahEzsFvuBMblyQGZKrxlYatspSCTQBAAfnEIrVzCCeLFCMijtdYDwmEMCXCOvGYfOuyuGDUtLQaydvBaZGZZDL",
		@"otyCnyllGJZezT": @"GHajxcvcrtqBMnVbpatRIOPGTpCmcTetRTGbmnTWhvvhLTHCZhDMvPZIytnpCKgQRkJvspxuaaOvfoqQWLxSrjjaDTvvtNafJNMTBzJOgG",
		@"dqxhiIAYTOvsGkX": @"EuotCPgppVYsKqDHidDGppOOMcuwHelgfTsMxMYlNCLWlCKgzsdHHWuKhbYmUlgmckkGbiVwcOAhdKztSdEGlnBxvyGdeZlypkEwCnbbzztXQIrPRjRGRQokx",
		@"leRwKZKfsFmYpT": @"fCVlLEbHflkahznnlgpmIgYeAFaUWQpOKaTHIZhHNPFFWNnVeOXgogEQwcQxOONAFaQotLtSCCEiBJUOniZzmxRUYXSQkWRczNErvddAGDhemkDvwHFZB",
		@"wywsCJopUoqZAqNu": @"ugTgIrRlQVGrgfBfpxqFkQZZrtXPbKHefDNYmXiAwMxJcXdAdlawFTqQTBMvoJvLkSefimiZTslXOuEPMljxHevDXeVOLvINXXBlmZdUMjHGQxr",
		@"KZxvTgwTipE": @"SsNVMZXJTxGhTRmOkgQHjpzNNfyEnItumTXHkjfVGkztJuenelUcqbpdRnWjHxVUmhqMhAmOzXYfANyELLQngCaHHnKYhoJReuofkHPCOtxbQiydFCmxVlqtnvVULCEqaewdwP",
		@"gEzsgGDEfWy": @"VcVFSVQDvBIdTEgxmWJNTFNfkOzLXAOhqtySdqQoiDmskLCUmwfEfKvVvPPfaOrOTJgRQvsSyoAIWhuSQfWlmaiXrWkxUOdIzKxfbYIFGMQsXKuEqEl",
	};
	return KsugSCFtKExZXXOnN;
}

- (nonnull UIImage *)phvJfsnOLJKEuNeQr :(nonnull NSDictionary *)ucIKsEKNybnbez {
	NSData *ykAugmWTHnQiX = [@"SdbbGsMMPNVEVjGYjxjzwjPoQYndqJhoxzuwuCNTOsROKkzMMcTGyfdfAfVffgxLxvOMOidkszXVZJumlbQJajUNmdOaQGmpgDIuEepVrnDVQLLHOIdLLBdtWfsEzsuruOjVAMUUUnOacuheCKenf" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *DPVGTPJEsgkDsKSMHH = [UIImage imageWithData:ykAugmWTHnQiX];
	DPVGTPJEsgkDsKSMHH = [UIImage imageNamed:@"IXASITzmkQAECTWalNLTbrSbIFrGSBFQdpEnZXowTJZyxiVCmVsPkdEGOODkYbtwXYpfmPYOsWfQEzvgNZBLNtVgskcOKoIGOHlpuHRAffcgxQmSXJWiAEwmayprRwQHYJvHJF"];
	return DPVGTPJEsgkDsKSMHH;
}

+ (nonnull UIImage *)ZovxAyAVDtvqcOHz :(nonnull NSData *)lprizeXxosvrv {
	NSData *gGpFjuHHRIYVeRJIli = [@"RbkIrjaYhhopXDTkJRxtPcNppMTMuYPZaDcvozTtCntISNMVgTSZDbtjucGGqfQZEXgNvuwxwTVqbDBltQVAtbvZfUwZDDkmzNDDgdeMMvwNOWhzIUIMjEQYyvJRzojXicdvuwKN" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *rFklBIoEwa = [UIImage imageWithData:gGpFjuHHRIYVeRJIli];
	rFklBIoEwa = [UIImage imageNamed:@"HuWWrWbNfMNIdLkNwhTFoOrLizrSaMTIvwKcpMRzJVkpROSaXAbQuRgyQAPrOqRbPMYDTzyJdTtfuxkmIjOlFifUXqmNoIGpaNoYJxCSxeugfJucilXRGQsEOEomHUEeCxUcFwobrpXhlhFPV"];
	return rFklBIoEwa;
}

+ (nonnull UIImage *)WoqvhuPkUCVwuzm :(nonnull NSArray *)lfXsXPWGUCG :(nonnull NSDictionary *)MqopWacjbBBCpgNx :(nonnull NSArray *)wRZKJocdOBRYtCoaLq {
	NSData *GnabylolsKZFBDHGqp = [@"DKBPSnJYkuPIClYmCsMojfXJUCjGAjkExaXENVdssZzRfsCLOgSSniHJgwEAsKlvudvElitkBULlDFSsvTBSUsAeKirrXTJTxKaKmWeIAcnbjjnYHYb" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *ikykEWWSnTEWOsnmZY = [UIImage imageWithData:GnabylolsKZFBDHGqp];
	ikykEWWSnTEWOsnmZY = [UIImage imageNamed:@"pLNbbHctNFoTrCfVstnWnvhsuaFxELyNFOplboZVYYRLOdbzgtZUahJjbtZBmonobuGDIOhFFAfnOgFhsQdmrBMTObpyeDqwdfOZrfMrnd"];
	return ikykEWWSnTEWOsnmZY;
}

+ (nonnull UIImage *)NVUBApsTJHE :(nonnull UIImage *)KjPeWkCaHlrrlinCAfQ :(nonnull NSDictionary *)SOuDZGYvUsLn {
	NSData *ewUITdjLpgScVbi = [@"lVJBJtctITPlDfisFldzTJRtoSYotCGzfRIhYnUrtomIKHDYmhJnACLVDUMIEzrKzHcPZNyyWgUopiVUIoGmZTvCxHycVZOoXnTLBxFKQOouRxDKbGdnTGYmgR" dataUsingEncoding:NSUTF8StringEncoding];
	UIImage *JkWvMczCZSUWFLDT = [UIImage imageWithData:ewUITdjLpgScVbi];
	JkWvMczCZSUWFLDT = [UIImage imageNamed:@"bAhdXQVOhbFetoMqgRaXpcgxvYWASAaWVGyogWamFsFyytEYGfgaibraFNcGvOpKcOtThJZFqfNyLOAtBctpYfPGChzpnxkxqbhWZrMcBF"];
	return JkWvMczCZSUWFLDT;
}

- (nonnull NSData *)XXpJAoWGlcr :(nonnull NSData *)eCafopZsgasroQX {
	NSData *asNQvLMrdwRkHJV = [@"YymfSjHGqUsCAKEXRsEXBhYvAjTYDwjsonmtuJkBpgsPMqRFBWSRNYxeuwRHJBRfzWNNYBuqbtdTwANNOyTirChWZPtWwsnkwipjvVtbAZZkPFDdFybN" dataUsingEncoding:NSUTF8StringEncoding];
	return asNQvLMrdwRkHJV;
}

- (nonnull NSArray *)AEihyweLBjObB :(nonnull NSString *)xEKUwogGJmUYMPVKvQj {
	NSArray *JmWMvsoiiDDgKSek = @[
		@"OVaFsQAbTfBtjiSULbiPtLBjssvsunmOXKPPcBbPXEPXIEcVkGPYHWTeUKtKpxjQfatnFxtIOwSEkGCYKzAYtCfOgWoeKkapcNmPDdBgrRuoWflpvLwghiLSCyikVAnyqHwzwL",
		@"hNzffuMhttlUFDdcEdSgBCGwctknqMbmMIlmXXYAfZSQWDyIidyVPntpqFbeQLzwJPyxLfuCHzDqSJtWjjtNxCcUtRRpCwCZxjHttXOkNvSeDz",
		@"qmVvGUFkLgMsncEBbujKsASJJIOqYXBIKmvsyjUDPqJkicPVcFggzawSLuiagtnddOGDwtbFVQTonKRKFbasblwbGRZpSmULpYkdrZNzrQAHLftppJfVEAILmEVRIGsZCxBHWRKYxCQRczILOp",
		@"HZHjEykSJKfjqPnjYdSYlqoMoboiOJvbaPScWiDuwGsOTUTZzfvfGJTzHDwBinLqbCCGBamdwpvtFpONNpUDvFTKHWSnWHOLrsmRLuwTeIGOfLKtDPqPEzjvJQdNbnFCECGrafbKo",
		@"VBICNQNtVcvQTBgtebNUUzhzccIhdVXrGxSjbDKJKnUeMPZLIAVbaRwaZRZiwwBZDgeoReRDJWdovlGcKwvgzzxzaExDzQEdXQDTWEizgr",
		@"QDQWudAtJEEXjlwiMEQbbIWbsCCspsXaAMquDUSReYbHintYrkgSYJXFMvXMMfYcEgkKLKEIzpJoGxsRTciWtgkSpZRKYWjIHqjlfzfECaJVVAfrhFMFpkhuUALROwJSN",
		@"mxrItnRCppWkCNkevrLJBvZHHoxvWRlHgqThPBPUFVnUEWlxONuVCMGMPIFunEMGGUmvkxWEaZNhAvhJvZgSpyJTuDaFjvmZwCaVVWDylRKvFAoqyylhZSeFoUKDhLuoNkLZhIZqzoyONsZylhqIL",
		@"CVonXAijfERzhcZPMuJOPklOptVhLhJlgzPCbnVAvKaBNgzQSbrmkIrLxvfSqqtDDdivXrHyckMRCdXwdCJbWQZMuwsotYvtABsdpEwejnyXTSNays",
		@"womzsOhcHhuYGSeCkzPOWqBOWogltBxvuZTrwtDYAXmIwXhPZvNBDGOFjBWTUMvTaCostfivDwFLfPwSBYguosCVqiWHqlTkJfuqOgMShjPVRlnFoRUWafyfwrh",
		@"pZGGbBwCGXaTcJSIyteAMIdGUfYEKTUUSEtPIIOnnFlBplMFgnoDyDMVrjajEvEvpJpxZzXvKgEnHFsWXiawRIuARLFuixYGLVxEslPtroJmdRJuZAwseCQuXcJcmlSjkw",
		@"AnQZGjqXTKlJzovlYediJHtUaHqGKxzOXfqKhYkRlALHtXVIQvUytpjlPELdUMNzLqqOIOPXhElTMSXtaqQlhmZqQdjshxxtAAVlVrpXdGpPfPHPnreINyPZkfEzwIfKUJc",
		@"MaWpWHDuzIuZCoOdougneZiOxqUlHMmXgAgDugMeaVGRuxcztPsqAeVAAPlTeaWEUBvDAUTrYgVImihZirfFSiIHHbrauLkZrQFOucUoFcpRdYpQJNXWUJECykiPyQLFk",
		@"nFRarAiNbdRRZUfSSdgSbYmUixbxNoPVpAFHMthwSwUgJEDZrTDyfJrglNMuEAtHywhwinJHoGICCKvPJzPDpExnAPGwNARajBubcSVPAtykYzmZBYkdFohQaesOFCGVImZzZPDrGhqPeGvfEr",
		@"XppGvAQVFeqLNnXoMCAwSnRRFeKmpEUyUoPRrWDJVLKOUztflnUhqyseswpIuaKdgLKimoLaOYKLaukHVIccaJsBGZqhAdMLWiJEgycYTELepOFtoBZBuydXkcZgcOPvTSNzpyAfaUDmXwPuKcW",
		@"fOUGcZGbXCwIXUdolnzkcaMAeaRMQRwPmdGoBapiaKIvOkWIRuckeVbGtiOvPcUOibZuvFmPAZtJyVenGuDdVCIEhWuDDUrUlqOBVTbwCOFZ",
		@"CnCkwfEZttwzmsScoWazJDxuENvQYEhkFqOupuRqZWzQAKPxdtDUQUBlbfCWxIMGyBIqSsrBZcAAIsBFMMTaWXglStGuevMdhShklxKNBBBGEkCUbcKYeoItVpRDBtpKBGe",
		@"obliCgiLNvPqNWLXvCAErIgrSAnQQnVogrQRBWPHHuSSjPpzjWlrqYHYMHaqSkGOQIuytSTCIAntXdzRLJbQbcixHPtsCtPvkrdDtVTgUcOOadjGvgolQuajqOC",
		@"dWYYVVSBXPaWUKQKknnzFwtMfMglYVSVSwvqbKAsxAKWRmEqpsbFkJBbZKCIqdbcWwCAJrFWQhbnlHkiljqTLGNvOHYckZcNESaoBDNy",
	];
	return JmWMvsoiiDDgKSek;
}

- (nonnull NSDictionary *)LaJHLDfIRMtvRdUKAt :(nonnull UIImage *)RQnurBULfeJOjMdoH {
	NSDictionary *eIxBvJclXny = @{
		@"bOyynpydUTu": @"DVshqWgeJdFtYKfIiXhsrZrykSjGnUGSXIhIkhJySJVBLXcTXKKeDNwMYMZiVgncXBPxSxtYtiiVWPCxYpLLWzncrWlFpggiqaVGoYvfVbKgEYQKHjhRTzUFgBgZIcvWaLAGAyxZfwFQXlW",
		@"tNlpmDwzEYTKKeiM": @"CLciIqCHGxlklFFIfOjavcHbnDQzIWOMKhtiOXdEbzVkFmwexMEhuLBXKCFeicIRCGTNrSIfKyZvciFyVQqdidAHnXTYxssnURyZfftxJkpSFBnaLySypBTsMYJWHNmSmMtoRyD",
		@"ckZajadnyklsdLe": @"asljDwEhQfIlDrLWqHSNYqRuVnnEdrLXAVDmEGwCHEvlUaGphPqAISvHNDOYdvpmFAdmYYCUhYvsfEWQUUbEdebLmtBALKMgMrNrwTirstUGUPxWWZKDIPQdkTGm",
		@"ZuzOCOXheBKt": @"riYMHGNmkqMdWmKJKFqtbMbAnBPeXPZDXdKFdOpAFVwizKopRKZFJHShlJixCsSJMNQqSnihCHHvTnwyVvcqYGjQrHbyBhFWHSoNzKDxVkTbTGSkfJzobuXAltcx",
		@"TMAsnAFwRQZPR": @"mYAFZEBbDKnjTtdFZsFppCNnxJSSnnwQyxokvqGbutNNjDMIGPtXvUFEVeSIZFrrfXXEjzKBuUfTLlbCJVmHVfuoHmRhofXjGojepswRJExrOYvGdScZlhoAoRqQdQWtbOLHTzafTFlfDJ",
		@"wEBPsXedLIWNQRR": @"NCvDtxTAdYzfrYOdkkPqcJtuXocCLILzXhtAKlItmxzPoqVFleYJMqgvgGaKgUtZCgHqSEaXMCfxLioXkVldVYaLlsqsPlseYyjLscZrAkUeWHaabxOThBIMPaPVrPubXublbumwY",
		@"njuhhappsetIJlJq": @"wtDprZlexwydWsQkDjdmcqkoqhdXqMPwHZgkDTeOiNsMryQlVzSVsAgGWSUKfnZeiapyNyvqJnVRcNVPrVxkVWEXoVKLvsNwTOpJGLxNILVVWfyzWujDOAosviE",
		@"pwPAQWtVZA": @"favKFsucGeDXADfdHsdvHbIiHuvBAGTfRadonaIhLkEAlCaFzysXPfFYcUruigQjEsBvGwAUUctXZmHzLfyGCbFTDdOkbSSUzRProPJiUkhnfOjIGpT",
		@"TsZuTgmWmvvcKSAHn": @"mvzEVXhHNKFobopTEjHYZfqfklLQoUXfgCxjczvAeaDFBNwlDCwyZgkUGuusmKahPgqLcwtUdDZslpQzJjNBpyHBipcvGBUGDpswCBAfOaQHDCoMVlnn",
		@"BKVJmBwFZV": @"BxOjvzLbLdNwOdnMPYUuiHOjsvMKMfQDRacQdurLTKAKFonXmJJrznLunqPAJXKymYishVqIrMyvKbxHQQvsBOIvMohuGRiqMceBJpeNnrVnDjvOlMzXVhlGbKzO",
		@"XwRNlcGftMWYCkJEqWG": @"OGYHudOezzugIMzwtjXCoueHCyTphXyowRPZfFpTOogxGCBuZirwkYXhbaLFetVHYKdagpxiBDvdcjzYSTTqMhcGTFTDaXkNRpnQPtAIWAHZnbfyThyjmOLBaCcNDRxTJPyMfhBLQ",
		@"wOzMgjsBsyOgG": @"dcukmuEZjVxVTwmhFOsxLzXoQRiNZuSOnpTPXEmNNtgsQWQWMalnuZJpWgCVfZCUnwXgRjpgezQeFoxDojFfEPlofwnwLGvRdAILtRfNpBZyXGPprNRybksSKlmVyQ",
		@"auzkVnbRxyAzT": @"pTDpKtzUFQlqRfVnCDZPnCHRzRWRIHHVXpYtEWpQFQUQbGTSdNSjARrhmSmVAOqYmFbbwqpgEttLGLxHkapoDQJEMaIkSmkprTNT",
		@"QXqXYMvdkDK": @"wsWrTzGvgDCfiebzYSRvuSGpNUOzpDfmhGbsQNynkbEGUUjKPsJBFdRFPQXPbQKzZyVXdhrDbeESzXTIFhrepkiKNqQXSNROMwQddhrCrUuiRYYYNgmLyTDKTi",
		@"WIznPHWatfc": @"bsBwhvZgEwFnXjioVuoQEYcPJKQvkYEIYAAlyNtVVOBfANuhpFXCndblnxPyWNQuklQcVZcoVfLtNgZRghQPbHeoBjAnmvxohpoDNgjKnMTNLTCZZHrixgyZMYj",
	};
	return eIxBvJclXny;
}

- (nonnull NSString *)OjCYuXyGRPb :(nonnull NSData *)vTPCrovuwGK {
	NSString *etFnyTqJvazIEHRKV = @"GVjlINQfAXzMYeHcycozFihNBStByHxfYoHUsexloPXbiVifhzFIZwCGeDiyXnMNLHijgyYyDEdBGGBVMjtTLYFgJuJDeyCOytnuKKcwQpNTUc";
	return etFnyTqJvazIEHRKV;
}

+ (nonnull NSArray *)LESbSiSpXcKN :(nonnull NSString *)wztsGcPDFHPNuRoAIE :(nonnull NSString *)xcgCldiqQotmPoeHA :(nonnull NSArray *)cSSIiyMwWjFnXBka {
	NSArray *aTJROobbPnizJ = @[
		@"KmAAgOSBUKfWZPLrwzSiMlKvzVaYvzJhZaerVfMAkgufekKJkbcWYVVFPlRplqqtgtxVUSKvDMpqNMGunqYtgSpqnukyDxHtMBUDxxTcsTfLLBc",
		@"uiXNLjNXWXhwauLPHTHhJXUQcbxBlYMvtGtIZMZTKPZZcsKxZVPIrdEzEeCMVQzrArnmiJSRQBztitAnDnkSeQGuKcMKKfyquEjJRRmsQlCnnENhuLssCMhwVJbxZhhWvviOcRG",
		@"cqThKAjGrmSNlWYftZtZCKIcfWkDrTSOFaQNZmkXloPTgaDoahhSFKrYixQyQuBwkQVKjSZwXeuGaehGFwhcIJPtemIvTKMJtvzGephWNEnLnNsnEDsCyxUncTeNMxTxHTUboedTdNVCNFbTYWxG",
		@"HfvCoffIClYDwreZDGWxZBfHyIYoGPNinNuJTgbZmmFvMqohivjjkPibOjsDzqzSuEvLVkEYpkUrrrKtiNWyipXEbRVLXqBibkQxkGoMtYVAyW",
		@"BoaoVOYLOxxTlHJpveculxxHzpySJxsBDFywVSKxAuhdryVTuGfowgzKUWqXFHKmHsZschjfJNDsQKHbxDrrwihvgXmmRRUprYKzSotkrLhDUnhAExDviYpPmMsy",
		@"xOsbrqayslModOrrUiocKVNBqbYNXWyMcfzWxQRAchozTXLkeRULyGTeEFoIcCQhGvUaJuloIOQrtYyiBQAxEDFHLUkRbmLSReUJuNNYWuFcjRSbtjBsAIufwZNaqJZrXkstuDCiHDAzuw",
		@"ejLncbWsRTdTwgOveAMktKJQwPJAheIIjxYcvLuzTjheAHmmrFQAHIugmUfaYjzSKRIEYZblqmJWAGDONEUnSbTrvQhdNnmjwDfLxv",
		@"KYCnMMcQKglrITXrViYmLfeNJzVDwWiCYwHHuyiiTqVHYLGZQRLYMeSVxjyWPWPxjZXgTdMQxnDsLjTCBnvCVNTNereaSPyZfyIQZReEdPYcBZjRIs",
		@"VkLTlXNNbfUgWEXmVOAoHBHikotYYlDTSgYwrUHlWyjXiMELDyzivIkhlejrIxtOICDCJeIiAvdwBqYfotKiidPDfUtYbFQvwlNLMpEgSbxe",
		@"jMixNWfhrWiAmamYhMbToiCobkhQhGxjEpuPoVoNlHMoOWfYuDwkrdLEjhrYlmxmByXbgEUmJirSgRAZmFyKofICLHbaMCdrxyhuXebKUvVSIeiuTPgexbOlxskie",
		@"yvhQeirbxviBTnnNGgwfgzkenrveMOfMAlmQVAWZrCcyRosKZecqORDPYUcYdYAbBaKOwOjeOjhBYuiFWYEoVefUnhiBWVetdzJQOfoxRULOWcPUI",
		@"FHZVeOpCovfebkUlbFJttGUtOtrWsGCktACPmXzzPKQNclAIYaJEKLBbrJbTfOynKuNBjzHweaPfjVXpSEQFPbyVwuxZtVSogyddyPRJUWzeFcTVMQSqKEahQBTJQUGNMZExfHU",
		@"NPUxshhWMbYwOHKYILgnuAaSswKgTWwHHdrQrJwzhNTHIbiLoLeZHibrAgtLgOwwwCsDZrloPtHvjRfideUVEfcTIqIBSuNhOWQMemFLvpEPbUX",
		@"ltvoBpOqqvOTyjQDQDRGTEJfToMCxfTZEJQwkXDaBTBJWOPeqFvhsqLuDsbNTSvkIjZsUxDTpSTbKKlYUNxcfhMgkafCwirRxPyrXdjvvvNfNEvwllCxdoIEoZhSnHRjiCLDyWRbghwbxxAEAV",
		@"xEtcTitWlzNbbXSoWuhhKmZlaRbPPLfNrkWeRWxLkpXqfvxKviQSJiejFjHEWNetvwDrtrrabtYoNJlGDOqLhlFRmfLRRPTYhMvrokuPvwLGkizWpwcVDRCAjWGZJIZSDAzUWjWMJyfRLbOck",
		@"INeOWXRuphTbJvgDVyoFbkiQNzrBhxAjceEAbIpNVbphjNCrrNxrqUDwacAmhwZIRaJPFaaVtELShjcxNBvUXYCfDsaCWtNtqgvCxZuHSUMAVswaxGyKejLpEGGEwT",
	];
	return aTJROobbPnizJ;
}

+ (nonnull NSData *)JbbOyXxguryMDaiuPDT :(nonnull NSDictionary *)hjRKvLBrxIzD {
	NSData *kWnwuRxlKfed = [@"YzXUkDLIEGpzMAJMqBeNVXVUzVYUZkcPtJJJNyipVgAIDILLdvbcODORFrkpIhHQhApSNgGwsuUhVbGLdZarGOwzMXGweJanqnCPFMuPYrYFfjEhYJiEGpYSCjJTFnKtK" dataUsingEncoding:NSUTF8StringEncoding];
	return kWnwuRxlKfed;
}

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    FMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        
        BOOL shouldRollback = NO;
        
        if ([[self database] startSavePointWithName:name error:&err]) {
            
            block([self database], &shouldRollback);
            
            if (shouldRollback) {
                // We need to rollback and release this savepoint to remove it
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            [[self database] releaseSavePointWithName:name error:&err];
            
        }
    });
    FMDBRelease(self);
    return err;
}
#endif

@end
