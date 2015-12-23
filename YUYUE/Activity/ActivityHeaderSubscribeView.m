//
//  ActivityHeaderSubscribeView.m
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityHeaderSubscribeView.h"
#import "CollectionCell.h"
#import "UIImageView+WebCache.h"
#import "UserInfoVC.h"
#import "UserListVC.h"

@implementation ActivityHeaderSubscribeView
{
    //参与btnbackview
    UIView *subscribeBackView;
    
    //
    NSMutableArray *subscribeUsers;
    
    //
    NSDictionary *motionDic;
    
    //
    NSMutableArray *subscribeUsersNames;
    
    UICollectionView *btnCollectionView;
    
    int temi;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setSubDetail:(NSDictionary *)dic{
    //参与者头像
    
    //这里的dic是整个result
    subscribeUsers = [NSMutableArray arrayWithArray:[dic objectForKey:@"subscribeUserIds"]];
    motionDic = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"motion"]];
    subscribeUsersNames = [NSMutableArray arrayWithArray:[dic objectForKey:@"subscribeUserNames"]];
    
    NSInteger numInRow =(SCREEN_WIDTH-10)/50;
    
    temi=0;
    
    if (subscribeUsers.count > numInRow) {
        //如果超过三行的数量
        temi = (int)(subscribeUsers.count-numInRow);
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(40, 40);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    btnCollectionView.alwaysBounceHorizontal = YES;
    btnCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 45) collectionViewLayout:flowLayout];
    
    btnCollectionView.backgroundColor = [UIColor whiteColor];
    btnCollectionView.pagingEnabled = YES;
    btnCollectionView.showsHorizontalScrollIndicator = NO;
    btnCollectionView.showsVerticalScrollIndicator = NO;
    [btnCollectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"depresscell"];
    btnCollectionView.delegate = self;
    btnCollectionView.dataSource = self;

    [self addSubview:btnCollectionView];

    UILabel *joinNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, SCREEN_WIDTH-20, 40)];
    
    NSString *string = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"subscribeCount"]];
    if (string.length == 0||[string isEqualToString:@"(null)"]) {
        string = @"0";
    }
    
    joinNumLabel.text = [NSString stringWithFormat:@"已预约人数（%@）",string];
    joinNumLabel.font = [UIFont systemFontOfSize:14];
    joinNumLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
    [self addSubview:joinNumLabel];
    
    if ([string intValue] > (SCREEN_WIDTH-10)/50) {
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 40)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.backgroundColor = [UIColor whiteColor];
        moreBtn.tag = 0;
        [self addSubview:moreBtn];
    }

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10,11, 6, 18)];
    image.layer.cornerRadius = 3;
    image.layer.masksToBounds = YES;
    image.layer.shouldRasterize = YES;
    image.layer.rasterizationScale = [UIScreen mainScreen].scale;
    image.backgroundColor = [UIColor colorWithRed:61/255.0 green:139/255.0 blue:255/255.0 alpha:1.0];
    [self addSubview:image];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45+45, SCREEN_WIDTH, 15)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self addSubview:line];
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 105+10);
    if (subscribeUsers.count<=0) {
        [line removeFromSuperview];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    }
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numInRow = (SCREEN_WIDTH-10)/50;
    if (subscribeUsers.count>numInRow) {
        return numInRow;
    }
    return subscribeUsers.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"depresscell";
    
    //重用cell
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",[subscribeUsers objectAtIndex:indexPath.row+temi]]];
    [cell.imgView sd_setImageWithURL:url placeholderImage:nil];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self subscribeUserInfoClicked:(indexPath.row+temi)];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)subscribeUserInfoClicked:(NSInteger)sender{
    //跳转到参与用户信息界面
    
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = [subscribeUsers objectAtIndex:sender];
    if ([_delegate respondsToSelector:@selector(pushViewController:)]) {
        [_delegate pushViewController:userInfoVc];
    }
}

- (void)moreBtnClicked:(UIButton *)sender{
    //获取更多用户
    
    UserListVC *userList = [[UserListVC alloc]init];
    userList.userIdArr = subscribeUsers;
    userList.userType = @"参与";
    userList.userIdArr = subscribeUsers;
    userList.userNameArr = subscribeUsersNames;

    if ([_delegate respondsToSelector:@selector(pushViewController:)]) {
        [_delegate pushViewController:userList];
    }
}

@end
