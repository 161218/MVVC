
//
//  MoreLearViewController.m
//  Universal
//
//  Created by zl on 2018/7/13.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "MoreLearViewController.h"

@interface MoreLearViewController ()<UIWebViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIWebView *webView;
//网址链接
@property (nonatomic, copy) NSString *URLString;
//返回
@property (nonatomic,strong) UIBarButtonItem *leftBarButton;
//关闭
@property (nonatomic,strong) UIBarButtonItem *leftBarButtonSecond;
//分享
@property (nonatomic,strong) NSString *userPhone;
@end

@implementation MoreLearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    [self webViewUI];
    //检测该Vc网络状态
    [self loadFailure];
    //加载Web
    [self loadWebRequest];
    
    //设置刷新按妞
    //UIImageRenderingModeAlwaysOriginal 去掉蓝色背景
    //    UIImage *rightImage = [[UIImage imageNamed:@"reload"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    UIBarButtonItem *reloadItem=[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(loadFailure)];
    //self.navigationItem.rightBarButtonItems = @[reloadItem];
}

-(void)webViewUI
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT==812?SCREEN_HEIGHT - 83:SCREEN_HEIGHT - 49)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    self.webView.backgroundColor=MRQGlobalBg;
    self.webView.opaque=NO;
    
    //iPhoneX 解决下方黑屏
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview: self.webView];
}

-(void)loadWebRequest
{
    NSURLRequest *request;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oauthToken = [defaults objectForKey:@"oauthToken"];
    if (oauthToken == nil) {
        NSMutableDictionary* post = [[NSMutableDictionary alloc] init];
        [post setObject:@"findList" forKey:@"service"];
        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        [post setObject:paramsStr forKey:@"sign"];
        
        self.URLString = [NSString stringWithFormat:@"%@?&service=%@&appId=%@&signType=%@&sign=%@",APP_FIND,@"findList",APP_ID,SIGN_TYPE,paramsStr];
        NSLog(@"--NOt ToKen--%@",self.URLString);
        //APP_FIND
        //APP_MAINHOME
        //APP_INVESTMENTLIST
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
    }
    else
    {
        NSMutableDictionary* post = [[NSMutableDictionary alloc] init];
        [post setObject:oauthToken forKey:@"oauthToken"];
        [post setObject:@"findList" forKey:@"service"];
        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        [post setObject:paramsStr forKey:@"sign"];
        
        self.URLString = [NSString stringWithFormat:@"%@?oauthToken=%@&service=%@&appId=%@&signType=%@&sign=%@",APP_FIND,oauthToken,@"findList",APP_ID,SIGN_TYPE,paramsStr];
        NSLog(@"--ToKen--%@",self.URLString);
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
    }
    
    [self.webView loadRequest:request];
}

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    // 获取h5的标题
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //禁止长按弹框
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    //1.传递accesstoken
    //    LoginModel * login = [LoginMethods getLoginModel];
    //    NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('hwdtoken','%@')",login.accessToken];
    //    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    //2.iOS监听vue的函数
    //self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js调用recharge方法时会走block回调
    //    self.jsContext[@"share"] = ^() {
    //        NSArray *args = [JSContext currentArguments];
    //        //dispatch_async(dispatch_get_main_queue(), ^{
    //        //NSLog(@"收到JS消息");
    //        //});
    //        for (JSValue *jsVal in args) {
    //            NSString *str= [NSString stringWithFormat:@"%@",jsVal];
    //            NSLog(@"jsVal==%@",str);
    //            if ([str isEqualToString:@"" ] )
    //            {
    //                NSLog(@"-------A-------");
    //            }
    //            else if ([str isEqualToString:@""]) {
    //                NSLog(@"-------B-------");
    //            }
    //        }
    //
    //    };
    //[self.webView stringByEvaluatingJavaScriptFromString:@"javaCallback()"];
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //每次拦截都判断下是否有网 提示用户
    //[XYReachability reachabilityChanged];
    NSString *tempStr = [[[request URL] absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"tempStr==%@",tempStr);
    
    NSArray *components = [tempStr componentsSeparatedByString:@"|"];
    NSLog(@"=components=====%@",components);
    
    NSString *str1 = [components objectAtIndex:0];
    NSLog(@"str1(1):%@",str1);
    
    NSArray *array2 = [str1 componentsSeparatedByString:@"/"];
    NSLog(@"array2(2)====%@",array2[0]);
    
    NSInteger coun11 = array2.count;
    NSString *method22 = array2[coun11-2];
    NSLog(@"method22(3)===%@",method22);
    
    NSInteger coun = array2.count;
    NSString *method = array2[coun-1];
    NSLog(@"method(4)===%@",method);
    
    NSArray *array3 = [str1 componentsSeparatedByString:@"?"];
    NSLog(@"array3(5)====%@",array3);
    
    NSInteger counq = array3.count;
    NSString *methodq = array3[counq-1];
    NSLog(@"methodq(6)===%@",methodq);
    
    NSArray *array4 = [methodq componentsSeparatedByString:@"="];
    NSLog(@"array4(7)====%@",array4);
    
    NSInteger counqe = array4.count;
    NSString *methodqe = array4[counqe-1];
    NSLog(@"methodqe(8)====%@",methodqe);
    
    NSDictionary *dictStrUrl=[XYTZGeneral dictionaryWithUrlString:tempStr];
    NSLog(@"dictStrUrl==%@",dictStrUrl);
    
    NSString *nw;
    nw = [dictStrUrl objectForKey:@"nw"];
    NSString *productId;
    productId = [dictStrUrl objectForKey:@"id"];
    NSLog(@"dictStrUrl==%@ nw==%@ id==%@",dictStrUrl,nw,productId);
    //0默认重开窗口 1不开新窗口
    if ([nw isEqualToString:@"1"]) {
        NSLog(@"不开新窗口,且当前URL为:%@ id为:%@",tempStr,productId);
        //return NO;
    }
    
    return YES;
}

#pragma mark 设置BarButtonItem
- (void)setBarButtonItem
{
    //通过imageInset调整item的位置和item之间的位置
    //设置返回按钮
    self.leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:[self addItemWithImage:@"back"
                                                                                imageInset:UIEdgeInsetsMake(0, -10,0, 10)
                                                                                      size:CGSizeMake(30, 24)
                                                                                    action:@selector(selectedToBack)]];
    
    //设置关闭按钮
    self.leftBarButtonSecond = [[UIBarButtonItem alloc]initWithCustomView:[self addItemWithImage:@"close"
                                                                                      imageInset:UIEdgeInsetsMake(0, -20, 0, 15)
                                                                                            size:CGSizeMake(24, 24)
                                                                                          action:@selector(selectedToClose)]];
    
    //self.navigationItem.leftBarButtonItems = @[self.leftBarButton];
    //self.navigationItem.leftBarButtonItems = @[self.leftBarButtonSecond];
    
    if (@available(iOS 11,*)) {
        NSLog(@"** iOS 11 **");
    }else{
        NSLog(@"** Not iOS 11 **");
    }
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
#pragma mark 关闭并上一界面
- (void)selectedToClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 返回上一个网页还是上一个Controller
- (void)selectedToBack
{
    if (self.webView.canGoBack == 1){
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark wkWebViewReload Or 实时监控Vc所有子页面状态
-(void)loadFailure
{
    [XYReachability netWorkState:^(NSInteger netState) {
        if (netState==0||netState==-1) {//没有网或网络连接失败
        }
        else//手机流量(GPRS/2G/3G/4G) WiFi连接成功
        {
            [self.webView reload];
        }
        NSLog(@"netState==%ld",(long)netState);
    }];
    
}

-(void) viewDidDisappear:(BOOL)animated{
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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
