//
//  ActivityCollectionViewCell.m
//  YUYUE
//
//  Created by Sunc on 15/12/1.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "ActivityCollectionViewCell.h"

@implementation ActivityCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addImgView];
    }
    return self;
}

- (void)addImgView{
    
    CGFloat width = 45;
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4.0-width)/2.0, 5, 45, 45)];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.frame = CGRectMake((SCREEN_WIDTH/4.0-width)/2.0, _imgView.frame.size.height+_imgView.frame.origin.y+5, width, 20.0);
    
    [self addSubview:_imgView];
    
    [self addSubview:_titleLabel];
}

@end
