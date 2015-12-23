//
//  NSUserDefaults+Standard.h
//  FoursquareIntegration
//
//  Created by Andreas Katzian on 07.08.10.
//  Copyright 2010 Blackwhale GmbH. All rights reserved.
//
//  A simple wrapper category for NSUserDefaults to provide
//  some common methods to read and write default values.
//


@interface NSUserDefaults (Standard)

//read/wrtie bool values
+ (void) setBool:(BOOL) value forKey:(NSString*) key;
+ (BOOL) boolForKey:(NSString*) key;

//read/write string values
+ (void) setString:(NSString*) value forKey:(NSString*) key;
+ (NSString*) stringForKey:(NSString*) key;

//read/write int values
+ (void) setInt:(int)value forKey:(NSString*)key;
+ (long) intForKey:(NSString*)key;

// register
+ (void)registerDefaultValueWithTestKey:(NSString *)key;

+ (void)setUserObject:(id)object forKey:(id)key;

+ (id)objectUserForKey:(id)key;

+ (void)removeObjectForKey:(id)key;

+ (id) wjReadFileForFileName: (NSString *)fileName;

+ (void) wjWriteFileObject:(id)object forFileName:(NSString *)fileName;
@end
