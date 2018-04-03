//
//  LaserViewController.m
//  ISYOU
//  激光类
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LaserViewController.h"
#import "LaserModel.h"
@interface LaserViewController ()

@end

@implementation LaserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"激光类";
}

- (void)setLaserModels:(NSArray *)laserModels{
    _laserModels = laserModels;
    NSMutableArray *muThumbnails = [NSMutableArray array];
    NSMutableArray *muOrignals = [NSMutableArray array];
    for (LaserModel *model in laserModels) {
        [muThumbnails addObject:model.thumbnailImagrUrl];
        [muOrignals addObject:model.orignalImagrUrls];
    }

    [super setThumbnailImageUrls:muThumbnails];
    [super setOriginalImageUrls:muOrignals];
}
@end
