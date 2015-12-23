//
//  SettingVC.m
//  YUYUE
//
//  Created by Sunc on 15/11/18.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "SettingVC.h"
#import "SDImageCache.h"
#import "RxWebViewController.h"
#import "UMSocial.h"
#import "TYImageCache.h"
#import "SDCycleScrollView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "SCKeychain.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    UITableView *settingTable;
    
    NSArray *nameArr;
}

@end

@implementation SettingVC

NSString * const Setting_UserName = @"com.yuyue.app.UserName";
NSString * const Setting_PassWord = @"com.yuyue.app.PassWord";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nameArr = @[@"",@"关于喻体",@"联系我们",@"意见反馈",@"免责声明",@"",@"发表评价",@"授权管理",@"清除缓存"];
    
    self.title = @"设置";
    
    [self initTable];
}

- (void)initTable{
    settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    settingTable.delegate = self;
    settingTable.dataSource = self;
    settingTable.backgroundColor = backGroundColor;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
    headerView.backgroundColor = [UIColor clearColor];
    [settingTable setTableHeaderView:headerView];
    
    [settingTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    settingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:settingTable];
}

- (void)logOutClicked{
    
    if (![self isLogin]) {
        
        return;
    }
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    [AppWebService logout:info.loginID success:^(id result) {
        
        [NSUserDefaults setBool:NO forKey:IS_LOGIN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
        
    } failed:^(NSError *error) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
    }];
}


#pragma mark -uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if([NSUserDefaults boolForKey:IS_LOGIN])
//    {
//        return 10;
//    }
//    else{
//        return 8;
//    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 160;
    }
    else if (indexPath.row == 5)
    {
        return 15;
    }
    else if (indexPath.row == 9)
    {
        return 80;
    }
    else
    {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 50)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:52/255.0 green:56/255.0 blue:67/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        //标志
        UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.617/2, 20, SCREEN_WIDTH*0.383, SCREEN_WIDTH*0.383*134/264)];
        logo.image = [UIImage imageNamed:@"yutiLogo"];
        
        UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, logo.frame.origin.y+logo.frame.size.height+10, 80, 25)];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"ver %@",version];
        versionLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.backgroundColor = backGroundColor;
        [cell.contentView addSubview:logo];
        [cell.contentView addSubview:versionLabel];
    }
    else if (indexPath.row == 5){
        //分割线
        [cell.contentView addSubview:lineView];
    }
    else if (indexPath.row == 9){
        //退出按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH-40, 40)];
        btn.backgroundColor = [UIColor colorWithRed:255/255.0 green:121/255.0 blue:40/255.0 alpha:1.0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(logOutClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    else{
        label.text = [NSString stringWithFormat:@"%@",[nameArr objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:line];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 7) {
            //三方平台
            if ([NSUserDefaults boolForKey:IS_LOGIN]) {
                UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
                UIImageView *loginPlatform = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-60, 5, 40, 40)];
                loginPlatform.layer.masksToBounds = YES;
                loginPlatform.layer.cornerRadius = loginPlatform.bounds.size.height/2.0;
                if ([userInfo.loginPlatform isEqualToString:@"wb"]) {
                    loginPlatform.image = [UIImage imageNamed:@"socialWb1"];
                }
                else if ([userInfo.loginPlatform isEqualToString:@"qq"]){
                    loginPlatform.image = [UIImage imageNamed:@"socialTx1"];
                }
                else if ([userInfo.loginPlatform isEqualToString:@"wx"]){
                    loginPlatform.image = [UIImage imageNamed:@"socialWx1"];
                    
                }
                loginPlatform.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:loginPlatform];
            }
        }
        else if (indexPath.row == 8){
            //清除缓存
            float cache = [[SDImageCache sharedImageCache] getSize];
            cache = cache/1024.0/1024.0;
            UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-100, 0, 80, 50)];
            subLabel.font = [UIFont systemFontOfSize:14];
            subLabel.textColor = tipColor;
            subLabel.textAlignment = NSTextAlignmentRight;
            subLabel.text = [NSString stringWithFormat:@"%.2f M",cache];
            [cell.contentView addSubview:subLabel];
        }
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
    
    if (indexPath.row == 1) {
        //关于喻约
        RxWebViewController *webController = [[RxWebViewController alloc]init];
        webController.urlStr = @"http://m.yuti.cc/about/";
        webController.webType = @"关于喻体";
        webController.needLogin = NO;
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];

    }
    else if (indexPath.row == 2)
    {
        //联系我们
        RxWebViewController *webController = [[RxWebViewController alloc]init];
        webController.urlStr = @"http://m.yuti.cc/about/contact";
        webController.webType = @"联系我们";
        webController.needLogin = NO;
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];

    }
    else if (indexPath.row == 3){
        //意见反馈
        NSString *mailUrl = @"547721810@qq.com";
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:[NSArray arrayWithObjects:mailUrl,nil]];
        
        [self presentViewController:mc animated:YES completion:^{
            
        }];
    }
    else if (indexPath.row == 4){
        //免责声明
        RxWebViewController *webController = [[RxWebViewController alloc]init];
        webController.urlStr = @"http://m.yuti.cc/about/disclaimer";
        webController.webType = @"免责声明";
        webController.needLogin = NO;
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
    else if (indexPath.row == 6)
    {
        //发表评价
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1033089809" ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if (indexPath.row == 7){
        //解除三方授权登录
        UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        
        if ([userInfo.loginPlatform isEqualToString:@"wb"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否解除新浪微博登录授权" delegate:self cancelButtonTitle:@"算了吧" otherButtonTitles:@"解除", nil];
            alert.tag = 1;
            [alert show];
        }
        else if ([userInfo.loginPlatform isEqualToString:@"qq"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否解除QQ登录授权" delegate:self cancelButtonTitle:@"算了吧" otherButtonTitles:@"解除", nil];
            alert.tag = 2;
            [alert show];
        }
        else if ([userInfo.loginPlatform isEqualToString:@"wx"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否解除微信登录授权" delegate:self cancelButtonTitle:@"算了吧" otherButtonTitles:@"解除", nil];
            alert.tag = 3;
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有授权第三方登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            alert.tag = 4;
            [alert show];
        }
    }
    else if (indexPath.row == 8){
        //清除缓存
        SDCycleScrollView *scrollView = [[SDCycleScrollView alloc]init];
        [scrollView clearCache];
        [[SDImageCache sharedImageCache] clearDisk];
        [[TYImageCache cache] clearCache];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
        [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件已保存");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送失败，错误: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -uialertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.labelText = @"解绑成功";
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        
        [NSUserDefaults setBool:NO forKey:IS_LOGIN];
        UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        
        [SCKeychain deleteWithUserNameService:Setting_UserName psaawordService:Setting_PassWord];
        
        if (alertView.tag == 1) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response is %@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [RootHud show:YES];
                    [RootHud hide:YES afterDelay:1];
                    userInfo.loginPlatform = nil;
                    [NSUserDefaults setUserObject:userInfo forKey:USER_STOKRN_KEY];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
                    [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
        }
        else if (alertView.tag == 2){
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response is %@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [RootHud show:YES];
                    [RootHud hide:YES afterDelay:1];
                    userInfo.loginPlatform = nil;
                    [NSUserDefaults setUserObject:userInfo forKey:USER_STOKRN_KEY];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
                    [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
        }
        else if (alertView.tag == 3){
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response is %@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [RootHud show:YES];
                    [RootHud hide:YES afterDelay:1];
                    userInfo.loginPlatform = nil;
                    [NSUserDefaults setUserObject:userInfo forKey:USER_STOKRN_KEY];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
                    [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
        }
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
