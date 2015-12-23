//
//  MyMotionVC.m
//  YUYUE
//
//  Created by Sunc on 15/12/14.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "MyMotionVC.h"
#import "Masonry.h"
#import "ActivityCell.h"
#import "ActivityDetailNewVC.h"
#import "SubListVC.h"

@interface MyMotionVC ()<UITableViewDataSource,UITableViewDelegate,jumpToSubs>

@property (nonatomic, retain)UITableView *myMotionTable;
@property (nonatomic, retain)NSArray *mySubActiviyArr;
@property (nonatomic, retain)NSArray *myActivityArr;

@end

@implementation MyMotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backGroundColor;
    self.title = @"我的活动";
    [self initTable];
    [self getData];
}

- (void)initTable{
    WS(ws);
    _myMotionTable = [UITableView new];
    [self.view addSubview:_myMotionTable];
    [_myMotionTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
    headerView.backgroundColor = [UIColor whiteColor];
    [_myMotionTable setTableHeaderView:headerView];
    [_myMotionTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    _myMotionTable.delegate =self;
    _myMotionTable.dataSource = self;
}

- (void)getData{
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    [AppWebService getMyActivity:userinfo.loginID success:^(id result) {
        _myActivityArr = [result objectForKey:@"publishMotions"];
        _mySubActiviyArr = [result objectForKey:@"subscribeMotions"];
        [_myMotionTable reloadData];
        [RootHud hide:YES];
    } failed:^(NSError *error) {
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
    }];
}

#pragma mark -jumpDelegate
- (void)jumpToCheckSubs:(NSString *)motionID{
    SubListVC *subList = [[SubListVC alloc]init];
    subList.activityID = motionID;
    [self.navigationController pushViewController:subList animated:YES];
}

#pragma mark -tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    ActivityDetailNewVC *activityDetail = [[ActivityDetailNewVC alloc]init];
    activityDetail.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *cellDataDic = [[NSDictionary alloc]init];
    
    if (indexPath.section == 0) {
        cellDataDic = [_myActivityArr objectAtIndex:indexPath.row];
        activityDetail.activityID = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"id"]];
        activityDetail.activityType = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"motionType"]];
    }
    else
    {
        cellDataDic = [_mySubActiviyArr objectAtIndex:indexPath.row];
        activityDetail.activityID = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"id"]];
        activityDetail.activityType = [NSString stringWithFormat:@"%@",[cellDataDic objectForKey:@"motionType"]];
    }
    [self.navigationController pushViewController:activityDetail animated:YES];
}

#pragma mark -tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _myActivityArr.count;
    }
    else if (section == 1){
        return _mySubActiviyArr.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *titleStr = [[_myActivityArr objectAtIndex:indexPath.row]objectForKey:@"name"];
        NSString *placeStr = [[_myActivityArr objectAtIndex:indexPath.row]objectForKey:@"motionPlaceText"];
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
        NSString *titleStr = [[_mySubActiviyArr objectAtIndex:indexPath.row]objectForKey:@"name"];
        NSString *placeStr = [[_mySubActiviyArr objectAtIndex:indexPath.row]objectForKey:@"motionPlaceText"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    backView.backgroundColor = backGroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = tipColor;
    label.adjustsFontSizeToFitWidth = YES;
    if (section == 0) {
        label.text = @"我发起的活动";
    }
    else{
        label.text = @"我参与的活动";
    }
    [backView addSubview:label];
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"activity";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;//箭头
    }
    
    cell.delegate = self;
    
    NSDictionary *cellDataDic = [[NSDictionary alloc]init];
    
    if (indexPath.section == 0) {
        cell.isMyActivity = YES;
        cell.belongsToMe = YES;
        cellDataDic = [_myActivityArr objectAtIndex:indexPath.row];
    }
    else
    {
        cell.isMyActivity = YES;
        cell.belongsToMe = NO;
        cellDataDic = [_mySubActiviyArr objectAtIndex:indexPath.row];
    }
    
    [cell setCellDetail:cellDataDic];
    return cell;

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
