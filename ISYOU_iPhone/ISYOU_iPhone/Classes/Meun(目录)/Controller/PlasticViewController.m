//
//  PlasticViewController.m
//  ISYOU
//  整形外科
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PlasticViewController.h"
#import "PlasticModel.h"
@interface PlasticViewController ()

@end

@implementation PlasticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"整形外科";
    // Do any additional setup after loading the view.
}

- (void)setPlasticModels:(NSArray *)plasticModels{
    _plasticModels = plasticModels;
    NSMutableArray *muThumbnails = [NSMutableArray array];
    NSMutableArray *muOrignals = [NSMutableArray array];
    for (PlasticModel *model in plasticModels) {
        [muThumbnails addObject:model.thumbnailImagrUrl];
        [muOrignals addObject:model.orignalImagrUrls];
    }
    [super setThumbnailImageUrls:muThumbnails];
    [super setOriginalImageUrls:muOrignals];
}

@end
