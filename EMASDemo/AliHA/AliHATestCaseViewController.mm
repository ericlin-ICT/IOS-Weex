//
//  AliHATestCaseViewControllerTableViewController.m
//  EMASDemo
//
//  Created by EMAS on 2017/12/26.
//  Copyright © 2017年 EMAS. All rights reserved.
//

#import "AliHATestCaseViewController.h"
#import <AliHACore/AliHA.h>
#import <TRemoteDebugger/TRDManagerService.h>
#import <TRemoteDebugger/TBClientDrivingPushTLogExec.h>
#import <BizErrorReporter4iOS/BizErrorReporter.h>
#import <WeexSDK/WeexSDK.h>
#import <UT/AppMonitorStat.h>

static NSString* INSTANCE_ID        = @"instanceId";
static NSString* FRAMEWORK_VERSION  = @"frameWorkVersion";
static NSString* ERROR_CODE         = @"errorCode";
static NSString* PAGE_USER_PATH     = @"pageUserPath";

@interface TestCycleRootObject : NSObject

@end


#define  TestObjectClass(x) \
@interface TestObject##x : TestCycleRootObject \
@property (nonatomic, strong) id object;\
@property (nonatomic, strong) id secondObject;\
@end\
@implementation TestObject##x\
@end\

TestObjectClass(1)
TestObjectClass(2)
TestObjectClass(3)
TestObjectClass(4)
TestObjectClass(5)
TestObjectClass(6)
TestObjectClass(7)

@interface AliHATestCaseViewController ()

@end

@implementation AliHATestCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"reuseIdentifier"];
    }
    
    switch (indexPath.row) {
            case 0:
        {
            cell.textLabel.text = @"全堆栈Crash";
            cell.textLabel.textColor = [UIColor redColor];
        }
            break;
            case 1:
        {
            cell.textLabel.text = @"Abort";
            cell.textLabel.textColor = [UIColor orangeColor];
        }
            break;
            case 2:
        {
            cell.textLabel.text = @"上报JSError";
            cell.textLabel.textColor = [UIColor blueColor];
        }
            break;
            case 3:
        {
            cell.textLabel.text = @"主动上报tlog";
            cell.textLabel.textColor = [UIColor blueColor];
        }
            break;
            case 4:
        {
            cell.textLabel.text = @"检查远程日志任务";
            cell.textLabel.textColor = [UIColor blueColor];
        }
            break;
            case 5:
        {
            cell.textLabel.text = @"触发卡顿";
            cell.textLabel.textColor = [UIColor redColor];
        }
            break;
            case 6:
        {
            cell.textLabel.text = @"上报Full Trace";
            cell.textLabel.textColor = [UIColor redColor];
        }
            break;
            case 7:
        {
            cell.textLabel.text = @"检查循环引用（切后台上报，针对iOS11以下设备）";
            cell.textLabel.textColor = [UIColor redColor];
        }
            break;
            case 8:
        {
            cell.textLabel.text = @"上报埋点";
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
            case 0:
        {
            // full stack crash
            NSMutableArray *array = @[];
            [array addObject:nil];
            break;
        }
            
            case 1:
        {
            // abort
            exit(0);
            break;
        }
            case 2:
        {
            [self handleJsError:[[WXJSExceptionInfo alloc] initWithInstanceId:@"001" bundleUrl:@"www.taobao.com/demo.js" errorCode:@"www.taobao.com/demo.js" functionName:@"sayHello" exception:@"undefined function sayHello" userInfo:nil]];
        }
            break;
            
            case 3:
        {
            // upload tlog
            [TBClientDrivingPushTLogExec uploadTLogAction:@{@"REASON": @"STARTUP_SLOW"}];
            break;
        }
            case 4:
        {
            [kTRDCmdServiceInstance.messageDelegate pullData:kTRDCmdServiceInstance.context.appKey deviceId:kTRDCmdServiceInstance.context.utdid resultsBlock:^(NSError *error, RemoteDebugResponse *response) {
                if (!error && response) {
                    RemoteDebugRequest *request = [[RemoteDebugRequest alloc] init];
                    request.headers = response.headers;
                    request.data = response.data;
                    request.appId = response.appId;
                    request.version = response.version;
                    [kTRDCmdServiceInstance handleRemoteCommand:request];
                }
            }];
            break;
        }
            case 5:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:30];
            });
        }
            break;
            case 6:
        {
            AliHA *haInstance = [AliHA shareInstance];
            if ([haInstance respondsToSelector:NSSelectorFromString(@"scanExistingTraceFiles")]) {
                [haInstance performSelector:NSSelectorFromString(@"scanExistingTraceFiles")];
            }
        }
            break;
            case 7:
        {
            [self testCycle];
            NSLog(@"xxxxxxxxxxxx");
        }
            break;
            case 8:
        {
            [self testPointReport];
        }
            break;
        default:
            break;
            
    }
}

- (void)testCycle{
    static NSMutableArray *strongArray = nil;
    if(!strongArray){
        strongArray = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < 6; ++i) {
        TestObject1 *testObject1 = [TestObject1 new];
        TestObject2 *testObject2 = [TestObject2 new];
        TestObject3 *testObject3 = [TestObject3 new];
        TestObject4 *testObject4 = [TestObject4 new];
        TestObject5 *testObject5 = [TestObject5 new];
        TestObject6 *testObject6 = [TestObject6 new];
        TestObject7 *testObject7 = [[TestObject7 alloc] init];
        
        
        
        testObject1.object = testObject2;
        testObject1.secondObject = testObject3;
        testObject2.object = testObject4;
        testObject2.secondObject = testObject5;
        testObject3.object = testObject1;
        testObject5.object = testObject6;
        testObject4.object = testObject1;
        testObject5.secondObject = testObject7;
        testObject7.object = testObject2;
        [strongArray addObject:testObject1];
    }
}

- (void)handleJsError:(WXJSExceptionInfo *)exception {
    MotuReportAdapteHandler* handler = [[MotuReportAdapteHandler alloc]init];
    
    AdapterExceptionModule* exceptionModule = [[AdapterExceptionModule alloc] init];
    exceptionModule.customizeBusinessType = @"WEEX_ERROR";
    exceptionModule.aggregationType = ADAPTER_CONTENT;
    
    //统计维度, weex不要按errorcode聚合，没关系，我把url设置到errcode里去
    NSString * bundleUrl = exception.bundleUrl;
    if (bundleUrl == nil) {
        //这个不能为空
        bundleUrl = @"UnKnown";
    }
    exceptionModule.exceptionDetail = bundleUrl;
    NSString* code = @"www.taobao.com/demo.js";
    exceptionModule.exceptionCode = code;
    
    NSString * sdkVersion = exception.sdkVersion;
    if (sdkVersion != nil) {
        exceptionModule.exceptionVersion = sdkVersion;
    }
    NSString * exceptionContent = exception.exception;
    if (exceptionContent != nil) {
        exceptionModule.exceptionArg1 = exceptionContent;
    }
    NSString * functionName = exception.functionName;
    if (functionName != nil) {
        exceptionModule.exceptionArg2 = functionName;
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * userInfo = exception.userInfo;
    if (userInfo != nil) {
        [dic addEntriesFromDictionary:userInfo];
    }
    NSString* instanceId = exception.instanceId;
    if (instanceId != nil) {
        [dic setObject:instanceId forKey:INSTANCE_ID];
    }
    NSString * errorCode = exception.errorCode;
    if (errorCode != nil) {
        [dic setObject:errorCode forKey:ERROR_CODE];
    }
    NSString * jsfmVersion = exception.jsfmVersion;
    if (jsfmVersion != nil) {
        [dic setObject:jsfmVersion forKey:FRAMEWORK_VERSION];
    }
    //增加用户轨迹
    NSString * userPage = @"DemoPage";
    if(userPage != nil){
        [dic setObject:userPage forKey:PAGE_USER_PATH];
    }
    exceptionModule.exceptionArgs = dic;
    
    [handler adapterWithExceptionModule:exceptionModule];
}

- (void)testPointReport
{
    // 定义维度集合
    AppMonitorDimensionSet  *dimensionSet = [[AppMonitorDimensionSet alloc] init];
    [dimensionSet addDimensionWithName:@"isVip"];
    
    // 定义指标集合
    AppMonitorMeasureSet    *measureSet = [[AppMonitorMeasureSet alloc] init];
    //添加指标，默认取值范围大于等于0
    [measureSet   addMeasureWithName:@"tokenLost"];
    
    //注册埋点 "network"对应埋点配置-模块；"responseTime"对应埋点配置-监控点
    [AppMonitorStat registerWithModule:@"vipmonitor" monitorPoint:@"tokenerror" measureSet:measureSet dimensionSet:dimensionSet];
    
    for (int i = 0; i < 2000; i++)
    {
        NSString *isVip = nil;
        double tokenLost;
        if (i % 4 == 0) {
            isVip = @"true";
            tokenLost = 1;
        } else if (i % 4 == 1){
            isVip = @"false";
            tokenLost = 1;
        } else if (i % 4 == 2) {
            isVip = @"false";
            tokenLost = 0;
        } else {
            isVip = @"true";
            tokenLost = 0;
        }
        // 增加setValue添加维度、指标
        AppMonitorDimensionValueSet *dimensionValues = [[AppMonitorDimensionValueSet alloc] init];
        [dimensionValues setValue:isVip forName:@"isVip"];
        
        AppMonitorMeasureValueSet  *measureValues = [[AppMonitorMeasureValueSet alloc] init];
        AppMonitorMeasureValue *measureValue = [[AppMonitorMeasureValue alloc] initWithValue:[NSNumber numberWithDouble:tokenLost]];
        [measureValues setValue:measureValue forName:@"tokenLost"];
        
        // 多维度多指标，最通用
        [AppMonitorStat commitWithModule:@"vipmonitor" monitorPoint:@"tokenerror" dimensionValueSet:dimensionValues measureValueSet:measureValues];
    }
}

@end

