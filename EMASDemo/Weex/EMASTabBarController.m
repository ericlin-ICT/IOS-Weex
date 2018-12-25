//
//  EMASTabBarController.m
//  EMASWeexDemo
//
//  Created by daoche.jb on 2018/7/27.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASTabBarController.h"
#import "EMASHostViewController.h"
#import "EMASBaseNavigationController.h"
#import "EMASWeexContainerService.h"

@interface EMASTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerArrayM;
@property (nonatomic, strong) NSMutableArray *tabBarItemsAttributesArrayM;

@end

@implementation EMASTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTabBarInfo];
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;
        UIOffset titlePositionAdjustment = UIOffsetMake(0, 0);
        self = [super  initWithViewControllers:self.viewControllerArrayM
                         tabBarItemsAttributes:self.tabBarItemsAttributesArrayM
                                   imageInsets:imageInsets
                       titlePositionAdjustment:titlePositionAdjustment
                                       context:self.context];
        [self customizeTabBarAppearance:self];
    }
    
    return self;
}

- (void)setupTabBarInfo
{
    NSNumber *tabSize = [[EMASWeexContainerService shareInstance] tabSize];
    NSInteger tabSizeInt = tabSize.integerValue;
    if (!tabSize || tabSizeInt < 2) {
        return;
    }
    
    self.viewControllerArrayM = [NSMutableArray array];
    self.tabBarItemsAttributesArrayM = [NSMutableArray array];
    
    NSDictionary *jsSourceDic = [[EMASWeexContainerService shareInstance] jsSource];
    
    for (int i = 0; i < tabSizeInt; i++) {
        NSString *url = [jsSourceDic objectForKey:@(i).stringValue];
        
        ///先简单区分本地和远程js
        if ([url rangeOfString:@"/"].location == NSNotFound) {//本地
            url = [NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] pathForResource:url ofType:@""]];
        }
        
        EMASHostViewController *viewController = [[EMASHostViewController alloc] initWithNavigatorURL:[NSURL URLWithString:url]];
        UIViewController *navigationController = [[EMASBaseNavigationController alloc]
                                                  initWithRootViewController:viewController];
        [self.viewControllerArrayM  addObject:navigationController];
        
        
        NSString *title = [NSString stringWithFormat:@"Tab%d", i + 1];
        NSString *imageSource = [NSString stringWithFormat:@"tab%d", i + 1];
        NSString *selectedImageSource = [NSString stringWithFormat:@"tab%d_click", i + 1];
        
        NSDictionary *tabBarItemsAttributes = @{
                                                     CYLTabBarItemTitle : title,
                                                     CYLTabBarItemImage : [UIImage imageNamed:imageSource],
                                                     CYLTabBarItemSelectedImage : [UIImage imageNamed:selectedImageSource]
                                                     };
        [self.tabBarItemsAttributesArrayM addObject:tabBarItemsAttributes];
    }
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setTintColor:[UIColor lightGrayColor]];
    //        [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];

    //FIXED: #196
    NSString *tabBarBackgroundImageName = @"tabbarBg";
    UIImage *tabBarBackgroundImage = [UIImage imageNamed:tabBarBackgroundImageName];
    UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage];
    [tabBarAppearance setBackgroundImage:scanedTabBarBackgroundImage];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // iOS10 后 需要使用 `-[CYLTabBarController hideTabBadgeBackgroundSeparator]` 见 AppDelegate 类中的演示;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = 40.f;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor whiteColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)scaleImage:(UIImage *)image {
    CGFloat halfWidth = image.size.width/2;
    CGFloat halfHeight = image.size.height/2;
    UIImage *secondStrechImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth) resizingMode:UIImageResizingModeStretch];
    return secondStrechImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
