//
//  QuestionVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/26.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "QuestionVC.h"

@interface QuestionVC ()
{
    UITableView *questionTable;
    
    NSDictionary *dic;
}

@end

@implementation QuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"问一问";
    
    [self initData];
    
    [self initTable];
}

- (void)initData{
    dic = @{@"image":@"nil",@"name":@"想旅游的陈美丽",@"age":@"90后",@"place":@"深圳",@"content":@"你们有什么号看的小说介绍吗",@"reply":@"141",@"favourite":@"3"};
}

- (void)initTable{
    questionTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-60)];
    [questionTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    questionTable.delegate = self;
    questionTable.dataSource = self;
    questionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:questionTable];
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 40)];
    btn.backgroundColor = [UIColor colorWithRed:245/255.0 green:103/255.0 blue:19/255.0 alpha:1.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"提问" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(askclicked) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    [back addSubview:btn];
    
}

- (void)askclicked{
    
}

#pragma mark- uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-70-20-20, 999) fontsize:12 text:[dic objectForKey:@"content"]];
    return 60+30+size.height+50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"question";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 70, 70)];
    image.layer.cornerRadius = image.bounds.size.height/2;
    image.backgroundColor = [UIColor orangeColor];
    [cell addSubview:image];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, SCREEN_WIDTH-80-10, 40)];
    nameLabel.text = @"爱旅游的陈美丽";
    [cell addSubview:nameLabel];
    
    UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, SCREEN_WIDTH-80-10, 30)];
    ageLabel.text = [NSString stringWithFormat:@"%@|%@",[dic objectForKey:@"age"],[dic objectForKey:@"place"]];
    [cell addSubview:ageLabel];
    
    CGSize size = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-70-20-20, 999) fontsize:12 text:[dic objectForKey:@"content"]];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 90, SCREEN_WIDTH-70-20-20, size.height)];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = [dic objectForKey:@"content"];
    [cell addSubview:contentLabel];
    
    CGFloat width = (SCREEN_WIDTH-80-10)/2;
    UILabel *replyLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, contentLabel.frame.origin.y+contentLabel.frame.size.height, width, 50)];
    replyLabel.text = [NSString stringWithFormat:@"回复（%@）",[dic objectForKey:@"reply"]];
    [cell addSubview:replyLabel];
    
    UILabel *favouriteLabel = [[UILabel alloc]initWithFrame:CGRectMake(80+width, contentLabel.frame.origin.y+contentLabel.frame.size.height, width, 50)];
    favouriteLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"favourite"]];
    [cell addSubview:favouriteLabel];
    
    return cell;
}
#pragma mark- uitableviewdelegate

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
