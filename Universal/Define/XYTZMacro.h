//
//  XYTZMacro.h
//  UniversalApp
//
//  Created by zl on 2018/7/11.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

//APP基本参数信息宏定义
#define APP_KEY @"EC5353216C8709FE36A2C41038CBB9B5"
#define APP_ID @"20150713100373165481"
#define SIGN_TYPE @"MD5"
#define PERNUM @"10" //每页显示数

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define statueBar [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

// 3.自定义Log
#ifdef DEBUG
#define LLog(...) NSLog(__VA_ARGS__)
#else
#define LLog(...)
#endif

// 4.全局背景色
#define MRQGlobalBg UIColorFromRGB(0xEEEEEE)

// 5.RGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 6.适配宏
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
//注意：请直接获取系统的tabbar高度，若没有用系统tabbar，建议判断屏幕高度；之前判断状态栏高度的方法不妥，如果正在通话状态栏会变高，导致判断异常！
#define kTabBarHeight kAppDelegate.mainTabBar.tabBar.frame.size.height
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define Height_NavContentBar 44.0f
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define Top_Offset SCREEN_HEIGHT==812?88:64
#define IS_IPHONE_X (SCREEN_HEIGHT == 812.0f) ? YES : NO
#define Height_StatusBar (IS_IPHONE_X==YES)?44.0f: 20.0f
#define Height_NavBar    (IS_IPHONE_X==YES)?88.0f: 64.0f
#define Height_TabBar    (IS_IPHONE_X==YES)?83.0f: 49.0f
#define FIT_X(x) (SCREEN_WIDTH/375.*(x)) //x轴适配
#define FIT_Y(y) (SCREEN_HEIGHT/375.*(y)) //y轴适配

// 7.支付宝秘钥
#define RSAPUBLICKEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCJnofEAu7Gt/qCjSnPN+k/Vsfal/7fQ1N024XVBLk6KGVqk4O63DGp9rrNT9YxxiDEfU7OV4wYjUAKzbRCWt8nsAqeWwk32ff046w6SkliZdtYB+hPajOf7AL50+o1v+jtmFHZEoYDmG4BktWfnlc6+DggeX7ZRj+GfnQaHAJcgwIDAQAB"


