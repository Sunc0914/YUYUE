//
//  LoginVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "LoginVC.h"
#import "HyLoglnButton.h"
#import "HyTransitions.h"
#import "MainTabBarViewController.h"
#import "InputText.h"
#import "UIView+XD.h"
#import "WXApi.h"
#import "RegisterNewViewController.h"
#import "SCKeychain.h"

@interface LoginVC ()<UIViewControllerTransitioningDelegate,UITextFieldDelegate,registerLogin>

@property (retain, nonatomic) UISwitch *Switch;

@property (nonatomic, weak)UITextField *userText;
@property (nonatomic, weak)UILabel *userTextName;
@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;
@property (nonatomic, retain)HyLoglnButton *log;
@property (nonatomic, retain)HyLoglnButton *visitorBtn;
@property (nonatomic, retain)HyLoglnButton *backBtn;
@property (nonatomic, assign) BOOL chang;

@property (nonatomic, assign) id delegate;


@end

@implementation LoginVC{
    CGFloat inputTextFiledHeight;
    UIButton *goToVisitorBtn;
}

NSString * const loginVC_UserName = @"com.yuyue.app.UserName";
NSString * const loginVC_PassWord = @"com.yuyue.app.PassWord";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _Switch = [[UISwitch alloc]init];
    
    [self initBackImageAndLogo];
    
    [self setupInputRectangle];
    
    [self createPresentControllerButton];
    
    [self initThirdPlatform];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)createPresentControllerButton{
    
    _log = [[HyLoglnButton alloc] initWithFrame:CGRectMake(30, self.passwordText.frame.size.height+self.passwordText.frame.origin.y+20, [UIScreen mainScreen].bounds.size.width - 60, 40)];
    [_log setBackgroundColor:[UIColor colorWithRed:50/255.0 green:113/255.0 blue:237/255.0 alpha:0.8]];
    [self.view addSubview:_log];
    [_log setTitle:@"登        录" forState:UIControlStateNormal];
    [_log addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    if(_modelViewType != 0)
    {
        _backBtn = [[HyLoglnButton alloc] initWithFrame:CGRectMake(30, _log.frame.size.height+_log.frame.origin.y+10, [UIScreen mainScreen].bounds.size.width - 60, 40)];
        [_backBtn setBackgroundColor:[UIColor colorWithRed:50/255.0 green:113/255.0 blue:237/255.0 alpha:0.8]];
        [self.view addSubview:_backBtn];
        [_backBtn setTitle:@"返        回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backToUpperViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        
        goToVisitorBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-30, SCREEN_WIDTH/4, 20)];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"先随便看看"];
        NSRange strRange1 = {0,[str1 length]};
        [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
        [str1 addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:strRange1];
        [goToVisitorBtn setAttributedTitle:str1 forState:UIControlStateNormal];
        [goToVisitorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        goToVisitorBtn.backgroundColor = [UIColor clearColor];
        [goToVisitorBtn addTarget:self action:@selector(goToVisitorBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        goToVisitorBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:goToVisitorBtn];
        
        UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*4/5.0-10, SCREEN_HEIGHT-30, SCREEN_WIDTH/5, 20)];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"没有账号?"];
        NSRange strRange2 = {0,[str2 length]};
        [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange2];
        [str2 addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:strRange1];
        [registerBtn setAttributedTitle:str2 forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.backgroundColor = [UIColor clearColor];
        [registerBtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
        registerBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:registerBtn];
    }
}

- (void)goRegister{
    //去注册
    RegisterNewViewController *registerVc = [[RegisterNewViewController alloc]init];
    registerVc.delegate = self;
    [self.navigationController pushViewControllerAnimatedWithTransition:registerVc];
}

- (void)loginAfterRegist:(NSDictionary *)loginDic{
    _userText.text = [loginDic objectForKey:@"userName"];
    _passwordText.text = [loginDic objectForKey:@"password"];
    [self PresentViewController:_log];
}

- (void)goToVisitorBtnClicked{
    //游客登录,直接去主界面
    MainTabBarViewController *mainTabBar = [[MainTabBarViewController alloc]init];
    [[UIApplication sharedApplication].delegate.window setRootViewController:mainTabBar];
}

- (void)initBackImageAndLogo{
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"loginBg.jpg"];
    [self.view addSubview:backImage];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, upsideheight+30, SCREEN_WIDTH*0.383, SCREEN_WIDTH*0.383*134/264)];
    logoImage.image = [UIImage imageNamed:@"yutiLogoWhite"];
    [self.view addSubview:logoImage];
    
    inputTextFiledHeight = logoImage.frame.origin.y+logoImage.frame.size.height+30;
}

- (void)initThirdPlatform{
    CGFloat btnWidth = 50;
    CGFloat width = (SCREEN_WIDTH-btnWidth*3)/6.0;
    
    NSArray *socialImageArr = @[@"socialWbNor",@"socialWxNor",@"socialTxNor"];
    
    UILabel *otherWayLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2.0, SCREEN_HEIGHT-130, 100, 20)];
    otherWayLabel.backgroundColor = [UIColor clearColor];
    otherWayLabel.text = @"使用其他方式登录";
    otherWayLabel.textColor = [UIColor whiteColor];
    otherWayLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:otherWayLabel];
    
    for (int i = 0; i<3; i++) {
        UIButton *thirdPlatformLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+(btnWidth+width*2)*i, SCREEN_HEIGHT-100, btnWidth, btnWidth)];
        thirdPlatformLoginBtn.layer.cornerRadius = thirdPlatformLoginBtn.bounds.size.height/2.0;
        thirdPlatformLoginBtn.layer.masksToBounds = YES;
        thirdPlatformLoginBtn.tag = i;
        [thirdPlatformLoginBtn addTarget:self action:@selector(thirdClicked:) forControlEvents:UIControlEventTouchUpInside];
        thirdPlatformLoginBtn.backgroundColor = [UIColor clearColor];
        [thirdPlatformLoginBtn setBackgroundImage:[UIImage imageNamed:[socialImageArr objectAtIndex:i]] forState:UIControlStateNormal];
        thirdPlatformLoginBtn.hidden = NO;
        [self.view addSubview:thirdPlatformLoginBtn];
        if (i==1) {
            if ([WXApi isWXAppInstalled]) {
                thirdPlatformLoginBtn.hidden = NO;
            }
            else{
                thirdPlatformLoginBtn.hidden = YES;
            }
        }
    }
}

- (void)thirdClicked:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:THIRD_PLATFROM object:nil userInfo:@{@"tag":[NSString stringWithFormat:@"%ld",(long)sender.tag]}];
}

- (void)setupInputRectangle
{
    //用户名
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    CGFloat centerX = SCREEN_WIDTH*0.5;
    InputText *inputTextUserName = [[InputText alloc] init];
    CGFloat userY = inputTextFiledHeight;
    UITextField *userText = [inputTextUserName setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.delegate = self;
    
    NSString *loginAccount = [SCKeychain getUserNameWithService:loginVC_UserName];
    userText.text = loginAccount;
    self.userText = userText;
    self.userText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userText setReturnKeyType:UIReturnKeyNext];
    [self.userText addTarget:self action:@selector(userTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:userText];
    UILabel *userTextName = [self setupTextName:@"用户名" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    if (self.userText.text.length>0) {
        [self diminishTextName:self.userTextName];
    }
    
    //密码
    
    CGFloat passwordY = CGRectGetMaxY(userText.frame) + 30;
    InputText *inputTextPassWord = [[InputText alloc] init];
    UITextField *passwordText = [inputTextPassWord setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    
    self.passwordText = passwordText;
    NSString *passWord = [SCKeychain getPasswordWithService:loginVC_PassWord];
    passwordText.text = passWord;
    self.passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordText setReturnKeyType:UIReturnKeyDone];
    
    [passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    if (self.passwordText.text.length>0) {
        [self diminishTextName:self.passwordTextName];
//        [self restoreTextName:self.userTextName textField:self.userText];
    }

}

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor whiteColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}

- (void)userTextFieldChanged:(UITextField *)sender{
    if (self.userText == sender) {
        NSString *loginAccount = [SCKeychain getUserNameWithService:loginVC_UserName];
        if (self.userText.text != loginAccount) {
            self.passwordText.text = @"";
        }
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userText) {
        return [self.passwordText becomeFirstResponder];
    }
    else
    {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        
        [_log StartAnimation];
        
        [self PresentViewController:_log];
        
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = [UIColor whiteColor];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}
- (void)textFieldDidChange
{
    if (self.userText.text.length != 0  && self.passwordText.text.length != 0) {
//        self.loginBtn.enabled = YES;
    } else {
//        self.loginBtn.enabled = NO;
    }
}

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}

#pragma mark- 登陆接口
-(void)PresentViewController:(HyLoglnButton *)button{
    
    typeof(self) __weak weak = self;
    
    //模拟网络访问
    [AppWebService userLoginWithAccount:_userText.text loginpwd:_passwordText.text success:^(id result) {
        NSLog(@"success");
        _Switch.on = YES;
        
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
            photostr = [NSString stringWithFormat:@"http//m.yuti.cc%@",photostr];
        }
        
        userinfo.photo = photostr;
    
        userinfo.registerDate = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"createTime"]];
        userinfo.sex = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"sex"]];
        userinfo.status = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"status"]];
        userinfo.introcution = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"introduction"]];
        
        
//        userinfo.useraccount = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]];
        if ([[NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]] isEqualToString:@"(null)"]) {
            userinfo.useraccount = nil;
        }
        [SCKeychain saveUserName:[NSString stringWithFormat:@"%@",[temdata objectForKey:@"userName"]]
                 userNameService:loginVC_UserName
                        psaaword:[NSString stringWithFormat:@"%@",[temdata objectForKey:@"password"]]
                 psaawordService:loginVC_PassWord];
        
        NSString *userLoginAccount = userinfo.useraccount;
        NSString *prefixStr = [userLoginAccount substringToIndex:3];
        if ([prefixStr isEqualToString:@"wb_"]) {
            userinfo.loginPlatform = @"wb";
        }
        else if ([prefixStr isEqualToString:@"wx_"]){
            userinfo.loginPlatform = @"wx";
        }
        else if ([prefixStr isEqualToString:@"qq_"]){
            userinfo.loginPlatform = @"qq";
        }
        
//        userinfo.password = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"password"]];
        userinfo.userscore = [NSString stringWithFormat:@"%@",[temdata objectForKey:@"score"]];
        userinfo.loginID = [NSString stringWithFormat:@"%@",[result objectForKey:@"s"]];
        
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        [NSUserDefaults setBool:YES forKey:IS_LOGIN];
        
        [weak LoginButton:button];
    } failed:^(NSError *error) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        _Switch.on = NO;
        [weak LoginButton:button];
        
    }];
}

-(void)LoginButton:(HyLoglnButton *)button
{
    typeof(self) __weak weak = self;
    if (_Switch.on) {
        if (_modelViewType == 2) {
            
            //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
            dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC);
            //推迟两纳秒执行
            dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
            
            dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                NSLog(@"Grand Center Dispatch!");
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            });
            
            return;
        }
        //网络正常 或者是密码账号正确跳转动画
        [button ExitAnimationCompletion:^{
            if (_modelViewType == 1) {
                [self.navigationController popViewControllerAnimatedWithTransition];
            }
            else if (_modelViewType == 2){
                
            }
            else{
                if (weak.Switch.on) {
                    [weak didPresentControllerButtonTouch];
                }
            }
        }];
    }else{
        //网络错误 或者是密码不正确还原动画
        [button ErrorRevertAnimationCompletion:^{
            if (weak.Switch.on) {
                [weak didPresentControllerButtonTouch];
            }
        }];
        
        
    }
}

- (void)backToUpperViewController{
    
    if (_modelViewType == 1) {
        [self.navigationController popViewControllerAnimatedWithTransition];
    }
    else if (_modelViewType == 2){
        
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            NSLog(@"Grand Center Dispatch!");
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        });
    }
}

- (void)didPresentControllerButtonTouch
{
    MainTabBarViewController *controller = [[MainTabBarViewController alloc]init];
    
    controller.transitioningDelegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
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
