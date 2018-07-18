//
//  LXViewController.h
//  Chemayi
//
//  Created by Bird on 14-3-17.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
//#import "UINavigationController+CompletionHandler.h"

@interface LXViewController : UIViewController

@property (nonatomic,strong)UIControl *ctrlView;
@property (nonatomic, strong) UIImageView *nodataImage;
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, assign) BOOL viewDidApper;

@property (nonatomic, strong) id incomingParam;
@property (nonatomic, strong) id exitParam;

- (void)dismiss:(UIButton *)backBtn;
#pragma mark - ResignFirstResponder
- (void)clearKeyboard;

- (void)setControlView:(id)sender;

#pragma mark - 导航栏
//- (UIBarButtonItem *)createNavBtnItem:(UIViewController *)target normal:(NSString *)imgStr highlight:(NSString *)highStr selector:(SEL)selector;
//- (void)setNavgationStationTitle:(NSString *)str action:(SEL)action;

#pragma mark - ProgressHud
- (void)showHudWithString:(NSString *)str;
- (void)showText:(NSString *)str;
- (void)showText:(NSString *)str Seconds:(int)a;

- (void)hideHud;
- (void)hideLoadingHud;

#pragma mark - NoDataView
- (void)showNoDataView;
- (void)hideNodataView;

#pragma mark - blankViewx
-(void)showBlankInView:(UIView*)view;
-(void)hideBlankView;

#pragma mark ViewController presentModal
/**
 *  直接push到某个类 在不需要传数据的情况下可以使用这种。(如果需要传数据还是使用传统的push方法)
 *
 *  @param className 类名
 *  @param animated  是否带动画
 */
- (void)lxPushViewController:(NSString *)className animated:(BOOL)animated;
- (void)pushViewController:(NSString *)className;
- (void)pushViewControllerNoAnimated:(NSString *)className;

- (void)pushNewViewController:(UIViewController *)newViewController;

- (void)replaceViewController:(NSString*)vcClassName withIncomingParam:(id)param;

- (void)replaceViewController:(UIViewController *)viewController withAnimated:(BOOL)animated;

//倒退几页，如从3退到1，就是退2页。
-(void)popToVCBackPageNum:(int) backPageNum animated:(BOOL)animated;


#pragma mark - Public Method
/**
 *  选择地域 模态出选择地域的VC
 */
- (void)chooseCity;

@end
