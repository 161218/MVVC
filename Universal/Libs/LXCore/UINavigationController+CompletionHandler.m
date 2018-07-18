//
//  UINavigationController+CompletionHandler.m
//  Cheguanjia
//
//  Created by Bird on 15/3/31.
//  Copyright (c) 2015年 chemayi. All rights reserved.
//

#import "UINavigationController+CompletionHandler.h"

@implementation UINavigationController (CompletionHandler)

- (void)completionhandler_pushViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}

@end
