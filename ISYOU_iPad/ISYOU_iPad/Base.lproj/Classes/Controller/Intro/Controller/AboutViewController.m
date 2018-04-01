//
//  AboutViewController.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutModel.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setAboutModel:(AboutModel *)aboutModel {
    _aboutModel = aboutModel;
    [super setImagesURL:aboutModel.orignalImagrUrls];
}
@end
