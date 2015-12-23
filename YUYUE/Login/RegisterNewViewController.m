//
//  RegisterNewViewController.m
//  inteLook
//
//  Created by Sunc on 15-3-3.
//  Copyright (c) 2015年 whtysf. All rights reserved.
//

#import "RegisterNewViewController.h"
#import "RxWebViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterNewViewController ()

@end

@implementation RegisterNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-30)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self initWithScrollView];
    [mainScrollView addSubview:bgView];
    [self initCheckPart];
    [self initPwdPart];
    [self initAgreePart];
    
}

-(void)initWithScrollView
{
    //定义scrollview
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight, self.view.frame.size.width, self.view.frame.size.height-upsideheight)];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    //设置代理
    mainScrollView.delegate=self;
    
    [self.view addSubview:mainScrollView];
    
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight+10);
    
}

-(void)initCheckPart
{
    UIView *tembgView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
    tembgView.layer.masksToBounds = YES;
    tembgView.layer.cornerRadius = 5;
    tembgView.layer.borderWidth = 1;
    tembgView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    [bgView addSubview:tembgView];

    phoneNumTF = [[UITextField alloc]initWithFrame:CGRectMake(30, tembgView.frame.origin.y, SCREEN_WIDTH-60, 40)];
    phoneNumTF.delegate = self;
    phoneNumTF.font = [UIFont systemFontOfSize:16];
    phoneNumTF.placeholder = @"请输入手机号码";
    phoneNumTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneNumTF.tag = 0;
    phoneNumTF.returnKeyType = UIReturnKeyNext;
    phoneNumTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phoneNumTF addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:phoneNumTF];
    
    //昵称栏
    tembgView = [[UIView alloc]initWithFrame:CGRectMake(20, tembgView.frame.origin.y+tembgView.frame.size.height+20, SCREEN_WIDTH-40, 40)];
    tembgView.layer.masksToBounds = YES;
    tembgView.layer.cornerRadius = 5;
    tembgView.layer.borderWidth = 1;
    tembgView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    [bgView addSubview:tembgView];
    
    username = [[UITextField alloc]initWithFrame:CGRectMake(30, tembgView.frame.origin.y, SCREEN_WIDTH-60, 40)];
    username.delegate = self;
    username.font = [UIFont systemFontOfSize:16];
    username.placeholder = @"请输入用户名";
    username.keyboardType = UIKeyboardTypeDefault;
    username.returnKeyType = UIReturnKeyNext;
    username.tag = 1;
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [username addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bgView addSubview:username];
    
    //验证码和按钮
    tembgView = [[UIView alloc]initWithFrame:CGRectMake(20, tembgView.frame.origin.y+tembgView.frame.size.height+20, (SCREEN_WIDTH-50)*3/5, 40)];
    tembgView.layer.masksToBounds = YES;
    tembgView.layer.cornerRadius = 5;
    tembgView.layer.borderWidth = 1;
    tembgView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    [bgView addSubview:tembgView];
    
    checkNumTF = [[UITextField alloc]initWithFrame:CGRectMake(30, tembgView.frame.origin.y, (SCREEN_WIDTH-50)*3/5-10, 40)];
    checkNumTF.delegate = self;
    checkNumTF.font = [UIFont systemFontOfSize:16];
    checkNumTF.placeholder = @"请输入验证码";
    checkNumTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    checkNumTF.returnKeyType = UIReturnKeyNext;
    checkNumTF.tag = 2;
    checkNumTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [checkNumTF addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:checkNumTF];
    
    getCheckCodeBT = [[UIButton alloc]initWithFrame:CGRectMake(20+10+(SCREEN_WIDTH-50)*3/5, tembgView.frame.origin.y, (SCREEN_WIDTH-50)*2/5, 40)];
    [getCheckCodeBT setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCheckCodeBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getCheckCodeBT addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    getCheckCodeBT.backgroundColor = [UIColor colorWithRed:50/255.0 green:113/255.0 blue:237/255.0 alpha:1.0];
    getCheckCodeBT.layer.masksToBounds = YES;
    getCheckCodeBT.layer.cornerRadius = 5;
    getCheckCodeBT.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:getCheckCodeBT];
}

- (void)closePage{
    [self.view resignFirstResponder];
    [self.navigationController popViewControllerAnimatedWithTransition];
}

-(void)getCheckCode:(NSString *)sender
{
    if (![self isMobileNumber:phoneNumTF.text]) {
        //请输入正确的手机号
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (phoneNumTF.text.length == 0) {
        //手机号不能为空
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号不能为空！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSLog(@"%@",phoneNumTF.text);
    
    //获取验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumTF.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error)
     {
         
         if (!error)
         {
             NSLog(@"验证码发送成功");
             //倒计时
             [self rcounttime];
             getCheckCodeBT.userInteractionEnabled = NO;
             [username resignFirstResponder];
             [checkNumTF becomeFirstResponder];
         }
         else
         {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                             message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"好的", nil)
                                                   otherButtonTitles:nil, nil];
             [alert show];
         }
         
     }];
    
}

-(void)rcounttime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                getCheckCodeBT.userInteractionEnabled = YES;
                getCheckCodeBT.titleLabel.font = [UIFont systemFontOfSize:14];
                [getCheckCodeBT setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
//            int minutes = timeout / 60;
//            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"剩余 %d秒", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getCheckCodeBT setTitle:strTime forState:UIControlStateNormal];
                getCheckCodeBT.titleLabel.adjustsFontSizeToFitWidth = YES;
            });
            timeout--;
        }  
    });  
    dispatch_resume(_timer);
}

-(void)initPwdPart
{
    //密码
    
    UIView *tembgView = [[UIView alloc]initWithFrame:CGRectMake(20, checkNumTF.frame.origin.y+checkNumTF.frame.size.height+20, SCREEN_WIDTH-40, 40)];
    tembgView.layer.masksToBounds = YES;
    tembgView.layer.cornerRadius = 5;
    tembgView.layer.borderWidth = 1;
    tembgView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    [bgView addSubview:tembgView];
    
    passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(30, tembgView.frame.origin.y, SCREEN_WIDTH-60, 40)];
    passwordTF.delegate = self;
    passwordTF.font = [UIFont systemFontOfSize:16];
    passwordTF.placeholder = @"请输入密码";
    passwordTF.keyboardType = UIKeyboardTypeAlphabet;
    passwordTF.returnKeyType = UIReturnKeyNext;
    passwordTF.tag = 3;
    passwordTF.secureTextEntry = YES;
    passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordTF addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:passwordTF];
    
    tembgView = [[UIView alloc]initWithFrame:CGRectMake(20, tembgView.frame.origin.y+tembgView.frame.size.height+20, SCREEN_WIDTH-40, 40)];
    tembgView.layer.masksToBounds = YES;
    tembgView.layer.cornerRadius = 5;
    tembgView.layer.borderWidth = 1;
    tembgView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    [bgView addSubview:tembgView];
    
    repeatpwdTF = [[UITextField alloc]initWithFrame:CGRectMake(30, tembgView.frame.origin.y, SCREEN_WIDTH-60, 40)];
    repeatpwdTF.delegate = self;
    repeatpwdTF.font = [UIFont systemFontOfSize:16];
    repeatpwdTF.placeholder = @"请再次输入密码";
    repeatpwdTF.keyboardType = UIKeyboardTypeAlphabet;
    repeatpwdTF.returnKeyType = UIReturnKeyDone;
    repeatpwdTF.tag = 4;
    repeatpwdTF.secureTextEntry = YES;
    repeatpwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [repeatpwdTF addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:repeatpwdTF];
}

-(void)initAgreePart
{
    selectBT = [[UIButton alloc]initWithFrame:CGRectMake(20, repeatpwdTF.frame.origin.y+repeatpwdTF.frame.size.height+15, 140, 20)];
    [selectBT setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [selectBT setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [selectBT addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [selectBT setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    selectBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBT setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [bgView addSubview:selectBT];
    
    UIButton *privacyBT = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140-20, selectBT.frame.origin.y+1, 140, 20)];
    [privacyBT setTitle:@"使用条款和隐私政策" forState:UIControlStateNormal];
    privacyBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [privacyBT setTitleColor:[UIColor colorWithRed:246/255.0 green:100/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
    [privacyBT addTarget:self action:@selector(privacyBtClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:privacyBT];
    
    registerBT = [[UIButton alloc]initWithFrame:CGRectMake(20, selectBT.frame.origin.y+selectBT.frame.size.height+15, SCREEN_WIDTH-40, 40)];
    registerBT.backgroundColor = [UIColor colorWithRed:228/255.0 green:229/255.0 blue:231/255.0 alpha:1.0];
    [registerBT addTarget:self action:@selector(registerbtnclicked) forControlEvents:UIControlEventTouchUpInside];
    [registerBT setTitle:@"注册并登录" forState:UIControlStateNormal];
    [registerBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBT.userInteractionEnabled = YES;
    registerBT.layer.masksToBounds = YES;
    registerBT.layer.cornerRadius = 5;
    [bgView addSubview:registerBT];
    
}

- (void)checkCode{
    //校核验证码
    [SMSSDK commitVerificationCode:checkNumTF.text phoneNumber:phoneNumTF.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            [self registerUser];
        }
        else
        {
            NSLog(@"验证失败");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"好的", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
}

- (void)registerUser{
    //注册用户
    if (checkNumTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (passwordTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![repeatpwdTF.text isEqualToString:passwordTF.text] ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (checkNumTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (username.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (username.text.length > 10) {
        UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名字数不能超过10个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (checkNumTF.text.length == 0) {
        //验证码失效
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请重新获取验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //注册
    
    NSDictionary *dic = @{@"userName":username.text,@"password":passwordTF.text,@"mobile":phoneNumTF.text};
    
    [AppWebService uesrRegister:dic success:^(id result) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        RootHud.labelText = @"注册成功";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC);
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_after(time, queue, ^{
            [self closePage];
            if ([_delegate respondsToSelector:@selector(loginAfterRegist:)]) {
                [_delegate loginAfterRegist:dic];
            }
        });
        
    } failed:^(NSError *error) {
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
    }];
    
    //注册成功后调用登陆接口
}

-(void)registerbtnclicked
{
//    [self checkCode];
    [self registerUser];
    
}

-(void)privacyBtClicked
{
    //使用条款和隐私政策
    
    RxWebViewController *priCtr=[[RxWebViewController alloc]init];
    priCtr.urlStr = @"http://m.yuti.cc/agreement";
    priCtr.webType = @"“喻体”注册服务条例";
    priCtr.needLogin = NO;
    priCtr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:priCtr animated:YES];
    
}

-(void)selected:(UIButton *)sender
{
    if (sender.selected) {
        selectBT.selected  = NO;
        registerBT.userInteractionEnabled = NO;
        registerBT.backgroundColor = [UIColor colorWithRed:228/255.0 green:229/255.0 blue:231/255.0 alpha:1.0];
    }
    else
    {
        selectBT.selected = YES;
        registerBT.userInteractionEnabled = YES;
        registerBT.backgroundColor = [UIColor colorWithRed:50/255.0 green:113/255.0 blue:237/255.0 alpha:1.0];
    }
}

-(void)textChangeAction:(UITextField *) sender
{
    if (sender.text.length>0) {
        sender.clearButtonMode = UITextFieldViewModeAlways;
    }
    else
    {
        sender.clearButtonMode = UITextFieldViewModeNever;
    }
    
    if (sender == phoneNumTF) {
        if (phoneNumTF.text>0) {
            phoneNumTF.text = [phoneNumTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [phoneNumTF resignFirstResponder];
    [checkNumTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [repeatpwdTF resignFirstResponder];
    [username resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        [phoneNumTF resignFirstResponder];
        [username becomeFirstResponder];
    }
    else if (textField.tag == 1) {
        [username resignFirstResponder];
        [checkNumTF becomeFirstResponder];
    }
    else if (textField.tag == 2)
    {
        [checkNumTF resignFirstResponder];
        [passwordTF becomeFirstResponder];
    }
    else if (textField.tag == 3)
    {
        [passwordTF resignFirstResponder];
        [repeatpwdTF becomeFirstResponder];
    }
    else if (textField.tag == 4)
    {
        [repeatpwdTF resignFirstResponder];
    }
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    mainScrollView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if (textField == repeatpwdTF) {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%f",textField.frame.origin.y);
    
    CGFloat y = textField.frame.origin.y + upsideheight + bgView.frame.origin.y + 40;
    
    CGFloat mainScrollViewY = mainScrollView.bounds.origin.y;
    
    NSLog(@"%f",(SCREEN_HEIGHT-keyboardheight));
    
    if ((SCREEN_HEIGHT-keyboardheight)<y) {
        [UIView animateWithDuration:0.5 animations:^{
            mainScrollView.frame = CGRectMake(mainScrollView.frame.origin.x, mainScrollViewY - (y-(SCREEN_HEIGHT-keyboardheight)), SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight);
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            mainScrollView.frame = CGRectMake(mainScrollView.frame.origin.x, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight);
        }];
    }
}

#pragma mark-keyboardHight

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    keyboardheight = kbSize.height;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
