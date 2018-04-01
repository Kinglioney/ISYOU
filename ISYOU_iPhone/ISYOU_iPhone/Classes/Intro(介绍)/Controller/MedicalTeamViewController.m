//
//  MedicalTeamViewController.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MedicalTeamViewController.h"
#import "MedicalTeamModel.h"
@interface MedicalTeamViewController ()

@end

@implementation MedicalTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setMedicalTeamModel:(MedicalTeamModel *)medicalTeamModel {
    _medicalTeamModel = medicalTeamModel;
    [super setImagesURL:medicalTeamModel.orignalImagrUrls];
}
@end
