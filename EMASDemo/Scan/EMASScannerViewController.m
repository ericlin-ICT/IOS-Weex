/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "EMASScannerViewController.h"
#import "AppDelegate.h"
#import "UIViewController+EMASWXNaviBar.h"
#import "EMASHostViewController.h"
#import <WeexSDK/WXDebugTool.h>
//#import <TBWXDevTool/TBWXDevTool.h>
#import <WXDevTool.h>
#import <AudioToolbox/AudioToolbox.h>
#import <WeexSDK/WXSDKEngine.h>
#import "EMASWindVaneViewController.h"

@interface EMASScannerViewController ()

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;
@property (nonatomic, strong) UIView *sanFrameView;

@end

@implementation EMASScannerViewController

#pragma mark - lifeCircle

- (void)dealloc {
    [_captureLayer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
#if !(TARGET_IPHONE_SIMULATOR)
    self.session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    if (output && input && device) {
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addInput:input];
        [_session addOutput:output];
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    }
    
    _captureLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _captureLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    _captureLayer.frame=self.view.layer.bounds;
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setupNaviBar];
    [self.view.layer addSublayer:_captureLayer];
    [_session startRunning];
    
    self.navigationItem.title = @"EMAS";
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_captureLayer removeFromSuperlayer];
    [_session stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_captureLayer removeFromSuperlayer];
    [_session stopRunning];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex: 0];
        [self openURL:metadataObject.stringValue];
    }
}

- (void)openURL:(NSString*)URL
{
    NSString *transformURL = URL;
    //NSURL *url = [NSURL URLWithString:URL];
    
    //weex打开
    if (URL.length == 0 || [URL containsString:@".js"] || [URL containsString:@".wx"]) {
        NSURL *url = [NSURL URLWithString:transformURL];
        if (!url) {
            return;
        }
        if ([self remoteDebug:url]) {
            return;
        }
        [self jsReplace:url];
        
        EMASHostViewController * controller = [[EMASHostViewController alloc] initWithNavigatorURL:url];
        controller.source = @"scan";
        
        NSMutableDictionary *queryDict = [NSMutableDictionary new];
        if (WX_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
            NSArray *queryItems = [components queryItems];

            for (NSURLQueryItem *item in queryItems)
            [queryDict setObject:item.value forKey:item.name];
        }else {
            queryDict = [self queryWithURL:url];
        }
        NSString *wsport = queryDict[@"wsport"] ?: @"8082";
        NSURL *socketURL = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%@", url.host, wsport]];
        controller.hotReloadSocket = [[SRWebSocket alloc] initWithURL:socketURL protocols:@[@"echo-protocol"]];
        controller.hotReloadSocket.delegate = controller;
        [controller.hotReloadSocket open];
        
        [[self navigationController] pushViewController:controller animated:YES];
    } else {//h5打开
        EMASWindVaneViewController * controller = [[EMASWindVaneViewController alloc] init];
        controller.loadUrl = URL;
        [[self navigationController] pushViewController:controller animated:YES];
    }
}

- (NSMutableDictionary*)queryWithURL:(NSURL *)url {
    NSMutableDictionary * queryDic = nil;
    if (![url query]) {
        return queryDic;
    }
    queryDic = [NSMutableDictionary new];
    NSArray* components = [[url query] componentsSeparatedByString:@"&"];
    for (NSUInteger i = 0; i < [components count]; i ++) {
        NSString * queryParam = [components objectAtIndex:i];
        NSArray* component = [queryParam componentsSeparatedByString:@"="];
        [queryDic setValue:component[1] forKey:component[0]];
    }
    
    return  queryDic;
}

#pragma mark - Replace JS

- (void)jsReplace:(NSURL *)url
{
    if ([[url host] isEqualToString:@"weex-remote-debugger"]){
        NSString* path = [url path];
        if ([path isEqualToString:@"/dynamic/replace/bundle"]){
            for (NSString * param in [[url query] componentsSeparatedByString:@"&"]) {
                NSArray* elts = [param componentsSeparatedByString:@"="];
                if ([elts count] < 2) {
                    continue;
                }
                if ([[elts firstObject] isEqualToString:@"bundle"]){
                    [WXDebugTool setReplacedBundleJS:[NSURL URLWithString:[elts lastObject]]];
                }
            }
        }
        
        if ([path isEqualToString:@"/dynamic/replace/framework"]){
            for (NSString * param in [[url query] componentsSeparatedByString:@"&"]) {
                NSArray* elts = [param componentsSeparatedByString:@"="];
                if ([elts count] < 2) {
                    continue;
                }
                if ([[elts firstObject] isEqualToString:@"framework"]){
                    [WXDebugTool setReplacedJSFramework:[NSURL URLWithString:[elts lastObject]]];
                }
            }
        }
    }
}

#pragma mark Remote debug
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (BOOL)remoteDebug:(NSURL *)url
{
    if ([url.scheme isEqualToString:@"ws"]) {
        [WXSDKEngine connectDebugServer:url.absoluteString];
        [WXSDKEngine initSDKEnvironment];
        
        return YES;
    }
    
    NSString *query = url.query;
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        if ([[elts firstObject] isEqualToString:@"_wx_debug"]) {
            [WXDebugTool setDebug:YES];
            [WXSDKEngine connectDebugServer:[[elts lastObject]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if ([[[self.navigationController viewControllers] objectAtIndex:0] isKindOfClass:NSClassFromString(@"EMASHostViewController")]) {
                EMASHostViewController * vc = (EMASHostViewController*)[[self.navigationController viewControllers] objectAtIndex:0];
                [vc performSelector:NSSelectorFromString(@"loadRefreshCtl")];
                [self.navigationController popToViewController:vc animated:NO];
            }
            return YES;
        } else if ([[elts firstObject] isEqualToString:@"_wx_devtool"]) {
            NSString *devToolURL = [[elts lastObject]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
            [WXDevTool launchDevToolDebugWithUrl:devToolURL];
#endif
            if ([[[self.navigationController viewControllers] objectAtIndex:0] isKindOfClass:NSClassFromString(@"EMASHostViewController")]) {
                EMASHostViewController * vc = (EMASHostViewController*)[[self.navigationController viewControllers] objectAtIndex:0];
                [self.navigationController popToViewController:vc animated:NO];
            }
            
            return YES;
        }
    }
    
    return NO;
}
#pragma clang diagnostic pop

@end
