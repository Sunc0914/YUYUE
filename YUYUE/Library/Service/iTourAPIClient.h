//
//  AFHTTPRequestOperation+iTourAPIClient.h
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

#define BASE_URL @"http://m.yuti.cc/app/"
#define WX_URL @"https://api.weixin.qq.com/"
#define SERVER_ERROR @"网络异常"

@interface iTourAPIClient:AFHTTPClient

+ (iTourAPIClient *)sharedClient;

+ (iTourAPIClient *)wxsharedClient;

@end
