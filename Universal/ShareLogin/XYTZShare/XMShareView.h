//
//  XMShareView.h
//  Universal
//
//  Created by zl on 2018/7/12.
//  Copyright © 2018年 Hangzhou Xiangyi Investment Management Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//  分享类型
typedef NS_ENUM(NSInteger, SHARE_ITEM){
    //  微信会话
    SHARE_ITEM_WEIXIN_SESSION,
    //  微信朋友圈
    SHARE_ITEM_WEIXIN_TIMELINE,
    //  QQ会话
    SHARE_ITEM_QQ,
    //  QQ空间
    SHARE_ITEM_QZONE,
    //  微博
    SHARE_ITEM_WEIBO
};


@interface XMShareView : UIView
{
    //  图片项
    NSMutableArray *iconList;
    //  文字项
    NSMutableArray *textList;
}

//  分享标题
@property (nonatomic, strong) NSString *shareTitle;
//  分享文本
@property (nonatomic, strong) NSString *shareText;
//  分享链接
@property (nonatomic, strong) NSString *shareUrl;
@end

