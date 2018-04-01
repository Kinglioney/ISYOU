//
//  MenuBarView.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MenuBarView.h"


@implementation MenuBarView

+ (instancetype)loadMenuBarView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MenuBarView" owner:nil options:nil] lastObject];
}


- (IBAction)pressedEvent:(UIButton *)sender {
    
    _introImg.image = [UIImage imageNamed:@"icon_introduction_unselect"];
    _itemsImg.image = [UIImage imageNamed:@"icon_menu_unselect"];
    _healthImg.image = [UIImage imageNamed:@"icon_health_unselect"];
    _recommendImg.image = [UIImage imageNamed:@"icon_recommend_unselect"];
    _magazineImg.image = [UIImage imageNamed:@"icon_publication_unselect"];
    
    _introLb.textColor = [UIColor whiteColor];
    _itemsLb.textColor = [UIColor whiteColor];
    _healthLb.textColor = [UIColor whiteColor];
    _recommendLb.textColor = [UIColor whiteColor];
    _magazineLb.textColor = [UIColor whiteColor];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        switch (sender.tag) {
            case 1:
                _introImg.image = [UIImage imageNamed:@"icon_introduction_select"];
                _introLb.textColor = MainColor;
                _introView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                break;
            case 2:
                _itemsImg.image = [UIImage imageNamed:@"icon_menu_select"];
                _itemsLb.textColor = MainColor;
                _itemsView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                break;
            case 3:
                _healthImg.image = [UIImage imageNamed:@"icon_health_select"];
                _healthLb.textColor = MainColor;
                _healthView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                break;
            case 4:
                _recommendImg.image = [UIImage imageNamed:@"icon_recommend_select"];
                _recommendLb.textColor = MainColor;
                _recommendView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                break;
            case 5:
                _magazineImg.image = [UIImage imageNamed:@"icon_publication_select"];
                _magazineLb.textColor = MainColor;
                _magazineView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                break;
            default:
                break;
        }
        
        
    } completion:nil];




}

- (IBAction)unpressedEvent:(UIButton *)sender {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        switch (sender.tag) {
            case 1:
                _introView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;
            case 2:
                _itemsView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;
            case 3:
                _healthView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;
            case 4:
                _recommendView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;
            case 5:
                _magazineView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;
            default:
                break;
        }
    } completion:nil];

    if (_deleagte && [_deleagte respondsToSelector:@selector(showChildMenuBarView:)]) {
        [_deleagte showChildMenuBarView:sender.tag];
    }
}



@end
