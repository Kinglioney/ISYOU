//
//  BaseMenuViewController.m
//  ISYOU
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseMenuViewController.h"
//#import "PYPhotoBrowser.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "BaseMenuCell.h"
#import "LaserDetailViewController.h"
#import "InjectionDetailViewController.h"
#import "HealthDetailViewController.h"
#import "PlasticDetailViewController.h"
#import "MenuViewModel.h"
#import "LaserModel.h"
#import "InjectionModel.h"
#import "PlasticModel.h"
#import "HealthModel.h"
#define kCellId @"kCellId"

@interface BaseMenuViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate>
//@property (nonatomic, strong) PYPhotosView *flowPhotosView;

//@property (nonatomic, strong) PYPhotoBrowseView *photoBrowser;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *cellFrames;

@property (nonatomic, strong) MenuViewModel *menuVM;

@property (nonatomic, copy  ) NSArray *laserDataModels;

@property (nonatomic, copy  ) NSArray *injectionDataModels;

@property (nonatomic, copy  ) NSArray *plasticDataModels;

@property (nonatomic, copy  ) NSArray *healthDataModels;

@property (nonatomic, strong) LaserModel *laserModel;

@property (nonatomic, strong) InjectionModel *injectionModel;

@property (nonatomic, strong) PlasticModel *plasticModel;

@property (nonatomic, strong) HealthModel *healthModel;

@property (nonatomic, copy  ) NSString *dateStr;

@property (nonatomic, assign) NSInteger index;//记录点击是哪一个cell

@property (nonatomic, strong)  MBProgressHUD *hud;
@end

@implementation BaseMenuViewController

//MARK: 系统方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:159/255.0 blue:9/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}
//MARK: 懒加载
- (NSArray *)laserDataModels {
    if (!_laserDataModels) {
        _laserDataModels = [NSArray array];
        _laserDataModels = [USER_DEFAULT objectForKey:UserDefault_Laser];
    }
    return _laserDataModels;
}

- (NSArray *)injectionDataModels {
    if (!_injectionDataModels) {
        _injectionDataModels = [NSArray array];
        _injectionDataModels = [USER_DEFAULT objectForKey:UserDefault_Injection];
    }
    return _injectionDataModels;
}

- (NSArray *)plasticDataModels {
    if (!_plasticDataModels) {
        _plasticDataModels = [NSArray array];
        _plasticDataModels = [USER_DEFAULT objectForKey:UserDefault_Plastic];
    }
    return _plasticDataModels;
}

- (NSArray *)healthDataModels {
    if (!_healthDataModels) {
        _healthDataModels = [NSArray array];
        _healthDataModels = [USER_DEFAULT objectForKey:UserDefault_Health];
    }
    return _healthDataModels;
}


- (NSMutableArray *)cellFrames {
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (void)setup{
    CGFloat lineMargin = 30;//行间距
    CGFloat colMargin = 40;//列间距
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = lineMargin;//行间距
    layout.minimumInteritemSpacing = colMargin;//列间距
    CGFloat itemW = (kSCREEN_WIDTH - 3 * colMargin)/2;
    CGFloat itemH = itemW *  524 / 482;
    layout.itemSize = CGSizeMake(itemW, itemH);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, colMargin/2, 0, colMargin/2);
    _collectionView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT);
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BaseMenuCell class]) bundle:nil] forCellWithReuseIdentifier:kCellId];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = NO;
    [self.view addSubview:_collectionView];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.hud hide:YES];
    });
}



#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.thumbnailImageUrls.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    BaseMenuCell *bmCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    bmCell.layer.borderWidth = 0.5;
    bmCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bmCell.layer.cornerRadius = 12;
    //[NSCharacterSet URLQueryAllowedCharacterSet]
    NSString *urlStr = self.thumbnailImageUrls[indexPath.row];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    //[bmCell.thumbnailImageView sd_setImageWithURL:url];
    //_hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    _hud.mode = MBProgressHUDAnimationFade;
    _hud.labelText = @"Loading";
    __weak typeof(self) weakSelf = self;
    [bmCell.thumbnailImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.hud hide:YES];
    }];
    cell = bmCell;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = (kSCREEN_WIDTH - 3 * 30)/2;
    CGFloat itemH = itemW * 524 / 482;
    return CGSizeMake(itemW, itemH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _index = indexPath.row;
    for (UICollectionViewCell *cell in collectionView.subviews) {
        NSLog(@"Rect---%f,%f,%f,%f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        CGRect frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    [self setupPhotoBrowser:indexPath.row];
}

#pragma mark - 初始化图片浏览器
- (void)setupPhotoBrowser:(NSInteger)index{
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


//MARK: setter
-(void)setThumbnailImageUrls:(NSMutableArray *)thumbnailImageUrls{
    _thumbnailImageUrls = thumbnailImageUrls;
    //根据缩略图的数量设置contentSize
    CGFloat lineMargin = 30;//行间距
    CGFloat colMargin = 40;//列间距
    CGFloat itemW = (kSCREEN_WIDTH - 3 * colMargin)/2;
    CGFloat itemH = itemW *  524 / 482;
    self.collectionView.contentSize = CGSizeMake(kSCREEN_WIDTH, (lineMargin+itemH)*(thumbnailImageUrls.count/2+1));
    [self.collectionView reloadData];
}
-(void)setOriginalImageUrls:(NSMutableArray *)originalImageUrls{
    _originalImageUrls = originalImageUrls;
    if (self.originalImageUrls.count==0) return;
}

//#pragma mark - PYPhotoBrowseViewDataSource
//- (NSArray<NSString *> *)imagesURLForBrowse{
//
//    return self.originalImageUrls[_index];
//}
//
//
//#pragma mark - PYPhotoBrowseViewDelegate
//- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didSingleClickedImage:(UIImage *)image index:(NSInteger)index{
//
//    [photoBrowseView hidden];
//
//}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.originalImageUrls[_index] count];
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    //创建图片模型
    NSString *urlStr = self.originalImageUrls[_index][index];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *photoUrl = [[NSURL alloc]initWithString:urlStr];
    MWPhoto *photo = [MWPhoto photoWithURL:photoUrl];
    return photo;
}
@end
