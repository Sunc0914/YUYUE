//
//  JoinDetailVC.m
//  YUYUE
//
//  Created by Sunc on 15/10/8.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "JoinDetailVC.h"
#import "InputText.h"
#import "MBProgressHUD.h"

@interface JoinDetailVC ()<UITextFieldDelegate,MBProgressHUDDelegate>

@property (nonatomic, retain)UITextField *userText;
@property (nonatomic, retain)UILabel *userTextName;
@property (nonatomic, retain)UITextField *emailText;
@property (nonatomic, retain)UILabel *emailTextName;
@property (nonatomic, retain)UITextField *passwordText;
@property (nonatomic, retain)UILabel *passwordTextName;
@property (nonatomic, assign) BOOL chang;
@property (nonatomic, retain) UIScrollView *backView;

@end

@implementation JoinDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"预约活动";
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString *string = userinfo.nickname;
    
    if (string == nil||string.length == 0||[string isEqualToString:@"(null)"]) {
        
        string = @"用户名";
    }
    
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
    _backView.showsVerticalScrollIndicator = NO;
    
    CGFloat centerX = SCREEN_WIDTH * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = upsideheight+20;
    UITextField *userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.text = string;
    userText.delegate = self;
    
    self.userText = userText;
    self.userText.textColor = tipColor;
    [userText setReturnKeyType:UIReturnKeyNext];
    [userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_backView addSubview:userText];
    
    UILabel *userTextName = [self setupTextName:@"用户名" frame:userText.frame];
    self.userTextName = userTextName;
    [_backView addSubview:userTextName];
    
    if (self.userText.text.length>0) {
        [self diminishTextName:self.userTextName];
    }
    
    CGFloat emailY = CGRectGetMaxY(userText.frame) + 20;
    UITextField *emailText = [inputText setupWithIcon:nil textY:emailY centerX:centerX point:nil];
    emailText.keyboardType = UIKeyboardTypeNumberPad;
    [emailText setReturnKeyType:UIReturnKeyNext];
    emailText.delegate = self;
    self.emailText = emailText;
    self.emailText.textColor = tipColor;
    [emailText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_backView addSubview:emailText];
    
    UILabel *emailTextName = [self setupTextName:@"手机号" frame:emailText.frame];
    self.emailTextName = emailTextName;
    [_backView addSubview:emailTextName];
    
    CGFloat passwordY = CGRectGetMaxY(emailText.frame) + 20;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    passwordText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passwordText.delegate = self;
    self.passwordText = passwordText;
    self.passwordText.textColor = tipColor;
    [passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_backView addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"QQ号" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [_backView addSubview:passwordTextName];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 232, 35)];
    btn.center = CGPointMake(SCREEN_WIDTH*0.5, passwordY+80);
    [btn setTitle:@"预  约" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(subscribeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithRed:245/255.0 green:103/255.0 blue:19/255.0 alpha:1.0];
    [_backView addSubview:btn];
    
    [self.view addSubview:_backView];
    
    RootHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:RootHud];
    
    RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    
    // Set custom view mode
    RootHud.mode = MBProgressHUDModeCustomView;
    
    RootHud.delegate = self;
}

- (void)subscribeBtnClicked{
    
    RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    
    if (self.userTextName.text.length == 0) {
        
        RootHud.labelText = @"请填写预约名";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        return;
    }
    
    if (self.emailText.text.length == 0 && self.passwordText.text.length == 0) {
        
        RootHud.labelText = @"手机号和QQ号至少需要填一个";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        return;
    }
    
    if ((self.emailText.text.length != 0)&&![self isMobileNumber:self.emailText.text]) {
        
        RootHud.labelText = @"请输入正确的手机号";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        return;
    }
    
    if ((self.passwordText.text.length != 0)&&![self isQQNumber:self.passwordText.text]) {
        
        RootHud.labelText = @"请输入正确的QQ号";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        return;
    }
    
    [self.emailText resignFirstResponder];
    [self.userText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    [AppWebService subscribeActivity:userinfo.loginID motionId:_activityID realName:self.userText.text mobile:self.emailText.text qq:self.passwordText.text success:^(id result) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        
        RootHud.labelText = @"预约成功";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
        if ([_delegate respondsToSelector:@selector(refreshSubScribeView)]) {
            [_delegate refreshSubScribeView];
        }
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failed:^(NSError *error) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
//    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark -uitextfielddelegate
- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.emailTextName textField:self.emailText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.emailText) {
        [self diminishTextName:self.emailTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.emailTextName textField:self.emailText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userText) {
        return [self.emailText becomeFirstResponder];
    } else if (textField == self.emailText){
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
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
    if (self.userText.text.length != 0 && self.emailText.text.length != 0 && self.passwordText.text.length != 0) {
        
    } else {
        
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
