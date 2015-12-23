//
//  MainTabBarViewController.m
//  iCity_CQ
//
//  Created by William Chen on 12-12-26.
//  Copyright (c) 2012年 whty. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "UserInfo.h"
#import "LoginVC.h"
#import "MBProgressHUD.h"
#import "HomeVC.h"
#import "ActivityVC.h"
#import "FindVC.h"
#import "MyVC.h"

@interface MainTabBarViewController () {
    NSMutableArray *tabButtons;
    NSMutableArray *tabTitles;
    NSMutableArray *tabBarConfigs;
}

@end

@implementation MainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initViewController];
    }
    return self;
}

- (void)initViewController{
    
    NSArray *arr = @[@"首页",@"活动",@"我的"];
    NSArray *controllerTitleArr = @[@"喻体",@"活动",@"我的"];
    NSArray *controllerNameArr = @[@"HomeVC",@"ActivityVC",@"MyVC"];
    NSArray *imageSelArr = @[@"icon_first_sel",@"icon_second_sel",@"icon_forth_sel"];
    NSArray *imageArr = @[@"icon_first",@"icon_second",@"icon_forth"];
    
    for (int i = 0; i<arr.count; i++) {
        Class currentElement_Class = NSClassFromString([NSString stringWithFormat:@"%@",[controllerNameArr objectAtIndex:i]]);
        UIViewController *currentController = [[currentElement_Class alloc]init];
        currentController.tabBarItem.title = [arr objectAtIndex:i];
        currentController.tabBarItem.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
        [currentController.tabBarItem setSelectedImage:[UIImage imageNamed:[imageSelArr objectAtIndex:i]]];
        [currentController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        currentController.title = [controllerTitleArr objectAtIndex:i];
        UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController: currentController];
        [self addChildViewController:navControl];
    }
    
}

@end
