//
//  UserInfoVC.m
//  YUYUE
//
//  Created by Sunc on 15/9/30.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "UserInfoVC.h"
#import "NJKWebViewProgressView.h"
@implementation UserInfoVC
{
    UIWebView *webView;
    NJKWebViewProgressView *progressView;
    NJKWebViewProgress *progressProxy;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"用户信息";
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    [self.view addSubview:webView];
    
    progressProxy = [[NJKWebViewProgress alloc] init];
    webView.delegate = progressProxy;
    progressView.progressColor = [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
    progressProxy.webViewProxyDelegate = self;
    progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self loadGoogle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [progressView removeFromSuperview];
}

-(void)loadGoogle
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/user/%@",_userID]]];
    [webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [progressView setProgress:progress animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
