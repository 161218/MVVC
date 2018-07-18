//
//  BaseTabBarViewController.m
//  企信通
//
//  Created by 林柏参 on 14/7/31.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "XYTZJuPhoneNum.h"

#import "HomeViewController.h"
#import "WoDeViewController.h"
#import "ProductCategoryViewController.h"
#import "MoreLearViewController.h"
@interface BaseTabBarViewController ()<UITabBarControllerDelegate>
{
    UILabel *number_lb;//TabBar小圆点
}

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate=self;
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    HomeViewController *home = [[HomeViewController alloc] init];
    [self setupChildViewController:home title:@"首页" imageName:@"btn_shouye_shouye" selectedImageName:@"btn_shouye_shouye_red" withTag:0];
    
    ProductCategoryViewController *message = [[ProductCategoryViewController alloc] init];
    [self setupChildViewController:message title:@"产品" imageName:@"btn_shouye_chanpin" selectedImageName:@"btn_shouye_chanpin_red" withTag:1];
    MoreLearViewController *discover = [[MoreLearViewController alloc] init];
    [self setupChildViewController:discover title:@"发现" imageName:@"faxian_@2x" selectedImageName:@"faxian_red_@2x" withTag:2];
    WoDeViewController *me = [[WoDeViewController alloc] init];
    [self setupChildViewController:me title:@"我的" imageName:@"wo_@2x" selectedImageName:@"wo_red_@2x" withTag:3];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName withTag:(int)tag
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    //颜色属性
    attributes[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.392 alpha:1.000];
    //字体大小属性
    //attributes[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    NSMutableDictionary *selectAttri = [NSMutableDictionary dictionary];
    selectAttri[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.996 green:0.349 blue:0.239 alpha:1.000];
    //selectAttri[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    //
    //设置为选中状态的文字属性
    [childVc.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //设置选中状态的属性
    [childVc.tabBarItem setTitleTextAttributes:selectAttri forState:UIControlStateSelected];

    // 2.包装一个导航控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];

    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"--tabbaritem.title--%@",viewController.tabBarItem.title);
    LLog(@"当前点击了第:%lu",(unsigned long)tabBarController.selectedIndex);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oauthToken = [defaults objectForKey:@"oauthToken"];
    int index = (int)[tabBarController.viewControllers indexOfObject:viewController];
    //判断点击我的时是否登录
    if (oauthToken == nil)
    {
        if (index == 3)
        {
            XYTZJuPhoneNum *phoneNum =[[XYTZJuPhoneNum alloc]init];
            UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:phoneNum];
            [self presentViewController:navigation animated:YES completion:nil];
            return NO;
        }
    }
    
    if (index == 3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyClick" object:nil];
        //通知我的是否有多张银行卡
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //判断是不是要设置单卡模式
        NSString* needPopStatus = [defaults objectForKey:@"needPopStatus"];
        if ([needPopStatus isEqualToString:@"1"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationSetSingleBank" object:nil ];
        }
    }
    
    if (index ==2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FindClick" object:nil];
    }
    
    if (index ==1)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductClick" object:nil];
//        XYTZTBCViewController *ickImageViewController = [[XYTZTBCViewController alloc] init];
//        [self.navigationController pushViewController: ickImageViewController animated:true];
    }
    
    if (index ==0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MainClick" object:nil];
    }

    return YES;
}

//在更多页面中 添加红色圆点
-(void) addAlertFlagInMoreViewController
{
    number_lb = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 20, 5, 5)];
    CALayer* layer=number_lb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 2.5;
    [number_lb setBackgroundColor:[UIColor colorWithRed:1 green:0.16 blue:0.27 alpha:1]];
    [self.tabBar addSubview:number_lb];
}

@end
