//
//  ConfigurationViewController.m
//  TBAccsSDKDemo
//
//  Created by wuchen.xj on 2018/5/28.
//  Copyright © 2018年 ZhuoLaiQiang. All rights reserved.
//

#import "ACCSSettingViewController.h"
#import "AccsConfiguration.h"
#import "WQCodeScanner.h"
#import <UIKit/UIKit.h>

@interface ACCSSettingViewController ()

@property(nonatomic, strong) IBOutlet UITextField   *tfAppkey;
@property(nonatomic, strong) IBOutlet UITextField   *tfAppsecret;

@property(nonatomic, strong) IBOutlet UITextField   *tfHost;
@property(nonatomic, strong) IBOutlet UITextField   *tfIP;
@property(nonatomic, strong) IBOutlet UITextField   *tfPort;
@property(nonatomic, strong) IBOutlet UITextField   *tfServiceID;

@end

@implementation ACCSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateConfigurationDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)updateConfigurationDisplay {
    AccsConfiguration *config = [AccsConfiguration sharedInstance];
    [_tfAppkey setText:config.appkey];
    [_tfAppsecret setText:config.appsecret];
    [_tfServiceID setText:config.serviceId];
    [_tfHost setText:config.host];
    [_tfIP setText:config.ip];
    [_tfPort setText:[NSString stringWithFormat:@"%ld", config.port]];
}

- (IBAction)onReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onQrScan:(id)sender {
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    [self presentViewController:scanner animated:YES completion:nil];
    
    __weak id wself = self;
    
    scanner.resultBlock = ^(NSString *value) {
        NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        [[AccsConfiguration sharedInstance] parseDict:dict];
        [wself updateConfigurationDisplay];
    };
}

- (IBAction)onSave:(id)sender {
    NSString *appkey = [_tfAppkey text];
    if (appkey.length == 0) {
        [self alertTitle:@"错误" message:@"请输入Appkey!"];
        return;
    }
    
    NSString *appsecret = [_tfAppsecret text];
    if (appsecret.length == 0) {
        [self alertTitle:@"错误" message:@"请输入Appsecret!"];
        return;
    }
    
    NSString *serviceId = [_tfServiceID text];
    if (serviceId.length == 0) {
        [self alertTitle:@"错误" message:@"请输入Service ID!"];
        return;
    }
    
    NSString *host = [_tfHost text];
    if (host.length == 0) {
        [self alertTitle:@"错误" message:@"请输入Host!"];
        return;
    }
    
    NSString *ip = [_tfIP text];
    if (ip.length == 0) {
        [self alertTitle:@"错误" message:@"请输入IP!"];
        return;
    }
    
    NSString *port = [_tfPort text];
    if (port.length == 0) {
        [self alertTitle:@"错误" message:@"请输入Port!"];
        return;
    }
    
    AccsConfiguration *config = [AccsConfiguration sharedInstance];
    [config setAppkey:appkey];
    [config setAppsecret:appsecret];
    [config setServiceId:serviceId];
    [config setHost:host];
    [config setIp:ip];
    [config setPort:[port integerValue]];
    
    [config save];
    
    [self alertTitle:@"提示" message:@"保存成功！使用新配置请重启APP，是否现在重启?"];
}

- (void)alertTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:(id)self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [UIView beginAnimations:@"exitApplication" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        self.view.window.bounds = CGRectMake(0, 0, 0, 0);
        [UIView commitAnimations];
    }
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

@end
