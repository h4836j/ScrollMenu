//
//  ScrollMenuView.m
//  菜单滑动
//
//  Created by huju on 16/6/30.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import "ScrollMenuView.h"

#define KSCreenWidth  [UIScreen mainScreen].bounds.size.width
#define KSCreenHeight [UIScreen mainScreen].bounds.size.height

@interface ScrollMenuView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation ScrollMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate = self;
//    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.menuItemFont = [UIFont systemFontOfSize:16];
    self.menuItemTitleColor = [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1.0];
    self.menuItemSelectedTitleColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
    self.menuIndicatorColor = [UIColor colorWithRed:0.168627 green:0.498039 blue:0.839216 alpha:1.0];
    self.menuViewWidth = 90;
    self.menuViewMargin = 10;
    self.indicatorHeight = 3;
    self.backgroundColor = [UIColor whiteColor];
}


#pragma mark - setter

- (void)setMenuTitles:(NSArray *)menuTitles
{
    _menuTitles = menuTitles;
    NSMutableArray *itemViews = [NSMutableArray array];
    for (int i = 0; i< menuTitles.count; i++) {
        UILabel *itemView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.menuViewWidth, CGRectGetHeight(self.frame))];
//        UILabel *itemView = [[UILabel alloc] initWithFrame:frame];
        [self.scrollView addSubview:itemView];
        itemView.tag = i;
        itemView.text = self.menuTitles[i];
        itemView.userInteractionEnabled = YES;
        itemView.backgroundColor = [UIColor clearColor];
        itemView.textAlignment = NSTextAlignmentCenter;
        itemView.font = self.menuItemFont;
        itemView.textColor = self.menuItemTitleColor;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewTapAction:)];
        [itemView addGestureRecognizer:tapGesture];
        
        [itemViews addObject:itemView];
    }
    self.itemViews = itemViews;
    
    _indicatorView = [[UIView alloc]init];
    _indicatorView.frame = CGRectMake(10, _scrollView.frame.size.height - self.indicatorHeight, self.menuViewWidth, self.indicatorHeight);
    _indicatorView.backgroundColor = self.menuIndicatorColor;
    [_scrollView addSubview:_indicatorView];
}





- (void)setMenuItemFont:(UIFont *)menuItemFont
{
    if (!menuItemFont) { return; }
    _menuItemFont = menuItemFont;
    for (UILabel *label in self.itemViews) {
        label.font = menuItemFont;
    }
}

- (void)setMenuItemTitleColor:(UIColor *)menuItemTitleColor
{
    if (!menuItemTitleColor) { return; }
    _menuItemTitleColor = menuItemTitleColor;
    for (UILabel *label in self.itemViews) {
        label.textColor = menuItemTitleColor;
    }
}

- (void)setMenuIndicatorColor:(UIColor *)menuIndicatorColor
{
    if (!menuIndicatorColor) { return; }
    _menuIndicatorColor = menuIndicatorColor;
    _indicatorView.backgroundColor = menuIndicatorColor;
}


//- (void)setItemTitleArray:(NSArray *)itemTitleArray
//{
//    if (_itemTitleArray != itemTitleArray) {
//        _itemTitleArray = itemTitleArray;
//        NSMutableArray *views = [NSMutableArray array];
//        
//        for (int i = 0; i < itemTitleArray.count; i++) {
//            CGRect frame = CGRectMake(0, 0, self.menuViewWidth, CGRectGetHeight(self.frame));
//            UILabel *itemView = [[UILabel alloc] initWithFrame:frame];
//            [self.scrollView addSubview:itemView];
//            itemView.tag = i;
//            itemView.text = itemTitleArray[i];
//            itemView.userInteractionEnabled = YES;
//            itemView.backgroundColor = [UIColor clearColor];
//            itemView.textAlignment = NSTextAlignmentCenter;
//            itemView.font = self.itemfont;
//            itemView.textColor = _itemTitleColor;
//            [views addObject:itemView];
//            
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewTapAction:)];
//            [itemView addGestureRecognizer:tapGesture];
//        }
//        
//        self.itemViewArray = [NSArray arrayWithArray:views];
//        
//        // indicator
//        _indicatorView = [[UIView alloc]init];
//        _indicatorView.frame = CGRectMake(10, _scrollView.frame.size.height - kYSLIndicatorHeight, self.menuViewWidth, kYSLIndicatorHeight);
//        _indicatorView.backgroundColor = self.itemIndicatorColor;
//        [_scrollView addSubview:_indicatorView];
//    }
//}

#pragma mark -- public

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex
{
    CGFloat indicatorX = 0.0;
    if (isNextItem) {
        indicatorX = ((self.menuViewMargin + self.menuViewWidth) * ratio ) + (toIndex * self.menuViewWidth) + ((toIndex + 1) * self.menuViewMargin);
    } else {
        indicatorX =  ((self.menuViewMargin + self.menuViewWidth) * (1 - ratio) ) + (toIndex * self.menuViewWidth) + ((toIndex + 1) * self.menuViewMargin);
    }
    
    if (indicatorX < self.menuViewMargin || indicatorX > self.scrollView.contentSize.width - (self.menuViewMargin + self.menuViewMargin)) {
        return;
    }
    _indicatorView.frame = CGRectMake(indicatorX, _scrollView.frame.size.height - self.indicatorHeight, self.menuViewWidth, self.indicatorHeight);
    //  NSLog(@"retio : %f",_indicatorView.frame.origin.x);
}

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex
{
    if (itemTextColor) { self.menuItemTitleColor = itemTextColor; }
    if (selectedItemTextColor) { self.menuItemSelectedTitleColor = selectedItemTextColor; }
    
    for (int i = 0; i < self.itemViews.count; i++) {
        UILabel *label = self.itemViews[i];
        if (i == currentIndex) {
            label.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 label.alpha = 1.0;
                                 label.textColor = self.menuItemSelectedTitleColor;
                             } completion:^(BOOL finished) {
                             }];
        } else {
            label.textColor = self.menuItemTitleColor;
        }
    }
}

- (void)menuViewDidSelectIndex:(NSInteger)index
                    titleColor:(UIColor *)titleColor
              selectTitleColor:(UIColor *)selectColor
{
    if (titleColor) { self.menuItemTitleColor = titleColor; }
    if (selectColor) { self.menuItemSelectedTitleColor = selectColor; }
    
    for (int i = 0; i < self.itemViews.count; i++) {
        UILabel *label = self.itemViews[i];
        if (i == index) {
            label.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 label.alpha = 1.0;
                                 label.textColor = self.menuItemSelectedTitleColor;
                             } completion:^(BOOL finished) {
                             }];
        } else {
            label.textColor = self.menuItemTitleColor;
        }
    }
}

#pragma mark -- private

// menu shadow
- (void)setShadowView
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, self.frame.size.height - 0.5, CGRectGetWidth(self.frame), 0.5);
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.menuViewMargin;
    for (NSUInteger i = 0; i < self.itemViews.count; i++) {
        CGFloat width = self.menuViewWidth;
        UILabel *itemView = self.itemViews[i];
        itemView.frame = CGRectMake(x, 0, width, self.scrollView.frame.size.height);
        x += width + self.menuViewMargin;
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    
    CGRect frame = self.scrollView.frame;
    if (self.frame.size.width > x) {
        frame.origin.x = (self.frame.size.width - x) / 2;
        frame.size.width = x;
    } else {
        frame.origin.x = 0;
        frame.size.width = self.frame.size.width;
    }
    self.scrollView.frame = frame;
}

#pragma mark -- Selector --------------------------------------- //
- (void)itemViewTapAction:(UITapGestureRecognizer *)Recongnizer
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenuViewSelectedIndex:)]) {
//        [self.delegate scrollMenuViewSelectedIndex:[(UIGestureRecognizer*) Recongnizer view].tag];
//    }
}
@end
