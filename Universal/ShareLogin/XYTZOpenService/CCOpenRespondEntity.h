//
//  CCOpenRespondEntity.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    CCOpenEntityTypeWeiXin = 0,
    CCOpenEntityTypeQQ,
    CCOpenEntityTypeWeiBo
} CCOpenEntityType;

@interface CCOpenRespondEntity : NSObject
@property (nonatomic) CCOpenEntityType type;
@property (nonatomic,strong) NSMutableDictionary *data;
@end
