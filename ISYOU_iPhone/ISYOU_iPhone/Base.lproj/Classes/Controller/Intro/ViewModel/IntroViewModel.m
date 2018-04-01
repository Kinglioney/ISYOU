//
//  IntroViewModel.m
//  ISYOU
//  用来从网络获取需要的数据
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "IntroViewModel.h"
#import "NetworkTool.h"

#define SERVER_ADDR   @"http://119.23.41.147:8080/isyou/"
#define URL_ISYOU     @"download2?folderName=ISYOU&type=IPHONE"
#define URL_MEDICAL   @"download2?folderName=医疗团队&type=IPHONE"
#define URL_AREANAV   @"download2?folderName=区域导航&type=IPHONE"
#define URL_SERVICE   @"download2?folderName=服务团队&type=IPHONE"
#define URL_ABOUT     @"download2?folderName=关于我们&type=IPHONE"
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
    [[NetworkTool sharedNetworkTool]getWithURL:url params:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSInteger length = str.length;
        if(length < 3) {
            failedBlock();
            return ;
        }
        str = [str substringWithRange:NSMakeRange(1, length-2)];

        // 2.拿到缩略图的路径
        NSArray *orignalUrls =[str componentsSeparatedByString:@"],"];
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

        // 3.拼接一个完整的图片路径
       // NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < orignalUrls.count; i++) {

            NSInteger length = [orignalUrls[i] length];
            NSString *photoUrl = [orignalUrls[i] substringWithRange:(i==orignalUrls.count-1)? NSMakeRange(1, length-2): NSMakeRange(1, length-1)];

            NSArray *allPhotoUrls = [photoUrl componentsSeparatedByString:@"},"];

            NSString *orignalImageUrl = nil;
            //NSMutableArray *orignalImageUrls = [NSMutableArray array];
            for (int j = 0; j < allPhotoUrls.count; j++) {
                NSInteger len = [allPhotoUrls[j]length];
                NSString *photoUrl = [allPhotoUrls[j] substringWithRange:(j==allPhotoUrls.count-1)? NSMakeRange(1, len-2):NSMakeRange(1, len-1)];
                NSArray *photoUrls = [photoUrl componentsSeparatedByString:@":"];
                NSLog(@"%@---%@", photoUrls[0], photoUrls[1]);
                if ([photoUrls[0] isEqualToString:@"\"thumbnailImagrUrl\""]) {
                    orignalImageUrl = photoUrls[1];
                    NSInteger len = orignalImageUrl.length;
                    orignalImageUrl = [orignalImageUrl substringWithRange:NSMakeRange(2, len-4)];
                    orignalImageUrl = [[NSString stringWithFormat:@"%@%@", SERVER_ADDR, orignalImageUrl]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

                }
            }


            if(type == RequestIntroDataTypeIsyou) {
                
                [weakSelf.isyouModel.orignalImagrUrls addObject:orignalImageUrl];
                //[self.isyous addObject:_isyouModel];
                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.isyouModel];
                //[datas addObject:data];
                [USER_DEFAULT setObject:data forKey:UserDefault_Isyou];

            }else if (type == RequestIntroDataTypeMedical) {

                [weakSelf.medicalModel.orignalImagrUrls addObject: orignalImageUrl];
               // [self.medicalTeams addObject:_medicalModel];

                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.medicalModel];
                //[datas addObject:data];
                [USER_DEFAULT setObject:data forKey:UserDefault_Medical];

            }else if (type == RequestIntroDataTypeAreanav){

                [weakSelf.areaModel.orignalImagrUrls addObject: orignalImageUrl];
                

                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.areaModel];
                //[datas addObject:data];
                [USER_DEFAULT setObject:data forKey:UserDefault_Area];
            }else if (type == RequestIntroDataTypeService){

                [weakSelf.serviceModel.orignalImagrUrls addObject: orignalImageUrl];
                //[self.serviceTeams addObject:_serviceModel];

                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.serviceModel];
                //[datas addObject:data];
                [USER_DEFAULT setObject:data forKey:UserDefault_Service];
            }else{

                [weakSelf.aboutModel.orignalImagrUrls addObject: orignalImageUrl];
                //[self.abouts addObject:_aboutModel];

                //将model转换为NSData
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weakSelf.aboutModel];
                //[datas addObject:data];
                [USER_DEFAULT setObject:data forKey:UserDefault_About];
            }
        }

        succeedBlock();
    } fail:^(NSError *error) {
        NSLog(@"fail");
    }];
    
}

@end
