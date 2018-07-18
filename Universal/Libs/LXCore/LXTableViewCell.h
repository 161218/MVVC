//
//  LXTableViewCell.h
//  chepeitong
//
//  Created by SHENYIBING on 16/1/4.
//  Copyright © 2016年 chemayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTableViewCell : UITableViewCell
@property(nonatomic, assign) id delegate;
@property(nonatomic,strong)id dataModel;

-(void)layoutUIFromModel:(id)model;
@end
