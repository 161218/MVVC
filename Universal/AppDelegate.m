//
//  AppDelegate.m
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"

@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate>
@property (nonatomic, strong) BaseTabBarViewController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabBarController = [[BaseTabBarViewController alloc] init];
    self.window.rootViewController = self.tabBarController;
    // 设置这个窗口有主窗口并显示
    [self.window makeKeyAndVisible];
    
    //向微信注册
    [WXApi registerApp:@"wx3a39884a3a5334dd" withDescription:@"demo 2.0"];
    //[[TencentOAuth alloc]initWithAppId:@"1104761586" andDelegate:self];
    //新浪
    [WeiboSDK registerApp:@"1762715000"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    if ([[url absoluteString] hasPrefix:@"tencent1104761586"]) {
    //        return [TencentOAuth HandleOpenURL:url];
    //    }
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    if ([[url absoluteString] hasPrefix:@"tencent1104761586"]) {
    //        return [TencentOAuth HandleOpenURL:url];
    //    }

    return [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self];
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title;
        LLog(@"------------微博:%ld",(long)response.statusCode);
        if (response.statusCode ==  0)
        {
            //发送成功
            title = @"发送成功";
            //[SVProgressHUD showSuccessWithStatus:title];
            //世界杯分享(以后会更新)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fxMessage" object:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}
//微博
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        // WXSuccess           = 0,    /**< 成功    */
        // WXErrCodeCommon     = -1,   /**< 普通错误类型    */
        // WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
        //     = -3,   /**< 发送失败    */
        // WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
        // WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
        NSString *strMsg;
        if (resp.errCode == 0)
        {
            strMsg = @"分享成功";
            //世界杯分享(以后会更新)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fxMessage" object:nil];
        }
        else if (resp.errCode == -2)
        {
            strMsg = @"取消分享";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

/**
 *  处理来至QQ的请求
 *
 *  @param req QQApi请求消息基类
 */
//- (void)onReq:(QQBaseReq *)req
//{
//
//}

/**
 *  处理来至QQ的响应
 *
 *  @param resp 响应体，根据响应结果作对应处理
 */
//- (void)onResp:(QQBaseResp *)resp
//{
//    NSString *message;
//    if([resp.result integerValue] == 0) {
//        message = @"分享成功";
//    }else{
//        message = @"分享失败";
//    }
//}

+ (AppDelegate *)shareAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

//显示引导页
//- (void)showIntroWithCrossDissolve
//{
//    XYJKGudiViewController *welcomeVC = [[XYJKGudiViewController alloc] init];
//    [self.window setRootViewController:welcomeVC];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    //在应用程序将要由活动状态切换到非活动状态时候，要执行的委托调用，如 按下 home 按钮，返回主屏幕，或全屏之间切换应用程序等。
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //在应用程序已进入后台程序时，要执行的委托调用。
    [SVProgressHUD dismiss];
    //获取当前时间 ，保存本地
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    LLog(@"------------当前时间：%lld",date);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld",date] forKey:@"dateTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 在应用程序将要进入前台时(被激活)，要执行的委托调用，刚好与applicationWillResignActive 方法相对应。
    //if (self.appType == 0) {//
        [self shoushimima];
    //}
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 调用手势密码
-(void)shoushimima
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int Nowdate = (long long int)time;
    LLog(@"------------当前时间：%lld",Nowdate);
    
    long long int dateTime =[[[NSUserDefaults standardUserDefaults] objectForKey:@"dateTime"] longLongValue];
    LLog(@"%lld",Nowdate - dateTime);
    if (Nowdate - dateTime > 300)
    {
        //开启手势密码 TODO判断是否登录 并且已经存在手势
        NSUserDefaults* defualts = [NSUserDefaults standardUserDefaults];
        
        if (![XYTZGeneral isBlankString:[defualts objectForKey:@"oauthToken"]]&&[[defualts objectForKey:@"isOpenGuestureLock"] boolValue] == YES  &&     [[[NSUserDefaults standardUserDefaults]objectForKey:@"guesturePassWordString"]length]
            )
            
        {
            [self.window.rootViewController presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckGuestureCodeViewController"]animated:YES completion:nil];
            
        }
    }
    else
    {
        //不启用解锁界面，但是首页需要刷新动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Activate" object:nil ];
    }
}

#pragma mark - 后台开关 是否JiaKe
//是否JiaKe开关 0app 1JiaKeapp
-(void)isJieKeRequest
{
    //假装的启动页
    __block UIImageView*launchImageView=[[UIImageView alloc]init];
    launchImageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    launchImageView.image=[UIImage imageNamed:@"logining_add.png"];
    [self.window addSubview:launchImageView];
    
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:@"phoneCheck" forKey:@"service"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // manager.requestSerializer.timeoutInterval = 10;
    [manager POST:APPISJIAKE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //移除假启动页
        [UIView animateWithDuration:2.0f animations:^{
            launchImageView.alpha=0;
        } completion:^(BOOL finished) {
            [launchImageView removeFromSuperview];
            launchImageView=nil;
        }];
        
        LLog(@"------------isAPP：%@", responseObject);
        NSDictionary*responseDict=(NSDictionary*)responseObject;
        //self.appType = [[NSString stringWithFormat:@"%@",responseDict[@"isPacking"]] integerValue];
        //self.appType=0;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [XYTZGeneral errorCode];
    }];
}

@end
