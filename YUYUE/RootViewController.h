//
//  RootViewController.h
//  Mood Diary
//
//  Created by SunCheng on 15-4-8.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RootViewController : UIViewController
{
    float navheight;
    float stateheight;
    float upsideheight;
    
    MBProgressHUD *RootHud;
    
    UIImageView *navBarHairlineImageView;

}

- (BOOL)hasNewVersion;
- (void)popBack;
- (void)handPopBack;
- (void)refreshAgain;
- (void)showAlertViewTitle:(NSString*)title message:(NSString*)mseeage;
- (float)getnavheight;
- (float)getstateheight;
- (void)showview:(UIView *)sender height:(CGFloat)height;
- (void)hideview:(UIView *)sender height:(CGFloat)height;
- (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)isQQNumber:(NSString *)QQNum;
- (BOOL)isLogin;
//自适应文字
-(CGSize)maxlabeisize:(CGSize)labelsize fontsize:(NSInteger)fontsize text:(NSString *)content;

@end
