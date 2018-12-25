//
//  EMASWindVaneConfig.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/9/29.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWindVaneConfig.h"
#import <WindVane/WindVane.h>
#import "EMASService.h"

@implementation EMASWindVaneConfig

+ (void)setUpWindVanePlugin {
    // 设置APPKey, 如果使用了安全黑匣子, 就会使用安全黑匣子的key
    //    [WVUserConfig setAppKey:@"4272" secrect:@"0ebbcccfee18d7ad1aebc5b135ffa906"];
    [WVUserConfig setAppKey:[[EMASService shareInstance] appkey]];
    // 设置是否使用安全黑匣子
     [WVUserConfig useSafeSecert:NO];
    // 设置环境
    // [WVUserConfig setEnvironment:WVEnvironmentDaily];
    [WVUserConfig setEnvironment:WVEnvironmentRelease];
    // 设置TTID
    //[WVUserConfig setTTid:@"windvane@demo2"];
    // 设置UA
    [WVUserConfig setAppUA:[NSString stringWithFormat:@"TBIOS"]];
    // 设置 App 名称，会在 UserAgent 中带上，请务必正确设置。
    [WVUserConfig setAppName:@"EMASDemo"];
    //取消域名安全策略
    [WVConfigManager defaultDomainConfig].aliDomain = @"";
    // 设置app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [WVUserConfig setAppVersion: [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    // WKWebView 支持 NSURLProtocol
    [WVURLProtocolService setSupportWKURLProtocol:YES];
    
#ifdef DEBUG
    [WVBasicUserConfig setDebugMode:YES];
    // 打开 WindVane 的 Log
    [WVBasicUserConfig openWindVaneLog];
    [WVUserConfig setLogLevel:WVLogLevelVerbose];
    [WVBasic setJSLogLevel:WVLogLevelVerbose];
#endif
    
    // 初始化WindVane各模块
    //[WVTBExtension setup];
    [WVBasic setup];
    [WVAPI setup];
    [WVMonitor startMonitoring];  
    [EMASWVExtensionConfig setup];
}

@end
