//
//  XYTZRegistrFinishView.m
//  祥益金服
//
//  Created by Liang Shen on 14-7-4.
//  Copyright (c) 2014年 com.erongdu.QZW. All rights reserved.
//

#import "XYTZRegistrFinishView.h"
#import "SVProgressHUD.h"
#import "ChangeGustureLockViewController.h"

#import "XYTZJuPhoneNum.h"
#import "XYTZRegistrXYViewController.h"

@interface XYTZRegistrFinishView ()
{
    UILabel *verify_lb;
    UILabel *pass_lb;
    UILabel *pass_lbEd;
    NSInteger secondsCountDown;//读秒
    NSTimer *countDownTimer;
}
@property (strong, nonatomic)  UILabel *subtitle_lb;
@property (strong, nonatomic)  UITextField *verifyCode_text;
@property (strong, nonatomic)  UIButton *verify_btn;
@property (strong, nonatomic)  UITextField *passWord_text;
@property (strong, nonatomic)  UITextField *passWordEd_text;
@property (strong, nonatomic)  UIButton *finish_btn;

@end

@implementation XYTZRegistrFinishView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.indenfiter = [ParamManager.param objectForKey:@"registerBool"];
    [ParamManager.param setObject:@"no" forKey:@"registerBool"];
    
    self.title=@"注册";
    UINavigationBar * bar = self.navigationController.navigationBar;
    bar.backgroundColor = UIColorFromRGB(0xffffff);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
       NSForegroundColorAttributeName:UIColorFromRGB(0x212121)}];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self navigationBarItem];
    
    [self createPhoneBgView];
    
    [self addNotification];
}

-(void)createPhoneBgView
{
    self.subtitle_lb = [[UILabel alloc]initWithFrame:CGRectMake(41,64 + 40, SCREEN_WIDTH - 41*2, 20)];
    self.subtitle_lb.text = [NSString stringWithFormat:@"已向您尾号为%@的手机号发送验证码",[self.phoneNum substringFromIndex:self.phoneNum.length - 4]];
    self.subtitle_lb.textColor = UIColorFromRGB(0x909396);
    self.subtitle_lb.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [self.view addSubview:self.subtitle_lb];
    
    verify_lb = [[UILabel alloc] initWithFrame:CGRectMake(41,145,128,23)];
    verify_lb.textAlignment = NSTextAlignmentLeft;
    verify_lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    verify_lb.textColor = UIColorFromRGB(0x212121);
    verify_lb.text=@"验证码";
    
    self.verifyCode_text=[[UITextField alloc]initWithFrame:CGRectMake(verify_lb.frame.origin.x,verify_lb.frame.origin.y + verify_lb.frame.size.height + 31, 126, 25)];
    self.verifyCode_text.delegate=self;
    self.verifyCode_text.returnKeyType = UIReturnKeyDone;
    NSString *holderText=@"请输入验证码";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xCCCCCC)
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont  boldSystemFontOfSize:18]
                        range:NSMakeRange(0, holderText.length)];
    self.verifyCode_text.attributedPlaceholder = placeholder;
    
    UIView * inputVerifyCodeLine = [[UIView alloc]initWithFrame:CGRectMake(verify_lb.frame.origin.x,self.verifyCode_text.frame.origin.y+ self.verifyCode_text.frame.size.height+8,SCREEN_WIDTH - verify_lb.frame.origin.x *2,0.5)];
    inputVerifyCodeLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
    
    self.verify_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.verifyCode_text.frame.origin.x + self.verifyCode_text.frame.size.width + 47,verify_lb.frame.origin.y + verify_lb.frame.size.height + 24, 108, 30)];
    UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB37C)];
    [self.verify_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [self.verify_btn addTarget:self action:@selector(checkVerify_btn) forControlEvents:UIControlEventTouchUpInside];
    self.verify_btn.layer.masksToBounds = YES;
    self.verify_btn.layer.cornerRadius =15;
    self.verify_btn.userInteractionEnabled = NO;
    [self.verify_btn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    [self.verify_btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.verify_btn.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    
    [self.view addSubview:self.verify_btn];
    [self.view addSubview:inputVerifyCodeLine];
    [self.view addSubview:self.verifyCode_text];
    [self.view addSubview:verify_lb];
    
    
    pass_lb = [[UILabel alloc] initWithFrame:CGRectMake(41,inputVerifyCodeLine.frame.origin.y+inputVerifyCodeLine.frame.size.height + 47,128,23)];
    pass_lb.textAlignment = NSTextAlignmentLeft;
    pass_lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    pass_lb.textColor = UIColorFromRGB(0x212121);
    pass_lb.text=@"密码设置";
    
    self.passWord_text=[[UITextField alloc]initWithFrame:CGRectMake(pass_lb.frame.origin.x,pass_lb.frame.origin.y + pass_lb.frame.size.height + 31, 132 + 40, 25)];
    self.passWord_text.delegate=self;
    self.passWord_text.returnKeyType = UIReturnKeyDone;
    NSString *holderPwsText=@"6~20位登录密码";
    NSMutableAttributedString *placeholderPws = [[NSMutableAttributedString alloc] initWithString:holderPwsText];
    [placeholderPws addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xCCCCCC)
                           range:NSMakeRange(0, holderPwsText.length)];
    [placeholderPws addAttribute:NSFontAttributeName
                           value:[UIFont  boldSystemFontOfSize:18]
                           range:NSMakeRange(0, holderPwsText.length)];
    self.passWord_text.attributedPlaceholder = placeholderPws;
    
    UIView * inputPhonePwsLine = [[UIView alloc]initWithFrame:CGRectMake(pass_lb.frame.origin.x,self.passWord_text.frame.origin.y+ self.passWord_text.frame.size.height+8,SCREEN_WIDTH - pass_lb.frame.origin.x *2,0.5)];
    inputPhonePwsLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
    
    [self.view addSubview:inputPhonePwsLine];
    [self.view addSubview:self.passWord_text];
    [self.view addSubview:pass_lb];
    
    
    pass_lbEd = [[UILabel alloc] initWithFrame:CGRectMake(41,inputPhonePwsLine.frame.origin.y+inputPhonePwsLine.frame.size.height + 47,128,23)];
    pass_lbEd.textAlignment = NSTextAlignmentLeft;
    pass_lbEd.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    pass_lbEd.textColor = UIColorFromRGB(0x212121);
    pass_lbEd.text=@"密码确认";
    
    self.passWordEd_text=[[UITextField alloc]initWithFrame:CGRectMake(pass_lbEd.frame.origin.x,pass_lbEd.frame.origin.y + pass_lbEd.frame.size.height + 31, 132 + 40, 25)];
    self.passWordEd_text.delegate=self;
    self.passWordEd_text.returnKeyType = UIReturnKeyDone;
    NSString *holderPwsEdText=@"再次输入登录密码";
    NSMutableAttributedString *placeholderPwsEd = [[NSMutableAttributedString alloc] initWithString:holderPwsEdText];
    [placeholderPwsEd addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xCCCCCC)
                           range:NSMakeRange(0, holderPwsEdText.length)];
    [placeholderPwsEd addAttribute:NSFontAttributeName
                           value:[UIFont  boldSystemFontOfSize:18]
                           range:NSMakeRange(0, holderPwsEdText.length)];
    self.passWordEd_text.attributedPlaceholder = placeholderPwsEd;
    
    UIView * inputPhonePwsEdLine = [[UIView alloc]initWithFrame:CGRectMake(pass_lbEd.frame.origin.x,self.passWordEd_text.frame.origin.y+ self.passWordEd_text.frame.size.height+8,SCREEN_WIDTH - pass_lbEd.frame.origin.x *2,0.5)];
    inputPhonePwsEdLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
    
    [self.view addSubview:inputPhonePwsEdLine];
    [self.view addSubview:self.passWordEd_text];
    [self.view addSubview:pass_lbEd];
    

    self.finish_btn = [[UIButton alloc] initWithFrame:CGRectMake(32,inputPhonePwsEdLine.frame.origin.y +inputPhonePwsEdLine.frame.size.height +36, SCREEN_WIDTH - 32*2, 44)];
    [self.finish_btn setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.finish_btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.finish_btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    //设置UIButton文字间距
    //实例化NSMutableAttributedString
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.finish_btn.titleLabel.text];
    //设置字间距
    long number = 3.f;
    //CFNumberRef添加字间距
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString1 addAttribute:NSKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
    //清除CFNumberRef
    CFRelease(num);
    //给lab赋值改变好的文字
    [self.finish_btn.titleLabel setAttributedText:attributedString1];
    
    UIImage *norImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
    [self.finish_btn setBackgroundImage:norImg forState:UIControlStateNormal];
    [self.finish_btn addTarget:self action:@selector(checkFinish_btn) forControlEvents:UIControlEventTouchUpInside];
    self.finish_btn.layer.masksToBounds = YES;
    self.finish_btn.layer.cornerRadius =22;
    [self.view addSubview:self.finish_btn];
    
    UIView *bomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.finish_btn.frame.origin.y+self.finish_btn.frame.size.height + 13, SCREEN_WIDTH, 20)];
    
    UILabel * tip_lb = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100 - 50,0,200,20)];
    tip_lb.textAlignment = NSTextAlignmentRight;
    tip_lb.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    tip_lb.textColor = UIColorFromRGB(0x909396);
    tip_lb.text=@"注册即表示您已阅读并同意";
    UIButton *resiger_btn = [[UIButton alloc] initWithFrame:CGRectMake(tip_lb.frame.origin.x + tip_lb.frame.size.width ,0,100,20)];
    [resiger_btn addTarget:self action:@selector(checkXieYiWeb) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"注册协议"];
    NSRange strRange = {0,[str length]};
    //设置下划线
    //[str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    //设置颜色
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF9323) range:strRange];
    [resiger_btn setAttributedTitle:str forState:UIControlStateNormal];
    resiger_btn.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    resiger_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [bomView addSubview:resiger_btn];
    [bomView addSubview:tip_lb];
    [self.view addSubview:bomView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.verifyCode_text becomeFirstResponder];
    });
    
    //进入注册Vc开始模拟倒计时
    [self verify_Code];
}

-(void)verify_Code
{
    secondsCountDown = 60;//60秒倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Resetcaptcha) userInfo:nil repeats:YES];
    //发送按钮 进入倒计时状态
    [self.verify_btn setUserInteractionEnabled:NO];
    UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB37C)];
    [self.verify_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    
    [self.finish_btn setUserInteractionEnabled:NO];
    UIImage *finishImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
    [self.finish_btn setBackgroundImage:finishImg forState:UIControlStateNormal];
}

-(void)navigationBarItem
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:[self addItemWithImage:@"back arrow_black@2x" imageInset:UIEdgeInsetsMake(0,-5,0,10) size:CGSizeMake(30, 24) action:@selector(handleBackButtonPressed)]];
    self.navigationItem.leftBarButtonItems = @[leftBarButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton addTarget:self action:@selector(rightButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"去登陆"];
    NSRange strRange = {0,[str length]};
    //设置下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    //设置颜色
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF9323) range:strRange];
    [rightButton setAttributedTitle:str forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    //rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightButton sizeToFit];
    
    UIBarButtonItem *leftItemBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItems = @[leftItemBtn];
    
}
-(void)handleBackButtonPressed
{
    if ([self.indenfiter isEqualToString:@"yes"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)rightButtonItem:(id)sender
{
    NSLog(@"去登陆");
    //UIStoryboard *storyboard = self.storyboard;
    //XYTZJuPhoneNum *identity = [storyboard instantiateViewControllerWithIdentifier:@"XYTZJuPhoneNum"];
    //[self presentViewController:identity animated:YES completion:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == self.passWord_text) {
//        textField.returnKeyType =UIReturnKeyDone;
//    }
//    else
//        textField.returnKeyType = UIReturnKeyNext;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  
    if (textField == self.verifyCode_text) {
        if(range.location>=4)
        {
            return NO;
        }
    }
    
    if (textField == self.passWord_text || textField == self.passWordEd_text) {
        if(range.location>=20)
        {
            return NO;
        }
    }
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.verifyCode_text text].length >=4 && [self.passWord_text text].length >= 6 &&[self.passWordEd_text text].length >=6) {
                
                //FFB86E 默认色  #FF9323 弹起色
                [self.finish_btn setUserInteractionEnabled:YES];
                UIImage *finishImg=[UIColor imageWithColor:UIColorFromRGB(0xFF9323)];
                [self.finish_btn setBackgroundImage:finishImg forState:UIControlStateNormal];
            }
            else
            {
                [self.finish_btn setUserInteractionEnabled:NO];
                UIImage *finishImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
                [self.finish_btn setBackgroundImage:finishImg forState:UIControlStateNormal];
            }
        });
    
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField
{
    //复原
    self.finish_btn.userInteractionEnabled = NO;
    UIImage *finishImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
    [self.finish_btn setBackgroundImage:finishImg forState:UIControlStateNormal];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == self.verifyCode_text||textField == self.passWord_text ||textField == self.passWordEd_text){
        //[textFielding becomeFirstResponder];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }else{
        flag = YES;
    }
    return flag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkFinish_btn
{
    //确认2次输入密码是否一致
    if ([[self.passWord_text text] isEqualToString:[self.passWordEd_text text]]) {
        [self uploadData];
    }
    else
    {
        PopAlterView *popView = [PopAlterView popViewWithTipStr:@"两次密码输入不一致"];
        [popView showInView:[UIApplication sharedApplication].keyWindow];
    }
}

-(void) uploadData
{
    //FFB86E 默认色  #FF9323 弹起色
    [self.finish_btn setUserInteractionEnabled:NO];
    UIImage *finishImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
    [self.finish_btn setBackgroundImage:finishImg forState:UIControlStateNormal];
    
    [SVProgressHUD showWithStatus:@"注册中...." maskType:SVProgressHUDMaskTypeBlack];
    //NSString *idfa = [[NSUserDefaults standardUserDefaults] objectForKey:@"idfa"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDic objectForKey:@"CFBundleVersion"];

    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:self.phoneNum forKey:@"phone"];
    [post setObject:[self.passWord_text text] forKey:@"password"];
    [post setObject:[self.verifyCode_text text] forKey:@"phoneCode"];
    [post setObject:version forKey:@"version"];
    [post setObject:@"23" forKey:@"systemType"];//苹果23
    //公共参数
    [post setObject:@"newRegister" forKey:@"service"];
    [post setObject:APP_ID forKey:@"appId"];
    [post setObject:SIGN_TYPE forKey:@"signType"];
    //md5加密
    NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
    [post setObject:paramsStr forKey:@"sign"];
    LLog(@"POST = %@",post);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:QZW_NEWREGISTER_URL parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"JSON: %@", responseObject);
        NSInteger resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
        if (resultCode == 1) {
            //save outhtoken!
            [XYTZGeneral saveUserInfo:responseObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:nil];
            [ParamManager.param setValue:[[responseObject objectForKey:@"resultData"] objectForKey:@"redPacketOpen"]forKey:@"redPacketOpen"];
            [ParamManager.param setValue:[[responseObject objectForKey:@"resultData"] objectForKey:@"redPacketAmount"]forKey:@"redPacketAmount"];
            [ParamManager.param setValue:[[responseObject objectForKey:@"resultData"] objectForKey:@"redPacketType"]forKey:@"redPacketType"];
            //设置手势密码
            [ParamManager.param setObject:@"comefromRegistration" forKey:@"comefromRegistration"];
            UIStoryboard *storyboard = self.storyboard;
            ChangeGustureLockViewController *identity = [storyboard instantiateViewControllerWithIdentifier:@"ChangeGustureLockViewController"];
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:identity animated:YES];
        }
        else
        {
            //[General refreshToken:responseObject viewController:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //0.4秒后异步执行
                NSLog(@"我已经等待了0.4秒！");
                //不需要更新Token的请求下使用
                [XYTZGeneral networkdataRequest:responseObject];
                [self.finish_btn setUserInteractionEnabled:YES];
                UIImage *finishImg=[UIColor imageWithColor:UIColorFromRGB(0xFF9323)];
                [self.finish_btn setBackgroundImage:finishImg forState:UIControlStateNormal];
            });
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [XYTZGeneral errorCode];
        [self.finish_btn setUserInteractionEnabled:YES];
        UIImage *finishImg=[UIColor imageWithColor:UIColorFromRGB(0xFF9323)];
        [self.finish_btn setBackgroundImage:finishImg forState:UIControlStateNormal];
    }];

}


- (void)checkVerify_btn
{
    [self sendCaptcha];
}

-(void)sendCaptcha
{
    secondsCountDown = 60;//60秒倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Resetcaptcha) userInfo:nil repeats:YES];
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:self.phoneNum forKey:@"phone"];
    [post setObject:@"regPhoneCode" forKey:@"service"];
    [post setObject:APP_ID forKey:@"appId"];
    [post setObject:SIGN_TYPE forKey:@"signType"];
    NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
    [post setObject:paramsStr forKey:@"sign"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:QZW_REGPHONECODE_URL parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LLog(@"JSON: %@", responseObject);
        NSInteger resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
        if (resultCode == 1) {
            //[SVProgressHUD showSuccessWithStatus:@"发送成功"];
            PopAlterView *popView = [PopAlterView popViewWithTipStr:@"验证码已发送"];
            [popView showInView:[UIApplication sharedApplication].keyWindow];
            
            //发送按钮 进入倒计时状态
            [self.verify_btn setUserInteractionEnabled:NO];
            UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB37C)];
            [self.verify_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
        }
        else
        {
            [XYTZGeneral refreshToken:responseObject viewController:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LLog(@"Error: %@", error);
        [XYTZGeneral errorCode];
    }];
}

-(void)Resetcaptcha
{
    secondsCountDown--;
    UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB37C)];
    [self.verify_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [self.verify_btn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)secondsCountDown] forState:UIControlStateNormal];
    if(secondsCountDown <= 0){
        [countDownTimer invalidate];
        [self.verify_btn setUserInteractionEnabled:YES];
        //[self.finish_btn setUserInteractionEnabled:YES];
        [self.verify_btn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        self.verify_btn.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFF9323)];
        [self.verify_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    }

}

-(void)checkXieYiWeb
{
    NSLog(@"注册协议...");
    XYTZRegistrXYViewController *resigerVc=[XYTZRegistrXYViewController alloc];
    [self.navigationController pushViewController:resigerVc animated:YES];
}

- (void)dealloc
{
    [self clearNotificationAndGesture];
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

@end
