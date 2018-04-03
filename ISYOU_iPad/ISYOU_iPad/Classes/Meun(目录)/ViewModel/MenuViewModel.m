//
//  MenuViewModel.m
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MenuViewModel.h"
#import "NetworkTool.h"
#import "LaserModel.h"
#import "InjectionModel.h"
#import "PlasticModel.h"
#import "HealthModel.h"

#define SERVER_ADDR   @"http://122.114.15.61:8090/isyou/"
/** 获取缩略图路径 */
#define URL_LASER     @"download2?folderName=激光类&version=IPAD"
#define URL_INJECTION @"download2?folderName=注射类&version=IPAD"
#define URL_PLASTIC   @"download2?folderName=整形外科&version=IPAD"
#define URL_HEALTH    @"download2?folderName=大健康类&version=IPAD"
/** 服务器存放崩溃标志的路径 */
#define URL_MakeCrash @"getFlag?type=IPAD"

@interface MenuViewModel()
@property (nonatomic, strong) LaserModel *laserModel;
@property (nonatomic, strong) InjectionModel *injectionModel;
@property (nonatomic, strong) PlasticModel *plasticModel;
@property (nonatomic, strong) HealthModel *healthModel;
@end



@implementation MenuViewModel
//MARK: 懒加载
- (NSMutableArray *)lasers {
    if (!_lasers) {
        _lasers = [NSMutableArray array];
    }

    return _lasers;
}

- (NSMutableArray *)injections {
    if (!_injections) {
        _injections = [NSMutableArray array];
    }
    return _injections;
}

- (NSMutableArray *)plastics {
    if (!_plastics) {
        _plastics = [NSMutableArray array];
    }
    return _plastics;
}

- (NSMutableArray *)healths {
    if (!_healths) {
        _healths = [NSMutableArray array];

    }
    return _healths;
}
#pragma mark - 网络请求
- (void)requestPhotoDataWithType:(RequestMenuDataType)type finishBlock:(FinishBlock)finishBlock failedBlock:(FailedBlock)failedBlock {
    NSString *url;
    
    switch (type) {
        case RequestMenuDataTypeLaser:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_LASER]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
            
        case RequestMenuDataTypeInjection:
            // 1.拼接URL来获取图片的路径
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_INJECTION]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        case RequestMenuDataTypePlastic:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_PLASTIC]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        case RequestMenuDataTypeHealth:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_HEALTH]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        default:
            break;
    }
    
    [self requestPhotoURL:url
                     Type:type
             SucceedBlock:^{
                 finishBlock();
             }FailedBlock:^{
                 failedBlock();
             }];
}


#pragma mark - 获取缩略图和高清图的url
- (void)requestPhotoURL:(NSString *)url Type:(RequestMenuDataType)type SucceedBlock:(SucceedBlock)succeedBlock FailedBlock:(FailedBlock)failedBlock {
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool]get:url params:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *results = responseObject;
        if (results.count == 0 || results == nil) {
            failedBlock();
            return;
        }
        NSString *thumbnailImageUrl = @"";
        
        NSMutableArray *datas = [NSMutableArray array];
        for (NSArray *arr in results) {
            weakSelf.laserModel = [LaserModel new];
            weakSelf.injectionModel = [InjectionModel new];
            weakSelf.plasticModel = [PlasticModel new];
            weakSelf.healthModel = [HealthModel new];
            NSDictionary *thumbnailImageDic = [arr firstObject];
            NSDictionary *orignalImageDic = [arr lastObject];
            //缩略图只有一张
            NSString *thumbnailImageStr = [thumbnailImageDic[@"thumbnailImagrUrl"]firstObject];
            thumbnailImageStr = [thumbnailImageStr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            thumbnailImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDR, thumbnailImageStr];
            NSMutableArray *orignalImageUrls = [NSMutableArray array];
            //高清图可能有多张
            NSArray *orignalImageUrlArr = orignalImageDic[@"orignalImagrUrls"];
            NSString *orignalImageUrl = @"";
            for(int i=0; i<orignalImageUrlArr.count; i++){
                orignalImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDR, orignalImageUrlArr[i]];
                orignalImageUrl = [orignalImageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                NSLog(@"高清图的URL：%@", orignalImageUrl);
                [orignalImageUrls addObject: orignalImageUrl];
            }
            if (type == RequestMenuDataTypeLaser) {
                weakSelf.laserModel.thumbnailImagrUrl = thumbnailImageUrl;
                weakSelf.laserModel.orignalImagrUrls = orignalImageUrls;
                [self.lasers addObject:weakSelf.laserModel];
                
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.laserModel];
                [datas addObject:data];
                [USER_DEFAULT setObject:datas forKey:UserDefault_Laser];
                
            }else if (type == RequestMenuDataTypeInjection){
                weakSelf.injectionModel.thumbnailImagrUrl = thumbnailImageUrl;
                weakSelf.injectionModel.orignalImagrUrls = orignalImageUrls;
                [self.injections addObject:weakSelf.injectionModel];
                
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.injectionModel];
                [datas addObject:data];
                [USER_DEFAULT setObject:datas forKey:UserDefault_Injection];
            }else if (type == RequestMenuDataTypePlastic){
                weakSelf.plasticModel.thumbnailImagrUrl = thumbnailImageUrl;
                weakSelf.plasticModel.orignalImagrUrls = orignalImageUrls;
                [self.plastics addObject:weakSelf.plasticModel];
                
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.plasticModel];
                [datas addObject:data];
                [USER_DEFAULT setObject:datas forKey:UserDefault_Plastic];
            }else{
                weakSelf.healthModel.thumbnailImagrUrl = thumbnailImageUrl;
                weakSelf.healthModel.orignalImagrUrls = orignalImageUrls;
                [self.healths addObject:weakSelf.healthModel];
                
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.healthModel];
                [datas addObject:data];
                [USER_DEFAULT setObject:datas forKey:UserDefault_Health];
            }
        }
        succeedBlock();
    } fail:^(NSError *error) {
        NSLog(@"fail");
    }];
    
}

/** 获取是否执行崩溃的bool值 */
- (void)requestCrashValue:(void (^)(BOOL isCrash))block {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_MakeCrash];
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool]get:url params:nil success:^(id responseObject) {
        NSString *crashStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        weakSelf.isCrash = [crashStr boolValue];
        block(weakSelf.isCrash);
        
    } fail:^(NSError *error) {
        NSLog(@"failed");
    }];
}
@end
