//
//  CCWeiXinOpenStrategy.m
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import "CCWeiXinOpenStrategy.h"
#import "AFNetworking.h"
#import "WXApi.h"
#import "CCOpenConfig.h"

@interface CCWeiXinOpenStrategy() <WXApiDelegate>

@property (nonatomic,strong) NSString *openID;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *refreshToken;
//token过期时间 2小时 7200秒
@property (nonatomic,strong) NSDate *expiresDate;

@end

@implementation CCWeiXinOpenStrategy

#pragma mark - <CCOpenProtocol> 面向CCOpenService
//由于微信有一个步骤需要设置代理 [WXApi handleOpenURL:url delegate:self]
//所以需要将weixin的strategy设置成单例
+(instancetype)sharedOpenStrategy {
    static CCWeiXinOpenStrategy *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shared = [[CCWeiXinOpenStrategy alloc] init];
        //向微信注册
        [WXApi registerApp:[CCOpenConfig getWeiXinAppID]];
    });
    return shared;
}

/**
 *  获取用户信息
 *
 *  @param respondHander 异步获取到用户数据后,respondHander将会在主线程中执行
 */
-(void)requestOpenAccount:(void (^)(CCOpenRespondEntity *))respondHander{
    if ([WXApi isWXAppInstalled] == NO ) {
        //没安装微信直接返回nil
        respondHander(nil);
        return;
    }
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    self.respondHander = respondHander;
}

-(BOOL)handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - 实现WXApiDelegate
-(void)onResp:(BaseResp *)resp{
    [self requestUserInfoWithBaseResp:(SendAuthResp *)resp];
}

-(void)onReq:(BaseReq *)req{
    NSLog(@"onReq :%@",req);
}

#pragma mark - 授权流程

-(void)requestUserInfoWithBaseResp:(SendAuthResp *)resp{
    NSString *code = [resp code];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // manager.responseSerializer默认就是期望JSON类型的response
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = [CCOpenConfig getWeiXinAppID];
    params[@"secret"] = [CCOpenConfig getWeiXinAppSecret];
    params[@"code"] = code;
    params[@"grant_type"] = @"authorization_code";
    
    
    [manager GET:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        responseObject = (NSDictionary *)responseObject;
        if ([responseObject valueForKey:@"access_token"]) {
            self.accessToken  = [responseObject valueForKey:@"access_token"];
            self.openID       = [responseObject valueForKey:@"openid"];
            self.refreshToken = [responseObject valueForKey:@"refreshToken"];
            
            //获取用户信息
            NSURL *getUserInfoURL = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.accessToken, self.openID]];
                        
            [manager GET:getUserInfoURL.absoluteString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                responseObject = (NSDictionary *)responseObject;
                if ([responseObject valueForKey:@"openid"]) {
                    //成功获取到用户数据,组成实体并且通知主线程的handerBlock
                    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
                    entity.type = CCOpenEntityTypeWeiXin;
                    entity.data = responseObject;
                    self.respondHander(entity);
                }else{
                    NSLog(@"JSON: %@", responseObject);
                }
            } failure:^(NSURLSessionDataTask * task, NSError * error) {
                NSLog(@"Error: %@", error);
            }];
        }else{
            NSLog(@"JSON: %@", responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
