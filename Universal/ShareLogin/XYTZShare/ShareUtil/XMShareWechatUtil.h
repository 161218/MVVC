//  微信分享工具类
//  XMShareWechatUtil.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XMShareUtil.h"

@interface XMShareWechatUtil : XMShareUtil


/**
 *  分享到微信会话
 */
- (void)shareToWeixinSession;

/**
 *  分享到朋友圈
 */
- (void)shareToWeixinTimeline;

+ (instancetype)sharedInstance;

@end
