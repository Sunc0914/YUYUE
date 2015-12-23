//
//  subUserCell.h
//  YUYUE
//
//  Created by Sunc on 15/12/14.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface subUserCell : UITableViewCell

- (void)getCellContent;

@property (nonatomic, retain)NSString *userID;
@property (nonatomic, retain)UIButton *userImgBtn;
@property (nonatomic, retain)UIViewController *currentVC;

@end
