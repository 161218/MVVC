//
//  NSString+CJAdditions.h
//  chepeitong
//
//  Created by king on 16/4/27.
//  Copyright © 2016年 chemayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+CJAdditions.h"

/**
 * Doxygen does not handle categories very well, so please refer to the .m file in general
 * for the documentation that is reflected on api.three20.info.
 */
@interface NSString (CJAdditions)

//+ (NSString *)generateGuid;
/**
 * Determines if the string contains only whitespace and newlines.
 */
//- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 */
//- (BOOL)isEmptyOrWhitespace;

/**
 * Parses a URL query string into a dictionary.
 */
//- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
//- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 * Compares two strings expressing software versions.
 *
 * The comparison is (except for the development version provisions noted below) lexicographic
 * string comparison. So as long as the strings being compared use consistent version formats,
 * a variety of schemes are supported. For example "3.02" < "3.03" and "3.0.2" < "3.0.3". If you
 * mix such schemes, like trying to compare "3.02" and "3.0.3", the result may not be what you
 * expect.
 *
 * Development versions are also supported by adding an "a" character and more version info after
 * it. For example "3.0a1" or "3.01a4". The way these are handled is as follows: if the parts
 * before the "a" are different, the parts after the "a" are ignored. If the parts before the "a"
 * are identical, the result of the comparison is the result of NUMERICALLY comparing the parts
 * after the "a". If the part after the "a" is empty, it is treated as if it were "0". If one
 * string has an "a" and the other does not (e.g. "3.0" and "3.0a1") the one without the "a"
 * is newer.
 *
 * Examples (?? means undefined):
 *   "3.0" = "3.0"
 *   "3.0a2" = "3.0a2"
 *   "3.0" > "2.5"
 *   "3.1" > "3.0"
 *   "3.0a1" < "3.0"
 *   "3.0a1" < "3.0a4"
 *   "3.0a2" < "3.0a19"  <-- numeric, not lexicographic
 *   "3.0a" < "3.0a1"
 *   "3.02" < "3.03"
 *   "3.0.2" < "3.0.3"
 *   "3.00" ?? "3.0"
 *   "3.02" ?? "3.0.3"
 *   "3.02" ?? "3.0.2"
 */
//- (NSComparisonResult)versionStringCompare:(NSString *)other;

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
//@property (nonatomic, readonly) NSString* md5Hash;

- (NSString *)CJURLEncodedString;
-(NSString *)URLDecodedString;

- (NSString*)stringByReplacingUnicode;

- (NSString*)stringByTrimmingWhiteChars;
@end

@interface NSString(CJMD5Addition)

- (NSString *)MD5String;   // lowerCase
- (NSString *)md5To16String;
- (NSString *)uppercaseMD5String;
-(NSString *)md5:(NSString *)str;
- (NSString*)encryptedString;
@end


//@interface NSString (NSStringUtils)
//- (NSString*)encodeAsURIComponent;
//- (NSString*)escapeHTML;
//- (NSString*)unescapeHTML;
//+ (NSString*)localizedString:(NSString*)key;
//+ (NSString*)base64encode:(NSString*)str;

//@end

@interface NSString(CJRSAAddition)

- (NSString *)RSAString;

- (NSString *)RSAStringWithPublicKey:(NSString *)publicKey;

@end



@interface NSString (CJJSONAccess)

- (id)JSONObject;

@end

@interface NSString (CJFile)

+ (NSString *)contentStringWithFileName:(NSString *)fileName;

@end

@interface NSString (CJFormatter)

- (NSString*)formatMaxLen:(int)maxLen;

- (NSString*)formattedCardNo;
- (NSString*)unformattedCardNo;

- (NSString*)formattedPhoneNo;
- (NSString*)unformattedPhoneNo;

- (NSString*)formattedIdcardNo;
- (NSString*)unformattedIdcardNo;

- (NSString*)formattedMoneyNums;

- (NSString*)formatDate;

- (BOOL)isPureNumber;
- (BOOL)isPureCharacter;

- (NSString*)secureMobile;
- (NSString*)secureStringWithShow:(int)headChars andTailsChrs:(int)tailChars;

- (BOOL)isOnlyContainCharactersString:(NSString*)characters;

- (NSString *)secureName;
- (NSString *)secureIdNumber;
- (NSString *)secureCardNumber;

- (NSString *)clearWhiteSpaceAndNewLine;

/*
 *是否合理的充值金额
 */
- (BOOL)isValidRechargeMoney;

/*
 *是否合理的姓名
 */
- (BOOL)isValidNameString;

/*
 *是否合理的密码
 */
- (BOOL)isVerifiedPassword;

/*
 *是否合理的手机号
 */
- (BOOL)isValidMobile;
@end

@interface NSString (CJChk18PaperId)
+(BOOL) Chk18PaperId:(NSString *)sPaperId;
@end

@interface NSString (CJCreateTime)
- (NSString *)formattedCreateOidTime;
@end


@interface NSString (CJUUID)

- (NSString*)UUIDString;

@end

@interface NSString (CJBinary)

+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal;

+ (NSMutableString *)getBinaryAddPara:(NSString *)aPara bPara:(NSString *)bPara;

@end
