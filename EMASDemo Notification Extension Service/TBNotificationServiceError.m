//
//  TBNotificationServiceError.m
//  Taobao4iPhone Notification Service Extension
//
//  Created by wuchen.xj on 2018/7/26.
//  Copyright © 2018年 Taobao.com. All rights reserved.
//

#import "TBNotificationServiceError.h"

@implementation TBNotificationServiceError

- (instancetype)initWithCode:(NSInteger)code withSubCode:(NSInteger)subcode withMessage:(NSString *)message {
    self = [super init];
    if (self) {
        _code = code;
        _subcode = subcode;
        _message = [message copy];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TBNotificationServiceError *copy = [[TBNotificationServiceError allocWithZone:nil]
                                        initWithCode:self.code
                                        withSubCode:self.subcode
                                        withMessage:self.message];
    
    
    return copy;
}

@end
