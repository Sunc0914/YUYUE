//
//  ActivityCell.h
//  YUYUE
//
//  Created by Sunc on 15/8/12.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol jumpToSubs <NSObject>

- (void)jumpToCheckSubs:(NSString *)motionID;

@end

@interface ActivityCell : UITableViewCell

@property(nonatomic, retain)UIImageView *activityImage;

@property(nonatomic, retain)UILabel *typeLabel;

@property(nonatomic, retain)UILabel *titleLabel;

@property(nonatomic, retain)UILabel *placeLabel;

@property(nonatomic, retain)UILabel *timeLabel;

@property(nonatomic, retain)UIButton *numOfJoinBtn;

@property(nonatomic, retain)UIView *line;

@property(nonatomic, assign)CGFloat placeViewX;

@property(nonatomic, assign)CGFloat activityImageX;

@property(nonatomic, retain)UIImageView *placeView;

@property(nonatomic, retain)UIImageView *timeView;

@property(nonatomic, assign)CGFloat placeViewY;

@property(nonatomic, assign)CGFloat typeLabelY;

@property(nonatomic, assign)BOOL isMyActivity;
@property(nonatomic, assign)BOOL belongsToMe;
@property(nonatomic, retain)id<jumpToSubs>delegate;

- (void)setCellDetail:(NSDictionary *)sender;

@end
