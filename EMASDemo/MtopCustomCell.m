//
//  MtopCustomCell.m
//  EMASDemo
//
//  Created by jiangpan on 2018/5/9.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "MtopCustomCell.h"

@implementation MtopCustomCell1


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            _textFiled = [[UITextField alloc] init];
            [_textFiled setTranslatesAutoresizingMaskIntoConstraints:NO];// 为防止自动布局冲突设置为NO
            [self.contentView addSubview:_textFiled];
            [self setupUI];
        }
    return self;
}

- (void)setupUI{
    
    NSLayoutConstraint *requestTextConstraint1 = [NSLayoutConstraint constraintWithItem:self.textFiled
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0];
    
    
    NSLayoutConstraint *requestTextConstraint2 = [NSLayoutConstraint constraintWithItem:self.textFiled
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:+18.0];

    
    
    NSLayoutConstraint *requestTextConstraint3 = [NSLayoutConstraint constraintWithItem:self.textFiled
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0
                                                                               constant:0];
    
    NSLayoutConstraint *requestTextConstraint4 = [NSLayoutConstraint constraintWithItem:_textFiled
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];
    

    
    [self.contentView addConstraints:@[requestTextConstraint1,requestTextConstraint2,requestTextConstraint3,requestTextConstraint4]];

}

@end


@implementation  MtopCustomCell2
{
    NSArray *dataArry;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _paramType = [[UITextField alloc] init];
    _paramType.placeholder = @"设置参数类型";
    [_paramType setTranslatesAutoresizingMaskIntoConstraints:NO];
    _paramValue = [[UITextField alloc] init];
    [_paramValue setTranslatesAutoresizingMaskIntoConstraints:NO];
    _paramValue.placeholder = @"设置参数值";
    _paramName = [[UITextField alloc] init];
    _paramName.placeholder = @"设置参数名";
    [_paramName setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    _pickView = [[UIPickerView alloc] init];
    _pickView.dataSource = self;
    _pickView.delegate = self;
    [_pickView.delegate pickerView:_pickView didSelectRow:0 inComponent:0];
    dataArry = [NSArray arrayWithObjects:@"Sting类型",@"Bool类型",@"Int类型",@"Double类型",@"Integer类型", nil];

    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0f)];
    tool.barStyle = UIBarStyleDefault;//实现Uitoolbar，他的位置不重要，主要是大小，
    
    
        //空的itme占空位
    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(resignKeyboard:)];
    
    [tool setItems:[NSArray arrayWithObjects:nextBarItem,spaceBarItem,doneBarItem,nil]];
    
    _paramType.inputView = _pickView;
    _paramType.inputAccessoryView = tool;
    
    [self.contentView addSubview:_paramValue];
    [self.contentView addSubview:_paramType];
    [self.contentView addSubview:_paramName];
    [self setConstraints];
}

- (void)resignKeyboard:(id)sender{
    [_paramType resignFirstResponder];
    self.paramType.text = self.selectedType;
}

#pragma mark UIPickViewDelagete

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 5;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"String类型";
    }else if (row == 1){
        return @"Bool类型";
    }else if (row == 2){
        return @"Int类型";
    }else if(row == 3){
        return @"Double类型";
    }else {
        return @"Integer类型";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.selectedType = @"String类型";
    }else if (row == 1){
        self.selectedType = @"Bool类型";
    }else if (row == 2){
        self.selectedType = @"Int类型";
    }else if (row == 3){
        self.selectedType = @"Double类型";
    }else {
        self.selectedType = @"Integer类型";
    }
}


- (void)setConstraints {
    
    NSLayoutConstraint *requestTextConstraint1 = [NSLayoutConstraint constraintWithItem:self.paramType
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0];
    
    
    NSLayoutConstraint *requestTextConstraint2 = [NSLayoutConstraint constraintWithItem:self.paramType
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:+18.0];
    
    
    
    NSLayoutConstraint *requestTextConstraint3 = [NSLayoutConstraint constraintWithItem:self.paramType
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0
                                                                               constant:110];
    
    NSLayoutConstraint *requestTextConstraint4 = [NSLayoutConstraint constraintWithItem:self.paramType
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];
    
    NSLayoutConstraint *requestTextConstraint5 = [NSLayoutConstraint constraintWithItem:self.paramValue
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0];
    
    
    NSLayoutConstraint *requestTextConstraint6 = [NSLayoutConstraint constraintWithItem:self.paramValue
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0
                                                                               constant:110];
    
    
    
    
    NSLayoutConstraint *requestTextConstraint7 = [NSLayoutConstraint constraintWithItem:self.paramValue
                                                                              attribute:NSLayoutAttributeLeading
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.paramType
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1.0
                                                                               constant:+10];
    
    NSLayoutConstraint *requestTextConstraint8 = [NSLayoutConstraint constraintWithItem:self.paramValue
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];
    
    NSLayoutConstraint *requestTextConstraint9 = [NSLayoutConstraint constraintWithItem:self.paramName
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0];


    NSLayoutConstraint *requestTextConstraint10 = [NSLayoutConstraint constraintWithItem:self.paramName
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0
                                                                               constant:0];




    NSLayoutConstraint *requestTextConstraint11 = [NSLayoutConstraint constraintWithItem:self.paramName
                                                                              attribute:NSLayoutAttributeLeading
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.paramValue
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1.0
                                                                               constant:0];

    NSLayoutConstraint *requestTextConstraint12 = [NSLayoutConstraint constraintWithItem:self.paramName
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];


    
    
    
    [self.contentView addConstraints:@[requestTextConstraint1,requestTextConstraint2,requestTextConstraint3,requestTextConstraint4,requestTextConstraint5,requestTextConstraint6,requestTextConstraint7,requestTextConstraint8,requestTextConstraint9,requestTextConstraint10,requestTextConstraint11,requestTextConstraint12]];
    
    
}


@end

@implementation MtopCustomCell3
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

@end

@implementation MtopCustomCell4
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.sendLabel = [[UILabel alloc] init];
    [self.sendLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.sendLabel.text = @"发送MTOP请求";
    self.sendLabel.textAlignment = NSTextAlignmentCenter;
    [self.sendLabel setFont:[UIFont systemFontOfSize:14]];
    [self.sendLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:self.sendLabel];
    [self setContraints];
}

- (void)setContraints {
    
    NSLayoutConstraint *requestTextConstraint1 = [NSLayoutConstraint constraintWithItem:self.sendLabel
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:3.0];
    
    
    NSLayoutConstraint *requestTextConstraint2 = [NSLayoutConstraint constraintWithItem:self.sendLabel
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:+18.0];
    
    
    
    NSLayoutConstraint *requestTextConstraint3 = [NSLayoutConstraint constraintWithItem:self.sendLabel
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0
                                                                               constant:-18];
    
    NSLayoutConstraint *requestTextConstraint4 = [NSLayoutConstraint constraintWithItem:self.sendLabel
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:-3.0];
    
    
    
    [self.contentView addConstraints:@[requestTextConstraint1,requestTextConstraint2,requestTextConstraint3,requestTextConstraint4]];

    
}

@end


