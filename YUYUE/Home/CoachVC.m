//
//  CoachVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/15.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "CoachVC.h"
#import "CoachTableViewCell.h"
#import "CoachDetailVC.h"

@interface CoachVC ()
{
    UIScrollView *scrollView;
    
    UITableView *coachTable;
    
    NSMutableArray *coachDetailArr;
    
    NSMutableArray *sportsArr;
    
    UIView *indicator;
    
    NSMutableArray *btnArr;
    
    CGFloat width;
}

@end

@implementation CoachVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"教练";
    
    [self initData];
    
    [self initScrollView];
    
    [self initTable];
    
}

- (void)initData{
    
    coachDetailArr = [[NSMutableArray alloc]init];
    
    NSDictionary *temdic = [[NSDictionary alloc]initWithObjectsAndKeys:@"image1",@"image",@"female",@"sex",@"李霞（职业教练）",@"title",@"5人评价",@"numofcomments",@"羽毛球 提供器材",@"describe",@"200元/时",@"charge", nil];
    NSDictionary *temdic1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"image1",@"image",@"female",@"sex",@"李霞（职业教练）",@"title",@"10人评价",@"numofcomments",@"羽毛球 提供器材",@"describe",@"200元/时",@"charge", nil];
    
    sportsArr = [[NSMutableArray alloc]initWithObjects:@"推荐",@"羽毛球",@"乒乓球",@"网球",@"台球",@"游泳",@"健身",@"跑步",@"足球",@"篮球",@"舞蹈",@"瑜伽",@"武术",@"其他", nil];
    
    btnArr = [[NSMutableArray alloc]init];
    
    [coachDetailArr addObject:temdic];
    [coachDetailArr addObject:temdic1];
    
}

- (void)initScrollView{
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, 40)];
    
    scrollView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    
    scrollView.delegate = self;
    
    width = SCREEN_WIDTH/5;
    
    scrollView.contentSize = CGSizeMake(width*sportsArr.count, 40);
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.pagingEnabled = NO;
    
    for (int i = 0; i<sportsArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, 40)];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [btn setTitle:[sportsArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:69/255.0 green:166/255.0 blue:233/255.0 alpha:1.0] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if(i == 0){
            btn.selected = YES;
            btn.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        }
        
        [btnArr addObject:btn];
        
        [scrollView addSubview:btn];
        
    }
    
    indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 38, width, 2)];
    indicator.backgroundColor = [UIColor colorWithRed:69/255.0 green:166/255.0 blue:233/255.0 alpha:1.0];
    [scrollView addSubview:indicator];
    
    [self.view addSubview:scrollView];
}

- (void)initTable{
    
    coachTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40+upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-40)];
    coachTable.delegate = self;
    coachTable.dataSource = self;
    
    coachTable.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    coachTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [coachTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [self.view addSubview:coachTable];
}

#pragma mark -btn
-(void)btnclicked:(UIButton *)sender{
    
    for (int i = 0; i<btnArr.count; i++) {
        if (i == sender.tag) {
            sender.selected = YES;
            sender.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        }
        else{
            UIButton *temBtn = [[UIButton alloc]init];
            temBtn = [btnArr objectAtIndex:i];
            temBtn.selected = NO;
            temBtn.transform = CGAffineTransformIdentity;
        }
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        if (sender.tag<3) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if (sender.tag>btnArr.count-3){
            scrollView.contentOffset = CGPointMake((btnArr.count-5)*width, 0);
        }
        else{
            scrollView.contentOffset = CGPointMake((sender.tag-2)*width, 0);
        }
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            indicator.frame = CGRectMake(width*sender.tag, 38, width, 2);
        }];
    }];
    
    [coachTable reloadData];
}

#pragma mark -uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return coachDetailArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"coach";
    CoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CoachTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setCellInfo:[coachDetailArr objectAtIndex:indexPath.section]];
    
    return cell;
}

#pragma mark -uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    CoachDetailVC *coachDetail = [[CoachDetailVC alloc]init];
    coachDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coachDetail animated:YES];
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
