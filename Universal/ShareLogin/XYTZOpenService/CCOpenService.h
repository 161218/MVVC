//
//  CCOpenLoginContext.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCOpenStrategy.h"

typedef enum : NSInteger{
    CCOpenServiceNameWeiXin = 0,
    CCOpenServiceNameQQ,
    CCOpenServiceNameWeiBo
} CCOpenServiceName;


@interface CCOpenService : NSObject

+(instancetype)getOpenServiceWithName:(CCOpenServiceName)name;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)requestOpenAccount:(void(^)(CCOpenRespondEntity *respond))respondHander;

@end
