//
//  ActivityHeaderTitleView.h
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol titlePush <NSObject>

- (void)pushViewController:(UIViewController *)controller;

@end

@interface ActivityHeaderTitleView : UIView

@property (nonatomic, retain) UIButton *whoAndWhen;

@property (nonatomic, assign) BOOL *canSub;

@property (nonatomic, assign) int motionState; //0 活动结束； 1 预约已满； 2 预约时间已过 3 接收预约中

@property (nonatomic, assign) id<titlePush>delegate;

- (void)setTitleDetail:(NSDictionary *)sender;

- (int)getStateCode;

@end
