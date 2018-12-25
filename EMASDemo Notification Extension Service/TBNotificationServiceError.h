//
//  TBNotificationServiceError.h
//  Taobao4iPhone Notification Service Extension
//
//  Created by wuchen.xj on 2018/7/26.
//  Copyright © 2018年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSE_DOWNLOAD_IMAGE_FAILED       1001

#define NSE_REMOVE_EXISTED_IMAGE_FAILED 1002

#define NSE_COPY_IMAGE_FAILED           1003

@interface TBNotificationServiceError : NSObject

@property (nonatomic, assign, readonly) NSInteger   code;
@property (nonatomic, assign, readonly) NSInteger   subcode;
@property (nonatomic, strong, readonly) NSString    *message;

- (instancetype)initWithCode:(NSInteger)code withSubCode:(NSInteger)subcode withMessage:(NSString *)message;

@end

#define TB_NS_ERROR(code, subcode, message) \
    [[TBNotificationServiceError alloc] initWithCode:code withSubCode:subcode withMessage:message]

