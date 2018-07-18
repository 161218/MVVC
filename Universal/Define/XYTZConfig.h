//
//  XYTZConfig.h
//  UniversalApp
//
//  Created by zl on 2018/7/11.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

//正式接口
#define NewBawe            @"https://www.xiangyitouzi.com"

//测试接口
//#define NewBawe          @"http://183.146.209.53:8081"
//#define NewBawe          @"http://192.168.1.107:8080"
//#define NewBawe          @"http://192.168.16.13:8081"

//#define NewBawe          @"http://192.168.16.9:8080"

//用户头像路径
#define USERHEADER      @"https://www.xiangyitouzi.com/imgurl.html?userid=%@&amp;size=big"
//#define USERHEADER      @"http://192.168.16.13:8081/imgurl.html?userid=%@&amp;size=big"
//JiaKe
#define APPISJIAKE [NSString stringWithFormat:@"%@/api/article/isPacking.html",NewBawe]//是否加壳
#define APPJIAKE [NSString stringWithFormat:@"%@/api/article/newsList.html",NewBawe]//首页
#define APPJIAKEPINGTAI [NSString stringWithFormat:@"%@/api/article/iosList.html",NewBawe]//平台
#define APPJIAKEP2P [NSString stringWithFormat:@"%@/api/article/datasFromBusiness.html",NewBawe]//P2P
#define APPJIAKEHANGYE [NSString stringWithFormat:@"%@/api/article/rankFromSource.html",NewBawe]//行业数据
#define APPJIAKEYINSI [NSString stringWithFormat:@"%@/api/article/secret.html",NewBawe]//隐私条款
#define APPJIAKEMIANZEI [NSString stringWithFormat:@"%@/api/article/relief.html",NewBawe]//免责声明
#define APPJIAKEJISHUZHICHI [NSString stringWithFormat:@"%@/api/article/techsupport.html",NewBawe]//技术支持
#define QZW_MAIN_URL   [NSString stringWithFormat:@"%@/",NewBawe]

//H5测试接口
#define APP_MAINHOME [NSString stringWithFormat:@"http://192.168.16.5:3000/appweb/home"] //首页
#define APP_INVESTMENTLIST [NSString stringWithFormat:@"http://192.168.16.5:3000/appweb/invest"] //投资列表页
#define APP_FIND [NSString stringWithFormat:@"http://192.168.16.5:3000/appweb/find"] //发现页
#define APP_MY [NSString stringWithFormat:@"http://192.168.16.5:3000/appweb/mine"] //我的页



//修改手势密码- 登录密码校验
#define CHECKLOGINPWD  [NSString stringWithFormat:@"%@/api/member/checkLoginPwd.html",NewBawe]
//用户上传头像
#define UPLOADAVATAR [NSString stringWithFormat:@"%@/api/member/uploadAvatar.html",NewBawe]
//手机验证码
#define QZW_REGPHONECODE_URL [NSString stringWithFormat:@"%@/api/user/regPhoneCode.html",NewBawe]
//注册
#define QZW_NEWREGISTER_URL [NSString stringWithFormat:@"%@/api/user/newRegister.html",NewBawe]
//登录
#define QZW_LOGIN_URL [NSString stringWithFormat:@"%@/api/user/login.html",NewBawe]
//refresh token
#define QZW_REFRESHTOKEN_URL [NSString stringWithFormat:@"%@/api/user/refreshToken.html",NewBawe]
//获取用户信息
#define QZW_GETUSERINFOSTATUS_URL [NSString stringWithFormat:@"%@/api/member/getUserInfoStatus.html",NewBawe]


























