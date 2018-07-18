//
//  XYTZBrain.m
//  calculator
//
//  Created by apple on 13-9-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//
//NSNumber* tempnumber=[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",(float)(rand()%100001)*0.001f -20] doubleValue]];

#import "XYTZBrain.h"

@implementation XYTZBrain
@synthesize liLv,touBiaoJiangLi,biaoZongE,zongJiangLi,guanLiFei,qiXian,touBianJinE;
@synthesize isRiLilv,isRiQiXian;
@synthesize huanKuanFangshi;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.qiXian = 1;
        self.touBianJinE = 10000;
        self.huanKuanFangshi = @"按月还本息";
    }
    return self;
}

//投标奖励
-(double)returnTouBiaoJiangLi
{
    double result = zongJiangLi/biaoZongE;
    NSLog(@"投标奖励 = %@",[NSNumber numberWithDouble:result]);
    NSString * s = [NSString stringWithFormat:@"%.2lf",result];
    if ([s isEqualToString:@"nan"]||[s isEqualToString:@"inf"])
    {
        self.touBiaoJiangLi = 0;
    }
    else
    {
        self.touBiaoJiangLi = result*100;
    }
    return result*100;
}

-(void)calculating
{
    guanLiFei = guanLiFei/100;
    liLv = liLv*(1-guanLiFei);
    
     NSLog(@"toubiaojine=%f qiXian=%lf  liLv=%lf  huanKuanFangshi=%@      toubiaojiangli=%lf",touBianJinE,qiXian,liLv,huanKuanFangshi,touBiaoJiangLi);
    
    if (qiXian>0 && liLv>0)
    {
        if ([huanKuanFangshi isEqualToString:@"1"])
        {
            NianHuaLiLv = 24.00*touBiaoJiangLi/(qiXian+1)+liLv;
            FuLiLiLv = (pow((1+NianHuaLiLv/1200), 12)-1)*100;
            
//            float tem1 = [self returnPoint2:touBianJinE*liLv/1200];
//            float tem2 = [self returnPoint2:pow((1+liLv/1200), qiXian)/(pow((1+liLv/1200), qiXian)-1)*qiXian];
//            //tem2 = [self returnPoint2:tem2];
//            float tem3 = tem1*tem2;
//            tem3 = [self returnPoint2:tem3];
//            DDLog(@"shouyi: %.2lf",tem3-touBianJinE);
//            ZongShouYi = tem3 - touBianJinE;
            ZongShouYi = touBianJinE*liLv/1200*pow((1+liLv/1200), qiXian)/(pow((1+liLv/1200), qiXian)-1)*qiXian-touBianJinE+touBianJinE*touBiaoJiangLi/100;
        
        }
        //以下不会用到
        else if ([huanKuanFangshi isEqualToString:@"按季还本息"])
        {
        
            ZongShouYi = touBianJinE*liLv*(1+ceil(qiXian/3))/800+touBianJinE*touBiaoJiangLi/100;
            NianHuaLiLv = (liLv *3 +24*touBiaoJiangLi/(qiXian/3+1))/3;
            FuLiLiLv = (pow((NianHuaLiLv/400+1), 4)-1)*100;
        }
        else if ([huanKuanFangshi isEqualToString:@"月还息到期还本"])
        {
            ZongShouYi = touBianJinE*liLv*qiXian/1200+touBiaoJiangLi*touBianJinE/100;
            NianHuaLiLv = (liLv*qiXian  + 12*touBiaoJiangLi)/qiXian;
            FuLiLiLv = (pow((1+NianHuaLiLv/1200*qiXian), 12/qiXian)-1)*100;
        }
        else if ([huanKuanFangshi isEqualToString:@"一次性还款"])
        {
            ZongShouYi = touBianJinE*liLv*qiXian/1200 + touBianJinE*touBiaoJiangLi/100;
            NianHuaLiLv = liLv + touBiaoJiangLi*12/qiXian;
            FuLiLiLv = (pow((1+NianHuaLiLv/1200*qiXian), 12/qiXian)-1)*100;
        }
        
        
        
        if (isRiQiXian)
        {
            NianHuaLiLv = liLv+touBiaoJiangLi/qiXian*360;
           NianHuaYueLiLv = NianHuaLiLv / 12;
            ZongShouYi = touBianJinE*liLv*qiXian/36000+touBiaoJiangLi*touBianJinE/100;
            FuLiLiLv = (pow((1+NianHuaLiLv/36500*qiXian), 365/qiXian)-1)*100;
        }
        ZongShouYi = round(ZongShouYi*100)/100;
    }
    else
    {
        ZongShouYi = round(touBianJinE*touBiaoJiangLi)/100;
    }
}


-(float)returnPoint2:(float)temDouble
{
    NSString *temStr = [NSString stringWithFormat:@"%f",temDouble];
    NSArray *temArray = [temStr componentsSeparatedByString:@"."];
    NSString *pointStr = [[temArray objectAtIndex:1] substringWithRange:NSMakeRange(0, 2)];
    NSString *resultStr = [NSString stringWithFormat:@"%@.%@",[temArray objectAtIndex:0],pointStr];
    return [resultStr floatValue];
}

//年华利率
-(double)returnNianHuaLiLv
{
    return round(NianHuaLiLv*100)/100;
}
//年化月利率
-(double)returnNianHuaYueLiLv
{
    return round(NianHuaLiLv/12*100)/100;
}
//复利利率
-(double)returnFuLiLiLv
{
    return round(FuLiLiLv*100)/100;
}
//复利月利率
-(double)returnFuLiYueLiLv
{
    return round(FuLiLiLv/12*100)/100;
}
//总收益
-(double)returnZongShouYi
{
    return ZongShouYi;
}
//总奖励
-(double)returnZongJiangLi
{
    return round(touBiaoJiangLi*touBianJinE)/100;
}
-(void)resetAllInstainedData
{
    
    NianHuaLiLv = 0;
    NianHuaYueLiLv = 0;
    FuLiLiLv = 0;
    FuLiYueLiLv =0 ;
    ZongShouYi = 0;
    returnZongJiangLi = 0;
    
    self.liLv = 0;
    self.touBiaoJiangLi = 0;
    self.biaoZongE = 0;
    self.zongJiangLi = 0;
    self.guanLiFei = 0;
    self.qiXian = 1;
    self.touBianJinE =10000;
}
@end
