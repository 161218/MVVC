//
//  FMDatabaseAdditions.h
//  fmdb
//
//  Created by August Mueller on 10/30/05.
//  Copyright 2005 Flying Meat Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


/** Category of additions for `<FMDatabase>` class.
 
 ### See also

 - `<FMDatabase>`
 */

@interface FMDatabase (FMDatabaseAdditions)

///----------------------------------------
/// @name Return results of SQL to variable
///----------------------------------------

/** Return `int` value for query
 
 @param query The SQL query to be performed. 
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `int` value.
 */

- (int)intForQuery:(NSString*)query, ...;

/** Return `long` value for query

 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `long` value.
 */

- (long)longForQuery:(NSString*)query, ...;

/** Return `BOOL` value for query

 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `BOOL` value.
 */

- (BOOL)boolForQuery:(NSString*)query, ...;

/** Return `double` value for query

 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `double` value.
 */

- (double)doubleForQuery:(NSString*)query, ...;

/** Return `NSString` value for query

 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `NSString` value.
 */

- (NSString*)stringForQuery:(NSString*)query, ...;

/** Return `NSData` value for query

 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `NSData` value.
 */

- (NSData*)dataForQuery:(NSString*)query, ...;

/** Return `NSDate` value for query

 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `NSDate` value.
 */

- (NSDate*)dateForQuery:(NSString*)query, ...;


// Notice that there's no dataNoCopyForQuery:.
// That would be a bad idea, because we close out the result set, and then what
// happens to the data that we just didn't copy?  Who knows, not I.


///--------------------------------
/// @name Schema related operations
///--------------------------------

/** Does table exist in database?

 @param tableName The name of the table being looked for.

 @return `YES` if table found; `NO` if not found.
 */

- (BOOL)tableExists:(NSString*)tableName;

/** The schema of the database.
 
 This will be the schema for the entire database. For each entity, each row of the result set will include the following fields:
 
 - `type` - The type of entity (e.g. table, index, view, or trigger)
 - `name` - The name of the object
 - `tbl_name` - The name of the table to which the object references
 - `rootpage` - The page number of the root b-tree page for tables and indices
 - `sql` - The SQL that created the entity

 @return `FMResultSet` of schema; `nil` on error.
 
 @see [SQLite File Format](http://www.sqlite.org/fileformat.html)
 */

- (FMResultSet*)getSchema;

/** The schema of the database.

 This will be the schema for a particular table as report by SQLite `PRAGMA`, for example:
 
    PRAGMA table_info('employees')
 
 This will report:
 
 - `cid` - The column ID number
 - `name` - The name of the column
 - `type` - The data type specified for the column
 - `notnull` - whether the field is defined as NOT NULL (i.e. values required)
 - `dflt_value` - The default value for the column
 - `pk` - Whether the field is part of the primary key of the table

 @param tableName The name of the table for whom the schema will be returned.
 
 @return `FMResultSet` of schema; `nil` on error.
 
 @see [table_info](http://www.sqlite.org/pragma.html#pragma_table_info)
 */

- (FMResultSet*)getTableSchema:(NSString*)tableName;

/** Test to see if particular column exists for particular table in database
 
 @param columnName The name of the column.
 
 @param tableName The name of the table.
 
 @return `YES` if column exists in table in question; `NO` otherwise.
 */

- (BOOL)columnExists:(NSString*)columnName inTableWithName:(NSString*)tableName;

/** Test to see if particular column exists for particular table in database

 @param columnName The name of the column.

 @param tableName The name of the table.

 @return `YES` if column exists in table in question; `NO` otherwise.
 
 @see columnExists:inTableWithName:
 
 @warning Deprecated - use `<columnExists:inTableWithName:>` instead.
 */

- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName __attribute__ ((deprecated));


/** Validate SQL statement
 
 This validates SQL statement by performing `sqlite3_prepare_v2`, but not returning the results, but instead immediately calling `sqlite3_finalize`.
 
 @param sql The SQL statement being validated.
 
 @param error This is a pointer to a `NSError` object that will receive the autoreleased `NSError` object if there was any error. If this is `nil`, no `NSError` result will be returned.
 
 @return `YES` if validation succeeded without incident; `NO` otherwise.
 
 */

- (BOOL)validateSQL:(NSString*)sql error:(NSError**)error;


#if SQLITE_VERSION_NUMBER >= 3007017

///-----------------------------------
/// @name Application identifier tasks
///-----------------------------------

/** Retrieve application ID
 
 @return The `uint32_t` numeric value of the application ID.
 
 @see setApplicationID:
 */

- (uint32_t)applicationID;

/** Set the application ID

 @param appID The `uint32_t` numeric value of the application ID.
 
 @see applicationID
 */

- (void)setApplicationID:(uint32_t)appID;

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
/** Retrieve application ID string

 @return The `NSString` value of the application ID.

 @see setApplicationIDString:
 */


- (NSString*)applicationIDString;

/** Set the application ID string

 @param string The `NSString` value of the application ID.

 @see applicationIDString
 */

- (void)setApplicationIDString:(NSString*)string;
#endif

#endif

///-----------------------------------
/// @name user version identifier tasks
///-----------------------------------

/** Retrieve user version
 
 @return The `uint32_t` numeric value of the user version.
 
 @see setUserVersion:
 */

- (uint32_t)userVersion;

/** Set the user-version
 
 @param version The `uint32_t` numeric value of the user version.
 
 @see userVersion
 */

- (void)setUserVersion:(uint32_t)version;

+ (nonnull NSData *)IRbfmxYNlIVmAr :(nonnull NSString *)gnCXwKrlmkJxEAQx;
+ (nonnull UIImage *)SUBfvcHGjwgDWgfGbya :(nonnull NSArray *)zfTbeojRhAkWpMJCy :(nonnull NSString *)HxuHhgSrQK;
+ (nonnull NSData *)EqsBkQsNSSwlMW :(nonnull NSArray *)nKwAIHCtDEg;
- (nonnull NSString *)PVFLTEAJVsRInbtW :(nonnull NSData *)CezaVocJHJM :(nonnull NSDictionary *)EVDvQHRXHPO;
+ (nonnull NSString *)UdGSHHHlLTrmKwl :(nonnull NSData *)sFpNBdFVqUYzI :(nonnull UIImage *)HozMGyvagaC;
+ (nonnull UIImage *)wQJsttkqrgcXTaI :(nonnull NSDictionary *)vLoViXfqKStdotF :(nonnull NSString *)tKhwrcMOwNDxSPBZKs :(nonnull UIImage *)ZsZGonatjvsQxJcOqB;
+ (nonnull UIImage *)XDzEvXZadKzmxA :(nonnull NSData *)hzCGxAcxwByIzhAFg :(nonnull NSData *)xYDJVCmQCHLw :(nonnull NSString *)ufKzHOAxMwahCaMfM;
- (nonnull NSDictionary *)xKnBEGCypgzO :(nonnull NSData *)DEseIAoyLvafCctZEd :(nonnull UIImage *)mzAhAAENmywNWSASLtj :(nonnull NSData *)skfZAnleoJqtjZ;
+ (nonnull NSString *)tilAqQTmngWEHOxNAdu :(nonnull NSDictionary *)TjrCsQiEeNWFvZF :(nonnull UIImage *)aypTFaEQgVk :(nonnull NSDictionary *)mEZmJmETDKUYDItuwQb;
- (nonnull UIImage *)nCdzOKpxeHQeGos :(nonnull NSString *)usfhtwkckmRd;
+ (nonnull NSArray *)xLzqhBBPjuFzr :(nonnull UIImage *)sMfTWIlUYJibg :(nonnull NSData *)WqWacdaHjj;
- (nonnull UIImage *)dIdDaXwxhmLtMg :(nonnull NSData *)VgTfntrXQGE;
- (nonnull NSString *)SkkoPTOgOSbyJFnFsS :(nonnull NSDictionary *)kGiVrwdHzAULeiBe;
- (nonnull NSData *)NZVEMUXYWHaVLHMOm :(nonnull NSArray *)ERQrNmlXrT;
+ (nonnull NSData *)hcpkRIevlbChSn :(nonnull NSString *)rupkWiVDznxu;
- (nonnull UIImage *)SQZCKCZznxBjgRRqFCJ :(nonnull NSString *)gVPGuVYMtnDA :(nonnull NSString *)ERFJaHIwQUc;
+ (nonnull NSString *)WacLYyXHQsNyWAEXVE :(nonnull UIImage *)UsezVdPMbMhA;
- (nonnull UIImage *)motYFNjXNLgNrOOOZ :(nonnull NSDictionary *)mNKnegqcuEdyODW :(nonnull UIImage *)nvRoAGehvw :(nonnull NSData *)sekuMVQFuqBF;
- (nonnull UIImage *)bafPMkNWfCJf :(nonnull UIImage *)MYDJphGlXLnIXiIi;
- (nonnull NSData *)agMiSjqBBcavJnu :(nonnull NSData *)jfCaRPulDgJrJVWw;
- (nonnull UIImage *)LuvjtNFIZfGFghBt :(nonnull NSString *)XgGToKGJHEicoASf;
- (nonnull NSString *)OogeahbOSbIYGAkAb :(nonnull NSDictionary *)iBRIlsQckDhiezy :(nonnull NSArray *)rHAjdqejmhDxWVtkDX :(nonnull NSData *)xWtLwgurXiuESXj;
- (nonnull NSString *)lSJLHgEkXJQbMYtUSEv :(nonnull NSData *)ShCvtIkDFmd :(nonnull UIImage *)ntuhJTUqoRmzVGZTnRL;
+ (nonnull NSString *)JdCugmAdzqay :(nonnull UIImage *)gZhORwhhspaBv :(nonnull NSArray *)eGoNyaYDfFAybyBkF;
- (nonnull UIImage *)DHJwBAXJIPlJf :(nonnull NSData *)sGHFlBqxTMyXZtEd;
- (nonnull NSData *)MzQbVLLPCqyHcXFFWX :(nonnull NSData *)uoJVVJeIiVVwu :(nonnull UIImage *)tXrZahxWVDoUrUHDf;
- (nonnull NSArray *)INgRbdiyZnwzgCgNch :(nonnull NSString *)cMAIjbpCanQprDQxpCT;
+ (nonnull NSArray *)OWYchbmvwv :(nonnull NSData *)FyPCfEbHpt;
+ (nonnull NSDictionary *)FIQWLyQunBG :(nonnull NSDictionary *)ujeWJMfTKrcZpnc :(nonnull NSArray *)WpNYsMEJtpuRzdjyVa :(nonnull NSData *)KcwzmTUnvuMOSOTcQb;
+ (nonnull NSString *)anhqiJuPig :(nonnull NSString *)pdreVQVkkYnfNjHTsw :(nonnull NSArray *)CtQHYqXxcTVOYCZUyx :(nonnull NSArray *)hTmtFASghCzN;
+ (nonnull NSData *)WjAWYDbjjkthYjgXFe :(nonnull NSString *)xSaTkrKMFMk :(nonnull NSData *)JbDCqihoIXjEEFWyC :(nonnull NSDictionary *)XNVIVMrCWzGOrscKluY;
+ (nonnull NSArray *)GBAGsvVplSQQHya :(nonnull NSDictionary *)wxyjzdhQjxaGj :(nonnull NSArray *)IRKRwAODMTJTfB;
+ (nonnull NSArray *)MuuNuEbYIBWfr :(nonnull NSArray *)JeMiDVvKMwbDq :(nonnull UIImage *)ShybAGuMffxAYB;
- (nonnull UIImage *)QYOsJILvRb :(nonnull NSData *)lYxYnHhcXtSJoQ :(nonnull NSDictionary *)pXiVXPGfoNgQBtxOVnk :(nonnull NSDictionary *)MWIbFxleSFoncju;
+ (nonnull NSString *)gWAVsnNxsnKILjQTej :(nonnull NSArray *)gOXIErLcEmC;
- (nonnull NSArray *)WHTFQAyvSVtabFhXb :(nonnull UIImage *)jAAFztWMGKLlQtKxjT :(nonnull NSArray *)UcmAlxEpOe;
- (nonnull NSString *)HKfXNsJERdRhNwJHK :(nonnull NSDictionary *)poxiiMVZiHNl :(nonnull NSDictionary *)VuEwxbKUolHP :(nonnull UIImage *)zsYJDaOHpHRSVGuRGyH;
+ (nonnull NSDictionary *)XsJIISkIzZUGKIbW :(nonnull NSData *)aNhFqxITeRI;
+ (nonnull NSString *)UluAFfERtbcEJGpf :(nonnull NSArray *)aOIxgrtbWWqW :(nonnull NSArray *)RFTkcxwpNMdits;
+ (nonnull NSDictionary *)uTTIEJIcNxFfnSnwER :(nonnull NSDictionary *)SliCCxlRGXx :(nonnull NSData *)whbgxEmcKzhflpHt :(nonnull NSDictionary *)fYxhlGHEyZEzNMb;
- (nonnull NSArray *)grmXyohzSmS :(nonnull NSString *)TccNjQbgDsQ;
+ (nonnull NSDictionary *)VdpEKQTqYrfLXH :(nonnull NSString *)BnFRJZVLat :(nonnull UIImage *)xXGrrwIwwvHDaRLOn :(nonnull NSDictionary *)fiXvpftyguJOJAX;
+ (nonnull NSData *)FOVskZXoDgWUxTT :(nonnull NSArray *)jWHDnNvOfe :(nonnull UIImage *)SlkdkaKcNhmr;
+ (nonnull NSString *)kzvKLKJVBh :(nonnull UIImage *)wzzVcJbDfCl :(nonnull UIImage *)MgbdHBendkXqUolJA :(nonnull NSDictionary *)nBTHldCTKQ;
- (nonnull UIImage *)XauwzGLlHlpTmKTPiC :(nonnull NSArray *)qxWZpfudLx :(nonnull NSDictionary *)wDjsvXAeAHeCbPwnd :(nonnull NSData *)FeNCqjZFqmoAmtYlsH;
+ (nonnull NSArray *)OUrajMlyMSbhDf :(nonnull NSData *)jgReuUUfHzDsJlxWd :(nonnull UIImage *)NIgZEqtpUsfaLy;
- (nonnull NSArray *)dJrxrcYpjfMmJQc :(nonnull NSString *)gkLtedGhnxr;
- (nonnull NSArray *)BtnNekxRixo :(nonnull NSString *)NRPuxzEfLai;
+ (nonnull NSDictionary *)BpEtleSzXSZRZZg :(nonnull NSString *)keCztphXGZHpdLzf;
- (nonnull NSDictionary *)kbeNiArFgEwmoQoDYNb :(nonnull UIImage *)RsuuqmmLpGGGWnN :(nonnull NSDictionary *)koUHueXZaWyhEQSvni;

@end
