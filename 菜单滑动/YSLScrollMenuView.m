//
//  YSLScrollMenuView.m
//  菜单滑动
//
//  Created by huju on 16/6/30.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import "YSLScrollMenuView.h"

static const CGFloat kYSLScrollMenuViewMargin = 10;
static const CGFloat kYSLIndicatorHeight = 3;

@interface YSLScrollMenuView ()<UIScrollViewDelegate>


@property(assign,nonatomic) NSInteger nextIndex;

@end

@implementation YSLScrollMenuView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default
        _viewbackgroudColor = [UIColor whiteColor];
        _itemfont = [UIFont systemFontOfSize:16];
        _itemTitleColor = [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1.0];
        _itemSelectedTitleColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
        _itemIndicatorColor = [UIColor colorWithRed:0.168627 green:0.498039 blue:0.839216 alpha:1.0];
        
        self.backgroundColor = _viewbackgroudColor;
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        self.kYSLScrollMenuViewWidth = 65;
    }
    return self;
}

#pragma mark -- Setter

- (void)setViewbackgroudColor:(UIColor *)viewbackgroudColor
{
    if (!viewbackgroudColor) { return; }
    _viewbackgroudColor = viewbackgroudColor;
    self.backgroundColor = viewbackgroudColor;
}

- (void)setItemfont:(UIFont *)itemfont
{
    if (!itemfont) { return; }
    _itemfont = itemfont;
    for (UILabel *label in _itemTitleArray) {
        label.font = itemfont;
    }
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor
{
    if (!itemTitleColor) { return; }
    _itemTitleColor = itemTitleColor;
    for (UILabel *label in _itemViewArray) {
        label.textColor = itemTitleColor;
    }
}

- (void)setItemIndicatorColor:(UIColor *)itemIndicatorColor
{
    if (!itemIndicatorColor) { return; }
    _itemIndicatorColor = itemIndicatorColor;
    _indicatorView.backgroundColor = itemIndicatorColor;
}

- (void)setItemTitleArray:(NSArray *)itemTitleArray
{
    if (_itemTitleArray != itemTitleArray) {
        _itemTitleArray = itemTitleArray;
        NSMutableArray *views = [NSMutableArray array];
        
        for (int i = 0; i < itemTitleArray.count; i++) {
            CGRect frame = CGRectMake(0, 0, _kYSLScrollMenuViewWidth, CGRectGetHeight(self.frame));
            _itemView = [[UILabel alloc] initWithFrame:frame];
            [self.scrollView addSubview:_itemView];
            _itemView.tag = i;
            _itemView.text = itemTitleArray[i];
            _itemView.userInteractionEnabled = YES;
            _itemView.backgroundColor = [UIColor clearColor];
            _itemView.textAlignment = NSTextAlignmentCenter;
            _itemView.font = [UIFont systemFontOfSize:13.0f];
            _itemView.textColor = _itemTitleColor;
            [views addObject:_itemView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewTapAction:)];
            [_itemView addGestureRecognizer:tapGesture];
            
        }
        
        self.itemViewArray = [NSArray arrayWithArray:views];
        _scrollView.contentSize =CGSizeMake(itemTitleArray.count*(_kYSLScrollMenuViewWidth+kYSLScrollMenuViewMargin)+kYSLScrollMenuViewMargin, self.frame.size.height);
        // indicator
        _indicatorView = [[UIView alloc]init];
       
        UIView *firstView = [self.itemViewArray objectAtIndex:0];
        self.kYSLScrollIndicatorViewWidth = self.kYSLScrollMenuViewWidth;
        CGFloat x = firstView.center.x - self.kYSLScrollIndicatorViewWidth*0.5;
        _indicatorView.frame = CGRectMake(x, _scrollView.frame.size.height - kYSLIndicatorHeight, self.self.kYSLScrollIndicatorViewWidth, kYSLIndicatorHeight);
        [_scrollView addSubview:_indicatorView];
    }
}

- (void)setKYSLScrollMenuViewWidth:(NSInteger)kYSLScrollMenuViewWidth
{
    _kYSLScrollMenuViewWidth = kYSLScrollMenuViewWidth;
    if(!self.kYSLScrollIndicatorViewWidth)
        self.kYSLScrollIndicatorViewWidth = kYSLScrollMenuViewWidth;
}


#pragma mark -- public

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex
{
    CGFloat indicatorX = 0.0;
    if (isNextItem) {
        indicatorX = ((kYSLScrollMenuViewMargin + _kYSLScrollMenuViewWidth) * ratio ) + (toIndex * _kYSLScrollMenuViewWidth) + ((toIndex + 1) * kYSLScrollMenuViewMargin);
    } else {
        indicatorX =  ((kYSLScrollMenuViewMargin + _kYSLScrollMenuViewWidth) * (1 - ratio) ) + (toIndex * _kYSLScrollMenuViewWidth) + ((toIndex + 1) * kYSLScrollMenuViewMargin);
    }
    
    if (indicatorX < kYSLScrollMenuViewMargin || indicatorX > self.scrollView.contentSize.width - (kYSLScrollMenuViewMargin + _kYSLScrollMenuViewWidth)) {
        return;
    }
    _indicatorView.frame = CGRectMake(indicatorX, _scrollView.frame.size.height - kYSLIndicatorHeight, self.kYSLScrollIndicatorViewWidth, kYSLIndicatorHeight);
    //  NSLog(@"retio : %f",_indicatorView.frame.origin.x);
}

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex
{
    if (itemTextColor) { _itemTitleColor = itemTextColor; }
    if (selectedItemTextColor) { _itemSelectedTitleColor = selectedItemTextColor; }
    
    for (int i = 0; i < self.itemViewArray.count; i++) {
        UILabel *label = self.itemViewArray[i];
        if (i == currentIndex) {
            label.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 label.alpha = 1.0;
                                 label.textColor = _itemSelectedTitleColor;
                             } completion:^(BOOL finished) {
                             }];
        } else {
            label.textColor = _itemTitleColor;
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
    self.scrollView.frame = self.bounds;
    CGFloat x = kYSLScrollMenuViewMargin;
    for (NSUInteger i = 0; i < self.itemViewArray.count; i++) {
        CGFloat width = _kYSLScrollMenuViewWidth;
        UIView *itemView = self.itemViewArray[i];
        itemView.frame = CGRectMake(x, 0, width, self.scrollView.frame.size.height);
        x += width + kYSLScrollMenuViewMargin;
    }
    UIView* currentV = self.itemViewArray[self.currentIndex];
    self.indicatorView.center = CGPointMake(currentV.center.x,self.indicatorView.center.y);
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    
//    CGRect frame = self.scrollView.frame;
//    if (self.frame.size.width > x) {
//        frame.origin.x = (self.frame.size.width - x) / 2;
//        frame.size.width = x;
//    } else {
//        frame.origin.x = 0;
//        frame.size.width = self.frame.size.width;
//    }
     //frame;
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(self.currentIndex==self.nextIndex) return;
//    
//    CGFloat oldPointX = self.currentIndex * scrollView.frame.size.width;
//    CGFloat ratio = (_scrollView.contentOffset.x - oldPointX) / _scrollView.frame.size.width;
//    
//    BOOL isToNextItem = (_scrollView.contentOffset.x > oldPointX);
//    NSInteger targetIndex = (isToNextItem) ? self.currentIndex + 1 : self.currentIndex - 1;
//    
//    CGFloat nextItemOffsetX = 1.0f;
//    CGFloat currentItemOffsetX = 1.0f;
//    
//    nextItemOffsetX = (_scrollView.contentSize.width - _scrollView.frame.size.width) * targetIndex / (self.itemViewArray.count - 1);
//    currentItemOffsetX = (_scrollView.contentSize.width - _scrollView.frame.size.width) * self.currentIndex / (self.itemViewArray.count - 1);
//    
//    if (targetIndex >= 0 && targetIndex < self.itemViewArray.count) {
//        // MenuView Move
//        CGFloat indicatorUpdateRatio = ratio;
//        if (isToNextItem) {
//            
//            CGPoint offset = _scrollView.contentOffset;
//            offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX;
//            [self.scrollView setContentOffset:offset animated:NO];
//            
//            indicatorUpdateRatio = indicatorUpdateRatio * 1;
//            [self setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:self.currentIndex];
//        } else {
//            
//            CGPoint offset = self.scrollView.contentOffset;
//            offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio;
//            [self.scrollView setContentOffset:offset animated:NO];
//            
//            indicatorUpdateRatio = indicatorUpdateRatio * -1;
//            [self setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:targetIndex];
//        }
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = self.nextIndex;
}


#pragma mark -- Selector --------------------------------------- //
- (void)itemViewTapAction:(UITapGestureRecognizer *)Recongnizer
{
    UIView *view = [(UIGestureRecognizer*) Recongnizer view];
    NSInteger index = view.tag;
    [self setSelectedIndex:index];
    
}

- (void) setSelectedIndex:(NSInteger)selectedIndex
{
    
    
    NSInteger index = selectedIndex;
    self.nextIndex  = index;

    CGFloat offset = _scrollView.frame.size.width/self.itemViewArray.count-kYSLScrollMenuViewMargin;
    CGFloat maxOffsetX = MIN((index*(_kYSLScrollMenuViewWidth+kYSLScrollMenuViewMargin)+kYSLScrollMenuViewMargin),(_scrollView.contentSize.width - _scrollView.frame.size.width));

    CGFloat nextOffset = _scrollView.contentOffset.x+(index-self.currentIndex)*offset;
    nextOffset = MIN(maxOffsetX,nextOffset);
    nextOffset = MAX(nextOffset,0);
    [_scrollView setContentOffset:CGPointMake(nextOffset, 0.) animated:YES];
    //[_scrollView setContentOffset:CGPointMake(maxOffsetX, 0.f) animated:YES];
    UIView *view = self.itemViewArray[index];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _indicatorView.center = CGPointMake(view.center.x, _indicatorView.center.y);
//        _indicatorView.frame = CGRectMake(view.frame.origin.x, _scrollView.frame.size.height - kYSLIndicatorHeight, self.kYSLScrollIndicatorViewWidth, kYSLIndicatorHeight);
    } completion:^(BOOL finished) {
        if(finished)
        {   _currentIndex = self.nextIndex;
            [self layoutSubviews];
        }
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenuViewSelectedIndex:)]) {
        [self.delegate scrollMenuViewSelectedIndex:index];
    }
    
}

- (void)scrollIndicatorViewToCurrentIndex
{
    
}

@end
