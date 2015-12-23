//
//  ActivityDetailCell.h
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"

@protocol cellPush <NSObject>

- (void)pushViewController:(UIViewController *)controller;

- (void)writeCommentToSomeone:(NSDictionary *)dic;

@end

@interface ActivityDetailCell : UITableViewCell

@property (nonatomic, retain) id<cellPush>delegate;

@property (nonatomic, retain) YYTextSimpleEmoticonParser *parser;

@property (nonatomic, assign) NSInteger cellIndex;

- (void)setCellContent:(NSDictionary *)dic withRemarkCount:(NSString *)count withHeight:(CGFloat)cellHeight;

@end
