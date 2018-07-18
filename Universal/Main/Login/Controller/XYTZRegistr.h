//
//  XYTZRegistr.h
//  祥益金服
//
//  Created by Liang Shen on 14-7-4.
//  Copyright (c) 2014年 com.erongdu.QZW. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DemoTextField.h"

@interface XYTZRegistr : UIViewController <UITextFieldDelegate>

@property (strong , nonatomic) NSString *identifyStr;//判断从那个入口进来
//@property (strong , nonatomic) NSString *phoneNum;//前一个界面传入
@property (strong , nonatomic) NSString *cardExist;//是否实名认证

@end
