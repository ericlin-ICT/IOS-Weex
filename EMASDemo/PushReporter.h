//
//  PushReporter.h
//  EMASDemo
//
//  Created by aegaeon on 2018/11/22.
//  Copyright © 2018 EMAS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushReporter : NSObject
+ (void)reportMessageTaped:(NSString *)messageId;
+ (void)reportMessageArrived:(NSString *)messageId;
@end

NS_ASSUME_NONNULL_END
