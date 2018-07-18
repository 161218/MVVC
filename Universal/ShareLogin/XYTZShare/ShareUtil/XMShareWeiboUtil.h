//  微博分享工具类
//  XMShareWeiboUtil.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

#import "XMShareUtil.h"

@interface XMShareWeiboUtil : XMShareUtil


/**
 *  分享到微博
 */
- (void)shareToWeibo;

+ (instancetype)sharedInstance;

@end
