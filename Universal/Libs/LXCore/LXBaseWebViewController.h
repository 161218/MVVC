//
//  LXBaseWebViewController.h
//  Chemayi_iPhone2.0
//
//  Created by Chemayi on 14/11/6.
//  Copyright (c) 2014年 LianXian. All rights reserved.
//

#import "LXViewController.h"

@interface LXBaseWebViewController : LXViewController

/**
 *  显示网页的控件
 */
@property (strong, nonatomic) UIWebView *webView;


/**
 *  需要加载的网址
 *
 *  @param urlString 网址
 */
- (void)loadDataWithURL:(NSString *)urlString;

@end
