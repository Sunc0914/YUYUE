//
//  MyWalletVC.m
//  YUYUE
//
//  Created by Sunc on 15/10/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "MyWalletVC.h"
#import "RxWebViewController.h"
#import "MyScoreVC.h"

@interface MyWalletVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *walletTable;
}

@end

@implementation MyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的钱包";
    
    [self initTable];
}

- (void)initTable{
    
    walletTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    walletTable.delegate = self;
    walletTable.dataSource = self;
    [walletTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [self.view addSubview:walletTable];
}

#pragma mark -uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    static NSString *CellIdentifier = @"wallet";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 150, 46)];
    label.font = [UIFont systemFontOfSize:13];
    [cell addSubview:label];
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95, 2, 60, 46)];
    scoreLabel.textColor = [UIColor orangeColor];
    scoreLabel.font = [UIFont systemFontOfSize:12];
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.text = @"";
    [cell addSubview:scoreLabel];
    
    if (indexPath.row == 0) {
        label.text = @"我的积分";
        scoreLabel.text = userinfo.userscore;
    }
    else if (indexPath.row == 1){
        label.text = @"我的优惠";
    }
    else if (indexPath.row == 2){
        label.text = @"怎样获取积分";
    }
    else if (indexPath.row == 3){
        label.text = @"积分兑换说明";
    }
    
    return cell;
}

#pragma mark -uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.row == 0) {
        
        MyScoreVC *myscore = [[MyScoreVC alloc]init];
        myscore.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myscore animated:YES];

    }
    else if (indexPath.row == 1){

    }
    else if (indexPath.row == 2){
        RxWebViewController *webController = [[RxWebViewController alloc]init];
        webController.needLogin = NO;
        webController.urlStr = @"http://m.yuti.cc/about/score/how";
        webController.webType = @"怎样获取积分";
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
    else if (indexPath.row == 3){
        RxWebViewController *webController = [[RxWebViewController alloc]init];
        webController.urlStr = @"http://m.yuti.cc/about/score/exchange";
        webController.webType = @"积分兑换说明";
        webController.needLogin = NO;
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
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
