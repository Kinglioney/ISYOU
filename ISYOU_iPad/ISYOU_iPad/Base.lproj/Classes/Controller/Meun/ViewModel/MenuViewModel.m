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

#define SERVER_ADDR   @"http://119.23.41.147:8080/isyou/"
/** 获取缩略图路径 */
#define URL_LASER     @"download2?folderName=激光类&type=IPAD"
#define URL_INJECTION @"download2?folderName=注射类&type=IPAD"
#define URL_PLASTIC   @"download2?folderName=整形外科&type=IPAD"
#define URL_HEALTH    @"download2?folderName=大健康类&type=IPAD"
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
- (void)requestPhotoDataWithIndex:(NSInteger)index finishBlock:(FinishBlock)finishBlock failedBlock:(FailedBlock)failedBlock {
    NSString *url;

    switch (index) {
            case 0:
        {
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_LASER]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

        }
            break;

            case 1:
        {
            // 1.拼接URL来获取图片的路径
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_INJECTION]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

        }
            break;

        case 2:
        {
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_PLASTIC]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

        }
            break;

        case 3:
        {
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_HEALTH]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

        }
            break;

        default:
            break;
    }

    [self requestPhotoURL:url
                Index:index
         SucceedBlock:^{
             finishBlock();
         }FailedBlock:^{
             failedBlock();
         }];
}


#pragma mark - 获取缩略图和高清图的url
- (void)requestPhotoURL:(NSString *)url Index:(NSInteger)index SucceedBlock:(SucceedBlock)succeedBlock FailedBlock:(FailedBlock)failedBlock {
    [[NetworkTool sharedNetworkTool]getWithURL:url params:nil success:^(id responseObject) {
        //NSLog(@"%@", responseObject);
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];


       // NSLog(@"获取的缩略图片数据-----%@", str);

        NSInteger length = str.length;
        if(length < 3) {
            failedBlock();
            return ;
        }
        str = [str substringWithRange:NSMakeRange(1, length-2)];

        // 2.拿到缩略图的路径
        NSArray *thumbnailUrls =[str componentsSeparatedByString:@"],"];

        // 3.拼接一个完整的图片路径
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < thumbnailUrls.count; i++) {
            _laserModel = [LaserModel new];

            _injectionModel = [InjectionModel new];

            _plasticModel = [PlasticModel new];

            _healthModel = [HealthModel new];

            NSInteger length = [thumbnailUrls[i] length];
            NSString *photoUrl = [thumbnailUrls[i] substringWithRange:(i==thumbnailUrls.count-1)? NSMakeRange(1, length-2): NSMakeRange(1, length-1)];

            NSArray *allPhotoUrls = [photoUrl componentsSeparatedByString:@"},"];

            NSString *thumbnailImageUrl = nil;
            NSMutableArray *orignalImageUrls = [NSMutableArray array];
            for (int j = 0; j < allPhotoUrls.count; j++) {
                NSInteger len = [allPhotoUrls[j]length];
                NSString *photoUrl = [allPhotoUrls[j] substringWithRange:(j==allPhotoUrls.count-1)? NSMakeRange(1, len-2):NSMakeRange(1, len-1)];
                NSArray *photoUrls = [photoUrl componentsSeparatedByString:@":"];
                NSLog(@"%@---%@", photoUrls[0], photoUrls[1]);
                if ([photoUrls[0] isEqualToString:@"\"thumbnailImagrUrl\""]) {
                    thumbnailImageUrl = photoUrls[1];
                    NSInteger len = thumbnailImageUrl.length;
                    thumbnailImageUrl = [thumbnailImageUrl substringWithRange:NSMakeRange(2, len-4)];
                    thumbnailImageUrl = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, thumbnailImageUrl]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

                }
                if ([photoUrls[0] isEqualToString:@"\"orignalImagrUrls\""]){
                    NSInteger len = [photoUrls[1] length];
                    NSString *allOrignalImageUrl = [photoUrls[1] substringWithRange:NSMakeRange(1, len-2)];

                    NSArray *orignalUrls = [allOrignalImageUrl componentsSeparatedByString:@","];
                    if (orignalUrls.count == 0) return;
                    for (int k = 0; k < orignalUrls.count; k++) {
                        NSInteger len = [orignalUrls[k] length];
                        if(len < 5) return;
                        NSString *orignalImageUrl = [orignalUrls[k] substringWithRange:NSMakeRange(1, len-2)];
                        orignalImageUrl = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, orignalImageUrl]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                        [orignalImageUrls addObject: orignalImageUrl];
                    }
                }
            }



            if (index == 0) {
                    _laserModel.thumbnailImagrUrl = thumbnailImageUrl;
                    _laserModel.orignalImagrUrls = orignalImageUrls;
                    [self.lasers addObject:_laserModel];

                    //将model转换为NSData
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_laserModel];
                    [datas addObject:data];
                    [USER_DEFAULT setObject:datas forKey:UserDefault_Laser];

                }else if (index == 1){
                    _injectionModel.thumbnailImagrUrl = thumbnailImageUrl;
                    _injectionModel.orignalImagrUrls = orignalImageUrls;
                    [self.injections addObject:_injectionModel];

                    //将model转换为NSData
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_injectionModel];
                    [datas addObject:data];
                    [USER_DEFAULT setObject:datas forKey:UserDefault_Injection];
                }else if (index == 2){
                    _plasticModel.thumbnailImagrUrl = thumbnailImageUrl;
                    _plasticModel.orignalImagrUrls = orignalImageUrls;
                    [self.plastics addObject:_plasticModel];

                    //将model转换为NSData
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_plasticModel];
                    [datas addObject:data];
                    [USER_DEFAULT setObject:datas forKey:UserDefault_Plastic];
                }else{
                    _healthModel.thumbnailImagrUrl = thumbnailImageUrl;
                    _healthModel.orignalImagrUrls = orignalImageUrls;
                    [self.healths addObject:_healthModel];

                    //将model转换为NSData
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_healthModel];
                    [datas addObject:data];
                    [USER_DEFAULT setObject:datas forKey:UserDefault_Health];
                }
            }
        succeedBlock();
    } fail:^(NSError *error) {
        NSLog(@"fail");
    }];

}


- (void)requestAllData:(FinishBlock)finishBlock {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        [self requestPhotoDataWithIndex:0 finishBlock:^{
            //finishBlock();
        }failedBlock:^{

        }];
    });
    dispatch_group_async(group, queue, ^{
        [self requestPhotoDataWithIndex:1 finishBlock:^{
            //finishBlock();
        }failedBlock:^{

        }];

    });
    dispatch_group_async(group, queue, ^{
        [self requestPhotoDataWithIndex:2 finishBlock:^{
            //finishBlock();
        }failedBlock:^{

        }];

    });
    dispatch_group_async(group, queue, ^{
        [self requestPhotoDataWithIndex:3 finishBlock:^{
            //finishBlock();
        }failedBlock:^{

        }];
    });

    dispatch_group_notify(group, queue, ^{
        finishBlock();
    });
}
/** 获取是否执行崩溃的bool值 */
- (void)requestCrashValue:(void (^)(BOOL isCrash))block {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_MakeCrash];
    [[NetworkTool sharedNetworkTool]getWithURL:url params:nil success:^(id responseObject) {
        NSString *crashStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        _isCrash = [crashStr boolValue];
        block(_isCrash);
        
    } fail:^(NSError *error) {
        NSLog(@"failed");
    }];
}
@end
