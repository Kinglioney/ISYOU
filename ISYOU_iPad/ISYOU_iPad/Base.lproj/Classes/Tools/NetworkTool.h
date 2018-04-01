//
//  NetworkTool.h
//  ISYOU
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseSuccess)(id responseObject);
typedef void(^ResponseFailed )(NSError *error);


@interface NetworkTool : NSObject
single_interface(NetworkTool)
@property (nonatomic, copy) ResponseSuccess successBlock;
@property (nonatomic, copy) ResponseFailed failedBlock;
@property (nonatomic, assign) BOOL netWorkState;

/**
 *  发送一个POST请求
 *  @param url  请求地址
 *  @param params 请求参数
 *  @param successBlock 请求成功的回调
 *  @param failedBlock  请求失败的回调
 */
- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(ResponseSuccess)successBlock
               fail:(ResponseFailed)failedBlock;


/**
 *  发送一个GET请求
 *  @param url  请求地址
 *  @param params 请求参数
 *  @param successBlock 请求成功的回调
 *  @param failedBlock  请求失败的回调
 */
- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(ResponseSuccess)successBlock
              fail:(ResponseFailed)failedBlock;


/** 检测网络状态 */
- (void)getNetworkState:(void(^)(BOOL state))success;

@end
