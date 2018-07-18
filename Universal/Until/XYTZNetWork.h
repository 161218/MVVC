//
//  XYTZNetWork.h
//  UniversalApp
//
//  Created by zl on 2018/7/11.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYTZNetWork : NSObject

+(id)shareAFnetworking;

- (void)performRequestWithPath:(NSString *)path viewController: (UIViewController*)viewController formDataDic:(NSDictionary *)formDataDic backBlock:(void (^)(NSDictionary *, NSError *))aBlock;

@end
