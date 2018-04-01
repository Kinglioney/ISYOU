//
//  UpdateView.m
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UpdateView.h"

@implementation UpdateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self drawUI];
        
    }
    
    return self;
}

- (void)drawUI
{
    
//    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 20;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(500);
        make.width.offset(500).multipliedBy(16/19);
        make.center.equalTo(self);
    }];
    
    //圆圈
    HWCircleView *circleView = [[HWCircleView alloc] initWithFrame:CGRectMake(220, 100, 150, 150)];
    [bgView addSubview:circleView];
    self.circleView = circleView;

    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView).offset(-20);
        make.centerX.equalTo(bgView);
        make.width.height.offset(150);
    }];
    
    _updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    _updateBtn.layer.cornerRadius = 40/2;
    _updateBtn.backgroundColor = MainColor;
    [_updateBtn setTitle:@"清空缓存" forState:UIControlStateNormal];
    [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:_updateBtn];
    [_updateBtn addTarget:self action:@selector(updateBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    
    [_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleView.mas_bottom).offset(60);
        make.centerX.equalTo(bgView);
        make.width.offset(100);
        make.height.offset(40);
    }];
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    [bgView addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(10);
        make.right.equalTo(bgView).offset(-10);
        make.width.height.offset(30);
    }];
}

#pragma mark - 点击事件
- (void)updateBtnClicked// 改为清空缓存
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickUpdateBtnAction)]){
        [_delegate clickUpdateBtnAction];
    }
    [self addTimer];
    
    self.updateBtn.enabled = NO;
    self.updateBtn.backgroundColor = [UIColor lightGrayColor];
    self.closeBtn.enabled = NO;
}

- (void)closeBtnClicked
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickCloseBtnAction)]){
        [_delegate clickCloseBtnAction];
    }}

- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    _circleView.progress += 0.01;

    
    if (_circleView.progress >= 1) {
        [self removeTimer];
        NSLog(@"完成");
        self.closeBtn.enabled = YES;

    }
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}
@end
