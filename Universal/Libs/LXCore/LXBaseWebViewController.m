//
//  LXBaseWebViewController.m
//  Chemayi_iPhone2.0
//
//  Created by Chemayi on 14/11/6.
//  Copyright (c) 2014年 LianXian. All rights reserved.
//

#import "LXBaseWebViewController.h"

@interface LXBaseWebViewController () <UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation LXBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : activityIndicatorView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)webView
{
    if (!_webView) {
        
        CGRect webViewFrame = [[UIScreen mainScreen] applicationFrame];
        webViewFrame.origin.y = 0;
        webViewFrame.size.height -= CGRectGetHeight(self.navigationController.navigationBar.bounds);
        
        _webView = [[UIWebView alloc] initWithFrame:webViewFrame];
        [_webView sizeToFit];
        _webView.delegate = self;
        
//        _webView.scalesPageToFit = YES;
    }
    
    return _webView;
}

- (void)loadDataWithURL:(NSString *)urlString
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicatorView stopAnimating];
}

@end
