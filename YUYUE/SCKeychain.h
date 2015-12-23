//
//  SCKeychain.h
//  YUYUE
//
//  Created by Sunc on 15/11/21.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCKeychain : NSObject
/**
 @author Sunc, 15-12-08 10:12:25
 
 配套储存
 @param userName	用户名
 @param userNameService	key
 @param pwd	密码
 @param pwdService	key
 */
+ (void) saveUserName:(NSString*)userName
      userNameService:(NSString*)userNameService
             psaaword:(NSString*)pwd
      psaawordService:(NSString*)pwdService;
/**
 @author Sunc, 15-12-08 10:12:06
 
 储存单一信息
 @param userInfo	信息
 @param userInfoService	key
 */
+ (void) saveUserInfo:(NSString*)userInfo
      userInfoService:(NSString*)userInfoService;

+ (void) deleteWithUserNameService:(NSString*)userNameService
                   psaawordService:(NSString*)pwdService;

+ (void) deleteuserInfoService:(NSString*)userInfoService;

+ (NSString*) getUserNameWithService:(NSString*)userNameService;

+ (NSString*) getPasswordWithService:(NSString*)pwdService;

@end
