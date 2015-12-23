//
//  ActivityHeaderDetailView.m
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityHeaderDetailView.h"

@implementation ActivityHeaderDetailView
{
    NSArray *arr;
    
    NSArray *keyArr;
    
    NSArray *payArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHeaderDetail:(NSDictionary *)sender{
    arr = @[@"活动方式",@"活动地点",@"活动时间",@"活动费用",@"活动对象"];
    keyArr = @[@"motionType",@"motionPlaceText",@"motionTimeText",@"payMode",@"motionTarget"];
    payArr = @[@"其他",@"AA制",@"我来请客",@"免费参与",@"败者支付"];
    
    CGFloat lastHeight = 10;
    
    for (int i = 0; i<5; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.numberOfLines = 0;
        
        //活动方式
        NSString *motionTypeStr = [[NSString alloc]init];
        NSString *motionTypeStateStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"motionType"]];
        
        if ([motionTypeStateStr isEqualToString:@"0"]) {
            motionTypeStr = @"不限";
        }
        else if ([motionTypeStateStr isEqualToString:@"1"])
        {
            motionTypeStr = @"个人活动";
        }
        else
        {
            motionTypeStr = @"团队活动";
        }
        
        //活动对象
        NSString *motionTargetStr = [[NSString alloc]init];
        NSString *motionTatgetStateStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"motionTarget"]];
        
        if ([motionTatgetStateStr isEqualToString:@"0"]) {
            motionTargetStr = @"不限";
        }
        else if ([motionTatgetStateStr isEqualToString:@"1"])
        {
            motionTargetStr = @"男生";
        }
        else if ([motionTatgetStateStr isEqualToString:@"2"])
        {
            motionTargetStr = @"女生";
        }
        else
        {
            motionTargetStr = @"学生";
        }
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],[sender objectForKey:[keyArr objectAtIndex:i]]]];
        
        if (i == 0) {
            //活动类型
            label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 25);
            if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
                label.text = @"";
            }
            string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],motionTypeStr]];
            lastHeight = lastHeight+25;
            
        }
        else if (i == 1) {
            //活动地点
            //活动地点
            NSString *placeStr = [NSString stringWithFormat:@"%@",[sender objectForKey:@"motionPlaceText"]];
            
            CGSize placesize;
            placesize = [[NSString stringWithFormat:@"活动地点：   %@",placeStr] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, 999) lineBreakMode:NSLineBreakByWordWrapping];

            CGFloat placeHeight = placesize.height;
            if (placesize.height<25) {
                placeHeight = 25;
            }
            
            label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, placeHeight);
            lastHeight = lastHeight + placeHeight;
        }
        else if (i == 2)
        {
            //活动时间
            label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 25);
            lastHeight = lastHeight + 25;
        }
        else if (i == 3)
        {
            //活动费用
            string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],[payArr objectAtIndex:[[sender objectForKey:[keyArr objectAtIndex:i]]intValue]]]];
            
            label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 25);
            lastHeight = lastHeight + 25;
        }
        else if (i == 4)
        {
            //活动对象
            string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],motionTargetStr]];
            if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
                label.text = @"";
            }
            label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 25);
            lastHeight = lastHeight + 25;
        }
        else if (i == 5)
        {
            //浏览人数
            string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],[sender objectForKey:@"visitCount"]]];
            if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
                label.text = @"";
            }
            
            label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 25);
            lastHeight = lastHeight + 25;
            //                label.frame = CGRectMake(10, 10+20*i, SCREEN_WIDTH-20, 20);
            //                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 20);
            //                lastHeight = lastHeight + descriptionHeight;
            label.backgroundColor = [UIColor whiteColor];
        }
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] range:NSMakeRange(6,string.length-6)];
        [string addAttribute:NSForegroundColorAttributeName value:tipColor range:NSMakeRange(0,5)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:13] range:NSMakeRange(0,string.length)];
        
        if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
            label.attributedText = nil;
        }
        
        label.attributedText = string;
        
        [self addSubview:label];
    }
    
    //根据cell的高度
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, lastHeight+10, SCREEN_WIDTH, 15)];
    line.backgroundColor = backGroundColor;
    [self addSubview:line];
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, lastHeight+25);
}

@end


