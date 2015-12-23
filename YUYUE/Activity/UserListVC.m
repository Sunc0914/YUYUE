//
//  UserListVC.m
//  YUYUE
//
//  Created by Sunc on 15/10/8.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "UserListVC.h"
#import "UserInfoVC.h"
#import "UIImageView+WebCache.h"

@interface UserListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *userListTable;
    
    NSMutableArray *idArr;
    
    NSMutableArray *nameArr;
}

@end

@implementation UserListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"加载中...";
    [RootHud show:YES];
    [RootHud hide:YES afterDelay:0.5];
    
    [self initTable];
    
    [self getData];
    
}

- (void)getData{
    idArr  = [[NSMutableArray alloc]initWithArray:_userIdArr];
    nameArr  = [[NSMutableArray alloc]initWithArray:_userNameArr];
    [userListTable reloadData];
}

- (void)initTable{
    
    self.title = [NSString stringWithFormat:@"%@列表",_userType];
    
    self.view.backgroundColor = backGroundColor;
    
    userListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
//    [userListTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    userListTable.delegate = self;
    userListTable.dataSource = self;
    userListTable.backgroundColor = [UIColor whiteColor];
    
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC);
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
    
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        NSLog(@"Grand Center Dispatch!");
        [self.view addSubview:userListTable];
    });
}

#pragma mark -uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return idArr.count;
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
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 4, 42, 42)];
    img.layer.cornerRadius = img.bounds.size.height/2.0;
    img.layer.masksToBounds = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",[idArr objectAtIndex:indexPath.row]]];
    [img sd_setImageWithURL:url placeholderImage:nil];
    [cell.contentView addSubview:img];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(75, 4, SCREEN_WIDTH-75-15, 42)];
    label.text = [nameArr objectAtIndex:indexPath.row];
    label.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0];
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
    
    UserInfoVC *userInfoVc = [[UserInfoVC alloc]init];
    userInfoVc.userID = [idArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:userInfoVc animated:YES];
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
