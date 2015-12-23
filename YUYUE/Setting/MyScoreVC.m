//
//  MyScoreVC.m
//  YUYUE
//
//  Created by Sunc on 15/10/27.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "MyScoreVC.h"

@interface MyScoreVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *userListTable;
    
    NSMutableDictionary *dic;
    
    NSArray *arr;
    
    NSArray *keyArr;
    
}

@end

@implementation MyScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dic = [[NSMutableDictionary alloc]init];
    
    arr = [[NSArray alloc]initWithObjects:@"签到积分",@"完善个人资料",@"活动被应约积分",@"应约活动积分",@"发起活动积分",@"注册积分", nil];
    
    keyArr = [[NSArray alloc]initWithObjects:@"签到",@"完善个人资料",@"被应约活动",@"应约活动",@"发起活动",@"注册", nil];
    
    [self initTable];
    
    [self getData];
    
}

- (void)getData{
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    [AppWebService getMyScore:userinfo.loginID success:^(id result) {
        
        dic = [NSMutableDictionary dictionaryWithDictionary:result];
        
        [userListTable reloadData];
        
    } failed:^(NSError *error) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
    }];
    
    [userListTable reloadData];
}

- (void)initTable{
    
    self.title = @"我的积分";
    
    self.view.backgroundColor = backGroundColor;
    
    userListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    //    [userListTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    userListTable.delegate = self;
    userListTable.dataSource = self;
    userListTable.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:userListTable];
}

#pragma mark -uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"userlist";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 4, SCREEN_WIDTH-30-100, 42)];
    NSString *str1 = [NSString stringWithFormat:@"%@",[arr objectAtIndex:indexPath.row]];
    if ([str1 isEqualToString:@"(null)"]) {
        str1 = @"0";
    }
    label1.text = str1;
    label1.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
    label1.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:label1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-100, 4, 100, 42)];
    NSString *str = [NSString stringWithFormat:@"%@",[ dic objectForKey:[keyArr objectAtIndex:indexPath.row]]];
    if ([str isEqualToString:@"(null)"]) {
        str = @"0";
    }
    label.text = str;
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark -uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
