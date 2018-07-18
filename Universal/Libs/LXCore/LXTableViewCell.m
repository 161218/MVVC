//
//  LXTableViewCell.m
//  chepeitong
//
//  Created by SHENYIBING on 16/1/4.
//  Copyright © 2016年 chemayi. All rights reserved.
//

#import "LXTableViewCell.h"

@implementation LXTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutUIFromModel:(id)model
{
    self.dataModel = model;
}
@end
