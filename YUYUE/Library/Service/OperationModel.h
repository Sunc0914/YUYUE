//
//  OperationModel.h
//  FlowMng
//
//  Created by tysoft on 14-4-8.
//  Copyright (c) 2014年 key. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationModel : NSObject


+(NSString *)getResultValueStr:(NSInteger )numValue; //处理结果
+(NSString *)getPaseStr:(NSInteger)statetype curstep:(NSString *)curstepStr; //处理状态
+(NSString *)getTaskNodePaseStr:(NSInteger)curStepNum currentStepStr:(NSString *)currentStepStr; //进行阶段
+(NSString *)getDealWay:(NSInteger)wayNum; //处理方式
+(NSString *)showIconImageView:(NSInteger)flowType;  //流程icon
+(NSString *)getFlowNum:(NSString *)typeName; //获取流程number
+(NSString *)getTypeName:(NSString *)typeNumber;

+(void)reFileName:(NSString *)exitPath otherPath:(NSString *)otherPath fileNum:(NSInteger)number; //文件重命名
@end
