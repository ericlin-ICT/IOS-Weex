//
//  ExEMASWXSDKEngine.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/6/28.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWXSubSDKEngine.h"
#import <WeexSDK/WeexSDK.h>
#import "EMASService.h"
#import "EMASWXNavigationImpl.h"
#import <EmasWeexComponents/EmasWeexComponents.h>

@implementation EMASWXSubSDKEngine

+ (void)setup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initWXSDKEnviroment];
    });
}

+ (void)initWXSDKEnviroment {
    [super initWXSDKEnviroment];
    
#ifdef DEBUG
    [WXDebugTool setDebug:YES];
    [WXLog setLogLevel:WXLogLevelLog];
    
#else
    [WXDebugTool setDebug:NO];
    [WXLog setLogLevel:WXLogLevelError];
#endif
    
    [EmasWeexComponents setup];
}

+ (void)appConfig {
    [super appConfig];
    
    [WXAppConfiguration setAppGroup:@"EMASApp"];
    [WXAppConfiguration setAppName:@"EMASDemo"];
    [WXAppConfiguration setAppVersion:[[EMASService shareInstance] getAppVersion]];

}

+ (void)registerHandler {
    [super registerHandler];
    [self registerHandler:[EMASWXNavigationImpl new] withProtocol:@protocol(WXNavigationProtocol)];
}

+ (void)registerModule {
    [super registerModule];
}

@end
