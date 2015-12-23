//
//  StoryCollectionViewCell.h
//  YUYUE
//
//  Created by Sunc on 15/10/26.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *img;
    
@property (nonatomic, retain) UILabel *titleLabel;
    
@property (nonatomic, retain) UIImageView *userImg;
    
@property (nonatomic, retain) UILabel *userNameLabel;

- (void)setCellCollectionViewCellDetail:(NSDictionary *)dic;


@end
