//
//  AccsConfiguration.h
//  EMASDemo
//
//  Created by wuchen.xj on 2018/6/20.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMAS_CONFIG_KEY_APPEKY      @"appkey"
#define EMAS_CONFIG_KEY_APPSECRET   @"appsecret"
#define EMAS_CONFIG_KEY_HOST        @"host"
#define EMAS_CONFIG_KEY_IP          @"ip"
#define EMAS_CONFIG_KEY_PORT        @"port"
#define EMAS_CONFIG_KEY_SERVICEID   @"serviceid"


@interface AccsConfiguration : NSObject

@property (nonatomic, strong)   NSString    *appkey;
@property (nonatomic, strong)   NSString    *appsecret;
@property (nonatomic, strong)   NSString    *host;
@property (nonatomic, strong)   NSString    *ip;
@property (nonatomic, strong)   NSString    *serviceId;
@property (nonatomic, assign)   NSInteger   port;

+ (instancetype)sharedInstance;

- (void)parseDict:(NSDictionary *)dict;

- (void)loadfile;

- (void)save;

@end
