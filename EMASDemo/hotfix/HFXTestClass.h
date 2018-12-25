//
//  TestClass.h
//  AlicloudHotFixTestApp
//
//  Created by EMAS on 2017/9/18.
//  Copyright © 2017年 EMAS. All rights reserved.
//

#ifndef TestClass_h
#define TestClass_h

@interface HFXTestClass : NSObject

- (NSString *)output;
- (void)blockTest;
- (void)blockListTest;
- (void)blockAsParam:(void (^)(NSString *make))block;
- (void)propertyTest;
- (void)methodTest;

@end

#endif /* TestClass_h */
