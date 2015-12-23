//
//  GymCell.h
//  YUYUE
//
//  Created by Sunc on 15/8/20.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentBtnDelegate <NSObject>

- (void)subcommentbtnclicked:(NSInteger)sender;

@end

@interface GymCell : UITableViewCell

@property (nonatomic, retain)UILabel *titleLabel;

@property (nonatomic, retain)UIImageView *image;

@property (nonatomic, retain)UILabel *addressLabel;

@property (nonatomic, retain)UILabel *commentLabel;

@property (nonatomic, retain)UILabel *projLabel;

@property (nonatomic, retain)UILabel *districtLabel;

@property (nonatomic, assign)id <CommentBtnDelegate> delegate;

- (void)setCellDetail:(NSDictionary *)sender index:(NSInteger)index;

@end
