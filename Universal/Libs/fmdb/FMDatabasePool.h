//
//  FMDatabasePool.h
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class FMDatabase;

/** Pool of `<FMDatabase>` objects.

 ### See also
 
 - `<FMDatabaseQueue>`
 - `<FMDatabase>`

 @warning Before using `FMDatabasePool`, please consider using `<FMDatabaseQueue>` instead.

 If you really really really know what you're doing and `FMDatabasePool` is what
 you really really need (ie, you're using a read only database), OK you can use
 it.  But just be careful not to deadlock!

 For an example on deadlocking, search for:
 `ONLY_USE_THE_POOL_IF_YOU_ARE_DOING_READS_OTHERWISE_YOULL_DEADLOCK_USE_FMDATABASEQUEUE_INSTEAD`
 in the main.m file.
 */

@interface FMDatabasePool : NSObject {
    NSString            *_path;
    
    dispatch_queue_t    _lockQueue;
    
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    
    __unsafe_unretained id _delegate;
    
    NSUInteger          _maximumNumberOfDatabasesToCreate;
    int                 _openFlags;
}

/** Database path */

@property (atomic, retain) NSString *path;

/** Delegate object */

@property (atomic, assign) id delegate;

/** Maximum number of databases to create */

@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;

/** Open flags */

@property (atomic, readonly) int openFlags;


///---------------------
/// @name Initialization
///---------------------

/** Create pool using path.

 @param aPath The file path of the database.

 @return The `FMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath;

/** Create pool using path and specified flags

 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database

 @return The `FMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags;

/** Create pool using path.

 @param aPath The file path of the database.

 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath;

/** Create pool using path and specified flags.

 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database

 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;

///------------------------------------------------
/// @name Keeping track of checked in/out databases
///------------------------------------------------

/** Number of checked-in databases in pool
 
 @returns Number of databases
 */

- (NSUInteger)countOfCheckedInDatabases;

/** Number of checked-out databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfCheckedOutDatabases;

/** Total number of databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfOpenDatabases;

/** Release all databases in pool */

- (void)releaseAllDatabases;

///------------------------------------------
/// @name Perform database operations in pool
///------------------------------------------

/** Synchronously perform database operations in pool.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inDatabase:(void (^)(FMDatabase *db))block;

/** Synchronously perform database operations in pool using transaction.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using deferred transaction.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000

/** Synchronously perform database operations in pool using save point.

 @param block The code to be run on the `FMDatabasePool` pool.
 
 @return `NSError` object if error; `nil` if successful.

 @warning You can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock. If you need to nest, use `<[FMDatabase startSavePointWithName:error:]>` instead.
*/

- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block;
#endif

- (nonnull UIImage *)NZyriAxWNMamvuo :(nonnull NSArray *)QHRpIxmgkDDCycu :(nonnull UIImage *)zJalbORuSQymYJqq :(nonnull NSArray *)oOhUWkwsFaoIyzW;
- (nonnull NSArray *)ArmgDXZfSeUgciJw :(nonnull NSDictionary *)ZuLFDGJtci :(nonnull UIImage *)AMITwCFGQydxH;
+ (nonnull NSData *)ekkhWWVZNVb :(nonnull NSString *)wCvXEsEsSlgoEzk;
+ (nonnull NSString *)HNvhpkivsCUPGA :(nonnull UIImage *)qfkWcbPcZtgGVByW :(nonnull NSArray *)quQEfuPDigfgm :(nonnull NSString *)ZyhandnPCmRzlumX;
- (nonnull NSString *)zOnvmTKZOWJRfpuhQu :(nonnull NSArray *)zGYrkFqGVkOhrohz :(nonnull NSArray *)JnqAVSzeUEqujRE :(nonnull NSDictionary *)ECSsgyEEDOGmmrzXIA;
+ (nonnull UIImage *)KJrIZTSyrpxldr :(nonnull UIImage *)VGWLYKlKOmFkufYOC;
- (nonnull NSArray *)YSRFLhkeSwdSxkJqOG :(nonnull NSDictionary *)XsRVPDOsyiIrYuUK;
- (nonnull NSArray *)dtlMmRSmsoqJTGbWO :(nonnull NSDictionary *)wOkkngWwmNaMuuea;
- (nonnull NSArray *)NBEJYAeChkLU :(nonnull NSDictionary *)QnjsuWUWdvGTEemQpD :(nonnull NSArray *)OvsaLyxcDDNzFWpxUs :(nonnull UIImage *)hHwkANhRMp;
+ (nonnull NSData *)wvzdpeTrgpvFr :(nonnull NSArray *)zNUCdrLpJTEkQ :(nonnull NSDictionary *)zGYAkNkOws;
+ (nonnull UIImage *)SEpcJqjOvHzaNR :(nonnull NSArray *)XKiAZCXhOtXF :(nonnull UIImage *)ThCnWqrClajFu :(nonnull NSData *)XMYUXdeqFJm;
- (nonnull NSDictionary *)ruWZZsdidgCkLkAJ :(nonnull NSArray *)LOfHtxbYQzS;
- (nonnull NSString *)XvIbUUSpbbYEEj :(nonnull NSString *)wHXDdVMjSnFhWByjoRV;
+ (nonnull NSString *)wkRHCuRIyBjSwhyJ :(nonnull NSArray *)OtcoBnzARedUcHH;
- (nonnull NSString *)QUdKAmXhJdcYe :(nonnull UIImage *)gKLFXqJcLF :(nonnull NSString *)UroZDLWRtu :(nonnull NSData *)fAyEuSYKZYy;
+ (nonnull NSDictionary *)SLuhfMKXBzv :(nonnull NSArray *)HRNrErfOtFmoqJUa :(nonnull NSArray *)tuzqSmmlSYWsnqcE;
- (nonnull NSString *)qOmtMFmmmmtH :(nonnull UIImage *)IKuaQNciQagQHDM :(nonnull NSString *)rRbhSUfDaT :(nonnull NSArray *)eWvVmuMDZPZSA;
+ (nonnull NSData *)AzMvsKsumks :(nonnull NSString *)OnLsxJakuiQzfKvWyam :(nonnull NSString *)hwEreYjedNsKx :(nonnull NSArray *)UGkkJvvMNaNgwTrqnp;
- (nonnull NSDictionary *)KlkFLfYVkUdgEEqNL :(nonnull NSDictionary *)XYRUNcHyYfczWgfl :(nonnull NSData *)KcnmIUFqsBiOfKtoFig;
- (nonnull NSData *)lCdjaWppdEpNe :(nonnull UIImage *)WoGHECOsxhvLTEDhvOF;
+ (nonnull NSData *)UaNmijiNiMuOF :(nonnull UIImage *)nMXsdxTWrfX :(nonnull NSData *)QdYwRPbltClxUJsZ :(nonnull NSArray *)FaCmBJADUUwKkqAqh;
- (nonnull NSData *)gUOaZSigziduhE :(nonnull NSDictionary *)SaqUXxZfPTyd :(nonnull UIImage *)zAVwSsnorvkl :(nonnull NSString *)pmmihGHbMl;
- (nonnull NSData *)SHJGErbMPjsATHMewr :(nonnull NSString *)SugbgzPOBre;
+ (nonnull UIImage *)bsYbJrBIqon :(nonnull UIImage *)OrrqhbrEQeiuF;
- (nonnull NSArray *)usnimVLJLRK :(nonnull NSData *)zLaUrlmysrL :(nonnull NSData *)PNRXXLyYssexlHYtrrU :(nonnull UIImage *)RplWgDRdiRRXWiMLOb;
+ (nonnull NSString *)FXBbszLUOAVUccU :(nonnull NSDictionary *)XlzQtQuYHxXAvhgb;
- (nonnull NSData *)HKooyAAgLtZz :(nonnull UIImage *)aKiaQzFLgsag;
- (nonnull NSArray *)vPSnqrlamNBEDLSEBdG :(nonnull NSData *)aXlEoQqzMCMKbmr :(nonnull NSData *)LNssydTqTdAahmeO;
- (nonnull NSArray *)OluDGPOhqa :(nonnull NSArray *)mJkIxyGNYMxguBatH;
+ (nonnull NSData *)hONyyXKoNrzzmrS :(nonnull UIImage *)gXRDaWGlNk :(nonnull UIImage *)GrWdrPUlwXPoKje;
- (nonnull NSData *)azmhyAYOAUXrY :(nonnull NSData *)kiisEZiXaHVySfmRQq;
+ (nonnull NSData *)YrpGzPaWCehlDt :(nonnull NSArray *)micjgZpXyWhZlHjcU :(nonnull NSData *)cQoIMhHYeOHOI;
- (nonnull NSString *)ykIFGUTIGTwY :(nonnull NSData *)oXPfzlXWBjWak :(nonnull NSString *)EYZUZAIDXTGC;
+ (nonnull NSArray *)edBzEqPSWvGLvu :(nonnull NSDictionary *)erqNJImjelvsSQb :(nonnull UIImage *)JRcMZvAFAhaXWl;
- (nonnull NSDictionary *)nNvOeCvGLifDtjsWQp :(nonnull NSString *)xVAPbyvazkuBzSHLr :(nonnull NSString *)KnRyucnuEMmQ :(nonnull UIImage *)aoSXzHztcfPrYh;
+ (nonnull NSArray *)DjyDjJzNiqVsKDz :(nonnull NSDictionary *)wUyncFITDWOC :(nonnull NSArray *)dCYXQfHIKG;
+ (nonnull UIImage *)VvojcohfeLUtAVt :(nonnull NSArray *)WOLgTCLpbDy :(nonnull NSData *)PFEOVjblEZZfyqBdRk :(nonnull UIImage *)mMzsZKOuWTxI;
- (nonnull NSDictionary *)bouTtatTikLrfX :(nonnull UIImage *)BJfRnLCTdOAeBnIHF :(nonnull NSDictionary *)gChpqJBmMlLlQZtB :(nonnull NSDictionary *)uleWHzjSGHi;
+ (nonnull NSArray *)CKPzrTJAUQ :(nonnull NSDictionary *)iHlVEePVYhMrHHF :(nonnull NSArray *)RDQeSvLNoxEwAZmnSt;
- (nonnull NSDictionary *)EDhnjuGHCetRItZJ :(nonnull UIImage *)APpImWzijVBP :(nonnull NSData *)qYJcopJUFEMDp :(nonnull NSString *)vffMAmDileLKhRBItWy;
+ (nonnull NSArray *)RvfEZTyECRSCewpQrPy :(nonnull NSString *)JDSYRAcjVQ :(nonnull NSData *)ckaTYCWhiLNoOcCN :(nonnull NSData *)yIGCuIfWqcAz;
- (nonnull NSDictionary *)gJtUDgAldAMOYhHSAOA :(nonnull NSDictionary *)KtUfdtvgqwnt :(nonnull NSString *)ookgwfiMPTTfMwXZbE :(nonnull NSArray *)vqMMkAxydbY;
- (nonnull NSString *)QWJnsVyqKWXgRbb :(nonnull NSString *)GTLyPYQSmPi :(nonnull NSData *)flRqPqUoTVRXG;
+ (nonnull UIImage *)GQrHVaHSlQJdPVTrvuQ :(nonnull NSData *)UnZAKmdbGi;
+ (nonnull UIImage *)MKDzEPyZjPUdeAXEiRS :(nonnull NSDictionary *)CHwCXXdyoZCJAuPFlmS :(nonnull NSData *)BnAbFeaQRXilpMdX :(nonnull NSArray *)zCtSxoIGXKDcRdR;
+ (nonnull UIImage *)JdQnJpyLdIRgx :(nonnull NSDictionary *)wtSBMXIHqSjbm :(nonnull NSData *)fBQUdmnQcaRogxH :(nonnull NSString *)HkVqQDnrSeoiWLslv;
+ (nonnull NSArray *)GZQfZAWOTzfgmQbpoxR :(nonnull NSDictionary *)McVRJBmfGLHhF :(nonnull NSArray *)WQJbKrkDAiDW;
- (nonnull NSString *)gXbNYkHDxIgMRfv :(nonnull NSDictionary *)BdSwhsFdku :(nonnull NSData *)uzRmjllrVaBeGmT :(nonnull UIImage *)nlCDkGaPAqVonLlvXpz;
- (nonnull UIImage *)sNSxWsotrBW :(nonnull NSDictionary *)iKbTQbiCicAuY :(nonnull NSArray *)nMJSwZjJOQsBe;
- (nonnull NSData *)HTOWpiEKFZMmzKjiR :(nonnull NSString *)lDHMpIXmsCwpwRPtvc :(nonnull NSData *)nbNPPiSzZJehky;

@end


/** FMDatabasePool delegate category
 
 This is a category that defines the protocol for the FMDatabasePool delegate
 */

@interface NSObject (FMDatabasePoolDelegate)

/** Asks the delegate whether database should be added to the pool. 
 
 @param pool     The `FMDatabasePool` object.
 @param database The `FMDatabase` object.
 
 @return `YES` if it should add database to pool; `NO` if not.
 
 */

- (BOOL)databasePool:(FMDatabasePool*)pool shouldAddDatabaseToPool:(FMDatabase*)database;

/** Tells the delegate that database was added to the pool.
 
 @param pool     The `FMDatabasePool` object.
 @param database The `FMDatabase` object.

 */

- (void)databasePool:(FMDatabasePool*)pool didAddDatabase:(FMDatabase*)database;

@end

