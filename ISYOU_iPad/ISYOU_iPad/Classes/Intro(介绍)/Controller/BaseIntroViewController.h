//
//  BaseIntroViewController.h
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
@interface BaseIntroViewController : UIViewController

/** 图片浏览器 */
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

/** 图片的url */
@property (nonatomic, strong) NSMutableArray *imagesURL;

/** 子目录的索引值 */
@property (nonatomic, assign) NSInteger childMeunIndex;

- (void)setupPhotoBrowser;

@end
