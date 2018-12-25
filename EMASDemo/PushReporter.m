//
//  PushReporter.m
//  EMASDemo
//
//  Created by aegaeon on 2018/11/22.
//  Copyright © 2018 EMAS. All rights reserved.
//

#import "PushReporter.h"

#define SHARED_GROUP_NAME   @"group.com.emas.demo.push"

@implementation PushReporter

/**
 * 埋点等反馈信息上报专用线程，并发队列。
 */
+ (dispatch_queue_t)feedbackQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.taobao.notificationservice.extension.report", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

/**
 * 图片下载Session, 全局只有一个即可。
 */
+ (NSURLSession *)thumbnailSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    });
    
    return session;
}

+ (void)reportMessageTaped:(NSString *)messageId {
    [self reportMessageInfo:messageId withType:@"8"];
}

+ (void)reportMessageArrived:(NSString *)messageId {
    [self reportMessageInfo:messageId withType:@"4"];
}

+ (void)reportMessageInfo:(NSString *)messageId withType:(NSString *)type {
    __block NSString *t_msgid = [messageId copy];
    
    dispatch_async([PushReporter feedbackQueue], ^(){
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_NAME];
        NSString *appkey = [sharedDefaults objectForKey:@"TB_PUSH_EXTENSION_APPKEY"];
        NSString *agootoken = [sharedDefaults objectForKey:@"TB_PUSH_EXTENSION_AGOO_TOKEN"];
        NSString *reportHost = [sharedDefaults objectForKey:@"TB_PUSH_EXTENSION_AGOO_REPORT_HOST"];
        //        reportHost = @"agoo-ack.taobao.net";
        if (reportHost.length == 0) {
            NSLog(@"[NotificationService] the report HOST is empty!");
            return;
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:(appkey.length>0 ? appkey : @"") forKey:@"appkey"];
        [dict setValue:(agootoken.length>0 ? agootoken : @"") forKey:@"tbAppDeviceToken"];
        [dict setValue:(t_msgid.length>0 ? t_msgid : @"") forKey:@"id"];
        [dict setValue:type forKey:@"status"];
        
        
        NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        
        NSString *url = [NSString stringWithFormat:@"%@", reportHost];
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [req setHTTPMethod:@"POST"];
        [req setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [req setHTTPBody:body];
        
        NSURLSessionDataTask * task = [[PushReporter thumbnailSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if ( error ) {
                NSLog(@"[NotificationService] report error: %@", error);
            }
        }];
        [task resume];
    });
}

@end
