//
//  Macro.h
//  ISYOU
//  宏定义类：整个应用会用到的宏定义
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//获取沙盒的Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒的Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//RGB格式
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//弱引用
#define WEAKSELF  __weak __typeof(self) weakSelf = self


//屏幕高度
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//屏幕宽度
#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

//NavigationBar高度 （44）
#define kNavigationBar_HEIGHT 44

//tabBar高度 （49）
#define kTabBar_HEIGHT 49

#define  kSubviewWidth  100 //目录中按钮的宽度
#define  kSubviewHeight 109 //目录中按钮的高度
#define  kMargin 10

#define MainColor [UIColor colorWithRed:243/255.0 green:159/255.0 blue:9/255.0 alpha:1.0]


#endif /* Macro_h */
