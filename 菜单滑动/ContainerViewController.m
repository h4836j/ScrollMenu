//
//  ContainerViewController.m
//  菜单滑动
//
//  Created by huju on 16/6/30.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import "ContainerViewController.h"
#import "ScrollMenuView.h"

//#define WeakSelf __weak typeof(self) weakSelf = self;

#define KSCreenWidth  [UIScreen mainScreen].bounds.size.width
#define KSCreenHeight [UIScreen mainScreen].bounds.size.height
@interface ContainerViewController ()<UIScrollViewDelegate>
/** 顶部菜单View的高度 */
@property (assign, nonatomic) double menuHeight;
/** 滑动视图 */
@property (strong, nonatomic) UIScrollView *scrollView;
/** 当前位置索引 */
@property (assign, nonatomic) NSInteger currentIndex;
/** 菜单视图 */
@property (strong, nonatomic) ScrollMenuView *menuView;

@property (copy, nonatomic) containerBlock block;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuHeight = 40;
    
    [self setUpScrollView];
    [self setUpMenuView];
    
    
}

- (instancetype)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController
{
    if (self = [super init]) {
        self.childViewControllers = controllers;
        self.topBarHeight = topBarHeight;
        
        [parentViewController addChildViewController:self];
        [self didMoveToParentViewController:parentViewController];
        
        _topBarHeight = topBarHeight;
        self.childViewControllers = controllers;
        
        NSMutableArray *titles = [NSMutableArray array];
        for (UIViewController *vc in self.childViewControllers) {
            [titles addObject:[vc valueForKey:@"title"]];
        }
        self.menuTitles = [titles copy];
        
    }
    return self;
}

- (void)setUpScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    CGFloat scrollX = 0;
    CGFloat scrollY = self.menuHeight;
    CGFloat scrollW = KSCreenWidth;
    CGFloat scrollH = KSCreenHeight - scrollY;
    scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    self.scrollView = scrollView;
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.childViewControllers.count, 0);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        id obj = [self.childViewControllers objectAtIndex:i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController*)obj;
            CGFloat scrollWidth = self.scrollView.frame.size.width;
            CGFloat scrollHeght = self.scrollView.frame.size.height;
            controller.view.frame = CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeght);
            [self.scrollView addSubview:controller.view];
        }
    }
    
    
}


- (void)setUpMenuView
{
    ScrollMenuView *menuView = [[ScrollMenuView alloc] init];
    menuView.frame = CGRectMake(0, self.topBarHeight, KSCreenWidth, self.menuHeight);
    [self.view addSubview:menuView];
    self.menuView = menuView;
    
    
    menuView.menuTitles = self.menuTitles;
    menuView.menuItemFont = self.menuItemFont;
    menuView.menuItemTitleColor = self.menuItemTitleColor;
    menuView.menuBackGroudColor = self.menuBackGroudColor;
    menuView.menuIndicatorColor = self.menuIndicatorColor;
    menuView.menuItemSelectedTitleColor = self.menuItemSelectedTitleColor;
    
    __weak typeof(self) weakSelf = self;
    [menuView menuViewDidSelectIndex:^(NSInteger index) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // 设置contentOffset有点问题
        [strongSelf.scrollView setContentOffset:CGPointMake(index * strongSelf.scrollView.frame.size.width, -strongSelf.topBarHeight) animated:YES];
        
        [strongSelf.menuView menuViewDidSelectIndex:index titleColor:strongSelf.menuItemTitleColor selectTitleColor:strongSelf.menuItemSelectedTitleColor];
        
        if (index == strongSelf.currentIndex) { return; }
        
        [strongSelf setChildViewControllerWithCurrentIndex:index];
        
        strongSelf.currentIndex = index;
        
        if (strongSelf.block) {
            strongSelf.block(strongSelf, index, strongSelf.childViewControllers[strongSelf.currentIndex]);
        }
    }];
    
    [self.menuView menuViewDidSelectIndex:0 titleColor:self.menuItemTitleColor selectTitleColor:self.menuItemSelectedTitleColor];
}

#pragma mark - UIScrollViewDelegate
// 滑动结束时，切换控制器和菜单索引
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    if (index == self.currentIndex) return;
    
    self.currentIndex = index;
    
    UIViewController *currentVC = [self.childViewControllers objectAtIndex:index];
    
    if (self.block) {
        self.block(self, index, currentVC);
    }
    
    [self.menuView menuViewDidSelectIndex:self.currentIndex titleColor:self.menuItemTitleColor selectTitleColor:self.menuItemSelectedTitleColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 之前的位置
    CGFloat oldPointX = self.currentIndex * scrollView.frame.size.width;
    // 计算出位置比例
    CGFloat ratio = (scrollView.contentOffset.x - oldPointX) / scrollView.frame.size.width;
    // 右滑还是左滑
    BOOL isToNextItem = (self.scrollView.contentOffset.x > oldPointX);
    NSInteger targetIndex = (isToNextItem) ? self.currentIndex + 1 : self.currentIndex - 1;
    
    CGFloat nextItemOffsetX = 1.0f;
    CGFloat currentItemOffsetX = 1.0f;
    // 滑动之后菜单View的OffsetX
    nextItemOffsetX = (self.menuView.scrollView.contentSize.width - self.menuView.scrollView.frame.size.width) * targetIndex / (self.menuView.itemViews.count - 1);
    // 当前菜单View的OffsetX
    currentItemOffsetX = (self.menuView.scrollView.contentSize.width - self.menuView.scrollView.frame.size.width) * self.currentIndex / (self.menuView.itemViews.count - 1);
    
    if (targetIndex >= 0 && targetIndex < self.childViewControllers.count) {
        // MenuView Move
        CGFloat indicatorUpdateRatio = ratio;
        if (isToNextItem) {
            
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX;
            [_menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * 1;
            [self.menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:self.currentIndex];
        } else {
            
            CGPoint offset = _menuView.scrollView.contentOffset;
            offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio;
            [_menuView.scrollView setContentOffset:offset animated:NO];
            
            indicatorUpdateRatio = indicatorUpdateRatio * -1;
            [self.menuView setIndicatorViewFrameWithRatio:indicatorUpdateRatio isNextItem:isToNextItem toIndex:targetIndex];
        }
    }
}


// 根据位置切换控制器
- (void)setChildViewControllerWithCurrentIndex:(NSInteger)index
{
    for (int i = 0; i < self.childViewControllers.count; i++) {
        id obj = self.childViewControllers[i];
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController*)obj;
            if (i == index) { // 添加新的控制器到scrollView
                // 当一个视图控制器从视图控制器容器中被添加或者被删除之前，该方法被调用
                [controller willMoveToParentViewController:self];
                [self addChildViewController:controller];
                // 当从一个视图控制容器中添加或者移除viewController后，该方法被调用。
                [controller didMoveToParentViewController:self];
            } else { // 移除之前的控制器
                [controller willMoveToParentViewController:self];
                [controller removeFromParentViewController];
                [controller didMoveToParentViewController:self];
            }
        }
    }
}



- (void)test:(containerBlock)contain
{
    self.block = contain;
}
















@end
