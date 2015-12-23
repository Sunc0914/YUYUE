//
//  UINavigationController+PushAnimation.m
//  YUYUE
//
//  Created by Sunc on 15/11/3.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "UINavigationController+PushAnimation.h"

@implementation UINavigationController (PushAnimation)

- (void)pushAnimationDidStop {
}

- (void)pushViewControllerAnimatedWithTransition: (UIViewController*)controller{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    self.navigationBarHidden = NO;

    [self pushViewController:controller animated:NO];
    [self.view.layer addAnimation:transition forKey:nil];

}

- (UIViewController*)popViewControllerAnimatedWithTransition {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    self.navigationBarHidden = NO;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    
    return poppedController;
}

@end
