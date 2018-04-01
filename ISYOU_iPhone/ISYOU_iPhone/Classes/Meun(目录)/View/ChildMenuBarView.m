//
//  ChildMenuBarView.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChildMenuBarView.h"
#import "YLButton.h"
@interface ChildMenuBarView()
/** 目录标题 */
@property (nonatomic, strong) NSArray *titles;

/** 目录标题 */
@property (nonatomic, strong) NSArray *images;

@end


@implementation ChildMenuBarView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }

    return self;
}

#pragma mark - 懒加载
- (NSArray *)titles {
    if (!_titles) {
        _titles = [NSArray array];
        
    }
    return _titles;
}
- (NSArray *)images {
    if (!_images) {
        _images = [NSArray array];
    }
    return _images;
}

#pragma mark - 根据主目录选择子目录
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    self.titles = nil;
    self.images = nil;
    
    switch (_selectedIndex) {
        case 1:// 企业简介
        {
            self.titles = @[@"ISYOU", @"医疗团队", @"区域导航", @"服务团队", @"关于我们"];
            self.images = @[@"icon_isyou", @"icon_medical_team", @"icon_area_nav" , @"icon_service_team", @"icon_about"];
        }
            break;
        case 2:// 项目单
        {
            self.titles = @[@"激光类", @"注射类", @"整形外科", @"大健康类"];
            self.images = @[@"icon_laser", @"icon_injection", @"icon_plastic_surgery" , @"icon_big_health"];
        }
            break;
        case 3:// 健康美
        {
            
        }
            break;
        case 4:// 引荐项目
        {

        }
            break;
        case 5:// ISYOU周刊
        {

        }
            break;

        default:
            break;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    NSInteger count = self.titles.count;
    for (int i = 0; i < count; i++) {
        CGFloat buttonW = 30;
        CGFloat buttonH = 56;
        CGFloat margin  = 10;
        YLButton *button = [[YLButton alloc] initWithFrame:CGRectMake(0, (margin + buttonH)*i, buttonW, buttonH)];
        button.tag = i;
        //if(button.tag == 0) button.selected = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        [button setImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        //设置图片和标题的位置 上-左-下-右
        button.imageRect = CGRectMake(0, 0, buttonW, buttonW);
        button.titleRect = CGRectMake(-10, buttonW, buttonW+20, 20);

        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

}
- (void)clickAction:(YLButton *)button{

    if(_delegate && [_delegate respondsToSelector:@selector(clickChildMenuBarAction:)]){
        [_delegate clickChildMenuBarAction:button.tag];
    }
}
@end
