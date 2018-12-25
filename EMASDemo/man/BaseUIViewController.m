//
//  BaseUIViewController.m
//  EMASMANTestApp
//
//  Created by junmo on 2018/6/15.
//  Copyright © 2018年 junmo. All rights reserved.
//

#import <EMASMAN/EMASMANPageHitHelper.h>
#import "BaseUIViewController.h"

@interface BaseUIViewController ()

@end

@implementation BaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [[EMASMANPageHitHelper sharedInstance] pageAppear:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[EMASMANPageHitHelper sharedInstance] pageDisAppear:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
