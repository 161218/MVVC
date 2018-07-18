//
//  UITabBar+littleRedDotBadge.h
//  Universal
//
//  Created by zl on 2018/7/13.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (littleRedDotBadge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
