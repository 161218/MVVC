//
//  NSString+CJAdditions.m
//  chepeitong
//
//  Created by king on 16/4/27.
//  Copyright © 2016年 chemayi. All rights reserved.
//

#import "NSString+CJAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CJAdditions)

//+ (NSString *)generateGuid {
//	CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
//	//get the string representation of the UUID
//
//#if __has_feature(objc_arc)
//	NSString	*uuidString = (__bridge_transfer  NSString*)CFUUIDCreateString(nil, uuidObj);
//#else
//    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
//#endif
//	return uuidString;
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (BOOL)isWhitespaceAndNewlines {
//	NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//	for (NSInteger i = 0; i < self.length; ++i) {
//		unichar c = [self characterAtIndex:i];
//		if (![whitespace characterIsMember:c]) {
//			return NO;
//		}
//	}
//	return YES;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (BOOL)isEmptyOrWhitespace {
//	return !self.length ||
//	![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
//- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
//	NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
//	NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
//	NSScanner* scanner = [[[NSScanner alloc] initWithString:self] autorelease];
//	while (![scanner isAtEnd]) {
//		NSString* pairString = nil;
//		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
//		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
//		NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
//		if (kvPair.count == 2) {
//			NSString* key = [[kvPair objectAtIndex:0]
//							 stringByReplacingPercentEscapesUsingEncoding:encoding];
//			NSString* value = [[kvPair objectAtIndex:1]
//							   stringByReplacingPercentEscapesUsingEncoding:encoding];
//			[pairs setObject:value forKey:key];
//		}
//	}
//
//	return [NSDictionary dictionaryWithDictionary:pairs];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
//	NSMutableArray* pairs = [NSMutableArray array];
//	for (NSString* key in [query keyEnumerator]) {
//		NSString* value = [query objectForKey:key];
//		value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
//		value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
//		NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
//		[pairs addObject:pair];
//	}
//
//	NSString* params = [pairs componentsJoinedByString:@"&"];
//	if ([self rangeOfString:@"?"].location == NSNotFound) {
//		return [self stringByAppendingFormat:@"?%@", params];
//	} else {
//		return [self stringByAppendingFormat:@"&%@", params];
//	}
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSComparisonResult)versionStringCompare:(NSString *)other {
//	NSArray *oneComponents = [self componentsSeparatedByString:@"a"];
//	NSArray *twoComponents = [other componentsSeparatedByString:@"a"];
//
//	// The parts before the "a"
//	NSString *oneMain = [oneComponents objectAtIndex:0];
//	NSString *twoMain = [twoComponents objectAtIndex:0];
//
//	// If main parts are different, return that result, regardless of alpha part
//	NSComparisonResult mainDiff;
//	if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame) {
//		return mainDiff;
//	}
//
//	// At this point the main parts are the same; just deal with alpha stuff
//	// If one has an alpha part and the other doesn't, the one without is newer
//	if ([oneComponents count] < [twoComponents count]) {
//		return NSOrderedDescending;
//	} else if ([oneComponents count] > [twoComponents count]) {
//		return NSOrderedAscending;
//	} else if ([oneComponents count] == 1) {
//		// Neither has an alpha part, and we know the main parts are the same
//		return NSOrderedSame;
//	}
//
//	// At this point the main parts are the same and both have alpha parts. Compare the alpha parts
//	// numerically. If it's not a valid number (including empty string) it's treated as zero.
//	NSNumber *oneAlpha = [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
//	NSNumber *twoAlpha = [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
//	return [oneAlpha compare:twoAlpha];
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSString*)md5Hash {
//	return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
//}

- (NSString *)CJURLEncodedString
{
#if __has_feature(objc_arc)
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (__bridge CFStringRef)self,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                    kCFStringEncodingUTF8);
#else
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
#endif
    
    
    return result;
}

- (NSString*)stringByReplacingUnicode
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

-(NSString *)URLDecodedString
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}


- (NSString*)stringByTrimmingWhiteChars
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end

@implementation NSString(CJMD5Addition)

- (NSString *) MD5String
{
    const char *original_str = [self UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, strlen(original_str), result);//调用md5
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;//全部大写
}

- (NSString *)md5To16String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//md5 32位 加密 （小写）
-(NSString *)md5:(NSString *)str {
    
    
    
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[32];
    
    
    
    CC_MD5( cStr, strlen(cStr), result );
    
    
    
    return [NSString stringWithFormat:
            
            
            
            @"xxxxxxxxxxxxxxxx",
            
            
            
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15],
            
            result[16], result[17],result[18], result[19],
            
            result[20], result[21],result[22], result[23],
            
            result[24], result[25],result[26], result[27],
            
            result[28], result[29],result[30], result[31]];
    
}

- (NSString*)encryptedString
{
    return [[self uppercaseMD5String] uppercaseMD5String];
}
@end

@implementation NSString(CJRSAAddition)

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

- (NSString *)RSAString
{
    return [self encryptString:self publicKey:RSAPUBLICKEY];
}

- (NSString *)RSAStringWithPublicKey:(NSString *)publicKey
{
    return [self encryptString:self publicKey:publicKey];
}

- (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
    NSData *data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

- (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}

- (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

- (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

- (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}


@end

@implementation NSString (CJJSONAccess)

//NSJSONReadingAllowFragments允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
- (id)JSONObject
{
    NSError *error = nil;
    
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:stringData
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    
    if (error != nil)
    {
        @throw [NSException exceptionWithName:@"JSON error"
                                       reason:[error description]
                                     userInfo:@{@"string":[NSString stringWithString:self]}];
    }
    
    return jsonObj;
    
}

@end

//static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//@implementation NSString (NSStringUtils)
//- (NSString*)encodeAsURIComponent
//{
//	const char* p = [self UTF8String];
//	NSMutableString* result = [NSMutableString string];
//
//	for (;*p ;p++) {
//		unsigned char c = *p;
//		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_') {
//			[result appendFormat:@"%c", c];
//		} else {
//			[result appendFormat:@"%%%02X", c];
//		}
//	}
//	return result;
//}

//+ (NSString*)base64encode:(NSString*)str
//{
//    if ([str length] == 0)
//        return @"";
//
//    const char *source = [str UTF8String];
//    int strlength  = strlen(source);
//
//    char *characters = malloc(((strlength + 2) / 3) * 4);
//    if (characters == NULL)
//        return nil;
//
//    NSUInteger length = 0;
//    NSUInteger i = 0;
//
//    while (i < strlength) {
//        char buffer[3] = {0,0,0};
//        short bufferLength = 0;
//        while (bufferLength < 3 && i < strlength)
//            buffer[bufferLength++] = source[i++];
//        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
//        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
//        if (bufferLength > 1)
//            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
//        else characters[length++] = '=';
//        if (bufferLength > 2)
//            characters[length++] = encodingTable[buffer[2] & 0x3F];
//        else characters[length++] = '=';
//    }
//
//    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
//}

//- (NSString*)escapeHTML
//{
//	NSMutableString* s = [NSMutableString string];
//
//	int start = 0;
//	int len = [self length];
//	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
//
//	while (start < len) {
//		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
//		if (r.location == NSNotFound) {
//			[s appendString:[self substringFromIndex:start]];
//			break;
//		}
//
//		if (start < r.location) {
//			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
//		}
//
//		switch ([self characterAtIndex:r.location]) {
//			case '<':
//				[s appendString:@"&lt;"];
//				break;
//			case '>':
//				[s appendString:@"&gt;"];
//				break;
//			case '"':
//				[s appendString:@"&quot;"];
//				break;
//			case '&':
//				[s appendString:@"&amp;"];
//				break;
//		}
//
//		start = r.location + 1;
//	}
//
//	return s;
//}
//
//- (NSString*)unescapeHTML
//{
//	NSMutableString* s = [NSMutableString string];
//	NSMutableString* target = [[self mutableCopy] autorelease] ;
//	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
//
//	while ([target length] > 0) {
//		NSRange r = [target rangeOfCharacterFromSet:chs];
//		if (r.location == NSNotFound) {
//			[s appendString:target];
//			break;
//		}
//
//		if (r.location > 0) {
//			[s appendString:[target substringToIndex:r.location]];
//			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
//		}
//
//		if ([target hasPrefix:@"&lt;"]) {
//			[s appendString:@"<"];
//			[target deleteCharactersInRange:NSMakeRange(0, 4)];
//		} else if ([target hasPrefix:@"&gt;"]) {
//			[s appendString:@">"];
//			[target deleteCharactersInRange:NSMakeRange(0, 4)];
//		} else if ([target hasPrefix:@"&quot;"]) {
//			[s appendString:@"\""];
//			[target deleteCharactersInRange:NSMakeRange(0, 6)];
//		} else if ([target hasPrefix:@"&amp;"]) {
//			[s appendString:@"&"];
//			[target deleteCharactersInRange:NSMakeRange(0, 5)];
//		} else {
//			[s appendString:@"&"];
//			[target deleteCharactersInRange:NSMakeRange(0, 1)];
//		}
//	}
//
//	return s;
//}

//+ (NSString*)localizedString:(NSString*)key
//{
//	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
//}

//@end

@implementation NSString (CJFile)

+ (NSString *)contentStringWithFileName:(NSString *)fileName
{
    NSString *bundleName = @"hsResources.bundle";
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Contents/Resources/%@", bundleName, fileName];
    
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    if (content.length > 0) {
        return content;
    }
    
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: bundleName];
    NSBundle *sdkBundle = [NSBundle bundleWithPath: bundlePath];
    if (sdkBundle != nil && fileName)
    {
        filePath = [[sdkBundle resourcePath] stringByAppendingPathComponent:fileName];
        
        content = [NSString stringWithContentsOfFile:filePath
                                            encoding:NSUTF8StringEncoding
                                               error:&error];
        
        if (content.length > 0) {
            return content;
        }
    }
    
    filePath = [[NSBundle mainBundle] bundlePath];
    //filePath = [filePath stringByDeletingLastPathComponent];
    NSString *absolutefileName = [fileName lastPathComponent];
    //	TRACELOG([filePath stringByAppendingPathComponent:absolutefileName]);
    absolutefileName = [filePath stringByAppendingPathComponent:absolutefileName];
    
    content = [NSString stringWithContentsOfFile:absolutefileName
                                        encoding:NSUTF8StringEncoding
                                           error:nil];
    
    return content;
}

@end

@implementation NSString (CJFormatter)

- (NSString*)formatMaxLen:(int)maxLen
{
    if (self.length > maxLen)
    {
        return [self substringToIndex:maxLen];
    }
    return self;
}

- (NSString*)formattedCardNo
{
    NSMutableString *toBeString = [NSMutableString stringWithString:self];
    
    [toBeString replaceOccurrencesOfString:@" " withString:@""
                                   options:NSCaseInsensitiveSearch range:NSMakeRange(0, toBeString.length)];
    
    for (int i = 6; i > 0; i--)
    {
        int insertSpaceIndex = i * 4;
        if ([toBeString length] > insertSpaceIndex)
        {
            [toBeString insertString:@" " atIndex:insertSpaceIndex];
        }
    }
    
    int maxLen = 23;
    if (toBeString.length > maxLen)
    {
        [toBeString deleteCharactersInRange:NSMakeRange(maxLen, toBeString.length - maxLen)];
    }
    
    return [toBeString formatMaxLen:maxLen];
}

- (NSString*)unformattedCardNo
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)formattedPhoneNo
{
    NSMutableString *toBeString = [NSMutableString stringWithString:self];
    
    [toBeString replaceOccurrencesOfString:@" " withString:@""
                                   options:NSCaseInsensitiveSearch range:NSMakeRange(0, toBeString.length)];
    
    
    if ([toBeString length] > 7)
    {
        [toBeString insertString:@" " atIndex:7];
    }
    if ([toBeString length] > 3)
    {
        [toBeString insertString:@" " atIndex:3];
    }
    
    int maxLen = 13;
    if (toBeString.length > maxLen)
    {
        [toBeString deleteCharactersInRange:NSMakeRange(maxLen, toBeString.length - maxLen)];
    }
    
    return [toBeString formatMaxLen:maxLen];
}

- (NSString*)unformattedPhoneNo
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (NSString*)formattedIdcardNo
{
    NSMutableString *toBeString = [NSMutableString stringWithString:self];
    
    [toBeString replaceOccurrencesOfString:@" " withString:@""
                                   options:NSCaseInsensitiveSearch range:NSMakeRange(0, toBeString.length)];
    
    
    if ([toBeString length] > 14)
    {
        [toBeString insertString:@" " atIndex:14];
    }
    if ([toBeString length] > 6)
    {
        [toBeString insertString:@" " atIndex:6];
    }
    
    int maxLen = 20;
    if (toBeString.length > maxLen)
    {
        [toBeString deleteCharactersInRange:NSMakeRange(maxLen, toBeString.length - maxLen)];
    }
    
    return [toBeString formatMaxLen:maxLen];
}

- (NSString*)unformattedIdcardNo
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)formattedMoneyNums
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSArray *strArr = [self componentsSeparatedByString:@"."];//分割字符串
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: [strArr[0] doubleValue]]];
    if (strArr.count == 1) {
        numberString = [NSString stringWithFormat:@"%@",numberString];
    }
    else
    {
        numberString = [NSString stringWithFormat:@"%@.%@",numberString,strArr[1]];
    }
    
    return numberString;
}

- (NSString*)formatDate
{
    NSMutableString *dateString = [NSMutableString stringWithString:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (self.length > 12)
    {
        [dateString insertString:@":" atIndex:12];
    }
    if (self.length > 10)
    {
        [dateString insertString:@":" atIndex:10];
    }
    if (self.length > 8)
    {
        [dateString insertString:@" " atIndex:8];
    }
    if (self.length > 6)
    {
        [dateString insertString:@"-" atIndex:6];
    }
    if (self.length > 4)
    {
        [dateString insertString:@"-" atIndex:4];
    }
    
    [dateString deleteCharactersInRange:NSMakeRange(dateString.length - 3, 3)];     // 移除后三位
    return dateString;
}

- (BOOL)isPureNumber
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    int number;
    return [scanner scanInt:&number] && [scanner isAtEnd];
}

- (BOOL)isPureCharacter
{
    NSCharacterSet *letterSet = [NSCharacterSet letterCharacterSet];
    return  [[self stringByTrimmingCharactersInSet:letterSet] isEqualToString:@""];
}

- (NSString*)secureMobile
{
    return [NSString stringWithFormat:@"%@****%@",
            [self substringToIndex:3],
            [self substringFromIndex:self.length-4]];
}

- (NSString*)secureStringWithShow:(int)headChars andTailsChrs:(int)tailChars
{
    if (headChars + tailChars >= self.length) {
        return [NSString stringWithString:self];
    }
    
    NSMutableString *maskString = [NSMutableString string];
    
    for (int i = 0; i < self.length - (headChars + tailChars); i++) {
        [maskString appendString:@"*"];
    }
    
    [maskString insertString:[self substringToIndex:headChars] atIndex:0];
    [maskString appendString:[self substringFromIndex:self.length-tailChars]];
    
    return maskString;
}

- (BOOL)isOnlyContainCharactersString:(NSString*)characters
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    NSCharacterSet* charsets = [NSCharacterSet characterSetWithCharactersInString:characters];
    NSString* restr = @"";
    
    [scanner scanCharactersFromSet:charsets intoString:&restr];
    
    if([restr length] == [self length])
    {
        return YES;
    }
    return  NO;
    
}

-(NSString *)secureName{
    NSString *name = [self substringFromIndex:1];
    //    for (int i = 0; i < self.length - 1; i++)
    //    {
    //        name = [NSString stringWithFormat:@"*%@", name];
    //    }
    name = [NSString stringWithFormat:@"*%@", name];
    return name;
    //    return [NSString stringWithFormat:@"*%@",[self substringFromIndex:self.length - 1]];
}

-(NSString *)secureIdNumber
{
    return [NSString stringWithFormat:@"%@*************%@",
            [self substringToIndex:1],
            [self substringFromIndex:self.length-1]];
    
}

-(NSString *)secureCardNumber
{
    return [NSString stringWithFormat:@"%@********%@",
            [self substringToIndex:6],
            [self substringFromIndex:self.length-4]];
    
}

- (NSString *)clearWhiteSpaceAndNewLine
{//去除一个String里面的空格跟换行
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
            componentsJoinedByString:@""];
}

- (BOOL)isValidRechargeMoney
{
    NSRange range = [self rangeOfString:@"."];
    if (range.length > 0) {
        NSString *behindString = [self substringFromIndex:range.location+range.length];
        NSLog(@"behindString: %@",behindString);
        if (behindString.length > 2) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isValidNameString
{
    if ([self length]<2 || [self length]>7) {
        return NO;
    }
    for (int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        NSLog(@"a lenght: %d",a);
        if( a < 0x4e00 || a > 0x9fff)
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isVerifiedPassword
{
    //    if (self.length >20 || self.length <6) {
    //        return NO;
    //    }
    if ([self isPureNumber]) {
        return NO;
    }
    if ([self isPureCharacter]) {
        return NO;
    }
    return YES;
}

- (BOOL)isValidMobile
{
    if (self.length != 11) {
        return NO;
    }
    if (![self isPureNumber]) {
        return NO;
    }
    if (![self hasPrefix:@"1"]) {
        
        return NO;
    }
    return YES;
}
@end

@implementation NSString (CJChk18PaperId)
/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
+(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger  )value1 Value2:(NSInteger )value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}
/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+(BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
    }
    return YES;
}

/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
+(BOOL) Chk18PaperId:(NSString *)sPaperId
{
    sPaperId = [sPaperId clearWhiteSpaceAndNewLine];
    
    // x 变成 X
    sPaperId = [sPaperId uppercaseString];
    
    //判断位数
    if ([sPaperId length] < 15 ||[sPaperId length] > 18) {
        
        return NO;
    }
    
    NSString *carid = sPaperId;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15) {
        
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
        
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![NSString areaCode:sProvince]) {
        
        return NO;
    }
    
    //判断年月日是否有效
    
    //年份
    int strYear = [[NSString getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[NSString getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[NSString getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId))
    {
        return NO;
    }
    
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}

@end

@implementation NSString (CJCreateTime)

- (NSString *)formattedCreateOidTime
{
    if (self.length < 12) {
        return nil;
    }
    NSString *ret = nil;
    @try {
        NSString *year = [self substringWithRange:NSMakeRange(0, 4)];
        NSString *mon = [self substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [self substringWithRange:NSMakeRange(6, 2)];
        NSString *HH = [self substringWithRange:NSMakeRange(8, 2)];
        NSString *MM = [self substringWithRange:NSMakeRange(10, 2)];
        NSString *SS = [self substringWithRange:NSMakeRange(12, 2)];
        
        ret = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,mon,day,HH,MM,SS];
    }
    @catch (NSException *exception) {
        ret = @"";
    }
    @finally {
    }
    
    return ret;
}

@end

@implementation NSString (CJUUID)

- (NSString*)UUIDString
{
    
    CFUUIDRef uuidObject = CFUUIDCreateFromString(kCFAllocatorDefault, (CFStringRef)self);
    
    // Create universally unique identifier (object)
    //CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   ...
    //   UInt8 byte15;
    // } CFUUIDBytes;
    //CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    CFRelease(uuidObject);
    
    return uuidStr;
}

@end

@implementation NSString (CJBinary)

+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal
{
    int num = [decimal intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (int i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

+ (NSMutableString *)getBinaryAddPara:(NSString *)aPara bPara:(NSString *)bPara
{
    NSMutableString *resultPara = [NSMutableString string];
    for (int i = 0; i < 8; i++) {
        NSString *aStr = [aPara substringWithRange:NSMakeRange(i, 1)];
        NSString *bStr = [bPara substringWithRange:NSMakeRange(i, 1)];
        NSString *resultStr = [NSString stringWithFormat:@"%lld",([aStr longLongValue] | [bStr longLongValue])];
        [resultPara appendString:resultStr];
    }
    return resultPara;
}

@end
