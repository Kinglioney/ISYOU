//
//  AreaNavViewController.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AreaNavViewController.h"
#import "AreaModel.h"
@interface AreaNavViewController ()

@end

@implementation AreaNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setAreaModel:(AreaModel *)areaModel {
    _areaModel = areaModel;
    [super setImagesURL:areaModel.orignalImagrUrls];
}
@end
