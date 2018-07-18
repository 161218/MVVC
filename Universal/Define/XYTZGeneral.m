//
//  XYTZGeneral.m
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "XYTZGeneral.h"

@implementation XYTZGeneral

//不需要更新Token的请求下使用 错误返回信息
+(void)networkdataRequest:(NSDictionary *)dict
{
    NSString* errorCode= [dict objectForKey:@"errorCode"];
    //显示错误信息
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ErrorExplain" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    LLog(@"%@", [data objectForKey:errorCode]);
    if ([XYTZGeneral isBlankString:[data objectForKey:errorCode]])
    {
        if ([XYTZGeneral isBlankString:[dict objectForKey:@"resultMsg"]])
        {
            //[SVProgressHUD showErrorWithStatus:@"系统出现异常"];
            PopAlterView *popView = [PopAlterView popViewWithTipStr:@"系统出现异常"];
            [popView showInView:[UIApplication sharedApplication].keyWindow];
        }
        else
        {
            //[SVProgressHUD showErrorWithStatus:[dict objectForKey:@"resultMsg"] duration:1];
            PopAlterView *popView = [PopAlterView popViewWithTipStr:[dict objectForKey:@"resultMsg"]];
            [popView showInView:[UIApplication sharedApplication].keyWindow];
        }
        
    }
    else
    {
        //[SVProgressHUD showErrorWithStatus:[data objectForKey:errorCode] duration:1];
        PopAlterView *popView = [PopAlterView popViewWithTipStr:[data objectForKey:errorCode]];
        [popView showInView:[UIApplication sharedApplication].keyWindow];
    }
}

+(NSMutableAttributedString*)setColorizedFontWithOneString:(NSString*)oneStr
                                                  oneColor:(UIColor*)oneColor
                                                   oneFont:(UIFont*)oneFont
                                                 twoString:(NSString*)twoStr
                                                  twoColor:(UIColor*)twoColor
                                                   twoFont:(UIFont*)twoFont
                                               threeString:(NSString*)threeStr
                                                threeColor:(UIColor*)threeColor
                                                 threeFont:(UIFont*)threeFont
{
    //一个label中不同颜色和字体
    NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",oneStr, twoStr ,threeStr]];
    //设置颜色  NSForegroundColorAttributeName
    [str addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, [oneStr length])];
    [str addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange([oneStr length], [twoStr length])];
    [str addAttribute:NSForegroundColorAttributeName value:threeColor range:NSMakeRange([oneStr length]+[twoStr length], [threeStr length])];
    //设置字体  NSFontAttributeName
    [str addAttribute:NSFontAttributeName value:oneFont range:NSMakeRange(0, [oneStr length])];
    [str addAttribute:NSFontAttributeName value:twoFont range:NSMakeRange([oneStr length], [twoStr length])];
    [str addAttribute:NSFontAttributeName value:threeFont range:NSMakeRange([oneStr length]+[twoStr length], [threeStr length])];
    
    return str;
}

+(NSMutableDictionary*)webURlString:(NSString*)url
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    NSArray* array = [url componentsSeparatedByString:@"&"];
    
    for (int i = 0; i<[array count]; i++)
    {
        NSString* tempStr = [array objectAtIndex:i];
        NSString* titleStr= [[tempStr componentsSeparatedByString:@"="] objectAtIndex:0];
        
        NSString* str = [XYTZGeneral URLDecodedString:[[tempStr componentsSeparatedByString:@"="] objectAtIndex:1]];
        
        if ([titleStr isEqualToString:@"title"])
        {
            [dic setObject:str forKey:@"title"];
        }
        else if ([titleStr isEqualToString:@"url"])
        {
            [dic setObject:str forKey:@"url"];
        }
    }
    return dic;
}

+(NSString*)URLDecodedString:(NSString*)codeURL
{
    NSMutableString *outputStr = [NSMutableString stringWithString:codeURL];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,
                                                      [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(NSString*)getwebURL:(NSURLRequest*)request :(UIViewController*)vc
{
    NSURL *requestURL = [ request URL];
    NSLog(@"__________requestURLy___________%@",requestURL);
    
    if ( [[ requestURL scheme ] isEqualToString:@"qian"])
    {
        NSString *indefinderurlstr = [[[[[requestURL absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0] componentsSeparatedByString:@"://"] objectAtIndex:1];
        //根据一些参数来判断，如果是分享，就直接调用分享
        if ([indefinderurlstr isEqualToString:@"getShare"])
        {
            //调用分享
            NSString* strUrl = [[[requestURL absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:1];
            //调用分享
            //[General shareUrl:vc :strUrl];
            return nil;
        }
        else
        {
            return indefinderurlstr;
        }
    }
    return nil;
}

//判断是否包含
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

+(void)realNamePayPwdFlag:(UIViewController*)VC :(NSString*)indefinder
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //设置实名认证
    int realStatus = [[defaults objectForKey:@"realStatus"] intValue];
    
    if (realStatus == 0)
    {
        //请先实名认证
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        PhoneIdentityVerification *identity = [storyboard instantiateViewControllerWithIdentifier:@"comeformphonebingding"];
        //        identity.indefinder =  indefinder;
        //
        //        [VC.navigationController pushViewController:identity animated:YES];
        [SVProgressHUD showErrorWithStatus:@"请先去实名认证"];
        return;
    }
    
    //设置交易密码
    NSString* payPwdFlag = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"payPwdFlag"]];
    if ([payPwdFlag isEqualToString:@"0"])
    {
        //交易密码
        //        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        XYTZFPWViewController *findmodifyPwd = [storyboard instantiateViewControllerWithIdentifier:@"XYTZFPWViewController"];
        //
        //        findmodifyPwd.indefinder= indefinder;
        //        [VC.navigationController pushViewController:findmodifyPwd animated:YES];
        return;
    }
}

+ (NSString *) paramsToMD5 :(NSMutableDictionary *)post
{
    NSArray *array = [[post allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //按照参数排序后的顺序,将其对应的value,进⾏行字符串拼接
    NSMutableString *signStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [array count]; i++) {
        
        NSString *key = [array objectAtIndex:i]; //从排序好的参数数组中,取得key
        
        NSString *value = [post valueForKey:key]; //从做好的参数字典中,通过key,取得对应的value
        //[signStr insertString:value atIndex:signStr.length]; //将取出的value,加到字符串⾥里⾯面
        [signStr appendString:key];
        [signStr appendString:@"="];
        [signStr appendString:value];
        if (i != [array count]-1) {
            [signStr appendString:@"&"];
        }
    }
    [signStr appendString:APP_KEY];
    //[signStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return  [signStr md5Encrypt];
}

+(void)saveData:(UIViewController*)viewController
{
    NSString *oauthToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"];
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    [post setObject:oauthToken forKey:@"oauthToken"];
    [post setObject:@"getUserInfoStatus" forKey:@"service"];
    
    [post setObject:APP_ID forKey:@"appId"];
    [post setObject:SIGN_TYPE forKey:@"signType"];
    NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
    [post setObject:paramsStr forKey:@"sign"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:QZW_GETUSERINFOSTATUS_URL parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
        if (resultCode == 1)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"realNameStatus"] forKey:@"realStatus"];//实名认证
            [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"payPwdStatus"] forKey:@"payPwdFlag"];//交易密码
            [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"needPopStatus"] forKey:@"needPopStatus"];
            [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"newHandStatus"] forKey:@"newHandStatus"];
            [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"bankCardStatus"] forKey:@"bankCardStatus"];
            
        }
        else
        {
            [XYTZGeneral refreshToken:responseObject viewController:viewController];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [XYTZGeneral errorCode];
    }];
    
}

+ (void) refreshToken:(NSDictionary *)dict viewController:(UIViewController*)viewController
{
    
    NSString* errorCode= [dict objectForKey:@"errorCode"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *refreshToken = [defaults objectForKey:@"refreshToken"];
    if ([errorCode isEqualToString:@"TOKEN_NOT_EXIST"] || [errorCode isEqualToString:@"TOKEN_EXPIRED"]) {
        NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
        [post setObject:refreshToken forKey:@"refreshToken"];
        [post setObject:@"refreshToken" forKey:@"service"];
        [post setObject:APP_ID forKey:@"appId"];
        [post setObject:SIGN_TYPE forKey:@"signType"];
        
        NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
        NSLog(@"md5 = %@",paramsStr);
        [post setObject:paramsStr forKey:@"sign"];
        NSLog(@"post = %@",post);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        // manager.requestSerializer.timeoutInterval = 10;
        [manager POST:QZW_REFRESHTOKEN_URL parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSInteger resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
            if (resultCode == 1)
            {
                //save token!
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"oauthToken"] forKey:@"oauthToken"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"useMoney"] forKey:@"useMoney"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"realStatus"] forKey:@"realStatus"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"phoneStatus"] forKey:@"phoneStatus"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"emailStatus"] forKey:@"emailStatus"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"payPwdFlag"] forKey:@"payPwdFlag"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"refreshToken"] forKey:@"refreshToken"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"userId"] forKey:@"userId"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"bankStatus"] forKey:@"bankStatus"];
                [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"share"] forKey:@"share"];
                [defaults synchronize];
                
            }
            else
            {
                [viewController.navigationController popToRootViewControllerAnimated:YES];
                viewController.navigationController.tabBarController.selectedIndex = 0;
                //设置定时器，多长时间调用这个方法
                
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //[SVProgressHUD showErrorWithStatus:@"网络请求失败"];
            PopAlterView *popView = [PopAlterView popViewWithTipStr:@"网络请求失败"];
            [popView showInView:[UIApplication sharedApplication].keyWindow];
        }];
        
    }
    else
    {
        //显示错误信息
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ErrorExplain" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSLog(@"%@", [data objectForKey:errorCode]);
        if ([XYTZGeneral isBlankString:[data objectForKey:errorCode]])
        {
            if ([XYTZGeneral isBlankString:[dict objectForKey:@"resultMsg"]])
            {
                //[SVProgressHUD showErrorWithStatus:@"系统出现异常"];
                PopAlterView *popView = [PopAlterView popViewWithTipStr:@"系统出现异常"];
                [popView showInView:[UIApplication sharedApplication].keyWindow];
            }
            else
            {
                //[SVProgressHUD showErrorWithStatus:[dict objectForKey:@"resultMsg"] duration:1];
                PopAlterView *popView = [PopAlterView popViewWithTipStr:[dict objectForKey:@"resultMsg"]];
                [popView showInView:[UIApplication sharedApplication].keyWindow];
            }
            
        }
        else
        {
            //[SVProgressHUD showErrorWithStatus:[data objectForKey:errorCode] duration:1];
            PopAlterView *popView = [PopAlterView popViewWithTipStr:[data objectForKey:errorCode]];
            [popView showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

+(void)timerFired
{
    //通知跳转到登陆页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCentreLogin" object:nil];
}

+(void)errorCode
{
    //[SVProgressHUD showErrorWithStatus:@"网络异常,加载失败哦！"];
    PopAlterView *popView = [PopAlterView popViewWithTipStr:@"网络异常,加载失败哦！"];
    [popView showInView:[UIApplication sharedApplication].keyWindow];
}

+ (void) initErrorNums
{
    NSUserDefaults* defualts = [NSUserDefaults standardUserDefaults];
    [defualts setObject:[self getNowTime] forKey:@"tradeTime"];
    [defualts setObject:@"5" forKey:@"maxErrorCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getNowTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHH"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}

+ (void) saveUserInfo:(id )responseObject
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![XYTZGeneral isBlankString:[[responseObject objectForKey:@"resultData"] objectForKey:@"oauthToken"]])
    {
        [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"oauthToken"] forKey:@"oauthToken"];
    }
    
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"useMoney"] forKey:@"useMoney"];//账户可用余额
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"realStatus"] forKey:@"realStatus"];//实名认证
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"phoneStatus"] forKey:@"phoneStatus"];//手机认证
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"emailStatus"] forKey:@"emailStatus"];//邮箱认证
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"payPwdFlag"] forKey:@"payPwdFlag"];//交易密码
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"share"] forKey:@"share"];//交易密码
    
    if (![XYTZGeneral isBlankString:[[responseObject objectForKey:@"resultData"] objectForKey:@"refreshToken"]])
    {
        [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"refreshToken"] forKey:@"refreshToken"];//刷新token
    }
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"userId"] forKey:@"userId"];//用户id
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"bankStatus"] forKey:@"bankStatus"];//银行卡绑定
    [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"realName"] forKey:@"realName"];//真实名字
    
    if (![XYTZGeneral isBlankString:[[responseObject objectForKey:@"resultData"] objectForKey:@"phone"]])
    {
        [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"phone"] forKey:@"phone"];//保存手机号
    }
    if (![XYTZGeneral isBlankString:[[responseObject objectForKey:@"resultData"] objectForKey:@"userName"]])
    {
        [defaults setObject:[[responseObject objectForKey:@"resultData"] objectForKey:@"userName"] forKey:@"userName"];//保存用户名
    }
    //    [defaults setObject:@"0" forKey:@"bankStatus"];
    //    [defaults setObject:@"0" forKey:@"realStatus"];
    [defaults synchronize];
}

+(void)reoveUserinfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"oauthToken"];
    [defaults setObject:nil forKey:@"useMoney"];
    [defaults setObject:nil forKey:@"realStatus"];
    [defaults setObject:nil forKey:@"phoneStatus"];
    [defaults setObject:nil forKey:@"emailStatus"];
    [defaults setObject:nil forKey:@"payPwdFlag"];
    [defaults setObject:nil forKey:@"userId"];
    [defaults setObject:nil forKey:@"refreshToken"];
    [defaults setObject:nil forKey:@"bankStatus"];
    [defaults setObject:nil forKey:@"realName"];
    [defaults setObject:nil forKey:@"phone"];
    [defaults setObject:nil forKey:@"userName"];
    [defaults setObject:nil forKey:@"share"];
    [defaults synchronize];
}

/*
 *  判断用户输入的密码是否符合规范，符合规范的密码要求：
 1. 长度大于8位
 2. 密码中必须同时包含数字和字母
 */
+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    //if ([pass length] >= 8 || [pass length] <=20){
    // 判断长度大于8位后再接着判断是否同时包含数字和字符
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:pass];
    //}
    return result;
}

+(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[NSString stringWithFormat:@"%@",string] length]==0) {
        return YES;
    }
    return NO;
}

//截取URL中Key Value
+(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

@end
