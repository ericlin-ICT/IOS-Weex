//
//  OrangeRemoteConfigRootVC.m
//  test
//
//  Created by jiangpan on 2018/5/21.
//  Copyright © 2018年 jiangpan. All rights reserved.
//

#import "OrangeRemoteConfigRootVC.h"
#import "OrangeRemotConfigDebugVC.h"
//#import <NWNetworkConfiguration.h>
#import <NetworkCore/NWNetworkConfiguration.h>
#import "OrangeFeatureSecondVC.h"
#import <orange/Orange.h>
#import <orange/OrangeLog.h>
#import <orange/OrangeConfigCenter.h>
#import <orange/OrangeAccsCenter.h>
#import <TBAccsSDK/TBAccsManager.h>
//#import "Orange.h"
//#import "OrangeLog.h"
//#import "OrangeConfigCenter.h"
//#import "TBAccsManager.h"
//#import "OrangeAccsCenter.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface OrangeRemoteConfigRootVC () <UIAlertViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *appKey;
@property (weak, nonatomic) IBOutlet UITextField *appSecret;
@property (weak, nonatomic) IBOutlet UITextView *baseMsg;
@property (weak, nonatomic) IBOutlet UIButton *debugBtn;
@property (weak, nonatomic) IBOutlet UIButton *playDemoBtn;
@property (weak, nonatomic) IBOutlet UISwitch *accsSwitch;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;

@end

@implementation OrangeRemoteConfigRootVC

- (IBAction)accsSwitch:(id)sender {
    
    TBAccsManager *accsMgr = [TBAccsManager accsManagerByHost:getOrangeConfigCenter().getAccsHost];
    
    if (self.accsSwitch.isOn) {
        [OrangeAccsCenter run];
        
    }else {
        [accsMgr unbindServiceWithServiceId:@"orange" callBack:^(NSError *error, NSDictionary *resultsDict) {
            if (error) {
                

                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解绑ACCS Orange服务失败"
                                                                        message: error.description
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确认"
                                                              otherButtonTitles:@"取消", nil];
                    [alertView show];

                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解绑ACCS Orange服务成功"
                                                                        message:@"SUCCESS"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确认"
                                                              otherButtonTitles:@"取消", nil];
                     [alertView show];
                });

            }
        }];
    }
}

- (IBAction)save:(id)sender {
    NSLog(@"sava appkey & appsecret");
    
    
    if (self.appKey.text.length > 0 &&
            self.appSecret.text.length > 0) {
        
        NSString *indexKey = [NSString stringWithFormat:@"%d_appkey",[NWNetworkConfiguration shareInstance].netEnvironment];
        NSString *secretKey = [NSString stringWithFormat:@"%d_appSecret",[NWNetworkConfiguration shareInstance].netEnvironment];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.appKey.text forKey:indexKey];
        [userDefault setObject:self.appSecret.text forKey:secretKey];
        [userDefault synchronize];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"即将重启APP" message:@"设置APPKEY&APPSECRET成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alertView show];

    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        exit(0);
    }
}

- (IBAction)jumpToDebugVC:(id)sender {
    NSLog(@"jump to debugVC");
    OrangeRemotConfigDebugVC *debugVC = [[OrangeRemotConfigDebugVC alloc] initWithNibName:@"OrangeRemotConfigDebugVC" bundle:[NSBundle mainBundle]];
    debugVC.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController pushViewController:debugVC animated:YES];
    
}

- (IBAction)jumpToPlayVC:(id)sender {
    NSLog(@"jump to playVC");
    OrangeFeatureSecondVC *secondFeatureVC = [[OrangeFeatureSecondVC alloc] initWithNibName:@"OrangeFeatureSecondVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:secondFeatureVC animated:YES];
}

- (IBAction)cleanConfig:(id)sender {
    NWNetworkConfiguration *nwconfig = [NWNetworkConfiguration shareInstance];
    NSString *extension = @"oranges_config_content";
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator*e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if([[filename pathExtension] isEqualToString:extension]) {
            
            [fileMgr removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
    NSString *indexKey = [NSString stringWithFormat:@"%d_appkey",nwconfig.netEnvironment];
    NSString *secretKey = [NSString stringWithFormat:@"%d_appSecret",nwconfig.netEnvironment];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:indexKey];
    [userDefault removeObjectForKey:secretKey];
    [userDefault synchronize];
    
    exit(0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"远程配置";
    // Do any additional setup after loading the view from its nib.
    NWNetworkConfiguration *nwConfig = [NWNetworkConfiguration shareInstance];
    NSDictionary *msg = [Orange getKeyMap];
    self.baseMsg.text = [NSString stringWithFormat:@"UTDID : %@ \n应用版本号:%@\n系统版本号: %@ \n品牌 : Apple \n机型 : %@ \n\nAppKey : %@ \nHost : %@ \n ",msg[@"did"],msg[@"app_ver"],msg[@"os_ver"],msg[@"m_model"],nwConfig.appkey,[getOrangeConfigCenter() getApiServerDomain:OrangeApiGroupData]];
    self.baseMsg.editable = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.appKey.delegate = self;
    self.appSecret.delegate = self;
    self.appKey.text = nwConfig.appkey;
    self.appSecret.text = nwConfig.appSecret;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma clang diagnostic pop
