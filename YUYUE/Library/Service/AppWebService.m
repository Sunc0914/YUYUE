//
//  NSObject+AppWebService.m
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTourAPIClient.h"
#import "AppWebService.h"

@implementation AppWebService

+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//用户注册
+ (void)uesrRegister:(NSDictionary *)infoDIc success:(SuccessBlock)success failed:(FailedBlock)failed{
    //上传json格式的参数
    NSDictionary * parameters = [ NSDictionary dictionaryWithObjectsAndKeys:[self DataTOjsonString:infoDIc], @"j" , nil ];
    
    [[iTourAPIClient sharedClient] postPath:@"register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
    
}

//登录方法
+(void)userLoginWithAccount:(NSString *)loginname loginpwd:(NSString *)loginpwd success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginname, @"userName", loginpwd, @"password", nil];
    
    //上传json格式的参数
    NSDictionary * parameters = [ NSDictionary dictionaryWithObjectsAndKeys:[self DataTOjsonString:dict], @"j" , nil ];
    
    [[iTourAPIClient sharedClient] postPath:@"login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];

        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//三方登陆
+ (void)thirdLoginWithAccount:(NSDictionary *)infoDic success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    //上传json格式的参数
    NSDictionary * parameters = [ NSDictionary dictionaryWithObjectsAndKeys:[self DataTOjsonString:infoDic], @"j" , nil ];
    
    [[iTourAPIClient sharedClient] postPath:@"login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//用户登出
+ (void)logout:(NSString *)logCode success:(SuccessBlock)success failed:(FailedBlock)failed;{
    
     NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:logCode, @"s", nil];
    
    [[iTourAPIClient sharedClient] postPath:@"logout" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"0"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
 
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取用户信息
+ (void)getuserDetail:(NSString *)userid success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"id", nil];
    
    [[iTourAPIClient sharedClient] postPath:@"user/detail" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//活动活动pic
+ (void)getActivitypicsuccess:(SuccessBlock)success failed:(FailedBlock)failed{
    
    [[iTourAPIClient sharedClient] postPath:@"sports" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取活动
+ (void)getNewAndHotActivitysuccess:(SuccessBlock)success failed:(FailedBlock)failed{
    
    [[iTourAPIClient sharedClient] postPath:@"motion/hot" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//活动详情
+ (void)getActivityDetail:(NSString *)activityID success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:activityID, @"id", nil];

    [[iTourAPIClient sharedClient] postPath:@"motion/detail" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取活动评论
+ (void)getActivityComment:(NSString *)objectID objectType:(NSString *)type page:(NSString *)page success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:objectID, @"objectId",type,@"objectType",page,@"page" ,nil];
    
    [[iTourAPIClient sharedClient] postPath:@"remark/list" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = @"没有更多数据";
        //        [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if (responseJson.count > 0) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"0"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//获取用户详情
+ (void)getUserInfo:(NSString *)loginID success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = @{@"id":loginID};
    [[iTourAPIClient sharedClient] postPath:@"user/detail" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//提交评论
+ (void)addComment:(NSString *)loginID objectID:(NSString *)objectId objectType:(NSString *)type score:(NSString *)score content:(NSString *)content success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:objectId,@"objectId",type,@"objectType",content,@"content",score,@"score", nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginID, @"s", [self DataTOjsonString:dict1], @"j" , nil];
    
    [[iTourAPIClient sharedClient] postPath:@"remark/add" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//活动点赞
+ (void)praiseActivity:(NSString *)loginId objectId:(NSString *)objectId success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginId, @"s",objectId,@"id" ,nil];
    
    [[iTourAPIClient sharedClient] postPath:@"motion/praise" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//活动预约
+ (void)subscribeActivity:(NSString *)loginId motionId:(NSString *)motionId  realName:(NSString *)name mobile:(NSString *)mobile qq:(NSString *)qq success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:motionId,@"motionId",name,@"realName",mobile,@"mobile",qq,@"qq", nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginId, @"s", [self DataTOjsonString:dict1], @"j" , nil];
    
    [[iTourAPIClient sharedClient] postPath:@"motion/subscribe" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取用户姓名
+ (void)getUseName:(NSString *)userid success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"id",nil];
    
    [[iTourAPIClient sharedClient] postPath:@"user/name" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//发布活动
+ (void)createActivity:(NSString *)loginId districtId:(NSString *)districtId schoolId:(NSString *)schoolId motionType:(NSString *)motionType name:(NSString *)name sportId:(NSString *)sportId motionPlace:(NSString *)motionPlace motionTime:(NSString *)motionTime payMode:(NSString *)payMode costMin:(NSString *)costMin costMax:(NSString *)costMax motionTarget:(NSString *)motionTarget attention:(NSString *)attention description:(NSString *)description contactPerson:(NSString *)contactPerson contactMobile:(NSString *)contactMobile :(NSString *)maxSubscribers success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:districtId,@"districtId",schoolId,@"schoolId",motionType,@"motionType",name,@"name", sportId,@"sportId",motionPlace,@"motionPlace",motionTime,@"motionTime",payMode,@"payMode",costMin,@"costMin",costMax,@"costMax",motionTarget,@"motionTarget",attention,@"attention",description,@"description",contactPerson,@"contactPerson",contactMobile,@"contactMobile",maxSubscribers,@"maxSubscribers",nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginId, @"s", [self DataTOjsonString:dict1], @"j" , nil];
    
    [[iTourAPIClient sharedClient] postPath:@"motion/publish" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//发布活动simple
+ (void)createActivitySimple:(NSMutableDictionary *)dic loginId:(NSString *)loginId success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginId, @"s", [self DataTOjsonString:dic], @"j" , nil];
    
    [[iTourAPIClient sharedClient] postPath:@"motion/publish" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

    
}

//获取地区id 获取学校id
+ (void)getIdType:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSString *path = @"/districts";
    
    if ([type isEqualToString: @"schoolid"]) {
        path = @"/schools";
    }
    else if ([type isEqualToString:@"sportid"])
    {
        path = @"/app/sports";
    }
    
    [[iTourAPIClient sharedClient] postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:responseJson];
        
        if (arr.count>0) {
            SAFE_BLOCK_CALL(success, arr);
        }
        else
        {
            NSString *errormsg = @"获取失败";
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取推荐故事
+ (void)getRecommandStory:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    [[iTourAPIClient sharedClient] postPath:@"story/recommend" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:responseJson];
        
        if (arr.count>0) {
            SAFE_BLOCK_CALL(success, arr);
        }
        else
        {
            NSString *errormsg = @"获取失败";
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
    
}

//获取故事列表
+ (void)getStoryList:(NSString *)page success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:page,@"page", nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[self DataTOjsonString:dic], @"j" , nil];
    
    [[iTourAPIClient sharedClient] postPath:@"story/search" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:responseJson];
        
        if (arr.count>0) {
            SAFE_BLOCK_CALL(success, arr);
        }
        else if(arr.count == 0)
        {
            NSString *errormsg = @"没有更多数据";
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        else
        {
            NSString *errormsg = @"获取失败";
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取我的积分
+ (void)getMyScore:(NSString *)loginID success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:loginID,@"s", nil];
    
    [[iTourAPIClient sharedClient] postPath:@"member/scores" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSDictionary *arr = [NSDictionary dictionaryWithDictionary:responseJson];
        
        if (arr.count>0) {
            SAFE_BLOCK_CALL(success, arr);
        }
        else
        {
            NSString *errormsg = @"积分获取失败";
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
    
}

//修改个人信息
+ (void)modifyInfo:(NSDictionary *)dic success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:info.loginID, @"s", [self DataTOjsonString:dic], @"j" , nil];
    
    [[iTourAPIClient sharedClient] postPath:@"member/modifyProfile" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"0"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//上传图片
+ (void)modifyPhoto:(NSData *)imgData fileName:(NSString *)filename success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSString *tempurl = BaseURLString;
    UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString* base_url=[NSString stringWithFormat:@"%@",tempurl];
    NSString *url = [NSString stringWithFormat:@"%@%@?s=%@",base_url,API_UPDATE_IMAGE,userInfo.loginID];
    NSLog(@"%@",url);
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *MPboundary=[NSString stringWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[NSString stringWithFormat:@"%@--",MPboundary];
    
    NSMutableString *body=[[NSMutableString alloc]init];

    [body appendFormat:@"%@\r\n",MPboundary];
    
    //声明pic字段，文件名为boris.png
    NSString *appendFormatStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"myFile\"; filename=\"%@\"\r\n", filename];
    NSLog(@"%@",appendFormatStr);
    
    //  [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"wangbo.doc\"\r\n"];
    [body appendFormat:@"%@",appendFormatStr];
    
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[NSString stringWithFormat:@"\r\n%@\r\n",endMPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //将image的data加入
    [myRequestData appendData:imgData];
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    [request setHTTPBody:myRequestData];
    [request setTimeoutInterval:10];
    
    //http method
    [request setHTTPMethod:@"POST"];
    
    //test
    AFHTTPRequestOperation *uploadOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempath = [docs[0] stringByAppendingPathComponent:userInfo.loginCount];
    NSLog(@"%@",tempath);
    NSString *tempath1 = [tempath stringByAppendingPathComponent:@"userimage"];
    NSString *path = [tempath1 stringByAppendingPathComponent:filename];
    NSLog(@"%@",path);
    
    uploadOperation.inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    
    [uploadOperation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat precent = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
        NSString *precentStr = [NSString stringWithFormat:@"%f",precent];
        SAFE_BLOCK_CALL(success, precentStr);
    }];
    //test

    
    NSData *requestdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [uploadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"123");
        
        NSLog(@"下载成功");
        SAFE_BLOCK_CALL(success, @"success");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SAFE_BLOCK_CALL(failed, [NSError errorWithMsg:@"下载附件失败"]);
    }];
    
//    NSString *requestStr = [[NSString alloc] initWithData:requestdata encoding:NSUTF8StringEncoding];
    
    NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:requestdata options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",responseJson);
    NSString *responseCode = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
    if ([responseCode isEqualToString:@"0"]) {
        SAFE_BLOCK_CALL(success, responseJson);
    }
    else {
        SAFE_BLOCK_CALL(failed, [NSError errorWithMsg:@"上传头像失败"]);
    }


}

//活动列表
+ (void)getAcitivity:(NSMutableDictionary *)dic success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: [self DataTOjsonString:dic], @"j" , nil];
    
    [[iTourAPIClient sharedClient] postPath:@"motion/search" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSArray *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = @"没有更多数据";
//        [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if (responseJson.count > 0) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"0"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//签到
+ (void)userSign:(NSString *)loginID success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginID, @"s",nil];
    
    [[iTourAPIClient sharedClient] postPath:@"member/sign" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//二级评论
+ (void)replyToSomeone:(NSString *)toID remarkID:(NSString *)remarkID content:(NSString *)content success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
 
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:content,@"content",remarkID,@"remarkId",toID,@"toUserId", nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[self DataTOjsonString:dic], @"j" ,userInfo.loginID,@"s", nil];
    
    [[iTourAPIClient sharedClient] postPath:@"remark/reply" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"0"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//活动分享后回调
+ (void)shareDone:(NSString *)motionID success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:motionID, @"id",  nil];
    
    [[iTourAPIClient sharedClient] postPath:@"motion/share" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"false"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else if ([errormsg isEqualToString:@"0"])
        {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//uionid  https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
+ (void)getUionID:(NSString *)openID withToken:(NSString *)token success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:openID,@"openid",token,@"access_token", nil];
    
    [[iTourAPIClient wxsharedClient] postPath:@"sns/userinfo" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"errcode"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//getAccessToken
+ (void)getAccessToken:(NSString *)code success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"wx92de49bd1cb1fda2",@"appid",@"d4624c36b6795d1d99dcf0547af5443d",@"secret",code,@"code",@"authorization_code",@"grant_type",nil];
    
    [[iTourAPIClient wxsharedClient] postPath:@"sns/oauth2/access_token" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"errcode"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//refresh_token
+ (void)refresh_token:(NSString *)refreshtoken success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"wx92de49bd1cb1fda2",@"appid",refreshtoken,@"refresh_token",@"refresh_token",@"grant_type",nil];
    
    [[iTourAPIClient wxsharedClient] postPath:@"sns/oauth2/refresh_token" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"errcode"]];
        
        if ([errormsg isEqualToString:@"(null)"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//check access_token
+ (void)checkaccess_token:(NSString *)access_token withOpenId:(NSString *)openid success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:openid,@"openid",access_token,@"access_token",nil];
    
    [[iTourAPIClient wxsharedClient] postPath:@"sns/auth" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"errcode"]];
        
        if ([errormsg isEqualToString:@"0"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//我的活动
+ (void)getMyActivity:(NSString *)loginID success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginID, @"s",nil];
    [[iTourAPIClient sharedClient] postPath:@"member/motions" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取某个活动的预约人
+ (void)getmyActivitySubs:(NSString *)loginID withActivityID:(NSString *)activityID success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = @{@"s":loginID,@"motionId":activityID};
    [[iTourAPIClient sharedClient] postPath:@"member/motion/subscribers" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

+ (void)getmyActivitySubsNew:(NSString *)loginID withActivityID:(NSString *)activityID success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = @{@"s":loginID,@"id":activityID};
    [[iTourAPIClient sharedClient] postPath:@"motion/subscribers" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//接受预约
+ (void)acceptSub:(NSString *)loginID withActivityID:(NSString *)activityID andUserID:(NSString *)subID success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = @{@"s":loginID,@"motionId":activityID,@"userId":subID};
    [[iTourAPIClient sharedClient] postPath:@"member/motion/accept" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSLog(@"%@",responseJson);
        
        
        SAFE_BLOCK_CALL(success, responseJson);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//删除预约
+ (void)deleteSub:(NSString *)loginID withActivityID:(NSString *)activityID andUserID:(NSString *)subID success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = @{@"s":loginID,@"motionId":activityID,@"userId":subID};
    [[iTourAPIClient sharedClient] postPath:@"member/motion/delete" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *errormsg = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"error"]];
        
        if ([errormsg isEqualToString:@"0"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

@end
