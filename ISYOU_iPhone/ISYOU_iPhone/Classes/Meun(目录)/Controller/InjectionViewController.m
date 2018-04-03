//
//  InjectionViewController.m
//  ISYOU
//  注射类
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "InjectionViewController.h"
#import "InjectionModel.h"
@interface InjectionViewController ()

@end

@implementation InjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注射类";
}

- (void)setInjectionModels:(NSArray *)injectionModels{
    _injectionModels = injectionModels;
    NSMutableArray *muThumbnails = [NSMutableArray array];
    NSMutableArray *muOrignals = [NSMutableArray array];
    for (InjectionModel *model in injectionModels) {
        if(model.thumbnailImagrUrl){
            [muThumbnails addObject:model.thumbnailImagrUrl];
            [muOrignals addObject:model.orignalImagrUrls];
        }
    }
    [super setThumbnailImageUrls:muThumbnails];
    [super setOriginalImageUrls:muOrignals];
    
}
@end
