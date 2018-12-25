//
//  TestClass.m
//  AlicloudHotFixTestApp
//
//  Created by EMAS on 2017/9/18.
//  Copyright © 2017年 EMAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFXTestClass.h"

@implementation HFXTestClass

typedef void (^BlockType)(NSString *);

- (NSString *)output {
    NSLog(@"[TestClass] origin output.");
    return @"[TestClass] origin output.";
}

@end
