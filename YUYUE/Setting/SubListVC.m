
//
//  SubListVC.m
//  YUYUE
//
//  Created by Sunc on 15/12/14.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "SubListVC.h"
#import "Masonry.h"
#import "subUserCell.h"
#import "UserInfoVC.h"
#import "ContactSubVC.h"

@interface SubListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)UITableView *subListTable;
@property (nonatomic, retain)NSMutableArray *subUserArr;

@end

@implementation SubListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backGroundColor;
    self.title = @"管理活动";
    
    [self initTable];
    [self getData];
}

- (void)getData{
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    [AppWebService getmyActivitySubsNew:userinfo.loginID withActivityID:_activityID success:^(id result) {
        _subUserArr = [NSMutableArray arrayWithArray:result];
        [_subListTable reloadData];
    } failed:^(NSError *error) {
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
    }];
}

- (void)initTable{
    WS(ws);
    _subListTable = [UITableView new];
    [self.view addSubview:_subListTable];
    [_subListTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
    headerView.backgroundColor = [UIColor whiteColor];
    [_subListTable setTableHeaderView:headerView];
    [_subListTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    _subListTable.delegate =self;
    _subListTable.dataSource = self;
}

//- (void)userImgBtnClicked:(UIButton *)sender{
//    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
//    NSDictionary *temDic = [NSDictionary dictionaryWithDictionary:[_subUserArr objectAtIndex:sender.tag]];
//    userInfoVc.userID = [temDic objectForKey:@"userId"];
//    [self.navigationController pushViewController:userInfoVc animated:YES];
//}

#pragma mark -uitableViewDelegate
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        NSInteger row = [indexPath row];
        [AppWebService deleteSub:userinfo.loginID withActivityID:_activityID andUserID:[_subUserArr objectAtIndex:indexPath.row] success:^(id result) {
            [_subUserArr removeObjectAtIndex:row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failed:^(NSError *error) {
            [_subListTable setEditing:NO];
            RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
            [RootHud show:YES];
            [RootHud hide:YES afterDelay:1];
        }];
    }  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    ContactSubVC *contactSub = [[ContactSubVC alloc]init];
    NSDictionary *temDic = [NSDictionary dictionaryWithDictionary:[_subUserArr objectAtIndex:indexPath.row]];
    contactSub.subInfoDic = temDic;
    [self.navigationController pushViewController:contactSub animated:YES];
}

#pragma mark -uitableDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 30)];
    backView.backgroundColor = backGroundColor;
    titleLab.textColor = tipColor;
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = [NSString stringWithFormat:@"已预约人数（%lu）",(unsigned long)_subUserArr.count];
    titleLab.font = [UIFont systemFontOfSize:12];
    [backView addSubview:titleLab];
    return backView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _subUserArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"subList";
    subUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[subUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;//箭头
        cell.currentVC = self;
    }
    NSDictionary *temDic = [NSDictionary dictionaryWithDictionary:[_subUserArr objectAtIndex:indexPath.row]];
    cell.userID = [temDic objectForKey:@"userId"];
    [cell getCellContent];
//    [cell.userImgBtn addTarget:self action:@selector(userImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    cell.userImgBtn.tag = indexPath.row;
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
