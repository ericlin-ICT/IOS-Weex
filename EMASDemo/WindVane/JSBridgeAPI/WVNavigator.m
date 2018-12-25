//
//  WVNavigation.m
//  Demo
//
//  Created by daoche.jb on 2018/9/26.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import "WVNavigator.h"
#import <WindVane/WindVane.h>
#import "EMASWindVaneViewController.h"

// 导航栏的标题高度
#define NAVIGATION_BAR_TITLE_HEIGHT 30

@implementation WVNavigator

- (void)push:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    NSString * url = [param wvStringValue:@"url"];
    if ([NSString wvIsBlank:url]) {
        [context callbackInvalidParameter:@"url" withMessage:nil];
        return;
    }
    
    BOOL animated = YES;
    NSString *obj = [[param objectForKey:@"animated"] lowercaseString];
    if (obj && [obj isEqualToString:@"false"]) {
        animated = NO;
    }
    
    EMASWindVaneViewController *vc = [[EMASWindVaneViewController alloc] init];
    vc.loadUrl = param[@"url"];
    vc.hidesBottomBarWhenPushed = YES;
    [container.navigationController pushViewController:vc animated:animated];
    [context callbackSuccess:nil];
}

- (void)pop:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    BOOL animated = YES;
    id obj = [param objectForKey:@"animated"];
    if (obj && [obj isEqualToString:@"false"]) {
        animated = NO;
    }
    
    [container.navigationController popViewControllerAnimated:animated];
    [context callbackSuccess:nil];
}

- (void)setNavBarHidden:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    BOOL hidden = NO;
    id obj = [param objectForKey:@"hidden"];
    if (obj && [obj isEqualToString:@"true"]) {
        hidden = YES;
    }
    
    container.navigationController.navigationBarHidden = hidden;
    
    [context callbackSuccess:nil];
}

#pragma mark Navigation Setup

- (void)setNavBarBackgroundColor:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    NSString * backgroundColor = [param wvStringValue:@"backgroundColor"];
    if ([NSString wvIsBlank:backgroundColor]) {
        [context callbackInvalidParameter:@"backgroundColor" withMessage:nil];
        return;
    }
    
    if (backgroundColor) {
        container.navigationController.navigationBar.barTintColor = [UIColor wvColorWithHexString:backgroundColor];
    }
    
    [context callbackSuccess:nil];
}

- (void)setNavBarRightItem:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    WVUIButtonItem * item = [WVUIUtil createNavigationBarItem:param maxHeight:NAVIGATION_BAR_TITLE_HEIGHT callback:^(){
        [[weakSelf webview] dispatchEvent:@"rightItemClicked" withParam:nil withCallback:nil];
    }];
    container.navigationItem.rightBarButtonItems = @[item];

    [context callbackSuccess:nil];
}

- (void)clearNavBarRightItem:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    container.navigationItem.rightBarButtonItems = nil;
    
    [context callbackSuccess:nil];
}

- (void)setNavBarLeftItem:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    WVUIButtonItem * item = [WVUIUtil createNavigationBarItem:param maxHeight:NAVIGATION_BAR_TITLE_HEIGHT callback:^(){
        [[weakSelf webview] dispatchEvent:@"rightItemClicked" withParam:nil withCallback:nil];
    }];
    container.navigationItem.leftBarButtonItems = @[item];
    
    [context callbackSuccess:nil];
}

- (void)clearNavBarLeftItem:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    container.navigationItem.leftBarButtonItems = nil;
    
    [context callbackSuccess:nil];
}

- (void)setNavBarMoreItem:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    [context callbackNotSupported:nil];
}

- (void)clearNavBarMoreItem:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    [context callbackNotSupported:nil];
}

- (void)setNavBarTitle:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    NSString * title = [param wvStringValue:@"title"];
    if ([NSString wvIsBlank:title]) {
        [context callbackInvalidParameter:@"title" withMessage:nil];
        return;
    }
    
    container.navigationItem.title = title;
    
    [context callbackSuccess:nil];
}

- (void)clearNavBarTitle:(NSDictionary *)param withWVBridgeContext:(id<WVBridgeCallbackContext>)context
{
    UIViewController *container = [self viewController];
    if (!container || !container.navigationController) {
        [context callbackFailure:MSG_RET_FAILED withMessage:@"isn't navigationViewController"];
        return;
    }
    
    container.navigationItem.title = nil;
    
    [context callbackSuccess:nil];
}

//- (UIViewController *)topViewController {
//    UIViewController *resultVC;
//    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
//    while (resultVC.presentedViewController) {
//        resultVC = [self _topViewController:resultVC.presentedViewController];
//    }
//    return resultVC;
//}
//
//- (UIViewController *)_topViewController:(UIViewController *)vc {
//    if ([vc isKindOfClass:[UINavigationController class]]) {
//        return [self _topViewController:[(UINavigationController *)vc topViewController]];
//    } else if ([vc isKindOfClass:[UITabBarController class]]) {
//        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
//    } else {
//        return vc;
//    }
//    return nil;
//}

@end
