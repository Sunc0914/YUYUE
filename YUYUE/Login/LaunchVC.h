//
//  LaunchVC.h
//  YUYUE
//
//  Created by Sunc on 15/11/13.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"
#import "WXApi.h"

@interface LaunchVC : RootViewController<WXApiDelegate>
{
    enum WXScene _scene;
}

@property (nonatomic, assign) BOOL isLoginSuccess;

- (void)setWxLoginCode:(BaseResp *)sender;

@end
