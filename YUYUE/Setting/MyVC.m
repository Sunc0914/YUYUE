//
//  MyVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "MyVC.h"
#import "UIImageView+WebCache.h"
#import "RxWebViewController.h"
#import "MyWalletVC.h"
#import "PersonalInfoVC.h"
#import "LoginVC.h"
#import "UIButton+WebCache.h"
#import "SettingVC.h"
#import "MyMotionVC.h"
#import "SCKeychain.h"

@interface MyVC ()
{
    UITableView *setTable;
    
    UILabel *scoreLabel;
    
    UILabel *addScore;
    
    NSString *userLoginId;
    
    BOOL islogin;
    
    UILabel *signLabel;
    
    UIButton *signBtn;
    
    UIButton *levelBtn;
    
    PersonalInfoVC *personalInfo;
}

@end

@implementation MyVC

NSString * const MyVC_UserName = @"com.yuyue.app.UserName";
NSString * const MyVC_PassWord = @"com.yuyue.app.PassWord";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backGroundColor;
    
    signLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    signLabel.layer.masksToBounds = YES;
    signLabel.layer.cornerRadius = 5;
    signLabel.font = [UIFont systemFontOfSize:16];
    signLabel.textColor = [UIColor whiteColor];
    signLabel.backgroundColor = [UIColor blackColor];
    signLabel.alpha = 0;
    signLabel.text = @"+ 5 积分";
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    
    [self initTable];
    
}

- (void)initTable{
    
    setTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    setTable.delegate = self;
    setTable.dataSource = self;
    setTable.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
    headerView.backgroundColor = [UIColor clearColor];
    [setTable setTableHeaderView:headerView];
    
    [setTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:setTable];
}

- (void)btnclicked:(UIButton *)sender{
    //签到
    UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    [AppWebService userSign:userInfo.loginID success:^(id result) {
        NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"score"]];
        int score = [str intValue];
        
        userInfo.isSign = @"1";
        
        [NSUserDefaults setUserObject:userInfo forKey:USER_STOKRN_KEY];
        
        signBtn.frame = CGRectMake(signBtn.frame.origin.x, signBtn.frame.origin.y, 50, 25);
        signBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [signBtn setImage:nil forState:UIControlStateNormal];
        signBtn.layer.borderWidth = 0.5;
        signBtn.layer.cornerRadius = 5;
        signBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        signBtn.layer.borderColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0].CGColor;
        signBtn.clipsToBounds = YES;
        [signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [signBtn setTitleColor:[UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        if (score == 0) {
            //已签
            RootHud.mode = MBProgressHUDModeCustomView;
            RootHud.labelText = @"您今天已经签过了，不要贪多哦！";
            RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            [RootHud show:YES];
            [RootHud hide:YES afterDelay:1.0];
        }
        else{
            //积分
            score = score/1000 +1;
            [levelBtn setTitle:[NSString stringWithFormat:@"V%d",score] forState:UIControlStateNormal];
            signLabel.alpha = 0.8;
            [self.view addSubview:signLabel];
            [UIView animateWithDuration:1.5 animations:^{
                signLabel.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/4.0);
                signLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                signLabel.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
            }];
            
        }
        
    } failed:^(NSError *error) {
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
    }];
}

- (void)presentLoginView{
    LoginVC *login = [[LoginVC alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    login.modelViewType = 1;
    [self.navigationController pushViewControllerAnimatedWithTransition:login];
}


- (void)viewWillAppear:(BOOL)animated{
    [setTable reloadData];
}

- (void)imgBtnClicked{
    if (!personalInfo) {
        personalInfo = [[PersonalInfoVC alloc]init];
    }
    personalInfo.userLoginId = userLoginId;
    personalInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalInfo animated:YES];
}

#pragma mark- uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([NSUserDefaults boolForKey:IS_LOGIN]) {
        return 7;
    }
    else
    {
        return 2;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([NSUserDefaults boolForKey:IS_LOGIN]) {
        if (indexPath.row == 0) {
            //头像
            return 110+15;
        }
        else if (indexPath.row == 1||indexPath.row == 5){
            //分割线
            return 15;
        }
        else{
            //钱包 活动 我的资料 设置
            return 50;
        }

    }
    else{
        
        //没有登录
        if (indexPath.row == 0) {
            //头像
            return 160;
        }
        else if (indexPath.row == 1){
            
            return 50;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    if([NSUserDefaults boolForKey:IS_LOGIN])
    {
        cell = [self CellWhenLogin:tableView cell:cell atIndex:indexPath];
    }
    else{
        cell = [self CellWithoutLogin:tableView cell:cell atIndex:indexPath];
    }
    
    return cell;
    
}

- (UITableViewCell *)CellWhenLogin:(UITableView *)tableView cell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath{
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 50)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:52/255.0 green:56/255.0 blue:67/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    img.backgroundColor = [UIColor clearColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    
    if (indexPath.row == 0) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell.contentView addSubview:line];
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        imgBtn.frame = CGRectMake(10, 15+17, 73, 73);
        imgBtn.layer.cornerRadius = imgBtn.bounds.size.height/2.0;
        [imgBtn addTarget:self action:@selector(imgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        imgBtn.layer.masksToBounds = YES;
        
        if ([userLoginId isEqualToString:userinfo.loginID]) {
            
            //不是重新登录就调用本地图片
            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            
            NSString *loginAccount = [SCKeychain getUserNameWithService:MyVC_UserName];
            //定义记录文件全名以及路径的字符串filePath
            NSString *docImagePath = [documentDirectory stringByAppendingPathComponent:loginAccount];
            
            NSString *imagePath = [docImagePath stringByAppendingPathComponent:@"userImage.png"];
            
            if ([UIImage imageWithContentsOfFile:imagePath]) {
                [imgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
                //                    image.image = [UIImage imageWithContentsOfFile:imagePath];
            }
            else{
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",userinfo.userid]];
                [imgBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userDefulat.png"] options:SDWebImageRefreshCached];
            }
            
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",userinfo.userid]];
            [imgBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userDefulat.png"] options:SDWebImageRefreshCached];
            userLoginId = userinfo.loginID;
        }
        
        [cell.contentView addSubview:imgBtn];
        
        //用户昵称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgBtn.frame.origin.x+imgBtn.frame.size.width+10, 15+17, 150, 20)];
        nameLabel.font = [UIFont systemFontOfSize:17];
        nameLabel.textColor = [UIColor colorWithRed:52/255.0 green:56/255.0 blue:67/255.0 alpha:1.0];
        nameLabel.text = @"";
        if (userinfo.nickname&&![userinfo.nickname isEqualToString:@"(null)"]) {
            nameLabel.text = userinfo.nickname;
        }
        CGSize size = [self maxlabeisize:CGSizeMake(999, 15) fontsize:17 text:nameLabel.text];
        nameLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, size.width, 20);
        //            nameLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:nameLabel];
        
        //签名
        UILabel *introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgBtn.frame.origin.x+imgBtn.frame.size.width+10, 17+26+15, SCREEN_WIDTH-75-35, 15)];
        introduceLabel.font = [UIFont systemFontOfSize:11];
        introduceLabel.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1.0];
        introduceLabel.text = @"你要我写签名，我就不写！";
        if (userinfo.introcution&&![userinfo.introcution isEqualToString:@"(null)"]) {
            introduceLabel.text = userinfo.introcution;
        }
        [cell.contentView addSubview:introduceLabel];
        
        //等级
        levelBtn = [[UIButton alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, nameLabel.frame.origin.y+2, 16, 16)];
        levelBtn.backgroundColor = [UIColor colorWithRed:253/255.0 green:203/255.0 blue:116/255.0 alpha:1.0];
        
        UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        
        [AppWebService getMyScore:userinfo.loginID success:^(id result) {
            
            NSArray *keyArr = [[NSArray alloc]initWithObjects:@"签到",@"完善个人资料",@"被应约活动",@"应约活动",@"发起活动",@"注册", nil];
            int totalScore = 0;
            for (int i = 0; i<keyArr.count; i++) {
                int temScore = [[result objectForKey:[keyArr objectAtIndex:i]]intValue];
                totalScore = totalScore + temScore;
            }
            
            
            userinfo.userscore = [NSString stringWithFormat:@"%d",totalScore];
            [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
            totalScore = totalScore/1000 +1;
            [levelBtn setTitle:[NSString stringWithFormat:@"V%d",totalScore] forState:UIControlStateNormal];
            
        } failed:^(NSError *error) {
            [levelBtn setTitle:[NSString stringWithFormat:@"V%d",[userinfo.userscore intValue]] forState:UIControlStateNormal];
        }];
        [levelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        levelBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        levelBtn.layer.cornerRadius = 5;
        [cell.contentView addSubview:levelBtn];
        
        //签到赚积分
        if ([userinfo.isSign isEqualToString:@"1"]) {
            //已签
            signBtn = [[UIButton alloc]initWithFrame:CGRectMake(imgBtn.frame.origin.x+imgBtn.frame.size.width+10, introduceLabel.frame.origin.y+introduceLabel.frame.size.height+15, 50, 25)];
            signBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            signBtn.layer.borderWidth = 0.5;
            signBtn.layer.cornerRadius = 5;
            signBtn.layer.borderColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0].CGColor;
            signBtn.clipsToBounds = YES;
            [signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [signBtn setTitleColor:[UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            signBtn = [[UIButton alloc]initWithFrame:CGRectMake(imgBtn.frame.origin.x+imgBtn.frame.size.width+10, introduceLabel.frame.origin.y+introduceLabel.frame.size.height+15, 105, 25)];
            [signBtn setImage:[UIImage imageNamed:@"jifen.png"] forState:UIControlStateNormal];
            [signBtn setTitle:@"签到赚积分" forState:UIControlStateNormal];
            [signBtn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
            [signBtn setTitleColor:[UIColor colorWithRed:16/255.0 green:104/255.0 blue:254/255.0 alpha:1.0] forState:UIControlStateNormal];
            signBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            signBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 5);
            signBtn.layer.borderWidth = 0.5;
            signBtn.layer.cornerRadius = 5;
            signBtn.layer.borderColor = [UIColor colorWithRed:16/255.0 green:104/255.0 blue:254/255.0 alpha:1.0].CGColor;
            signBtn.clipsToBounds = YES;
        }
        
        [cell.contentView addSubview:signBtn];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 1){
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];
        
    }
    else if (indexPath.row == 2){
        //我的资料
        img.image = [UIImage imageNamed:@"personUser"];
        [cell.contentView addSubview:img];
        label.text = @"我的资料";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:line];
    }
    else if (indexPath.row == 3){
        //我的钱包
        img.image = [UIImage imageNamed:@"personWallet"];
        [cell.contentView addSubview:img];
        label.text = @"我的钱包";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:line];
    }
    else if(indexPath.row == 4){
        //我的活动
        img.image = [UIImage imageNamed:@"personMotion"];
        [cell.contentView addSubview:img];
        label.text = @"我的活动";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:line];
    }
    else if (indexPath.row == 5){
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
    else if (indexPath.row == 6){
        //设置
        img.image = [UIImage imageNamed:@"personSetting"];
        [cell.contentView addSubview:img];
        label.text = @"设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:line];
    }
//    else if (indexPath.row == 5&& indexPath.section == 2){
//        
//        //退出按钮
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH-40, 40)];
//        btn.backgroundColor = [UIColor colorWithRed:42/255.0 green:154/255.0 blue:231/255.0 alpha:1.0];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
//        btn.layer.cornerRadius = 5;
//        [btn addTarget:self action:@selector(logOutClicked) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn];
//        
//    }
    
    return cell;
}

- (UITableViewCell *)CellWithoutLogin:(UITableView *)tableView cell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 50)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:52/255.0 green:56/255.0 blue:67/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    img.backgroundColor = [UIColor clearColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    
    if (indexPath.row == 0 ) {
        
        //同学们都在这里约运动
        UIButton *userPhotoBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 20, 60, 60)];
        [userPhotoBtn setBackgroundImage:[UIImage imageNamed:@"personOffline"] forState:UIControlStateNormal];
        [userPhotoBtn addTarget:self action:@selector(presentLoginView) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:userPhotoBtn];
        
        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, userPhotoBtn.frame.origin.y+userPhotoBtn.frame.size.height+10, 80, 30)];
        loginBtn.layer.cornerRadius = 15;
        [loginBtn setTitle:@"登录喻体" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor colorWithRed:16/255.0 green:104/255.0 blue:254/255.0 alpha:1.0] forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        loginBtn.layer.borderWidth = 1.0;
        loginBtn.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
        [loginBtn addTarget:self action:@selector(presentLoginView) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:loginBtn];
        
        UILabel *strLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, loginBtn.frame.origin.y+loginBtn.frame.size.height+10, 120, 20)];
        strLabel.text = @"同学们都在这里约运动";
        strLabel.font = [UIFont systemFontOfSize:12];
        strLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:strLabel];
        cell.backgroundColor = [UIColor clearColor];
        
    }
//    else if (indexPath.row == 1){
//        //关于喻约
//        img.image = [UIImage imageNamed:@"personAbout"];
//        [cell.contentView addSubview:img];
//        label.text = @"关于喻约";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell.contentView addSubview:label];
//        [cell.contentView addSubview:line];
//    }
//    else if (indexPath.row == 2){
//        //联系我们
//        img.image = [UIImage imageNamed:@"personMessage"];
//        [cell.contentView addSubview:img];
//        label.text = @"联系我们";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell.contentView addSubview:label];
//        [cell.contentView addSubview:line];
//    }
//    else if (indexPath.row == 3){
//        //免责声明
//        img.image = [UIImage imageNamed:@"personNotice"];
//        [cell.contentView addSubview:img];
//        label.text = @"免责声明";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        [cell.contentView addSubview:label];
//        [cell.contentView addSubview:line];
//    }
    else if(indexPath.row == 1 ){
        
        //设置
        img.image = [UIImage imageNamed:@"personSetting"];
        [cell.contentView addSubview:img];
        label.text = @"设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:line];
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    return cell;
    
}

#pragma mark- uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if ([NSUserDefaults boolForKey:IS_LOGIN]) {
        [self cellSelectedWhenLogin:tableView indexPath:indexPath];
    }
    else
    {
        [self cellSelectedWhenWithoutLogin:tableView indexPath:indexPath];
    }
    
}

- (void)cellSelectedWhenLogin:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
    }
    else if (indexPath.row == 2){
        
        //我的资料
        if (!personalInfo) {
            personalInfo = [[PersonalInfoVC alloc]init];
        }
        personalInfo.userLoginId = userLoginId;
        personalInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalInfo animated:YES];
    }
    else if (indexPath.row == 3){
        //我的钱包
        RxWebViewController *webController = [[RxWebViewController alloc]init];
        webController.webType = @"我的钱包";
        webController.needLogin = YES;
        webController.urlStr = @"http://m.yuti.cc/member/wallet";
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
    else if (indexPath.row == 4){
        //我的活动
//        RxWebViewController *webController = [[RxWebViewController alloc]init];
//        webController.urlStr = @"http://m.yuti.cc/app/h5/member/motion";
//        webController.webType = @"我的活动";
//        webController.needLogin = YES;
//        webController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:webController animated:YES];
        MyMotionVC *myMotion = [[MyMotionVC alloc]init];
        myMotion.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myMotion animated:YES];
    }
    else if (indexPath.row == 6){
        //设置
        SettingVC *setting = [[SettingVC alloc]init];
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
    }
}

- (void)cellSelectedWhenWithoutLogin:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
    }
    else if (indexPath.row == 1){
        //设置
        SettingVC *setting = [[SettingVC alloc]init];
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
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
