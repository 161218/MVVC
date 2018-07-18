//
//  UINavigationController+CompletionHandler.h
//  Cheguanjia
//
//  Created by Bird on 15/3/31.
//  Copyright (c) 2015年 chemayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UINavigationController (CompletionHandler)

- (void)completionhandler_pushViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion;

@end
