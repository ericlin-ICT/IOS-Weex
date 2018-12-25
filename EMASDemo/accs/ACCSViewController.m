//
//  AccsViewController.m
//  EMASDemo
//
//  Created by wuchen.xj on 2018/6/20.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "ACCSViewController.h"
#import "ACCSSettingViewController.h"

#import "TBAccsSDK/TBAccsConfiguration.h"
#import "TBAccsSDK/TBAccsManager.h"
#import "TBAccsSDK/TBAccsSDKLogUtil.h"
#import "TBAccsSDK/AccsProtocol.h"
#import "TBAccsSDK/TBAccsConfiguration.h"
#import "TBAccsSDK/TBAccsRequestContext.h"
#import "TBAccsSDK/AccsProtocol.h"
#import "TBAccsSDK/TBAccsSDKLogUtil.h"
#import "AccsConfiguration.h"

#import <NetworkSDK/NetworkCore/NWNetworkConfiguration.h>
#import <NetworkSDK/AliReachability/NWLog.h>

#define EMAS_ACCS_PREPARE_HOST      @"aserver-pre-k8s.emas-poc.com"
#define EMAS_ACCS_PREPARE_IP        @"47.97.186.202"
#define EMAS_ACCS_PREPARE_PORT      30080

@interface ACCSViewController ()

@property(nonatomic, strong) IBOutlet UILabel       *lbConnectStatus;
@property(nonatomic, strong) IBOutlet UITextField   *tfUserID;
@property(nonatomic, strong) IBOutlet UITextField   *tfMessage;
@property(nonatomic, strong) IBOutlet UITextField   *tfUtdid;
@property(nonatomic, strong) IBOutlet UITextView    *tvUp;
@property(nonatomic, strong) IBOutlet UITextView    *tvDown;

@property(nonatomic, strong) TBAccsManager          *accsManager;
@property(nonatomic, strong) NSDateFormatter        *dateFormatter;

@end

@implementation ACCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDateFormater];
    
    // 打开日志
    tbAccsSDKSwitchLog(YES);
    [NWLog setLogLevel:NW_LOG_DEBUG];
    
    AccsConfiguration *config = [AccsConfiguration sharedInstance];
    [config loadfile];
    
    // 注册ACCS通道通断事件
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onAccsStatusChanged:)
                                                 name: k_Accs_Aisle_OK // ACCS 通道连接成功
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onAccsStatusChanged:)
                                                 name: k_Accs_Aisle_NO // ACCS 通道断开
                                               object: nil];
    
    // 设置环境: 线上 release, 预发 releaseDebug, 日常：daily
    [[NWNetworkConfiguration shareInstance] setIsEnableAMDC:NO];
    
    TBAccsConfiguration *ac = [[TBAccsConfiguration alloc] initWithHost:config.host];
    ac.appkey = config.appkey;
    ac.appsecret = config.appsecret;
    ac.defaultIP = config.ip;
    ac.defaultPort = config.port;
    ac.slightSSLPublickeyIndex = ACCS_PUBKEY_PSEQ_EMAS;
    
    _accsManager = [TBAccsManager createAccsWithConfiguration:ac];
    [_accsManager startAccs];
    
    // bind app
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self bindApp];
        [self bindService:nil];
    });
    
    // 显示utdid
    NSString *utdid = [NWNetworkConfiguration shareInstance].utdid;
    [self.tfUtdid setText:utdid];
    NSLog(@"UTDID: %@", utdid);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initDateFormater {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (IBAction)onSettingClicked:(id)sender {
    ACCSSettingViewController *svc = [[ACCSSettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)onAccsStatusChanged:(NSNotification *)noti {
    if ([noti.name isEqualToString:k_Accs_Aisle_OK]) {
        [self updateNetworkStatus:YES];
    }
    else if ([noti.name isEqualToString:k_Accs_Aisle_NO]) {
        [self updateNetworkStatus:NO];
    }
}

- (IBAction)bindApp
{
    double t = [NSDate timeIntervalSinceReferenceDate];
    NSString *tokenString = [NSString stringWithFormat: @"%f", t];
    [_accsManager bindAppWithAppleToken: [tokenString dataUsingEncoding: NSUTF8StringEncoding]
                               callBack: ^(NSError *error, NSDictionary *resultsDict) {
                                   if (error){
                                       NSString *txt = [NSString stringWithFormat:@">> [BIND APP] ERROR: %@", error];
                                       NSLog(@"%@", txt);
                                       [self displayText:txt inTextView:_tvUp];
                                   }
                                   else{
                                       NSString *txt = [NSString stringWithFormat:@">> [BIND APP] SUCCESS!"];
                                       NSLog(@"%@", txt);
                                       [self displayText:txt inTextView:_tvUp];
                                   }
                               }];
}


- (IBAction)bindUser:(id)sender {
    NSString *userId = [self.tfUserID text];
    if (userId.length == 0) {
        NSString *txt = [NSString stringWithFormat:@">> [BIND USER] The user id is invalid!"];
        NSLog(@"%@", txt);
        [self displayText:txt inTextView:_tvUp];
        return;
    }
    
    [_accsManager bindUserWithUserId:self.tfUserID.text
                            callBack:^(NSError *error, NSDictionary *resultsDict) {
                                if (error) {
                                    NSString *txt = [NSString stringWithFormat:@">> [BIND USER] ERROR: %@", error];
                                    NSLog(@"%@", txt);
                                    [self displayText:txt inTextView:_tvUp];
                                }
                                else{
                                    NSString *txt = [NSString stringWithFormat:@">> [BIND USER] SUCCESS!"];
                                    NSLog(@"%@", txt);
                                    [self displayText:txt inTextView:_tvUp];
                                }
                            }];
}

- (IBAction)unbindUser:(id)sender {
    [_accsManager unbindUserWithUserId:self.tfUserID.text
                              callBack:^(NSError *error, NSDictionary *resultsDict) {
                                  if (error) {
                                      NSString *txt = [NSString stringWithFormat:@">> [UNBIND USER] ERROR: %@", error];
                                      NSLog(@"%@", txt);
                                      [self displayText:txt inTextView:_tvUp];
                                  }
                                  else{
                                      NSString *txt = [NSString stringWithFormat:@">> [UNBIND USER] SUCCESS!"];
                                      NSLog(@"%@", txt);
                                      [self displayText:txt inTextView:_tvUp];
                                  }
                              }];
}


- (IBAction)bindService:(id)sender {
    AccsConfiguration *config = [AccsConfiguration sharedInstance];
    NSString *serviceId = config.serviceId;
    if (serviceId.length == 0) {
        NSString *txt = [NSString stringWithFormat:@">> [UNBIND SERVICE] The service id is invalid!"];
        NSLog(@"%@", txt);
        [self displayText:txt inTextView:_tvUp];
        return;
    }
    
    /**
     * 本DEMO模拟的是 手淘iphone bundle, 所以在测试下行消息的时候，使用Appkey: 21380790
     **/
    [_accsManager bindServiceWithServiceId:serviceId
                                  callBack:^(NSError *error, NSDictionary *resultsDict) {
                                      if (error) {
                                          NSString *txt = [NSString stringWithFormat:@">> [BIND SERVICE] ERROR: %@", error];
                                          NSLog(@"%@", txt);
                                          [self displayText:txt inTextView:_tvDown];
                                      }
                                      else{
                                          NSString *txt = [NSString stringWithFormat:@">> [BIND SERVICE] SUCCESS: %@", serviceId];
                                          NSLog(@"%@", txt);
                                          //[self displayText:txt inTextView:_tvDown];
                                      }
                                  }
                         receviceDataBlock:^(NSError *error, NSDictionary *resultsDict)
     {
         if (error) {
             NSString *txt = [NSString stringWithFormat:@">> [RECEIVE DATA] ERROR: %@", error];
             NSLog(@"%@", txt);
             [self displayText:txt inTextView:_tvDown];
         }
         else{
             NSString *dataId = [resultsDict objectForKey:@"dataId"];
             NSString *serviceId = [resultsDict objectForKey:@"serviceId"];
             NSData *payload = [resultsDict objectForKey:@"resultData"];
             NSString *payloadText = nil;
             if (payload) {
                 payloadText =  [[NSString alloc] initWithData:payload encoding:NSUTF8StringEncoding];
             }
             
             NSString *txt = [NSString stringWithFormat:@">> [RECEIVE DATA] : \n\tdataId : %@\n\tserviceId : %@\n\tpayload : %@",
                              dataId, serviceId, payloadText];
             
             NSLog(@"%@", txt);
             [self displayText:txt inTextView:_tvDown];
         }
     }];
}

- (IBAction)unbindService:(id)sender {
    [_accsManager unbindServiceWithServiceId:[AccsConfiguration sharedInstance].serviceId
                                    callBack:^(NSError *error, NSDictionary *resultsDict) {
                                        if (error) {
                                            NSString *txt = [NSString stringWithFormat:@">> [UNBIND SERVICE] ERROR: %@", error];
                                            NSLog(@"%@", txt);
                                            [self displayText:txt inTextView:_tvUp];
                                        }
                                        else{
                                            NSString *txt = [NSString stringWithFormat:@">> [UNBIND SERVICE] SUCCESS!"];
                                            NSLog(@"%@", txt);
                                            [self displayText:txt inTextView:_tvUp];
                                        }
                                    }];
}

- (IBAction)sendRequest:(id)sender {
    NSString *msg = @"hello world!";
    NSString *serviceId = [AccsConfiguration sharedInstance].serviceId;
    
    if (msg.length==0 || serviceId.length==0) {
        NSString *txt = [NSString stringWithFormat:@">> [SEND REQ] Please input service id and message!"];
        NSLog(@"%@", txt);
        [self displayText:txt inTextView:_tvUp];
        return;
    }
    
    
    [_accsManager sendRequestWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                            serviceId:serviceId
                               userId:@"wuchen.xj"
                               routID:nil
                              timeout:30 // 单位: S
                             callBack:^(NSError *error, NSDictionary *resultDict){
                                 if (error) {
                                     NSString *txt = [NSString stringWithFormat:@">> [SEND REQ] ERROR: %@", error];
                                     NSLog(@"%@", txt);
                                     [self displayText:txt inTextView:_tvUp];
                                 }
                                 else {
                                     
                                     NSString *txt = nil;
                                     NSData *data = [resultDict objectForKey:@"resultData"];
                                     
                                     if ( data ) {
                                         NSString *dataTxt = [[NSString alloc]  initWithData:data encoding: NSUTF8StringEncoding];
                                         NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dataTxt doubleValue]/1000.0f];
                                         
                                         txt = [NSString stringWithFormat:@">> [SERVER RESPONSE] : \n %@", [_dateFormatter stringFromDate:date]];
                                     }
                                     else {
                                         txt = [NSString stringWithFormat:@">> [SERVER RESPONSE] SUCCESS, without payload!"];
                                     }
                                     
                                     NSLog(@"%@", txt);
                                     [self displayText:txt inTextView:_tvUp];
                                 }
                             }];
}

- (void)displayText:(NSString*)text inTextView:(UITextView *)tv {
    if (text.length == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tv insertText:text];
        [tv insertText:@"\n"];
    });
    
}

- (void)updateNetworkStatus:(BOOL)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status) {
            [self.lbConnectStatus setText:@"连接状态: CONNECTED"];
            [self.lbConnectStatus setTextColor:[UIColor greenColor]];
        }
        else {
            [self.lbConnectStatus setText:@"连接状态: UNCONNECTED"];
            [self.lbConnectStatus setTextColor:[UIColor redColor]];
        }
    });
}

@end
