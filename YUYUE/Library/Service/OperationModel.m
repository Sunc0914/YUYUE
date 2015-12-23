//
//  OperationModel.m
//  FlowMng
//
//  Created by tysoft on 14-4-8.
//  Copyright (c) 2014年 key. All rights reserved.
//

#import "OperationModel.h"

@implementation OperationModel

+(NSString *)getResultValueStr:(NSInteger )numValue{
    NSString *resultStr = @"";
    switch (numValue) {
        case 0:
           resultStr = [NSString stringWithFormat:@"等待审批"];
            break;
        case 1:
            resultStr = [NSString stringWithFormat:@"等待发送邮件"];
            break;
        case 2:
            resultStr = [NSString stringWithFormat:@"等待下载文件"];
            break;
        case 3:
            resultStr = [NSString stringWithFormat:@"等待恢复在线策略"];
            break;
        case 4:
            resultStr = [NSString stringWithFormat:@"等待激活离线使用"];
            break;
        case 5:
            resultStr = [NSString stringWithFormat:@"审批通过"];
            break;
        case 6:
            resultStr  = [NSString stringWithFormat:@"审批拒绝"];
            break;
        case 7:
            resultStr = [NSString stringWithFormat:@"下载文件完成"];
            break;
        case 8:
            resultStr = [NSString stringWithFormat:@"离线使用完成"];
            break;
        case 9:
            resultStr = [NSString stringWithFormat:@"发送邮件完成"];
            break;
        default:
            break;
    }
    return resultStr;

}

+(NSString *)getPaseStr:(NSInteger)statetype curstep:(NSString *)curstepStr {
    NSString *resultStr = @"";
    switch (statetype) {
        case 0:
            resultStr = [NSString stringWithFormat:@"等待第%@级审批", curstepStr];
            break;
        case 1:
            resultStr = [NSString stringWithFormat:@"第%@级审批未通过", curstepStr];
            break;
        case 2:
            resultStr = [NSString stringWithFormat:@"等待下载文件"];
            break;
        case 3:
            resultStr = [NSString stringWithFormat:@"等待发送邮件"];
            break;
        case 4:
            resultStr = [NSString stringWithFormat:@"下载文件完成"];
            break;
        case 5:
            resultStr = [NSString stringWithFormat:@"发送邮件完成"];
            break;
        case 6:
            resultStr = [NSString stringWithFormat:@"等待离线使用完成"];
            break;
        case 7:
            resultStr = [NSString stringWithFormat:@"离线使用完成"];
            break;
        default:
            break;
    }
    return resultStr;

}

+(NSString *)getTaskNodePaseStr:(NSInteger)curStepNum currentStepStr:(NSString *)currentStepStr{
    NSString *resultStr = @"";
    switch (curStepNum) {
        case 0:
            resultStr = [NSString stringWithFormat:@"第%@级审批", currentStepStr];
            break;
        case 1:
            resultStr = [NSString stringWithFormat:@"发送邮件"];
            break;
        case 2:
            resultStr = [NSString stringWithFormat:@"下载文件"];
            break;
        case 3:
            resultStr = [NSString stringWithFormat:@"离线使用"];
            break;
        default:
            break;
    }
    return resultStr;
}

+(NSString *)getDealWay:(NSInteger)wayNum {
    NSString *resultStr = @"";
    switch (wayNum) {
        case 0:
            resultStr = [NSString stringWithFormat:@"单人通过即可"];
            break;
        case 1:
            resultStr = [NSString stringWithFormat:@"所有人都要通过"];
            break;
        default:
            break;
    }
    return resultStr;
}

+(NSString *)getTypeName:(NSString *)typeNumber {
    NSString *resultStr = @"";
    if ([typeNumber isEqualToString:@"0"]) {
        resultStr = @"解密流程";
    }
    if ([typeNumber isEqualToString:@"1"]) {
        resultStr = @"文件转换流程";
    }
    if ([typeNumber isEqualToString:@"2"]) {
        resultStr = @"打印流程";
    }
//    if ([typeNumber isEqualToString:@"传送流程"]) {
//        resultStr = @"3";
//    }
//    if ([typeNumber isEqualToString:@"离线加解密授权流程"]) {
//        resultStr = @"5";
//    }
//    if ([typeNumber isEqualToString:@"离线客户端流程"]) {
//        resultStr = @"6";
//    }
    return resultStr;
}

+(NSString *)getFlowNum:(NSString *)typeName{
    NSString *resultStr = @"";
    if ([typeName isEqualToString:@"解密流程"]) {
        resultStr = @"0";
    }
    if ([typeName isEqualToString:@"文件转换流程"]) {
        resultStr = @"1";
    }
    if ([typeName isEqualToString:@"打印流程"]) {
        resultStr = @"2";
    }
    if ([typeName isEqualToString:@"传送流程"]) {
        resultStr = @"3";
    }
    if ([typeName isEqualToString:@"离线加解密授权流程"]) {
        resultStr = @"5";
    }
    if ([typeName isEqualToString:@"离线客户端流程"]) {
        resultStr = @"6";
    }
    return resultStr;
}

+(NSString *)showIconImageView:(NSInteger)flowType{
    NSString *resultStr = @"";
    switch (flowType) {
        case 0: //解密流程
            resultStr = @"icon_decipher";
            break;
        case 1: //转换流程
            resultStr = @"icon_transform";
            break;
        case 2: //打印流程
            resultStr = @"icon_mimeograph";
            break;
        case 3: //传送流程
            resultStr = @"icon_deliver";
            break;
        case 4: //外发流程
            resultStr = @"icon_decipher";
            break;
        case 5: //离线加解密流程
            resultStr = @"icon_impower";
            break;
        case 6: //离线客户端流程
            resultStr = @"icon_client";
            break;
        default:
            break;
    }

    return resultStr;
}

+(void)reFileName:(NSString *)exitPath otherPath:(NSString *)otherPath fileNum:(NSInteger)number{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    NSError *error = nil;
    NSMutableArray *fileList = [[NSMutableArray alloc]init];
    [fileList addObjectsFromArray:[fileManager contentsOfDirectoryAtPath:otherPath error:&error]];
    for (NSString *file in fileList) {
        NSString *path = [exitPath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (!isDir) {
            NSLog(@"%@",path);
            if (![fileManager fileExistsAtPath:path]) {
                NSLog(@"不存在，移动文件");
                NSString *movePath = [otherPath stringByAppendingPathComponent:file];
                [fileManager moveItemAtPath:movePath toPath:path error:nil];
                number = 1;
            }else {
                NSString *fileName = [file stringByDeletingPathExtension];
                NSString *exestr = [file pathExtension];
                NSRange range = [fileName rangeOfString:@"("];///匹配得到的下标
                NSLog(@"%@",NSStringFromRange(range));
                if (range.length > 0) {
                    fileName = [fileName substringToIndex:range.location];
                }
                NSString *newfile = [NSString stringWithFormat:@"%@(%d).%@", fileName, number, exestr];
                NSString *movePath = [otherPath stringByAppendingPathComponent:newfile];
         
                NSString *oldPath = [otherPath stringByAppendingPathComponent:file];
                [fileManager moveItemAtPath:oldPath toPath:movePath error:nil];
                [self reFileName:exitPath otherPath:otherPath fileNum:++number];
                break;
            }
        }else {
            
        }
    }

}


@end
