//
//  ChildMenuBarView.h
//  ISYOU
//
//  Created by 叶振龙 on 2017/8/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChildMenuBarDelegate<NSObject>

- (void)clickChildMenuBarAction:(NSInteger)index;

@end
@interface ChildMenuBarView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;//记录点击的哪一个主目录

@property (nonatomic, assign) id<ChildMenuBarDelegate> delegate;

@end
