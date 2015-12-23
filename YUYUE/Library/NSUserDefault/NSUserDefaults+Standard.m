//
//  NSUserDefaults+Standard.m
//  FoursquareIntegration
//
//  Created by Andreas Katzian on 07.08.10.
//  Copyright 2010 Blackwhale GmbH. All rights reserved.
//

#import "NSUserDefaults+Standard.h"


@implementation NSUserDefaults (Standard)


+ (void) setBool:(BOOL) value forKey:(NSString*) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:value forKey:key];
	[defaults synchronize];
}

+ (BOOL) boolForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


+ (void) setObject:(id) value forKey:(NSString*) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:value forKey:key];
	[defaults synchronize];
}


+ (void) setString:(NSString*) value forKey:(NSString*) key
{
	[NSUserDefaults setObject:value forKey:key];
}

+ (NSString*) stringForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (void)setInt:(int)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+ (long)intForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)registerDefaultValueWithTestKey:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults) {
        val = [standardUserDefaults valueForKey:key];
    }
    
    if (val == nil) {
        NSString *bPath = [[NSBundle mainBundle] bundlePath];
        NSString *settingPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *plistPath = [settingPath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
        NSDictionary *item;
        for (item in preferencesArray) {
            NSString *keyValue = [item objectForKey:@"Key"];
            
            id defaultValue = [item objectForKey:@"DefaultValue"];
            
            if (keyValue && defaultValue) {
                [standardUserDefaults setObject:defaultValue forKey:keyValue];
            }
        }
        [standardUserDefaults synchronize];
    }
}

+ (void)setUserObject:(id)object forKey:(id)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectUserForKey:(id)key
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return nil;
}

+ (void)removeObjectForKey:(id)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) wjWriteFileObject:(id)object forFileName:(NSString *)fileName
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *DocumentPath =[documentPaths objectAtIndex:0];
    NSString *fileURL = [NSString stringWithFormat:@"%@/%@", DocumentPath, fileName];
    NSData *fileData = [NSKeyedArchiver archivedDataWithRootObject:object];
    if ([fileData writeToFile:fileURL atomically:YES]) {
        NSLog(@"添加购物车成功!");
    }
}

+ (id) wjReadFileForFileName: (NSString *)fileName
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *DocumentPath =[documentPaths objectAtIndex:0];
    NSString *Name = [NSString stringWithFormat:@"%@/%@", DocumentPath, fileName];
    NSData *data = [[NSData alloc] initWithContentsOfFile:Name];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


@end
