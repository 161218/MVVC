

//
//  XYTZNetWork.m
//  UniversalApp
//
//  Created by zl on 2018/7/11.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "XYTZNetWork.h"


static XYTZNetWork * afnetworing;

@implementation XYTZNetWork

bool isSelf;

+(id)shareAFnetworking
{
    if (!afnetworing) {
        isSelf = YES;
        afnetworing = [[XYTZNetWork alloc]init];
        isSelf = NO;
    }
    
    return afnetworing;
    
}
+(id)alloc
{
    if (isSelf == YES)
    {
        return [super alloc];
    }
    return nil;
}

- (void)performRequestWithPath:(NSString *)path viewController: (UIViewController*)viewController formDataDic:(NSDictionary *)formDataDic backBlock:(void (^)(NSDictionary *, NSError *))aBlock
{
    [SVProgressHUD showWithStatus:@"请稍等..." maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
    
    [post setDictionary:formDataDic];
    [post setObject:APP_ID forKey:@"appId"];
    [post setObject:SIGN_TYPE forKey:@"signType"];
    NSString *paramsStr = [XYTZGeneral paramsToMD5:post];
    [post setObject:paramsStr forKey:@"sign"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // manager.requestSerializer.timeoutInterval = 10;
    [manager POST:path parameters:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"JSON: %@", responseObject);
        NSInteger resultCode;
        resultCode = [[responseObject objectForKey:@"resultCode"] intValue];
        if (resultCode == 1)
        {
            if (aBlock)
            {
                aBlock([NSDictionary dictionaryWithDictionary:responseObject], nil);
            }
        }
        else
        {
            //UIViewController *viewC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [XYTZGeneral refreshToken:responseObject viewController:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [XYTZGeneral errorCode];
    }];
}

@end
