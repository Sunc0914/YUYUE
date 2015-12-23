//
//  RootViewController.m
//  Mood Diary
//
//  Created by SunCheng on 15-4-8.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"
#import "LoginVC.h"

@interface RootViewController ()<MBProgressHUDDelegate>
{
    
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initnav];
    
    upsideheight = 0;
    
    if (IS_IOS_7) {
        stateheight = [self getstateheight];
        navheight = [self getnavheight];
        upsideheight = stateheight + navheight;
    }
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.backgroundColor = [UIColor whiteColor];
    navBarHairlineImageView.hidden = YES;
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, navheight-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    [self.navigationController.navigationBar addSubview:line];
    
    [self initHUD];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:228/255.0 blue:225/255.0 alpha:1.0];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    //隐藏导航栏的一条直线
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (BOOL)isLogin{
    
//    [NSUserDefaults setBool:NO forKey:IS_LOGIN];
    if (![NSUserDefaults boolForKey:IS_LOGIN]) {
        MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:Hud];
        
        
        Hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        Hud.mode = MBProgressHUDModeCustomView;
        Hud.labelText = @"登录才可以操作哦！";
        
        [Hud show:YES];
        [Hud hide:YES afterDelay:1.5];
        
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 1.5f * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            NSLog(@"Grand Center Dispatch!");
            LoginVC *login = [[LoginVC alloc]init];
            login.modelViewType = 1;
            login.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewControllerAnimatedWithTransition:login];
            
        });
        
        return [NSUserDefaults boolForKey:IS_LOGIN];

    }
    else
    {
        return YES;
    }
    
}

- (void)initHUD{
    
    RootHud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.navigationController.view addSubview:RootHud];
    
    RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    
    // Set custom view mode
    RootHud.mode = MBProgressHUDModeCustomView;
    RootHud.animationType = MBProgressHUDAnimationFade;
    
    RootHud.delegate = self;
}

-(void)initnav
{
    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
    
    //设置导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0],UITextAttributeTextColor,nil]];
    //设置导航栏标题的大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

//自适应文字
-(CGSize)maxlabeisize:(CGSize)labelsize fontsize:(NSInteger)fontsize text:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:labelsize lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)refreshAgain {
    
}

-(void)showAlertViewTitle:(NSString *)title message:(NSString *)mseeage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:mseeage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
}


-(void)handPopBack {
    NSTimer *connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
}

-(void)timerFired:(NSTimer *)timer{
    
    [self popBack];
    
}

-(void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}
//新版本检测
-(BOOL)hasNewVersion
{
    NSString *flowversion = [NSUserDefaults objectUserForKey:APP_VERSION];
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *preVersion =[dic objectForKey:@"CFBundleVersion"];
    NSArray* preVerArr =[preVersion componentsSeparatedByString:@"."];
    NSArray* flowVerArr=[flowversion componentsSeparatedByString:@"."];
    BOOL isNewVersion=NO;
    for (int i=0; i<preVerArr.count; i++) {
        int a = [[preVerArr objectAtIndex:i]intValue];
        if (flowVerArr.count>i) {
            int b=[[flowVerArr objectAtIndex:i]intValue];
            if (a>b) {
                return NO;
            }
            if (a < b) {
                isNewVersion=YES;
                break ;
            }
        }
    }
    if (isNewVersion){
        
        return YES;
    }
    else
        return NO;
}

-(float)getnavheight
{
    float height;
    height = self.navigationController.navigationBar.frame.size.height;
    return height;
}

-(float)getstateheight
{
    float height;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    height = rectStatus.size.height;
    return height;
}

- (void)showview:(UIView *)sender height:(CGFloat)height{
    CGRect containerFrame = sender.frame;
    containerFrame.origin.y = height;
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        sender.frame = containerFrame;
    }];
}

- (void)hideview:(UIView *)sender height:(CGFloat)height{
    CGRect containerFrame = sender.frame;
    containerFrame.origin.y = height;
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        sender.frame = containerFrame;
    }];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^((13[0-9])|(14[^7,\\D])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isQQNumber:(NSString *)QQNum
{
    NSString * MOBILE = @"[1-9][0-9]{4,}";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([regextestmobile evaluateWithObject:QQNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
