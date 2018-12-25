//
//  TestUIViewController.m
//  EMASMANTestApp
//
//  Created by junmo on 2018/6/15.
//  Copyright © 2018年 junmo. All rights reserved.
//

#import <EMASMAN/EMASMANPageHitHelper.h>
#import "TestUIViewController.h"

@interface TestUIViewController ()

@end

@implementation TestUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 100, 300, 30);
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 设置页面扩展参数
    NSDictionary *pageProperties = @{ @"pageKey":@"pageValue" };
    [[EMASMANPageHitHelper sharedInstance] updatPage:self properties:pageProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
