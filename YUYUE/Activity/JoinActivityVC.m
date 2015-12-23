//
//  JoinActivityVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/30.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "JoinActivityVC.h"
#import "ActivityCell.h"
#import "DOPDropDownMenu.h"
#import "ActivityDetailNewVC.h"
#import "DropDownListView.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"

@interface JoinActivityVC ()<DropDownChooseDataSource,DropDownChooseDelegate>
{
    NSMutableArray *joinDetailArr;
    
    NSMutableArray *arr1;//地区
    NSMutableArray *arr2;//运动
    NSMutableArray *arr3;//运动类型
    NSMutableArray *arr4;//sort
    
    UITableView *joinTable;
    
    NSMutableArray *chooseArray;
    
    NSString *districtId;
    NSString *schoolId;
    NSString *sportId;
    NSString *motionType;
    NSString *sort;
    NSString *keyword;
    NSString *pageStr;
    
    NSMutableDictionary *totalIdDic;
    
    BOOL getSportIdSuccess;
    
    BOOL getDistrictIdSuccess;
    
    NSMutableDictionary *conditionDic;
    
    BOOL isFirstIn;
}

@end

@implementation JoinActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    self.title = @"活动列表";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAll)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    
    [self initData];
    
    [self getId];
    
    [self initTable];
    
}

- (void)clearAll{
    
    [joinTable removeFromSuperview];
    
    [self initTable];
    
    [joinDetailArr removeAllObjects];
    [conditionDic removeAllObjects];
    
    [self getData];
    
    [self.view addSubview:joinTable];
}

- (void)initData{
    
    arr1 = [[NSMutableArray alloc]init];
    
    arr2 = [[NSMutableArray alloc]init];
    
    joinDetailArr = [[NSMutableArray alloc]init];
    
    arr3 = [[NSMutableArray alloc]initWithObjects:@"全部类型",@"个人活动",@"团队活动", nil];
    
    arr4 = [[NSMutableArray alloc]initWithObjects:@"默认排序",@"发布时间",@"人气最高", nil];
    
    conditionDic = [[NSMutableDictionary alloc]init];
    
    pageStr = @"1";
    
    [conditionDic setObject:pageStr forKey:@"page"];
    
}

- (void)getId{
    
    totalIdDic = [[NSMutableDictionary alloc]init];
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    for (int i = 0; i<arr3.count; i++) {
        [totalIdDic setObject:[NSString stringWithFormat:@"%d",i] forKey:[arr3 objectAtIndex:i]];
    }
    
    for (int j = 0; j<arr4.count; j++) {
        [totalIdDic setObject:[NSString stringWithFormat:@"%d",j] forKey:[arr4 objectAtIndex:j]];
    }
    
    [AppWebService getIdType:nil success:^(id result) {
        getDistrictIdSuccess = YES;
        userinfo.districtArr = [NSArray arrayWithArray:result];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"其他",@"name", nil];
        [result addObject:dic];
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        arr1 = [self processData:result type:@"district"];
        [arr1 insertObject:@"全部地区" atIndex:0];
        
        if (getDistrictIdSuccess&&getSportIdSuccess) {
            chooseArray = [NSMutableArray arrayWithArray:@[arr1,arr2,arr3,arr4]];
            [self initTable];
        }
        
    } failed:^(NSError *error) {
        getDistrictIdSuccess = NO;
    }];
    
    [AppWebService getIdType:@"sportid" success:^(id result) {
        getSportIdSuccess = YES;
        
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        arr2 = [self processData:result type:@"sport"];
        [arr2 insertObject:@"全部项目" atIndex:0];
        
        if (![_joinTypeStr isEqualToString:@"更多"]) {
            
            sportId = [totalIdDic objectForKey:_joinTypeStr];
            
            [conditionDic setObject:sportId forKey:@"sportId"];
            
        }
        
        [self getData];
        
        if (getDistrictIdSuccess&&getSportIdSuccess) {
            chooseArray = [NSMutableArray arrayWithArray:@[arr1,arr2,arr3,arr4]];
            
            [self initTable];
        }
        
    } failed:^(NSError *error) {
        getSportIdSuccess = NO;
    }];
}

- (NSMutableArray *)processData:(NSArray *)sender type:(NSString *)type{
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<sender.count; i++) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[sender objectAtIndex:i]];
        [totalIdDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] forKey:[dic objectForKey:@"name"]];
        [nameArr addObject:[dic objectForKey:@"name"]];
    }
    
    return nameArr;
}

- (void)getData{
    
    [AppWebService getAcitivity:conditionDic success:^(id result) {
        
        if (result == nil) {
            
            return;
        }
        
        if ([pageStr isEqualToString:@"1"]) {
            [joinDetailArr removeAllObjects];
        }
        
        [joinDetailArr addObjectsFromArray:result];
        
        NSArray *temArr = [NSArray arrayWithArray:result];
        
        [RootHud hide:YES];
        
        if (temArr.count <10) {
            joinTable.footer = nil;
        }
        else{
            joinTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                // 上拉加载
                pageStr = [NSString stringWithFormat:@"%d",([pageStr intValue]+1)];
                
                [conditionDic setObject:pageStr forKey:@"page"];
                
                if (joinTable.footer.isRefreshing) {
                    
                    [self getData];
                }
                
            }];

        }
        
        [joinTable reloadData];
        
        [joinTable.header endRefreshing];
        [joinTable.footer endRefreshing];
        
    } failed:^(NSError *error) {
        
        [joinTable.header endRefreshing];
        [joinTable.footer endRefreshing];
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        if ([RootHud.labelText isEqualToString:@"没有更多数据"]&&joinDetailArr.count == 0)
        {
            RootHud.labelText = @"没有符合条件的活动";
            
            [joinTable reloadData];
        }
        
        RootHud.mode = MBProgressHUDModeCustomView;
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        if ([RootHud.labelText isEqualToString:@"没有更多数据"]&&joinDetailArr.count>0) {
            
            CGPoint point = joinTable.contentOffset;
            
            NSLog(@"%f",SCREEN_HEIGHT);
            
            float x = point.x;
            float y = point.y;
            
            [joinTable setContentOffset:CGPointMake(x, y-48) animated:YES];
        }
        
    }];

}

- (void)initTable{
  
    joinTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    joinTable.delegate = self;
    joinTable.dataSource = self;
    [joinTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    joinTable.backgroundColor = backGroundColor;
    
    joinTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 下拉刷新
        pageStr = @"1";
        
        [conditionDic setObject:pageStr forKey:@"page"];
        
        if (joinTable.header.isRefreshing) {
            
           [self getData];
        }
        
    }];
    
    joinTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载
        pageStr = [NSString stringWithFormat:@"%d",([pageStr intValue]+1)];
        
        [conditionDic setObject:pageStr forKey:@"page"];
        
        if (joinTable.footer.isRefreshing) {
            
            [self getData];
        }
        
    }];
    
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,upsideheight, SCREEN_WIDTH, 40) dataSource:self delegate:self];
    dropDownView.mSuperView = joinTable;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, upsideheight+40)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:dropDownView];
    [joinTable setTableHeaderView:headerView];
    
    [self.view addSubview:joinTable];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated{
//    [joinTable removeFromSuperview];
}

#pragma mark -- dropDownListDelegate
- (void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"孙大圣选了section:%ld ,index:%ld",(long)section,(long)index);
    if ([chooseArray[section][index] isEqualToString:@"其他"]||[chooseArray[section][index] isEqualToString:@"全部项目"]) {
        if (section == 0) {
            districtId = @"0";
            [conditionDic setObject:districtId forKey:@"districtId"];
        }
        else
        {
            sportId = @"0";
            [conditionDic setObject:sportId forKey:@"sportId"];
        }
    }
    else
    {
        if (index != 0) {
            if (section == 0) {
                [conditionDic setObject:[totalIdDic objectForKey:chooseArray[section][index]] forKey:@"districtId"];
            }
            else if (section == 1){
                [conditionDic setObject:[totalIdDic objectForKey:chooseArray[section][index]] forKey:@"sportId"];
            }
            else if (section == 2){
                [conditionDic setObject:[totalIdDic objectForKey:chooseArray[section][index]] forKey:@"motionType"];
            }
            else if (section == 3){
                [conditionDic setObject:[totalIdDic objectForKey:chooseArray[section][index]] forKey:@"sort"];
            }
        }
    }
    
    [joinDetailArr removeAllObjects];
    
    [conditionDic setObject:@"1" forKey:@"page"];
    
    [self getData];
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    return @"123";
}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    
    if (![_joinTypeStr isEqualToString:@"更多"]&&!isFirstIn) {
        
        if (section == 1 && index == 0) {
            isFirstIn = YES;
            return _joinTypeStr;
        }
    }
    
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}


#pragma mark- uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return joinDetailArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleStr = [[joinDetailArr objectAtIndex:indexPath.row]objectForKey:@"name"];
    NSString *placeStr = [[joinDetailArr objectAtIndex:indexPath.row]objectForKey:@"motionPlaceText"];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"join";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;//箭头
    }
    
    NSDictionary *cellDataDic = [[NSDictionary alloc]init];
    
    cellDataDic = [joinDetailArr objectAtIndex:indexPath.row];
    
    [cell setCellDetail:cellDataDic];
    
    return cell;
}


#pragma mark- uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    ActivityDetailNewVC *activityDetail = [[ActivityDetailNewVC alloc]init];
    activityDetail.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *cellDataDic = [[NSDictionary alloc]init];
    
    cellDataDic = [joinDetailArr objectAtIndex:indexPath.row];
    activityDetail.activityID = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"id"]];
    activityDetail.activityType = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"motionType"]];
    
    [self.navigationController pushViewController:activityDetail animated:YES];
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
