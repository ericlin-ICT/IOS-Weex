//
//  AppConfigTableViewController.m
//  EMASDemo
//
//  Created by zhishui.lcq on 2018/4/8.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "AppConfigTableViewController.h"
#import "EMASService.h"
#import <objc/runtime.h>

@interface AppConfigTableViewController ()

@end

@implementation AppConfigTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"应用配置信息";
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
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableSampleIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [self textForTextLabel:indexPath];
    cell.detailTextLabel.text = [self textForDetailLabel:indexPath];
    cell.detailTextLabel.textColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self textForTextLabel:indexPath];
    NSString *message = [self textForDetailLabel:indexPath];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSString *)textForTextLabel:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            case 0:
        {
            return @"[Appkey字段] Appkey";
        }
            case 1:
        {
            return @"[AppSecret字段] AppSecret";
        }
            case 2:
        {
            return @"[ACCSDomain字段] accs域名";
        }
            case 3:
        {
            return @"[MTOPDomain字段] mtop域名";
        }
            case 4:
        {
            return @"[ChannelID字段] 渠道ID";
        }
            case 5:
        {
            return @"[ZCacheURL字段] Weex 预加载地址";
        }
            case 6:
        {
            return @"[HAOSSBucketName字段] HA OSS Bucket Name";
        }
            case 7:
        {
            return @"[HAServiceID字段] HA Service ID";
        }
            case 8:
        {
            return @"[HAUniversalHost字段] adash域名";
        }
            case 9:
        {
            return @"[HATimestampHost字段] HA时间戳域名(同MTOP域名)";
        }
            case 10:
        {
            return @"[HARSAPublicKey字段] HA公钥";
        }
            case 11:
        {
            return @"[HotfixServerURL字段] 热修复地址";
        }
            case 12:
        {
            return @"[UseHTTP字段] 是否使用HTTP发请求";
        }
            case 13:
        {
            return @"[全局] 设备ID";
        }
            case 14:
        {
            return @"[全局] App版本号";
        }
            case 15:
        {
            return @"[IPStrategy字段] IP策略";
        }
            
        default:
        {
            return @"";
        }
    }
}

- (NSString *)textForDetailLabel:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            case 0:
        {
            return [[EMASService shareInstance] appkey];
        }
            case 1:
        {
            return [[EMASService shareInstance] appSecret];
        }
            case 2:
        {
            return [[EMASService shareInstance] ACCSDomain];
        }
            case 3:
        {
            return [[EMASService shareInstance] MTOPDomain];
        }
            case 4:
        {
            return [[EMASService shareInstance] ChannelID];
        }
            case 5:
        {
            return [[EMASService shareInstance] ZCacheURL];
        }
            case 6:
        {
            return [[EMASService shareInstance] HAOSSBucketName];
        }
            case 7:
        {
            return [[EMASService shareInstance] HAServiceID];
        }
            case 8:
        {
            return [[EMASService shareInstance] HAUniversalHost];
        }
            case 9:
        {
            return [[EMASService shareInstance] HATimestampHost];
        }
            case 10:
        {
            NSString *publicKey = [[EMASService shareInstance] HARSAPublicKey];
            return (publicKey.length > 0 ? publicKey : @"暂无设置");
        }
            case 11:
        {
            return [[EMASService shareInstance] HotfixServerURL];
        }
            case 12:
        {
            BOOL result = [[EMASService shareInstance] useHTTP];
            return (result ? @"是" : @"不是") ;
        }
            case 13:
        {
            return [self getUTDid] ;
        }
            case 14:
        {
            return [[EMASService shareInstance] getAppVersion] ;
        }
            case 15:
        {
            NSString *info = @"";
            NSDictionary *ipStrategy = [[EMASService shareInstance] IPStrategy];
            for (NSString *key in [ipStrategy allKeys]) {
                info = [info stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, [ipStrategy objectForKey:key]]];
                if (![key isEqualToString:[[ipStrategy allKeys] lastObject]]) {
                    info = [info stringByAppendingString:@"&"];
                }
            }
            return (info.length > 0 ? info : @"暂无设置") ;
        }
            
        default:
        {
            return @"";
        }
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (NSString *)getUTDid
{
    id UTDevice$Class = objc_getClass("UTDevice");
    if ((UTDevice$Class == nil) || ![UTDevice$Class respondsToSelector: @selector(utdid)]) {
        return @"";
    }
    
    NSString *utdid = [UTDevice$Class performSelector: @selector(utdid)];
    return utdid;
}

#pragma clang diagnostic pop

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
