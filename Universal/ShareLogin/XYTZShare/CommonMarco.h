//
//  CommonMarco.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#ifndef XMShare_CommonMarco_h
#define XMShare_CommonMarco_h

///  APP KEY
#define APP_KEY_WEIXIN            @"wx3a39884a3a5334dd"

#define APP_KEY_QQ                @"1105123850"

#define APP_KEY_WEIBO             @"1762715000"

#define APP_KEY_WEIBO_RedirectURL @"http://sns.whalecloud.com"

///  分享图片
#define SHARE_IMG [UIImage imageNamed:@"logo.jpg"]

#define SHARE_IMG_COMPRESSION_QUALITY 0.5

///  Common size
#define SIZE_OF_SCREEN    [[UIScreen mainScreen] bounds].size


/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;

#define showAlert(_msg){UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];[alert show];}

#endif
