//
//  Functions.h
//  AirQueue
//
//  Created by zppro on 11-8-4.
//  Copyright 2011 codans. All rights reserved.
//
 

#import <Foundation/Foundation.h> 


void ShowInfo(NSString* message);

void ShowError(NSString* message);

NSString* FormatNullString(NSString* formatString);

NSString* GetCurrentDateString(NSString* formatString);

NSString* GetDateString(NSDate* date, NSString* formatString);

NSString* GetMonthName(NSDate* date,NSLocale* locale);

NSString* GetMonthAbbrName(NSDate* date,NSLocale* locale);

NSString* GetWeekName(NSDate* date,NSLocale* locale);

NSString* GetWeekAttrName(NSDate* date,NSLocale* locale);

NSDate* ParseDateFromJsonStr(NSString *json);

NSString* ParseDateToJsonStr(NSDate *date);

NSDate* ParseDateFromString(NSString *dateString);

NSDate* ParseDateFromStringFormat(NSString *dateString, NSString* formatString);
 

NSString* ConvertToStringFromDateTime(NSString* jsonDateTime);

NSNumber* ConvertToNumber(NSString* numberString);

NSString* ConvertToDistanceString(double distance);

id GetNextResponserToSelctor(id occurViewOrController, SEL selector);

id GetFirstResponser(id occurViewOrController);

BOOL IsValidMobile(NSString* mobile);

BOOL IsValidMobileByError(NSString* mobile,NSString** error);

BOOL IsNilOrEmpty(id obj);

BOOL isPureInt(NSString * input);
BOOL isPureFloat(NSString * input);

NSString* ConvertToTimeStringFromSecondString(double seconds);
 