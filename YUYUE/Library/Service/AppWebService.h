//
//  NSObject+AppWebService.h
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BaseURLString  @"http://m.yuti.cc/app/"
#define API_UPDATE_IMAGE @"member/modifyPhoto"


@interface AppWebService:NSObject

+ (NSString*)DataTOjsonString:(id)object;

//用户注册
+ (void)uesrRegister:(NSDictionary *)infoDIc success:(SuccessBlock)success failed:(FailedBlock)failed;

//用户登录
+ (void)userLoginWithAccount:(NSString *)loginname loginpwd:(NSString *)loginpwd success:(SuccessBlock)success failed:(FailedBlock)failed;

//三方登陆
+ (void)thirdLoginWithAccount:(NSDictionary *)infoDic success:(SuccessBlock)success failed:(FailedBlock)failed;

//用户登出
+ (void)logout:(NSString *)logCode success:(SuccessBlock)success failed:(FailedBlock)failed;

//用户详情
+ (void)getuserDetail:(NSString *)userid success:(SuccessBlock)success failed:(FailedBlock)failed;

//活动活动pic
+ (void)getActivitypicsuccess:(SuccessBlock)success failed:(FailedBlock)failed;

//获取活动(热门/最新)
+ (void)getNewAndHotActivitysuccess:(SuccessBlock)success failed:(FailedBlock)failed;

//活动详情
+ (void)getActivityDetail:(NSString *)activityID success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取活动评论
+ (void)getActivityComment:(NSString *)objectID objectType:(NSString *)type page:(NSString *)page success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取用户详情
+ (void)getUserInfo:(NSString *)userid success:(SuccessBlock)success failed:(FailedBlock)failed;

//提交评论
+ (void)addComment:(NSString *)loginID objectID:(NSString *)objectId objectType:(NSString *)type score:(NSString *)score content:(NSString *)content success:(SuccessBlock)success failed:(FailedBlock)failed;

//活动点赞
+ (void)praiseActivity:(NSString *)loginId objectId:(NSString *)objectId success:(SuccessBlock)success failed:(FailedBlock)failed;

//活动预约
+ (void)subscribeActivity:(NSString *)loginId motionId:(NSString *)motionId  realName:(NSString *)name mobile:(NSString *)mobile qq:(NSString *)qq success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取用户姓名
+ (void)getUseName:(NSString *)userid success:(SuccessBlock)success failed:(FailedBlock)failed;

//发布活动
+ (void)createActivity:(NSString *)loginId districtId:(NSString *)districtId schoolId:(NSString *)schoolId motionType:(NSString *)motionType name:(NSString *)name sportId:(NSString *)sportId motionPlace:(NSString *)motionPlace motionTime:(NSString *)motionTime payMode:(NSString *)payMode costMin:(NSString *)costMin costMax:(NSString *)costMax motionTarget:(NSString *)motionTarget attention:(NSString *)attention description:(NSString *)description contactPerson:(NSString *)contactPerson contactMobile:(NSString *)contactMobile :(NSString *)maxSubscribers success:(SuccessBlock)success failed:(FailedBlock)failed;

//发布活动simple
+ (void)createActivitySimple:(NSMutableDictionary *)dic loginId:(NSString *)loginId success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取地区id 获取学校id
+ (void)getIdType:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取推荐故事
+ (void)getRecommandStory:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取故事列表
+ (void)getStoryList:(NSString *)page success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取我的积分
+ (void)getMyScore:(NSString *)loginID success:(SuccessBlock)success failed:(FailedBlock)failed;

//修改个人信息
+ (void)modifyInfo:(NSDictionary *)dic success:(SuccessBlock)success failed:(FailedBlock)failed;

//上传图片
+ (void)modifyPhoto:(NSData *)imgData fileName:(NSString *)filename success:(SuccessBlock)success failed:(FailedBlock)failed;

//所有活动列表
+ (void)getAcitivity:(NSMutableDictionary *)dic success:(SuccessBlock)success failed:(FailedBlock)failed;

//签到
+ (void)userSign:(NSString *)loginID success:(SuccessBlock)success failed:(FailedBlock)failed;

//二级评论
+ (void)replyToSomeone:(NSString *)toID remarkID:(NSString *)remarkID content:(NSString *)content success:(SuccessBlock)success failed:(FailedBlock)failed;

//活动分享后回调
+ (void)shareDone:(NSString *)motionID success:(SuccessBlock)success failed:(FailedBlock)failed;

//uionid  https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
+ (void)getUionID:(NSString *)openID withToken:(NSString *)token success:(SuccessBlock)success failed:(FailedBlock)failed;

//getAccessToken
+ (void)getAccessToken:(NSString *)code success:(SuccessBlock)success failed:(FailedBlock)failed;

//refresh_token
+ (void)refresh_token:(NSString *)refreshtoken success:(SuccessBlock)success failed:(FailedBlock)failed;

//check access_token
+ (void)checkaccess_token:(NSString *)access_token withOpenId:(NSString *)openid success:(SuccessBlock)success failed:(FailedBlock)failed;

//我的活动
+ (void)getMyActivity:(NSString *)loginID success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取某个活动的预约人
+ (void)getmyActivitySubs:(NSString *)loginID withActivityID:(NSString *)activityID success:(SuccessBlock)success failed:(FailedBlock)failed;

+ (void)getmyActivitySubsNew:(NSString *)loginID withActivityID:(NSString *)activityID success:(SuccessBlock)success failed:(FailedBlock)failed;

//接受预约
+ (void)acceptSub:(NSString *)loginID withActivityID:(NSString *)activityID andUserID:(NSString *)subID success:(SuccessBlock)success failed:(FailedBlock)failed;

//删除预约
+ (void)deleteSub:(NSString *)loginID withActivityID:(NSString *)activityID andUserID:(NSString *)subID success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
