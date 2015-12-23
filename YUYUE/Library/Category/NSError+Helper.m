//
//  NSError+Helper.m
//  AirMenu
//
//  Created by yangxh yang on 11-8-18.
//  Copyright 2011年 codans. All rights reserved.
//

#import "NSError+Helper.h"

@implementation NSError (NSError_Helper)

+ (NSError *)errorWithMsg:(NSString *)msg
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:msg?:@"发生错误!", NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:@"ERROR DOMAIN" code:-1000 userInfo:userInfo];
}

@end
