//
//  LoginGuestureViewController.m
//  祥益金服
//
//  Created by zyh on 14-7-24.
//  Copyright (c) 2014年 com.erongdu.QZW. All rights reserved.
//

#import "LoginGuestureViewController.h"

@interface LoginGuestureViewController ()

@end

@implementation LoginGuestureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTaped)];
    [self.view addGestureRecognizer:tap];
    self.suer_btn.layer.cornerRadius = 4;
  
   
}
-(void)ViewTaped
{
    
    [self.loginPwd_text resignFirstResponder];
   
    //    [RecommendRegist_text resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [IQKeyBoardManager enableKeyboardManger];
}
- (IBAction)sureBtnClick:(id)sender
{
    [self.loginPwd_text resignFirstResponder];
    if ([self.loginPwd_text.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
    }
    else
    {

        NSMutableDictionary *post = [[NSMutableDictionary alloc] init];

        [post setObject:@"checkLoginPwd" forKey:@"service"];

        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        [post setObject:self.loginPwd_text.text forKey:@"loginPassword"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"oauthToken"];
        [post setObject:token forKey:@"oauthToken"];
        
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        LLog(@"md5 = %@",paramsStr);
        [post setObject:paramsStr forKey:@"sign"];
        LLog(@"post = %@",post);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:CHECKLOGINPWD parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
            LLog(@"JSON: %@", responseObject);
            NSInteger resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
            if (resultCode == 1) {
//                self.navigationController.navigationBarHidden= YES;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window.rootViewController presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeGustureLockViewController"]animated:YES completion:nil];
            }
            else
            {
//                [General refreshToken:[responseObject objectForKey:@"errorCode"]];
               
                [XYTZGeneral refreshToken:responseObject viewController:self];
//                NSString *msg = [[responseObject objectForKey:@"resultData"] objectForKey:@"errorMsg"];
//                [SVProgressHUD showErrorWithStatus:msg];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            LLog(@"Error: %@", error);
             [XYTZGeneral errorCode];
        }];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
