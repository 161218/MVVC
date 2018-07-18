//  分享工具类基类
//  XMShareUtil.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMarco.h"

@interface XMShareUtil : NSObject

/**
 *  分享标题
 */
@property (nonatomic, strong) NSString *shareTitle;

/**
 *  分享内容
 */
@property (nonatomic, strong) NSString *shareText;

/**
 *  分享链接地址
 */
@property (nonatomic, strong) NSString *shareUrl;


@end
