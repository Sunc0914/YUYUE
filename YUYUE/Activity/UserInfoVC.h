//
//  UserInfoVC.h
//  YUYUE
//
//  Created by Sunc on 15/9/30.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"
#import "NJKWebViewProgress.h"

@interface UserInfoVC : RootViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property(nonatomic, retain) NSString *userID;

@end
