//
//  RegisterNewViewController.h
//  inteLook
//
//  Created by Sunc on 15-3-3.
//  Copyright (c) 2015年 whtysf. All rights reserved.
//

#import "RootViewController.h"

@protocol registerLogin <NSObject>

- (void)loginAfterRegist:(NSDictionary *)loginDic;

@end

@interface RegisterNewViewController : RootViewController<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
    UITextField *phoneNumTF;
    UITextField *checkNumTF;
    UITextField *passwordTF;
    UITextField *repeatpwdTF;
    UITextField *username;
    UIButton *registerBT;
    UIButton *selectBT;
    UIButton *getCheckCodeBT;
    
    UIView *bgView;
    int keyboardheight;
    BOOL codegot;
}

@property (nonatomic, assign)id<registerLogin>delegate;

@end
