//
//  EMASService.m
//  EMASDemo
//
//  Created by EMAS on 2018/1/15.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASService.h"

@implementation EMASService
{
    NSDictionary *services;
}

+ (EMASService *)shareInstance {
    static EMASService *g_instance = nil;
    static  dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        g_instance = [[EMASService alloc] init];
    });
    return g_instance;
}

- (id)init
{
    if (self = [super init])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AliyunEmasServices-Info" ofType:@"plist"];
        NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
        services = [root objectForKey:@"private_cloud_config"];
    }
    return self;
}

- (NSString *)appkey
{
    return [services objectForKey:@"AppKey"];
}

- (NSString *)appSecret
{
    return [services objectForKey:@"AppSecret"];
}

- (NSString *)getAppVersion
{
    NSDictionary *appinfo = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appinfo objectForKey:@"CFBundleShortVersionString"];
    if (!version) {
        version = @"10.0.0";
    }
    return version;
}

- (NSString *)ACCSDomain
{
    NSDictionary *dict = [services objectForKey:@"ACCS"];
    return [dict objectForKey:@"Host"];
}

- (NSDictionary *)IPStrategy
{
    NSDictionary *dict = [services objectForKey:@"Network"];
    return [dict objectForKey:@"IPStrategy"];
}

- (NSString *)HAServiceID
{
    return [services objectForKey:@"HAServiceID"];
}

- (NSString *)MTOPDomain
{
    NSDictionary *dict = [services objectForKey:@"MTOP"];
    return [dict objectForKey:@"Domain"];
}

- (NSString *)ChannelID
{
    return [services objectForKey:@"ChannelID"];
}

- (NSString *)ZCacheURL
{
    NSDictionary *dict = [services objectForKey:@"ZCache"];
    return [dict objectForKey:@"URL"];
}

- (NSString *)HAOSSBucketName
{
    NSDictionary *dict = [services objectForKey:@"HA"];
    return [dict objectForKey:@"OSSBucketName"];
}

- (NSString *)HAUniversalHost
{
    NSDictionary *dict = [services objectForKey:@"HA"];
    return [dict objectForKey:@"UniversalHost"];
}

- (NSString *)HATimestampHost
{
    NSDictionary *dict = [services objectForKey:@"HA"];
    return [dict objectForKey:@"TimestampHost"];
}

- (NSString *)HARSAPublicKey
{
    NSDictionary *dict = [services objectForKey:@"HA"];
    return [dict objectForKey:@"RSAPublicKey"];
}

- (NSString *)HotfixServerURL
{
    NSDictionary *dict = [services objectForKey:@"Hotfix"];
    return [dict objectForKey:@"URL"];
}

- (BOOL)useHTTP
{
    return [[services objectForKey:@"UseHTTP"] boolValue];
}

- (NSString *)RemoteConfigHost
{
    NSDictionary *dict = [services objectForKey:@"RemoteConfig"];
    return [dict objectForKey:@"Domain"];
}

@end
