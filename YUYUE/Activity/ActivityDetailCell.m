//
//  ActivityDetailCell.m
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityDetailCell.h"
#import "UserInfoVC.h"
#import "UIButton+WebCache.h"
#import "MLEmojiLabel.h"

@implementation ActivityDetailCell
{
    CGFloat lastHeight;
    
    NSDictionary *commentDic;
    
    MLEmojiLabel *contentLabel;
    
    YYLabel *newContentLabel;
    
    UILabel *titleLabel;
    UIButton *imageBtn;
    UIButton *userBtn;
    UILabel *timeLabel;
    UIButton *commentBtn;
    
    UIView *lineView;
    
    NSString *toUseID;
    
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
        [self initOwnerView];
    }
    return self;
}

- (void)commentUserClicked:(UIButton *)sender{
    //跳转到发起者个人信息界面
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = [commentDic objectForKey:@"createUserId"];
    if ([_delegate respondsToSelector:@selector(pushViewController:)]) {
        [_delegate pushViewController:userInfoVc];
    }
}

- (void)initOwnerView{
    
    imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    imageBtn.layer.cornerRadius = imageBtn.bounds.size.height/2.0;
    imageBtn.layer.masksToBounds = YES;
    imageBtn.layer.shouldRasterize = YES;
    imageBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [imageBtn addTarget:self action:@selector(commentUserClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:imageBtn];
    
    userBtn = [[UIButton alloc]initWithFrame:CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+10, 10, 200, 25)];
    [userBtn setTitleColor:userNameColor forState:UIControlStateNormal];
    userBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    userBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [userBtn addTarget:self action:@selector(commentUserClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:userBtn];
    
    newContentLabel = [[YYLabel alloc]initWithFrame:CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+10, imageBtn.frame.origin.y+imageBtn.frame.size.height+10, SCREEN_WIDTH-20-10-imageBtn.frame.size.width, 40)];
    newContentLabel.numberOfLines = 0;
    newContentLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
    newContentLabel.font = [UIFont systemFontOfSize:14.0f];
    newContentLabel.backgroundColor = [UIColor clearColor];
    newContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    newContentLabel.textParser = _parser;
    newContentLabel.displaysAsynchronously = YES;
    [self.contentView addSubview:newContentLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+10, contentLabel.frame.origin.y+contentLabel.frame.size.height+10, SCREEN_WIDTH-20-10-imageBtn.frame.size.width, 25)];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:timeLabel];
    
    commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50-10, timeLabel.frame.origin.y-5, 30, 30)];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"replyNor"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentToSomeone) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentBtn];
    
    lastHeight = commentBtn.frame.origin.y+commentBtn.frame.size.height+10;
    
}

- (void)commentToSomeone{
    
    NSDictionary *dic = @{@"index":[NSNumber numberWithInteger:_cellIndex],
                          @"targetID":[NSString stringWithFormat:@"%@",[commentDic objectForKey:@"id"]],
                          @"toID":@"(null)",
                          @"toName":[commentDic objectForKey:@"createUserName"]};
    
    if([_delegate respondsToSelector:@selector(writeCommentToSomeone:)])
    {
        [_delegate writeCommentToSomeone:dic];
    }
}

- (void)commentToSomeoneWithID:(UIButton *)sender{
    
    NSArray *replyArr = [NSArray arrayWithArray:[commentDic objectForKey:@"replyList"]];
    NSDictionary *temDic = [NSDictionary dictionaryWithDictionary:[replyArr objectAtIndex:sender.tag]];
    toUseID = [NSString stringWithFormat:@"%@",[temDic objectForKey:@"createUserId"]];
    NSString *toUserName = [NSString stringWithFormat:@"%@",[temDic objectForKey:@"createUserName"]];
    
    NSDictionary *dic = @{@"index":[NSNumber numberWithInteger:_cellIndex],
                          @"targetID":[NSString stringWithFormat:@"%@",[commentDic objectForKey:@"id"]],
                          @"toID":toUseID,
                          @"toName":toUserName};
    
    if([_delegate respondsToSelector:@selector(writeCommentToSomeone:)])
    {
        [_delegate writeCommentToSomeone:dic];
    }
}

- (void)setCellContent:(NSDictionary *)dic withRemarkCount:(NSString *)count  withHeight:(CGFloat)cellHeight{
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [self initOwnerView];
    
    titleLabel.text = [NSString stringWithFormat:@"精彩评论（%@）",count];
    
    commentDic = [[NSDictionary alloc]initWithDictionary:dic];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",[commentDic objectForKey:@"createUserId"]]];
    [imageBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:nil];
    
    [userBtn setTitle:[NSString stringWithFormat:@"%@",[commentDic objectForKey:@"createUserName"]] forState:UIControlStateNormal];
    
    NSString *content = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"content"]];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20-10-imageBtn.frame.size.width, 999) lineBreakMode:NSLineBreakByWordWrapping];
    
    if(size.height<16.0f)
    {
        size.height = 25;
    }
    else {
        size.height = size.height+10;
    }
    
    newContentLabel.text = content;
    newContentLabel.frame = CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+10, userBtn.frame.origin.y+userBtn.frame.size.height+5, SCREEN_WIDTH-20-10-imageBtn.frame.size.width, size.height);
    [newContentLabel sizeToFit];
    
    timeLabel.text = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"createTimeText"]];
    timeLabel.frame = CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+10, newContentLabel.frame.origin.y+newContentLabel.frame.size.height+5, SCREEN_WIDTH-20-10-imageBtn.frame.size.width, 25);
    
    commentBtn.frame = CGRectMake(SCREEN_WIDTH-30-10, timeLabel.frame.origin.y-5, 30, 30);
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(10, cellHeight-1, SCREEN_WIDTH-10, 1)];
    lineView.backgroundColor = backGroundColor;
    [self.contentView addSubview:lineView];
    
    NSArray *replyArr = [NSArray arrayWithArray:[dic objectForKey:@"replyList"]];
    if (replyArr.count>0) {
        [self addSecondComment:replyArr];
    }
    
}

- (void)addSecondComment:(NSArray *)replyListArr{
    //第二级评论
    if (replyListArr.count>0) {
        CGSize size;
        CGFloat height = timeLabel.frame.origin.y+timeLabel.frame.size.height;
        for (int j = 0; j<replyListArr.count; j++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[replyListArr objectAtIndex:j]];
            NSMutableAttributedString *str;
            
            NSString *toStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"toUserName"]];
            NSString *string;
            NSString *name;
            if (toStr.length == 0) {
                string = [NSString stringWithFormat:@"%@: %@",[dic objectForKey:@"createUserName"],[dic objectForKey:@"content"]];
                str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ : %@",[dic objectForKey:@"createUserName"],[dic objectForKey:@"content"]]];
                name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createUserName"]];
                
                [str addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:14.0],NSFontAttributeName,
                                   [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0],NSForegroundColorAttributeName,
                                    nil] range:NSMakeRange(0,str.length)];
                [str addAttribute:NSForegroundColorAttributeName value:userNameColor range:NSMakeRange(0,name.length)];
            }
            else
            {
                string = [NSString stringWithFormat:@"%@ 回复 %@：%@",[dic objectForKey:@"createUserName"],toStr,[dic objectForKey:@"content"]];
                str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 回复 %@：%@",[dic objectForKey:@"createUserName"],toStr,[dic objectForKey:@"content"]]];
                
                name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createUserName"]];
                
                [str addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14.0],NSFontAttributeName,
                                    [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0],NSForegroundColorAttributeName,
                                    nil] range:NSMakeRange(0,str.length)];
                [str addAttribute:NSForegroundColorAttributeName value:userNameColor range:NSMakeRange(0,name.length)];
                [str addAttribute:NSForegroundColorAttributeName value:userNameColor range:NSMakeRange(name.length+4, toStr.length)];
            }
            
            size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20-10-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
            
            if(size.height<16.0f)
            {
                size.height = 25;
            }
            else {
                size.height = size.height+10;
            }
            
            YYLabel *label = [[YYLabel alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x, height, SCREEN_WIDTH-20-10-40, size.height)];
            label.numberOfLines = 0;
            label.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.backgroundColor = [UIColor clearColor];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.displaysAsynchronously = YES;

            label.textParser = _parser;
            label.attributedText = str;
            [label sizeToFit];
            
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = label.frame;
            btn.tag = j;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(commentToSomeoneWithID:) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:label];
            [self.contentView addSubview:btn];
            
            height = height + size.height;
        }
        
        height = height+10;
        
        lineView.frame = CGRectMake(10, height-1, SCREEN_WIDTH-10, 1);
    }
}

@end
