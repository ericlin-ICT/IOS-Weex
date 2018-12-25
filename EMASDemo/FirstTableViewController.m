//
//  FirstTableViewController.m
//  EMASDemo
//
//  Created by EMAS on 2017/12/8.
//  Copyright © 2017年 EMAS. All rights reserved.
//

#import "FirstTableViewController.h"
#import "HFXViewController.h"
#import "EMASHostViewController.h"
#import "DemoDefine.h"
#import "AliHATestCaseViewController.h"
#import <objc/runtime.h>
#import "EMASService.h"
#import "AppConfigTableViewController.h"
#import "MtopVerifyTableViewController.h"
#import "OrangeRemoteConfigRootVC.h"
#import "ACCSViewController.h"
#import "PushViewController.h"
#import "MANViewController.h"
#import "EMASNativeViewController.h"
#import "UIViewController+EMASWXNaviBar.h"

@interface FirstTableViewController ()

@end

@implementation FirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviBar];
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
    return 8;//10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"[重要] 应用配置信息检查";
            cell.textLabel.textColor = [UIColor redColor];
        }
        break;
        case 1:
        {
            cell.textLabel.text = @"API网关";
            cell.textLabel.textColor = [UIColor purpleColor];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"高可用";
            cell.textLabel.textColor = [UIColor blueColor];
        }
        break;
        case 3:
        {
            cell.textLabel.text = @"热修复";
            cell.textLabel.textColor = [UIColor greenColor];
        }
            break;
        
        case 4:
        {
            cell.textLabel.text = @"远程配置";
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        break;
        case 5:
        {
            cell.textLabel.text = @"ACCS";
            cell.textLabel.textColor = [UIColor brownColor];
        }
        break;
        case 6:
        {
            cell.textLabel.text = @"PUSH";
            cell.textLabel.textColor = [UIColor magentaColor];
        }
            break;
        case 7:
        {
            cell.textLabel.text = @"数据分析";
            cell.textLabel.textColor = [UIColor purpleColor];
        }
            break;
        case 8:
        {
            cell.textLabel.text = @"Weex";
            cell.textLabel.textColor = [UIColor orangeColor];
        }
            break;
        case 9:
        {
            cell.textLabel.text = @"WindVane";
            cell.textLabel.textColor = [UIColor cyanColor];
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
            AppConfigTableViewController *controller = [AppConfigTableViewController new];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 1:
        {
            MtopVerifyTableViewController *ctrl = [MtopVerifyTableViewController new];
            [self.navigationController pushViewController:ctrl animated:YES];
            return;
        }
        case 2:
        {
            // AliHA
            AliHATestCaseViewController *controller = [[AliHATestCaseViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
            
        }
        case 3:
        {
            HFXViewController *controller = [HFXViewController new];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        
        case 4:
        {
            OrangeRemoteConfigRootVC *configVC = [[OrangeRemoteConfigRootVC alloc] init];
            [self.navigationController pushViewController:configVC animated:YES];
            break;
        }
        
        case 5:
        {
            ACCSViewController *avc = [[ACCSViewController alloc] init];
            [self.navigationController pushViewController:avc animated:YES];
            break;
        }
        case 6:
        {
            PushViewController *pvc = [[PushViewController alloc] init];
            [self.navigationController pushViewController:pvc animated:YES];
            break;
        }
        case 7:
        {
            MANViewController *mvc = [[MANViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
            break;
        }
//        case 8:
//        {
//            EMASNativeViewController *controller = [[EMASNativeViewController alloc] init];
//            [self.navigationController pushViewController:controller animated:YES];
//            break;
//        }
//        case 9:
//        {
//            EMASWindVaneScanViewController *controller = [[EMASWindVaneScanViewController alloc] init];
//            //controller.loadUrl = @"http://wapp.m.taobao.com/app/windvane/jsbridge.html";
//            //controller.loadUrl = @"http://chaoshi.m.tmall.com";
//            [self.navigationController pushViewController:controller animated:YES];
//            break;
//        }
    }
}

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
