//
//  RxWebViewController.h
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface RxWebViewController : UIViewController

/**
 *  origin url
 */
@property (nonatomic)NSURL* url;

/**
 *  embed webView
 */
@property (nonatomic)UIWebView* webView;

/**
 *  tint color of progress view
 */

@property (nonatomic)UIColor* progressViewColor;
/**
 @author Sunc, 15-12-09 10:12:11
 
 自定义四个属性变量
 */

@property (nonatomic, retain)NSString *urlStr;

@property (nonatomic, retain)NSString *webType;

@property (nonatomic, retain)NSString *idstr;

@property (nonatomic, assign)BOOL needLogin;

/**
 *  get instance with url
 *
 *  @param url url
 *
 *  @return instance
 */
-(instancetype)initWithUrl:(NSURL*)url;


-(void)reloadWebView;

@end



