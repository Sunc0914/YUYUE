//
//  CollectionCell.m
//  YUYUE
//
//  Created by Sunc on 15/11/28.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

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
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _imgView.clipsToBounds = YES;
    _imgView.layer.cornerRadius = _imgView.bounds.size.height/2.0f;
    _imgView.layer.shouldRasterize = YES;
    _imgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self addSubview:_imgView];
}

@end
