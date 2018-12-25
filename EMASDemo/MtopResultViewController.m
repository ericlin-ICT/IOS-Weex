//
//  MtopResultViewController.m
//  EMASDemo
//
//  Created by jiangpan on 2018/5/2.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "MtopResultViewController.h"
#import <mtopext/MtopCore/MtopExtRequest.h>
#import <mtopext/MtopCore/MtopExtResponse.h>
#import <mtopext/MtopCore/MtopService.h>
#import <MtopSDK/TBSDKConnection.h>

typedef NS_ENUM(NSUInteger,MtopParamType){
    MtopParamType_Int = 1,
    MtopParamType_Double,
    MtopParamType_Integer,
    MtopParamType_String,
    MtopParamType_Bool
};

static MtopParamType filterType(NSString *typeString) {
    if ([typeString hasPrefix:@"String"]) {
        return MtopParamType_String;
    }else if ([typeString hasPrefix:@"Bool"]) {
        return MtopParamType_Bool;
    }else if ([typeString hasPrefix:@"Int"]){
        return MtopParamType_Int;
    }else if ([typeString hasPrefix:@"Double"]){
        return MtopParamType_Double;
    }else if ([typeString hasPrefix:@"Integer"]){
        return MtopParamType_Integer;
    }
    return 0;
}

static NSString* mtopDescription(MtopExtResponse *response){
   
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n请求的网络地址= %@\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n",response.request.mrequest.request.url];
    
    [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\nHTTP请求Method: %@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n",response.request.isUseHttpPost?@"POST":@"GET"]];
   
    [mStr appendString:[NSMutableString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\nHTTP请求头%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName,  response.requestHeaders]];;
    
    [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\nHTTP响应头%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName, response.headers]];
    
    if ([response.request.mrequest.responseString length])
    {
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\n服务器返回值\n%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName, response.request.mrequest.responseString]];
    }
    else if (response.request.mrequest.responseData)
    {
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\n服务器返回值\n%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName, [response.request.mrequest.responseData description]]];
    }
    else
    {
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n服务器没有返回数据\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n"]];
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\nmappincCode:%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n",response.error.mappingCode]];
    }
    
    return mStr;
}

@interface MtopResultViewController ()
@property (strong,nonatomic) NSDictionary *requestData;
@property (strong,nonatomic) UITextView *requestText;


@end

@implementation MtopResultViewController
- (instancetype)initWithRequestData:(NSDictionary *)requestData {
    self = [super init];
    if (self) {
        _requestData = requestData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self sendMtopRequest:self.requestData];
}

- (void)setupUI {
    
    _requestText = [[UITextView alloc] init];
    [_requestText setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_requestText];
    [_requestText setTranslatesAutoresizingMaskIntoConstraints:NO];// 为防止自动布局冲突设置为NO
    NSLayoutConstraint *requestTextConstraint1 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0];

    NSLayoutConstraint *requestTextConstraint2 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:0];

    NSLayoutConstraint *requestTextConstraint3 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0
                                                                               constant:0];


    NSLayoutConstraint *requestTextConstraint4 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];

    [self.view addConstraints:@[requestTextConstraint1,requestTextConstraint2,requestTextConstraint3,requestTextConstraint4]];
    
}

- (void)sendMtopRequest:(NSDictionary *)requestData {
    
    NSString *domain = [requestData objectForKey:@"Domain"];
    NSString *origianlApiMsg = [requestData objectForKey:@"API"];
    NSArray *apiMsg = [origianlApiMsg componentsSeparatedByString:@"/"];
    NSString *apiName = @"";
    NSString *apiVersion = @"";
    if ([apiMsg isKindOfClass:[NSArray class]] && apiMsg.count == 2) {
        apiName = [apiMsg objectAtIndex:0];
        apiVersion = [apiMsg objectAtIndex:1];
    }
    MtopExtRequest* request = [[MtopExtRequest alloc] initWithApiName: apiName apiVersion: apiVersion];
    [request setCustomHost:domain];
    TBSDKConfiguration *config = [TBSDKConfiguration shareInstance];
    config.latitude = 30.26;
    config.longitude = 120.19;
    request.protocolType = MtopProtocolTypeEmas;
    [request disableHttps];
    
    if ([(NSString *)[requestData objectForKey:@"Mtheod"] hasPrefix:@"POST"]) {
        [request useHttpPost];
    }else {
        // 默认GET请求
    }
    
    NSArray *paramArray = [requestData objectForKey:@"Data"];
    if ([paramArray isKindOfClass:[NSArray class]] && paramArray.count > 0) {
        for (NSDictionary *dict in paramArray) {
            NSString *paramName = [dict objectForKey:@"paramName"];
            NSString *paramType = [dict objectForKey:@"paramType"];
            NSString *paramValue = [dict objectForKey:@"paramValue"];
            
            MtopParamType type = filterType(paramType);
            switch (type) {
                case MtopParamType_Int:{
                    [request addBizParameter:[NSNumber numberWithInt:paramValue.intValue] forKey:paramName];
                }
                    
                    break;
                    
                case MtopParamType_Bool:{
                    [request addBizParameter:paramValue.boolValue?@"true":@"false" forKey:paramName];
                }
                    
                    break;
                    
                case MtopParamType_Double:{
                    [request addBizParameter:[NSDecimalNumber numberWithDouble:paramValue.doubleValue] forKey:paramName];
                }
                    
                    break;
                
                case MtopParamType_String:{
                    [request addBizParameter:paramValue forKey:paramName];
                }
                    
                    break;
                    
                case MtopParamType_Integer:{
                    [request addBizParameter:[NSNumber numberWithInteger:paramValue.integerValue] forKey:paramName];
                }
                    break;
            }
        }
    }
    
    
//    [request addBizParameter:[NSNumber numberWithBool:true] forKey:@"testBool"];
//    [request addBizParameter:[NSNumber numberWithInteger:2] forKey:@"testInteger"];
//    [request addBizParameter:[NSNumber numberWithBool:false]  forKey:@"testBoolean"];
//    [request addBizParameter:[NSDecimalNumber numberWithDouble:1.1] forKey:@"testDoub"];
//    [request addBizParameter:@"test" forKey:@"testStr"];
//    [request addBizParameter:[NSNumber numberWithInt:1] forKey:@"testInt"];
//    [request addBizParameter:[NSDecimalNumber numberWithDouble:1.2] forKey:@"testDouble"];
    
    
    request.succeedBlock = ^(MtopExtResponse *response) {
        // 成功回调
        self.requestText.text = mtopDescription(response);
        
    };
    
    request.failedBlock = ^(MtopExtResponse *response) {
        // 失败回调
        self.requestText.text = mtopDescription(response);
    };
    
    [[MtopService getInstance] async_call:request delegate:nil];
}

@end
