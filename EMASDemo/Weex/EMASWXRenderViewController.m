//
//  EMASWXRenderViewController.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/6/28.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWXRenderViewController.h"
#import <DynamicConfiguration/DynamicConfigurationManager.h>

@interface EMASWXRenderViewController () <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id<UIScrollViewDelegate> originalDelegate;
@property (nonatomic, strong)  UIActivityIndicatorView *pageLoadingIndicator;

@end

@implementation EMASWXRenderViewController

//获取宿主容器的导航控制器。由于当前渲染容器是通过addChildViewController的方式添加到宿主容器中，因此所属的导航控制器应该是通过宿主容器获取。
- (UIViewController *)wxNavigationController {
    if (self.parentVC) {
        return self.parentVC.navigationController;
    }
    return nil;
}

//获取渲染容器包含的子视图控制器。例如，web对应的component，它会生成webviewController，并通过addChileViewController的方式添加到渲染容器中。
- (NSMutableArray *)wxChildViewControllers {
    return (NSMutableArray *)self.childViewControllers;
}

//在渲染容器中添加特定的子视图控制器。
- (void)wxAddChildViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
}

//在渲染容器中移除特定的子视图控制器。
- (void)wxRemoveChildViewController:(UIViewController *)viewController {
    [viewController removeFromParentViewController];
}

//校验当前的URL是否在白名单内，默然返回YES，表示当前URL为安全连接。这里可根据实际情况自定义安全规则。
- (BOOL)wxCheckIsSecurityDomain:(NSString *)url {
    return YES;
}

//配合wxCheckIsSecurityDomain使用，当上述接口返回为NO时，给予提示。
- (void)wxShowWarningBar:(UIView *)view {
    //[WVNotiBar showNotiBar:@"检测到该网址为外部网站，外部网站打开可能存在安全隐患，请注意保护您的个人隐私" image:[TBWeexUtils getIconFont:@"info_fill" size:16 color:[UIColor wvColorWithHex:0xF5A623]] inView: view];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"这是个提示"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
}

//自定义页面加载的indicatorView，并显示在view中。
- (void)wxShowPageLoadingIndicator:(UIView *)view {
    [view addSubview:self.pageLoadingIndicator];
    [self.pageLoadingIndicator startAnimating];}

//隐藏indicatorView
- (void)wxHidePageLoadingIndicator {
    [self.pageLoadingIndicator stopAnimating];
    [self.pageLoadingIndicator removeFromSuperview];
}

- (UIActivityIndicatorView *)pageLoadingIndicator {
    if (_pageLoadingIndicator == nil) {
        self.pageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 40)/2, (self.view.frame.size.height - 40)/2, 40, 40)];
        [self.pageLoadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _pageLoadingIndicator;
}


- (void)wxInstanceRenderOnCreate {
    // Weex渲染容器在实渲染中判断当前实例是否可以被复用
}

- (void)wxInstanceRenderOnFail:(NSError *)error {
    // Weex实例渲染失败回调，返回错误信息
}

- (void)wxInstanceRenderOnFinish {
    // Weex实例渲染完成回调
}

- (void)wxJSBundleDownloadOnFinish:(WXResourceResponse *)response request:(WXResourceRequest *)request data:(NSData *)data error:(NSError *)error {
    // JS Bundle下载回调
}

- (BOOL)wxJSBundleCanUseCache:(NSURL *)URL callback:(void (^)(NSString *))callback {
    // JS Bundle是否可以使用本地缓存，例如zcache或本地cache的场景，callback输入参数为完整的JS Bundle，返回后会直接进入模版渲染，不再进行网络请求。
    return NO;
}


@end
