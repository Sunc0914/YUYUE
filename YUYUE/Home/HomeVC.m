//
//  HomeVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "HomeVC.h"
#import "SDCycleScrollView.h"
#import "CoachVC.h"
#import "GymVC.h"
#import "CreateActivityVC.h"
#import "UIImageView+WebCache.h"
#import "StoryVC.h"
#import "UIView+Shadow.h"
#import "Masonry.h"
#import "YYLabel.h"
#import "YYTextParser.h"
#import "RxWebViewController.h"

@interface HomeVC ()
{
    UIView *backViewLeft;
    UIView *backViewRight;
    CGFloat height;
    
    NSMutableArray *recommadStoryArr;
    NSMutableArray *AdImageUrlArray;
    UIButton *againRefreshBtn;
    
    UIScrollView *horizonBackview;
    
    UIView *contentView;
    UIButton *moreBtn;
    
    //其他页面
    StoryVC *story;
    RxWebViewController *webController;
    
}

@end

@implementation HomeVC
@synthesize AdImageArray;
@synthesize backScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = backGroundColor;
    
    self.title = @"喻体";
    
    [self initData];
    
    [self updateSportPic];
    
    [self initCycleView];
}

- (void)updateSportPic
{

}

- (void)initData{
    AdImageArray = [[NSMutableArray alloc]initWithObjects:@"http://m.yuti.cc/mobile/images/slide/image1.jpg",@"http://m.yuti.cc/mobile/images/slide/image2.jpg",@"http://m.yuti.cc/mobile/images/slide/image3.jpg",nil];
    AdImageUrlArray = [[NSMutableArray alloc]initWithObjects:@"http://mp.weixin.qq.com/s?__biz=MzAwOTIzNTE2NQ==&mid=400338539&idx=2&sn=5fd495448162c8a16452c2a85184ef04&scene=0#wechat_redirect",@"http://m.yuti.cc/mobile/images/slide/image2.jpg",@"http://m.yuti.cc/mobile/images/slide/image3.jpg",nil];
    
    backViewLeft = [[UIView alloc]init];
    backViewRight = [[UIView alloc]init];
}

- (void)initCycleView{
    
    WS(ws);
//    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    backScrollView = [UIScrollView new];
    [self.view addSubview:backScrollView];
    
    [backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    backScrollView.pagingEnabled = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_WIDTH/640*280) imageURLStringsGroup:AdImageArray];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView new];
    [backScrollView addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upsideheight);
        make.left.right.mas_equalTo(ws.view);
        make.height.mas_equalTo(SCREEN_WIDTH/640*280);
    }];
    
    cycleScrollView.imageURLStringsGroup = AdImageArray;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    
//    UIScrollView *horizonBackview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, cycleScrollView.frame.origin.y+cycleScrollView.frame.size.height+15, SCREEN_WIDTH, 90)];
    horizonBackview = [UIScrollView new];
    [backScrollView addSubview:horizonBackview];
    
    [horizonBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cycleScrollView.mas_bottom).offset(15);
        make.left.right.equalTo(ws.view);
        make.height.mas_equalTo(90);
    }];
    
    horizonBackview.backgroundColor = [UIColor whiteColor];
    horizonBackview.showsHorizontalScrollIndicator = YES;
    horizonBackview.scrollEnabled = NO;
    
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"发起运动", @"参与运动",@"技能平台",@"运动优惠",nil];
    NSArray *imageArray = [[NSArray alloc]initWithObjects:@"iconFabuNor",@"iconHuodongNor",@"iconJinengNor",@"iconQuanNor",nil];
    
    horizonBackview.pagingEnabled = YES;
    
    UILabel *lastLabel= nil;
    UIButton *lastBtn = nil;
    for (int i = 0; i<titleArray.count; i++) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [horizonBackview addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(horizonBackview.mas_top).offset(10);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(horizonBackview).multipliedBy(0.25);
            if (lastLabel) {
                make.left.mas_equalTo(lastBtn.mas_right);
                
            }
            else{
                make.left.mas_equalTo(horizonBackview);
            }
        }];
        
        lastBtn = btn;
        
        btn.tag = i;
        [btn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.frame.size.height/2;
        [btn setTitleColor:[UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = [titleArray objectAtIndex:i];
        titleLabel.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        [horizonBackview addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(btn.mas_bottom).offset(5);
            make.bottom.mas_equalTo(horizonBackview).offset(-5);
            make.width.mas_equalTo(horizonBackview).multipliedBy(0.25);
            
            if (lastLabel) {
                make.left.mas_equalTo(lastLabel.mas_right);
                
            }
            else{
                make.left.mas_equalTo(horizonBackview);
            }
            
        }];
        
        lastLabel = titleLabel;
    }
    
    //精选运动故事
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, horizonBackview.frame.origin.y+horizonBackview.frame.size.height+15, 6, 18)];
    UIImageView *image = [UIImageView new];
    [backScrollView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizonBackview.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(18);
    }];
    image.layer.cornerRadius = 3;
    image.layer.masksToBounds = YES;
    image.backgroundColor = [UIColor colorWithRed:61/255.0 green:139/255.0 blue:255/255.0 alpha:1.0];
//    image.backgroundColor = [UIColor whiteColor];
    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, horizonBackview.frame.origin.y+horizonBackview.frame.size.height+4, 200, 40)];
    UILabel *titleLabel = [UILabel new];
    [backScrollView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizonBackview.mas_bottom).offset(4);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(ws.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    titleLabel.text = @"精选运动故事";
    titleLabel.textColor = [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:13];
    

//    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, horizonBackview.frame.origin.y+horizonBackview.frame.size.height+4, 50, 40)];
    moreBtn = [UIButton new];
    [backScrollView addSubview:moreBtn];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(titleLabel);
        make.width.mas_equalTo(50);
    }];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self getRecommendStory];
}

- (void)getRecommendStory{
    
    WS(ws);
    
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"获取故事...";
    [RootHud show:YES];
    
    [AppWebService getRecommandStory:nil success:^(id result) {
        
        recommadStoryArr = [[NSMutableArray alloc]initWithArray:result];
        
        [RootHud hide:YES];
        
        [self refreshStory];
        
    } failed:^(NSError *error) {
        
//        againRefreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, height+40+10, SCREEN_WIDTH-40, SCREEN_HEIGHT-49-height-40-10)];
        
        againRefreshBtn = [UIButton new];
        [backScrollView addSubview:againRefreshBtn];
        [againRefreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(moreBtn.mas_bottom).offset(10);
            make.bottom.equalTo(ws.view.mas_bottom).offset(-10-49);
            make.left.right.equalTo(horizonBackview);
        }];
        
        [againRefreshBtn addTarget:self action:@selector(againRefreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [againRefreshBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [againRefreshBtn setTitleColor:tipColor forState:UIControlStateNormal];
        
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+5);
    }];
}

- (void)againRefreshBtnClicked{
    [againRefreshBtn removeFromSuperview];
    [self getRecommendStory];
}

- (void)refreshStory{
    
    //推荐故事
    
    CGFloat imgwidth = (SCREEN_WIDTH-30)/2.0;
    CGFloat imgheight = imgwidth*5/7.0;
    CGFloat titleheight = imgwidth*9/35.0;
    CGFloat nameheight =  imgwidth*7/35.0;
    
    for (int i = 0; i<4; i++) {
        
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[recommadStoryArr objectAtIndex:i]];
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10+(10+imgwidth)*(i%2),height+40+10 +(10+imgheight+titleheight+nameheight+5)*(i/2), imgwidth, imgheight+titleheight+nameheight+5)];
        UIView *view = [UIView new];
        [backScrollView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(horizonBackview.mas_bottom).offset(40+10+(10+imgheight+titleheight+nameheight+5)*(i/2));
            make.left.mas_equalTo(10+(10+imgwidth)*(i%2));
            make.width.mas_equalTo(imgwidth);
            make.height.mas_equalTo(imgheight+titleheight+nameheight+5);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        
        [self.view layoutIfNeeded];
        //设置阴影
        view.layer.masksToBounds = NO;
        view.layer.shadowOffset = CGSizeMake(0,0);
        view.layer.shadowRadius = 5.0f;
        view.layer.shadowOpacity = 0.5f;
        view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        
        //故事图片
//        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgwidth, imgheight)];
        UIImageView *img = [UIImageView new];
        [view addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(imgwidth);
            make.height.mas_equalTo(imgheight);
        }];
        NSString *imgStr = [NSString stringWithFormat:@"http://m.yuti.cc%@",[dic objectForKey:@"coverImage"]];
        NSURL *url = [NSURL URLWithString:imgStr];
        [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"storyDefault.png"]];
        
        [self.view layoutIfNeeded];
        
        img.backgroundColor = [UIColor clearColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:img.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, imgwidth, imgheight);
        maskLayer.path = maskPath.CGPath;
        img.layer.mask = maskLayer;

        //故事标题
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, imgheight, imgwidth-5, titleheight)];
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(5);
            make.top.equalTo(view).offset(imgheight);
            make.right.equalTo(view);
            make.height.mas_equalTo(titleheight);
        }];
        titleLabel.textColor = [UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1.0];
        titleLabel.numberOfLines = 2;
        titleLabel.text = [dic objectForKey:@"title"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.backgroundColor = [UIColor whiteColor];
        
        //作者
//        UIImageView *userImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, imgheight+titleheight+6, nameheight-12, nameheight-12)];
        UIImageView *userImg = [UIImageView new];
        [view addSubview:userImg];
        [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.equalTo(titleLabel);
            make.width.mas_equalTo(nameheight);
            make.height.equalTo(userImg.mas_width);
        }];
        userImg.backgroundColor = [UIColor clearColor];
        imgStr = [NSString stringWithFormat:@"http://m.yuti.cc%@",[dic objectForKey:@"createUserPhoto"]];
        url = [NSURL URLWithString:imgStr];
        [userImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"userDefulat.png"]];
        userImg.layer.cornerRadius = nameheight/2.0;
        userImg.clipsToBounds = YES;
        
//        UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+nameheight, imgheight+titleheight, imgwidth-nameheight-10-2, nameheight)];
        UILabel *userNameLabel = [UILabel new];
        [view addSubview:userNameLabel];
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.equalTo(userImg.mas_right).offset(5);
            make.right.equalTo(view).offset(-5);
            make.height.mas_equalTo(nameheight);
        }];
        userNameLabel.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
        userNameLabel.font = [UIFont systemFontOfSize:10];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.textAlignment = NSTextAlignmentLeft;
        userNameLabel.text = [dic objectForKey:@"createUserName"];
        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0 , imgwidth, imgheight+titleheight+nameheight+10)];
        UIButton *btn = [UIButton new];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(storybtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==3) {
            backViewLeft = view;
        }
    }
    
    WS(ws);
    //autolayout重新布局
    [backScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
        make.bottom.equalTo(backViewLeft).offset(49+10);
    }];
    
}

- (void)storybtnClick:(UIButton *)sender{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[recommadStoryArr objectAtIndex:sender.tag]];
    
    if (!webController) {
        webController = [[RxWebViewController alloc]init];
    }
    webController.webType = @"运动故事";
    webController.needLogin = YES;
    webController.idstr = [dic objectForKey:@"id"];
    webController.urlStr = [NSString stringWithFormat:@"http://m.yuti.cc/story/%@",[dic objectForKey:@"id"]];
    webController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webController animated:YES];
    
}

- (void)moreBtnClick{
    
    //故事列表
    if (!story) {
        story = [[StoryVC alloc]init];
    }
    story.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:story animated:YES];
    
}

- (void)btnclicked:(UIButton *)sender{
    //横向btn点击
    if (sender.tag == 0) {
        
        if (![self isLogin]) {
            return;
        }
        
        CreateActivityVC *create = [[CreateActivityVC alloc]init];
        create.hidesBottomBarWhenPushed = YES;
        create.isModelViewController = NO;
        [self.navigationController pushViewController:create animated:YES];
    }
    else if (sender.tag == 1){
        self.tabBarController.selectedIndex = sender.tag;
    }
    else if (sender.tag == 2){
        if (!webController) {
            webController = [[RxWebViewController alloc]init];
        }
        webController = [[RxWebViewController alloc]init];
        webController.webType = @"技能平台";
        webController.needLogin = YES;
        webController.urlStr = @"http://m.yuti.cc/coach/";
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
    else if (sender.tag == 3){
        if (!webController) {
            webController = [[RxWebViewController alloc]init];
        }
        webController.webType = @"运动优惠";
        webController.needLogin = YES;
        webController.urlStr = @"http://m.yuti.cc/venue/";
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];

    }
}


#pragma mark - SDCycleScrollView

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (!webController) {
        webController = [[RxWebViewController alloc]init];
    }
    if (index == 1) {
        webController.webType = @"运动优惠";
        webController.needLogin = NO;
        webController.urlStr = [AdImageUrlArray objectAtIndex:0];
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    story = nil;
    webController = nil;
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
