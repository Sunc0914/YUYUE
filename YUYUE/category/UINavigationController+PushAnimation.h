//
//  UINavigationController+PushAnimation.h
//  YUYUE
//
//  Created by Sunc on 15/11/3.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PushAnimation)

- (void)pushAnimationDidStop;

- (void)pushViewControllerAnimatedWithTransition: (UIViewController*)controller;

- (UIViewController*)popViewControllerAnimatedWithTransition;

@end
