//
//  UserInfo.m
//  FlowMng
//
//  Created by tysoft on 14-2-27.
//  Copyright (c) 2014年 key. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize accountType;
@synthesize birthday;
@synthesize email;
@synthesize userid;
@synthesize idCard;
@synthesize loginCount;
@synthesize name;
@synthesize nickname;
@synthesize phone;
@synthesize photo;
@synthesize registerDate;
@synthesize sex;
@synthesize signature;
@synthesize status;
@synthesize useraccount;
@synthesize password;
@synthesize loginID;
@synthesize userscore;
@synthesize sportPic;
@synthesize districtArr;
@synthesize schoolArr;
@synthesize introcution;
@synthesize loginPlatform;
@synthesize isSign;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.accountType = [decoder decodeObjectForKey:@"accountType"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.userid= [decoder decodeObjectForKey:@"userid"];
        self.idCard = [decoder decodeObjectForKey:@"idCard"];
        self.loginCount = [decoder decodeObjectForKey:@"loginCount"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.photo = [decoder decodeObjectForKey:@"photo"];
        self.registerDate = [decoder decodeObjectForKey:@"registerDate"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.signature = [decoder decodeObjectForKey:@"signature"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.useraccount = [decoder decodeObjectForKey:@"useraccount"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.loginID = [decoder decodeObjectForKey:@"loginid"];
        self.userscore = [decoder decodeObjectForKey:@"userscore"];
        self.sportPic = [decoder decodeObjectForKey:@"sportpic"];
        self.districtArr = [decoder decodeObjectForKey:@"districtid"];
        self.schoolArr = [decoder decodeObjectForKey:@"schoolid"];
        self.introcution = [decoder decodeObjectForKey:@"introcution"];
        self.loginPlatform = [decoder decodeObjectForKey:@"loginPlatform"];
        self.isSign = [decoder decodeObjectForKey:@"isSign"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.accountType forKey:@"accountType"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.userid forKey:@"userid"];
    [encoder encodeObject:self.idCard forKey:@"idCard"];
    [encoder encodeObject:self.loginCount forKey:@"loginCount"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.photo forKey:@"photo"];
    [encoder encodeObject:self.registerDate forKey:@"registerDate"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.signature forKey:@"signature"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.useraccount forKey:@"useraccount"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.loginID forKey:@"loginid"];
    [encoder encodeObject:self.userscore forKey:@"userscore"];
    [encoder encodeObject:self.sportPic forKey:@"sportpic"];
    [encoder encodeObject:self.districtArr forKey:@"districtid"];
    [encoder encodeObject:self.schoolArr forKey:@"schoolid"];
    [encoder encodeObject:self.introcution forKey:@"introcution"];
    [encoder encodeObject:self.loginPlatform forKey:@"loginPlatform"];
    [encoder encodeObject:self.isSign forKey:@"isSign"];
}

-(void)dealloc{
   
 
}

@end
