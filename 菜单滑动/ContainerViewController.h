//
//  ContainerViewController.h
//  菜单滑动
//
//  Created by huju on 16/6/30.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContainerViewController;

typedef void(^containerBlock)(ContainerViewController *vc, NSInteger index, UIViewController *currentVC);

@interface ContainerViewController : UIViewController



/** 子控制器数组 */
@property (strong, nonatomic) NSArray *childViewControllers;
/** 标题数组 */
@property (strong, nonatomic) NSArray *menuTitles;
/** 标题字体大小 */
@property (nonatomic, strong) UIFont  *menuItemFont;
/** 标题字体颜色 */
@property (nonatomic, strong) UIColor *menuItemTitleColor;
/** 选中字体颜色 */
@property (nonatomic, strong) UIColor *menuItemSelectedTitleColor;
/** 标题框背景颜色 */
@property (nonatomic, strong) UIColor *menuBackGroudColor;
/** 选择时标题底部横线颜色 */
@property (nonatomic, strong) UIColor *menuIndicatorColor;
/** 控制器顶部高度（导航栏和状态栏之和）（64/0） */
@property (assign, nonatomic) double topBarHeight;

- (void)test:(containerBlock)contain;

/**
 *  初始化方法创建控制器
 *
 *  @param controllers          子控制器数组
 *  @param topBarHeight         顶部高度（64/0）
 *  @param parentViewController 父控制器
 *
 */
- (instancetype)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController;

@end
