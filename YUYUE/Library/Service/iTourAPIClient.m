//
//  AFHTTPRequestOperation+iTourAPIClient.m
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import "iTourAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation iTourAPIClient

+(iTourAPIClient *)sharedClient {
    static iTourAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedClient = [[iTourAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _sharedClient;
}

+ (iTourAPIClient *)wxsharedClient{
    
    static iTourAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[iTourAPIClient alloc] initWithBaseURL:[NSURL URLWithString:WX_URL]];
    });
    
    return _sharedClient;
}

- (id)initPostWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self setDefaultHeader:@"Accept"value:@"application/json"];
    //设置提交的数据编码类型为json格式
    
    [self setParameterEncoding:AFFormURLParameterEncoding];
    return self;
}





@end
