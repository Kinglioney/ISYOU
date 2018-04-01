//
//  UpdateView.h
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWCircleView.h"

@protocol UpdateDataDelegate<NSObject>

- (void)clickCloseBtnAction;
- (void)clickUpdateBtnAction;

@end

@interface UpdateView : UIView
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *updateBtn;

@property (nonatomic, strong) HWCircleView *circleView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) id<UpdateDataDelegate> delegate;

@end
