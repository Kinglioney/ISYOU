//
//  IntroViewModel.m
//  ISYOU
//  用来从网络获取需要的数据
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "IntroViewModel.h"
#import "NetworkTool.h"

#define SERVER_ADDR   @"http://122.114.15.61:8090/isyou/"
#define URL_ISYOU     @"download2?folderName=ISYOU&version=IPHONE"
#define URL_MEDICAL   @"download2?folderName=医疗团队&version=IPHONE"
#define URL_AREANAV   @"download2?folderName=区域导航&version=IPHONE"
#define URL_SERVICE   @"download2?folderName=服务团队&version=IPHONE"
#define URL_ABOUT     @"download2?folderName=关于我们&version=IPHONE"
@interface IntroViewModel()

@end
@implementation IntroViewModel
//MARK: 网络请求
- (void)requestDataWithType:(RequestIntroDataType)type finishBlock:(FinishBlock)finishBlock failedBlock:(FailedBlock)failedBlock {
    NSString *url;
    switch (type) {
        case RequestIntroDataTypeIsyou:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_ISYOU]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        case RequestIntroDataTypeMedical:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_MEDICAL]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        case RequestIntroDataTypeAreanav:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_AREANAV]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        case RequestIntroDataTypeService:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_SERVICE]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        case RequestIntroDataTypeAbout:
            url = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, URL_ABOUT]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            break;
        default:
            break;
    }

    [self requestPhotoURL:url
                    Type:type
             SucceedBlock:^{
                 finishBlock();
             }
            failedBlock:^{
                 failedBlock();
            }
     ];



}
- (void)requestPhotoURL:(NSString *)url Type:(RequestIntroDataType)type SucceedBlock:(SucceedBlock)succeedBlock failedBlock:(FailedBlock)failedBlock{
    __weak typeof(self) weakSelf = self;
    //url = @"http://capi.douyucdn.cn/api/v1/getVerticalRoom";
    [[NetworkTool sharedNetworkTool]get:url params:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *results = responseObject;
        if(results.count == 0 || results == nil) {
            return;
        }
        NSDictionary *orignalImagrDic = [[results lastObject]lastObject];
        NSArray *orignalImageUrlArr = orignalImagrDic[@"orignalImagrUrls"];
        NSString *orignalImageUrl = @"";
        weakSelf.isyouModel = [IsyouModel new];
        weakSelf.medicalModel = [MedicalTeamModel new];
        weakSelf.areaModel = [AreaModel new];
        weakSelf.serviceModel = [ServiceTeamModel new];
        weakSelf.aboutModel = [AboutModel new];
        weakSelf.isyouModel.orignalImagrUrls = [NSMutableArray array];
        weakSelf.medicalModel.orignalImagrUrls = [NSMutableArray array];
        weakSelf.areaModel.orignalImagrUrls = [NSMutableArray array];
        weakSelf.serviceModel.orignalImagrUrls = [NSMutableArray array];
        weakSelf.aboutModel.orignalImagrUrls = [NSMutableArray array];

        //拼接一个完整的图片路径
        for (int i = 0; i < orignalImageUrlArr.count; i++) {
            orignalImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDR, orignalImageUrlArr[i]];
            orignalImageUrl = [orignalImageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            NSLog(@"高清图的URL：%@", orignalImageUrl);
            if(type == RequestIntroDataTypeIsyou) {
                [weakSelf.isyouModel.orignalImagrUrls addObject:orignalImageUrl];
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.isyouModel];
                [USER_DEFAULT setObject:data forKey:UserDefault_Isyou];
            }else if (type == RequestIntroDataTypeMedical) {
                [weakSelf.medicalModel.orignalImagrUrls addObject: orignalImageUrl];
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.medicalModel];
                [USER_DEFAULT setObject:data forKey:UserDefault_Medical];
            }else if (type == RequestIntroDataTypeAreanav){
                [weakSelf.areaModel.orignalImagrUrls addObject: orignalImageUrl];
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.areaModel];
                [USER_DEFAULT setObject:data forKey:UserDefault_Area];
            }else if (type == RequestIntroDataTypeService){
                [weakSelf.serviceModel.orignalImagrUrls addObject: orignalImageUrl];
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.serviceModel];
                [USER_DEFAULT setObject:data forKey:UserDefault_Service];
            }else{
                [weakSelf.aboutModel.orignalImagrUrls addObject: orignalImageUrl];
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.aboutModel];
                [USER_DEFAULT setObject:data forKey:UserDefault_About];
            }
        }
        succeedBlock();
    } fail:^(NSError *error) {
        NSLog(@"fail");
    }];
    
}

@end
