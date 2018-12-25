//
//  CustomCell.m
//  test
//
//  Created by jiangpan on 2018/5/21.
//  Copyright © 2018年 jiangpan. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

+ (instancetype)initTableViewCell:(UITableView *)tableView andCellIdentify:(NSString *)cellIdentify {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentify owner:nil options:nil] lastObject];
    }//由于是从xib中创建，所以调用loadNibName的方法
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
