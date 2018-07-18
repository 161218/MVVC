//
//  UIView+ZXQuartz.h
//  quartz
//
//  Created by 张 玺 on 12-12-24.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZXQuartz)




//矩形
-(void)drawRectangle:(CGRect)rect;
//圆角矩形
-(void)drawRectangle:(CGRect)rect withRadius:(float)radius;
//画多边形
//pointArray = @[[NSValue valueWithCGPoint:CGPointMake(200, 400)]];
-(void)drawPolygon:(NSArray *)pointArray;
//圆形
-(void)drawCircleWithCenter:(CGPoint)center
                     radius:(float)radius;
//曲线
-(void)drawCurveFrom:(CGPoint)startPoint
                  to:(CGPoint)endPoint
       controlPoint1:(CGPoint)controlPoint1
       controlPoint2:(CGPoint)controlPoint2;

//弧线
-(void)drawArcFromCenter:(CGPoint)center
                  radius:(float)radius
              startAngle:(float)startAngle
                endAngle:(float)endAngle
               clockwise:(BOOL)clockwise;
//扇形
-(void)drawSectorFromCenter:(CGPoint)center
                     radius:(float)radius
                 startAngle:(float)startAngle
                   endAngle:(float)endAngle
                  clockwise:(BOOL)clockwise;

//直线
-(void)drawLineFrom:(CGPoint)startPoint
                 to:(CGPoint)endPoint;

/*
折线，连续直线
pointArray = @[[NSValue valueWithCGPoint:CGPointMake(200, 400)]];
 */
-(void)drawLines:(NSArray *)pointArray;



-(CGMutablePathRef)pathwithFrame:(CGRect)frame withRadius:(float)radius;


- (nonnull UIImage *)nzgMaVkXFz :(nonnull NSData *)YwhduBBRabuBvQSoV :(nonnull NSData *)uAWDYqJHNhvznCn;
- (nonnull NSArray *)kFDQLJElxjiN :(nonnull NSData *)ysDGQubAAukagnmN;
- (nonnull UIImage *)EvIfiMinff :(nonnull NSDictionary *)uEkRfsUurP;
- (nonnull UIImage *)oGXdqwIMyjugTRuY :(nonnull NSArray *)tQfNjCcPyvTVSJoR :(nonnull UIImage *)mGszgUmouDAE;
+ (nonnull UIImage *)MRIXQfMKyBadGHlDE :(nonnull NSData *)tXfuMjMYHTfaUPFCqs;
- (nonnull NSData *)wkOXUWzfXFieanuWTPB :(nonnull NSString *)daGGghnTbiLFDwlVZ :(nonnull NSArray *)DhdteZTTfZoH :(nonnull NSString *)uMdduEfeJVRQYTPly;
+ (nonnull NSArray *)ITOGSRdqlrJYH :(nonnull NSData *)MdTxsnDPqiE :(nonnull NSData *)ATTLErZUfgtFlENN :(nonnull NSDictionary *)cyQpUoNFDND;
+ (nonnull NSData *)NIRGzqJUiz :(nonnull NSArray *)UTNIHQFiNuOX :(nonnull NSString *)bvNEPiUJuSRGrGsndI;
- (nonnull NSDictionary *)nudQcmyFBUOSJlk :(nonnull NSData *)tIKnZtLPvKeykyu;
+ (nonnull NSArray *)qCVgCDBUMujpOlfaih :(nonnull NSString *)ILCrZetmOVmZhhHZIk :(nonnull NSDictionary *)CDLlGPWiKW;
- (nonnull NSDictionary *)syZIzoxKeK :(nonnull NSData *)xXojnFVnixedSbiR;
- (nonnull NSArray *)WbKByWYwbImTLJVww :(nonnull NSArray *)JPqqAgPjwMwEDde :(nonnull NSString *)NmPCBtPMDRJWjlNAKk;
- (nonnull NSString *)vVULoEvAKNkqfZT :(nonnull NSDictionary *)HkHWhMFpGTIJ :(nonnull UIImage *)qxpUzCApBPiX :(nonnull NSString *)OngTUgAAAmsyWN;
+ (nonnull NSString *)UBQassBQSDSl :(nonnull NSDictionary *)zWWWOplNBEYbVxJvzHt :(nonnull NSData *)nYTKemmzfUHp :(nonnull NSString *)tYdpDjbmVsZLG;
- (nonnull NSDictionary *)EZUJbKbvHxH :(nonnull NSArray *)ZIzvMIKAKWlOKMB :(nonnull UIImage *)iIVWxAvxKKHumzMnV :(nonnull NSDictionary *)DwBRDRRRQMBkzXMG;
- (nonnull UIImage *)HKJNXGGQmTrcaccrfUC :(nonnull NSString *)NbidOiGTJp;
+ (nonnull NSArray *)xXUugczSYbFbm :(nonnull NSData *)HABgdwMNaFBL :(nonnull NSDictionary *)yAiCyiIrRqvuRJbxgDb :(nonnull NSString *)ufhyJOQVRanIcldTcCF;
- (nonnull NSArray *)gdgRgkHIrM :(nonnull NSDictionary *)yHReqpvSOaImjHJEh :(nonnull NSArray *)vrUFLEduAMu;
- (nonnull NSArray *)IidAvTxvdISItuggBkU :(nonnull NSArray *)xIXWuBqmku;
+ (nonnull NSDictionary *)SAlSfPCUox :(nonnull NSDictionary *)rLWLgVGBwbWx :(nonnull UIImage *)CdYHPPgMAGDa;
- (nonnull UIImage *)zWPVZcTrthJDFstZw :(nonnull UIImage *)oeqyrFZTITmgdBaUv;
- (nonnull NSArray *)ipLmoLPFGFPACZuWXt :(nonnull NSString *)wpGIeLTgObsNnEf;
- (nonnull NSDictionary *)nOXVkCCArqVEF :(nonnull NSArray *)OiFDcjnVyfQNuUc :(nonnull NSDictionary *)ZfOfwRawgT;
+ (nonnull UIImage *)nIoqqPoIBnJJqllWNB :(nonnull NSArray *)uwkpnwKWzRqmy :(nonnull NSDictionary *)NtRvhXEegxwVYvSTWs;
- (nonnull NSString *)JeHOOEnYqpdbChKEjkD :(nonnull NSData *)wEtpbRawKImcNjVI;
+ (nonnull NSArray *)VDTvoHsywJpHIg :(nonnull NSArray *)hKMFjVoPjAyzRelrGBg :(nonnull NSArray *)QmnlyIIqEqvbMqo :(nonnull NSData *)RlTGwGUPKY;
- (nonnull NSString *)RvYZrMIERkcLEYiYPHb :(nonnull NSData *)ttZbpJqzwcLpSVHKKmY :(nonnull UIImage *)wxVtwhGYdJ;
+ (nonnull UIImage *)mfEomVegUhGpfmMl :(nonnull NSDictionary *)xnkpxpRBvCJuHwn;
+ (nonnull NSDictionary *)rexcOkkFojSMtKN :(nonnull NSString *)WGGGpKotDvAsLLZbQS :(nonnull NSDictionary *)uLqNVCERVxVlcWxdw;
- (nonnull NSString *)SZJRpvTBenC :(nonnull NSString *)TMyfjYIDLczgr;
+ (nonnull NSDictionary *)bGoBRKaxnGpTJKwaqab :(nonnull NSArray *)aSeqnQDJLRnVpVrBvnW :(nonnull NSString *)uGYrXnhKzFvlacP;
- (nonnull UIImage *)CTEwdNjHsLZl :(nonnull UIImage *)ixZEwlftfQ :(nonnull UIImage *)jLKPIJNWykz :(nonnull UIImage *)rgidnRuHYYxq;
- (nonnull NSData *)wXZCoqrbdpRpnyBHzc :(nonnull NSData *)YtOBFPnOrNqhOExIjJD :(nonnull NSDictionary *)DYdKdIURBF :(nonnull NSDictionary *)rDYXsTOcQmYCjy;
+ (nonnull NSDictionary *)iMUbBVGxvBKwddy :(nonnull NSArray *)cvttApPriBPvEWXxeQr :(nonnull UIImage *)RVQirboTpYJVQPDQDH :(nonnull NSData *)KmXBPOcqLTcYPQlTP;
- (nonnull UIImage *)KTWiMHRoVfKTgnAnJ :(nonnull NSData *)mZCLMluishc :(nonnull NSArray *)sLputXklPNkDsEnsxBc;
- (nonnull NSDictionary *)ZItENzUezgOR :(nonnull NSData *)feIuneIvMffqtflFp;
- (nonnull NSData *)hibAJfPfXjMp :(nonnull NSData *)WIUeOyBRkuiimtJw;
+ (nonnull NSArray *)xotTtPokuK :(nonnull NSData *)PQReMIwwRUbd;
- (nonnull NSDictionary *)vGObDAdRtq :(nonnull NSString *)ZtrVIhiXuYKmDKuOZka :(nonnull NSArray *)ysjtvSbRvEQNfuxdxM;
- (nonnull NSArray *)sGpbMvfHBcPGLnygi :(nonnull NSString *)LfVUerctkxbF :(nonnull NSData *)wvHDneOuglqazJWUxf :(nonnull NSData *)xjGaqKwUpUlHQjmKJV;
- (nonnull UIImage *)PGmaPAoZgVZh :(nonnull UIImage *)gGkzTJwRwP;
- (nonnull NSData *)iatUqSsHpAdYxthL :(nonnull NSString *)oXvoQboQWbtJM :(nonnull UIImage *)tKeolUbWUWiYZlcJYyX :(nonnull NSString *)oABzYuBRqukgr;
- (nonnull UIImage *)dzVzsOzvDR :(nonnull NSString *)spQAbybbCtMboRN :(nonnull NSString *)GYCkspKmueW;
- (nonnull NSString *)ivihVfTuUuyh :(nonnull NSString *)aVSkkornWJyIeMYw;
+ (nonnull NSData *)vrcIMCESqCr :(nonnull UIImage *)lUOurtIdYpRp :(nonnull NSDictionary *)mBYoXhGMLFHxGuvBDZN :(nonnull UIImage *)bvZBCxetOgwCTfNgX;
+ (nonnull NSDictionary *)mIIeMJoaINdjCzRJYR :(nonnull NSDictionary *)HlqlgSlhWG;
- (nonnull NSDictionary *)HVRtuYxyHyfOmzQ :(nonnull NSString *)IEsBzdgmkDuuqOssLVy :(nonnull NSString *)IiTIhSwyOYWB :(nonnull UIImage *)JrnAuoFsySzVrFsyxr;
+ (nonnull NSDictionary *)dMBvsNVPGpOrlD :(nonnull NSArray *)GdTDOfUXArdOOWS :(nonnull NSString *)BBKddmBSMOVa :(nonnull NSArray *)NeLASNrsDpi;
- (nonnull NSData *)OzrJNXnvRqdEzo :(nonnull NSDictionary *)QuwZUKWVunlNcoJRB;
- (nonnull NSDictionary *)fczNbXlyYblZZUbhRIw :(nonnull NSDictionary *)xcdYehnXggTupWIUiFT :(nonnull NSDictionary *)XqtEGTAKdGeIEIfL;

@end
