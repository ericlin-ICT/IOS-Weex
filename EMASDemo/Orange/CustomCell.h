//
//  CustomCell.h
//  test
//
//  Created by jiangpan on 2018/5/21.
//  Copyright © 2018年 jiangpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *configName;
@property (weak, nonatomic) IBOutlet UILabel *loadLevel;
@property (weak, nonatomic) IBOutlet UILabel *configType;

+ (instancetype)initTableViewCell:(UITableView *)tableView andCellIdentify:(NSString *)cellIdentify;

@end
