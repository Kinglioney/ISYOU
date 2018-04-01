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

typedef void(^FinishBlock)();
typedef void(^SucceedBlock)();
typedef void(^FailedBlock)();
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

- (void)requestDataWithIndex:(NSInteger)index finishBlock:(FinishBlock)finishBlock failedBlock:(FailedBlock)failedBlock;


- (void)requestAllData:(FinishBlock)finishBlock;

@end
