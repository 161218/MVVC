//
//  CheckGuestureCodeViewController.m
//  祥益金服
//
//  Created by tiramisuZhen on 14-5-23.
//  Copyright (c) 2014年 tiramisuZhen. All rights reserved.
//

#import "CheckGuestureCodeViewController.h"
#import "SVProgressHUD.h"
//#import "ForgetPassword.h"
#import "XYTZGeneral.h"
#import "XYTZJuPhoneNum.h"

@interface CheckGuestureCodeViewController ()
{
    int countNum;
}
@end

@implementation CheckGuestureCodeViewController


/*
- (IBAction)forgetGuesturePasscode:(id)sender
{
    
    AlertView3 * alert = [[[NSBundle mainBundle]loadNibNamed:@"AlertView3" owner:self options:nil]lastObject];
    alert.content = @"请输入爱优理财登陆密码：";
    alert.textFieldPlaceHolderText = @"爱优理财登陆密码";
    alert.isSecret = YES;
    alert.textAlignment = NSTextAlignmentCenter;
    alert.isYUANLabelHidden = YES;
    alert.delegate = self;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:alert];

}
*/

- (IBAction)forgetPwd:(id)sender {
   /*
    //手势密码标示
    [ParamManager.param setObject:@"guesture" forKey:@"forget"];
    
    //忘记密码
    UIStoryboard *storyboard = self.storyboard;
    ForgetPassword *forget = [storyboard instantiateViewControllerWithIdentifier:@"forgetPassword"];
    [self presentViewController:forget animated:YES completion:nil];
    */
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:nil message:@"忘记密码，您需要重新登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag = 100;
    [alter show];
}
#pragma mark  alterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            [ParamManager.param setObject:@"shoushimima" forKey:@"identifyStr"];
            XYTZJuPhoneNum *phoneNum =[[XYTZJuPhoneNum alloc]init];
            UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:phoneNum];
            [self presentViewController:navigation animated:YES completion:nil];
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            [ParamManager.param setObject:@"shoushimima" forKey:@"identifyStr"];
            XYTZJuPhoneNum *phoneNum =[[XYTZJuPhoneNum alloc]init];
            UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:phoneNum];
            [self presentViewController:navigation animated:YES completion:nil];
        }
    }
}
- (IBAction)otherwayLogin:(id)sender {
    
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:nil message:@"更换账号，您需要重新登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag =110;
    [alter show];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    statueBar;
    self.heightq.constant=150;
//    [_userHeaderView.layer setCornerRadius:CGRectGetHeight([_userHeaderView bounds]) / 2];
    _userHeaderView.layer.cornerRadius = 33;
    _userHeaderView.layer.masksToBounds = YES;
//    _userHeaderView.layer.borderWidth = 2;
    _userHeaderView.backgroundColor = [UIColor whiteColor];

    NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    self.userCountLabel.text =[NSString stringWithFormat:@"%@*****%@",[phone substringToIndex:3],[phone substringFromIndex:11-4]];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal.png"];
//    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected.png"];
    
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"circle_gray_136.png"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"circle_red_136.png"];
    
    self.lockView.lineColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 1;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(165, 35, 115, 35);
    
    NSString* phoneName =[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    if (![XYTZGeneral isBlankString:phoneName])
    {
        self.title_lab.text =[NSString stringWithFormat:@"HI,%@****%@",[phoneName substringToIndex:3],[phoneName substringFromIndex:11-4]];
    }
    else
    {
         NSString* userName =[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        if (![XYTZGeneral isBlankString:userName])
        {
            self.title_lab.text =[NSString stringWithFormat:@"HI,%@",userName];
        }

      
    }
    
   
}

#pragma mark --  手势密码代理

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode
{
    LLog(@"%@",passcode);
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode
{
    LLog(@"%@",passcode);
    if ([passcode componentsSeparatedByString:@","].count >= 4)
    {
       
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"guesturePassWordString"] isEqualToString:passcode])
            {
                //首页刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Activate" object:nil ];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                countNum +=1;
                if (countNum == 5)
                {
                    [SVProgressHUD showErrorWithStatus:@"您已退出登录"];
                    LLog(@"跳转到登录页面");

                    [ParamManager.param setObject:@"shoushimima" forKey:@"identifyStr"];
                    XYTZJuPhoneNum *phoneNum =[[XYTZJuPhoneNum alloc]init];
                    UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:phoneNum];
                    [self presentViewController:navigation animated:YES completion:nil];
                    
                    countNum = 0;
                }
                self.tipsLabel.text =[NSString stringWithFormat:@"密码不正确，还可以尝试%d次",5-countNum];
                self.tipsLabel.textColor = [UIColor blackColor];
            }
    }
    else
    {
        self.tipsLabel.text = @"至少连接四个点";
        self.tipsLabel.textColor = [UIColor blackColor];
        
    }
}


@end
