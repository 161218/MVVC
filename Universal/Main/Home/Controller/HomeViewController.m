//
//  HomeViewController.m
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "XYTZJuPhoneNum.h"
@interface HomeViewController ()<UINavigationControllerDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
//网址链接
@property (nonatomic, copy) NSString *URLString;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //去掉导航栏 .........
    self.navigationController.delegate = self;
    //显示
    [self.tabBarController.tabBar showBadgeOnItemIndex:0];
    //隐藏
    //[self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    
    //新手注册后 红包显示 监听
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(redpacketViewInit:)
//                                                 name: @"redpacket"
//                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(refreshTokenloadView)
                                                 name: @"notificationCentreLogin"
                                               object: nil];
    
    //程序 激活启动
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(loadFailure)
                                                 name: @"Activate"
                                               object: nil];
    
    [self webViewUI];
    [self loadFailure];
    [self loadWebRequest];
    
    [self getDataFromService];
    
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedButton.frame=CGRectMake(SCREEN_WIDTH - 80,64 + 64, 80, 80);
    selectedButton.backgroundColor=[UIColor blueColor];
    [selectedButton setTitle:@"分享" forState:UIControlStateNormal];
    [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedButton addTarget:self action:@selector(sharBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectedButton];
}

-(void)refreshTokenloadView
{
    [XYTZGeneral reoveUserinfo];
    
    XYTZJuPhoneNum * phoneNumVc = [[XYTZJuPhoneNum alloc]init];
    UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:phoneNumVc];
    [self presentViewController:navigation animated:YES completion:nil];
    
    [SVProgressHUD showErrorWithStatus:@"请重新登录"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"outhtoken_failure" object:nil ];
}

-(void)webViewUI
{
    NSLog(@"当前设备Height_StatusBar(状态栏): %f Height_NavBar(导航栏): %f Height_TabBar(TabBar): %f", Height_StatusBar,Height_NavBar,Height_TabBar);
    //使用方法，在开启webview的时候开启监听，，销毁weibview的时候取消监听，否则监听还在继续。将会监听所有的网络请求
    //[JWCacheURLProtocol startListeningNetWorking];
    //self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT==812?44:0,SCREEN_WIDTH,SCREEN_HEIGHT==812?SCREEN_HEIGHT:SCREEN_HEIGHT)];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 20*2)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    self.webView.backgroundColor=MRQGlobalBg;
    self.webView.opaque=NO;
    //self.webView.scrollView.bounces = NO;
    //[(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadFailure];
    }];
    // 马上进入刷新状态
    [self.webView.scrollView.mj_header beginRefreshing];
    
    [self.view addSubview:self.webView];
    
    //iPhoneX 解决下方黑屏
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // (statusbar)
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"statusbar height: %f", rectOfStatusbar.size.height);   // 高度
    //（navigationbar）
    CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
    NSLog(@"navigationbar height: %f", rectOfNavigationbar.size.height);   // 高度
    
    //创建UIActivityIndicatorView背底半透明View
    //    UIColor *color = kColorFromRGB(0x000000);
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    view.backgroundColor = [color colorWithAlphaComponent:0.45];
    //    [view setTag:103];
    //    view.layer.masksToBounds = YES;
    //    view.layer.cornerRadius =5;
    //    [self.view addSubview:view];
    //
    //    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    //    [activityIndicator setCenter:view.center];
    //    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    //    [view addSubview:activityIndicator];
}

-(void)sharBtn
{
//    if(!self.shareView){
//
//        self.shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
//        self.shareView.alpha = 0.0;
//        self.shareView.shareTitle = NSLocalizedString(@"分享标题", nil);
//        self.shareView.shareText = NSLocalizedString(@"分享内容", nil);
//        self.shareView.shareUrl = @"http://amonxu.com";
//        [self.view addSubview:self.shareView];
//
//        [UIView animateWithDuration:1 animations:^{
//            self.shareView.alpha = 1.0;
//        }];
//
//    }else
//    {
//        [UIView animateWithDuration:1 animations:^{
//            self.shareView.alpha = 1.0;
//        }];
//    }
    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.description = @"分享内容";
//    NSLog(@"---%@",@"分享内容");
//    message.title = @"分享标题";
//    UIImage *temImg;
//    temImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"logo.jpg"]]];
//    temImg = [temImg IcontoSize:CGSizeMake(120,120)];
//    [message setThumbImage:temImg];
//
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl =@"https://www.xiangyitouzi.com";
//
//    message.mediaObject = ext;
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//
//    req.scene = WXSceneSession;
//    req.message = message;
//    [WXApi sendReq:req];
}

-(void)loadWebRequest
{
    NSURLRequest *request;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oauthToken = [defaults objectForKey:@"oauthToken"];
    if (oauthToken == nil) {
        NSMutableDictionary* post = [[NSMutableDictionary alloc] init];
        [post setObject:@"home" forKey:@"service"];
        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        [post setObject:paramsStr forKey:@"sign"];
        
        self.URLString = [NSString stringWithFormat:@"%@?&service=%@&appId=%@&signType=%@&sign=%@",APP_MAINHOME,@"home",APP_ID,SIGN_TYPE,paramsStr];
        NSLog(@"--NOt ToKen--%@",self.URLString);
        
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
    }
    else
    {
        NSMutableDictionary* post = [[NSMutableDictionary alloc] init];
        [post setObject:oauthToken forKey:@"oauthToken"];
        [post setObject:@"home" forKey:@"service"];
        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        [post setObject:paramsStr forKey:@"sign"];
        
        self.URLString = [NSString stringWithFormat:@"%@?oauthToken=%@&service=%@&appId=%@&signType=%@&sign=%@",APP_MAINHOME,oauthToken,@"home",APP_ID,SIGN_TYPE,paramsStr];
        
        NSLog(@"--ToKen--%@",self.URLString);
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];//  https://www.baidu.com
    }
    
    [self.webView loadRequest:request];
    
    //NSLog(@"cache directory(Main)---%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]);
}

-(void)viewDidDisappear:(BOOL)animated
{
    //不需要缓存的url，取消注册，即不回走urlprotocol机制了
    //[NSURLProtocol unregisterClass:[SCYCacheURLProtocol class]];
}

//- (void)dealloc{
//[JWCacheURLProtocol cancelListeningNetWorking];//在不需要用到webview的时候即使的取消监听
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    //[activityIndicator startAnimating];
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    [self.webView.scrollView.mj_header endRefreshing];
    //禁止长按弹框
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    //    [activityIndicator stopAnimating];
    //    UIView *view = (UIView *)[self.view viewWithTag:103];
    //    [view removeFromSuperview];
    
    //1.传递accesstoken
    //    LoginModel * login = [LoginMethods getLoginModel];
    //    NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('hwdtoken','%@')",login.accessToken];
    //    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    //2.iOS监听vue的函数
    //self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js调用recharge方法时会走block回调
//        self.jsContext[@"share"] = ^() {
//            NSArray *args = [JSContext currentArguments];
//            //dispatch_async(dispatch_get_main_queue(), ^{
//            //NSLog(@"收到JS消息");
//            //});
//            for (JSValue *jsVal in args) {
//                NSString *str= [NSString stringWithFormat:@"%@",jsVal];
//                NSLog(@"jsVal==%@",str);
//                if ([str isEqualToString:@"" ] )
//                {
//                    NSLog(@"-------A-------");
//                }
//                else if ([str isEqualToString:@""]) {
//                    NSLog(@"-------B-------");
//                }
//            }
//
//        };
//    [self.webView stringByEvaluatingJavaScriptFromString:@"javaCallback()"];
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.webView.scrollView.mj_header endRefreshing];
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
        //处理未登录 未实名认证 未设置交易银行卡
        //[self jilinbao];
        //return NO;
    }
    
    return YES;
}

#pragma mark wkWebViewReload Or 实时监控Vc所有子页面状态
-(void)loadFailure
{
    [XYReachability netWorkState:^(NSInteger netState) {
        if (netState==0||netState==-1) {//没有网或网络连接失败
            
            [self.webView.scrollView.mj_header endRefreshing];
        }
        else//手机流量(GPRS/2G/3G/4G) WiFi连接成功
        {
            [self.webView reload];
        }
        NSLog(@"netState==%ld",(long)netState);
    }];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

-(void)OpenServiceLogin
{
    //微信登录
    CCOpenService *wxService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiXin];
    [wxService requestOpenAccount:^(CCOpenRespondEntity *respond) {
        if (respond == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"^_^亲,您木有安装微信哟~ " delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSLog(@"respond is %@",respond);
        NSDictionary *userInfo = respond.data;
        NSString *string = [NSString stringWithFormat:@"%@",userInfo];
        NSLog(@"%@",string);
        NSString *exec = [NSString stringWithFormat:@"onAuthSuccess('17xiu_m_third_login', 'wechat', '%@', '%@', '%@', '%@', '%@');", userInfo[@"unionid"], userInfo[@"openid"], userInfo[@"nickname"], userInfo[@"headimgurl"], userInfo[@"sex"]];
    }];
    //[strongSelf.webView evaluateJavaScript:exec completionHandler:nil];
    
    //QQ登录
    CCOpenService *qqService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameQQ];
    [qqService requestOpenAccount:^(CCOpenRespondEntity *respond) {
        NSLog(@"respond is %@",respond.data);
        NSDictionary *userInfo = respond.data;
        
        NSString *gender;
        if ([(NSString *)userInfo[@"gender"] isEqualToString: @"男"]) {
            gender = @"0";
        }else{
            gender = @"1";
        }
        
        NSString *exec = [NSString stringWithFormat:@"onAuthSuccess('17xiu_m_third_login', 'qq', '%@', '%@', '%@', '%@', '%@');", userInfo[@"unionid"], userInfo[@"openid"], userInfo[@"nickname"], userInfo[@"figureurl_qq_2"], gender];
        //[strongSelf.webView evaluateJavaScript:exec completionHandler:nil];
    }];
    
    //微博登录
    CCOpenService *wbService = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiBo];
    [wbService requestOpenAccount:^(CCOpenRespondEntity *respond) {
        NSLog(@"respond is %@",respond.data);
        NSDictionary *userInfo = respond.data;
        
        NSString *gender;
        if ([(NSString *)userInfo[@"gender"] isEqualToString: @"m"]) {
            gender = @"0";
        }else{
            gender = @"1";
        }
        
        NSString *exec = [NSString stringWithFormat:@"onAuthSuccess('17xiu_m_third_login', 'weibo', '%@', '%@', '%@', '%@', '%@');", userInfo[@"unionid"], userInfo[@"userID"], userInfo[@"name"], userInfo[@"avatarLargeUrl"], gender];
        //[strongSelf.webView evaluateJavaScript:exec completionHandler:nil];
    }];
}

#pragma mark - 获取首页数据
-(void)getDataFromService
{
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:@"home" forKey:@"service"];
    [post setObject:APP_ID forKey:@"appId"];
    [post setObject:SIGN_TYPE forKey:@"signType"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![XYTZGeneral isBlankString:[defaults objectForKey:@"oauthToken"]])
    {
        [post setObject:[defaults objectForKey:@"oauthToken"] forKey:@"oauthToken"];
    }
    NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
    [post setObject:paramsStr forKey:@"sign"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer.timeoutInterval = 10;
    [manager POST:[NSString stringWithFormat:@"%@%@",@"https://www.xiangyitouzi.com",@"/api/home1xV4.html"] parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger resultCode;
        resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
        NSLog(@"————————————————首页数据: %@", responseObject);
        if (resultCode == 1) {
            NSLog(@"请求成功");
            
            NSDictionary *productDic = [[responseObject objectForKey:@"resultData"] objectForKey:@"product"];
            // 存入单列
            [self saveSignle:productDic];
        }
        else
        {
            NSLog(@"请求失败");
            [XYTZGeneral refreshToken:responseObject viewController:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [XYTZGeneral errorCode];
    }];
}

-(void)saveSignle:(NSDictionary *)temDic
{
    //单列 只用在??页面
    [ParamManager.param setValue:[temDic objectForKey:@"borrowId"] forKey:@"borrowId"];
    [ParamManager.param setValue:[temDic objectForKey:@"name"] forKey:@"name"];
    [ParamManager.param setValue:[temDic objectForKey:@"apr"] forKey:@"apr"];
    [ParamManager.param setValue:[temDic objectForKey:@"ficAccount"] forKey:@"ficAccount"];
    [ParamManager.param setValue:[temDic objectForKey:@"account"] forKey:@"account"];
    [ParamManager.param setValue:[temDic objectForKey:@"accountYes"] forKey:@"accountYes"];
    [ParamManager.param setValue:[temDic objectForKey:@"type"] forKey:@"type"];
    if ([[temDic objectForKey:@"type"] intValue] == 112 ) {
        [ParamManager.param setValue:[temDic objectForKey:@"lastRepayTime"] forKey:@"lastRepayTime"];
    }
    [ParamManager.param setValue:[temDic objectForKey:@"flowMoney"] forKey:@"flowMoney"];
    [ParamManager.param setValue:[temDic objectForKey:@"timeLimit"] forKey:@"timeLimit"];
    [ParamManager.param setValue:[temDic objectForKey:@"timeLimitDay"] forKey:@"timeLimitDay"];
    [ParamManager.param setValue:[temDic objectForKey:@"style"] forKey:@"style"];
    [ParamManager.param setValue:[temDic objectForKey:@"lowestAccount"] forKey:@"lowestAccount"];
    [ParamManager.param setValue:[temDic objectForKey:@"productStatus"] forKeyPath:@"productStatus"];
    [ParamManager.param setValue:[temDic objectForKey:@"brType"] forKey:@"brType"];
}


//清楚单列存储
//[ParamManager clearParam];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
