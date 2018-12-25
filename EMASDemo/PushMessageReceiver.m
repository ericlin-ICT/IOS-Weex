//
//  PushMessageReceiver.m
//  EMASDemo
//
//  Created by wuchen.xj on 2018/11/15.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "PushMessageReceiver.h"

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "PushReporter.h"

@implementation PushMessageReceiver

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSLog(@">>>>>>> [AGOO MESSAGE]: %@", userInfo);
    
    NSString *text = [userInfo description];
    if (!text ) {
        text = @"消息解析失败!";
    }
    
    NSString *messageId;
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
         messageId = [userInfo objectForKey:@"m"];
    }
    
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground) {
        if (@available(iOS 10.0, *)) {
            [self pushNotificationOniOS10:userInfo];
        } else {
            [self pushNotificationOnLessiOS10:userInfo];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AGOO 消息" message:text delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        if (messageId.length > 0) {
            [PushReporter reportMessageTaped:messageId];
        }
    }
}

- (void)pushNotificationOniOS10:(NSDictionary *)userInfo {
    if (@available(iOS 10.0, *)) {
        NSDictionary *aps = userInfo[@"aps"];
        if (!aps || ![aps isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSDictionary *alertDic = aps[@"alert"];
        if (!alertDic) {
            return;
        }
        
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        
        if ([alertDic isKindOfClass:[NSDictionary class]]) {
            NSString *body = [alertDic valueForKeyPath:@"body"];
            NSString *title = [alertDic valueForKeyPath:@"title"];
            NSString *subtitle = [alertDic valueForKeyPath:@"subtitle"];
            content.body = body;
            content.subtitle = subtitle;
            content.title = title;
        }
        
        if ([alertDic isKindOfClass:[NSString class]]) {
            content.title = (NSString *)alertDic;
        }
        
        NSNumber *badge = [userInfo valueForKeyPath:@"aps.badge"];
        if (badge) {
            content.badge = badge;
        } else {
            content.badge = @(1);
        }
        
        NSString *sound = [userInfo valueForKeyPath:@"aps.sound"];
        if (sound.length > 0) {
            if ([sound isEqualToString:@"default"]) {
                content.sound = [UNNotificationSound defaultSound];
            } else {
                content.sound = [UNNotificationSound soundNamed:@"hongbao.wav"];
            }
        }
        
        NSString *icon = userInfo[@"icon"];
        if (icon.length > 0) {
            NSURL *iconUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"icon_two_selected.png" ofType:nil]];
            
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment"
                                                                                                  URL:iconUrl
                                                                                              options:nil
                                                                                                error:nil];
            content.attachments = @[attachment];
        }
        
        content.userInfo = userInfo;
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                              content:content
                                                                              trigger:nil];
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }
}

- (void)pushNotificationOnLessiOS10:(NSDictionary *)userInfo {
    UILocalNotification *localNotification = [UILocalNotification new];
    NSDictionary *aps = userInfo[@"aps"];
    if (!aps || ![aps isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *alertDic = aps[@"alert"];
    if (!alertDic) {
        return;
    }
    
    if ([alertDic isKindOfClass:[NSDictionary class]]) {
        NSString *body = [alertDic valueForKeyPath:@"body"];
        NSString *title = [alertDic valueForKeyPath:@"title"];
        localNotification.alertBody = body;
        localNotification.alertTitle = title;
    }
    
    if ([alertDic isKindOfClass:[NSString class]]) {
        localNotification.alertTitle = (NSString *)alertDic;
    }
    
    NSNumber *badge = [userInfo valueForKeyPath:@"aps.badge"];
    if (badge) {
        localNotification.applicationIconBadgeNumber = badge.integerValue;
    } else {
        localNotification.applicationIconBadgeNumber = 0;
    }
    
    
    NSString *sound = [userInfo valueForKeyPath:@"aps.sound"];
    if (sound.length > 0) {
        localNotification.soundName = @"hongbao.wav";
    }
    
    NSString *icon = userInfo[@"icon"];
    if (icon.length > 0) {
        localNotification.alertLaunchImage = @"icon_two_selected.png";
    }
    
    localNotification.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
