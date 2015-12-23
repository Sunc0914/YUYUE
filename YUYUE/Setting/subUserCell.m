//
//  subUserCell.m
//  YUYUE
//
//  Created by Sunc on 15/12/14.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "subUserCell.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"
#import "UserInfoVC.h"

@implementation subUserCell
{
    UILabel *userNameLabel;
    UILabel *signLabel;
    UIImageView *sexImageView;
    
    NSDictionary *userInfoDic;
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
        [self initCell];
    }
    return self;
}

- (void)initCell{
    WS(ws);
    _userImgBtn = [UIButton new];
    _userImgBtn.userInteractionEnabled = NO;
    [self addSubview:_userImgBtn];
    [_userImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(_userImgBtn.mas_height);
        make.left.equalTo(ws).offset(15);
    }];
    
    signLabel = [UILabel new];
    signLabel.textColor = tipColor;
    signLabel.font = [UIFont systemFontOfSize:11];
    signLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:signLabel];
    
    userNameLabel = [UILabel new];
    userNameLabel.textColor = [UIColor colorWithRed:62/255.0 green:167/255.0 blue:234/255.0 alpha:1.0];
    userNameLabel.font = [UIFont systemFontOfSize:13];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:userNameLabel];
    
    sexImageView = [UIImageView new];
    [self addSubview:sexImageView];
    
    [sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userImgBtn.mas_right).offset(10);
        make.top.equalTo(_userImgBtn);
        make.bottom.mas_equalTo(signLabel.mas_top);
        make.width.mas_equalTo(sexImageView.mas_height);
    }];
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sexImageView.mas_right).offset(10);
        make.top.equalTo(_userImgBtn);
        make.bottom.mas_equalTo(signLabel.mas_top);
        make.right.equalTo(ws).offset(-70);
    }];
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userImgBtn.mas_right).offset(10);
        make.top.mas_equalTo(userNameLabel.mas_bottom);
        make.bottom.equalTo(ws).offset(-5);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    NSLog(@"%f------%f",sexImageView.frame.size.width,sexImageView.frame.size.height);
    NSLog(@"%f------%f",sexImageView.bounds.size.width,sexImageView.bounds.size.height);
    _userImgBtn.clipsToBounds = YES;
    _userImgBtn.layer.cornerRadius = _userImgBtn.bounds.size.height/2.0;
    _userImgBtn.layer.shouldRasterize = YES;
    _userImgBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)userImgBtnClicked:(UIButton *)sender{
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = _userID;
    [_currentVC.navigationController pushViewController:userInfoVc animated:YES];
}

- (void)getCellContent{
    
    [AppWebService getUserInfo:_userID success:^(id result) {
        userInfoDic  = [result objectForKey:@"user"];
        [self setCellContent];
    } failed:^(NSError *error) {
        [self setCellContent];
    }];
}

- (void)setCellContent{
    WS(ws);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",_userID]];
    [_userImgBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    if (userInfoDic) {
        signLabel.text = [userInfoDic objectForKey:@"introduction"];
        userNameLabel.text = [userInfoDic objectForKey:@"nickName"];
        long sexNum = [[userInfoDic objectForKey:@"gender"] longValue];
        //性别
        if (sexNum == 1) {
            sexImageView.image = [UIImage imageNamed:@"male.png"];
        }
        else if (sexNum == 2){
            sexImageView.image = [UIImage imageNamed:@"female.png"];
        }
        else
        {
            [sexImageView removeFromSuperview];
            [userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_userImgBtn.mas_right).offset(10);
                make.top.equalTo(_userImgBtn);
                make.bottom.mas_equalTo(signLabel.mas_top);
                make.right.equalTo(ws).offset(-70);
            }];
        }
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
