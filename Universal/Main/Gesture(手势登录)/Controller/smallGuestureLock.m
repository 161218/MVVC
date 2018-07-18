//
//  smallGuestureLock.m
//  爱优理财
//
//  Created by tiramisuZhen on 14-5-22.
//  Copyright (c) 2014年 tiramisuZhen. All rights reserved.
//

#import "smallGuestureLock.h"
#import "UIView+ZXQuartz.h"

//间距
#define SPACE  5

//半径
#define R  5

@implementation smallGuestureLock

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.choosedNum = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [[UIColor whiteColor] setStroke];//设置线条颜色
    [[UIColor clearColor] setFill]; //设置填充颜色
    
    //创建小圆
    for (int i = 0; i < 9; i++)
    {
        //匹配是否有被选中的
        for (int j = 0; j<self.choosedNum.count; j++)
        {
            if ([[self.choosedNum objectAtIndex:j] integerValue] == i)
            {
                [[UIColor blueColor] setStroke];//设置线条颜色
                [[UIColor blueColor] setFill]; //设置填充颜色
                
                break;
            }
            else
            {
                if (j == (self.choosedNum.count -1))
                {
                    [[UIColor darkGrayColor] setStroke];//设置线条颜色
                    [[UIColor clearColor] setFill]; //设置填充颜色
                }
            }
        }
        
        [self drawCircleWithCenter:CGPointMake((i%3)*(2*R + SPACE) + 5, (ceilf(((float)(i+1))/3)-1) * (2*R + SPACE) + 5)
                                 radius:R];
    }
}


@end
