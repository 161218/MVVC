//
//  XYTZRegistr.m
//  祥益金服
//
//  Created by Liang Shen on 14-7-4.
//  Copyright (c) 2014年 com.erongdu.QZW. All rights reserved.
//

#import "XYTZRegistr.h"
#import "SVProgressHUD.h"
#import "XYTZJuPhoneNum.h"
#import "ChangeGustureLockViewController.h"
#import "XYTZRegistrXYViewController.h"
#import "XYTZRegistrFinishView.h"

//#import "XYTZSetPhoneValidate.h"
//#import "XYTZRealNameFPW.h"

@interface XYTZRegistr ()
{
    UILabel *phoneNum_lb;
    UIButton *next_btn;
}
@property (strong, nonatomic)UITextField *inputPhoneNum_text;
@end

@implementation XYTZRegistr

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
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    CustomNavBar;
    self.identifyStr = [ParamManager.param objectForKey:@"identifyStr"];
    [ParamManager.param setObject:@"" forKey:@"identifyStr"];
    
    self.title=@"注册";
    UINavigationBar * bar = self.navigationController.navigationBar;
    bar.backgroundColor = UIColorFromRGB(0xffffff);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
       NSForegroundColorAttributeName:UIColorFromRGB(0x212121)}];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self navigationBarItem];
    
    [self createPhoneBgView];
    
    [self.inputPhoneNum_text becomeFirstResponder];
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
    
    next_btn = [[UIButton alloc] initWithFrame:CGRectMake(32,inputPhoneNumLine.frame.origin.y + inputPhoneNumLine.frame.size.height + 60, self.view.frame.size.width - 32*2, 44)];
    [next_btn setTitle:@"下一步" forState:UIControlStateNormal];
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
    [next_btn addTarget:self action:@selector(checkNextExist) forControlEvents:UIControlEventTouchUpInside];
    next_btn.layer.masksToBounds = YES;
    next_btn.layer.cornerRadius =22;
    next_btn.userInteractionEnabled = NO;
    [self.view addSubview:next_btn];
    
    UIView *bomView=[[UIView alloc]initWithFrame:CGRectMake(0, next_btn.frame.origin.y+next_btn.frame.size.height + 13, SCREEN_WIDTH, 20)];
    
    UILabel * tip_lb = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100 - 50,0,200,20)];
    tip_lb.textAlignment = NSTextAlignmentRight;
    tip_lb.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    tip_lb.textColor = UIColorFromRGB(0x909396);
    tip_lb.text=@"注册即表示您已阅读并同意";
    
    //tip_lb.attributedText=[General setColorizedFontWithOneString:@"注册即表示您已阅读并同意" oneColor:kColorFromRGB(0x909396) oneFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:13] twoString:@"注册协议" twoColor:kColorFromRGB(0xfcaf00) twoFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:13] threeString:@"" threeColor:kColorFromRGB(0xFA6900) threeFont:[UIFont systemFontOfSize:0]];
    
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == self.inputPhoneNum_text){
        //[textFielding becomeFirstResponder];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }else{
        flag = YES;
    }
    return flag;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.inputPhoneNum_text) {
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.inputPhoneNum_text.text.length >=11)
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
    //复原
    UIImage *normalImg=[UIColor imageWithColor:UIColorFromRGB(0xFFB37C)];
    [next_btn setBackgroundImage:normalImg forState:UIControlStateNormal ];
    next_btn.userInteractionEnabled = NO;
    return YES;
}

-(void)checkNextExist
{
    NSLog(@"下一步...");
    [self.inputPhoneNum_text resignFirstResponder];
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:[self.inputPhoneNum_text text] forKey:@"phone"];
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
           
            XYTZRegistrFinishView *identity =[[XYTZRegistrFinishView alloc]init];
            identity.phoneNum = [self.inputPhoneNum_text text];
            [self.navigationController pushViewController:identity animated:YES];
        }
        else
        {
            [XYTZGeneral refreshToken:responseObject viewController:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LLog(@"Error: %@", error);
        [XYTZGeneral errorCode];
    }];
    
    
    
    //在注册界面验证是否注册过
//    [SVProgressHUD showWithStatus:@"手机号码检测中" maskType:SVProgressHUDMaskTypeBlack];
//    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
//    [post setObject:[self.inputPhoneNum_text text]forKey:@"userName"];
//
//    [post setObject:@"phoneCheck" forKey:@"service"];
//    [post setObject:APP_ID forKey:@"appId"];
//    [post setObject:SIGN_TYPE forKey:@"signType"];
//
//    NSString *paramsStr = [General paramsToMD5:post];
//    [post setObject:paramsStr forKey:@"sign"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:QZW_PHONECHECK_URL parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [SVProgressHUD dismiss];
//        DDLog(@"JSON: %@", responseObject);
//        NSInteger resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
//        if (resultCode == 1) {
//            //int phoneExist = [[[responseObject objectForKey:@"resultData"] objectForKey:@"phoneExist"] intValue];
////            if (phoneExist == 1){
////            }else{
////            }
//        }
//        else
//        {
//            [General refreshToken:responseObject viewController:self];
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [General errorCode];
//    }];
}

-(void)checkXieYiWeb
{
    NSLog(@"注册协议...");
    XYTZRegistrXYViewController *resigerVc=[XYTZRegistrXYViewController alloc];
    [self.navigationController pushViewController:resigerVc animated:YES];
}


-(void)navigationBarItem
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:[self addItemWithImage:@"back arrow_black@2x" imageInset:UIEdgeInsetsMake(0,-5,0,10) size:CGSizeMake(30, 24) action:@selector(handleBackButtonPressed:)]];
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
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"moreHideTabBar" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightButtonItem:(id)sender
{
    NSLog(@"去登陆");
    //UIStoryboard *storyboard = self.storyboard;
    //XYTZJuPhoneNum *identity = [storyboard instantiateViewControllerWithIdentifier:@"XYTZJuPhoneNum"];
    //[self presentViewController:identity animated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)forgetPwd_btn:(id)sender {
    if ([self.cardExist intValue] != 1) {
        //未实名认证过
//        UIStoryboard *storyboard = self.storyboard;
//        XYTZSetPhoneValidate *identity = [storyboard instantiateViewControllerWithIdentifier:@"comeformtrandepwd"];
//        //identity.temStr = self.phoneNum;
//        identity.identifierStr =@"忘记密码";
//        [self.navigationController pushViewController:identity animated:YES];
    }
    else
    {
        //实名认证过
//        UIStoryboard *storyboard = self.storyboard;
//        XYTZRealNameFPW *identity = [storyboard instantiateViewControllerWithIdentifier:@"XYTZRealNameFPW"];
//        //identity.temStr = self.phoneNum;
////        identity.identifierStr =@"忘记密码";
//        [self.navigationController pushViewController:identity animated:YES];
    }
}
@end
