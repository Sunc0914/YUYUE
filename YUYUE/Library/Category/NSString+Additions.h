//
//  NSString+Additions.h
//  FeinnoShareLibrary
//
//  Created by Michael.Tan on 12-8-30.
//  Copyright (c) 2012年 Feinno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Additions)

// 编码
- (NSString *) base64StringEncode;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

// 解码
- (NSString *) base64StringDecode;
+ (NSData *) base64DataFromString:(NSString *)string;

// MD5
- (NSString *)MD5;

- (BOOL)isEmpty;

- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;
+ (NSString*)localizedString:(NSString*)key;
+ (NSString*)base64encode:(NSString*)str;

@end
