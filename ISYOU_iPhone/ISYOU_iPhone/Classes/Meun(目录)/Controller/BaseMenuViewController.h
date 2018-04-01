//
//  BaseMenuViewController.h
//  ISYOU
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseMenuViewController : UIViewController

/** 缩略图 */
@property (nonatomic, strong) NSMutableArray *thumbnailImageUrls;

/** 详情图 */
@property (nonatomic, strong) NSMutableArray *originalImageUrls;

/** 子目录的索引值 */
@property (nonatomic, assign) NSInteger childMeunIndex;

@end
