//
//  XYReachability.h
//
//  Created by lzy on 16/7/23.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ netStateBlock)(NSInteger netState);

@interface XYReachability : NSObject

/**
 *  网络监测
 *
 *  @param block 判断结果回调
 *
 *  @return 网络监测
 */
+(void)netWorkState:(netStateBlock)block;

+ (void)reachabilityChanged;

@end
