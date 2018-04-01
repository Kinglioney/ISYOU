//
//  IntroViewModel.h
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IsyouModel.h"
#import "MedicalTeamModel.h"
#import "AreaModel.h"
#import "ServiceTeamModel.h"
#import "AboutModel.h"
/**定义请求数据的回调*/
typedef void(^FinishBlock)(void);
typedef void(^SucceedBlock)(void);
typedef void(^FailedBlock)(void);
/**定义请求数据的类型枚举*/
typedef NS_ENUM(NSInteger, RequestIntroDataType) {
    RequestIntroDataTypeIsyou = 0,//ISYOU
    RequestIntroDataTypeMedical,//医疗团队
    RequestIntroDataTypeAreanav,//区域导航
    RequestIntroDataTypeService,//服务团队
    RequestIntroDataTypeAbout,//关于我们
    
    
};
@interface IntroViewModel : NSObject

/** ISYOU模型 */
@property (nonatomic, strong) IsyouModel *isyouModel;
/** 医疗团队模型 */
@property (nonatomic, strong) MedicalTeamModel *medicalModel;
/** 区域导航模型 */
@property (nonatomic, strong) AreaModel *areaModel;
/** 服务团队模型*/
@property (nonatomic, strong) ServiceTeamModel *serviceModel;
/** 关于我们模型 */
@property (nonatomic, strong) AboutModel *aboutModel;

@property (nonatomic, copy  ) FinishBlock finishBlock;

@property (nonatomic, copy  ) SucceedBlock succeedBlock;

@property (nonatomic, copy  ) FailedBlock failedBlock;

- (void)requestDataWithType:(RequestIntroDataType)type finishBlock:(FinishBlock)finishBlock failedBlock:(FailedBlock)failedBlock;

@end
