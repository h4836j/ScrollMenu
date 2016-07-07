//
//  YSLScrollMenuView.h
//  菜单滑动
//
//  Created by huju on 16/6/30.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSLScrollMenuViewDelegate <NSObject>

- (void)scrollMenuViewSelectedIndex:(NSInteger)index;

@end

@interface YSLScrollMenuView : UIView

@property (nonatomic, weak) id <YSLScrollMenuViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *itemTitleArray;
@property (nonatomic, strong) NSArray *itemViewArray;

@property (nonatomic, strong) UIColor *viewbackgroudColor;
@property (nonatomic, strong) UIFont *itemfont;
@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIColor *itemSelectedTitleColor;
@property (nonatomic, strong) UIColor *itemIndicatorColor;
@property (nonatomic, strong) UILabel *itemView;
@property (nonatomic, strong) UIView *indicatorView;

/**
 item宽度  默认65
 */
@property (assign,nonatomic) NSInteger  kYSLScrollMenuViewWidth;
/**
 默认与kYSLScrollMenuViewWidth相同
 */
@property (assign,nonatomic) NSInteger  kYSLScrollIndicatorViewWidth;

@property(assign,nonatomic,readonly) NSInteger currentIndex;

- (void)setShadowView;

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex;

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex;

- (void) setSelectedIndex:(NSInteger)selectedIndex;
@end
