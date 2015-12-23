//
//  MacroFunctions.h
//  FeinnoShareLibrary
//
//  Created by Michael.Tan on 12-8-31.
//  Copyright (c) 2012年 Feinno. All rights reserved.
//

// MARK: - Block Helper
#if NS_BLOCKS_AVAILABLE

typedef void (^CompletionBlock)(NSDictionary *dict);
typedef void (^SuccessBlock)(id result);
typedef void (^FailedBlock)(NSError *error);
typedef void (^FinalBlock)(void);

#define SAFE_BLOCK_CALL_NO_P(b) (b == nil ?: b())
#define SAFE_BLOCK_CALL(b, p) (b == nil ? : b(p) )
#define SAFE_BLOCK_CALL_2_P(b, p1, p2) (b == nil ? : b(p1, p2))

#endif

//字符串
#define MF_Trim(x) [x stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
#define MF_SWF(FORMAT, ...) [NSString stringWithFormat:FORMAT, __VA_ARGS__]
#define MF_Replace(raw,f,r) [raw stringByReplacingOccurrencesOfString:f withString:r]

//颜色
#define MF_ColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define MF_ColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define MF_ColorFromRGBA2(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define MF_ColorFromString(x) MF_ColorFromRGB(\
[MF_Trim([[[x substringWithRange:NSMakeRange(1, [x length]-1)] componentsSeparatedByString:@","] objectAtIndex:0]) floatValue], \
[MF_Trim([[[x substringWithRange:NSMakeRange(1, [x length]-1)] componentsSeparatedByString:@","] objectAtIndex:1]) floatValue], \
[MF_Trim([[[x substringWithRange:NSMakeRange(1, [x length]-1)] componentsSeparatedByString:@","] objectAtIndex:2]) floatValue])

#define MF_StringFromColor(color) [NSString stringWithFormat:@"{%d,%d,%d}",\
[[[[NSString stringWithFormat:@"%@",color] componentsSeparatedByString:@" "] objectAtIndex:1] intValue] * 255,\
[[[[NSString stringWithFormat:@"%@",color] componentsSeparatedByString:@" "] objectAtIndex:2] intValue] * 255,\
[[[[NSString stringWithFormat:@"%@",color] componentsSeparatedByString:@" "] objectAtIndex:3] intValue] * 255]

//资源
#define MF_PngWithSkin(skin, name) [FResourceManager getImageWithName:name andSkinName:skin]
#define MF_Png(name) [FResourceManager getImageWithName:name]
#define MF_Resource(name) [FResourceManager getResourcePath:name]
#define MF_Plist(name) [FResourceManager getResourcePath:[NSString stringWithFormat:@"%@.plist",name]]
#define MF_PngFromMainBundle(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]

//file
#define MF_ResourceDocument() [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Documents"]
#define MF_DocumentFolder() [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define MF_FileExists(fullPath) [[NSFileManager defaultManager] fileExistsAtPath:fullPath]

//通知处理
#define addN(_selector,_name)\
([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:nil])

#define removeNObserverWithName(_name)\
([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])

#define removeNObserver() ([[NSNotificationCenter defaultCenter] removeObserver:self])

#define postN(_name)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:nil])

#define postNWithObj(_name,_obj)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:nil])

#define postNWithInfos(_name,_obj,_infos)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:_infos])

// MARK: - String Helper
#define NULL_STR(str, default) (str ?: default)
#define EMPTY_STR(str, default) (str ? (str.length == 0 ? default : str ) : default)
#define NULL_STR_DEFAULT_TO_EMPTY(str) NULL_STR(str, @"")
#define NULL_ARRAY_DEFAULT_TO_EMPTY(o, default) (o ?: default)
#define SI(i) [NSString stringWithFormat:@"%d", i]
#define SNI(ni) [NSString stringWithFormat:@"%d", [ni intValue]]
#define S_A_T(a,t) [NSString stringWithFormat:@"%d/%d", a,t]
#define joinStr( s, ... ) [NSString stringWithFormat:(s), ##__VA_ARGS__]