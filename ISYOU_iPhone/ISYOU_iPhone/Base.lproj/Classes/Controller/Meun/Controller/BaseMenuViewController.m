//
//  BaseMenuViewController.m
//  ISYOU
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseMenuViewController.h"
#import "PYPhotoBrowser.h"
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

@interface BaseMenuViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PYPhotoBrowseViewDataSource, PYPhotoBrowseViewDelegate>
@property (nonatomic, strong) PYPhotosView *flowPhotosView;

@property (nonatomic, strong) PYPhotoBrowseView *photoBrowser;

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
@end

@implementation BaseMenuViewController
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
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, lineMargin, kSCREEN_WIDTH, kSCREEN_HEIGHT) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, colMargin/2, 0, colMargin/2);
    _collectionView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT+20);
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BaseMenuCell class]) bundle:nil] forCellWithReuseIdentifier:kCellId];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = NO;
    //_collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_collectionView];
    
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.equalTo(self.view);
//    }];
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
    NSURL *url = self.thumbnailImageUrls[indexPath.row];

    [bmCell.thumbnailImageView sd_setImageWithURL:url];
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


- (void)setupPhotoBrowser:(NSInteger)index{
    _photoBrowser = [[PYPhotoBrowseView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _photoBrowser.dataSource = self;
    _photoBrowser.delegate = self;
    _photoBrowser.autoRotateImage = NO;
    CGRect frame = [self.cellFrames[index] CGRectValue];
    //CGFloat lineMargin = 30;//行间距
    CGFloat colMargin = 40;//列间距
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat formX = frame.origin.x + colMargin/2;
    CGFloat formY = frame.origin.y + 100 ;
    CGFloat toX = formX ;
    CGFloat toY = formY ;

    //显示图片相对于主窗口的位置
    _photoBrowser.frameFormWindow = CGRectMake(formX, formY, width, height);
    //消失回到相对于住窗口的指定位置
    _photoBrowser.frameToWindow = CGRectMake(toX, toY, width, height);;
    _photoBrowser.placeholderImage = [UIImage imageNamed:@"bg_lightGray"];
    _photoBrowser.hiddenDuration = 0.20;
    _photoBrowser.showDuration = 0.20;
    
    [_photoBrowser show];
}


//MARK: setter
-(void)setThumbnailImageUrls:(NSMutableArray *)thumbnailImageUrls{
    _thumbnailImageUrls = thumbnailImageUrls;
    [self.collectionView reloadData];

}
-(void)setOriginalImageUrls:(NSMutableArray *)originalImageUrls{
    _originalImageUrls = originalImageUrls;
    if (self.photoBrowser) {
        [self.photoBrowser removeFromSuperview];

    }
    if (self.originalImageUrls.count==0) return;
}

#pragma mark - PYPhotoBrowseViewDataSource
- (NSArray<NSString *> *)imagesURLForBrowse{

    return self.originalImageUrls[_index];
}


#pragma mark - PYPhotoBrowseViewDelegate
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didSingleClickedImage:(UIImage *)image index:(NSInteger)index{

    [photoBrowseView hidden];
    
}
@end
