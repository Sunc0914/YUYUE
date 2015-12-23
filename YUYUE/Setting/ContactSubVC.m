//
//  ContactSubVC.m
//  YUYUE
//
//  Created by Sunc on 15/12/21.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "ContactSubVC.h"
#import "Masonry.h"
#import "UIButton+WebCache.h"
#import "HTCopyableLabel.h"

@interface ContactSubVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIActionSheet *myActionSheet;
    NSString *currentStr;
}

@property (nonatomic, retain)UITableView *contactSubTableView;

@end

@implementation ContactSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backGroundColor;
    [self initTable];
}

- (void)initTable{
    WS(ws);
    _contactSubTableView = [UITableView new];
    [self.view addSubview:_contactSubTableView];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
    headerView.backgroundColor = [UIColor whiteColor];
    [_contactSubTableView setTableHeaderView:headerView];
    _contactSubTableView.delegate = self;
    _contactSubTableView.dataSource = self;
    [_contactSubTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [_contactSubTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
}

#pragma mark uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"subList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;//箭头
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    if (indexPath.row == 0) {
        UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
        imgBtn.layer.cornerRadius = imgBtn.bounds.size.height/2.0;
        imgBtn.layer.masksToBounds = YES;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",[_subInfoDic objectForKey:@"userId"]]];
        [imgBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userDefulat.png"]];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, SCREEN_WIDTH-70, 40)];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.textColor = tipColor;
        nameLabel.text = @"";
        if ([_subInfoDic objectForKey:@"realName"]) {
            nameLabel.text = [_subInfoDic objectForKey:@"realName"];
        }
        
        [cell.contentView addSubview:imgBtn];
        [cell.contentView addSubview:nameLabel];
    }
    else if (indexPath.row ==1){
        HTCopyableLabel *tele = [[HTCopyableLabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-20, 40)];
        NSString *str = @"";
        if ([_subInfoDic objectForKey:@"mobile"]) {
            str = [NSString stringWithFormat:@"%@",[_subInfoDic objectForKey:@"mobile"]];
        }
        str = [NSString stringWithFormat:@"电话：%@",str];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange strRange1 = {3,[str1 length]-3};
        [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
        NSRange strRange2 = {0,[str1 length]};
        [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont systemFontOfSize:12.0],NSFontAttributeName,
                             tipColor,NSForegroundColorAttributeName,nil] range:strRange2];
        tele.attributedText = str1;
        
        [cell.contentView addSubview:tele];
    }
    else if (indexPath.row ==2){
        HTCopyableLabel *tele = [[HTCopyableLabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-20, 40)];
        NSString *str = @"";
        if ([_subInfoDic objectForKey:@"qq"]) {
            str = [NSString stringWithFormat:@"%@",[_subInfoDic objectForKey:@"qq"]];
        }
        str = [NSString stringWithFormat:@"Q  Q：%@",str];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange strRange1 = {5,[str1 length]-5};
        [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
        NSRange strRange2 = {0,[str1 length]};
        [str1 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIFont systemFontOfSize:12.0],NSFontAttributeName,
                             tipColor,NSForegroundColorAttributeName,nil] range:strRange2];
        tele.attributedText = str1;
        
        [cell.contentView addSubview:tele];
    }
    
    return cell;
}

#pragma mark uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.row == 1) {
        //电话
        NSString *tele = [_subInfoDic objectForKey:@"mobile"];
        if ([self isMobileNumber:tele]) {
            currentStr = tele;
            [self openMenu:0];
        }
    }
    else if (indexPath.row ==2){
        //qq
        NSString *tele = [_subInfoDic objectForKey:@"qq"];
        if ([self isQQNumber:tele]) {
            currentStr = tele;
            [self openMenu:1];
        }
    }
}

-(void)openMenu:(NSInteger)type
{
    switch (type) {
        case 0:
            myActionSheet = [[UIActionSheet alloc]
                             initWithTitle:nil
                             delegate:self
                             cancelButtonTitle:@"取消"
                             destructiveButtonTitle:nil
                             otherButtonTitles: @"呼叫", @"复制",nil];
            break;
        case 1:
            myActionSheet = [[UIActionSheet alloc]
                             initWithTitle:nil
                             delegate:self
                             cancelButtonTitle:@"取消"
                             destructiveButtonTitle:nil
                             otherButtonTitles: @"复制",nil];
            break;
            
        default:
            break;
    }
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    if (myActionSheet.cancelButtonIndex == 2) {
        switch (buttonIndex)
        {
            case 0:  //呼叫
                [self callUser];
                break;
                
            case 1:  //复制
                [self copyContent];
                break;
            default:
                break;
        }
    }
    else{
        switch (buttonIndex)
        {
            case 0:  //复制
                [self copyContent];
                break;
            default:
                break;
        }
    }
}

//呼叫
-(void)callUser
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[_subInfoDic objectForKey:@"mobile"]];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//复制
-(void)copyContent
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = currentStr;
    RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    RootHud.labelText = @"复制成功";
    [RootHud show:YES];
    [RootHud hide:YES afterDelay:1];
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
