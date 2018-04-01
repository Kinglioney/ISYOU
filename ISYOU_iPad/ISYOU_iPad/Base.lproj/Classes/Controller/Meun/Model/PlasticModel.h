//
//  PlasticModel.h
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlasticModel : NSObject<NSCoding>

/** 缩略图的URL */
@property (nonatomic, copy) NSString *thumbnailImagrUrl;


/** 原图的URL数组 */
@property (nonatomic, strong) NSMutableArray *orignalImagrUrls;


@end
