//
//  BaseIntroViewController.m
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseIntroViewController.h"


@interface BaseIntroViewController ()

@end

@implementation BaseIntroViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
//MARK: setter
- (void)setImagesURL:(NSMutableArray *)imagesURL{
    _imagesURL = imagesURL;
    if (self.photoBrowser) {
        
        [self.photoBrowser removeFromSuperview];
    }
    if (imagesURL.count) [self setupPhotoBrowser];
    else return;
}

- (void)setupPhotoBrowser{
    _photoBrowser = [[PYPhotoBrowseView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _photoBrowser.dataSource = self;
    _photoBrowser.delegate = self;
    _photoBrowser.frameFormWindow = CGRectMake(28+10,(10 + 56) * _childMeunIndex + 56/2 + 75, 10, 10);
    _photoBrowser.frameToWindow = CGRectMake(28+10, (10 + 56) * _childMeunIndex + 56/2 + 75, 1, 1);
    _photoBrowser.placeholderImage = [UIImage imageNamed:@"bg_lightGray"];
    _photoBrowser.hiddenDuration = 0.18;
    _photoBrowser.showDuration = 0.2;
    _photoBrowser.autoRotateImage = NO;
    [_photoBrowser show];
}
#pragma mark - PYPhotoBrowseViewDataSource
- (NSArray<NSString *> *)imagesURLForBrowse{

    return self.imagesURL;
}

#pragma mark - PYPhotoBrowseViewDelegate
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didSingleClickedImage:(UIImage *)image index:(NSInteger)index{

    [photoBrowseView hidden];

    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
