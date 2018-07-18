//
//  UIImage+MJ.m
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIImage+BC.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extend.h"
@implementation UIImage (BC)

+ (UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) { // 没有_os7后缀的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
//
    // 非iOS7
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

-(UIImage *)TransformtoSize:(CGSize)Newsize
{
    
    // 创建一个bitmap的context
    UIGraphicsBeginImageContextWithOptions(Newsize, NO, [UIScreen mainScreen].scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}

-(UIImage *)IcontoSize:(CGSize)Newsize1
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContextWithOptions(Newsize1, NO, 1);
    LLog(@"%f",[UIScreen mainScreen].scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, Newsize1.width, Newsize1.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}

- (UIColor *)colorWithHexString:(NSString *)hexString {
    
    return [self colorWithHexString:hexString alpha:1.0f];
}

- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return nil;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return nil;
    
    NSString *rString = [cString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [cString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [cString substringWithRange:NSMakeRange(4, 2)];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    UIColor *hexColor = [UIColor colorWithRed:((float) r / 255.0f)
                                        green:((float) g / 255.0f)
                                         blue:((float) b / 255.0f)
                                        alpha:alpha];
    
    return hexColor;
}



- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (UIImage *)imageWithHexString:(NSString *)hexString {
    return [self imageWithColor:[self colorWithHexString:hexString]];
}
@end
