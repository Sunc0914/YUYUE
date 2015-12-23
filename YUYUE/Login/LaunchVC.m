//
//  LaunchVC.m
//  YUYUE
//
//  Created by Sunc on 15/11/13.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "LaunchVC.h"
#import "LoginVC.h"
#import "MainTabBarViewController.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "SCKeychain.h"

@interface LaunchVC ()
{
    UIImageView *launchView;
    UIImageView *logoView;
    UIView *backView;
    
    UIButton *goToLoginBtn;
    UIButton *goToVisitorBtn;
    
    NSMutableArray *btnArr;
    
    NSString *platForm;
    
}

@end

@implementation LaunchVC

NSString * const KEY_RefreshToken = @"com.yuyue.app.refresh_token";
NSString * const KEY_AccessToken = @"com.yuyue.app.access_token";
NSString * const KEY_OpenID = @"com.yuyue.app.OpenID";
NSString * const KEY_UserName = @"com.yuyue.app.UserName";
NSString * const KEY_PassWord = @"com.yuyue.app.PassWord";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initLaunchImage];
    
    [self registerNotification];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)registerNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginFailed)
                                                 name:LOGIN_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(thirdPlatformClicked:)
                                                 name:THIRD_PLATFROM object:nil];
}

- (void)loginFailed{
    //注意这里传的是登录状态
    [self showGoToLoginBtn:YES];
}

- (void)initLaunchImage{
    
    btnArr = [[NSMutableArray alloc]init];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor clearColor];
    
    launchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    launchView.image = [UIImage imageNamed:@"yutiL"];
    
    logoView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT*3/4, SCREEN_WIDTH*0.383, SCREEN_WIDTH*0.383*134/264)];
    logoView.image = [UIImage imageNamed:@"yutiLogo"];
    
    goToLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT-80, SCREEN_WIDTH/2, 20)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"去登录"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [goToLoginBtn setAttributedTitle:str forState:UIControlStateNormal];
    [goToLoginBtn setTitleColor:[UIColor colorWithRed:52/255.02 green:48/255.0 blue:49/255.0 alpha:1.0] forState:UIControlStateNormal];
    goToLoginBtn.backgroundColor = [UIColor clearColor];
    [goToLoginBtn addTarget:self action:@selector(goToLoginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    goToLoginBtn.hidden = YES;
    goToLoginBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [launchView addSubview:goToLoginBtn];
    
    goToVisitorBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/8, SCREEN_HEIGHT-40, SCREEN_WIDTH/4, 20)];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"先随便看看"];
    NSRange strRange1 = {0,[str1 length]};
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [goToVisitorBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    [goToVisitorBtn setTitleColor:[UIColor colorWithRed:52/255.02 green:48/255.0 blue:49/255.0 alpha:1.0] forState:UIControlStateNormal];
    goToVisitorBtn.backgroundColor = [UIColor clearColor];
    [goToVisitorBtn addTarget:self action:@selector(goToVisitorBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    goToVisitorBtn.hidden = YES;
    goToVisitorBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [launchView addSubview:goToVisitorBtn];
    
    CGFloat btnWidth = 60;
    CGFloat width = (SCREEN_WIDTH-btnWidth*3)/6.0;
    
    NSArray *socialImageArr = @[@"socialWb1",@"socialWx1",@"socialTx1"];
    
    for (int i = 0; i<3; i++) {
        UIButton *thirdPlatformLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+(btnWidth+width*2)*i, logoView.frame.origin.y+logoView.frame.size.height+20, btnWidth, btnWidth)];
        thirdPlatformLoginBtn.layer.cornerRadius = thirdPlatformLoginBtn.bounds.size.height/2.0;
        thirdPlatformLoginBtn.layer.masksToBounds = YES;
        thirdPlatformLoginBtn.tag = i;
        [thirdPlatformLoginBtn addTarget:self action:@selector(thirdPlatformLoginaunchViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        thirdPlatformLoginBtn.backgroundColor = [UIColor clearColor];
        [thirdPlatformLoginBtn setBackgroundImage:[UIImage imageNamed:[socialImageArr objectAtIndex:i]] forState:UIControlStateNormal];
        thirdPlatformLoginBtn.hidden = YES;
        [backView addSubview:thirdPlatformLoginBtn];
        [btnArr addObject:thirdPlatformLoginBtn];
    }
    
    [backView addSubview:logoView];
    launchView.userInteractionEnabled = YES;
    [launchView addSubview:backView];
    
    [self.view addSubview:launchView];
    
    [self showGoToLoginBtn:_isLoginSuccess];
}

- (void)showGoToLoginBtn:(BOOL)isSuccess{
    
    if (isSuccess) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            backView.frame = CGRectMake(0, -SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT);
            for (UIButton *btn in btnArr) {
                if (btn.tag == 1) {
                    if([WXApi isWXAppInstalled]){
                        btn.hidden = NO;
                    }
                }
                else
                {
                    btn.hidden = NO;
                }
            }
        } completion:^(BOOL finished) {
            goToLoginBtn.hidden = NO;
            goToVisitorBtn.hidden = NO;
        }];
    }
    
}

- (void)thirdPlatformClicked:(NSNotification *)sender{
    //通知调用的方法
    NSString *tag = [sender.userInfo objectForKey:@"tag"];
    [self chooseLoginWay:[tag integerValue]];
}

- (void)thirdPlatformLoginaunchViewClicked:(UIButton *)sender{
    
    [self chooseLoginWay:sender.tag];
}

- (void)chooseLoginWay:(NSInteger)tag{
    
    RootHud.mode = MBProgressHUDModeIndeterminate;
    RootHud.labelText = @"登录中...";
    [RootHud show:YES];
    [RootHud hide:YES afterDelay:3.0];
    switch (tag) {
        case 0:
            [self wbLogin];
            break;
        case 1:
            [self wxLogin];
            break;
        case 2:
            [self qqLogin];
            break;
            
        default:
            break;
    }
}

- (void)wbLogin{
    
    //直接获取用户信息
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        
        NSLog(@"SnsInformation is %@",response.data);
        if(response.responseCode == UMSResponseCodeSuccess){
            //获取成功
            
            //处理数据
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:response.data];
            
            NSDictionary *infoDic = @{@"type":@"wb",@"openID":[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]],@"nickName":[dic objectForKey:@"screen_name"],@"gender":[NSString stringWithFormat:@"%@",[dic objectForKey:@"gender"]],@"photo":[dic objectForKey:@"profile_image_url"]};
            platForm = @"wb";
            [self thirdLogin:infoDic];
            
        }
        else{
            //获取失败，开始申请授权
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    //授权成功，重新获取用户信息
                    [self wbLogin];
                    
                }
                else{
                    //授权失败
                    [self goToLoginBtnClicked];
                }
            });
            
            if (response.responseCode != UMSResponseCodeSuccess)
            {
                if (!RootHud.isHidden) {
                    [RootHud hide:YES];
                }
            }
            
        }
    }];
    
}

#pragma mark 微信一大坨
- (void)setWxLoginCode:(BaseResp *)sender{
    //wx回调
    
    RootHud.mode = MBProgressHUDModeCustomView;
    RootHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
    if (sender.errCode == 0)
    {
        NSLog(@"用户同意");
        SendAuthResp *aresp = (SendAuthResp *)sender;
        [self getAccessTokenWithCode:aresp.code];
        
    }else if (sender.errCode == -4){
        NSLog(@"用户拒绝");
        RootHud.labelText = @"用户拒绝";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
    }else if (sender.errCode == -2){
        NSLog(@"用户取消");
        RootHud.labelText = @"用户取消";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
    }
}

- (void)getAccessTokenWithCode:(NSString *)code{
    //获取accessToken
    [AppWebService getAccessToken:code success:^(id result) {
        
        //self save refreshToken
        
        [self saveRefresh_token:[result objectForKey:@"refresh_token"] withAccess_token:[result objectForKey:@"access_token"] withOpenid:[result objectForKey:@"openid"]];
        [self getWxUserInfo:[result objectForKey:@"openid"] withAccess_token:[result objectForKey:@"access_token"]];
        
    } failed:^(NSError *error) {
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
        RootHud.labelText = @"access_token获取失败";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
    }];
}

- (void)saveRefresh_token:(NSString *)refresh_token withAccess_token:(NSString *)access_token withOpenid:(NSString *)openid{
    
    //save refreshToken and access token
    //username就是refresh_token  password 就是access_token
    [SCKeychain saveUserName:refresh_token userNameService:KEY_RefreshToken psaaword:access_token psaawordService:KEY_AccessToken];
    [SCKeychain saveUserInfo:openid userInfoService:KEY_OpenID];
}

- (void)getWxUserInfo:(NSString *)openid withAccess_token:(NSString *)access_token{
    //获取微信用户信息，uionid
    [AppWebService getUionID:openid withToken:access_token success:^(id result) {
        
        NSDictionary *infoDic = @{@"type":@"wx",@"openID":[result objectForKey:@"unionid"],@"nickName":[result objectForKey:@"nickname"],@"gender":[NSString stringWithFormat:@"%@",[result objectForKey:@"sex"]],@"photo":[result objectForKey:@"headimgurl"]};
        
        platForm = @"wx";
        [self thirdLogin:infoDic];
        
    } failed:^(NSError *error) {
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
        RootHud.labelText = @"用户信息获取失败";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        
    }];
}

- (void)checkAccessToken:(NSString *)access_token withOpenID:(NSString *)openid
{
    //检查access_token是否有效
    [AppWebService checkaccess_token:access_token withOpenId:openid success:^(id result) {
        //有效,直接获取信息
        NSString *access_token = [SCKeychain getPasswordWithService:KEY_AccessToken];
        NSString *openid = [SCKeychain getUserNameWithService:KEY_OpenID];
        [self getWxUserInfo:openid withAccess_token:access_token];
        
    } failed:^(NSError *error) {
        //无效,刷新access_token
        NSString *refresh_token = [SCKeychain getUserNameWithService:KEY_RefreshToken];
        [self refreshAccess_token:refresh_token];
    }];
}

- (void)refreshAccess_token:(NSString *)refresh_token{
    
    //刷新access_token
    [AppWebService refresh_token:refresh_token success:^(id result) {
        [SCKeychain saveUserInfo:[result objectForKey:@"openid"] userInfoService:KEY_OpenID];
        [self getWxUserInfo:[result objectForKey:@"openid"] withAccess_token:[result objectForKey:@"access_token"]];
    } failed:^(NSError *error) {
        //调用授权
        [self reqestAuth];
    }];
}

- (void)reqestAuth{
    
    if (![WXApi isWXAppInstalled]) {
        //判断是否有微信
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"还没有安装微信哦，可以尝试其他登陆方式" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [RootHud hide:YES];
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"cc.yuti.www";
    [WXApi sendReq:req];
}

- (void)wxLogin{
    
    NSString *access_token = [SCKeychain getPasswordWithService:KEY_AccessToken];
    NSString *openid = [SCKeychain getUserNameWithService:KEY_OpenID];
    
    [self checkAccessToken:access_token withOpenID:openid];
    
}

- (void)qqLogin{
    
    //直接获取用户信息
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        
        NSLog(@"SnsInformation is %@",response.data);
        if(response.responseCode == UMSResponseCodeSuccess){
            //获取成功
            
            //处理数据
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:response.data];
            
            NSDictionary *infoDic = @{@"type":@"qq",@"openID":[NSString stringWithFormat:@"%@",[dic objectForKey:@"openid"]],@"nickName":[dic objectForKey:@"screen_name"],@"gender":[NSString stringWithFormat:@"%@",[dic objectForKey:@"gender"]],@"photo":[dic objectForKey:@"profile_image_url"]};
            platForm = @"qq";
            [self thirdLogin:infoDic];
        }
        else{
            //获取失败，开始申请授权
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    //授权成功，重新获取用户信息
                    [self qqLogin];
                    
                }
                else{
                    //授权失败
                    [self goToLoginBtnClicked];
                }
            });
            
            if (response.responseCode != UMSResponseCodeSuccess)
            {
                if (!RootHud.isHidden) {
                    [RootHud hide:YES];
                }
            }
        }
    }];
}

- (void)thirdLogin:(NSDictionary *)sender{
    
    [AppWebService thirdLoginWithAccount:sender success:^(id result) {
        
        [RootHud hide:YES];
        
        UserInfo *userinfo  = [[UserInfo alloc]init];
        
        NSDictionary *temdata  = [result objectForKey:@"user"];
        
        userinfo.loginPlatform = platForm;
        
        userinfo.accountType = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"status"]];
        userinfo.birthday = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"birthday"]];
        userinfo.email = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"email"]];
        userinfo.userid = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"id"]];
        
        userinfo.nickname = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"nickName"]];
        
        userinfo.phone = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"phone"]];
        
        NSString *photostr = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"photo"]];
        if([photostr rangeOfString:@"http"].location == NSNotFound)//_roaldSearchText
        {
            photostr = [NSString stringWithFormat:@"http://m.yuti.cc%@",photostr];
        }
        
        userinfo.photo = photostr;
        userinfo.registerDate = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"createTime"]];
        userinfo.sex = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"sex"]];
        userinfo.status = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"status"]];
        userinfo.introcution = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"introduction"]];
        
        [SCKeychain saveUserName:[NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]]
                 userNameService:KEY_UserName
                        psaaword:[NSString stringWithFormat:@"%@",[temdata objectForKey:@"password"]]
                 psaawordService:KEY_PassWord];
//        userinfo.useraccount = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]];
        
        if ([[NSString stringWithFormat:@"%@",[temdata objectForKey:@"introduction"]] isEqualToString:@"(null)"]) {
            userinfo.introcution = nil;
        }
        
//        userinfo.password = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"password"]];
        userinfo.userscore = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"score"]];
        userinfo.loginID = [NSString stringWithFormat:@"%@",[result objectForKey:@"s"]];
        
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        [NSUserDefaults setBool:YES forKey:IS_LOGIN];
        
        //跳转到主界面
        [self goToVisitorBtnClicked];
    } failed:^(NSError *error) {
        
        [RootHud hide:YES];
        
        RootHud.mode = MBProgressHUDModeCustomView;
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        
        [NSUserDefaults setBool:NO forKey:IS_LOGIN];
        
    }];
}

- (void)goToLoginBtnClicked{
    //去登录界面
    LoginVC *loginvc = [[LoginVC alloc]init];
    loginvc.modelViewType = 0;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginvc];
    [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
}

- (void)goToVisitorBtnClicked{
    //游客登录,直接去主界面
    MainTabBarViewController *mainTabBar = [[MainTabBarViewController alloc]init];
    [[UIApplication sharedApplication].delegate.window setRootViewController:mainTabBar];
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
