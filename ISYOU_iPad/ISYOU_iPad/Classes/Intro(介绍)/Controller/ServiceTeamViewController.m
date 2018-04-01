//
//  ServiceTeamViewController.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ServiceTeamViewController.h"
#import "ServiceTeamModel.h"
@interface ServiceTeamViewController ()

@end

@implementation ServiceTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setServiceTeamModel:(ServiceTeamModel *)serviceTeamModel {
    _serviceTeamModel = serviceTeamModel;
    [super setImagesURL:serviceTeamModel.orignalImagrUrls];
}

@end
