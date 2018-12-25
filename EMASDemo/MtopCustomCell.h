//
//  MtopCustomCell.h
//  EMASDemo
//
//  Created by jiangpan on 2018/5/9.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MtopCustomCell1 : UITableViewCell

@property (strong,nonatomic) UITextField *textFiled;

@end

@interface MtopCustomCell2 : UITableViewCell  <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong,nonatomic) UITextField *paramType;
@property (strong,nonatomic) UITextField *paramValue;
@property (strong,nonatomic) UITextField *paramName;
@property (strong,nonatomic) UIPickerView *pickView;
@property (copy,nonatomic)   NSString *selectedType;

@end

@interface MtopCustomCell3 : UITableViewCell

@end


@interface MtopCustomCell4 : UITableViewCell
@property (strong,nonatomic) UILabel *sendLabel;

@end


