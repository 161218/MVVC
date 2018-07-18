//
//  ChangeGustureLockViewController.m
//  爱优理财
//
//  Created by tiramisuZhen on 14-5-21.
//  Copyright (c) 2014年 tiramisuZhen. All rights reserved.
//

#import "ChangeGustureLockViewController.h"
#import "SVProgressHUD.h"
//#import "XYTZRedPacketView.h"

#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
@interface ChangeGustureLockViewController ()

{
    BOOL isFirstLockCorrecct;
    
}
@property (copy) NSString * guesturePassWordString;
@end

@implementation ChangeGustureLockViewController



//-(void)navigationBarItem
//{
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    [backButton setImage:[UIImage imageNamed:@"NavigationBack_barItem.PNG"] forState:UIControlStateNormal];
//    backButton.backgroundColor = [UIColor blackColor];
//    [backButton setFrame:CGRectMake(16, 0, 32, 44)];
//    [backButton addTarget:self action:@selector(handleBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = barButtonItem;
//}
//- (void)handleBackButtonPressed:(id)sender
//{
//    [self GuestureCodeSettingFaild];
//}
//-(void)GuestureCodeSettingFaild
//{
//    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"isOpenGuestureLock"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"guesturePassWordString"];
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(IBAction)backBtnClick:(id)sender
{
   // self.navigationController.navigationBarHidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil ];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.breakHomePage =[ParamManager.param objectForKey:@"comefromRegistration"];
    [ParamManager.param setObject:@"" forKey:@"comefromRegistration"];
    
    self.hiddenBack_btn = [ParamManager.param objectForKey:@"hiddenBack_btn"];
     [ParamManager.param setObject:@"" forKey:@"hiddenBack_btn"];
    if ([self.hiddenBack_btn isEqualToString:@"hiddenBack_btn"])
    {
        self.back_btn.hidden = NO;
        self.tabbbarTitle_lab.text = @"修改手势密码";
    }
    else
    {
        self.back_btn.hidden = YES;
        self.tabbbarTitle_lab.text = @"设置手势密码";
    }
    
    _backGroundImageView.contentMode = 13;
//    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal.png"];
//    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected.png"];
    
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"circle_gray_136.png"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"circle_red_136.png"];
    self.lockView.lineColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 1;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(150, 30, 100, 30);
    self.resetBtn.hidden = YES;
}
- (IBAction)resetBtnClick:(id)sender
{
    UIButton* regest_btn=(UIButton*)sender;
    if (regest_btn.tag ==120)
    {
        //重新设置密码
        isFirstLockCorrecct = NO;
         self.resetBtn.hidden = YES;
        self.tipsLabel.text = @"手势密码将在您开启程序时启用";
//        [self.smallGuestureLock.choosedNum removeAllObjects];
    }
}
#pragma mark --  AlertView3 Delegate
/*

-(void)confirmButtonClickedAlertViewType3:(NSString *)text WithTag:(NSInteger)tag
{
    NSString * urlStr = [CHECK_PASSWORD([[SingleInstance shareInstance]oauthToken ],[MyMD5 md5:text]) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    
    request.delegate = self;
    [request startAsynchronous];
    [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeBlack];
 }
-(void)cancleButtonClickedAlertViewTyp3WithTag:(NSInteger)tag
{
    [self.navigationController popViewControllerAnimated:YES];
}
 */
/*
#pragma mark  -- ASIHTTPrequest
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"数据提交失败"];
     [self GuestureCodeSettingFaild];
 }
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSData * data = [request responseData];
    
    NSError *error=nil;
    id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments error:&error];
    
    if (JsonObject!=nil&&error==nil)
    {
        
        if ([[JsonObject objectForKey:@"resCode"]integerValue] == 1)
        {
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
        }
        else
        {
            if ([[SingleInstance shareInstance] oauthToken]) {
                [SVProgressHUD showErrorWithStatus:@"密码错误"];
                 [self GuestureCodeSettingFaild];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"您未登录"];
                 [self GuestureCodeSettingFaild];
            }

        }
        
    }
    
  }
*/

#pragma mark --  手势密码代理

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode
{
    LLog(@"%@",passcode);
}
- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode
{
    LLog(@"%@",passcode);
//        self.resetBtn.hidden = NO;
        if ([passcode componentsSeparatedByString:@","].count >= 4)
        {
             self.resetBtn.hidden = NO;
            if (isFirstLockCorrecct == YES)
            {
                if ([self.guesturePassWordString isEqualToString:passcode])
                {
                    //[SVProgressHUD showSuccessWithStatus:@"设置成功"];
                    PopAlterView *popView = [PopAlterView popViewWithTipStr:@"设置成功"];
                    [popView showInView:[UIApplication sharedApplication].keyWindow];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isOpenGuestureLock"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.guesturePassWordString forKey:@"guesturePassWordString"];
    
                    if ([self.breakHomePage isEqualToString:@"comefromRegistration"])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:nil];
                        
                        if (self.presentingViewController.presentingViewController)
                        {
                            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                        else
                        {
                            //新红包注册提醒
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"redpacket" object:nil];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"neWlogin" object:nil];
                        
                    }
                    else if ([self.breakHomePage isEqualToString:@"comeformLogin"])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:nil];
                        
                        if (self.presentingViewController.presentingViewController)
                        {
                            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                        else
                        {

                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"neWlogin" object:nil];
                    }
                    else
                    {
                      [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                else
                {
                    self.tipsLabel.text = @"与上一次密码不一致，请重新绘制";
                    self.tipsLabel.textColor = [UIColor blackColor];
                }
            }
            else
            {
//                //清空已选的密码
//                if (self.smallGuestureLock.choosedNum.count)
//                {
//                    [self.smallGuestureLock.choosedNum removeAllObjects];
//                }
//                
//                for(id object in [passcode componentsSeparatedByString:@","])
//                {
//                    [self.smallGuestureLock.choosedNum addObject:object];
//                }
//                
//                //触发smallGuestureLock drawRect
//                [self.smallGuestureLock setNeedsDisplay];
//                
                isFirstLockCorrecct = YES;
                self.guesturePassWordString = passcode;
                
                self.tipsLabel.text = @"请再次绘制";
                self.tipsLabel.textColor = [UIColor blackColor];
            }
            
        }
        else
        {
            if (isFirstLockCorrecct == NO)
            {
                //第一次
                 self.resetBtn.hidden = YES;
            }
            else
            {
                 self.resetBtn.hidden = NO;
            }
            self.tipsLabel.text = @"至少连接四个点";
            self.tipsLabel.textColor = [UIColor blackColor];
        }
}


@end
