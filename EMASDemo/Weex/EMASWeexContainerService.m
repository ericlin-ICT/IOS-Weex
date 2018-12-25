//
//  EMASWeexContainerService.m
//  EMASWeexDemo
//
//  Created by daoche.jb on 2018/8/23.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWeexContainerService.h"

@implementation EMASWeexContainerService
{
    NSDictionary *services;
}

+ (EMASWeexContainerService *)shareInstance {
    static EMASWeexContainerService *g_instance = nil;
    static  dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        g_instance = [[EMASWeexContainerService alloc] init];
    });
    return g_instance;
}

- (id)init
{
    if (self = [super init])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Scaffold-Info" ofType:@"plist"];
        NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
        services = root;
    }
    return self;
}

- (NSNumber *)scaffoldType
{
    return [services objectForKey:@"ScaffoldType"];
}

- (NSNumber *)tabSize
{
    return [services objectForKey:@"TabSize"];
}

- (NSDictionary *)jsSource
{
    return [services objectForKey:@"JSSource"];
}

@end
