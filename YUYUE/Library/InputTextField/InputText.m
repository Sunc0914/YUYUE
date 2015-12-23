//
//  InputText.m
//  动态输入框
//
//  Created by mxd on 14/12/4.
//  Copyright (c) 2014年 daizhe. All rights reserved.
//

#import "InputText.h"
#import "UIView+XD.h"

@implementation InputText
- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
{
    UITextField *textField = [[UITextField alloc] init];
    textField.width = SCREEN_WIDTH-60;
    textField.height = 40;
    textField.centerX = centerX;
    textField.y = textY;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH-40, 0.5)];
    view.alpha = 0.5;
    view.backgroundColor = [UIColor grayColor];
    [textField addSubview:view];
    textField.placeholder = point;
    textField.font = [UIFont systemFontOfSize:18];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor whiteColor];
    UIImage *bigIcon = [UIImage imageNamed:icon];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:bigIcon];
    if (icon) {
        iconView.width = 34;
    }
    iconView.contentMode = UIViewContentModeLeft;
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
