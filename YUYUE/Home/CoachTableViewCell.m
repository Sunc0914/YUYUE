//
//  CoachTableViewCell.m
//  YUYUE
//
//  Created by Sunc on 15/8/15.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "CoachTableViewCell.h"

@implementation CoachTableViewCell

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
        _coachImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 25, 50, 50)];
        _coachImage.backgroundColor = [UIColor yellowColor];
        _coachImage.layer.masksToBounds = YES;
        _coachImage.layer.cornerRadius = _coachImage.bounds.size.width/2;
        [self addSubview:_coachImage];
        
        CGFloat width = _coachImage.frame.origin.x+_coachImage.frame.size.width+5;
        
        _sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(width, 20, 20, 20)];
        _sexImage.backgroundColor = [UIColor purpleColor];
        _sexImage.layer.masksToBounds = YES;
        _sexImage.layer.cornerRadius = 2;
        [self addSubview:_sexImage];
        
        
        _numberofCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, _sexImage.frame.origin.y+_sexImage.frame.size.height+5, 100, 20)];
//        _numberofCommentLabel.adjustsFontSizeToFitWidth = YES;
        _numberofCommentLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_numberofCommentLabel];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, _numberofCommentLabel.frame.origin.y+_numberofCommentLabel.frame.size.height+5, 150, 20)];
//        _detailLabel.adjustsFontSizeToFitWidth = YES;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_detailLabel];
        
        _coachTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sexImage.frame.origin.x+_sexImage.frame.size.width+5, 20, 120, 20)];
//        _coachTitleLabel.adjustsFontSizeToFitWidth = YES;
        _coachTitleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_coachTitleLabel];
        
        _chargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 80, 20)];
        _chargeLabel.textColor = [UIColor colorWithRed:246/255.0 green:70/255.0 blue:0/255.0 alpha:1.0];
//        _chargeLabel.adjustsFontSizeToFitWidth = YES;
        _chargeLabel.textAlignment = NSTextAlignmentRight;
        _chargeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_chargeLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:139/255.0 green:190/255.0 blue:238/255.0 alpha:1.0];
        [self addSubview:line];
    }
    
    return self;
}

- (void)setCellInfo:(NSDictionary *)sender{
    
    _coachTitleLabel.text = [sender objectForKey:@"title"];
    
    _chargeLabel.text = [sender objectForKey:@"charge"];
    
    _detailLabel.text = [sender objectForKey:@"describe"];
    
    _numberofCommentLabel.text = [sender objectForKey:@"numofcomments"];
}

@end
