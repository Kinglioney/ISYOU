//
//  MenuViewModel.h
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 请求数据的类型枚举*/
typedef NS_ENUM(NSInteger, RequestMenuDataType) {
    RequestMenuDataTypeLaser = 0,//激光类
    RequestMenuDataTypeInjection,//注射类
    RequestMenuDataTypePlastic,//整形外科
    RequestMenuDataTypeHealth,//大健康类
    
};
typedef void(^FinishBlock)(void);
typedef void(^SucceedBlock)(void);
typedef void(^FailedBlock)(void);

@interface MenuViewModel : NSObject
/** 激光类模型数组 */
@property (nonatomic, strong) NSMutableArray *lasers;
/** 注射类模型数组 */
@property (nonatomic, strong) NSMutableArray *injections;
/** 整形外科模型数组 */
@property (nonatomic, strong) NSMutableArray *plastics;
/** 大健康类模型数组 */
@property (nonatomic, strong) NSMutableArray *healths;
/** 程序崩溃的标志 */
@property (nonatomic, assign) BOOL isCrash;
/** block */
@property (nonatomic, copy  ) FinishBlock finishBlock;

@property (nonatomic, copy  ) SucceedBlock succeedBlock;

@property (nonatomic, copy  ) FailedBlock failedBlock;

/** 获取缩略图和高清图的数据 */
- (void)requestPhotoDataWithType:(RequestMenuDataType)type finishBlock:(FinishBlock)finishBlock failedBlock:(FailedBlock)failedBlock;
/** 获取是否执行崩溃的bool值 */
- (void)requestCrashValue:(void (^)(BOOL isCrash))block;

@end
