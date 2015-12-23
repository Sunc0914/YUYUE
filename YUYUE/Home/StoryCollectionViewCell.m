//
//  StoryCollectionViewCell.m
//  YUYUE
//
//  Created by Sunc on 15/10/26.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "StoryCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation StoryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        CGFloat imgwidth = (SCREEN_WIDTH-15)/2.0;
        CGFloat imgheight = imgwidth*5/7.0;
        CGFloat titleheight = imgwidth*9/35.0;
        CGFloat nameheight =  imgwidth*7/35.0;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , imgwidth, imgheight+titleheight+nameheight+10)];
        view.backgroundColor = [UIColor whiteColor];
        
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgwidth, imgheight)];
        _img.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, imgheight+4, imgwidth-2, titleheight)];
        _titleLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
        _titleLabel.numberOfLines = 2;
        
        _titleLabel.font = [UIFont systemFontOfSize:13];
        
        _userImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, imgheight+titleheight+2+4, nameheight-4, nameheight-4)];
        _userImg.backgroundColor = [UIColor clearColor];
        _userImg.layer.cornerRadius = _userImg.bounds.size.height/2.0;
        _userImg.layer.masksToBounds = YES;
        _userImg.layer.shouldRasterize = YES;
        _userImg.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+nameheight, imgheight+titleheight+4, imgwidth-nameheight-10-2, nameheight)];
        _userNameLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _userNameLabel.font = [UIFont systemFontOfSize:12];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        
        
        [view addSubview:_img];
        [view addSubview:_titleLabel];
        [view addSubview:_userImg];
        [view addSubview:_userNameLabel];
        
        [self addSubview:view];
    }
    return self;
}

- (void)setCellCollectionViewCellDetail:(NSDictionary *)dic{
    
    NSString *imgStr = [NSString stringWithFormat:@"http://m.yuti.cc%@",[dic objectForKey:@"coverImage"]];
    NSURL *url = [NSURL URLWithString:imgStr];
    [_img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"storyDefault.png"]];
    
    _titleLabel.text = [dic objectForKey:@"title"];
    
    imgStr = [NSString stringWithFormat:@"http://m.yuti.cc%@",[dic objectForKey:@"createUserPhoto"]];
    url = [NSURL URLWithString:imgStr];
    [_userImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"userDefulat.png"]];
    
    _userNameLabel.text = [dic objectForKey:@"createUserName"];
    
}

@end
