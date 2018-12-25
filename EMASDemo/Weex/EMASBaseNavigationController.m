//
//  EMASBaseNavigationController.m
//  EMASWeexDemo
//
//  Created by daoche.jb on 2018/7/27.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASBaseNavigationController.h"

@implementation EMASBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
        }
    }
    [super pushViewController:viewController animated:animated];
    
}

@end
