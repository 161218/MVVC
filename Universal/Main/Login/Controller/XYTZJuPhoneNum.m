//
//  XYTZJuPhoneNum.m
//  祥益金服
//
//  Created by Liang Shen on 14/11/20.
//  Copyright (c) 2014年 com.erongdu.QZW. All rights reserved.
//

//根据 手机号判断 是否已注册
#import "XYTZJuPhoneNum.h"
#import "XYTZRegistr.h"
#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "ChangeGustureLockViewController.h"

#import "HomeViewController.h"
#import "WoDeViewController.h"
#define PHONE_BG_VIEW_HEIGHT 45 //手机号码 显示高度

@interface XYTZJuPhoneNum ()<UITextFieldDelegate>
{
    UILabel *phoneNum_lb;
    UILabel *phonePws_lb;
    UIButton *next_btn;
}

@property (strong, nonatomic)UITextField *inputPhoneNum_text;
@property (strong, nonatomic)UITextField *inputPhonePws_text;

@end

@implementation XYTZJuPhoneNum

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"登录";
    UINavigationBar * bar = self.navigationController.navigationBar;
    bar.backgroundColor = UIColorFromRGB(0xffffff);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
       NSForegroundColorAttributeName:UIColorFromRGB(0x212121)}];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self navigationBarItem];
    
    // 从收拾密码 进入 忘记密码 和切换用户
    self.identifyStr = [ParamManager.param objectForKey:@"identifyStr"];
    [ParamManager.param setObject:@"" forKey:@"identifyStr"];
    // *********  end  ************
    
    [self createPhoneBgView];
    
    [self.inputPhoneNum_text becomeFirstResponder];
    
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航底部黑色线条
    //self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

-(void)createPhoneBgView
{
    
    phoneNum_lb = [[UILabel alloc] initWithFrame:CGRectMake(41,145,128,23)];
    phoneNum_lb.textAlignment = NSTextAlignmentLeft;
    phoneNum_lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    phoneNum_lb.textColor = UIColorFromRGB(0x212121);
    phoneNum_lb.text=@"手机号码";
    
    self.inputPhoneNum_text=[[UITextField alloc]initWithFrame:CGRectMake(phoneNum_lb.frame.origin.x,phoneNum_lb.frame.origin.y + phoneNum_lb.frame.size.height + 31, 126, 25)];
    self.inputPhoneNum_text.delegate=self;
    self.inputPhoneNum_text.returnKeyType = UIReturnKeyDone;
    
    NSString *holderText=@"请输入手机号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xCCCCCC)
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont  boldSystemFontOfSize:18]
                        range:NSMakeRange(0, holderText.length)];
    self.inputPhoneNum_text.attributedPlaceholder = placeholder;
    
    
    UIView * inputPhoneNumLine = [[UIView alloc]initWithFrame:CGRectMake(phoneNum_lb.frame.origin.x,self.inputPhoneNum_text.frame.origin.y+ self.inputPhoneNum_text.frame.size.height+8,SCREEN_WIDTH - phoneNum_lb.frame.origin.x *2,0.5)];
    inputPhoneNumLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
    
    [self.view addSubview:inputPhoneNumLine];
    [self.view addSubview:self.inputPhoneNum_text];
    [self.view addSubview:phoneNum_lb];
    
    phonePws_lb = [[UILabel alloc] initWithFrame:CGRectMake(41,inputPhoneNumLine.frame.origin.y+inputPhoneNumLine.frame.size.height + 52,128,23)];
    phonePws_lb.textAlignment = NSTextAlignmentLeft;
    phonePws_lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    phonePws_lb.textColor = UIColorFromRGB(0x212121);
    phonePws_lb.text=@"密码";
    
    self.inputPhonePws_text=[[UITextField alloc]initWithFrame:CGRectMake(phonePws_lb.frame.origin.x,phonePws_lb.frame.origin.y + phonePws_lb.frame.size.height + 31, 132 + 40, 25)];
    self.inputPhonePws_text.delegate=self;
    self.inputPhonePws_text.returnKeyType = UIReturnKeyDone;
    NSString *holderPwsText=@"6~20位登录密码";
    NSMutableAttributedString *placeholderPws = [[NSMutableAttributedString alloc] initWithString:holderPwsText];
    [placeholderPws addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xCCCCCC)
                        range:NSMakeRange(0, holderPwsText.length)];
    [placeholderPws addAttribute:NSFontAttributeName
                        value:[UIFont  boldSystemFontOfSize:18]
                        range:NSMakeRange(0, holderPwsText.length)];
    self.inputPhonePws_text.attributedPlaceholder = placeholderPws;
    
    
    UIView * inputPhonePwsLine = [[UIView alloc]initWithFrame:CGRectMake(phonePws_lb.frame.origin.x,self.inputPhonePws_text.frame.origin.y+ self.inputPhonePws_text.frame.size.height+8,SCREEN_WIDTH - phonePws_lb.frame.origin.x *2,0.5)];
    inputPhonePwsLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
    
    [self.view addSubview:inputPhonePwsLine];
    [self.view addSubview:self.inputPhonePws_text];
    [self.view addSubview:phonePws_lb];
    
    UIButton *getPwsBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH  - 100 - 32, inputPhonePwsLine.frame.origin.y + inputPhonePwsLine.frame.size.height + 8, 100, 20)];
    [getPwsBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [getPwsBtn setTitleColor:UIColorFromRGB(0x515151) forState:UIControlStateNormal];
    getPwsBtn.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Bold" size:14];
    [getPwsBtn addTarget:self action:@selector(checkPwsExist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getPwsBtn];
    
    next_btn = [[UIButton alloc] initWithFrame:CGRectMake(32,getPwsBtn.frame.origin.y + getPwsBtn.frame.size.height + 42, self.view.frame.size.width - 32*2, 44)];
    [next_btn setTitle:@"立即登录" forState:UIControlStateNormal];
    [next_btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    next_btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    //设置UIButton文字间距
    //实例化NSMutableAttributedString
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:next_btn.titleLabel.text];
    //设置字间距
    long number = 3.f;
    //CFNumberRef添加字间距
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString1 addAttribute:NSKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
    //清除CFNumberRef
    CFRelease(num);
    //给lab赋值改变好的文字
    [next_btn.titleLabel setAttributedText:attributedString1];
    
    UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
    [next_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [next_btn addTarget:self action:@selector(checkPhoneExist) forControlEvents:UIControlEventTouchUpInside];
    next_btn.layer.masksToBounds = YES;
    next_btn.layer.cornerRadius =22;
    next_btn.userInteractionEnabled = NO;
    [self.view addSubview:next_btn];
    
    UIView *bomView=[[UIView alloc]initWithFrame:CGRectMake(0, next_btn.frame.origin.y+next_btn.frame.size.height + 13, SCREEN_WIDTH, 20)];
    
    UILabel * tip_lb = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100,0,100,20)];
    tip_lb.textAlignment = NSTextAlignmentRight;
    tip_lb.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    tip_lb.textColor = UIColorFromRGB(0x909396);
    tip_lb.text=@"还没有账号？";
    
    UIButton *resiger_btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,0,100,20)];
    [resiger_btn addTarget:self action:@selector(checkResiger) forControlEvents:UIControlEventTouchUpInside];
    //[resiger_btn setTitleColor:kColorFromRGB(0xFA6900) forState:UIControlStateNormal];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"免费注册"];
    NSRange strRange = {0,[str length]};
    //设置下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    //设置颜色
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF9323) range:strRange];
    
    [resiger_btn setAttributedTitle:str forState:UIControlStateNormal];
    
    
    resiger_btn.titleLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    resiger_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [bomView addSubview:resiger_btn];
    [bomView addSubview:tip_lb];
    [self.view addSubview:bomView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == self.inputPhoneNum_text || textField == self.inputPhonePws_text){
        //[textFielding becomeFirstResponder];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }else{
        flag = YES;
    }
    return flag;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.inputPhoneNum_text || textField == self.inputPhonePws_text) {
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int  remainTextNum_= 11;//?
    
    
    if (textField == self.inputPhoneNum_text) {
        //计算剩下多少文字可以输入
        if(range.location>=11)
        {
            remainTextNum_ = 0;
            return NO;
        }
    }
    else
    {
        //计算剩下多少文字可以输入
        if(range.location >=20)
        {
            remainTextNum_ = 0;
            return NO;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (self.inputPhoneNum_text.text.length >=11 && self.inputPhonePws_text.text.length >=6)
        {
            UIImage *seletcImg=[UIColor imageWithColor:UIColorFromRGB(0xFF9323)];
            [next_btn setBackgroundImage:seletcImg forState:UIControlStateNormal];
            next_btn.userInteractionEnabled = YES;
        }
        else
        {
            UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
            [next_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
            next_btn.userInteractionEnabled = NO;
        }
        
    });
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField
{
    UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB37C)];
    [next_btn setBackgroundImage:normalImg forState:UIControlStateNormal ];
    next_btn.userInteractionEnabled = NO;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkPwsExist
{
    NSLog(@"忘记密码...");
}

-(void)checkResiger
{
    NSLog(@"免费注册...");
    XYTZRegistr *regiStrVc=[[XYTZRegistr alloc]init];
    
    [self.navigationController pushViewController:regiStrVc animated:YES];
}


- (void)checkPhoneExist
{
    [self.inputPhoneNum_text resignFirstResponder];
    [self.inputPhonePws_text resignFirstResponder];
    
    
    UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB86E)];
    [next_btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    next_btn.userInteractionEnabled = NO;
    
    [SVProgressHUD showWithStatus:@"登录中...." maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:self.inputPhoneNum_text.text forKey:@"userName"];
    [post setObject:self.inputPhonePws_text.text forKey:@"password"];
    
    [post setObject:@"login" forKey:@"service"];
    [post setObject:APP_ID forKey:@"appId"];
    [post setObject:SIGN_TYPE forKey:@"signType"];
    
    NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
    LLog(@"md5 = %@",paramsStr);
    [post setObject:paramsStr forKey:@"sign"];
    LLog(@"post = %@",post);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // manager.requestSerializer.timeoutInterval = 10;
    [manager POST:QZW_LOGIN_URL parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"-------------登录接口: %@", responseObject);
        NSInteger resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
        if (resultCode == 1) {
            //save token!
            [XYTZGeneral saveUserInfo:responseObject];
            //初始化错误次数
            [XYTZGeneral initErrorNums];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMyQianZhuangData" object:nil];
            
            //首页活动子页面登录成功通知重新加载web
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BANERRESHERNOTICE" object:nil];
            
            //调用一下获取用户信息
            [XYTZGeneral saveData:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadSystemMsgTag" object:nil ];
            [ParamManager.param setObject:@"comeformLogin" forKey:@"comefromRegistration"];
            
//            UIStoryboard *storyboard = self.storyboard;
//            ChangeGustureLockViewController *identity = [storyboard instantiateViewControllerWithIdentifier:@"ChangeGustureLockViewController"];
//            [self presentViewController:identity animated:YES completion:nil];
            
            [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeGustureLockViewController"] animated:YES completion:nil];
        }
        else
        {
            //这里错误后台返回不一样 要特殊处理
            NSString *errormasg=[[responseObject objectForKey:@"resultData"] objectForKey:@"errorMsg"];
            //[SVProgressHUD showErrorWithStatus:errormasg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //0.4秒后异步执行
                NSLog(@"我已经等待了0.4秒！");
                PopAlterView *popView = [PopAlterView popViewWithTipStr:errormasg];
                [popView showInView:[UIApplication sharedApplication].keyWindow];
                
                UIImage *seletcImg=[UIColor imageWithColor:UIColorFromRGB(0xFF9323)];
                [next_btn setBackgroundImage:seletcImg forState:UIControlStateNormal];
                next_btn.userInteractionEnabled = YES;
            });
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [XYTZGeneral errorCode];
        UIImage *seletcImg=[UIColor imageWithColor:UIColorFromRGB(0xFF9323)];
        [next_btn setBackgroundImage:seletcImg forState:UIControlStateNormal];
        next_btn.userInteractionEnabled = YES;
    }];
    
}

-(void)navigationBarItem
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Withdrawaltopup_bg1_img"] forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:[self addItemWithImage:@"back arrow_black@2x" imageInset:UIEdgeInsetsMake(0,-5,0,10) size:CGSizeMake(30, 24) action:@selector(handleBackButtonPressed:)]];
    self.navigationItem.leftBarButtonItems = @[leftBarButton];
}

- (void)handleBackButtonPressed:(id)sender
{
    [self.inputPhoneNum_text resignFirstResponder];
    //返回至首页
    if ([self.identifyStr isEqualToString:@"shoushimima"])
    {
        [XYTZGeneral reoveUserinfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"neWlogin" object:nil];

        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
