//
//  IsyouModel.h
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsyouModel : NSObject<NSCoding>

/** 原图的URL数组 */
@property (nonatomic, strong) NSMutableArray *orignalImagrUrls;

@end
