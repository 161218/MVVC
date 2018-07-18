//
//  AppDelegate.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


+ (AppDelegate *)shareAppDelegate;
//- (void)showIntroWithCrossDissolve;
//-(void)jiakeTabBar;


@property (strong, nonatomic) UIWindow *window;

//@property (assign, nonatomic)NSInteger appType;//app类型：通过后台返回到数据判断0=app，1=JiaKe

@end

