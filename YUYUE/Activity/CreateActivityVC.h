//
//  CreateActivityVC.h
//  YUYUE
//
//  Created by Sunc on 15/8/12.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"

@protocol refreshActivity <NSObject>

- (void)refreshData;

@end

@interface CreateActivityVC : RootViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic, retain)UITableView *createActivityTable;

@property(nonatomic, retain)UIButton *leftBtn;

@property(nonatomic, retain)UIButton *rightBtn;

@property(nonatomic, retain)NSArray *titleArray;

@property(nonatomic, retain)UIButton *singleBtn;

@property(nonatomic, retain)UIButton *organizasionBtn;

@property(nonatomic, retain)UIView *indicator;

@property(nonatomic, retain)NSMutableArray *activityDetail;

@property(nonatomic, retain)UITextView *inputTextView;

@property(nonatomic, retain)UIButton *completeBtn;

@property(nonatomic, assign)CGFloat keyboardheight;

@property(nonatomic, retain)NSMutableArray *sportsArr;//活动类别

@property(nonatomic, retain)NSMutableArray *districtArr;//活动区域

@property(nonatomic, retain)NSMutableArray *placeArr;//活动地点

@property(nonatomic, retain)NSMutableArray *payWayArr;//付款方式

@property(nonatomic, retain)NSMutableArray *targetArr;//活动对象

@property (nonatomic, assign) BOOL isModelViewController;

@property (nonatomic, assign) id<refreshActivity>delegate;

@end
