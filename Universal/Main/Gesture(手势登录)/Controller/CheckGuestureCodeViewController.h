//
//  CheckGuestureCodeViewController.h
//  祥益金服
//
//  Created by tiramisuZhen on 14-5-23.
//  Copyright (c) 2014年 tiramisuZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"
@interface CheckGuestureCodeViewController : UIViewController<KKGestureLockViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *userHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;
@property (weak, nonatomic) IBOutlet KKGestureLockView *lockView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightq;

@end
