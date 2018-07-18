//
//  UIImage+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BC)
/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

-(UIImage *)TransformtoSize:(CGSize)Newsize;
-(UIImage *)IcontoSize:(CGSize)Newsize1;

/**
 通过哈希值获取UIcolor颜色
 ******通过16进制hexString色值直接获取`UIColor`对象******
 @param hexString hex值字符串
 @return UIColor对象
 */
- (UIColor *)colorWithHexString:(NSString *)hexString;
/**
 通过哈希值获取UIcolor颜色
 @param hexString hex值字符串
 @param alpha 透明度
 @return UIColor对象
 */
- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;


/**
 从一张单色滤镜图片上面获取颜色
 ******从一张纯色图获取颜色******
 @param image UIImage对象
 @return UIColor对象
 */
- (UIColor *)colorWithUIImage:(UIImage *)image;

/**
 用UIColor颜色生成一张纯色图片
 ******由`UIColor`颜色获取`UIImage`对象******
 @param color UIColor颜色对象
 @return UIImage对象
 */
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 用哈希值获取一张纯色图片
 ******由16进制`HexString`颜色获取`UIImage`对象******
 @param hexString hex值字符串
 @return UIImage对象
 */
- (UIImage *)imageWithHexString:(NSString *)hexString;
@end
