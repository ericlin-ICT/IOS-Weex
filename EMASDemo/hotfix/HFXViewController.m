//
//  ViewController.m
//  AlicloudHotFixTestApp
//
//  Created by EMAS on 2017/9/12.
//  Copyright © 2017年 EMAS. All rights reserved.
//

#import <AlicloudHotFixDebugEmas/AlicloudHotFixDebugServiceEmas.h>

#import "HFXViewController.h"
#import <AlicloudHotFixEmas/AlicloudHotFixServiceEmas.h>
#import "HFXTestClass.h"
#import "EMASService.h"

@interface HFXViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

static AlicloudHotFixServiceEmas *hotfixService;
//static NSString *const testAppId = @"10000064";
//static NSString *const testAppSecret = @"70c378f69aec7b295a373ef81528c8ea";

static NSArray *tableViewGroupNames;
static NSArray *tableViewCellTitleInSection;

static NSCondition *_condition;

@implementation HFXViewController

+ (void)initialize {
    tableViewGroupNames = @[ @"补丁测试", @"Patch加载", @"Patch调试工具"];
    tableViewCellTitleInSection = @[
                                    @[ @"补丁加载测试" ],
                                    @[ @"Patch拉取", @"Patch清空"],
                                    @[ @"本地补丁载入", @"二维码扫描" ],
                                  ];
    _condition = [[NSCondition alloc] init];
}

- (void)waitUtilFinished {
    [_condition lock];
    [_condition wait];
    [_condition unlock];
}

- (void)taskFinished {
    [_condition signal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"%@", path);
    
    [self initTableView];
    
    [self hotfixSdkInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化热修复
- (void)hotfixSdkInit {
    hotfixService = [AlicloudHotFixServiceEmas sharedInstance];
    [hotfixService setLogEnabled:YES];
    [hotfixService setServerURL:[[EMASService shareInstance] HotfixServerURL]];
    [hotfixService initWithAppId:[[EMASService shareInstance] appkey] appSecret:[[EMASService shareInstance] appSecret] callback:^(BOOL res, id data, NSError *error) {
        if (res) {
            NSLog(@"HotFix SDK init success.");
        } else {
            NSLog(@"HotFix SDK init failed, error: %@", error);
        }
    }];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)showAlert:(NSString *)title content:(NSString *)content {
    if ([NSThread isMainThread]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
}

#pragma mark TableView 数据源设置

/* Section Num */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableViewGroupNames.count;
}

/* Cell Num Each Section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[tableViewCellTitleInSection objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"cellId-%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self cellTitleForIndexPath:indexPath];
    return cell;
}

#pragma mark TableView 代理设置

/* Section Header Title */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return tableViewGroupNames[section];
}

/* Click Cell */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cellTitle = [self cellTitleForIndexPath:indexPath];
    if ([cellTitle isEqualToString:@"Patch拉取"]) {
        [self onLoadPatchClick];
    } else if ([cellTitle isEqualToString:@"Patch状态上报"]) {
        
    } else if ([cellTitle isEqualToString:@"补丁加载测试"]) {
        [self onPatchTestClick];
    } else if ([cellTitle isEqualToString:@"Patch清空"]) {
        [self onCleanPatchClick];
    } else if ([cellTitle isEqualToString:@"二维码扫描"]) {
        [self onQrCodeClick];
    } else if ([cellTitle isEqualToString:@"本地补丁载入"]) {
        [self onLoadLocalPatchClick];
    }
}

- (NSString *)cellTitleForIndexPath:(NSIndexPath *)indexPath {
    return [[tableViewCellTitleInSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)onPatchTestClick {
    HFXTestClass *testClass = [[HFXTestClass alloc] init];
    [self showAlert:@"Patch Test" content:[testClass output]];
}

- (void)onLoadPatchClick {
    [hotfixService loadPatch:^(BOOL res, id data, NSError *error) {
        if (res) {
            NSLog(@"Load patch success.");
        } else {
            NSLog(@"Load patch failed, error: %@", error);
        }
    }];
}

- (void)onReportStatusClick {
    
}

- (void)onCleanPatchClick {
    [hotfixService cleanPatch];
}

- (void)onQrCodeClick {
    [AlicloudHotFixDebugServiceEmas showDebug:self];
}

- (void)onLoadLocalPatchClick {
    [AlicloudHotFixDebugServiceEmas loadLocalPachFile:[[NSBundle mainBundle] pathForResource:@"fix" ofType:@"lua"]];
}

- (void)onPrintSandbox {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"%@", path);
}

- (void)onChantuTest {
    NSLog(@"in chantu test");
//    UIViewController *vc = [[TestViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.barStyle = UIBarStyleDefault;
//    [nav.navigationBar setBarTintColor:UIColor.whiteColor];
//    [nav.navigationBar setTranslucent:NO];
//    [self presentViewController:nav animated:YES completion:nil];
}

@end
