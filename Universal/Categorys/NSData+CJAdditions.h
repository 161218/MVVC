//
//  NSData+CJAdditions.h
//  chepeitong
//
//  Created by king on 16/4/27.
//  Copyright © 2016年 chemayi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CJAdditions)

/**
 * Calculate the md5 hash of this data using CC_MD5.
 *
 * @return md5 hash of this data
 */
@property (nonatomic, readonly) NSString* md5Hash;

@end
