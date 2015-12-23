//
//  UserInfo.h
//  FlowMng
//
//  Created by tysoft on 14-2-27.
//  Copyright (c) 2014年 key. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject  {
    
    NSString *loginID;//动态登陆id
    NSString *accountType;//账号类型
    NSString *birthday;//生日
    NSString *email;//邮箱
    NSString *userid; //用户id
    NSString *idCard;//身份证号
    NSString *loginCount;//登陆账号
    NSString *name;   //姓名
    NSString *nickname;  //昵称
    NSString *phone; //手机号
    NSString *photo;   //照片地址
    NSString *registerDate;
    NSString *sex;//性别
    NSString *signature;//签名
    NSString *status;//状态
    NSString *useraccount;//账号
    NSString *password;//登陆密码
    NSString *userscore;//用户积分
    NSDictionary *sportPic;//运动图标
    NSArray *districtArr;//地区id
    NSArray *schoolArr;//学校id
    NSString *introcution;//签名
    NSString *loginPlatform;//三方平台名
    NSString *isSign;//签到
 }

@property (nonatomic, retain) NSString *accountType;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *idCard;
@property (nonatomic, retain) NSString *loginCount;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *registerDate;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *signature;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *useraccount;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *loginID;
@property (nonatomic, retain) NSString *userscore;//用户积分
@property (nonatomic, retain) NSDictionary *sportPic;
@property (nonatomic, retain) NSArray *districtArr;
@property (nonatomic, retain) NSArray *schoolArr;
@property (nonatomic, retain) NSString *introcution;//签名
@property (nonatomic, retain) NSString *loginPlatform;
@property (nonatomic, retain) NSString *isSign;

@end
