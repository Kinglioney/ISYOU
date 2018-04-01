//
//  NetworkTool.m
//  ISYOU
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NetworkTool.h"
#import <AFNetworking.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation NetworkTool
single_implementation(NetworkTool)

- (void)post:(NSString *)url params:(NSDictionary *)params success:(ResponseSuccess)successBlock fail:(ResponseFailed)failedBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failedBlock(error);
        NSLog(@"请求失败---%@", error);
    }];

}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(ResponseSuccess)successBlock fail:(ResponseFailed)failedBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error);
        NSLog(@"请求失败---%@", error);
    }];
}





- (void)getNetworkState:(void(^)(BOOL state))success{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        WEAKSELF;
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未知网络");
                weakSelf.netWorkState = NO;
                success(weakSelf.netWorkState);
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");
                weakSelf.netWorkState = NO;
                success(weakSelf.netWorkState);
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"手机自带网络");
                weakSelf.netWorkState = YES;
                success(weakSelf.netWorkState);
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WIFI");
                weakSelf.netWorkState = YES;
                success(weakSelf.netWorkState);
            }
                break;
        }
    }];
    [manager startMonitoring];
    
}
- (void)setNetWorkState:(BOOL)netWorkState {
    _netWorkState = netWorkState;
}
@end
