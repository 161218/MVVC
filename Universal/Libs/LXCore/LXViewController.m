//
//  LXViewController.m
//  Chemayi
//
//  Created by Bird on 14-3-17.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import "LXViewController.h"
#import "MBProgressHUD.h"

@interface LXViewController ()
{
    BOOL currentFlag;
    BOOL currentIsNoneBack;
    BOOL currentIsFromPrice;
}

@property (nonatomic,strong) NSMutableDictionary *currentExtDic;

@end

@implementation LXViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerKeyboardEvent];
        self.ctrlView = [[UIControl alloc] init];
        self.blankView = nil;
        self.currentExtDic = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 状态栏颜色 iOS7以上系统有效
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Lifes

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
//    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置默认显示navbar
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self setControlView:self.view];
//    [self.navigationController.navigationBar setBarTintColor:kColorRGBA(65,158,136,1)];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
//    NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

//- (void)setNavgationStationTitle:(NSString *)str action:(SEL)action
//{
//    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cityBtn.frame = CGRectMake(0,0, 50,30);
//    [cityBtn setTitle:str forState:UIControlStateNormal];
//    [cityBtn setImage:[UIImage imageNamed:@"top_return"] forState:UIControlStateNormal];
//    [cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
//    [cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 28, 0, -28)];
//    cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [cityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [cityBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* leftItem=[[UIBarButtonItem alloc]initWithCustomView:cityBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewDidApper = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.viewDidApper = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.ctrlView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.viewDidApper = YES;
//    [self logViewFrameInfo:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentFlag = NO;
    //统一所有返回按钮样式
//    if (iOS7)
//    {
//        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
//        backButtonItem.title = @"返回";
//        [backButtonItem setTintColor:[UIColor blackColor]];
//        self.navigationItem.backBarButtonItem = backButtonItem;
//        [self.tabBarController.tabBar setTranslucent:NO];
//    }

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = MRQGlobalBg;
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    gesture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:gesture];
    /**
     *  兼容IOS7，对页面布局，导航条标题的设置。
     *
     *  @param IOS7_OR_LATER 判断版本是否大于等于IOS7
     *
     */
#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    
    //修复iOS7系统下布局从（0，0）开始问题
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    if ([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)]) {
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark Keyboard
-(void)keyboardWillShow:(NSNotification*)notif
{
    
}

-(void)keyboardWillHide:(NSNotification*)notif
{
    
}

-(void)keyboardWasChange:(NSNotification*)notif
{
    
}

-(void)registerKeyboardEvent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)dismiss:(UIButton *)backBtn
{
    if (self.viewDidApper)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setControlView:(id)sender
{
    self.ctrlView.autoresizesSubviews = YES;
    UIView *view = (UIView *)sender;
    if (self.navigationController.navigationBarHidden == NO)
    {
        self.ctrlView.frame =CGRectMake(0, view.bounds.origin.y-44, view.frame.size.width,view.frame.size.height);
    }
    else
    {
        self.ctrlView.frame = view.bounds;
    }
//    self.ctrlView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.ctrlView.autoresizesSubviews = YES;
    [_ctrlView addTarget:self action:@selector(clearKeyboard)forControlEvents:UIControlEventTouchUpInside];
    if ([sender isKindOfClass:[UIView class]])
    {
        [(UIView *)sender addSubview:self.ctrlView];
        [(UIView *)sender sendSubviewToBack:self.ctrlView];
    }
}

- (void)clearKeyboard
{
    [self.view endEditing:YES];
}

//- (UIBarButtonItem *)createNavBtnItem:(UIViewController *)target normal:(NSString *)imgStr highlight:(NSString *)highStr selector:(SEL)selector
//{
//    UIImage *btnImage = [UIImage imageNamed:imgStr];
//    UIImage *btnImageH = [UIImage imageNamed:highStr];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0.0f, 0.0f, btnImage.size.width+10, btnImage.size.height);
//    btn.backgroundColor = [UIColor clearColor];
//    [btn setImage:btnImage forState:UIControlStateNormal];
//    [btn setImage:btnImageH forState:UIControlStateHighlighted];
//    if (!FBIsEmpty(target))
//    {
//        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    }
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    return item;
//}

- (void)showHudWithString:(NSString *)str
{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
    hud.labelText = str;
    [hud show:YES];

}

- (void)showText:(NSString *)str
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view bringSubviewToFront:hud];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = str;
	hud.margin = 10.f;
	hud.yOffset = 50.f;
	hud.removeFromSuperViewOnHide = NO;
	[hud hide:YES afterDelay:1.0f];
}

- (void)showText:(NSString *)str Seconds:(int)a
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.yOffset = 50.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:a];
}

- (void)hideHud
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)hideLoadingHud
{
    for (MBProgressHUD *hud in [MBProgressHUD allHUDsForView:self.view])
    {
        if (hud.mode==MBProgressHUDModeIndeterminate)
        {
            [hud hide:YES];
        }
    };
}

#pragma mark - NoDataView
- (void)showNoDataView
{
    if (!_nodataImage) {
        _nodataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pub_nodata.png"]];
        [_nodataImage setFrame:CGRectMake(0, 0, 139, 76)];
        [_nodataImage setCenter:self.view.center];
        
        [self.view addSubview:_nodataImage];
    }
}

- (void)hideNodataView
{
    if (_nodataImage) {
        [_nodataImage removeFromSuperview];
        _nodataImage = nil;
    }
}

#pragma mark - ViewController presentModal

- (void)lxPushViewController:(NSString *)className animated:(BOOL)animated {
    Class cls = NSClassFromString(className);
    NSAssert1(cls, @"could not find class '%@'",className);
    id obj = [[cls alloc] initWithNibName:className bundle:nil];
    [self.navigationController pushViewController:obj animated:animated];
}

- (void)pushViewController:(NSString *)className {
    [self lxPushViewController:className animated:YES];
}

- (void)pushViewControllerNoAnimated:(NSString *)className {
    [self lxPushViewController:className animated:NO];
}

- (void)pushNewViewController:(UIViewController *)newViewController {
    [self.navigationController pushViewController:newViewController animated:YES];
}


- (void)replaceViewController:(NSString*)vcClassName withIncomingParam:(id)param
{
    NSMutableArray *vcStack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    [vcStack removeLastObject];
    
    id vc = [NSClassFromString(vcClassName) viewControllerWithIncomingParam:param];
    
    [vcStack addObject:vc];
    
    [self.navigationController setViewControllers:vcStack animated:YES];
}

- (void)replaceViewController:(UIViewController *)viewController withAnimated:(BOOL)animated
{
    NSMutableArray *vcStack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
//    if ([[vcStack lastObject] isKindOfClass:[viewController class]]) {
        [vcStack removeLastObject];
//    }
    
    [vcStack addObject:viewController];
    
    [self.navigationController setViewControllers:vcStack animated:animated];
}

//倒退几页，如从3退到1，就是退2页。
-(void)popToVCBackPageNum:(int) backPageNum animated:(BOOL)animated
{
    
    NSMutableArray *vcStack = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    if ([vcStack count] >= backPageNum+1) {
        LXViewController *targetVC = (LXViewController *)[self.navigationController.viewControllers objectAtIndex:[vcStack count] - (backPageNum+1)];
        [self.navigationController popToViewController:targetVC animated:YES];
    }
}

+ (instancetype)viewControllerWithIncomingParam:(id)param
{
    LXViewController *vc = [[self alloc] initWithNibName:nil bundle:nil];
    
    if ([vc isKindOfClass:[LXViewController class]])
    {
        vc.incomingParam = param;
    }
    
    return vc;
}


#pragma mark - Public Method

/**
 *  选择地域 模态出选择地域的VC
 */
- (void)chooseCity
{
//    LXChooseCityVC *cityVC = [[LXChooseCityVC alloc] init];
//    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:cityVC];
//    
//    [self.navigationController presentViewController:rootNav animated:YES completion:^{
//        
//    }];
}

- (void)logViewFrameInfo:(UIViewController *)vc
{
    LLog(@"---%@---",[vc class]);
    LLog(@"ApplicationFrame:%@",NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
    LLog(@"NavBar Hidden:%@",vc.navigationController.navigationBarHidden?@"YES":@"NO");
    LLog(@"ViewFrame:%@",NSStringFromCGRect(vc.view.frame));
    for (UIView *subView in vc.view.subviews)
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            LLog(@"ScrollViewFrame:%@",NSStringFromCGRect(subView.frame));
        }
    }
}
-(void)showBlankInView:(UIView*)view
{
    if(self.blankView == nil)
    {
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,250)];
        blankView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 34,80,68,68)];
        imageView.image = [UIImage imageNamed:@"blank"];
        
        UILabel *blankLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100,178,200,21)];
        blankLabel.text = @"暂时无数据,请重新刷新";
        blankLabel.textColor = [UIColor lightGrayColor];
        blankLabel.textAlignment = NSTextAlignmentCenter;
        [blankView addSubview:imageView];
        [blankView addSubview:blankLabel];
        self.blankView = blankView;
        [view addSubview:self.blankView];
        self.blankView.userInteractionEnabled = NO;
        
    }
    
    self.blankView.hidden = NO;
    
}
-(void)hideBlankView
{
    if(self.blankView != nil)
    {
        self.blankView.hidden = YES;
    }
}

@end
