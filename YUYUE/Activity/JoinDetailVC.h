//
//  JoinDetailVC.h
//  YUYUE
//
//  Created by Sunc on 15/10/8.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"

@protocol subScribeSuccess <NSObject>

- (void)refreshSubScribeView;

@end

@interface JoinDetailVC : RootViewController

@property(nonatomic, retain)NSString *activityID;

@property(nonatomic, assign)id<subScribeSuccess>delegate;

@end
