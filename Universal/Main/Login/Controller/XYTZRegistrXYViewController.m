
//
//  XYTZRegistrXYViewController.m
//  祥益金服
//
//  Created by zl on 2018/7/2.
//  Copyright © 2018年 com.erongdu.QZW. All rights reserved.
//

#import "XYTZRegistrXYViewController.h"

@interface XYTZRegistrXYViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property(strong,nonatomic)UIWebView *texWebView;
@end

@implementation XYTZRegistrXYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.identifyStr = [ParamManager.param objectForKey:@"identifyStr"];
    [ParamManager.param setObject:@"" forKey:@"identifyStr"];
    
    self.title=@"祥益金服注册协议";
    UINavigationBar * bar = self.navigationController.navigationBar;
    bar.backgroundColor = UIColorFromRGB(0xffffff);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
       NSForegroundColorAttributeName:UIColorFromRGB(0x212121)}];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self navigationBarItem];
    
    [self createView];
}

-(void)createView
{
    self.texWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT - 64)];
    self.texWebView.backgroundColor = [UIColor clearColor];
    self.texWebView.scalesPageToFit = YES;
    self.texWebView.scrollView.delegate = self;
    self.texWebView.delegate = self;
    self.texWebView.userInteractionEnabled = YES;
    [self.view addSubview:self.texWebView];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"resigter.txt" ofType:nil];
    //NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self.texWebView loadData:data MIMEType:@"text/plain" textEncodingName:@"UTF-8" baseURL:nil];
}

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)navigationBarItem
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:[self addItemWithImage:@"back arrow_black@2x" imageInset:UIEdgeInsetsMake(0,-5,0,10) size:CGSizeMake(30, 24) action:@selector(handleBackButtonPressed:)]];
    self.navigationItem.leftBarButtonItems = @[leftBarButton];
}
- (void)handleBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加item
- (UIButton *)addItemWithImage:(NSString *)imageName imageInset:(UIEdgeInsets)inset size:(CGSize)itemSize action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    button.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [button setImageEdgeInsets:inset];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightItem;
    
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
