//
//  XYTZBrain.h
//  calculator
//
//  Created by apple on 13-9-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYTZBrain : NSObject
{
    //float TouBiaoJiangLi; //投标奖励
   
    double NianHuaLiLv; //年化利率
    
    double NianHuaYueLiLv;//年化月利率
    
    double FuLiLiLv;//复利利率
    
    double FuLiYueLiLv;//复利月利率
    
    double ZongShouYi;//总收益
    
    double returnZongJiangLi;//总奖励
}
@property(assign,nonatomic) double liLv;
@property(assign,nonatomic) double touBiaoJiangLi;
@property(assign,nonatomic) double biaoZongE;
@property(assign,nonatomic) double zongJiangLi;
@property(assign,nonatomic) double guanLiFei;
@property(assign,nonatomic) double qiXian;
@property(assign,nonatomic) double touBianJinE;
@property (assign,nonatomic) BOOL isRiQiXian;//是否日期限
@property (assign,nonatomic) BOOL isRiLilv;//是否日利率
@property (retain,nonatomic) NSString * huanKuanFangshi;//还款方式


-(void)resetAllInstainedData;

//投标奖励
-(double)returnTouBiaoJiangLi;
//年华利率
-(double)returnNianHuaLiLv;

//年化月利率
-(double)returnNianHuaYueLiLv;

//复利利率
-(double)returnFuLiLiLv;

//复利月利率
-(double)returnFuLiYueLiLv;

//总收益
-(double)returnZongShouYi;

//总奖励
-(double)returnZongJiangLi;

-(void)calculating;

@end
