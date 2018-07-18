//
//  LXBaseTableViewController.h
//  Chemayi_iPhone2.0
//
//  Created by Chemayi on 14/8/26.
//  Copyright (c) 2014年 LianXian. All rights reserved.
//

#import "LXViewController.h"

@interface LXBaseTableViewController : LXViewController<UITableViewDelegate, UITableViewDataSource>
 

/**
 *  显示大量数据的控件
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  初始化init的时候设置tableView的样式才有效
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 *  大量数据的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  下拉刷新
 */
//@property (retain, nonatomic) MJRefreshHeader *header;

/**
 *  这个为YES的时候可以下拉刷新，默认为NO
 */
@property (nonatomic) BOOL canPullRefresh;

/**
 *  这个为YES的时候分割线顶满左边界，默认为YES
 */
@property (nonatomic) BOOL seperatorFull;


/**
 *  这个为YES的时候自动隐藏多余Cell分割线
 */
@property (nonatomic) BOOL extraSeperatorHide;

//上拉加载
//@property (retain, nonatomic) MJRefreshFooter *footer;


- (BOOL)validateSeparatorInset;

/**
 *  去除iOS7新的功能api，tableView的分割线变成iOS6正常的样式
 */
- (void)configuraTableViewNormalSeparatorInset;

/**
 *  配置tableView右侧的index title 背景颜色，因为在iOS7有白色底色，iOS6没有
 *
 *  @param tableView 目标tableView
 */
- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView;

/**
 *  加载本地或者网络数据源
 */
- (void)loadDataSource;

/**
 *  自定义导航栏左右按钮
 */
- (UIBarButtonItem *)createNavBtnItem:(UIViewController *)target normal:(NSString *)imgStr highlight:(NSString *)highStr selector:(SEL)selector;

@end
