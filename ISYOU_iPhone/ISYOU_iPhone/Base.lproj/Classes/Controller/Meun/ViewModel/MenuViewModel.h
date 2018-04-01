//
//  MenuViewModel.h
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^FinishBlock)();
typedef void(^SucceedBlock)();
typedef void(^FailedBlock)();
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

/** 获取所有的缩略图的数据 */
- (void)requestAllData:(FinishBlock)finishBlock;

/** 获取缩略图和高清图的数据 */
- (void)requestPhotoDataWithIndex:(NSInteger)index finishBlock:(FinishBlock)finishBlock failedBlock:(FailedBlock)failedBlock;

/** 获取是否执行崩溃的bool值 */
- (void)requestCrashValue:(void (^)(BOOL isCrash))block;

@end
