//
//  ViewController.m
//  EMASMANTestApp
//
//  Created by junmo on 2018/6/13.
//  Copyright © 2018年 junmo. All rights reserved.
//

#import <TBRest/TBRestConfiguration.h>
#import <TBRest/TBRestSendService.h>
#import <EMASMAN/EMASMAN.h>
#import <UT/UTAnalytics.h>
#import <UT/AppMonitor.h>
#import "TestUIViewController.h"
#import "MANViewController.h"
#import "EMASService.h"

static NSString *scheme = @"https";

@interface MANViewController ()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;

@property (nonatomic, strong) EMASMANService *manService;
@property (nonatomic, copy) NSString *registerUserNick;

@end

@implementation MANViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"数据分析";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat xStart = 50;
    CGFloat yStart = 100;
    CGFloat yInterval = 50;
    CGFloat width = 200;
    CGFloat height = 40;
    
    _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button1.frame = CGRectMake(xStart, yStart += yInterval, width, height);
    _button1.backgroundColor = [UIColor blackColor];
    _button1.tintColor = [UIColor whiteColor];
    [_button1 setTitle:@"SDK初始化" forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(initMAN) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button2.frame = CGRectMake(xStart, yStart += yInterval, width, height);
    _button2.backgroundColor = [UIColor blackColor];
    _button2.tintColor = [UIColor whiteColor];
    [_button2 setTitle:@"页面辅助埋点" forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(testPageHitHelper) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_button2];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button3.frame = CGRectMake(xStart, yStart += yInterval, width, height);
    _button3.backgroundColor = [UIColor blackColor];
    _button3.tintColor = [UIColor whiteColor];
    [_button3 setTitle:@"页面基础埋点" forState:UIControlStateNormal];
    [_button3 addTarget:self action:@selector(testPageHitBuilder) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_button3];
    
    _button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button4.frame = CGRectMake(xStart, yStart += yInterval, width, height);
    _button4.backgroundColor = [UIColor blackColor];
    _button4.tintColor = [UIColor whiteColor];
    [_button4 setTitle:@"自定义埋点" forState:UIControlStateNormal];
    [_button4 addTarget:self action:@selector(testCustomHitBuilder) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_button4];
    
    _button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button5.frame = CGRectMake(xStart, yStart += yInterval, width, height);
    _button5.backgroundColor = [UIColor blackColor];
    _button5.tintColor = [UIColor whiteColor];
    [_button5 setTitle:@"用户注册" forState:UIControlStateNormal];
    [_button5 addTarget:self action:@selector(testUserRegister) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_button5];
    
    _button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button6.frame = CGRectMake(xStart, yStart += yInterval, width, height);
    _button6.backgroundColor = [UIColor blackColor];
    _button6.tintColor = [UIColor whiteColor];
    [_button6 setTitle:@"用户登录" forState:UIControlStateNormal];
    [_button6 addTarget:self action:@selector(testUserLogin) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_button6];
}

- (void)initMAN {
    // UT初始化部分
    [[UTAnalytics getInstance] turnOffCrashHandler];
    // 打开调试日志
    [[UTAnalytics getInstance] turnOnDebug];
    //scheme指定了埋点上报组件的请求协议，可以是https或者http
    [[UTAnalytics getInstance] setTimestampHost:[[EMASService shareInstance] HATimestampHost] scheme:scheme];
    [[UTAnalytics getInstance] setAppKey:[[EMASService shareInstance] appkey] secret:[[EMASService shareInstance] appSecret]];
    // 调试使用，上报不采样，建议正式发布版本不要这么做
    [AppMonitor disableSample];
    
    // 上报配置
    TBRestConfiguration *restConfiguration = [[TBRestConfiguration alloc] init];
    restConfiguration.appkey = [[EMASService shareInstance] appkey];
    restConfiguration.appVersion = [[EMASService shareInstance] getAppVersion];
    restConfiguration.channel = [[EMASService shareInstance] ChannelID];
    restConfiguration.usernick = @"emas-ha"; // nick根据app实际情况填写
    restConfiguration.dataUploadScheme = scheme;
    restConfiguration.dataUploadHost = [[EMASService shareInstance] HAUniversalHost];
    [[TBRestSendService shareInstance] configBasicParamWithTBConfiguration:restConfiguration];
    
    _manService = [EMASMANService sharedInstance];
    [_manService initWithAppKey:[[EMASService shareInstance] appkey] appSecret:[[EMASService shareInstance] appSecret]];
    [_manService enableLog:true];
    [_manService setAppVersion:[[EMASService shareInstance] getAppVersion]];
    [_manService setChannel:[[EMASService shareInstance] ChannelID]];
}

- (void)testPageHitHelper {
    TestUIViewController *testVC = [[TestUIViewController alloc] init];
    [self presentViewController:testVC animated:YES completion:nil];
}

- (void)testPageHitBuilder {
    EMASMANPageHitBuilder *pageHitBuilder = [[EMASMANPageHitBuilder alloc] init];
    [pageHitBuilder setPageName:@"testPage"];
    [pageHitBuilder setReferPage:@"testReferPage"];
    [pageHitBuilder setDurationOnPage:1000];
    [pageHitBuilder setProperty:@"pageKey1" value:@"pageValue1"];
    [pageHitBuilder setProperty:@"pageKey2" value:@"pageValue2"];
    [pageHitBuilder setProperties:@{ @"pageKey3" : @"pageValue3" }];
    [_manService send:[pageHitBuilder build]];
}

- (void)testCustomHitBuilder {
    EMASMANCustomHitBuilder *customHitBuilder = [[EMASMANCustomHitBuilder alloc] init];
    [customHitBuilder setEventLabel:@"testEventLable"];
    [customHitBuilder setEventPage:@"testEventPage"];
    [customHitBuilder setDurationOnEvent:1234];
    [customHitBuilder setProperty:@"key1" value:@"value1"];
    [customHitBuilder setProperty:@"key2" value:@"value2"];
    [customHitBuilder setProperty:@"key3" value:@"value3"];
    [customHitBuilder setProperties:@{ @"key4" : @"value4" }];
    [_manService send:[customHitBuilder build]];
}

- (void)testUserRegister {
    _registerUserNick = [NSString stringWithFormat:@"userNick-%f", [[NSDate date] timeIntervalSince1970]];
    [_manService userRegister:_registerUserNick];
    [self showAlert:@"提示" content:[NSString stringWithFormat:@"注册用户名: %@", _registerUserNick]];
}

- (void)testUserLogin {
    [_manService userLogin:_registerUserNick userId:_registerUserNick];
}

- (void)showAlert:(NSString *)title content:(NSString *)content {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    if ([NSThread isMainThread]) {
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
