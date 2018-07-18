//
//  XYTZGeneral.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline BOOL FBIsEmpty(id thing)
{
    return thing == nil ||
    ([thing isEqual:[NSNull null]]) ||
    ([thing isEqual:@"nil"])||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

@interface XYTZGeneral : NSObject

/**
 *  存储用户信息 登录 注册 refreshtoken
 */
+ (void) saveUserInfo:(id )responseObject;
/**
 *  清除用户信息
 */
+(void)reoveUserinfo;

+(NSMutableAttributedString*)setColorizedFontWithOneString:(NSString*)oneStr
                                                  oneColor:(UIColor*)oneColor
                                                   oneFont:(UIFont*)oneFont
                                                 twoString:(NSString*)twoStr
                                                  twoColor:(UIColor*)twoColor
                                                   twoFont:(UIFont*)twoFont
                                               threeString:(NSString*)threeStr
                                                threeColor:(UIColor*)threeColor
                                                 threeFont:(UIFont*)threeFont;

//加载网页,传url和title
+(NSMutableDictionary*)webURlString:(NSString*)url;

//网页的url进行反编码
+(NSString*)URLDecodedString:(NSString*)codeURL;

//网页的数据进行分割,用途
+(NSString*)getwebURL:(NSURLRequest*)request :(UIViewController*)vc;
//判断密码强度函数
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password;
//判断用户是否实名认证，是否设置交易密码
+(void)realNamePayPwdFlag:(UIViewController*)VC :(NSString*)indefinder;
//获取用户信息
+(void)saveData:(UIViewController*)viewController;
//MD5加密
+ (NSString *) paramsToMD5 :(NSMutableDictionary *)post;

//初始化错误次数
+ (void) initErrorNums;
+ (NSString *)getNowTime;
/**
 *  refresh token
 */
//+ (void) refreshToken:(NSString *)errorCode;
+ (void) refreshToken:(NSDictionary *)dict viewController:(UIViewController*)viewController;
/**
 *  系统异常;
 */
+(void)errorCode;
/*
*
*  判断用户输入的密码是否符合规范，符合规范的密码要求：
1. 长度大于8位
2. 密码中必须同时包含数字和字母
*/
+(BOOL)judgePassWordLegal:(NSString *)pass;
//判断字符串是否为空 ,空返回TRUE
+(BOOL) isBlankString:(NSString *)string;
//截取URL中Key Value
+(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;
//不需要更新Token的请求下使用 错误返回信息
+(void)networkdataRequest:(NSDictionary *)dict;
@end
