//  QQ分享工具类
//  XMShareQQUtil.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "XMShareUtil.h"

//  分享到QQ的类型
typedef NS_ENUM(NSInteger, SHARE_QQ_TYPE){
    
    //  QQ会话
    SHARE_QQ_TYPE_SESSION,
    
    //  QQ空间
    SHARE_QQ_TYPE_QZONE
    
};

@interface XMShareQQUtil : XMShareUtil

/**
 *  分享到QQ会话
 */
- (void)shareToQQ;

/**
 *  分享到QQ空间
 */
- (void)shareToQzone;

+ (instancetype)sharedInstance;

@end
