//
//  EMASNativeViewController.m
//  EMASWeexDemo
//
//  Created by daoche.jb on 2018/8/20.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASNativeViewController.h"
#import "UIViewController+EMASWXNaviBar.h"

@interface EMASNativeViewController ()

@end

@implementation EMASNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *item = [self leftBarButtonItem];
        self.navigationItem.rightBarButtonItem = item;
    }
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
