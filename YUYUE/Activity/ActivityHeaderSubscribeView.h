//
//  ActivityHeaderSubscribeView.h
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol subPush <NSObject>

- (void)pushViewController:(UIViewController *)controller;

@end

@interface ActivityHeaderSubscribeView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

- (void)setSubDetail:(NSDictionary *)dic;

@property (nonatomic, assign) id<subPush>delegate;

@end
