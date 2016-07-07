//
//  ScrollMenuView.h
//  菜单滑动
//
//  Created by huju on 16/6/30.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollMenuView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;

/** 标题数组 */
@property (strong, nonatomic) NSArray *menuTitles;
/** 标题View的数组 */
@property (nonatomic, strong) NSArray *itemViews;
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
/** 菜单view的宽度，默认为90 */
@property (assign, nonatomic) double menuViewWidth;
/** 菜单view的间隔，默认为10 */
@property (assign, nonatomic) double menuViewMargin;
/** 底部横线高度，默认为3 */
@property (assign, nonatomic) double indicatorHeight;

//static const CGFloat kYSLScrollMenuViewWidth  = 90;
//static const CGFloat kYSLScrollMenuViewMargin = 10;
//static const CGFloat kYSLIndicatorHeight = 3;

/**
 *  菜单栏选中了第几个视图
 */
- (void)menuViewDidSelectIndex:(NSInteger)index;
/**
 *  菜单栏选中了第几个视图
 *
 *  @param index       选中的索引
 *  @param titleColor  字体颜色
 *  @param selectColor 选中后的字体颜色
 */
- (void)menuViewDidSelectIndex:(NSInteger)index
                    titleColor:(UIColor *)titleColor
              selectTitleColor:(UIColor *)selectColor;

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex;

- (void)setShadowView;
@end
