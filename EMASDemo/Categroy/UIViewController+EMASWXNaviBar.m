/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "UIViewController+EMASWXNaviBar.h"
#import "EMASScannerViewController.h"
#import <WeexSDK/WeexSDK.h>
//#import "WXDefine.h"
#import <objc/runtime.h>
#define WEEX_COLOR [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1]

@implementation UIViewController (EMASWXNaviBar)

- (void)setupNaviBar
{
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGestureRecognizer.delegate = self;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = WEEX_COLOR;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = WEEX_COLOR;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.title = @"EMAS";
    
    if(![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItems = @[[self backButtonItem]];
    } else {
        self.navigationItem.rightBarButtonItems = @[[self leftBarButtonItem]];
    }

}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer*)edgePanGestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark - UIBarButtonItems

- (UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *leftItem = objc_getAssociatedObject(self, _cmd);
    
    if (!leftItem) {
        leftItem = [[UIBarButtonItem alloc]
                    initWithImage:[UIImage imageNamed:@"scan"]
                     style:UIBarButtonItemStylePlain
                    target:self
                    action:@selector(scanQR:)];
        leftItem.accessibilityHint = @"click to scan qr code";
        leftItem.accessibilityValue = @"scan qr code";
        objc_setAssociatedObject(self, _cmd, leftItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return leftItem;
}

- (UIBarButtonItem *)backButtonItem
{
    UIBarButtonItem *backButtonItem = objc_getAssociatedObject(self, _cmd);
    if (!backButtonItem) {
        backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(backButtonClicked:)];
        objc_setAssociatedObject(self, _cmd, backButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return backButtonItem;
}

#pragma mark -
#pragma mark - UIBarButtonItem actions

- (void)scanQR:(id)sender
{
    EMASScannerViewController * scanViewController = [[EMASScannerViewController alloc] init];
    [self.navigationController pushViewController:scanViewController animated:YES];
}

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
