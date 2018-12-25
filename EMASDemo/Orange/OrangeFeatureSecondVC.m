//
//  OrangeFeatureSecondVC.m
//  test
//
//  Created by jiangpan on 2018/5/21.
//  Copyright © 2018年 jiangpan. All rights reserved.
//

#import "OrangeFeatureSecondVC.h"
#import "OrangeFeatureFirstVC.h"
#import <orange/orange.h>
#import "OrangeTestConstants.h"



@interface OrangeFeatureSecondVC ()

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLable;


@end

@implementation OrangeFeatureSecondVC

- (IBAction)jumpToFeature1:(id)sender {
    OrangeFeatureFirstVC *firstFeatureVC = [[OrangeFeatureFirstVC alloc] initWithNibName:@"OrangeFeatureFirstVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:firstFeatureVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchFeatureConfig:)
                                                 name:@"feature_orange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchThemeConfig:)
                                                 name:@"theme_orange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(update)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    NSString *showMsg = [NSString stringWithFormat:@"theme_name=%@",[Orange getConfigByGroupName:SecondFeatureName key:SecondFeatureKey1 defaultConfig:@"unknow" isDefault:nil]];
    self.themeLable.text = showMsg;
    
    BOOL isShow = ((NSString *)[Orange getConfigByGroupName:FirstFeatureName key:FirstFeatureKey1 defaultConfig:nil isDefault:nil]).boolValue;
    if (isShow) {
        self.playBtn.hidden = NO;
    }else {
        self.playBtn.hidden = YES;
    }
    
    NSString *color = [Orange getConfigByGroupName:SecondFeatureName key:SecondFeatureKey2 defaultConfig:@"black" isDefault:nil];
    if ([color isEqualToString:@"black"]) {
        self.colorLabel.backgroundColor = [UIColor blackColor];
    }else  if(color.length){
        self.colorLabel.backgroundColor = [OrangeFeatureSecondVC colorWithHexString:color];
    } else {
        self.colorLabel.backgroundColor = [UIColor blackColor];
    }
}

- (void)fetchFeatureConfig:(NSNotification *)notice {
    NSDictionary *dict = notice.object;
    NSDictionary *content = [dict objectForKey:@"content"];
    if (content) {
        BOOL isShow = ((NSString *)[content objectForKey:FirstFeatureKey1]).boolValue;
        if (isShow) {
            self.playBtn.hidden = NO;
        }else {
            self.playBtn.hidden = YES;
        }
    }
}

- (void)fetchThemeConfig:(NSNotification *)notice {
    NSDictionary *dict = notice.object;
    NSDictionary *content = [dict objectForKey:@"content"];
    if (content) {
        if ([content objectForKey:SecondFeatureKey2]) {
            self.colorLabel.backgroundColor = [OrangeFeatureSecondVC colorWithHexString:[content objectForKey:SecondFeatureKey2]];
        }
        if ([content objectForKey:SecondFeatureKey1]) {
            NSString *showMsg = [NSString stringWithFormat:@"theme_name=%@",[content objectForKey:SecondFeatureKey1]];
            self.themeLable.text = showMsg;
        }
    }
}

- (void)update {
    NSString *showMsg = [NSString stringWithFormat:@"theme_name=%@",[Orange getConfigByGroupName:SecondFeatureName key:SecondFeatureKey1 defaultConfig:@"unknow" isDefault:nil]];
    self.themeLable.text = showMsg;
    
    BOOL isShow = ((NSString *)[Orange getConfigByGroupName:FirstFeatureName key:FirstFeatureKey1 defaultConfig:nil isDefault:nil]).boolValue;
    if (isShow) {
        self.playBtn.hidden = NO;
    }else {
        self.playBtn.hidden = YES;
    }
    
    NSString *color = [Orange getConfigByGroupName:SecondFeatureName key:SecondFeatureKey2 defaultConfig:@"black" isDefault:nil];
    if ([color isEqualToString:@"black"]) {
        self.colorLabel.backgroundColor = [UIColor blackColor];
    }else  if(color.length){
        self.colorLabel.backgroundColor = [OrangeFeatureSecondVC colorWithHexString:color];
    } else {
        self.colorLabel.backgroundColor = [UIColor blackColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
