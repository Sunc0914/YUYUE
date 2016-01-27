//
//  PublishActivityVC.m
//  YUYUE
//
//  Created by Sunc on 15/12/27.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "PublishActivityVC.h"
#import "Masonry.h"

@interface PublishActivityVC ()
{
    UIScrollView *publishScrollView;
}

@end

@implementation PublishActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backGroundColor;
    [self initScrollView];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)initScrollView{
    WS(ws);
    publishScrollView = [UIScrollView new];
    [self.view addSubview:publishScrollView];
    UIView *containerView = [UIView new];
    [publishScrollView addSubview:containerView];
    publishScrollView.pagingEnabled = YES;
    
    [publishScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(upsideheight);
        make.bottom.left.right.equalTo(ws.view);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(publishScrollView);
        make.width.equalTo(publishScrollView).multipliedBy(3.0);
    }];
    
    containerView.backgroundColor = [UIColor clearColor];
//    publishScrollView.backgroundColor = [UIColor greenColor];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    view1.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    view2.backgroundColor = [UIColor greenColor];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    view3.backgroundColor = [UIColor yellowColor];
    
    [containerView addSubview:view1];
    [containerView addSubview:view2];
    [containerView addSubview:view3];
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
