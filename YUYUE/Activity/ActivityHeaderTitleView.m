//
//  ActivityHeaderTitleView.m
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityHeaderTitleView.h"
#import "UIImageView+WebCache.h"
#include "UserInfoVC.h"

@implementation ActivityHeaderTitleView
{
    NSDictionary *motionDic;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTitleDetail:(NSDictionary *)sender{
    
    motionDic = [NSDictionary dictionaryWithDictionary:sender];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    image.layer.cornerRadius = image.frame.size.height/2;
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/%@",[sender objectForKey:@"sportItemIcon"]]] placeholderImage:nil
     ];
    image.backgroundColor = [UIColor whiteColor];
    [self addSubview:image];
    
    //活动名称
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1.0];
    NSString *nameStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"name"]];
    if ([nameStr isEqualToString:@"(null)"]) {
        nameStr = @"";
    }
    CGSize placesize;
    placesize = [nameStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH-45-100, 999) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat placeHeight = placesize.height;
    if (placesize.height<30) {
        placeHeight = 30;
    }

    titleLabel.text = nameStr;
    titleLabel.frame = CGRectMake(image.frame.origin.x+image.frame.size.width+10, 5, SCREEN_WIDTH-45-100, placeHeight);
    [self addSubview:titleLabel];
    
    //谁发布于什么时候
    _whoAndWhen = [[UIButton alloc]initWithFrame:CGRectMake(image.frame.origin.x+image.frame.size.width+10, placeHeight+10, SCREEN_WIDTH-45-100, 25)];
    _whoAndWhen.titleLabel.font = [UIFont systemFontOfSize:13];
    _whoAndWhen.titleLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
    _whoAndWhen.titleLabel.numberOfLines = 2;
    
    NSString *whoStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"createUserName"]];
    NSString *createTimeStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"createTimeText"]];
    if ([whoStr isEqualToString:@"(null)"]) {
        whoStr = @"";
    }
    
    if ([createTimeStr isEqualToString:@"(null)"]) {
        createTimeStr = @"";
    }
    
    NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  发布于%@",whoStr,createTimeStr]];
    [timeStr addAttribute:NSForegroundColorAttributeName value:userNameColor range:NSMakeRange(0,whoStr.length)];
    [_whoAndWhen setAttributedTitle:timeStr forState:UIControlStateNormal];
    _whoAndWhen.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_whoAndWhen addTarget:self action:@selector(createTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_whoAndWhen];
    
    //已预约人数
    UILabel *subNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x+image.frame.size.width+10, _whoAndWhen.frame.origin.y+_whoAndWhen.frame.size.height, SCREEN_WIDTH-45-80-80, 25)];
    subNumLabel.font = [UIFont systemFontOfSize:12];
    subNumLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    subNumLabel.numberOfLines = 2;
    NSString *subStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"subscribeCount"]];
    if ([subStr isEqualToString:@"(null)"]) {
        subStr = @"0";
    }
    subNumLabel.text = [NSString stringWithFormat:@"已有  %@  人预约",subStr];
    subNumLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:subNumLabel];
    
    //限制最大人数
    
    UILabel *maxSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, _whoAndWhen.frame.origin.y+_whoAndWhen.frame.size.height, 80, 25)];
    maxSubLabel.textColor = tipColor;
    maxSubLabel.text = [NSString stringWithFormat:@"限 %@ 人", [sender objectForKey:@"maxSubscribers"]];
    if (![sender objectForKey:@"maxSubscribers"]) {
        maxSubLabel.text = @"";
    }
    else if ([[sender objectForKey:@"maxSubscribers"] intValue] == 0){
        maxSubLabel.text = @"人数不限";
    }
    else{
        maxSubLabel.text = @"";
    }
    
    maxSubLabel.textAlignment = NSTextAlignmentRight;
    maxSubLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:maxSubLabel];
    
    NSString *motionState;
    NSMutableAttributedString *string;
    if ([[NSString stringWithFormat:@"%@",[sender objectForKey:@"finish"]] isEqualToString:@"1"]) {
        //活动已结束
        motionState = @"活动已结束";
        string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",motionState]];
        _motionState = 0;
    }
    else{
        //活动没结束，判断是否接受预约
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd HH:mm"];
        NSString *timeStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"subscribeEndTime"]];
        NSDate *dateTime = [formatter dateFromString:timeStr];
        
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *nowDate = [date  dateByAddingTimeInterval: interval];
        if ([dateTime earlierDate:nowDate] == nowDate) {
            //还没到活动时间
            NSString *subNumber = [NSString stringWithFormat:@"%@",[sender objectForKey:@"subscribeCount"]];
            NSString *maxNumber = [NSString stringWithFormat:@"%@",[sender objectForKey:@"maxSubscribers"]];
            if ([maxNumber isEqualToString:@"(null)"]) {
                //接受预约中 最大人数不填
                motionState = @"接受预约中";
                string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",motionState,[sender objectForKey:@"leftTime"]]];
                _motionState = 3;
            }
            else if ([maxNumber isEqualToString:@"0"]){
                //接受预约中 最大人数为0
                motionState = @"接受预约中";
                string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",motionState,[sender objectForKey:@"leftTime"]]];
                _motionState = 3;
            }
            else if ([subNumber intValue]<[maxNumber intValue]) {
                //接受预约
                motionState = @"接受预约中";
                string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",motionState,[sender objectForKey:@"leftTime"]]];
                _motionState = 3;
            }
            else
            {
                motionState = @"预约已截止";
                string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(人数已满)",motionState]];
                _motionState = 1;
            }
        }
    }
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, subNumLabel.frame.origin.y+subNumLabel.frame.size.height, SCREEN_WIDTH-45-100, 25)];
    if (string.length>5) {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5,string.length-5)];
    }
    stateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    stateLabel.attributedText = string;
    stateLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:stateLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, stateLabel.frame.origin.y+stateLabel.frame.size.height+15);
    
    //根据cell的高度
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-15, SCREEN_WIDTH, 15)];
    line.backgroundColor = backGroundColor;
    [self addSubview:line];
}

- (void)createTitleClicked:(UIButton *)sender{
    //跳转到发起者个人信息界面
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = [motionDic objectForKey:@"createUserId"];
    if ([_delegate respondsToSelector:@selector(pushViewController:)]) {
        [_delegate pushViewController:userInfoVc];
    }
}

- (int)getStateCode{
    return _motionState;
}

@end
