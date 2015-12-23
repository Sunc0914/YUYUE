//
//  AppDelegate.m
//  YUYUE
//
//  Created by Sunc on 15/8/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "UserInfo.h"
#import "MBProgressHUD.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "LaunchVC.h"
#import "SCKeychain.h"
#import <SMS_SDK/SMSSDK.h>

@implementation AppDelegate
{
    UIImageView *launchView;
    UIImageView *logoView;
    UIScrollView *backScrollView;
    
    UIButton *goToLoginBtn;
    UIButton *goToVisitorBtn;
    
    NSMutableArray *btnArr;
    
    LaunchVC *launchVc;
}

NSString * const APP_RefreshToken = @"com.yuyue.app.refresh_token";
NSString * const APP_AccessToken = @"com.yuyue.app.access_token";
NSString * const APP_OpenID = @"com.yuye.app.OpenID";
NSString * const APP_UserName = @"com.yuyue.app.UserName";
NSString * const APP_PassWord = @"com.yuyue.app.PassWord";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        [SCKeychain deleteuserInfoService:APP_OpenID];
        [SCKeychain deleteuserInfoService:APP_AccessToken];
        [SCKeychain deleteuserInfoService:APP_RefreshToken];
        [SCKeychain deleteuserInfoService:APP_UserName];
        [SCKeychain deleteuserInfoService:APP_PassWord];
    }else{
        NSLog(@"不是第一次启动");
    }
    
    launchVc = [[LaunchVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:launchVc];
    self.window.rootViewController = nav;
    
    [self registernotify];
    
    [self setUmengShare];
    
    [self setShareSdk];
    
    [self setUmengAnalytics];
    
    [self ininloginvc];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setShareSdk{
    [SMSSDK registerApp:@"d3bfe1b0a04c"
             withSecret:@"7a37daa65e6de0531df629245752e725"];
}

- (void)registernotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToWhitchViewController)
                                                 name:GO_TO_CONTROLLER object:nil];
}

- (void)setUmengShare
{
    //设置友盟分享
    [UMSocialData setAppKey:umengShareKey];
    
    //新浪分享
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //新浪sso
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"329672474" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //qq空间和好友
    [UMSocialQQHandler setQQWithAppId:@"1104889403" appKey:@"Ejxf1vKS3Eq1vB7J" url:@"http://www.yuti.cc"];
//    //微信和微信好友
    [UMSocialWechatHandler setWXAppId:@"wx92de49bd1cb1fda2" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.yuti.cc"];
    
    [WXApi registerApp:@"wx92de49bd1cb1fda2" withDescription:@"originalyuyue"];
}

- (void)setUmengAnalytics{
    //设置友盟应用统计
    
}

- (void)ininloginvc
{
    NSString *loginAccount = [SCKeychain getUserNameWithService:APP_UserName];
    NSString *passWord = [SCKeychain getUserNameWithService:APP_PassWord];
    
    if (loginAccount.length>0&&passWord.length>0) {
        //自动登陆

        [AppWebService userLoginWithAccount:loginAccount loginpwd:passWord success:^(id result) {
            
            NSLog(@"success");
            
            NSDictionary *temdata  = [result objectForKey:@"user"];

            UserInfo *userinfo  = [[UserInfo alloc]init];
            
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
            
            NSString *loginAccount = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]];
            if ([[NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]] isEqualToString:@"(null)"]) {
                loginAccount = nil;
            }
            
            [SCKeychain saveUserName:[NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]]
                     userNameService:APP_UserName
                            psaaword:[NSString stringWithFormat:@"%@",[temdata objectForKey:@"password"]]
                     psaawordService:APP_PassWord];
            //判断值账号属于哪种类型
            NSString *prefixStr = [loginAccount substringToIndex:3];
            if ([prefixStr isEqualToString:@"wb_"]) {
                userinfo.loginPlatform = @"wb";
            }
            else if ([prefixStr isEqualToString:@"wx_"]){
                userinfo.loginPlatform = @"wx";
            }
            else if ([prefixStr isEqualToString:@"qq_"]){
                userinfo.loginPlatform = @"qq";
            }
            
//            userinfo.password = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"password"]];
            userinfo.userscore = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"score"]];
            userinfo.loginID = [NSString stringWithFormat:@"%@",[result objectForKey:@"s"]];
            
            [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
            [NSUserDefaults setBool:YES forKey:IS_LOGIN];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_FAILED object:nil];


        } failed:^(NSError *error) {
            
            //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
            dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
            //推迟两纳秒执行
            dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
            
            dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                NSLog(@"Grand Center Dispatch!");
                [NSUserDefaults setBool:NO forKey:IS_LOGIN];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_FAILED object:nil];
            });
            
        }];
        
       //登陆方法
        
    }
    else{
        
        //手动登陆
        [NSUserDefaults setBool:NO forKey:IS_LOGIN];
        launchVc = [[LaunchVC alloc]init];
        launchVc.isLoginSuccess = YES;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:launchVc];
        self.window.rootViewController = nav;
    }
    
}

- (void)goToWhitchViewController{
    
    //先判断是否登陆
    if ([NSUserDefaults boolForKey:IS_LOGIN]){
        self.tabBarController = [[MainTabBarViewController alloc]init];
        self.window.rootViewController = self.tabBarController;
    }
    else{
        LoginVC *loginvc = [[LoginVC alloc]init];
        loginvc.modelViewType = 0;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginvc];
        self.window.rootViewController = nav;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)onResp:(BaseResp*)resp{
    NSLog(@"success");
    /**
     @author Sunc, 15-11-25 16:11:19
     
     这里微信共用一个回调，分享授权都是走这里，要判断是哪一种
     */
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_SHARE_SUCCESS object:nil];
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        [launchVc setWxLoginCode:resp];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [NSUserDefaults setBool:NO forKey:IS_LOGIN];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
