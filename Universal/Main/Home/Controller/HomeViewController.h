//
//  HomeViewController.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface HomeViewController : UIViewController

@property (nonatomic, strong) XMShareView *shareView;

//@property (nonatomic, strong)JSContext *jsContext;

/**
 加载纯外部链接网页
 
 @param string URL地址
 */
//- (void)loadWebURLSring:(NSString *)string;

/**
 加载本地网页
 
 @param string 本地HTML文件名
 */
//- (void)loadWebHTMLSring:(NSString *)string;

/**
 加载外部链接POST请求(注意检查 XFWKJSPOST.html 文件是否存在 )
 postData请求块 注意格式：@"\"username\":\"xxxx\",\"password\":\"xxxx\""
 
 @param string 需要POST的URL地址
 @param postData post请求块
 */
//- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData;

@end

