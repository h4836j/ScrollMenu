//
//  HJViewController.m
//  菜单滑动
//
//  Created by huju on 16/7/8.
//  Copyright © 2016年 liuxiaoxin. All rights reserved.
//

#import "HJViewController.h"
#import "ContainerViewController.h"
#import "PlayListTableViewController.h"
#import "ArtistsViewController.h"
#import "SampleViewController.h"
@interface HJViewController ()

@end

@implementation HJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [UIColor redColor];
    //    return;
    
    //    self.title = @"ddddd";
//    self.navigationItem.title = @"dadfads";
    
    // NavigationBar
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.font = [UIFont fontWithName:@"Futura-Medium" size:19];
    titleView.textColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
    titleView.text = @"Menu";
    [titleView sizeToFit];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;

    // SetUp ViewControllers
    PlayListTableViewController *playListVC = [[PlayListTableViewController alloc]initWithNibName:@"PlayListTableViewController" bundle:nil];
    playListVC.title = @"PlayList";
    
    ArtistsViewController *artistVC = [[ArtistsViewController alloc]initWithNibName:@"ArtistsViewController" bundle:nil];
    artistVC.title = @"Artists";
    
    SampleViewController *sampleVC1 = [[SampleViewController alloc]initWithNibName:@"SampleViewController" bundle:nil];
    sampleVC1.title = @"Album";
    
    SampleViewController *sampleVC2 = [[SampleViewController alloc]initWithNibName:@"SampleViewController" bundle:nil];
    sampleVC2.title = @"Track";
    
    SampleViewController *sampleVC3 = [[SampleViewController alloc]initWithNibName:@"SampleViewController" bundle:nil];
    sampleVC3.title = @"Setting";
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    ContainerViewController *containerVC = [[ContainerViewController alloc]initWithControllers:@[playListVC,artistVC,sampleVC1,sampleVC2,sampleVC3]
                                                                                  topBarHeight:statusHeight + navigationHeight
                                                                          parentViewController:self];
    //    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
    [containerVC test:^(ContainerViewController *vc, NSInteger index, UIViewController *currentVC) {
        [currentVC viewWillAppear:YES];
    }];
    [self.view addSubview:containerVC.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
