//
//  ActivityVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ActivityVC.h"
#import "ActivityCell.h"
#import "CreateActivityVC.h"
#import "ActivityDetailVC.h"
#import "ActivityDetailNewVC.h"
#import "JoinActivityVC.h"
#import "MJRefreshNormalHeader.h"
#import "ActivityCollectionViewCell.h"
#import "PublishActivityVC.h"

@interface ActivityVC ()<refreshActivity,UICollectionViewDataSource,UICollectionViewDelegate,UITabBarControllerDelegate>
{
    NSString *joinTypeStr;
    
    NSArray *imageArray;
    
    NSArray *titleArray;
    
    UICollectionView *btnCollectionView;
    
    UIButton *againRefreshBtn;
}

@end

@implementation ActivityVC
@synthesize activityTable;
@synthesize activityScrollview;
@synthesize deadlineActivityArray;
@synthesize specialActivityArray;
@synthesize detailLeftBtn;
@synthesize detailRightBtn;
@synthesize indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.delegate = self;
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    
    [self initCollectionView];
    
    [self initDetailBtn];
    
    [self initRightItem];
    
    [self initScrollview];
    
    [self initData];
    
    [self getData];
    
}

- (void)initCollectionView{
    
    titleArray = [[NSArray alloc]initWithObjects:@"跑步", @"羽毛球",@"游泳",@"骑行",@"乒乓球",@"健身",@"舞蹈",@"更多",nil];
    imageArray = [[NSArray alloc]initWithObjects:@"01paobu",@"02yumaoqiu",@"03youyong",@"04qixing",@"05pingpang",@"06jianshen",@"07wudao",@"15more",nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(40, 40);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    btnCollectionView.alwaysBounceHorizontal = YES;
    btnCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165) collectionViewLayout:flowLayout];
    
    btnCollectionView.backgroundColor = [UIColor whiteColor];
    btnCollectionView.pagingEnabled = YES;
    btnCollectionView.showsHorizontalScrollIndicator = NO;
    btnCollectionView.showsVerticalScrollIndicator = NO;
    [btnCollectionView registerClass:[ActivityCollectionViewCell class] forCellWithReuseIdentifier:@"depresscell"];
    btnCollectionView.delegate = self;
    btnCollectionView.dataSource = self;
}

- (void)initDetailBtn{
    
    detailRightBtn  = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, (SCREEN_WIDTH-30)/2, 40)];
    [detailRightBtn setTitle:@"最新活动" forState:UIControlStateNormal];
    [detailRightBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:152/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
    [detailRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    detailRightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [detailRightBtn addTarget:self action:@selector(detailBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:detailRightBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = detailRightBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    detailRightBtn.layer.mask = maskLayer;
    
    detailRightBtn.selected = YES;
    
    detailLeftBtn  = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, (SCREEN_WIDTH-30)/2, 40)];
    [detailLeftBtn setTitle:@"精华活动" forState:UIControlStateNormal];
    [detailLeftBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:152/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
    [detailLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    detailLeftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [detailLeftBtn addTarget:self action:@selector(detailBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:detailLeftBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = detailLeftBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    
    detailLeftBtn.layer.mask = maskLayer;
    
    
    indicator = [[UIView alloc]initWithFrame:CGRectMake(15, 10, (SCREEN_WIDTH-30)/2, 40)];
    indicator.layer.cornerRadius = 1;
    indicator.layer.masksToBounds = YES;
    indicator.layer.shouldRasterize = YES;
    indicator.layer.rasterizationScale = [UIScreen mainScreen].scale;
    indicator.backgroundColor = [UIColor colorWithRed:41/255.0 green:152/255.0 blue:230/255.0 alpha:1.0];
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:indicator.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = indicator.bounds;
    maskLayer.path = maskPath.CGPath;
    indicator.layer.mask = maskLayer;
    
}

- (void)refreshData{
    
}

- (void)initRightItem{
    UIImage* itemImage= [UIImage imageNamed:@"addNor"]; // Colored Image
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(centerbtnclicked:)];
    right.tag = 10086;
    self.navigationItem.rightBarButtonItem = right;
}

- (void)initData{
    
    specialActivityArray = [[NSMutableArray alloc]init];
    deadlineActivityArray = [[NSMutableArray alloc]init];
    
}

- (void)getData{
    
    [AppWebService getNewAndHotActivitysuccess:^(id result) {
        
        [againRefreshBtn removeFromSuperview];
        specialActivityArray = [NSMutableArray arrayWithArray:[result objectForKey:@"hotMotions"]];
        deadlineActivityArray = [NSMutableArray arrayWithArray:[result objectForKey:@"newMotions"]];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        
        [activityTable.header endRefreshing];
        
        [activityTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        [RootHud hide:YES];
        
        
    } failed:^(NSError *error) {
        
        againRefreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 225, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-225-49)];
        
        [activityTable.header endRefreshing];
        [againRefreshBtn addTarget:self action:@selector(againRefreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [againRefreshBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [againRefreshBtn setTitleColor:tipColor forState:UIControlStateNormal];
        [activityTable addSubview:againRefreshBtn];
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = @"加载失败,下拉重新刷新";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        
    }];
}

- (void)againRefreshBtnClicked{
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    [againRefreshBtn removeFromSuperview];
    [self getData];
}

- (void)initScrollview{
    
    if (!activityTable) {
        activityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
        activityTable.delegate = self;
        activityTable.dataSource = self;
        activityTable.backgroundColor = backGroundColor;
        
        [activityTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
        activityTable.showsVerticalScrollIndicator = YES;
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
        headerView.backgroundColor = [UIColor clearColor];
        [activityTable setTableHeaderView:headerView];
        
        activityTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC);
            dispatch_queue_t currentQueue = dispatch_get_main_queue();
            dispatch_after(time, currentQueue, ^{
                [self getData];
            });
        }];
    }
    
    [activityTable reloadData];
    
}

- (void)btnclicked:(NSInteger )sender{
    //

    joinTypeStr = [titleArray objectAtIndex:sender];

    [self goToJoinActivityVC];
    
}

- (void)goToJoinActivityVC{
    
    JoinActivityVC *join = [[JoinActivityVC alloc]init];
    
    join.joinTypeStr = joinTypeStr;
    
    if ([joinTypeStr isEqualToString:@"more"]) {
        join.joinTypeStr = @"more";
    }
    
    join.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:join animated:YES];
}

- (void)centerbtnclicked:(UIButton *)sender{
    
    if (sender.tag == 10086) {
        if ([self isLogin]) {
//            CreateActivityVC *create = [[CreateActivityVC alloc]init];
//            create.delegate = self;
//            create.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:create animated:YES];
            PublishActivityVC *publish = [[PublishActivityVC alloc]init];
            [self.navigationController pushViewController:publish animated:YES];
        }
    }
    else{
        JoinActivityVC *join = [[JoinActivityVC alloc]init];
        join.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:join animated:YES];
    }
    
}

- (void)detailBtnclicked:(UIButton *)sender{
    
    if (sender == detailRightBtn) {
        //点击右边btn
        detailRightBtn.selected = YES;
        detailLeftBtn.selected = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:detailLeftBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = detailLeftBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            indicator.layer.mask = maskLayer;
            indicator.frame = CGRectMake(15, 10, (SCREEN_WIDTH-30)/2, 40);
        }];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        
        [activityTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    else{
        //点击左边btn
        detailLeftBtn.selected = YES;
        detailRightBtn.selected = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:detailRightBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = detailRightBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            indicator.layer.mask = maskLayer;
            indicator.frame = CGRectMake(SCREEN_WIDTH/2, 10, (SCREEN_WIDTH-30)/2, 40);
        }];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        
        [activityTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view addSubview:activityTable];
}

- (void)viewDidAppear:(BOOL)animated{
    [RootHud hide:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [activityTable removeFromSuperview];
}

#pragma mark uitabbarcontroller
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSString *classStr =tabBarController.selectedViewController.tabBarItem.title;
    if ([classStr isEqualToString:@"活动"]) {
        if (!activityTable.header.isRefreshing) {
            [activityTable.header beginRefreshing];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC);
            dispatch_queue_t currentQueue = dispatch_get_main_queue();
            dispatch_after(time, currentQueue, ^{
                [self getData];
            });
        }
        return YES;
    }
    return YES;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
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
    ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.imgView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    
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
    return CGSizeMake(SCREEN_WIDTH/4.0, 80);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2.5, 0, 0, 0);
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
    [self btnclicked:indexPath.row];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - uitableviewdelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.section==3) {
        
        ActivityDetailNewVC *activityDetail = [[ActivityDetailNewVC alloc]init];
        activityDetail.hidesBottomBarWhenPushed = YES;
        
        NSDictionary *cellDataDic = [[NSDictionary alloc]init];
        
        if (detailLeftBtn.selected) {
            cellDataDic = [specialActivityArray objectAtIndex:indexPath.row];
            activityDetail.activityID = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"id"]];
            activityDetail.activityType = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"motionType"]];
        }
        else
        {
            cellDataDic = [deadlineActivityArray objectAtIndex:indexPath.row];
            activityDetail.activityID = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"id"]];
            activityDetail.activityType = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"motionType"]];
        }
        
        [self.navigationController pushViewController:activityDetail animated:YES];
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 165;
    }
    else if (section == 1){
        return 60;
    }
    else if (section == 2){
        return 0;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        
        if (detailLeftBtn.selected) {
            
            NSString *titleStr = [[specialActivityArray objectAtIndex:indexPath.row]objectForKey:@"name"];
            NSString *placeStr = [[specialActivityArray objectAtIndex:indexPath.row]objectForKey:@"motionPlaceText"];
            CGSize size1 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-95-10, 999) fontsize:12 text:placeStr];
            CGSize size2 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-70, 999) fontsize:14 text:[NSString stringWithFormat:@"         %@",titleStr]];
            
            if (size1.height<=17) {
                size1.height = 17;
            }
            else
            {
                size1.height = size1.height;
            }
            
            if (size2.height<=15) {
                size2.height = 15;
            }
            else
            {
                size2.height = size2.height;
            }
            
            return 60+size1.height+size2.height;
        }
        else
        {
            NSString *titleStr = [[deadlineActivityArray objectAtIndex:indexPath.row]objectForKey:@"name"];
            NSString *placeStr = [[deadlineActivityArray objectAtIndex:indexPath.row]objectForKey:@"motionPlaceText"];
            CGSize size1 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-95-10, 999) fontsize:12 text:placeStr];
            CGSize size2 = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-70, 999) fontsize:14 text:[NSString stringWithFormat:@"         %@",titleStr]];
            
            if (size1.height<=17) {
                size1.height = 17;
            }
            else
            {
                size1.height = size1.height;
            }
            
            if (size2.height<=15) {
                size2.height = 15;
            }
            else{
                size2.height = size2.height;
            }
            
            return 60+size1.height+size2.height;
        }
        
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        //第一个c展示活动
        
        if (!btnCollectionView) {
            [self initCollectionView];
        }
        
        return btnCollectionView;
        
    }
    else if (section == 1){
        
        //第二个最新活动  精华活动
        
        UIView *headerview = [[UIView alloc]init];
        headerview.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 40)];
        backView.layer.cornerRadius = 5.0;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        
        [headerview addSubview:backView];
        
        [headerview addSubview:indicator];
        
        [headerview addSubview:detailLeftBtn];
        
        [headerview addSubview:detailRightBtn];
        
        return headerview;
    }
    else if (section == 2){
        
        return nil;
        
    }
    else
    {
        return nil;
    }
    
}


#pragma mark - uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    else if (section == 1){
        return 0;
    }
    else if (section == 2){
        return 0;
    }
    else if (section == 3){
        if (detailLeftBtn.selected) {
            return specialActivityArray.count;
        }
        else
        {
            return deadlineActivityArray.count;
        }
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"activity";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;//箭头
    }
    
    if (indexPath.section==3) {
        NSDictionary *cellDataDic = [[NSDictionary alloc]init];
        
        if (detailLeftBtn.selected) {
            cellDataDic = [specialActivityArray objectAtIndex:indexPath.row];
        }
        else
        {
            cellDataDic = [deadlineActivityArray objectAtIndex:indexPath.row];
        }
        
        [cell setCellDetail:cellDataDic];
        return cell;
    }
    else
    {
        return nil;
    }
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
