//
//  ChangeGustureLockViewController.h
//  爱优理财
//
//  Created by tiramisuZhen on 14-5-21.
//  Copyright (c) 2014年 tiramisuZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"
#import "smallGuestureLock.h"
@interface ChangeGustureLockViewController : UIViewController<KKGestureLockViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *back_btn;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

@property (weak, nonatomic) IBOutlet KKGestureLockView *lockView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UILabel *tabbbarTitle_lab;

@property (strong,nonatomic) NSString* breakHomePage;
@property (strong,nonatomic) NSString* hiddenBack_btn;
@property (nonatomic,assign) BOOL isRegisteredBool;

@end
