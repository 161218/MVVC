//
//  CCOpenConfig.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCOpenConfig : NSObject
//微信 配置
+(void)setWeiXinAppID:(NSString *)AppID;
+(NSString *)getWeiXinAppID;

+(void)setWeiXinAppSecret:(NSString *)AppSecret;
+(NSString *)getWeiXinAppSecret;

//QQ 配置
+(void)setQQAppID:(NSString *)AppID;
+(NSString *)getQQAppID;

+(void)setQQAppKey:(NSString *)AppKey;
+(NSString *)getQQAppKey;

//微博 配置
+(void)setWeiBoAppKey:(NSString *)AppKey;
+(NSString *)getWeiBoAppKey;

+(void)setWeiBoAppSecret:(NSString *)AppSecret;
+(NSString *)getWeiBoAppSecret;

+(void)setWeiBoRedirectURI:(NSString *)URI;
+(NSString *)getWeiBoRedirectURI;
@end
