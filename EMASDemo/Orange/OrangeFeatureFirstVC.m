//
//  OrangeFeatureFirstVC.m
//  test
//
//  Created by jiangpan on 2018/5/21.
//  Copyright © 2018年 jiangpan. All rights reserved.
//

#import "OrangeFeatureFirstVC.h"
//#import "Orange.h"
#import <orange/Orange.h>
#import "OrangeTestConstants.h"

@interface OrangeFeatureFirstVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@end

@implementation OrangeFeatureFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.urlLabel.text = [Orange getConfigByGroupName:FirstFeatureName
                                                  key:FirstFeatureKey2
                                        defaultConfig:@"https://www.baidu.com"
                                            isDefault:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlLabel.text]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchFeatureConfig:)
                                                 name:@"feature_orange"
                                               object:nil];
    
}

- (void)fetchFeatureConfig:(NSNotification *)notice {
    NSDictionary *dict = notice.object;
    NSDictionary *content = [dict objectForKey:@"content"];
    if (content) {
        if ([content objectForKey:FirstFeatureKey2]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[content objectForKey:FirstFeatureKey2]]]];
            self.urlLabel.text = [dict objectForKey:FirstFeatureKey2];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
