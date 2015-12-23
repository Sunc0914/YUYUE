//
//  ActivityCell.m
//  YUYUE
//
//  Created by Sunc on 15/8/12.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation ActivityCell
{
    NSDictionary *temDic;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _activityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        [self addSubview:_activityImage];
        
        //第一行
        _activityImageX = _activityImage.frame.origin.x+_activityImage.frame.size.width+10;
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_activityImageX, 17, 30, 18)];
        _typeLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        _typeLabel.adjustsFontSizeToFitWidth = YES;
        _typeLabel.layer.cornerRadius = 5;
        _typeLabel.font = [UIFont systemFontOfSize:13];
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.layer.shouldRasterize = YES;
        _typeLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_typeLabel];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_activityImageX, 15 , SCREEN_WIDTH-_activityImageX-10, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        if (_isMyActivity) {
            _titleLabel.textColor = [UIColor blueColor];
        }
        [self addSubview:_titleLabel];
        
        //第二行
        
        _typeLabelY = _typeLabel.frame.origin.y+_typeLabel.frame.size.height+10;
        _placeView = [[UIImageView alloc]initWithFrame:CGRectMake(_activityImageX, _typeLabelY+2.5, 15, 15)];
        _placeView.image = [UIImage imageNamed:@"motionAddress.png"];
        [self addSubview:_placeView];
        
        _placeViewX = _placeView.frame.origin.x + _placeView.frame.size.width+5;
        
        _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_placeViewX, _typeLabelY, SCREEN_WIDTH-_placeViewX-10, 20)];
        _placeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
        _placeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_placeLabel];
        
        //第三行
        
        _placeViewY = _placeView.frame.origin.y + _placeView.frame.size.height+8;
        
        _timeView = [[UIImageView alloc]initWithFrame:CGRectMake(_activityImageX, _placeViewY+2.5, 15, 15)];
        _timeView.image = [UIImage imageNamed:@"motionTime.png"];
        [self addSubview:_timeView];
        
        CGFloat timeViewX = _timeView.frame.origin.x + _timeView.frame.size.width + 5;
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeViewX, _placeViewY, 130, 20)];
        _timeLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        
        _numOfJoinBtn = [[UIButton alloc]initWithFrame:CGRectMake(_timeLabel.frame.origin.x+_timeLabel.frame.size.width+5, _timeLabel.frame.origin.y, 80, 20)];
        [_numOfJoinBtn setTitleColor:[UIColor colorWithRed:246/255.0 green:70/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
        _numOfJoinBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _numOfJoinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_numOfJoinBtn addTarget:self action:@selector(checkSubs) forControlEvents:UIControlEventTouchUpInside];
        _numOfJoinBtn.userInteractionEnabled = NO;
        [self addSubview:_numOfJoinBtn];
        
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        _placeLabel.numberOfLines = 0;
        _placeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
    }
    NSLog(@"%f",self.frame.size.height);
    return self;
}

- (void)checkSubs{
    if ([_delegate respondsToSelector:@selector(jumpToCheckSubs:)]) {
        [_delegate jumpToCheckSubs:[NSString stringWithFormat:@"%@",[temDic objectForKey:@"id"]]];
    }
}

- (void)setCellDetail:(NSDictionary *)sender{
    temDic = [NSDictionary dictionaryWithDictionary:sender];
    NSString *iconStr = [NSString stringWithFormat:@"http://m.yuti.cc%@",[sender objectForKey:@"sportItemIcon"]];
    
    [_activityImage sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    
    if ([[NSString stringWithFormat:@"%@",[sender objectForKey:@"motionType"]] intValue] == 1) {
        _typeLabel.text = @"个人";
    }
    else{
        _typeLabel.text = @"团队";
    }
    
    NSString *time = [NSString stringWithFormat:@"%@",[sender objectForKey:@"motionTimeText"]];
    if (time.length>25) {
       time = [time substringToIndex:25];
    }
    
    _timeLabel.text = time;
    
    _titleLabel.text = [NSString stringWithFormat:@"         %@",[sender objectForKey:@"name"]];
    
    _placeLabel.text = [NSString stringWithFormat:@"%@",[sender objectForKey:@"motionPlaceText"]];
    
    [_numOfJoinBtn setTitle:[NSString stringWithFormat:@"%@人应约",[sender objectForKey:@"subscribeCount"]]forState:UIControlStateNormal];
    if (_isMyActivity) {
        [_numOfJoinBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:167/255.0 blue:234/255.0 alpha:1.0] forState:UIControlStateNormal];
        if (_belongsToMe) {
            [_numOfJoinBtn setTitle:@"查看预约的人" forState:UIControlStateNormal];
            _numOfJoinBtn.userInteractionEnabled = YES;
        }
        else
        {
            [_numOfJoinBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        }
    }
    
    
    //名称label
    CGSize size2 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-_activityImageX-10, 999) fontsize:14 text:_titleLabel.text];
    
    CGFloat height = 17;
    
    if (size2.height<=15) {
        size2.height = 15;
        height = 15;
    }
    
    _titleLabel.frame = CGRectMake(_activityImage.frame.origin.x+_activityImage.frame.size.width+10, height , SCREEN_WIDTH-_activityImageX-10, size2.height);
    
    //第二行、地点label
    _placeView.frame = CGRectMake(_activityImage.frame.origin.x+_activityImage.frame.size.width+10, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+6+2.5, 15, 15);
    
    
    CGSize size1 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-95-10, 999) fontsize:12 text:_placeLabel.text];
    
    if (size1.height<=15) {
        size1.height = 15;
    }
    
    _placeLabel.frame = CGRectMake(_placeViewX, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+8, SCREEN_WIDTH-95-10, size1.height);
    
    //第三行
    
    _timeView.frame = CGRectMake(_activityImage.frame.origin.x+_activityImage.frame.size.width+10, _placeLabel.frame.origin.y + _placeLabel.frame.size.height+5+2.5, 15, 15);
    
    _timeLabel.frame = CGRectMake(_timeView.frame.origin.x + _timeView.frame.size.width + 5, _placeLabel.frame.origin.y + _placeLabel.frame.size.height+5, 150, 20);
    
    _numOfJoinBtn.frame = CGRectMake(SCREEN_WIDTH-10-80, _timeLabel.frame.origin.y, 80, 20);
    
}

//自适应文字
-(CGSize)maxlabeisize:(CGSize)labelsize fontsize:(NSInteger)fontsize text:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:labelsize lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

@end
