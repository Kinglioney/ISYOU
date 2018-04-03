//
//  HealthViewController.m
//  ISYOU
//  大健康类
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HealthViewController.h"
#import "HealthModel.h"
@interface HealthViewController ()

@end

@implementation HealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"大健康";
}

//MARK: setter
- (void)setHealthModels:(NSArray *)healthModels{
    _healthModels = healthModels;
    NSMutableArray *muThumbnails = [NSMutableArray array];
    NSMutableArray *muOrignals = [NSMutableArray array];
    for (HealthModel *model in healthModels) {
        [muThumbnails addObject:model.thumbnailImagrUrl];
        [muOrignals addObject:model.orignalImagrUrls];
    }
    [super setThumbnailImageUrls:muThumbnails];
    [super setOriginalImageUrls:muOrignals];
}



@end
