//
//  StoryVC.m
//  YUYUE
//
//  Created by Sunc on 15/10/26.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "StoryVC.h"
#import "StoryCollectionViewCell.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MBProgressHUD.h"
#import "RxWebViewController.h"

@interface StoryVC ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate>
{
    NSString *pageStr;
    
    UICollectionView *storyCollectionView;
    
    NSMutableArray *storyListArr;
    
    CGFloat cellHeihgt;
    
    UIButton *publishBtn;
    
    RxWebViewController *webController;
}

@end

@implementation StoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = backGroundColor;
    
    storyListArr = [[NSMutableArray alloc]init];
    
    pageStr = @"1";
    
    self.title = @"运动故事";
    
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    
    [self getData];
    
}

- (void)getData{
    
    [AppWebService getStoryList:pageStr success:^(id result) {
        
        [RootHud hide:YES];
        
        if (result == nil) {
            
            return;
        }
        
        if ([pageStr isEqualToString:@"1"]) {
            [storyListArr removeAllObjects];
        }
        
        [storyListArr addObjectsFromArray:result];
        
        [self initStoryCollectionView];
        
        [storyCollectionView reloadData];
        
        [storyCollectionView.header endRefreshing];
        [storyCollectionView.footer endRefreshing];
        
    } failed:^(NSError *error) {
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        [storyCollectionView.header endRefreshing];
        [storyCollectionView.footer endRefreshing];
        
        if ([RootHud.labelText isEqualToString:@"没有更多数据"]) {
            
            CGPoint point = storyCollectionView.contentOffset;
            
            NSLog(@"%f",SCREEN_HEIGHT);
            
            float x = point.x;
            float y = point.y;
            
            [storyCollectionView setContentOffset:CGPointMake(x, y-40) animated:YES];
        }
        
    }];
    
}

- (void)initStoryCollectionView{
    
    CGFloat imgwidth = (SCREEN_WIDTH-15)/2.0;
    CGFloat imgheight = imgwidth*5/7.0;
    CGFloat titleheight = imgwidth*9/35.0;
    CGFloat nameheight =  imgwidth*7/35.0;
    
    cellHeihgt = imgheight+titleheight+nameheight+10;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-15)/2, cellHeihgt);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    if(!storyCollectionView)
    {
        storyCollectionView.alwaysBounceVertical = YES;
        
        storyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-55-10) collectionViewLayout:flowLayout];
        
        storyCollectionView.backgroundColor = [UIColor clearColor];
        storyCollectionView.pagingEnabled = NO;
        storyCollectionView.showsHorizontalScrollIndicator = NO;
        storyCollectionView.showsVerticalScrollIndicator = NO;
        [storyCollectionView registerClass:[StoryCollectionViewCell class] forCellWithReuseIdentifier:@"depresscell"];
        storyCollectionView.delegate = self;
        storyCollectionView.dataSource = self;
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
        headerView.backgroundColor = [UIColor clearColor];
        [storyCollectionView addSubview:headerView];
        
        storyCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            pageStr = @"1";
            
            [self getData];
        }];
        
        storyCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 上拉加载
            pageStr = [NSString stringWithFormat:@"%d",([pageStr intValue]+1)];
            
            [self getData];
        }];
        
        [self.view addSubview:storyCollectionView];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-55, SCREEN_WIDTH, 55)];
        backView.backgroundColor = [UIColor whiteColor];
        
        publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 7.5, SCREEN_WIDTH-30, 40)];
        publishBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:103/255.0 blue:19/255.0 alpha:1.0];
        [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [publishBtn setTitle:@"我也有故事" forState:UIControlStateNormal];
        publishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        publishBtn.hidden = YES;
        [publishBtn addTarget:self action:@selector(publishClicked) forControlEvents:UIControlEventTouchUpInside];
        publishBtn.layer.cornerRadius = 5;
        
        [backView addSubview:publishBtn];
        [self.view addSubview:backView];

    }
}

- (void)publishClicked{
    
}

- (void)viewWillAppear:(BOOL)animated{
    if(storyListArr.count<=0){
        [self getData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
//    [storyCollectionView removeFromSuperview];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return storyListArr.count;
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
    
    StoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    cell.layer.shadowOffset = CGSizeMake(0,0);
    cell.layer.shadowRadius = 5.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.shadowColor = [UIColor redColor].CGColor;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [cell setCellCollectionViewCellDetail:[storyListArr objectAtIndex:indexPath.row]];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={SCREEN_WIDTH,74};
    return size;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-15)/2, cellHeihgt);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[storyListArr objectAtIndex:indexPath.row]];
    
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
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
