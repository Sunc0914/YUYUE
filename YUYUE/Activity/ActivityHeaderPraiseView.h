//
//  ActivityHeaderPraiseView.h
//  YUYUE
//
//  Created by Sunc on 15/11/19.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol praPush <NSObject>

- (void)pushViewController:(UIViewController *)controller;

@end

@interface ActivityHeaderPraiseView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

- (void)setSubDetail:(NSDictionary *)dic;

@property (nonatomic, assign) id<praPush>delegate;

@end
