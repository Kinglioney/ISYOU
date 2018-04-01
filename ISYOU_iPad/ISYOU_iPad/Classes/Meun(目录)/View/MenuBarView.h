//
//  MenuBarView.h
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuBarViewDelegate<NSObject>

- (void)showChildMenuBarView:(NSInteger)index;

@end

@interface MenuBarView : UIView
/* 企业简介**/
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UIButton *introBtn;
@property (weak, nonatomic) IBOutlet UIImageView *introImg;
@property (weak, nonatomic) IBOutlet UILabel *introLb;

/* 项目单**/
@property (weak, nonatomic) IBOutlet UIView *itemsView;
@property (weak, nonatomic) IBOutlet UIButton *itemsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *itemsImg;
@property (weak, nonatomic) IBOutlet UILabel *itemsLb;

/* 健康美**/
@property (weak, nonatomic) IBOutlet UIView *healthView;
@property (weak, nonatomic) IBOutlet UIButton *healthBtn;
@property (weak, nonatomic) IBOutlet UIImageView *healthImg;
@property (weak, nonatomic) IBOutlet UILabel *healthLb;

/* 引荐项目**/
@property (weak, nonatomic) IBOutlet UIView *recommendView;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *recommendImg;
@property (weak, nonatomic) IBOutlet UILabel *recommendLb;

/* ISYOU月刊**/
@property (weak, nonatomic) IBOutlet UIView *magazineView;
@property (weak, nonatomic) IBOutlet UIButton *magazineBtn;
@property (weak, nonatomic) IBOutlet UIImageView *magazineImg;
@property (weak, nonatomic) IBOutlet UILabel *magazineLb;

//声明协议
@property (nonatomic, weak) id<MenuBarViewDelegate> deleagte;



+ (instancetype)loadMenuBarView;

@end
