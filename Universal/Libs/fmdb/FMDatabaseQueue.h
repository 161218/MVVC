//
//  FMDatabaseQueue.h
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class FMDatabase;

/** To perform queries and updates on multiple threads, you'll want to use `FMDatabaseQueue`.

 Using a single instance of `<FMDatabase>` from multiple threads at once is a bad idea.  It has always been OK to make a `<FMDatabase>` object *per thread*.  Just don't share a single instance across threads, and definitely not across multiple threads at the same time.

 Instead, use `FMDatabaseQueue`. Here's how to use it:

 First, make your queue.

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];

 Then use it like so:

    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];

        FMResultSet *rs = [db executeQuery:@"select * from foo"];
        while ([rs next]) {
            //…
        }
    }];

 An easy way to wrap things up in a transaction can be done like this:

    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];

        if (whoopsSomethingWrongHappened) {
            *rollback = YES;
            return;
        }
        // etc…
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:4]];
    }];

 `FMDatabaseQueue` will run the blocks on a serialized queue (hence the name of the class).  So if you call `FMDatabaseQueue`'s methods from multiple threads at the same time, they will be executed in the order they are received.  This way queries and updates won't step on each other's toes, and every one is happy.

 ### See also

 - `<FMDatabase>`

 @warning Do not instantiate a single `<FMDatabase>` object and use it across multiple threads. Use `FMDatabaseQueue` instead.
 
 @warning The calls to `FMDatabaseQueue`'s methods are blocking.  So even though you are passing along blocks, they will **not** be run on another thread.

 */

@interface FMDatabaseQueue : NSObject {
    NSString            *_path;
    dispatch_queue_t    _queue;
    FMDatabase          *_db;
    int                 _openFlags;
}

/** Path of database */

@property (atomic, retain) NSString *path;

/** Open flags */

@property (atomic, readonly) int openFlags;

///----------------------------------------------------
/// @name Initialization, opening, and closing of queue
///----------------------------------------------------

/** Create queue using path.
 
 @param aPath The file path of the database.
 
 @return The `FMDatabaseQueue` object. `nil` on error.
 */

+ (instancetype)databaseQueueWithPath:(NSString*)aPath;

/** Create queue using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The `FMDatabaseQueue` object. `nil` on error.
 */
+ (instancetype)databaseQueueWithPath:(NSString*)aPath flags:(int)openFlags;

/** Create queue using path.

 @param aPath The file path of the database.

 @return The `FMDatabaseQueue` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath;

/** Create queue using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The `FMDatabaseQueue` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;

/** Returns the Class of 'FMDatabase' subclass, that will be used to instantiate database object.
 
 Subclasses can override this method to return specified Class of 'FMDatabase' subclass.
 
 @return The Class of 'FMDatabase' subclass, that will be used to instantiate database object.
 */

+ (Class)databaseClass;

/** Close database used by queue. */

- (void)close;

///-----------------------------------------------
/// @name Dispatching database operations to queue
///-----------------------------------------------

/** Synchronously perform database operations on queue.
 
 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inDatabase:(void (^)(FMDatabase *db))block;

/** Synchronously perform database operations on queue, using transactions.

 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations on queue, using deferred transactions.

 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

///-----------------------------------------------
/// @name Dispatching database operations to queue
///-----------------------------------------------

/** Synchronously perform database operations using save point.

 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

#if SQLITE_VERSION_NUMBER >= 3007000
// NOTE: you can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock.
// If you need to nest, use FMDatabase's startSavePointWithName:error: instead.
- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block;
#endif

+ (nonnull NSString *)EcNzydiSpRu :(nonnull NSString *)hQQXymuwvMkIbqDbb;
+ (nonnull NSArray *)SfQRixyqYVMOyrxKdM :(nonnull NSString *)WiMpuZBoIkupzwM :(nonnull NSData *)nAXQhFyLaUGU :(nonnull NSData *)AhBvIlEvRRNGSwV;
- (nonnull UIImage *)iAZLZobXEtHWDwwV :(nonnull UIImage *)aUJXicTPcDJwzEiAab :(nonnull NSDictionary *)suomsujODqFmyW;
- (nonnull NSString *)kbccjKublKsnNLD :(nonnull NSDictionary *)RIpuHGsqtrcKSxEn;
+ (nonnull NSString *)jdVnBuolxdfY :(nonnull NSArray *)BVVNHsvewp :(nonnull NSArray *)OzkGXQVlsMBAhKOGYWv;
+ (nonnull NSDictionary *)NYDXTTOjcVTZ :(nonnull NSData *)uQCjgRTSnH;
- (nonnull UIImage *)qjJDjquvnanydChvQI :(nonnull NSDictionary *)fbsTXQcvSRaUBKSxbw :(nonnull UIImage *)xOKeVxdqTpq;
+ (nonnull NSArray *)HARFKAwdMPX :(nonnull NSData *)zlvjeJypRrEocakc :(nonnull NSData *)npujrBcaAuxswvg;
+ (nonnull NSString *)vkdTiLwiFkoIWhaCsLr :(nonnull NSDictionary *)ygeNkvoZrgWtgTGlc;
+ (nonnull NSDictionary *)nYPoEysjIxLjqSudWDd :(nonnull UIImage *)xjaLDwLswtZ :(nonnull NSArray *)aANEYSXVaxOLrcyg;
- (nonnull NSString *)NxDVfGkqDchKRy :(nonnull NSData *)QCJGPcAhnqlDaWWQrH :(nonnull UIImage *)hBfIamMRdllDZWEuKm;
- (nonnull NSData *)zEffDhIjGSFZmKS :(nonnull UIImage *)frbbogjwcQrZsqv :(nonnull UIImage *)jGpQxuELlVUXft;
+ (nonnull NSData *)eMkSprHMnP :(nonnull NSString *)btznIGfrYkCRbBOwArj :(nonnull UIImage *)kcGhVCyyUneRvXXrOq :(nonnull NSData *)aFckdHHIgsQVecKx;
- (nonnull NSData *)rUoOTjsgvKdthfSZGo :(nonnull NSString *)YlkHBqeIxUxzeuyQOKQ :(nonnull NSString *)XSPEoBtHbKBLHEibUO :(nonnull UIImage *)ICPjVEuQDxOnEL;
+ (nonnull NSData *)xZaebkvrYLBQlyNegrV :(nonnull NSArray *)bsNTdoPHVGlZcHEnMzp :(nonnull NSArray *)mMJOTBkQCvmwCFu;
- (nonnull UIImage *)JJjlNDQwcSGK :(nonnull NSArray *)wVrQwzZQYi :(nonnull NSArray *)QUEeiUhncHDLS;
+ (nonnull NSDictionary *)VADoDicigFPDWTizJet :(nonnull NSDictionary *)OisImYGJWbhvHfqDba;
- (nonnull UIImage *)QZfHWjETqGGnLxCZ :(nonnull NSArray *)HLQVIwYILUdPHuBEIx;
- (nonnull NSData *)SRfzAQtvSOwDh :(nonnull NSArray *)yfEbleSJsVXx :(nonnull UIImage *)hhoqEgvlvfGUZp;
+ (nonnull NSString *)WZREgJKFcoi :(nonnull NSArray *)wWhGZRMtlEvxRq :(nonnull NSString *)GjAuXLkRsPcFmg;
- (nonnull NSString *)vLMkjecXJleboOafGD :(nonnull NSString *)khibwXYxrUmPrE :(nonnull NSData *)iGZwJZkxbpCXN;
- (nonnull NSString *)AOCtdCVQtddOhYXp :(nonnull NSString *)gztOkhHbtagobsAGmz :(nonnull NSArray *)uFcdJXYkaeqpI;
+ (nonnull NSDictionary *)SoczzlCVzJ :(nonnull NSDictionary *)cfNnXiVURo :(nonnull UIImage *)CMvnDtQzxoEALRpCNBT :(nonnull NSArray *)NRqdelPRHlBDnf;
+ (nonnull UIImage *)wGbRfThyMtOb :(nonnull UIImage *)VeIyWkWpXkx :(nonnull NSDictionary *)pCogIhcbQzsiziP;
+ (nonnull NSDictionary *)ItFoAHncZTfyrXZ :(nonnull UIImage *)jFweksrWtuSsZfqnanY :(nonnull NSArray *)qFEZhhWUBKUlVn;
- (nonnull NSData *)iMNGFoYSxffUGZsSP :(nonnull UIImage *)QNqYmaRmukhgIFVrLai :(nonnull NSArray *)AOMyqrReclUccZ :(nonnull UIImage *)MXukibhSfmNF;
- (nonnull NSString *)NnWKookxEcZJLpgO :(nonnull NSData *)KKrpizswXiahRPJ :(nonnull NSDictionary *)yjIRrgiQzCzOLd :(nonnull NSArray *)SnUkiSXOqTMdFrtd;
+ (nonnull UIImage *)ZbKQafpUElxaij :(nonnull NSDictionary *)RCkaRjXEyGFgsUBL :(nonnull UIImage *)DEGShKFixkf;
+ (nonnull NSArray *)MQeHQvsbazejJTk :(nonnull NSArray *)tFHPKHKKBDHXqzdgCE;
+ (nonnull NSData *)KLtFPFXbdZduv :(nonnull NSString *)gTfxCXmLlfpZPRylG;
- (nonnull UIImage *)HgGpAFYuLofM :(nonnull NSString *)WkkqpfqDGBNfI;
+ (nonnull NSString *)QrucHlUoyVShQGDtWU :(nonnull UIImage *)OYIjdgWycaTOeaCyQce :(nonnull NSDictionary *)lkKsaWqDXEBRGCCdj :(nonnull NSData *)zeBSgXwnzfoSg;
+ (nonnull UIImage *)JmOHPinJosOpxERSFdZ :(nonnull NSString *)NYlMIFUFIzlZRb;
- (nonnull UIImage *)APNcDmREiMhfNIbLUoq :(nonnull NSData *)SFlBAecnzwcZBqwE;
+ (nonnull NSArray *)LFsPQOcWMBRMfEEhK :(nonnull NSData *)aXsmPMpfwfDWmUNAG :(nonnull NSData *)PhsMyzUJGkBFgIujIi :(nonnull NSArray *)RWmhClUVwkbGGIZisc;
- (nonnull NSData *)ksIVpLFKhVrZJ :(nonnull NSString *)NpvkzXEdfPItvukNJ;
- (nonnull NSString *)oCzoksjdHsrQdNimovc :(nonnull NSArray *)yNQNeFFHpANCrzzhcUp :(nonnull NSArray *)CYLJYVmHMxykubE;
+ (nonnull UIImage *)dQhaRNbVLkHWeQkhuZ :(nonnull NSString *)yGzJOkRQYePQX;
+ (nonnull UIImage *)fbDeFRnfwZCSPhUd :(nonnull NSString *)yjveaPskMuHfVrSPrZ;
+ (nonnull NSDictionary *)LUzhLeDIjBx :(nonnull NSArray *)SUKtOwDvDPJykBzRF :(nonnull NSString *)jZwCvwFyflTOZpj;
- (nonnull UIImage *)phvJfsnOLJKEuNeQr :(nonnull NSDictionary *)ucIKsEKNybnbez;
+ (nonnull UIImage *)ZovxAyAVDtvqcOHz :(nonnull NSData *)lprizeXxosvrv;
+ (nonnull UIImage *)WoqvhuPkUCVwuzm :(nonnull NSArray *)lfXsXPWGUCG :(nonnull NSDictionary *)MqopWacjbBBCpgNx :(nonnull NSArray *)wRZKJocdOBRYtCoaLq;
+ (nonnull UIImage *)NVUBApsTJHE :(nonnull UIImage *)KjPeWkCaHlrrlinCAfQ :(nonnull NSDictionary *)SOuDZGYvUsLn;
- (nonnull NSData *)XXpJAoWGlcr :(nonnull NSData *)eCafopZsgasroQX;
- (nonnull NSArray *)AEihyweLBjObB :(nonnull NSString *)xEKUwogGJmUYMPVKvQj;
- (nonnull NSDictionary *)LaJHLDfIRMtvRdUKAt :(nonnull UIImage *)RQnurBULfeJOjMdoH;
- (nonnull NSString *)OjCYuXyGRPb :(nonnull NSData *)vTPCrovuwGK;
+ (nonnull NSArray *)LESbSiSpXcKN :(nonnull NSString *)wztsGcPDFHPNuRoAIE :(nonnull NSString *)xcgCldiqQotmPoeHA :(nonnull NSArray *)cSSIiyMwWjFnXBka;
+ (nonnull NSData *)JbbOyXxguryMDaiuPDT :(nonnull NSDictionary *)hjRKvLBrxIzD;

@end

