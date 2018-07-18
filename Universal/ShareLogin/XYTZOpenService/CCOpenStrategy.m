//
//  CCOpenLoginStrategy.m
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "CCOpenStrategy.h"

@implementation CCOpenStrategy

+(instancetype)sharedOpenStrategy{
    //Do nothing
    return nil;
}

-(void)requestOpenAccount:(void(^)(CCOpenRespondEntity *respond))respondHander {
	//Do nothing.
}

-(BOOL)handleOpenURL:(NSURL *)url{
    //Do nothing
    return NO;
}
@end
