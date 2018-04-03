//
//  MenuViewController.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuBarView.h"
#import "ChildMenuBarView.h"
#import "ISYOUViewController.h"
#import "MedicalTeamViewController.h"
#import "AreaNavViewController.h"
#import "ServiceTeamViewController.h"
#import "AboutViewController.h"
#import "LaserViewController.h"
#import "InjectionViewController.h"
#import "PlasticViewController.h"
#import "HealthViewController.h"
#import "SHBAVController.h"
#import "UpdateView.h"
#import "IntroViewModel.h"
#import "MenuViewModel.h"

#import "IsyouModel.h"
#import "MedicalTeamModel.h"
#import "AreaModel.h"
#import "ServiceTeamModel.h"
#import "AboutModel.h"

#import "LaserModel.h"
#import "InjectionModel.h"
#import "PlasticModel.h"
#import "HealthModel.h"

#import "NetworkTool.h"
#import "MenuViewModel.h"

#import "AppDelegate.h"
static NSString *videoUrl = @"http://192.168.0.101:8080/isyou/video";


@interface MenuViewController ()<MenuBarViewDelegate, ChildMenuBarDelegate, UpdateDataDelegate>
/** 主目录和子目录 */
@property (nonatomic, strong) MenuBarView *menuBarView;
@property (nonatomic, strong) ChildMenuBarView *childMenuBar;

/** 主目录的索引值 */
@property (nonatomic, assign) NSInteger menuIndex;

/** 子目录的索引值 */
@property (nonatomic, assign) NSInteger childMenuIndex;

/* 图片更新界面**/
@property (nonatomic, strong) UpdateView *updateView;

/** 视图模型 */
@property (nonatomic, strong) IntroViewModel *introVM;
@property (nonatomic, strong) MenuViewModel *menuVM;

/** 网络状况 */
@property (nonatomic, assign) BOOL networkState;
/** 程序崩溃的标志 */
@property (nonatomic, assign) BOOL isCrash;
@end

@implementation MenuViewController

-(ChildMenuBarView *)childMenuBar{
    if (!_childMenuBar) {
        _childMenuBar = [[ChildMenuBarView alloc] initWithFrame:CGRectMake(28, 75, 51, kSCREEN_HEIGHT - 200)];
        _childMenuBar.delegate = self;
        [self.view addSubview:_childMenuBar];
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(updateData:)];
        longPress.minimumPressDuration = 3.0f;
        [_childMenuBar addGestureRecognizer:longPress];
    }

    return _childMenuBar;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _menuIndex = 1;//默认是第一个主目录
    
    // 导航栏
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:243/255.0 green:159/255.0 blue:9/255.0 alpha:1.0]];//设置背景颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//设置按钮颜色
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];

    //初始化视图模型
    _introVM = [[IntroViewModel alloc]init];
    [_introVM requestDataWithType:0 finishBlock:^{
        NSLog(@"获取ISYOU网络数据成功！");
        }failedBlock:^{
            return ;
    }];
    _menuVM = [[MenuViewModel alloc]init];

    // 背景图片
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    // 目录
    _menuBarView = [MenuBarView loadMenuBarView];
    _menuBarView.deleagte = self;
    _menuBarView.introLb.textColor = MainColor;
    [self.view addSubview:_menuBarView];
    
    [_menuBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-28);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.offset(50);
    }];

    self.childMenuBar.selectedIndex = 1;//默认是首页
    __weak typeof(self) weakSelf = self;
    //监听网络状态
    [[NetworkTool sharedNetworkTool] getNetworkState:^(BOOL state) {
        weakSelf.networkState = state;
        
        if ( weakSelf.networkState) {// 连接网络
            [self requestServertoDecideCrash:^(BOOL crash) {
                if (crash) {
                    [self makeAppCrash];
                }else{
                    [self playVideo];// 播放视频
                }
            }];
        }else {// 没有网络
             weakSelf.isCrash = [USER_DEFAULT boolForKey:UserDefaule_IsCrash];
            if (weakSelf.isCrash) {
                [self makeAppCrash];
            }else{
                [self playVideo];// 播放视频
            }
        }

    }];
    


}



- (void)updateData:(UILongPressGestureRecognizer *)gesture
{
    if (!_updateView) {
        _updateView = [[UpdateView alloc] init];
        _updateView.delegate = self;
        _updateView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_updateView];
        __weak typeof(self) weakSelf = self;
        [_updateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
        _updateView.transform = CGAffineTransformMakeScale(0, 0);

        [UIView animateWithDuration:0.38 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.updateView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        
        
        
    }
    
}


- (void)playVideo {
    [self goToPlayerWithUrl:[NSURL URLWithString:videoUrl]];
}

- (void)goToPlayerWithUrl:(NSURL *)url {
    SHBAVController *av = [[SHBAVController alloc] initWithUrl:url];
    [self presentViewController:av animated:true completion:nil];
    
}



#pragma mark - MenuBarViewDelegate
- (void)showChildMenuBarView:(NSInteger)index{
    _menuIndex = index;
    self.childMenuBar.selectedIndex = index;
}

#pragma mark - ChildMenuBarDelegate
- (void)clickChildMenuBarAction:(NSInteger)index{
    UIViewController *vc;
    _childMenuIndex = index;

    NSData *isyouModelsData = [USER_DEFAULT objectForKey:UserDefault_Isyou];
    NSData *medicalModelsData = [USER_DEFAULT objectForKey:UserDefault_Medical];
    NSData *areaModelsData = [USER_DEFAULT objectForKey:UserDefault_Area];
    NSData *serviceModelsData = [USER_DEFAULT objectForKey:UserDefault_Service];
    NSData *aboutModelsData = [USER_DEFAULT objectForKey:UserDefault_About];

    NSMutableArray *laserModelsData = [USER_DEFAULT objectForKey:UserDefault_Laser];
    NSMutableArray *injectionModelsData = [USER_DEFAULT objectForKey:UserDefault_Injection];
    NSMutableArray *plasticModelsData = [USER_DEFAULT objectForKey:UserDefault_Plastic];
    NSMutableArray *healthModelsData = [USER_DEFAULT objectForKey:UserDefault_Health];
    
    __weak typeof(self) weakSelf = self;
    switch (_menuIndex) {
        case 1://企业简介
        {
            if(index == 0){

                ISYOUViewController *iyVC = [[ISYOUViewController alloc]init];
                 iyVC.childMeunIndex = index;
                
                if (!isyouModelsData && !isyouModelsData.length) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    [_introVM requestDataWithType:index finishBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                        iyVC.isyouModel = self.introVM.isyouModel;
                    } failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{

                    IsyouModel *isyouModel = [NSKeyedUnarchiver unarchiveObjectWithData:isyouModelsData];

                    iyVC.isyouModel = isyouModel;
                }

                vc = iyVC;
            }else if (index == 1 ){
                if (!_networkState && !medicalModelsData.length) {
                    NSLog(@"请检查网络连接");
                    [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                    return;
                }
                MedicalTeamViewController *mtVC = [[MedicalTeamViewController alloc]init];

                mtVC.childMeunIndex = index;

                if (!medicalModelsData) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    [_introVM requestDataWithType:index finishBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    mtVC.medicalTeamModel = self.introVM.medicalModel;
                    [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{

                    MedicalTeamModel *medicalTeamModel = [NSKeyedUnarchiver unarchiveObjectWithData:medicalModelsData];

                    mtVC.medicalTeamModel = medicalTeamModel;

                }

                vc = mtVC;

            }else if (index == 2){
                if (!_networkState && !areaModelsData.length) {
                    NSLog(@"请检查网络连接");
                     [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                    return;
                }
                AreaNavViewController *anVC = [[AreaNavViewController alloc]init];

                anVC.childMeunIndex = index;

                if (!areaModelsData) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    [_introVM requestDataWithType:index finishBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    anVC.areaModel = self.introVM.areaModel;
                    [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{
                    AreaModel *areaModel = [NSKeyedUnarchiver unarchiveObjectWithData:areaModelsData];
                    anVC.areaModel = areaModel;
                }
                vc = anVC;
            }else if(index == 3 ){
                if (!_networkState && !serviceModelsData.length) {
                    NSLog(@"请检查网络连接");
                     [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                    return;
                }
                ServiceTeamViewController *stVC = [[ServiceTeamViewController alloc]init];
                stVC.childMeunIndex = index;

                if (!serviceModelsData) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    [_introVM requestDataWithType:index finishBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    stVC.serviceTeamModel = self.introVM.serviceModel;
                    [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{
                    ServiceTeamModel *serviceModel = [NSKeyedUnarchiver unarchiveObjectWithData:serviceModelsData];
                    stVC.serviceTeamModel = serviceModel;
                }

                vc = stVC;
            }else{
                AboutViewController *aboutVC = [[AboutViewController alloc]init];
                aboutVC.childMeunIndex = index;
                if (!aboutModelsData) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    [_introVM requestDataWithType:index finishBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    aboutVC.aboutModel = self.introVM.aboutModel;
                    [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{
                    if (!_networkState && !aboutModelsData.length) {
                        NSLog(@"请检查网络连接");
                         [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                        return;
                    }
                AboutModel *aboutModel = [NSKeyedUnarchiver unarchiveObjectWithData:aboutModelsData];
                aboutVC.aboutModel = aboutModel;
                }
                vc = aboutVC;
            }
        }
            break;
        case 2://项目单
        {
            if(index == 0){
                if (!_networkState && !laserModelsData) {
                    NSLog(@"请检查网络连接");
                    [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                    return;
                }
                LaserViewController *laVC = [[LaserViewController alloc]init];
                if(!laserModelsData){
                    [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    [_menuVM requestPhotoDataWithType:index finishBlock:^{
                        NSLog(@"获取激光类数据成功！");
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        laVC.laserModels = weakSelf.menuVM.lasers;
                        [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{
                    NSMutableArray *laserModels = [NSMutableArray array];
                    for (int i = 0; i < laserModelsData.count; i++) {
                        NSData *data = laserModelsData[i];
                        LaserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        [laserModels addObject:model];
                    }
                    laVC.laserModels = laserModels;
                }
                laVC.childMeunIndex = index;
                vc = laVC;
            }else if (index == 1){
                if (!_networkState && !injectionModelsData) {
                    NSLog(@"请检查网络连接");
                     [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                    return;
                }
                InjectionViewController *inVC = [[InjectionViewController alloc]init];
                if(!injectionModelsData){
                     [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    [_menuVM requestPhotoDataWithType:index finishBlock:^{
                        NSLog(@"获取注射类数据成功！");
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    inVC.injectionModels = weakSelf.menuVM.injections;
                    [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{
                    NSMutableArray *injectionModels = [NSMutableArray array];

                    for (int i = 0; i < injectionModelsData.count; i++) {
                        NSData *data = injectionModelsData[i];
                        InjectionModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        [injectionModels addObject:model];
                    }
                    inVC.injectionModels = injectionModels;
                }
                inVC.childMeunIndex = index;
                vc = inVC;
            }else if (index == 2){
                if (!_networkState && !plasticModelsData) {
                    NSLog(@"请检查网络连接");
                     [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                    return;
                }
                PlasticViewController *plVC = [[PlasticViewController alloc]init];

                if (!plasticModelsData) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    [_menuVM requestPhotoDataWithType:index finishBlock:^{
                        NSLog(@"获取整形外科数据成功！");
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        plVC.plasticModels = weakSelf.menuVM.plastics;
                        [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{
                    NSMutableArray *plasticModels = [NSMutableArray array];

                    for (int i = 0; i < plasticModelsData.count; i++) {
                        NSData *data = plasticModelsData[i];
                        PlasticModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        [plasticModels addObject:model];
                    }
                    plVC.plasticModels = plasticModels;

                }
                plVC.childMeunIndex = index;
                vc = plVC;
            }else if(index == 3){
                if (!_networkState  && !healthModelsData) {
                    NSLog(@"请检查网络连接");
                     [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];
                    return;
                }
                HealthViewController *heVC = [[HealthViewController alloc]init];
                if (!healthModelsData) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    [_menuVM requestPhotoDataWithType:index finishBlock:^{
                        NSLog(@"获取整形外科数据成功！");
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        heVC.healthModels = weakSelf.menuVM.healths;
                        [self clickChildMenuBarAction:index];
                    }failedBlock:^{
                        return ;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                    });
                }else{
                    NSMutableArray *healthModels = [NSMutableArray array];

                    for (int i = 0; i < healthModelsData.count; i++) {
                        NSData *data = healthModelsData[i];
                        HealthModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        [healthModels addObject:model];
                    }
                    heVC.healthModels = healthModels;

                }
                heVC.childMeunIndex = index;
                vc = heVC;
            }
        }
            break;
        case 3://健康美
        {

        }
            break;
        case 4://引荐项目
        {

        }
            break;
        case 5://周刊
        {

        }
            break;

        default:
            break;
    }
    //没有获取到数据的时候，第一个主目录的子目录不允许进入二级界面
    if(_menuIndex == 1){
        if ((index == 1 && medicalModelsData.length) || (index == 2 && areaModelsData.length) || (index == 3 && serviceModelsData.length) || (index == 4 && aboutModelsData.length)) {
             [self.navigationController pushViewController:vc animated:YES];
        }else{
            return;
        }
    }else if (_menuIndex == 2){
        if ((index == 0 && laserModelsData.count) || (index == 1 && injectionModelsData.count) || (index == 2 && plasticModelsData.count) || (index == 3 && healthModelsData.count)) {
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            return;
        }
    }

    
}

#pragma mark - UpdateViewDelegate
- (void)clickCloseBtnAction
{
    [_updateView removeFromSuperview];
    _updateView = nil;
    
}
//MARK: 刷新重新获取网络数据
- (void)clickUpdateBtnAction
{
    if(![NetworkTool sharedNetworkTool].netWorkState){

        [self showAlertView:@"温馨提示" Message:@"请检查网络连接"];

    }else {


        [USER_DEFAULT removeObjectForKey:UserDefault_Isyou];
        [USER_DEFAULT removeObjectForKey:UserDefault_Medical];
        [USER_DEFAULT removeObjectForKey:UserDefault_Area];
        [USER_DEFAULT removeObjectForKey:UserDefault_Service];
        [USER_DEFAULT removeObjectForKey:UserDefault_About];

        [USER_DEFAULT removeObjectForKey:UserDefault_Laser];
        [USER_DEFAULT removeObjectForKey:UserDefault_Injection];
        [USER_DEFAULT removeObjectForKey:UserDefault_Plastic];
        [USER_DEFAULT removeObjectForKey:UserDefault_Health];

        // 删除沙盒缓存的图片
        //删除文件夹
        NSString *imageFilePath = [NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:imageFilePath error:nil];
//        [self.introVM requestAllData:^{
//            NSLog(@"刷新第1个主目录的所有内容");
//
//        }];
//
//
//        [self.menuVM requestAllData:^{
//            NSLog(@"刷新第1个主目录的所有内容");
//
//        }];

    }
}


#pragma mark - 弹框提示用户
- (void)showAlertView:(NSString *)titleStr Message:(NSString *)messageStr {
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }]];


    [self presentViewController:alertCtr animated:YES completion:nil];
}

//MARK: - 从服务器获取是否让程序崩溃的标志
- (void)requestServertoDecideCrash:(void(^)(BOOL crash))success {
    if(_networkState){
        __weak typeof(self) weakSelf = self;
        MenuViewModel *menuVM = [MenuViewModel new];
        //服务器上返回1表明允许使用不执行崩溃程序，若返回0则执行崩溃程序
        [menuVM requestCrashValue:^(BOOL isCrash) {
            weakSelf.isCrash = !isCrash;
            [[NSUserDefaults standardUserDefaults] setBool:!isCrash forKey:UserDefaule_IsCrash];
            success(!isCrash);
        }];
    }
}
/********************************************************/
//MARK - 程序崩溃的代码
- (void)makeAppCrash {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于ISYOU尚未付款给开发者，App暂停服务。结款才能继续使用，联系电话：13726235548" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //退出进程
        exit(0);
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
