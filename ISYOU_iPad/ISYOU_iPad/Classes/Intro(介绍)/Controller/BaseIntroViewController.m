//
//  BaseIntroViewController.m
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseIntroViewController.h"


@interface BaseIntroViewController ()<MWPhotoBrowserDelegate>

@end

@implementation BaseIntroViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPhotoBrowser];
}
//MARK: setter
- (void)setImagesURL:(NSMutableArray *)imagesURL{
    _imagesURL = imagesURL;
}

- (void)setupPhotoBrowser{
    _photoBrowser = [[MWPhotoBrowser alloc]init];
    _photoBrowser.delegate = self;
    _photoBrowser.displayNavArrows = NO;
    _photoBrowser.displayActionButton = NO;
    _photoBrowser.zoomPhotosToFill = YES;
    [_photoBrowser showNextPhotoAnimated:YES];
    [_photoBrowser showPreviousPhotoAnimated:YES];
    [_photoBrowser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:_photoBrowser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imagesURL.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    //创建图片模型
    NSString *urlStr = self.imagesURL[index];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *photoUrl = [[NSURL alloc]initWithString:urlStr];
    MWPhoto *photo = [MWPhoto photoWithURL:photoUrl];
    return photo;
}

@end
