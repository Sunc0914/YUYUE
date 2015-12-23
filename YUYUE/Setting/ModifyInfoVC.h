//
//  ModifyInfoVC.h
//  YUYUE
//
//  Created by Sunc on 15/11/3.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"

@protocol refreshAfterInfoChanged <NSObject>

- (void)getData;

@end

@interface ModifyInfoVC : RootViewController

@property (nonatomic, retain) NSString *placeHolderStr;

@property (nonatomic, retain) NSString *changeType;//0是文字输入，1是table选择

@property (nonatomic, retain) NSString *titleStr;

@property (nonatomic, retain) NSString *changeKey;

@property (nonatomic, retain) id<refreshAfterInfoChanged> delegate;

@end
