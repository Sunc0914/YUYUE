//
//  SaveInfo.m
//  YUYUE
//
//  Created by Sunc on 15/11/14.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "SaveInfo.h"
#import "UserInfo.h"

@implementation SaveInfo

- (void)saveUserInfo:(NSString *)detail withKey:(NSString *)key{
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    if ([key isEqualToString:@"nickName"])
    {
        info.nickname = detail;
    }
    else if ([key isEqualToString:@"introduction"]){
        info.introcution = detail;
    }
    else if ([key isEqualToString:@"photo"]){
        info.photo = detail;
    }
    else if ([key isEqualToString:@"gender"]){
        info.sex = detail;
    }
    else if ([key isEqualToString:@"schoolID"]){
        
    }
    else if ([key isEqualToString:@"mobie"]){
        info.phone = detail;
    }
    else if ([key isEqualToString:@"qq"]){
        
    }
    else if ([key isEqualToString:@"email"]){
        info.email = detail;
    }
    else if ([key isEqualToString:@"birthday"]){
        info.birthday = detail;
    }
    
    [NSUserDefaults setUserObject:info forKey:USER_STOKRN_KEY];
}

@end
