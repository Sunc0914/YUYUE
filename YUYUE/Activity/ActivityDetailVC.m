//
//  ActivityDetailVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/25.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityDetailVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UserInfoVC.h"
#import "MLEmojiLabel.h"
#import "MBProgressHUD.h"
#import "KGModal.h"
#import "InputText.h"
#import "JoinDetailVC.h"
#import "UserListVC.h"
#import "CreateActivityVC.h"
#import "RichLabel.h"
#import "TYAttributedLabel.h"
#import "AGPhotoBrowserView.h"
#import <AVFoundation/AVFoundation.h>
#import "TYImageCache.h"

@interface ActivityDetailVC ()<UITextViewDelegate,UITextViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,TYAttributedLabelDelegate,AGPhotoBrowserDataSource,AGPhotoBrowserDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UITableView *activityDetailTable;
    
    //活动详情
    NSDictionary *motionDic;
    
    //点赞人数
    NSMutableArray *praiseUsers;
    NSMutableArray *praiseUsersNames;
    
    UILabel *favouriteLabel;
    
    //评论人数
    NSString *remarkCount;
    
    //点赞btnbackview
    UIView *praiseBackView;
    
    //参与btnbackview
    UIView *subscribeBackView;
    
    NSArray *arr;
    
    NSArray *keyArr;
    
    NSMutableArray *motionDetailArr;
    //活动详情
    
    NSMutableArray *subscribeUsers;
    NSMutableArray *subscribeUsersNames;
    //参与人数
    
    BOOL isFinish;//是否结束
    
    BOOL canSubscribe;//可以参加
    
    NSString *placeStr;//地点string
    
    NSArray *descriptionArr;//描述arr
    
    CGFloat placeHeight;//地点高度
    
    CGFloat descriptionHeight;//描述高度
    
    NSInteger rowOfPraise;
    
    NSInteger rowOfSubscribe;
    
    UITextView *inputTextView;//输入框
    
    UIButton *completeBtn;//发送按钮
    
    UIView *inputBackView;//输入框背景
    
    NSInteger whichCellEdited;//哪个cell被编辑
    
    NSIndexPath *inputIndexPath;//输入位置
    
    CGFloat keyboardheight;
    
    NSInteger pages;
    
    //评论显示
    
    NSMutableArray *commentArr;//评论arr
    
    NSMutableArray *commentHeightArr;//评论高度arr
    
    BOOL hasMoreComment;//有没有更多评论
    
    UIBarButtonItem *rightBarBtn;//清空输入框按钮
    
    BOOL isRefresh;
    
    UIView *subscribeView;//预约背景
    
    TYAttributedLabel *descriptionView;//描述view
    
    NSMutableArray *imageArr;
    
    NSMutableArray *imageUrlArr;
    
    int imageIndex;
    
}

@property (nonatomic, weak)UITextField *userText;
@property (nonatomic, weak)UILabel *userTextName;
@property (nonatomic, weak)UITextField *emailText;
@property (nonatomic, weak)UILabel *emailTextName;
@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;
@property (nonatomic, assign) BOOL chang;
@property (nonatomic, retain)UIView *backView;
@property (nonatomic, retain)AGPhotoBrowserView *browserView;

@end

@implementation ActivityDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    self.title = @"活动详情";
    
    [self initData];
    
    [self initTable];
    
    [self getData];
}

- (void)initData{

    arr = [[NSArray alloc]initWithObjects:@"活动方式",@"活动地点",@"活动时间",@"活动费用",@"活动对象",@"浏览次数", nil];
    keyArr = [[NSArray alloc]initWithObjects:@"motionType",@"motionPlaceText",@"motionTimeText",@"costMin",@"motionTarget",@"description", nil];
    motionDic = [[NSDictionary alloc]init];
    praiseUsers = [[NSMutableArray alloc]init];
    subscribeUsers = [[NSMutableArray alloc]init];
    remarkCount = [[NSString alloc]init];
    motionDetailArr = [[NSMutableArray alloc]init];
    commentArr = [[NSMutableArray alloc]init];
    commentHeightArr = [[NSMutableArray alloc]init];
    praiseUsersNames = [[NSMutableArray alloc]init];
    subscribeUsersNames = [[NSMutableArray alloc]init];
}

- (void)initTable{
    activityDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    activityDetailTable.dataSource = self;
    activityDetailTable.delegate = self;
    activityDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    activityDetailTable.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [activityDetailTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    activityDetailTable.showsVerticalScrollIndicator = NO;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
    headerView.backgroundColor = [UIColor clearColor];
    [activityDetailTable setTableHeaderView:headerView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    footerView.backgroundColor = [UIColor whiteColor];
    [activityDetailTable setTableFooterView:footerView];
    
//    [self.view addSubview:activityDetailTable];
    
    //输入框初始化
    inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 4, SCREEN_WIDTH-75, 36)];
    inputTextView.delegate = self;
    inputTextView.font = [UIFont systemFontOfSize:16];
    inputTextView.layer.masksToBounds = YES;
    inputTextView.layer.borderWidth = 1;
    inputTextView.layer.cornerRadius = 5;
    inputTextView.layer.shouldRasterize = YES;
    inputTextView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    inputTextView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    
    completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputTextView.frame.origin.x+inputTextView.frame.size.width+5, 4, 45, 36)];
    completeBtn.layer.masksToBounds = YES;
    completeBtn.layer.borderWidth = 1;
    completeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    completeBtn.layer.cornerRadius = 5;
    completeBtn.layer.shouldRasterize = YES;
    completeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    completeBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    
    inputBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    
    inputBackView.backgroundColor = [UIColor colorWithRed:229/255.0 green:228/255.0 blue:225/255.0 alpha:1.0];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    
    [inputBackView addSubview:inputTextView];
    [inputBackView addSubview:completeBtn];
    [inputBackView addSubview:line];
    
    //初始化清空数据
    rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClicked)];

    
    whichCellEdited = 4;
    
    inputIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    
    pages = 1;
    
    hasMoreComment = YES;
    
    subscribeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45)];
    subscribeView.backgroundColor = [UIColor whiteColor];
    subscribeView.alpha = 0.9;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 45)];
    rightBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:103/255.0 blue:19/255.0 alpha:1.0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"我要预约" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(joinClicked) forControlEvents:UIControlEventTouchUpInside];
    [subscribeView addSubview:rightBtn];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 45)];
    leftBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"我也要发起" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(pubilishClicked) forControlEvents:UIControlEventTouchUpInside];
    [subscribeView addSubview:leftBtn];
    
}

- (void)getData{
    
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    
    [AppWebService getActivityDetail:_activityID success:^(id result) {
        
        motionDic = [result objectForKey:@"motion"];
        praiseUsers = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"praiseUserIds"]];
        subscribeUsers = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"subscribeUserIds"]];
        praiseUsersNames = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"praiseUserNames"]];
        subscribeUsersNames = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"subscribeUserNames"]];
        remarkCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"remarkCount"]];
        
        //活动状态
        NSString *motionState = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"finish"]];
        if ([motionState isEqualToString:@"0"]) {
            isFinish = NO;
        }
        else
        {
            isFinish = YES;
        }
        
        //预约状态
        NSString *subscribeState = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"subscribeFinish"]];
        if ([subscribeState isEqualToString:@"0"]) {
            canSubscribe = YES;
        }
        else
        {
            canSubscribe = NO;
        }
        
        //活动地点
        placeStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"motionPlaceText"]];
        
        CGSize placesize;
        placesize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-20, 999) fontsize:12 text:[NSString stringWithFormat:@"活动地点：   %@",placeStr]];
        placeHeight = placesize.height;
        if (placesize.height<20) {
            placeHeight = 20;
        }
        
        //活动描述
        descriptionArr = [NSArray arrayWithArray:[result objectForKey:@"descArray"]];
        
        RichLabel *richModel = [[RichLabel alloc]init];
        descriptionView = [[TYAttributedLabel alloc]init];
//        descriptionView = [richModel setRichLabelWithContent:descriptionArr visitCount:@"0" shareCount:@"0"];
        descriptionView.delegate = self;
        
        imageUrlArr = [[NSMutableArray alloc]initWithArray:[richModel getImageUrlArr]];
        imageArr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<imageUrlArr.count; i++) {
            [[TYImageCache cache] imageForURL:[NSString stringWithFormat:@"%@",imageUrlArr[i]] needThumImage:NO found:^(UIImage *image) {
                [imageArr addObject:image];
            } notFound:^{
                
            }];
        }
        
        descriptionHeight = descriptionView.frame.size.height;
        
        //点赞人数
        rowOfPraise = 0;
        
        if ([motionDic objectForKey:@"praiseCount"]>0) {
            rowOfPraise = 1;
        }
        
        //参与人数
        rowOfSubscribe = 0;
        
        if ([motionDic objectForKey:@"subscribeCount"]>0) {
            rowOfSubscribe = 1;
        }
        
        [self getCommentList];
        
        [RootHud hide:YES];
        
        [activityDetailTable reloadData];
        
        //活动状态，是否接受预约，结束时间
        if (!canSubscribe) {
            
            UIImageView *stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 80+upsideheight, 90, 80)];
            
            if (isFinish) {
                //活动结束
                stateImage.image = [UIImage imageNamed:@"activity_over"];
            }
            else{
                //预约截止
                stateImage.image = [UIImage imageNamed:@"subscribe_over"];
            }
            
            [activityDetailTable addSubview:stateImage];
        }
        
        [self.view addSubview:activityDetailTable];
        
        [self.view addSubview:subscribeView];
        
        [self initBtnsBackground];
        
    } failed:^(NSError *error) {
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = @"加载失败";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
    }];
}

- (void)initBtnsBackground{
    
    //点赞头像
    praiseBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, rowOfPraise*45)];
    
    if (praiseUsers.count>0) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //每行几个
            NSInteger numInRow =(SCREEN_WIDTH-10)/50;
            
            int temi=0;
            
            if (praiseUsers.count > numInRow) {
                //如果超过三行的数量
                temi = (int)(praiseUsers.count-numInRow);
            }
            
            int j = 0;
            
            for (int i = temi; i<praiseUsers.count; i++) {
                
                NSInteger row = j/numInRow;
                NSInteger num = j%numInRow;
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+num*(40+10), row*45, 40, 40)];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = btn.bounds.size.height/2.0f;
                btn.layer.shouldRasterize = YES;
                btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
                //                btn.backgroundColor = [UIColor redColor];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",[praiseUsers objectAtIndex:i]]];
                [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:nil];
                btn.tag = i;
                [btn addTarget:self action:@selector(favouriteUserInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [praiseBackView addSubview:btn];
                j++;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // something
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
                [activityDetailTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
    
    //参与者头像
    subscribeBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, rowOfSubscribe*45)];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (subscribeUsers.count>0) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //每行几个
                NSInteger numInRow =(SCREEN_WIDTH-10)/50;
                
                int temi=0;
                
                if (subscribeUsers.count > numInRow) {
                    //如果超过三行的数量
                    temi = (int)(subscribeUsers.count-numInRow);
                }
                
                int j = 0;
                for (int i = temi; i<subscribeUsers.count; i++){
                    NSInteger row = j/numInRow;
                    NSInteger num = j%numInRow;
                    
                    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+num*(40+10), row*45, 40, 40)];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = btn.bounds.size.height/2.0f;
                    btn.layer.shouldRasterize = YES;
                    btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",[subscribeUsers objectAtIndex:i]]];
                    [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:nil];
                    btn.tag = i;
                    [btn addTarget:self action:@selector(subscribeUserInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [subscribeBackView addSubview:btn];
                    
                    j++;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                    [activityDetailTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                });
            });
            
        }

    });
    
}

- (void)getCommentList{
    
    if (isRefresh) {
        commentArr = [[NSMutableArray alloc]init];
    }
    
    [AppWebService getActivityComment:[motionDic objectForKey:@"id"] objectType:@"1" page:[NSString stringWithFormat:@"%ld",(long)pages] success:^(id result) {
        
        if (commentArr.count>0) {
            [commentArr addObjectsFromArray:result];
        }
        else
        {
            commentArr = [NSMutableArray arrayWithArray:result];
        }
        
        hasMoreComment = NO;
        
        if(commentArr.count<[remarkCount intValue])
        {
            hasMoreComment = YES;
            pages++;
        }
        
        [self calculateCommentHeight];
        
        [activityDetailTable reloadData];
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)calculateCommentHeight{
    //计算评论高度
    for (int i = (int)commentHeightArr.count; i<commentArr.count; i++) {
        CGSize size;
        NSDictionary *temdic = [NSDictionary dictionaryWithDictionary:[commentArr objectAtIndex:i]];
        
        NSLog(@"%@",[temdic objectForKey:@"content"]);
        
        size = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-20, 999) fontsize:12 text:[temdic objectForKey:@"content"]];
        
        if(size.height<16.0f)
        {
            size.height = 25;
        }
        else {
            size.height = size.height+10;
        }
        
        [commentHeightArr addObject:[NSNumber numberWithFloat:size.height]];
    }
}

- (void)btnclicked{
    //点赞
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    if (![self isLogin]) {
        return;
    }
    
    [AppWebService praiseActivity:userinfo.loginID objectId:_activityID success:^(id result) {
        
        NSString *status = [NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
        
        if([status isEqualToString:@"0"])
        {
            [inputTextView resignFirstResponder];
            
            RootHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:RootHud];
            
            RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            
            // Set custom view mode
            RootHud.mode = MBProgressHUDModeCustomView;
            
            RootHud.delegate = self;
            RootHud.labelText = @"哎呀，您已点过赞了";
            
            [RootHud show:YES];
            [RootHud hide:YES afterDelay:1];
            
            return;
        }
        int count = [favouriteLabel.text intValue];
        count++;
        favouriteLabel.text = [NSString stringWithFormat:@"%d",count];
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)joinClicked{
    //预约
    if (![self isLogin]) {
        return;
    }
    
    [self showItems];
}

- (void)pubilishClicked{
    //发起活动
    
    if (![self isLogin]) {
        return;
    }
    
    CreateActivityVC *creat = [[CreateActivityVC alloc]init];
    creat.isModelViewController = YES;
    [self.navigationController pushViewControllerAnimatedWithTransition:creat];
}

- (void)showItems{
    
    //填写预约信息
    JoinDetailVC *joinDetail = [[JoinDetailVC alloc]init];
    joinDetail.activityID = _activityID;
    [self.navigationController pushViewController:joinDetail animated:YES];
}

- (void)createTitleClicked:(UIButton *)sender{
    //跳转到发起者个人信息界面
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = [motionDic objectForKey:@"createUserId"];
    [self.navigationController pushViewController:userInfoVc animated:YES];
}

- (void)favouriteUserInfoClicked:(UIButton *)sender{
    //跳转到点赞用户信息界面
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = [praiseUsers objectAtIndex:sender.tag];
    [self.navigationController pushViewController:userInfoVc animated:YES];
    
}

- (void)subscribeUserInfoClicked:(UIButton *)sender{
    //跳转到参与用户信息界面
    
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = [subscribeUsers objectAtIndex:sender.tag];
    [self.navigationController pushViewController:userInfoVc animated:YES];
}

- (void)commentUserClicked:(UIButton *)sender
{
    //跳转到评论用户信息界面
    NSString *userID = @"";
    NSDictionary *temdic = [commentArr objectAtIndex:sender.tag];
    userID = [NSString stringWithFormat:@"%@",[temdic objectForKey:@"createUserId"]];
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = userID;
    [self.navigationController pushViewController:userInfoVc animated:YES];
    
}

- (void)completeBtnClicked:(UIButton *)sender{
    
    NSLog(@"%@",inputTextView.text);
    
    if (inputTextView.text.length == 0) {
        
        [inputTextView resignFirstResponder];
        
        RootHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:RootHud];
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        // Set custom view mode
        RootHud.mode = MBProgressHUDModeCustomView;
        
        RootHud.delegate = self;
        RootHud.labelText = @"评论不能为空";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        return;
    }
    
    if (![self isLogin]) {
        return;
    }
    
    //发表评论
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    [AppWebService addComment:userinfo.loginID objectID:_activityID objectType:_activityType score:nil content:inputTextView.text success:^(id result) {
        NSLog(@"success");
        isRefresh = YES;
        [self getCommentList];
        [activityDetailTable reloadData];
    } failed:^(NSError *error) {
        
    }];
    
    [inputTextView resignFirstResponder];
    
    activityDetailTable.userInteractionEnabled = YES;
    
}

- (void)myTask
{
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}

- (void)moreBtnClicked:(UIButton *)sender{
    //获取更多用户
    
    UserListVC *userList = [[UserListVC alloc]init];
    userList.userIdArr = praiseUsers;
    if (sender.tag == 0) {
        userList.userType = @"参与";
        userList.userIdArr = subscribeUsers;
        userList.userNameArr = subscribeUsersNames;
    }
    else
    {
        userList.userType = @"点赞";
        userList.userIdArr = praiseUsers;
        userList.userNameArr = praiseUsersNames;
    }
    
    
    [self.navigationController pushViewController:userList animated:YES];
}

- (void)writeComment
{
    //写评论
    inputBackView.backgroundColor = [UIColor colorWithRed:229/255.0 green:228/255.0 blue:225/255.0 alpha:1.0];
    inputTextView.font = [UIFont systemFontOfSize:16];
    inputTextView.returnKeyType = UIReturnKeyDone;
    inputTextView.delegate = self;
    
    inputTextView.layer.borderWidth = 1;
    inputTextView.layer.cornerRadius = 5;
    inputTextView.layer.borderColor = [UIColor whiteColor].CGColor;
    inputTextView.layer.masksToBounds = YES;
    inputTextView.layer.shouldRasterize = YES;
    inputTextView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [inputBackView addSubview:inputTextView];
    
    [completeBtn addTarget:self action:@selector(completeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    completeBtn.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
    completeBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    completeBtn.layer.cornerRadius = 5;
    completeBtn.layer.masksToBounds = YES;
    completeBtn.layer.shouldRasterize = YES;
    completeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [inputBackView addSubview:completeBtn];
    
    [self.view addSubview:inputBackView];
    
    [inputTextView becomeFirstResponder];
    
    activityDetailTable.userInteractionEnabled = NO;
}

- (void)rightBarBtnClicked
{
    //清空输入框
    
    inputTextView.text = @"";
    
    [UIView animateWithDuration:0.2f animations:^{
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardheight-44, SCREEN_WIDTH, 44);
        
        inputTextView.frame = CGRectMake(15, 4, SCREEN_WIDTH - 75, 36);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.emailTextName textField:self.emailText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
    
    [self hideview:inputBackView height:SCREEN_HEIGHT];
    activityDetailTable.userInteractionEnabled = YES;
    [inputTextView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initKeyboardNotification];
}

- (void)initKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    return imageArr.count;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
    return [imageArr objectAtIndex:index];
}

#pragma mark - AGPhotoBrowser delegate

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
    // -- Dismiss
    NSLog(@"Dismiss the photo browser here");
    [self.browserView hideWithCompletion:^(BOOL finished){
        NSLog(@"Dismissed!");
    }];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
    NSLog(@"Action button tapped at index %ld!", (long)index);
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"提    示"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"保存到本地相册"
                                               otherButtonTitles:nil];
    action.tintColor = [UIColor darkGrayColor];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    
}

#pragma mark - saveimg
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied){
        //没有使用权限
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提  示" message:@"喻体未获得您的相册权限，请前往设置里面授权" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"设置", nil];
        [alert show];
    }
    else {
        UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        //        [self.view showResult:ResultViewTypeFaild text:msg];
    }else{
        msg = @"保存图片成功" ;
        //        [self.view showResult:ResultViewTypeOK text:msg];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提  示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Getters

- (AGPhotoBrowserView *)browserView
{
    if (!_browserView) {
        _browserView = [[AGPhotoBrowserView alloc] initWithFrame:self.view.bounds];
        _browserView.delegate = self;
        _browserView.dataSource = self;
    }
    
    return _browserView;
}

#pragma mark - delegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    NSLog(@"textStorageClickedAtPoint");
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        
        id linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }else if ([TextRun isKindOfClass:[TYImageStorage class]]) {
        
        TYImageStorage *imageStorage = (TYImageStorage *)TextRun;
        NSInteger index = [imageUrlArr indexOfObject:imageStorage.imageURL];
        
        if (index>=imageArr.count) {
            return;
        }
        
        [self.browserView showFromIndex:index];
    }
}

#pragma mark -uitextfielddelegate
- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.emailTextName textField:self.emailText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.emailText) {
        [self diminishTextName:self.emailTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.emailTextName textField:self.emailText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userText) {
        return [self.emailText becomeFirstResponder];
    } else if (textField == self.emailText){
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}

- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}
- (void)textFieldDidChange
{
    if (self.userText.text.length != 0 && self.emailText.text.length != 0 && self.passwordText.text.length != 0) {

    } else {

    }
}

#pragma mark -KeyboardNotification
- (void) keyboardWillShow:(NSNotification *) note
{
   
    
}

- (void) keyboardDidShow:(NSNotification *) note
{
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hight_hitht:%f",kbSize.height);
    keyboardheight = kbSize.height;
    
    CGFloat textViewHeight = inputBackView.frame.size.height;
    
    [UIView animateWithDuration:0.5f animations:^{
        
        //输入框弹出
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardheight - textViewHeight, SCREEN_WIDTH, 44);
        
        inputTextView.frame = CGRectMake(15, 4, SCREEN_WIDTH - 75, 36);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
        
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
    }];
    
    activityDetailTable.userInteractionEnabled = NO;
}

- (void) keyboardWillHide:(NSNotification *) note
{
    keyboardheight = 0;
    
    activityDetailTable.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
        
        inputTextView.frame = CGRectMake(15, 4, SCREEN_WIDTH - 75, 36);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }];
    
}


#pragma mark -uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7+commentArr.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"activitydetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    
    if (indexPath.row == 0) {
        //活动头像
        #pragma mark --活动简介
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        image.layer.cornerRadius = image.frame.size.height/2;
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/%@",[motionDic objectForKey:@"sportItemIcon"]]] placeholderImage:nil
         ];
        image.backgroundColor = [UIColor whiteColor];
        [cell addSubview:image];
        
        //活动名称
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-45-100, 30)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
        NSString *nameStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"name"]];
        if ([nameStr isEqualToString:@"(null)"]) {
            nameStr = @"";
        }
        titleLabel.text = nameStr;
        [cell addSubview:titleLabel];
        
        //谁发布于什么时候
        UIButton *whoAndWhen = [[UIButton alloc]initWithFrame:CGRectMake(100, 40, SCREEN_WIDTH-45-100, 25)];
        whoAndWhen.titleLabel.font = [UIFont systemFontOfSize:11];
        whoAndWhen.titleLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        whoAndWhen.titleLabel.numberOfLines = 2;
        
        NSString *whoStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"createUserName"]];
        NSString *createTimeStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"createTimeText"]];
        if ([whoStr isEqualToString:@"(null)"]) {
            whoStr = @"";
        }
        
        if ([createTimeStr isEqualToString:@"(null)"]) {
            createTimeStr = @"";
        }
        
        NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",whoStr,createTimeStr]];
        [timeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,whoStr.length)];
        [whoAndWhen setAttributedTitle:timeStr forState:UIControlStateNormal];
        whoAndWhen.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [whoAndWhen addTarget:self action:@selector(createTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:whoAndWhen];
        
        //最大预约人数
        UILabel *maxNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 65, SCREEN_WIDTH-45-100, 25)];
        maxNumLabel.font = [UIFont systemFontOfSize:11];
        maxNumLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        maxNumLabel.numberOfLines = 2;
        NSString *maxStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"maxSubscribers"]];
        if ([maxStr isEqualToString:@"(null)"]) {
            maxStr = @"";
        }
        maxNumLabel.text = [NSString stringWithFormat:@"最大预约人数：%@",maxStr];
        [cell addSubview:maxNumLabel];
        
        //根据cell的高度
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 15)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        
        [cell addSubview:line];
        
        NSString *motionState;
        
        //活动状态，是否接受预约，结束时间
        if (canSubscribe) {
            
            //可以预约
             motionState = @"接受预约中";
        }
        else
        {
            if (isFinish) {
                //活动结束
                motionState = @"活动已结束";
            }
            else{
                //预约截止
                motionState = @"预约已截止";
            }
        }
        
        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 90, SCREEN_WIDTH-45-100, 25)];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",motionState,[motionDic objectForKey:@"leftTime"]]];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5,string.length-5)];
        stateLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        stateLabel.attributedText = string;
        stateLabel.font = [UIFont systemFontOfSize:11];
        [cell addSubview:stateLabel];
        
        //点赞按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 20, 30, 30)];
        [btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0].CGColor;
        btn.layer.borderWidth = 1.0f;
        [cell addSubview:btn];
       
        
        favouriteLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 50, 30, 20)];
        favouriteLabel.font = [UIFont systemFontOfSize:12];
        favouriteLabel.textColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
        favouriteLabel.textAlignment = NSTextAlignmentCenter;
        favouriteLabel.text = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"praiseCount"]];
        [cell addSubview:favouriteLabel];
        
    }
    else if (indexPath.row == 1){
        //活动详情
        
        #pragma mark --活动详情
        
        CGFloat lastHeight = 10;
        
        for (int i = 0; i<6; i++) {
            
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont systemFontOfSize:12];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            
            //活动方式
            NSString *motionTypeStr = [[NSString alloc]init];
            NSString *motionTypeStateStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"motionType"]];
            
            if ([motionTypeStateStr isEqualToString:@"0"]) {
                motionTypeStr = @"全部";
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
            NSString *motionTatgetStateStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"motionType"]];
            
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
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],[motionDic objectForKey:[keyArr objectAtIndex:i]]]];

            if (i == 0) {
                //活动类型
                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 20);
                if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
                    label.text = @"";
                }
                string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],motionTypeStr]];
                lastHeight = lastHeight+20;

            }
            else if (i == 1) {
                //活动地点
                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, placeHeight);
                lastHeight = lastHeight + placeHeight;
            }
            else if (i == 2)
            {
                //活动时间
                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 20);
                lastHeight = lastHeight + 20;
            }
            else if (i == 3)
            {
                //活动费用
                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 20);
                lastHeight = lastHeight + 20;
            }
            else if (i == 4)
            {
                //活动对象
                string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],motionTargetStr]];
                if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
                    label.text = @"";
                }
                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 20);
                lastHeight = lastHeight + 20;
            }
            else if (i == 5)
            {
                //浏览人数
                string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:   %@",[arr objectAtIndex:i],[motionDic objectForKey:@"visitCount"]]];
                if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
                    label.text = @"";
                }
                
                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 20);
                lastHeight = lastHeight + 20;
//                label.frame = CGRectMake(10, 10+20*i, SCREEN_WIDTH-20, 20);
//                label.frame = CGRectMake(10, lastHeight, SCREEN_WIDTH-20, 20);
//                lastHeight = lastHeight + descriptionHeight;
                label.backgroundColor = [UIColor whiteColor];
            }
            
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0] range:NSMakeRange(6,string.length-6)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0] range:NSMakeRange(0,5)];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12] range:NSMakeRange(0,string.length)];
            
            if ([string isEqualToAttributedString:[[NSMutableAttributedString alloc]initWithString:@"(null)"]]) {
                label.attributedText = nil;
            }
            
            label.attributedText = string;
            
            [cell addSubview:label];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, lastHeight, SCREEN_WIDTH, 15)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell addSubview:line];
        
    }
    else if (indexPath.row == 2)
    {
        #pragma mark --活动介绍
        UILabel *commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
        commentNumLabel.text = @"活动介绍";
        commentNumLabel.font = [UIFont systemFontOfSize:14];
        commentNumLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        [cell addSubview:commentNumLabel];
        
        UIView *narrowLine = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREEN_WIDTH-20, 1)];
        narrowLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell addSubview:narrowLine];
        
        [cell addSubview:descriptionView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 60+descriptionHeight, SCREEN_WIDTH, 15)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell addSubview:line];
        
    }
    else if (indexPath.row == 3){
        #pragma mark --预约人数
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subscribe"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subscribe"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
        
        //预约人数
        UILabel *joinNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
        
        NSString *string = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"subscribeCount"]];
        if (string.length == 0||[string isEqualToString:@"(null)"]) {
            string = @"0";
        }
        
        joinNumLabel.text = [NSString stringWithFormat:@"已预约人数（%@）",string];
        joinNumLabel.font = [UIFont systemFontOfSize:14];
        joinNumLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        [cell addSubview:joinNumLabel];
        
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 40)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.backgroundColor = [UIColor whiteColor];
        moreBtn.tag = 0;
        [cell addSubview:moreBtn];
        
        UIView *narrowLine = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREEN_WIDTH-20, 1)];
        narrowLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell addSubview:narrowLine];
        
        [cell addSubview:subscribeBackView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45+rowOfSubscribe*45, SCREEN_WIDTH, 15)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
//        line.backgroundColor = [UIColor redColor];
        [cell addSubview:line];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    else if (indexPath.row == 4){
        #pragma mark --点赞人数
        //点赞人数
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"praise"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"praise"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *favouriteNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
        favouriteNumLabel.text = [NSString stringWithFormat:@"已点赞人数（%@）",[motionDic objectForKey:@"praiseCount"]];
        favouriteNumLabel.font = [UIFont systemFontOfSize:14];
        favouriteNumLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        [cell addSubview:favouriteNumLabel];
        
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 40)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.backgroundColor = [UIColor whiteColor];
        moreBtn.tag = 1;
        [cell addSubview:moreBtn];
        
        UIView *narrowLine = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREEN_WIDTH-20, 1)];
        narrowLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell addSubview:narrowLine];
        
        [cell addSubview:praiseBackView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45+rowOfPraise*45, SCREEN_WIDTH, 15)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
//        line.backgroundColor = [UIColor greenColor];
        [cell addSubview:line];
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    else if (indexPath.row == 5){
        //评论人数
        #pragma mark --评论人数
        UILabel *commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
        commentNumLabel.text = [NSString stringWithFormat:@"用户留言（%@）",remarkCount];
        commentNumLabel.font = [UIFont systemFontOfSize:14];
        commentNumLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        [cell addSubview:commentNumLabel];
        
        UIView *narrowLine = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREEN_WIDTH-20, 1)];
        narrowLine.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:narrowLine];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 45, SCREEN_WIDTH-40, 40)];
        [btn setTitle:@"说点什么吧" forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.shouldRasterize = YES;
        btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        btn.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        btn.layer.borderWidth = 1.0f;
        [btn setTitleColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    else
    {
        #pragma mark --评论内容
        NSString *userNameStr = @"";
        NSString *timeStr = @"";
        NSString *contentStr = @"";
        if (commentArr.count>0) {
            NSDictionary *temdic = [commentArr objectAtIndex:(int)(indexPath.row-6)];
            userNameStr = [temdic objectForKey:@"createUserName"];
            timeStr = [temdic objectForKey:@"createTimeText"];
            contentStr = [temdic objectForKey:@"content"];
        }
        
        CGFloat height = 0;
        
        if (commentHeightArr.count>0) {
            NSString *heightStr = [commentHeightArr objectAtIndex:(int)(indexPath.row-6)];
            height = [heightStr floatValue];
        }
        
        UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 200, 25)];
        userBtn.tag = (int)(indexPath.row-5);
        [userBtn setTitle:userNameStr forState:UIControlStateNormal];
        [userBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        userBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        userBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [userBtn addTarget:self action:@selector(commentUserClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-100,0, 100, 25)];
        timeLabel.textColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.text = timeStr;
        
        MLEmojiLabel *contentLabel = [[MLEmojiLabel alloc]init];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
        contentLabel.font = [UIFont systemFontOfSize:12.0f];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contentLabel.isNeedAtAndPoundSign = YES;
        
        [contentLabel setText:contentStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            return mutableAttributedString;
        }];
        
        contentLabel.frame = CGRectMake(10, 30, SCREEN_WIDTH-20, height);
//        [contentLabel sizeToFit];
        
        UIView *narrowLine = [[UIView alloc]initWithFrame:CGRectMake(10, 30+height-1, SCREEN_WIDTH-20, 1)];
        narrowLine.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        
        [cell addSubview:userBtn];
        [cell addSubview:timeLabel];
        [cell addSubview:contentLabel];
        [cell addSubview:narrowLine];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int index = (int)indexPath.row;
    
    if (index == 0) {
        if (isFinish) {
            return 115 +25;
        }
        return 115+25;
    }
    else if (index == 1)
    {
        //动态参数 活动详情
        return 115+placeHeight+20;
    }
    else if (index == 2){
        //活动介绍
        return descriptionHeight+40+35+10;
    }
    else if (index == 3)
    {
        //动态参数 参与人数
        return 70+rowOfSubscribe*45;
    }
    else if (index == 4){
        //动态参数 点赞人数
        return 70+rowOfPraise*45;
    }
    else if (index == 5){
        //评论人数
        return 65+35;
    }
    else if(index>5&&index<(5+commentArr.count))
    {
        //用户评论高度
        
        CGFloat height = 0;
        
        if (commentHeightArr.count>0) {
            NSString *heightStr = [commentHeightArr objectAtIndex:(int)(indexPath.row-5)];
            height = [heightStr floatValue];
        }
        
        return 35+height;
    }
    else
    {
        //预约按钮
        return 65;
    }
}

#pragma mark -uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark -uitextviewdelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    CGSize constraintSize;
    
    constraintSize.width = SCREEN_WIDTH-75;
    constraintSize.height = 120;
    CGSize sizeFrame =[textView.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (sizeFrame.height<36) {
        inputBackView.frame = CGRectMake(0, inputBackView.frame.origin.y, SCREEN_WIDTH, 50);
        return;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardheight - sizeFrame.height -4-4, SCREEN_WIDTH, sizeFrame.height+8);
        
        textView.frame = CGRectMake(15, 4, SCREEN_WIDTH-75, sizeFrame.height);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
        
    }];

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
