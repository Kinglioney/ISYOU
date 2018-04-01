//
//  ISYOUViewController.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ISYOUViewController.h"
#import "IsyouModel.h"

@interface ISYOUViewController ()

@end

@implementation ISYOUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}


- (void)setIsyouModel:(IsyouModel *)isyouModel {
    _isyouModel = isyouModel;
    [super setImagesURL:isyouModel.orignalImagrUrls];
}

@end
