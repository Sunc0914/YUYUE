//
//  ActivityDetailVC.h
//  YUYUE
//
//  Created by Sunc on 15/8/25.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"

@interface ActivityDetailVC : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain)NSString *activityID;

@property(nonatomic, retain)NSString *activityType;

@end
