//
//  GymVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/20.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "GymVC.h"
#import "GymCell.h"
#import "DOPDropDownMenu.h"
#import "GymDetailVC.h"
#import "DropDownListView.h"


@interface GymVC ()<DropDownChooseDataSource,DropDownChooseDelegate>
{
    UITableView *gymTable;
    
    NSMutableArray *gymDetailArr;
    
    UISearchBar *search;
    
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    
    UIView *backview;
    
    NSMutableArray *chooseArray;
}

@end

@implementation GymVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    self.title = @"场馆精选";
    
    [self initData];
    
    [self initTable];
}

- (void)initData{
    NSDictionary *dic1 = @{@"title":@"山道健身会所（华科店）",@"image":@"img_1.jpg",@"address":@"华中科技大学东校区韵苑体育馆1楼",@"comment":@"暂无评价",@"proj":@"健身 其他",@"district":@"洪山区"};
    NSDictionary *dic2 = @{@"title":@"贝利美健身地质大学店",@"image":@"img_2.jpg",@"address":@"鲁磨路中国地质大学体育馆4楼",@"comment":@"暂无评价",@"proj":@"健身 其他",@"district":@"洪山区",@"discount":@[@{@"price":@"99",@"detail":@"单人包月套餐"}]};
    NSDictionary *dic3 = @{@"title":@"体限健身俱乐部地质大学店",@"image":@"img_3.jpg",@"address":@"鲁磨路388号中国地质大学北区超时楼上（近地大北综楼）",@"comment":@"暂无评价",@"proj":@"健身 其他",@"district":@"洪山区",@"discount":@[@{@"price":@"100",@"detail":@"办理会员卡冲100送50"},@{@"price":@"300",@"detail":@"充300送200优惠活动"}]};
    
    arr1 = [[NSMutableArray alloc]initWithObjects:@"全部地区",@"洪山区",@"武昌区",@"江汉区",@"江岸区",@"硚口区",@"汉阳区",@"东西湖区",@"青山区",@"江夏区",@"汉南区",@"黄陂区",@"新洲区",@"蔡甸区",@"其他", nil];
    
    arr2 = [[NSMutableArray alloc]initWithObjects:@"全部项目",@"羽毛球",@"乒乓球",@"网球",@"台球",@"游泳",@"健身",@"跑步",@"足球",@"篮球",@"舞蹈",@"瑜伽",@"武术",@"其他", nil];
    
    arr3 = [[NSMutableArray alloc]initWithObjects:@"默认排序",@"评价最好",@"人气最高", nil];
    
    gymDetailArr = [[NSMutableArray alloc]initWithObjects:dic1,dic2,dic3,nil];
    
}

- (void)initTable{
    
    //初始化search
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    search.tintColor =[UIColor whiteColor];
    search.placeholder = @"请输入场馆名称";
    [search setContentMode:UIViewContentModeLeft];
    
    if (IS_IOS_7) {
        [[[[search.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
        [search setBackgroundColor :[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
    }else {
        [[search.subviews objectAtIndex : 0 ] removeFromSuperview ];
        
        [search setBackgroundColor :[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
        search.tintColor = [UIColor colorWithRed:51 / 255.0 green:165 / 255.0 blue:219 / 255.0 alpha:1];
        
    }
    
    search.delegate = self;
    [backview addSubview:search];
    
    //初始化table
    gymTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    gymTable.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];;
    gymTable.delegate = self;
    gymTable.dataSource = self;
    [gymTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    gymTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //初始化下拉菜单
    
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   @[@"全部地区",@"洪山区",@"武昌区",@"江汉区",@"江岸区",@"硚口区",@"汉阳区",@"东西湖区",@"青山区",@"江夏区",@"汉南区",@"黄陂区",@"新洲区",@"蔡甸区",@"其他"],
                                                   @[@"全部项目",@"羽毛球",@"乒乓球",@"网球",@"台球",@"游泳",@"健身",@"跑步",@"足球",@"篮球",@"舞蹈",@"瑜伽",@"武术",@"其他"],
                                                   @[@"默认排序",@"评价最好",@"人气最高"]
                                                   ]];
    
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,45, SCREEN_WIDTH, 40) dataSource:self delegate:self];
    dropDownView.mSuperView = gymTable;
    dropDownView.mSearch = search;
    [backview addSubview:dropDownView];
    
    [gymTable setTableHeaderView:backview];
    
    [self.view addSubview:gymTable];
}

#pragma mark -- dropDownListDelegate
- (void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"孙大圣选了section:%ld ,index:%ld",(long)section,(long)index);
}

//- (void) tableviewShouldEnableScroll:(BOOL)enableScroll{
//    
//    gymTable.scrollEnabled = enableScroll;
//}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

#pragma mark- UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [search setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [search setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [search setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [search setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
//    gymTable.userInteractionEnabled = YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    gymTable.userInteractionEnabled = NO;
    [searchBar becomeFirstResponder];
}

#pragma mark- CommentBtnDelegate
- (void)subcommentbtnclicked:(NSInteger)sender{
    //点击优惠券
    
    //哪一个cell;
    NSInteger index = sender/100;
    //第几个优惠;
    NSInteger whichindex = sender%100;
    
    NSLog(@"%ld---%ld",(long)index,(long)whichindex);
    
}

#pragma mark- uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return gymDetailArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"gymcell";
    GymCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GymCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.delegate = self;
    
    [cell setCellDetail:[gymDetailArr objectAtIndex:indexPath.row] index:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[gymDetailArr objectAtIndex:indexPath.row]];
    
    if ([dic objectForKey:@"discount"]) {
        NSArray *arr = [[NSArray alloc]initWithArray:[dic objectForKey:@"discount"]];
        return 135+arr.count*40;
    }
    
    return 135;
}

#pragma mark- uitableviewdelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    GymDetailVC *gymDetail = [[GymDetailVC alloc]init];
    [self.navigationController pushViewController:gymDetail animated:YES];
}

#pragma mark- uiscrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [search resignFirstResponder];
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
