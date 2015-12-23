//
//  AppDelegate.h
//  YUYUE
//
//  Created by Sunc on 15/8/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarViewController.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end
