//
//  CCOpenLoginStrategy.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCOpenProtocol.h"
#import "CCOpenRespondEntity.h"


@interface CCOpenStrategy : NSObject <CCOpenProtocol>
@property (nonatomic,copy) void (^respondHander)(CCOpenRespondEntity *);
@end
