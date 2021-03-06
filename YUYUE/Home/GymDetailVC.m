//
//  GymDetailVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/21.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "GymDetailVC.h"
#import "SDCycleScrollView.h"
#import "SFTag.h"
#import "SFTagView.h"
#import "HexColors.h"
#import "UIHyperlinksButton.h"

@interface GymDetailVC ()<SDCycleScrollViewDelegate,UIActionSheetDelegate>
{
    UITableView *gymDetailTable;
    
    NSMutableArray *imageArr;
    
    NSMutableDictionary *gymDetailDic;
    
    NSArray *colorPool;
    
    NSMutableArray *tagArr;
}

@property (strong, nonatomic) SFTagView *serviceTagView;

@property (strong, nonatomic) SFTagView *specialTagView;

@end

@implementation GymDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"场馆详情";
    
    [self initData];
    
    [self initTable];
}

- (void)initData{
    
    colorPool = @[@"#7ecef4", @"#84ccc9", @"#88abda",@"#7dc1dd",@"#b6b8de"];
    
    imageArr = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"gym_1.jpg"],[UIImage imageNamed:@"gym_2.jpg"],[UIImage imageNamed:@"gym_3.jpg"],nil];
    
    gymDetailDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"support":@"健身 其他",@"address":@"鲁磨路388号中国地质大学北区超市楼上（近地大北综楼）",@"tele":@"027-87680600",@"discount":@[@{@"price":@"100",@"detail":@"办理会员卡冲100送50"},@{@"price":@"300",@"detail":@"充300送200优惠活动"}],@"title":@"体限健身俱乐部地质大学店",@"introduction":@"体限健身管理有限公司是一家集健身、休闲、娱乐为一体的专业健身管理咨询公司，公司采用连锁化经营，把专业的健身理念和服务传递给每一位热爱健身的朋友。“您身边的健身专家”正是体现对健身理念和文化的深入诠释。会所引进国际顶级的健身设备，营造优雅精致的氛围，不仅提供最卓越的硬件环境，更有一支高素质、专业化、知识化的管理团队把最专业的健身服务带给每一位会员，帮助健身文化更好地成长为一个时尚的焦点，体限也将致力成为最具竞争力的健身品牌。会所营业面积从1000平米，设有器械训练区、有氧大操房、动感单车房、热瑜伽房、武道区、等。体限俱乐部是为人们带来健康的产业，其地位和重要性却不言而喻。因此，体限俱乐部始终遵循着“为折射健康人生”而努力奋斗的企业宗旨，投身并奉献于于这个健康、阳光的产业。",@"service":@[@"储物柜",@"场馆卖品",@"洗浴设施",@"休息区域",@"空调",@"会员卡"],@"special":@[@"交通便利",@"停车方便"],@"price":@"9.9元三次"}];
    
    [self setupServiceTagView];
    
    [self setupSpecialTagView];
}

- (void)initTable{
    gymDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    gymDetailTable.delegate = self;
    gymDetailTable.dataSource = self;
    [gymDetailTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    gymDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:gymDetailTable];
    
    SDCycleScrollView *gymCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_WIDTH/640*280) imagesGroup:imageArr];
    gymCycleScrollView.delegate = self;
    gymCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    gymCycleScrollView.autoScrollTimeInterval = 3.0f;
    gymCycleScrollView.infiniteLoop = YES;
    gymCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, gymCycleScrollView.frame.size.height-30, SCREEN_WIDTH, 30)];
    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.alpha = 0.5f;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"体限健身俱乐部地质大学店";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [gymCycleScrollView addSubview:titleLabel];
    
    [gymDetailTable setTableHeaderView:gymCycleScrollView];
}

- (void)setupServiceTagView
{
    
    NSArray *texts = [[NSArray alloc]initWithArray:[gymDetailDic objectForKey:@"service"]];
    
    _serviceTagView = [[SFTagView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 0)];
    [_serviceTagView setBackgroundColor:[UIColor whiteColor]];
    
    _serviceTagView.margin    = UIEdgeInsetsMake(10, 3, 10, 3);
    _serviceTagView.insets    = 5;
    _serviceTagView.lineSpace = 5;
    
    [texts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SFTag *tag = [SFTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.bgColor   = [UIColor colorWithHexString:colorPool[idx % colorPool.count]];
         tag.cornerRadius = 3;
         
         [self.serviceTagView addTag:tag];
     }];
    
}

- (void)setupSpecialTagView
{
    
    NSArray *texts = [[NSArray alloc]initWithArray:[gymDetailDic objectForKey:@"special"]];
    
     _specialTagView = [[SFTagView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 0)];
    [_specialTagView setBackgroundColor:[UIColor whiteColor]];
    
    _specialTagView.margin    = UIEdgeInsetsMake(10, 3, 10, 3);
    _specialTagView.insets    = 5;
    _specialTagView.lineSpace = 5;
    
    [texts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SFTag *tag = [SFTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.bgColor   = [UIColor colorWithHexString:colorPool[idx % colorPool.count]];
         tag.cornerRadius = 3;
         
         [self.specialTagView addTag:tag];
     }];
    
}

- (void)labelClicked:(UIHyperlinksButton*)lable
{
    NSString* phone=lable.accessibilityLabel;
    
    //拨打电话
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拨打电话"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.accessibilityLabel=phone;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}



#pragma mark - SDCycleScrollView
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

#pragma mark- uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        //支持项目
        return 35+40+40+10;
    }
    else if (indexPath.row == 1)
    {
        //优惠券
        NSMutableArray *discountArr = [[NSMutableArray alloc]init];
        discountArr = [gymDetailDic objectForKey:@"discount"];
        if (discountArr.count>0) {
            return 35+discountArr.count*30+10+10;
        }
        else{
            return 35+10+10;
        }
    }
    else if (indexPath.row == 2){
        //场馆介绍
        CGSize introductionSize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-10, 999) fontsize:12 text:[gymDetailDic objectForKey:@"introduction"]];
        return 35+introductionSize.height+20+10+10;
    }
    else if (indexPath.row == 3){
        //场馆服务
        NSLog(@"%f",self.serviceTagView.frame.size.height);
        return 35+self.serviceTagView.frame.size.height+10;
    }
    else if (indexPath.row == 4){
        //场馆特色
        return 35+self.specialTagView.frame.size.height+10;
    }
    else if (indexPath.row == 5){
        //场馆价格
        return 35+30+10+10;
    }
    else if (indexPath.row == 6){
        //用户评价
        return 35+110+20;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"gymdetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row == 0) {
        
        //支持项目
        UILabel *supportLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 35)];
        supportLabel.text = [NSString stringWithFormat:@"支持项目：%@",[gymDetailDic objectForKey:@"support"]];
        supportLabel.font = [UIFont systemFontOfSize:14];
        supportLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        supportLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:supportLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 35, SCREEN_WIDTH-35-5, 40)];
        addressLabel.text = [gymDetailDic objectForKey:@"address"];
        addressLabel.font = [UIFont systemFontOfSize:12];
        addressLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        addressLabel.numberOfLines = 2;
        addressLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:addressLabel];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(35, 74, SCREEN_WIDTH-35, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
        UIHyperlinksButton* teleLbale1=[[UIHyperlinksButton alloc]initWithFrame:CGRectMake(35, 75, SCREEN_WIDTH-35-10, 40)];
        teleLbale1.titleLabel.font =[UIFont systemFontOfSize:12];
        [teleLbale1 setTitle:@"电话：027-87680600" forState:UIControlStateNormal];
        teleLbale1.accessibilityLabel=@"027-87680600";
        [teleLbale1 setColor:[UIColor blueColor]];
        [teleLbale1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [teleLbale1 setBackgroundColor:[UIColor clearColor]];
        teleLbale1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [teleLbale1 addTarget:self action:@selector(labelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:teleLbale1];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
    }
    else if (indexPath.row == 1){
        //优惠券
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-10-35, 35)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        titleLabel.text = @"优惠券";
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 34, SCREEN_WIDTH-10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:135/255.0 green:212/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
        NSMutableArray *discountArr = [[NSMutableArray alloc]init];
        discountArr = [gymDetailDic objectForKey:@"discount"];
        
        if (discountArr.count>0) {
            for (int i = 0; i<discountArr.count; i++) {
                
                NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[discountArr objectAtIndex:i]];
                
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,5+i*40+35, 60, 30)];
                priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
                priceLabel.textColor = [UIColor colorWithRed:246/255.0 green:70/255.0 blue:0/255.0 alpha:1.0];
                priceLabel.userInteractionEnabled = YES;
                [cell addSubview:priceLabel];
                
                UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 5+i*40+35, SCREEN_WIDTH-70, 30)];
                detailLabel.text = [dic objectForKey:@"detail"];
                detailLabel.userInteractionEnabled = YES;
                detailLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
                detailLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:detailLabel];
                
                if (i<discountArr.count-1) {
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 39+i*40+34, SCREEN_WIDTH-10, 1)];
                    line.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
                    [cell addSubview:line];
                }
            }
        }
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+discountArr.count*30+10, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
    }
    else if (indexPath.row == 2){
        //场馆信息
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-35-10, 35)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        titleLabel.text = @"场馆信息";
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 34, SCREEN_WIDTH-10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:135/255.0 green:212/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
        UILabel *gymTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, SCREEN_WIDTH-10, 20)];
        gymTitleLabel.font = [UIFont systemFontOfSize:12];
        gymTitleLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        gymTitleLabel.text = [gymDetailDic objectForKey:@"title"];
        [cell addSubview:gymTitleLabel];
        
        CGSize introductionSize = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-10, 999) fontsize:12 text:[gymDetailDic objectForKey:@"introduction"]];
        
        UILabel *introLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, SCREEN_WIDTH-10, introductionSize.height)];
        introLabel.numberOfLines = 0;
        introLabel.lineBreakMode = NSLineBreakByWordWrapping;
        introLabel.font = [UIFont systemFontOfSize:12];
        introLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        introLabel.text = [gymDetailDic objectForKey:@"introduction"];
        [cell addSubview:introLabel];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+introductionSize.height+20+10, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
    }
    else if (indexPath.row == 3){
        //场馆服务
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-35-10, 35)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        titleLabel.text = @"场馆服务";
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 34, SCREEN_WIDTH-10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:135/255.0 green:212/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
        [cell addSubview:self.serviceTagView];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+self.serviceTagView.frame.size.height, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
    }
    else if (indexPath.row == 4){
        //场馆特色
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-35-10, 35)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        titleLabel.text = @"场馆特色";
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 34, SCREEN_WIDTH-10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:135/255.0 green:212/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
        [cell addSubview:self.specialTagView];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+self.specialTagView.frame.size.height, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
    }
    else if (indexPath.row == 5){
        //场馆价格
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-35-10, 35)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        titleLabel.text = @"场馆价格";
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 34, SCREEN_WIDTH-10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:135/255.0 green:212/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, SCREEN_WIDTH, 30)];
        priceLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        priceLabel.text = [gymDetailDic objectForKey:@"price"];
        [cell addSubview:priceLabel];
        
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+30+10, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
    }
    else {
        //用户评价
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH-35-10, 35)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        titleLabel.text = @"用户评价（共0条）：";
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 34, SCREEN_WIDTH-10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:135/255.0 green:212/255.0 blue:229/255.0 alpha:1.0];
        [cell addSubview:lineView];
        
    }
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
