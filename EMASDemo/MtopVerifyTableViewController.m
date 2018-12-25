//
//  MtopVerifyTableViewController.m
//  EMASDemo
//
//  Created by zhishui.lcq on 2018/4/9.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "MtopVerifyTableViewController.h"
#import <mtopext/MtopCore/MtopService.h>
#import <mtopext/MtopCore/MtopExtRequest.h>
#import "MtopResultViewController.h"
#import "MtopCustomCell.h"
#import <TBAccsSDK/TBAccsManager.h>
#import "EMASService.h"


static NSString *TableSampleIdentifier1 = @"TableSampleIdentifier1";
static NSString *TableSampleIdentifier2 = @"TableSampleIdentifier2";
static NSString *TableSampleIdentifier3 = @"TableSampleIdentifier3";
static NSString *TableSampleIdentifier4 = @"TableSampleIdentifier4";

//static int paramRowsInSection = 7;
//static BOOL isFirstLoad = YES;

@interface MtopVerifyTableViewController () <MtopExtRequestDelegate>

@property (nonatomic,strong) NSMutableDictionary *requestData;
@property (nonatomic,strong) NSMutableArray *defaultParamData;
@property (nonatomic,assign) int paramRowsInSection;


@end

@implementation MtopVerifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _paramRowsInSection = 7;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"验证MTOP";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addParamDataSource)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _defaultParamData = @[@{@"testBool":@[@"true",@"Bool"]},
                          @{@"testInteger":@[@"2",@"Integer"]},
                          @{@"testBoolean":@[@"false",@"Bool"]},
                          @{@"testDoub":@[@"1.1",@"Double"]},
                          @{@"testStr":@[@"test+str",@"String"]},
                          @{@"testInt":@[@"1",@"Int"]},
                          @{@"testDouble":@[@"1.2",@"Double"]}].mutableCopy;
    [self registerCustomCell];
    
}

- (NSMutableDictionary *)requestData {
    if (_requestData == nil) {
        _requestData = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _requestData;
}

- (void)registerCustomCell {
    [self.tableView registerClass:[MtopCustomCell1 class] forCellReuseIdentifier:TableSampleIdentifier1];
    [self.tableView registerClass:[MtopCustomCell2 class] forCellReuseIdentifier:TableSampleIdentifier2];
    [self.tableView registerClass:[MtopCustomCell3 class] forCellReuseIdentifier:TableSampleIdentifier3];
    [self.tableView registerClass:[MtopCustomCell4 class] forCellReuseIdentifier:TableSampleIdentifier4];
}

- (void)addParamDataSource {
    self.paramRowsInSection += 1;
    [self.tableView reloadData];
}

#pragma mark - Table view Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.paramRowsInSection -= 1 ;
        if (self.defaultParamData.count >= (indexPath.row + 1) ) {
            [self.defaultParamData removeObjectAtIndex:indexPath.row];
        }
        // 刷新
        MtopCustomCell2 *cell2 = [tableView cellForRowAtIndexPath:indexPath];
        // 清空cell数据
        cell2.selectedType = nil;
        cell2.paramType.text = nil;
        cell2.paramValue.text = nil;
        cell2.paramName.text = nil;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
         return @"删除";
    }
    return @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return self.paramRowsInSection;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0: {
            cell = (MtopCustomCell1 *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier1];
            if (cell == nil) {
                cell = [(MtopCustomCell1 *)[MtopCustomCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier1];
            }
            if (indexPath.row == 0) {
                ((MtopCustomCell1 *)cell).textFiled.placeholder = @"输入网关IP和PORT (IP地址:端口号)";
                ((MtopCustomCell1 *)cell).textFiled.text = @"gw.emas-poc.com"; // 设置默认值
            }
            if (indexPath.row == 1) {
                ((MtopCustomCell1 *)cell).textFiled.placeholder = @"输入API名称及版本 (apiName/apiVersion)";
                //((MtopCustomCell1 *)cell).textFiled.text = @"mtop.bizmock.test.passbody.http/1.0";
                ((MtopCustomCell1 *)cell).textFiled.text = @"mtop.bizmock.test.simpleParam.http/1.0";
            }
        }
            break;
            
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier2];
            if (cell == nil) {
                cell = [[MtopCustomCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier2];
            }
            
            MtopCustomCell2 *cell2 = (MtopCustomCell2 *)cell;
            
            if (self.defaultParamData.count >= (indexPath.row + 1)) {
                NSDictionary *dict = [self.defaultParamData objectAtIndex:indexPath.row];
                for (NSString *key in dict.allKeys) {
                    cell2.paramName.text = key;
                    NSArray *result = dict[key];
                    cell2.paramType.text = [result objectAtIndex:1];
                    cell2.paramValue.text = [result objectAtIndex:0];
                    cell2.selectedType = [result objectAtIndex:1];
                }
            }
        }
            break;
            
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier3];
            if (cell == nil) {
                cell = [[MtopCustomCell3 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier3];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"选择请求Mehtod";
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            cell.detailTextLabel.text = @"GET请求";
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
        }
    
            break;
        
        case 3: {
            cell = (MtopCustomCell4 *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier4];
            if (cell == nil) {
                cell = [(MtopCustomCell4 *)[MtopCustomCell4 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier4];
            }
        }
            
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        // 选中第二分组
        [self showAlertUIWithTable:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    if (indexPath.section == 3) {
        // 发送MTOP请求
        [self sendMtopRequest:tableView];
    }
    
}

- (void)sendMtopRequest:(UITableView *)tableView {

    NSIndexPath *indexPathForCell1 = [NSIndexPath indexPathForRow:0 inSection:0];
    MtopCustomCell1 *cell1 = [tableView cellForRowAtIndexPath:indexPathForCell1];
    if (cell1.textFiled.text.length == 0) {
        [self showAlert:NO desc:@"网关IP与端口不可为空!!"];
        return;
    }else {
        [self.requestData setObject:cell1.textFiled.text forKey:@"Domain"];
    }
    
    NSIndexPath *indexPathForCell2 = [NSIndexPath indexPathForRow:1 inSection:0];
    MtopCustomCell1 *cell2 = [tableView cellForRowAtIndexPath:indexPathForCell2];
    if (cell2.textFiled.text.length == 0) {
        [self showAlert:NO desc:@"API Name 与 API Verion 不可为空"];
        return;
    }else {
        [self.requestData setObject:cell2.textFiled.text forKey:@"API"];
    }
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i < self.paramRowsInSection ; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        MtopCustomCell2 *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.paramType.text.length != 0 &&
             cell.paramValue.text.length != 0 &&
                cell.paramName.text.length != 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:2];
            [dictM setObject:cell.paramType.text forKey:@"paramType"];
            [dictM setObject:cell.paramName.text forKey:@"paramName"];
            [dictM setObject:cell.paramValue.text forKey:@"paramValue"];
            [dataArray addObject:dictM];
        }else if (cell.paramName.text.length != 0){
            [self showAlert:NO desc:@"参数类型、参数值不可为空"];
            return;
        }
    }
    
    [self.requestData setObject:dataArray forKey:@"Data"];
    
    
    NSIndexPath *indexPahtForCell4 = [NSIndexPath indexPathForRow:0 inSection:2];
    MtopCustomCell3 *cell3 = [tableView cellForRowAtIndexPath:indexPahtForCell4];
    if (cell3.detailTextLabel.text.length == 0) {
        [self showAlert:NO desc:@"API Mtheod 请求方式不可为空"];
        return;
    }else {
        [self.requestData setObject:cell3.detailTextLabel.text forKey:@"Mtheod"];
    }
    
    NSLog(@"%@",self.requestData);
    
    MtopResultViewController *resultVc = [[MtopResultViewController alloc] initWithRequestData:self.requestData];
    [self.navigationController pushViewController:resultVc animated:YES];
}

- (void)showAlertUIWithTable:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* getAction = [UIAlertAction actionWithTitle:@"GET 请求" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:2];
                                                             MtopCustomCell3 *cell = [table cellForRowAtIndexPath:indexPath1];
                                                             cell.detailTextLabel.text = @"GET请求";
                                                         }];
    UIAlertAction* postAction = [UIAlertAction actionWithTitle:@"POST 请求" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           //响应事件
                                                           NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:2];
                                                           MtopCustomCell3 *cell = [table cellForRowAtIndexPath:indexPath1];
                                                           cell.detailTextLabel.text = @"POST请求";

                                                       }];
    
    [alert addAction:getAction];
    [alert addAction:cancelAction];
    [alert addAction:postAction];
    [self presentViewController:alert animated:YES completion:nil];


}



- (void)showAlert:(BOOL)isSuccess desc:(NSString *)desc
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:(isSuccess ? @"发送MTOP请求成功" : @"发送MTOP请求失败")
                                                        message:desc
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end
