//
//  ActivityDetailNewVC.m
//  YUYUE
//
//  Created by Sunc on 15/11/16.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityDetailNewVC.h"
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
#import "ActivityHeaderDetailView.h"
#import "ActivityHeaderSubscribeView.h"
#import "ActivityHeaderTitleView.h"
#import "ActivityHeaderPraiseView.h"
#import "ActivityDetailCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "UMSocial.h"
#import "YYLabel.h"
#import "YYTextView.h"

@interface ActivityDetailNewVC ()<UITextViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,TYAttributedLabelDelegate,AGPhotoBrowserDataSource,AGPhotoBrowserDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,subPush,titlePush,cellPush,praPush,UMSocialUIDelegate,subScribeSuccess,UICollectionViewDelegate,UICollectionViewDataSource,YYTextViewDelegate>
{
    NSArray *arr;//中文类别
    
    NSArray *keyArr;//英文key
    
    UITableView *activityDetailTable;
    NSMutableDictionary *motionDic;
    
    YYTextView *inputTextView;//输入框
    UIButton *completeBtn;//发送按钮
    UIView *inputBackView;//输入框背景
    UIButton *emBtn;//表情按钮
    UICollectionView *emCollectionView;//表情
    CGFloat cellHeihgt;
//    NSDictionary *emDic;
    NSDictionary *reverseEmDic;
    
    UIView *subscribeView;//预约背景
    TYAttributedLabel *coreLabel;//
    UILabel *numOfZan;//点赞
    UIButton *zanBtn;//点赞按钮
    
    UIView *descriptionView;//描述view
    
    UIBarButtonItem *rightBarBtn;//清空输入框按钮
    UIBarButtonItem *shareBarBtn;//分享
    BOOL hasMoreComment;//有没有更多评论
    BOOL isRefresh;//是刷新还是上拉加载
    BOOL isZan;//点赞的时候不需要刷新cell
    
    NSInteger whichCellEdited;//哪个cell被编辑
    NSIndexPath *inputIndexPath;//输入位置
    CGFloat keyboardheight;
    NSInteger pages;
    
    NSMutableArray *imageArr;
    NSMutableArray *imageUrlArr;
    int imageIndex;
    
    NSMutableArray *commentArr;//评论arr
    NSMutableArray *commentHeightArr;//评论高度arr
    NSString *remarkCount;//评论人数
    NSArray *descriptionArr;
    //点赞人数
    NSMutableArray *praiseUsers;
    NSMutableArray *praiseUsersNames;
    
    ActivityHeaderDetailView *headerDetailView;
    ActivityHeaderSubscribeView *headerSubscribeView;
    ActivityHeaderPraiseView *headerPraiseView;
    ActivityHeaderTitleView *headerTitleView;
    
    UIView *grayView;//模态视图
    NSString *replyID;
    NSString *toUserID;
    NSIndexPath *cellIndexPath;
    
    CGFloat contentOffY;
    
    //YY相关的类
    YYTextSimpleEmoticonParser *yyParser;
    
}

@property (nonatomic, weak)UITextField *userText;
@property (nonatomic, weak)UILabel *userTextName;
@property (nonatomic, weak)UITextField *emailText;
@property (nonatomic, weak)UILabel *emailTextName;
@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;
@property (nonatomic, assign) BOOL chang;
@property (nonatomic, retain)UIView *backView;
@property (nonatomic, strong) AGPhotoBrowserView *browserView;
@property (nonatomic, retain) NSDictionary *resultDic;

@end

@implementation ActivityDetailNewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"活动详情";
    
    if (!grayView) {
        grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        grayView.backgroundColor = [UIColor lightGrayColor];
        grayView.alpha = 0.5;
    }
    
    yyParser = [YYTextSimpleEmoticonParser new];
    
    yyParser = [self getYYEmDic];
    
    [self getData];
    
    [self initTable];
    
    [self initSub];
    
    [self initBarItem];
    
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    
}

- (YYTextSimpleEmoticonParser *)getYYEmDic{
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    
    static NSDictionary *emojiDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"expressionImage.plist"];
        emojiDictionary = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
    });
    NSArray *yyKeyArr = [emojiDictionary allKeys];
    for (NSString *key in yyKeyArr) {
        mapper[key] = [UIImage imageNamed:[emojiDictionary objectForKey:key]];
    }
    parser.emoticonMapper = mapper;
    
    return parser;
}

- (void)initTable{
    
    if (!activityDetailTable) {
        activityDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
        activityDetailTable.dataSource = self;
        activityDetailTable.delegate = self;
        activityDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        activityDetailTable.backgroundColor = backGroundColor;
        [activityDetailTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
        activityDetailTable.showsVerticalScrollIndicator = NO;
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
        headerView.backgroundColor = [UIColor clearColor];
        [activityDetailTable setTableHeaderView:headerView];
        
        activityDetailTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 上拉加载
            
            if (activityDetailTable.footer.isRefreshing) {
                
                [self getCommentListAfterComment:NO];
            }
            
        }];
    }
}

- (void)initInput{
    //输入框初始化
    if (!emBtn) {
        emBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 36, 36)];
        emBtn.layer.masksToBounds = YES;
        emBtn.layer.cornerRadius = 5;
        emBtn.layer.shouldRasterize = YES;
        emBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        emBtn.backgroundColor = [UIColor clearColor];
        [emBtn addTarget:self action:@selector(emBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        emBtn.selected = NO;
        [emBtn setImage:[UIImage imageNamed:@"faceNo"] forState:UIControlStateNormal];
        [emBtn setImage:[UIImage imageNamed:@"face"] forState:UIControlStateSelected];
    }
    
    if (!inputTextView) {
        inputTextView = [[YYTextView alloc]initWithFrame:CGRectMake(emBtn.frame.origin.x+emBtn.frame.size.width+3, 8, SCREEN_WIDTH-5-36-3-3-50-5, 30)];
        inputTextView.delegate = self;
        inputTextView.font = [UIFont systemFontOfSize:16];
        inputTextView.layer.masksToBounds = YES;
        inputTextView.layer.cornerRadius = 5;
        inputTextView.scrollEnabled = YES;
        inputTextView.textParser = yyParser;
        inputTextView.placeholderTextColor = tipColor;
        inputTextView.textColor = [UIColor darkGrayColor];
        inputTextView.placeholderText = @"我也说一句";
        inputTextView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    }
    
    if (!completeBtn) {
        completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputTextView.frame.origin.x+inputTextView.frame.size.width+3, inputTextView.frame.origin.y, 50, 30)];
        completeBtn.layer.masksToBounds = YES;
        completeBtn.layer.shouldRasterize = YES;
        completeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        completeBtn.layer.cornerRadius = 5;
        completeBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:152/255.0 blue:234/255.0 alpha:1.0];
        [completeBtn setTitle:@"发送" forState:UIControlStateNormal];
    }
    
    [self getEmDic];
    
    cellHeihgt = SCREEN_WIDTH/7;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(cellHeihgt, cellHeihgt);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    emCollectionView.alwaysBounceHorizontal = YES;
    CGFloat emHeight;
    emHeight = cellHeihgt*3;
    if (!emCollectionView) {
        emCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, emHeight) collectionViewLayout:flowLayout];
        emCollectionView.backgroundColor = backGroundColor;
        emCollectionView.pagingEnabled = YES;
        emCollectionView.showsHorizontalScrollIndicator = NO;
        emCollectionView.showsVerticalScrollIndicator = NO;
        [emCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"depresscell"];
        emCollectionView.delegate = self;
        emCollectionView.dataSource = self;
    }
    
    if (!inputBackView) {
        inputBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
        inputBackView.backgroundColor = [UIColor whiteColor];
        [inputBackView addSubview:inputTextView];
        [inputBackView addSubview:completeBtn];
        [inputBackView addSubview:emBtn];
    }
    
    [inputBackView removeFromSuperview];
    
    whichCellEdited = 4;
    
    inputIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    
    pages = 1;
    
    hasMoreComment = YES;
}

- (void)initSub{
    subscribeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    subscribeView.backgroundColor = [UIColor clearColor];
    subscribeView.alpha = 0.9;

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 49)];
    rightBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:103/255.0 blue:19/255.0 alpha:1.0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"我要预约" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(joinClicked) forControlEvents:UIControlEventTouchUpInside];
    [subscribeView addSubview:rightBtn];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 49)];
    leftBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"我也要发起" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(pubilishClicked) forControlEvents:UIControlEventTouchUpInside];
    [subscribeView addSubview:leftBtn];
}

- (void)initBarItem{
    //初始化清空数据
    rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClicked:)];
    rightBarBtn.tag = 10086;
    
    //分享
    UIImage* itemImage= [UIImage imageNamed:@"shareNor"]; // Colored Image
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shareBarBtn = [[UIBarButtonItem alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClicked:)];
    shareBarBtn.tag = 10000;
    
    self.navigationItem.rightBarButtonItem = shareBarBtn;
}

- (void)getData{
    
    [AppWebService getActivityDetail:_activityID success:^(id result) {
        
        motionDic = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"motion"]];
        praiseUsers = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"praiseUserIds"]];
        praiseUsersNames = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"praiseUserNames"]];
        //活动描述
        descriptionArr = [NSArray arrayWithArray:[result objectForKey:@"descArray"]];
        remarkCount = [NSString stringWithFormat:@"%@",[result objectForKey:@"remarkCount"]];
        
        _resultDic = [NSDictionary dictionaryWithDictionary:result];
        
        if ([remarkCount isEqualToString:@"(null)"]) {
            remarkCount = @"0";
        }
        
        //初始化header
        [self initSectionViews:[NSDictionary dictionaryWithDictionary:result]];
        
        pages = 1;
        if (!isZan) {
            [self getCommentListAfterComment:NO];
        }
        
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 0.2f * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            NSLog(@"Grand Center Dispatch!");
            if(activityDetailTable.superview != self.view)
            {
                [activityDetailTable reloadData];
                [self.view addSubview:activityDetailTable];
                [self.view addSubview:subscribeView];
            }
            else{
                [activityDetailTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
            }
            isZan = NO;//恢复点赞前的状态
            [RootHud hide:YES];
        });
        
    } failed:^(NSError *error) {
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        RootHud.labelText = @"加载失败";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
    }];
}

- (void)initDesView:(TYAttributedLabel *)label visit:(NSString *)visit share:(NSString *)share{
    descriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, label.frame.size.height+40+15+10+40+20+70)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, SCREEN_WIDTH-26, 40)];
    titleLabel.text = @"活动说明";
    titleLabel.textColor = [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10,11, 6, 18)];
    image.layer.cornerRadius = 3;
    image.layer.masksToBounds = YES;
    image.layer.shouldRasterize = YES;
    image.layer.rasterizationScale = [UIScreen mainScreen].scale;
    image.backgroundColor = [UIColor colorWithRed:61/255.0 green:139/255.0 blue:255/255.0 alpha:1.0];
    
    UIImageView *dianzanImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, label.frame.origin.y+label.frame.size.height + 20, 70, 70)];
    dianzanImage.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    dianzanImage.image = [UIImage imageNamed:@"zan1Nor"];
    dianzanImage.layer.masksToBounds = YES;
    dianzanImage.layer.shouldRasterize = YES;
    dianzanImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    dianzanImage.layer.cornerRadius = dianzanImage.bounds.size.width/2.0;
    [descriptionView addSubview:dianzanImage];
    
    //开始蹩脚英文
    numOfZan = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
    numOfZan.center = CGPointMake(70/2.0+2, 70-20);
    numOfZan.textColor = tipColor;
    numOfZan.adjustsFontSizeToFitWidth = YES;
    numOfZan.textAlignment = NSTextAlignmentCenter;
    NSString *zanStr = [NSString stringWithFormat:@"赞（%@）",[motionDic objectForKey:@"praiseCount"]];
    if ([zanStr isEqual:@"(null)"]) {
        zanStr = @"0";
    }
    numOfZan.text = zanStr;
    [dianzanImage addSubview:numOfZan];
    
    zanBtn = [[UIButton alloc]init];
    zanBtn.frame = dianzanImage.frame;
    zanBtn.backgroundColor = [UIColor clearColor];
    [zanBtn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
    [descriptionView addSubview:zanBtn];
    
    UILabel *visitLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30-100, dianzanImage.frame.origin.y+dianzanImage.frame.size.height, 60, 40)];
    visitLabel.font = [UIFont systemFontOfSize:12];
    visitLabel.textColor = [UIColor darkGrayColor];
    visitLabel.textAlignment = NSTextAlignmentRight;
    visitLabel.text = [NSString stringWithFormat:@"浏览 %@",visit];
    [descriptionView addSubview:visitLabel];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, dianzanImage.frame.origin.y+dianzanImage.frame.size.height, 60, 40)];
    shareLabel.font = [UIFont systemFontOfSize:12];
    shareLabel.textColor = [UIColor darkGrayColor];
    shareLabel.textAlignment = NSTextAlignmentRight;
    shareLabel.text = [NSString stringWithFormat:@"分享 %@",share];
    [descriptionView addSubview:shareLabel];
    
    //根据cell的高度
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, descriptionView.frame.size.height-15, SCREEN_WIDTH, 15)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [descriptionView addSubview:label];
    [descriptionView addSubview:titleLabel];
    [descriptionView addSubview:image];
    [descriptionView addSubview:line];
    descriptionView.backgroundColor = [UIColor whiteColor];
}

- (void)initSectionViews:(NSDictionary *)sender{
    
        RichLabel *richModel = [[RichLabel alloc]init];
        coreLabel = [[TYAttributedLabel alloc]init];
        coreLabel = [richModel setRichLabelWithContent:descriptionArr];
        coreLabel.delegate = self;
        
        NSString *visit = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"visitCount"]];
        if ([visit isEqualToString:@"(null)"]) {
            visit = @"0";
        }
        
        NSString *share = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"shareCount"]];
        if ([visit isEqualToString:@"(null)"]) {
            share = @"0";
        }
        
        [self initDesView:coreLabel visit:visit share:share];
    
    //详情
    headerDetailView = [[ActivityHeaderDetailView alloc]init];
    [headerDetailView setHeaderDetail:motionDic];
    //预约
    headerSubscribeView = [[ActivityHeaderSubscribeView alloc]init];
    headerSubscribeView.delegate = self;
    [headerSubscribeView setSubDetail:sender];
    //点赞
    headerPraiseView = [[ActivityHeaderPraiseView alloc]init];
    headerPraiseView.delegate = self;
    [headerPraiseView setSubDetail:sender];
    //标题
    headerTitleView = [[ActivityHeaderTitleView alloc]init];
    headerTitleView.delegate = self;
    [headerTitleView setTitleDetail:motionDic];
    
    int getTime = 0;//获取富文本图片的次数
    [self getImageUrl:richModel withTime:(int)getTime];
}

- (void)getImageUrl:(RichLabel *)richModel withTime:(int )initTime{
    
    __block int temTime = initTime;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        imageUrlArr = [[NSMutableArray alloc]initWithArray:[richModel getImageUrlArr]];
        imageArr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<imageUrlArr.count; i++) {
            [[TYImageCache cache] imageForURL:[NSString stringWithFormat:@"%@",imageUrlArr[i]] found:^(UIImage *image) {
                [imageArr addObject:image];
            } notFound:^{
                
            }];
        }
        
        if (imageArr.count<imageUrlArr.count&&temTime<3) {
            temTime++;
            [self getImageUrl:richModel withTime:initTime];
        }
    });
}

- (void)emBtnClicked{
    
    if (emBtn.selected) {
        //收起表情
        emBtn.selected = NO;
        
        [inputTextView becomeFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            emCollectionView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, emCollectionView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        //显示表情
        emBtn.selected = YES;
        
        [inputTextView resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            emCollectionView.frame = CGRectMake(0, (SCREEN_HEIGHT-emCollectionView.frame.size.height), SCREEN_WIDTH, emCollectionView.frame.size.height);
            inputBackView.frame = CGRectMake(0, emCollectionView.frame.origin.y-inputBackView.frame.size.height, SCREEN_WIDTH, inputBackView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)getEmDic{
    static NSDictionary *emojiDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"expressionImage.plist"];
        emojiDictionary = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
    });
    
    reverseEmDic = [[NSDictionary alloc]initWithDictionary:emojiDictionary];
}

- (void)chooseEm:(UIButton *)sender{
    //点击表情
    NSString *emStr = [[NSString alloc]initWithFormat:@"[em_%ld]",(long)sender.tag];
    NSString *lastStr = [NSString stringWithFormat:@"%@",inputTextView.text];
    if ([lastStr isEqualToString:@"(null)"]) {
        lastStr = @"";
    }
    inputTextView.text = [[NSString alloc]initWithFormat:@"%@%@",lastStr,emStr];
}

- (void)btnclicked{
    //点赞
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    if (![self isLogin]) {
        return;
    }
    
    BOOL hasPraise = NO;
    for (id tem in praiseUsers) {
        NSString *str = [NSString stringWithFormat:@"%@",tem];
        if ([str isEqualToString:userinfo.userid]) {
            
            RootHud.mode = MBProgressHUDModeCustomView;
            RootHud.labelText = @"您已经点过赞了";
            RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            [RootHud show:YES];
            [RootHud hide:YES afterDelay:1.0];
            
            hasPraise = YES;
            break;
        }
    }
    
    if (hasPraise) {
        return;
    }
    isZan = YES;
    zanBtn.userInteractionEnabled = NO;
    [AppWebService praiseActivity:userinfo.loginID objectId:_activityID success:^(id result) {
        zanBtn.userInteractionEnabled = YES;
        NSString *status = [NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
        
        isRefresh = YES;
        
        if([status isEqualToString:@"0"])
        {
            [inputTextView resignFirstResponder];
            [self getData];
            NSString *zanStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"praiseCount"]];
            int count = [zanStr intValue];
            if (count == 0)
                return ;
            numOfZan.text = [NSString stringWithFormat:@"赞（%d）",count];
        }
        else
        {
            [self getData];
            NSString *zanStr = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"praiseCount"]];
            int count = [zanStr intValue];
            count++;
            numOfZan.text = [NSString stringWithFormat:@"赞（%d）",count];
        }
        
    } failed:^(NSError *error) {
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        zanBtn.userInteractionEnabled = YES;
    }];
}

- (void)rightBarBtnClicked:(UIBarButtonItem *)sender{
    
    if (sender.tag == 10086) {
        //清空操作
        inputTextView.text = @"";
        
        [UIView animateWithDuration:0.2f animations:^{
            if (inputTextView.isFirstResponder) {
                inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardheight-44, SCREEN_WIDTH, 44);
            }
            else{
                inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - emCollectionView.frame.size.height-44, SCREEN_WIDTH, 44);
            }
            
            inputTextView.frame = CGRectMake(inputTextView.frame.origin.x, inputTextView.frame.origin.y, inputTextView.frame.size.width, 30);
            
//            completeBtn.frame.origin.y = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 30);
        }];
    }
    else
    {
        //分享操作
        NSString *commonUrlStr = [NSString stringWithFormat:@"http://m.yuti.cc/motion/%@",[motionDic objectForKey:@"id"]];
        
        NSString *shareText = [NSString stringWithFormat:@"活动名称：%@；\n活动地点：%@；\n活动时间：%@\n%@\n%@\n（来自喻体iOS客户端）",[motionDic objectForKey:@"name"],[motionDic objectForKey:@"motionPlaceText"],[motionDic objectForKey:@"motionTimeText"],[motionDic objectForKey:@"leftTime"],commonUrlStr];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:umengShareKey
                                          shareText:shareText
                                         shareImage:[UIImage imageNamed:@"icon512"]
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToSms,UMShareToEmail]
                                           delegate:self];
        [self setGotoUrl];
    }
}

- (void)setGotoUrl{
    
    NSString *commonUrlStr = [NSString stringWithFormat:@"http://m.yuti.cc/motion/%@",[motionDic objectForKey:@"id"]];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://m.yuti.cc/wx/entry?url=/motion/%@",[motionDic objectForKey:@"id"]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxc6ed9b57771c1723&redirect_uri=%@&response_type=code&scope=snsapi_base&state=yuti123#wechat_redirect",urlStr];
    
    NSString *shareTitle = [NSString stringWithFormat:@"%@发起了%@活动",[motionDic objectForKey:@"createUserName"],[motionDic objectForKey:@"name"]];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
    
    [UMSocialData defaultData].extConfig.qqData.url = commonUrlStr;
    [UMSocialData defaultData].extConfig.qzoneData.url = commonUrlStr;
    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
}

#pragma mark -自定义代理
- (void)refreshSubScribeView{
    isRefresh = YES;
    [self getData];
}

#pragma mark -友盟分享回调
//友盟实现回调方法（可选）：
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [AppWebService shareDone:[motionDic objectForKey:@"id"] success:^(id result) {
            NSString *share = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"shareCount"]];
            int count = [share intValue];
            count++;
            share = [NSString stringWithFormat:@"%d",count];
            [motionDic setObject:share forKey:@"shareCount"];
            
            NSString *visit = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"visitCount"]];
            if ([visit isEqualToString:@"(null)"]) {
                visit = @"0";
            }
            
            [self initDesView:coreLabel visit:visit share:share];
            
            NSIndexSet *index = [[NSIndexSet alloc]initWithIndex:2];
            
            [activityDetailTable reloadSections:index withRowAnimation:UITableViewRowAnimationFade];
        } failed:^(NSError *error) {
            
        }];
        
        [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"2091897557"}];
        
        
        [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[@"2091897557"] completion:nil];
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)wxShareSuccess{
    //微信单独分享成功后统计
    [AppWebService shareDone:[motionDic objectForKey:@"id"] success:^(id result) {
        NSString *share = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"shareCount"]];
        int count = [share intValue];
        count++;
        share = [NSString stringWithFormat:@"%d",count];
        [motionDic setObject:share forKey:@"shareCount"];
        
        NSString *visit = [NSString stringWithFormat:@"%@",[motionDic objectForKey:@"visitCount"]];
        if ([visit isEqualToString:@"(null)"]) {
            visit = @"0";
        }
        
        [self initDesView:coreLabel visit:visit share:share];
        
        NSIndexSet *index = [[NSIndexSet alloc]initWithIndex:2];
        
        [activityDetailTable reloadSections:index withRowAnimation:UITableViewRowAnimationFade];
    } failed:^(NSError *error) {
        
    }];
}

- (void)getCommentListAfterComment:(BOOL)isAfter{
    
    if (isRefresh) {
        commentArr = [[NSMutableArray alloc]init];
        pages=1;
    }
    
    [AppWebService getActivityComment:[motionDic objectForKey:@"id"] objectType:@"1" page:[NSString stringWithFormat:@"%ld",(long)pages] success:^(id result) {
        
        [activityDetailTable.footer endRefreshing];
        
        if (isAfter) {
            int newRemarkCount = [remarkCount intValue]+1;
            remarkCount = [NSString stringWithFormat:@"%d",newRemarkCount];
            //评论后刷新评论
            if (commentArr.count>0) {
                [commentArr addObjectsFromArray:result];
            }
            else
            {
                commentArr = [NSMutableArray arrayWithArray:result];
            }
            
            if ((commentArr.count-1)<cellIndexPath.row) {
                //还要继续加载评论
                pages++;
                isRefresh = NO;
                
                [self getCommentListAfterComment:YES];
            }
            else{
                //评论已经加载完
                [self calculateCommentHeight];
                [activityDetailTable reloadData];
                [activityDetailTable scrollToRowAtIndexPath:cellIndexPath
                                           atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        else{
            //直接获取评论
            if (commentArr.count>0) {
                [commentArr addObjectsFromArray:result];
            }
            else
            {
                commentArr = [NSMutableArray arrayWithArray:result];
            }
            
            NSArray *temArr = [NSArray arrayWithArray:result];
            
            [RootHud hide:YES];
            
            if (temArr.count <10||(commentArr.count == [[motionDic objectForKey:@"remarkCount"] intValue])) {
                //没有更多评论
                activityDetailTable.footer = [[MJRefreshFooter alloc]init];
            }
            else{
                //还有更多
                activityDetailTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    // 上拉加载
                    if (activityDetailTable.footer.isRefreshing) {
                        
                        [self getCommentListAfterComment:NO];
                    }
                    
                }];
                
            }
            
            pages++;
            
            isRefresh = NO;
            
            [self calculateCommentHeight];
            
            [activityDetailTable reloadData];
            
        }
        
    } failed:^(NSError *error) {
        
        [activityDetailTable.footer endRefreshing];
        activityDetailTable.footer = [[MJRefreshFooter alloc]init];
    }];
    
}

- (void)calculateCommentHeight{
    //计算评论高度
    
    commentHeightArr = [[NSMutableArray alloc]init];
    
    CGFloat finalHeght;
    
    for (int i = 0; i<commentArr.count; i++) {
        CGSize size;
        NSDictionary *temdic = [NSDictionary dictionaryWithDictionary:[commentArr objectAtIndex:i]];
        
        NSLog(@"%@",[temdic objectForKey:@"content"]);
        
        size = [[NSString stringWithFormat:@"%@",[temdic objectForKey:@"content"]] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20-10-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
        
        if(size.height<16.0f)
        {
            size.height = 25;
        }
        else {
            size.height = size.height+10;
        }
        
        finalHeght = size.height;
        
        NSArray *replyArr = [NSArray arrayWithArray:[temdic objectForKey:@"replyList"]];
        if (replyArr.count>0) {
            for (int j = 0; j<replyArr.count; j++) {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[replyArr objectAtIndex:j]];
                NSString *toStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"toUserName"]];
                NSString *string;
                if (toStr.length == 0) {
                    string = [NSString stringWithFormat:@"%@: %@",[dic objectForKey:@"createUserName"],[dic objectForKey:@"content"]];
                }
                else
                {
                    string = [NSString stringWithFormat:@"%@ 回复 %@：%@",[dic objectForKey:@"createUserName"],toStr,[dic objectForKey:@"content"]];
                }
                
                size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20-10-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
                if(size.height<16.0f)
                {
                    size.height = 25;
                }
                else {
                    size.height = size.height+10;
                }
                
                finalHeght = finalHeght +size.height;
            }
            
        }
        
        [commentHeightArr addObject:[NSNumber numberWithFloat:(finalHeght+70)]];
    }
}


- (void)joinClicked{
    //预约
    
    int stateCode;
    stateCode = [headerTitleView getStateCode];
    
    RootHud.mode = MBProgressHUDModeCustomView;
    
    RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    
    if (stateCode == 0 ) {
        //活动结束
        RootHud.labelText = @"活动已结束";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        return;
    }
    else if (stateCode ==1 ){
        //人数已满
        RootHud.labelText = @"没有名额了";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        return;
    }
    else if (stateCode == 2){
        //预约截止
        RootHud.labelText = @"预约已截止";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        return;

    }
    
    if (![self isLogin]) {
        return;
    }
    
    [self showItems];
}

- (void)showItems{
    
    //填写预约信息
    JoinDetailVC *joinDetail = [[JoinDetailVC alloc]init];
    joinDetail.activityID = _activityID;
    joinDetail.delegate = self;
    [self.navigationController pushViewController:joinDetail animated:YES];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [grayView removeFromSuperview];
    
    [self.view endEditing:YES];
    
    [self hideview:emCollectionView height:SCREEN_HEIGHT];
    [self hideview:inputBackView height:SCREEN_HEIGHT];
    activityDetailTable.userInteractionEnabled = YES;
    [inputTextView resignFirstResponder];
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

- (void)writeComment
{
    if (![self isLogin]) {
        return;
    }
    
    [self initInput];
    //写评论
    inputBackView.backgroundColor = [UIColor whiteColor];
    
    inputTextView.font = [UIFont systemFontOfSize:16];
    inputTextView.returnKeyType = UIReturnKeyDone;
    inputTextView.layer.cornerRadius = 5;
    inputTextView.layer.masksToBounds = YES;
    if (inputTextView.text.length<=0) {
        inputTextView.placeholderText = @"我也说一句";
    }
    
    [completeBtn addTarget:self action:@selector(completeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.layer.cornerRadius = 5;
    completeBtn.layer.masksToBounds = YES;
    completeBtn.layer.shouldRasterize = YES;
    completeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    grayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-keyboardheight);
    [self.view addSubview:grayView];
    [self.view addSubview:emCollectionView];
    [self.view addSubview:inputBackView];
    [inputTextView becomeFirstResponder];
    
    activityDetailTable.userInteractionEnabled = NO;
}

- (void)writeCommentToSomeone:(NSDictionary *)sender{
    
//    (NSString *)targetID withToUserID:(NSString *)toID whichCell:(NSIndexPath *)index
    
    if (![self isLogin]) {
        return;
    }
    
    [self initInput];
    
    cellIndexPath = [NSIndexPath indexPathForRow:[[sender objectForKey:@"index"] intValue] inSection:5];
    replyID = [sender objectForKey:@"targetID"];//评论ID
    toUserID = [sender objectForKey:@"toID"];
    if ([toUserID isEqualToString:@"(null)"]) {
        toUserID = nil;
    }
    //写二级评论
    inputBackView.backgroundColor = [UIColor whiteColor];
    
    inputTextView.font = [UIFont systemFontOfSize:16];
    inputTextView.returnKeyType = UIReturnKeyDone;
    inputTextView.layer.cornerRadius = 5;
    inputTextView.layer.masksToBounds = YES;
    if (inputTextView.text.length<=0) {
        NSString *toName = [sender objectForKey:@"toName"];
        if (toName.length>0&&![toName isEqualToString:@"(null)"]) {
            inputTextView.placeholderText = [NSString stringWithFormat:@"回复 %@",toName];
        }
        else
        {
            inputTextView.placeholderText = @"我也说一句";
        }
    }
    
    [completeBtn addTarget:self action:@selector(secondClassComment:) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.layer.cornerRadius = 5;
    completeBtn.layer.masksToBounds = YES;
    completeBtn.layer.shouldRasterize = YES;
    completeBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [inputBackView addSubview:completeBtn];
    
    [self.view addSubview:grayView];
    [self.view addSubview:emCollectionView];
    [self.view addSubview:inputBackView];
    [inputTextView becomeFirstResponder];
    
    activityDetailTable.userInteractionEnabled = NO;
}

- (void)secondClassComment:(UIButton *)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        emCollectionView.frame = CGRectMake(0, SCREEN_HEIGHT, emCollectionView.frame.size.width, emCollectionView.frame.size.height);
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT, inputBackView.frame.size.width, inputBackView.frame.size.height);
    }];
    
    NSLog(@"%@",inputTextView.text);
    
    if (inputTextView.text.length == 0) {
        
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
    
    [grayView removeFromSuperview];
    
    [AppWebService replyToSomeone:toUserID remarkID:replyID content:inputTextView.text success:^(id result) {
        
        NSLog(@"success");
        
        inputTextView.text = @"";
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        
        // Set custom view mode
        RootHud.mode = MBProgressHUDModeCustomView;
        
        RootHud.delegate = self;
        RootHud.labelText = @"发表成功";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        isRefresh = YES;
        pages = 1;
        
        [self getCommentListAfterComment:YES];
        
    } failed:^(NSError *error) {
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
    }];
    
    [inputTextView resignFirstResponder];
    [inputBackView removeFromSuperview];
    
    activityDetailTable.userInteractionEnabled = YES;

}

- (void)completeBtnClicked:(UIButton *)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        emCollectionView.frame = CGRectMake(0, SCREEN_HEIGHT, emCollectionView.frame.size.width, emCollectionView.frame.size.height);
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT, inputBackView.frame.size.width, inputBackView.frame.size.height);
    }];
    
    NSLog(@"%@",inputTextView.text);
    
    if (inputTextView.text.length == 0) {
        
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
    
    [grayView removeFromSuperview];
    
    //发表评论
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    [AppWebService addComment:userinfo.loginID objectID:_activityID objectType:_activityType score:nil content:inputTextView.text success:^(id result) {
        NSLog(@"success");
        
        inputTextView.text = @"";
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        
        // Set custom view mode
        RootHud.mode = MBProgressHUDModeCustomView;
        
        RootHud.delegate = self;
        RootHud.labelText = @"发表成功";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        isRefresh = YES;
        
        [self getCommentListAfterComment:YES];
        
    } failed:^(NSError *error) {
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
    }];
    
    [inputTextView resignFirstResponder];
    [inputBackView removeFromSuperview];
    
    activityDetailTable.userInteractionEnabled = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self initKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxShareSuccess)
                                                 name:WX_SHARE_SUCCESS object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 75;
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    NSString * emStr = [NSString stringWithFormat:@"[em_%ld]",(indexPath.row+1)];
    emStr = [NSString stringWithFormat:@"%@",[reverseEmDic objectForKey:emStr]];
    UIButton *img = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cellHeihgt, cellHeihgt)];
    [img setImage:[UIImage imageNamed:emStr ] forState:UIControlStateNormal];
    img.tag = indexPath.row+1;
    [img addTarget:self action:@selector(chooseEm:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:img];
    cell.backgroundColor = backGroundColor;
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
    return CGSizeMake(cellHeihgt, cellHeihgt);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma maek -headerViewDelegate
- (void)pushViewController:(UIViewController *)controller{
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 5) {
        return commentArr.count;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        int stateCode;
        stateCode = [headerTitleView getStateCode];
        
        UIImageView *stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 90+upsideheight, 90, 80)];
        
        if (stateCode == 0 ) {
            //活动结束
            stateImage.image = [UIImage imageNamed:@"activity_over"];
        }
        else if (stateCode ==1 ){
            //人数已满
            stateImage.image = [UIImage imageNamed:@"subNum_over"];
        }
        else if (stateCode == 2){
            //预约截止
            stateImage.image = [UIImage imageNamed:@"subscribe_over"];
        }
        
        [activityDetailTable addSubview:stateImage];
        
        return headerTitleView;
    }
    else if (section == 1)
    {
        return headerDetailView;
    }
    else if (section == 2)
    {
        //活动说明
        return descriptionView;
    }
    else if (section == 3){
        //点赞人数
        return headerPraiseView;
    }
    else if (section == 4){
        //已预约人数
        return headerSubscribeView;
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 5) {
        
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor =[UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, SCREEN_WIDTH-26, 40)];
        if ([remarkCount isEqualToString:@"(null)"]) {
            remarkCount = @"0";
        }
        titleLabel.text = [NSString stringWithFormat:@"精彩评论（%@）",remarkCount];
        titleLabel.textColor = [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [view addSubview:titleLabel];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10,11, 6, 18)];
        image.layer.cornerRadius = 3;
        image.layer.masksToBounds = YES;
        image.layer.shouldRasterize = YES;
        image.layer.rasterizationScale = [UIScreen mainScreen].scale;
        image.backgroundColor = [UIColor colorWithRed:61/255.0 green:139/255.0 blue:255/255.0 alpha:1.0];
        [view addSubview:image];
        
        UIButton *writeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 40)];
        [writeBtn setTitle:@"写评论" forState:UIControlStateNormal];
        [writeBtn setTitleColor:[UIColor colorWithRed:46/255.0 green:157/255.0 blue:227/255.0 alpha:1.0] forState:UIControlStateNormal];
        writeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [writeBtn addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:writeBtn];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 5) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return headerTitleView.frame.size.height;
    }
    else if (section == 1)
    {
        return headerDetailView.frame.size.height;
    }
    else if (section == 2)
    {
        //活动说明
        return descriptionView.frame.size.height;
    }
    else if (section == 3){
        //已点赞人数
        NSLog(@"%f",headerPraiseView.frame.size.height);
        return headerPraiseView.frame.size.height;
    }
    else if (section == 4){
        //已预约人数
        NSLog(@"%f",headerSubscribeView.frame.size.height);
        return headerSubscribeView.frame.size.height;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"activityNewdetail";
    ActivityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ActivityDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    if (!remarkCount||[remarkCount isEqualToString:@"(null)"]) {
        remarkCount = @"0";
    }
    
    CGFloat cellHeight = [[commentHeightArr objectAtIndex:indexPath.row] floatValue];
    
    if (indexPath.section == 5) {
        cell.parser = yyParser;
        cell.cellIndex = indexPath.row;
        [cell setCellContent:[commentArr objectAtIndex:indexPath.row] withRemarkCount:remarkCount withHeight:cellHeight];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 5) {
        
        CGFloat height;
        
        NSString *heightStr = [commentHeightArr objectAtIndex:(int)(indexPath.row)];
        height = [heightStr floatValue];
        
        return height;
    }
    else
    {
        return 0;
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    CGSize constraintSize;
    
    constraintSize.width = textView.frame.size.width;
    constraintSize.height = 120;
    
    NSString *stringWithEmojiSymbol = textView.text;
    
    NSAttributedString *test = [[NSAttributedString alloc]initWithString:stringWithEmojiSymbol];
    
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 15;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = constraintSize;
    container.linePositionModifier = modifier;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:test];
    
    
    if (layout.textBoundingSize.height<36) {
        inputBackView.frame = CGRectMake(0, inputBackView.frame.origin.y, SCREEN_WIDTH, 50);
        return;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        
        if (inputTextView.isFirstResponder) {
            //键盘弹出
            inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardheight - layout.textBoundingSize.height -4-7, SCREEN_WIDTH, layout.textBoundingSize.height+8+3);
        }
        else{
            if (emCollectionView.frame.origin.y!=SCREEN_HEIGHT) {
                //表情弹出
                inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - emCollectionView.frame.size.height - layout.textBoundingSize.height -4-7, SCREEN_WIDTH, layout.textBoundingSize.height+8+3);
            }
        }
        
        textView.frame = CGRectMake(textView.frame.origin.x, 7, textView.frame.size.width, layout.textBoundingSize.height);
        [textView sizeThatFits:CGSizeMake(textView.bounds.size.width, 5000)];
        
        //        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 30);
        
    }];
    
    if (!inputTextView.isFirstResponder) {
        //如果是表情输入状态，自动滚动到最后一行
        [inputTextView scrollRectToVisible:CGRectMake(0, inputTextView.contentSize.height-15, inputTextView.contentSize.width, 10) animated:YES];
    }
    
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

    [self.browserView hideWithCompletion:^(BOOL finished){
        
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提  示" message:@"预约未获得您的相册权限，请前往设置里面授权" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"设置", nil];
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
        
        [[self browserView] showFromIndex:index];
    }
}

#pragma mark -KeyboardNotification
- (void) keyboardWillShow:(NSNotification *) note
{
    
}

- (void) keyboardDidShow:(NSNotification *) note
{
    emBtn.selected = NO;
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hight_hitht:%f",kbSize.height);
    keyboardheight = kbSize.height;
    
    CGFloat textViewHeight = inputBackView.frame.size.height;
    
    [UIView animateWithDuration:0.5f animations:^{
        
        //输入框弹出
        
        emCollectionView.frame = CGRectMake(0, SCREEN_HEIGHT, emCollectionView.frame.size.width, emCollectionView.frame.size.height);
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardheight - textViewHeight, SCREEN_WIDTH, inputBackView.frame.size.height);
        
        inputTextView.frame = CGRectMake(inputTextView.frame.origin.x, inputTextView.frame.origin.y, inputTextView.frame.size.width, inputTextView.frame.size.height);
        
//        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 30);
        
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
    }];
    
    activityDetailTable.userInteractionEnabled = NO;
}

- (void) keyboardWillHide:(NSNotification *) note
{
    
    activityDetailTable.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, inputBackView.frame.size.height);
        
        if(emCollectionView.frame.origin.y != SCREEN_HEIGHT){
            inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT-emCollectionView.frame.size.height-44, SCREEN_WIDTH, inputBackView.frame.size.height);
            self.navigationItem.rightBarButtonItem = shareBarBtn;
        }
        
        inputTextView.frame = CGRectMake(inputTextView.frame.origin.x, inputTextView.frame.origin.y, inputTextView.frame.size.width, inputTextView.frame.size.height);
        
//        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 30);
        
    }];
    
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
