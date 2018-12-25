//
//  OrangeRemotConfigDebugVC.m
//  test
//
//  Created by jiangpan on 2018/5/21.
//  Copyright © 2018年 jiangpan. All rights reserved.
//

#import "OrangeRemotConfigDebugVC.h"
#import "CustomCell.h"
#import <orange/OrangeConfigModel.h>
#import <orange/OrangeTest.h>

static NSString* cellIdentity =   @"CustomCell";//cell的标识

@interface OrangeRemotConfigDebugVC () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataList;
@property (strong,nonatomic) NSDictionary *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freshBtn;

@end

@implementation OrangeRemotConfigDebugVC

- (IBAction)fresh:(id)sender {
    self.dataSource = [OrangeTest getDisplayConfig];
    [self.dataList reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.dataSource = [OrangeTest getDisplayConfig];
    self.dataList.dataSource = self;
    self.dataList.delegate = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSDictionary *)self.dataSource[@"config"]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell* cell = [CustomCell initTableViewCell:tableView andCellIdentify:cellIdentity];//调用初始化方法
    NSArray *keyArray = ((NSDictionary *) self.dataSource[@"config"]).allKeys;
    NSString *key = [keyArray objectAtIndex:indexPath.row];
    OrangeConfigModel *model = [(NSDictionary *)self.dataSource[@"config"] objectForKey:key];
    cell.configName.text = model.configName;
    cell.configType.text = model.type;
    cell.loadLevel.text =  model.level;
    return cell;//返回该cell
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keyArray = ((NSDictionary *) self.dataSource[@"config"]).allKeys;
    NSString *key = [keyArray objectAtIndex:indexPath.row];
    OrangeConfigModel *model = [(NSDictionary *)self.dataSource[@"config"] objectForKey:key];
    [self showEffectiveConfig:model];
}

- (void) showEffectiveConfig:(OrangeConfigModel *)model {
    NSMutableDictionary *msg = [NSMutableDictionary dictionaryWithCapacity:7];
    [msg setObject:model.content ?:@"" forKey:@"content"];
    [msg setObject:model.updateTime ?:@"" forKey:@"updateTime"];
    [msg setObject:model.digest?:@"" forKey:@"digest"];
    [msg setObject:model.ref ?:@"" forKey:@"ref"];
    [msg setObject:model.name?:@"" forKey:@"name"];
    [msg setObject:model.type?:@"" forKey:@"type"];
    [msg setObject:model.configName?:@"" forKey:@"configName"];
    [msg setObject:model.caseId?:@"" forKey:@"caseId"];
    [msg setObject:model.level ?:@"" forKey:@"level"];
    [msg setObject:model.exp?:@"" forKey:@"exp"];
    self.msgView.text = msg.description;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

