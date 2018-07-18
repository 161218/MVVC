


//
//  WoDeViewController.m
//  Universal
//
//  Created by zl on 2018/7/13.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "WoDeViewController.h"
#import "BaseTabBarViewController.h"
#import <SobotKit/SobotKit.h>
#import <SobotKit/ZCUIChatController.h>

@interface WoDeViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIWebViewDelegate>
{
    
    NSDictionary *userInfoDic;//用户信息
    UIImagePickerController *pickerController;
    
    AFHTTPSessionManager* manager2;
    NSString*todaySignTimes;
}
@property (strong, nonatomic) UIImageView* userPic;
@property (nonatomic, strong) UIWebView *webView;
//网址链接
@property (nonatomic, copy) NSString *URLString;
//返回
@property (nonatomic,strong) UIBarButtonItem *leftBarButton;
//关闭
@property (nonatomic,strong) UIBarButtonItem *leftBarButtonSecond;
@end

@implementation WoDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor=MRQGlobalBg;
    //去掉导航栏 .........
    //self.navigationController.delegate = self;
    
    [self createUIImagePicker];
    
    [self webViewUI];
    [self loadFailure];
    [self loadWebRequest];
    //设置刷新按妞
    //UIImageRenderingModeAlwaysOriginal 去掉蓝色背景
    //UIImage *rightImage = [[UIImage imageNamed:@"reload"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //UIBarButtonItem *reloadItem=[[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(loadFailure)];
    //self.navigationItem.rightBarButtonItems = @[reloadItem];
    
    //最新登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMyQianZhuangData) name:@"removeMyQianZhuangData" object:nil];
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedButton.frame=CGRectMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT -150, 40, 40);
    selectedButton.backgroundColor=[UIColor blueColor];
    [selectedButton setTitle:@"退出" forState:UIControlStateNormal];
    [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedButton addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectedButton];
    
    UIButton *initfo=[[UIButton alloc] initWithFrame:CGRectMake(10, 40, 30, 30)];
    [ initfo setTitle:@"客服" forState:UIControlStateNormal];
    initfo.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    [initfo addTarget:self action:@selector(initleftbuto)forControlEvents:UIControlEventTouchUpInside];
    [ initfo setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal ];
    //[self.view addSubview:initfo];
}

-(void)webViewUI
{
    //使用方法，在开启webview的时候开启监听，，销毁weibview的时候取消监听，否则监听还在继续。将会监听所有的网络请求
    //[JWCacheURLProtocol startListeningNetWorking];
    //self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT==812?44:0,SCREEN_WIDTH,SCREEN_HEIGHT==812?SCREEN_HEIGHT:SCREEN_HEIGHT)];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 20*2)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    self.webView.backgroundColor=MRQGlobalBg;
    self.webView.opaque=NO;
    
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
    NSLog(@"statusbar height: %f", rectOfStatusbar.size.height);// 高度
    //（navigationbar）
    CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
    NSLog(@"navigationbar height: %f", rectOfNavigationbar.size.height);// 高度
}

-(void)loadWebRequest
{
    NSURLRequest *request;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oauthToken = [defaults objectForKey:@"oauthToken"];
    if (oauthToken == nil) {
        NSMutableDictionary* post = [[NSMutableDictionary alloc] init];
        [post setObject:@"getProductDetail" forKey:@"service"];
        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        [post setObject:paramsStr forKey:@"sign"];
        
        self.URLString = [NSString stringWithFormat:@"%@?&service=%@&appId=%@&signType=%@&sign=%@",APP_MY,@"getProductDetail",APP_ID,SIGN_TYPE,paramsStr];
        NSLog(@"--NOt ToKen--%@",self.URLString);
        
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
    }
    else
    {
        NSMutableDictionary* post = [[NSMutableDictionary alloc] init];
        [post setObject:oauthToken forKey:@"oauthToken"];
        [post setObject:@"getProductDetail" forKey:@"service"];
        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        [post setObject:paramsStr forKey:@"sign"];
        
        self.URLString = [NSString stringWithFormat:@"%@?oauthToken=%@&service=%@&appId=%@&signType=%@&sign=%@",APP_MY,oauthToken,@"getProductDetail",APP_ID,SIGN_TYPE,paramsStr];
        
        NSLog(@"--ToKen--%@",self.URLString);
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];//  https://www.baidu.com
    }
    
    [self.webView loadRequest:request];
    
    //NSLog(@"cache directory(Main)---%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]);
}

//- (void)dealloc{
//[JWCacheURLProtocol cancelListeningNetWorking];//在不需要用到webview的时候即使的取消监听
//}

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.webView.scrollView.mj_header endRefreshing];
    //禁止长按弹框https://edu.csdn.net/promotion_activity?id=3&utm_source=618qztt
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

//充值成功返回我的VC刷新数据
-(void)setMoney
{
    //[self doRefresh];
}

-(void)initleftbuto{
    //  初始化配置信息
    ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
    [self setZCLibInitInfoParam:initInfo];
    //自定义用户参数
    // [self customUserInformationWith:initInfo];
    ZCKitInfo *uiInfo=[ZCKitInfo new];
    // 自定义UI(设置背景颜色相关)
    //[self customerUI:uiInfo];
    // 自定义提示语相关设置
    // [self customTipWord:initInfo];
    // 之定义商品和留言页面的相关UI
    // [self customerGoodAndLeavePageWithParameter:uiInfo];
    // 未读消息
    //[self customUnReadNumber:uiInfo];
    // 测试模式
    [ZCSobot setShowDebug:NO];
    [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
    // 启动
    [ZCSobot startZCChatView:uiInfo with:self target:nil pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
        // 点击返回
        if(type==ZCPageBlockGoBack){
            NSLog(@"点击了关闭按钮");
        }
        // 页面UI初始化完成，可以获取UIView，自定义UI
        if(type==ZCPageBlockLoadFinish){
            
        }
    } messageLinkClick:nil];
}

- (void)setZCLibInitInfoParam:(ZCLibInitInfo *)initInfo{
    // 获取AppKey
    initInfo.appKey = @"6c3d714f569644919e99cc5c52712189";
}


-(void)loginOut
{
    [XYTZGeneral reoveUserinfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:nil];
    BaseTabBarViewController *dvc = (BaseTabBarViewController*)self.navigationController.tabBarController;
    dvc.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    BOOL hidden = !self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)removeMyQianZhuangData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phone = [defaults objectForKey:@"phone"];
    //title
    //   self.navigationItem.title = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:11-4]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //清空数据，加载
    //[self doRefresh];
}

- (void)createUIImagePicker
{
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor orangeColor];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
}
//
-(void)openMenu {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"支持相机");
            [self makePhoto];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            
            [alert show];
        }
    }else if (buttonIndex == 1){//相片
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            NSLog(@"支持相册1");
            [self choosePicture];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }
    
    
}
//跳转到imagePicker里
- (void)makePhoto
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转到相册
- (void)choosePicture
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}
//跳转图库
- (void)pictureLibrary
{
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}
//用户取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"22222%@",picker);
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
    self.navigationController.navigationBarHidden=YES;
}
//用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"%s,info == %@",__func__,info);
    
    UIImage *userImage = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    userImage = [self scaleImage:userImage toScale:0.3];
    
    //保存图片
    //    [self saveImage:userImage name:@"某个特定标示"];
    
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    self.navigationController.navigationBarHidden=YES;
    [self.userPic setImage:userImage];
    self.userPic.contentMode = UIViewContentModeScaleAspectFill;
    self.userPic.clipsToBounds = YES;
    
    //照片上传
    [self upDateHeadIcon:userImage];
}

- (void)upDateHeadIcon:(UIImage *)photo
{
    NSString *oauthToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"];
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:oauthToken forKey:@"oauthToken"];
    [post setObject:SIGN_TYPE forKey:@"signType"];
    [post setObject:APP_ID forKey:@"appId"];
    [post setObject:@"getProductDetail" forKey:@"service"];
    
    NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
    [post setObject:paramsStr forKey:@"sign"];
    NSLog(@"--param-%@",post);
    
    NSString *postUrl = UPLOADAVATAR;//URL
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.3);//image为要上传的图片(UIImage)
    manager2 = [AFHTTPSessionManager manager];
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager2 POST:postUrl parameters:post constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         //formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *fileName = [NSString stringWithFormat:@"test.jpg"];
         //二进制文件，接口key值，文件路径，图片格式
         [formData appendPartWithFileData:imageData name:@"avatarFile" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
     } success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [SVProgressHUD showSuccessWithStatus:@"上传成功！"];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [SVProgressHUD showSuccessWithStatus:@"上传失败！"];
     }];
}

//单列
-(void) saveSignle:(NSDictionary *)temDic
{
    //单列 只用在申购页面
    [ParamManager.param setValue:[temDic objectForKey:@"borrowId"] forKey:@"borrowId"];
    [ParamManager.param setValue:[temDic objectForKey:@"name"] forKey:@"name"];
    [ParamManager.param setValue:[temDic objectForKey:@"apr"] forKey:@"apr"];
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


-(UIImage *)getimage:(NSString *)urlstr{
    
    return [UIImage imageWithContentsOfFile:urlstr];
}

//缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"----%@",NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}
//修正照片方向(手机转90度方向拍照)
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
