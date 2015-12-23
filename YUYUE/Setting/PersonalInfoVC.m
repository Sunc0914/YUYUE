//
//  PersonalInfoVC.m
//  YUYUE
//
//  Created by Sunc on 15/11/3.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "UIImageView+WebCache.h"
#import "ModifyInfoVC.h"
#import "UINavigationController+PushAnimation.h"
#import "SCKeychain.h"

@interface PersonalInfoVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,refreshAfterInfoChanged>
{
    UITableView *personalInfoTable;
    
    NSMutableDictionary *userInfoDic;
    
    NSArray *arr;
    
    NSArray *keyArr;
    
    BOOL hasGetData;
    
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
    
    UIImage *newImage;
    
}

@end

@implementation PersonalInfoVC
NSString * const Person_UserName = @"com.yuyue.app.UserName";
NSString * const Person_PassWord = @"com.yuyue.app.PassWord";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    userInfoDic = [[NSMutableDictionary alloc]init];
    
    self.title = @"个人信息";
    
    arr = @[@"",@"用户名",@"昵称",@"签名",@"",@"头像",@"性别",@"学校",@"",@"手机",@"QQ",@"Email",@"生日"];
    
    keyArr = @[@"",@"userName",@"nickName",@"introduction",@"",@"photo",@"gender",@"schoolId",@"",@"mobile",@"qq",@"email",@"birthday"];
    
    [self initTable];
}

- (void)getData{
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    [AppWebService getIdType:@"schoolid" success:^(id result) {
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"其他",@"name", nil];
        [result addObject:dic];
        info.schoolArr = [NSArray arrayWithArray:[self processData:result type:@"school"]];
        [NSUserDefaults setUserObject:info forKey:USER_STOKRN_KEY];
        
        if (!hasGetData) {
            //没有数据
            hasGetData = YES;
        }
        else{
            [personalInfoTable reloadData];
            hasGetData = NO;
        }
        
    } failed:^(NSError *error) {
        
    }];
    
    
    [AppWebService getuserDetail:info.userid success:^(id result) {
        
        if ([result objectForKey:@"user"]) {
            userInfoDic = [[NSMutableDictionary alloc]initWithDictionary:[result objectForKey:@"user"]];
        }
        
        if (!hasGetData) {
            //没有数据
            hasGetData = YES;
        }
        else{
            [personalInfoTable reloadData];
            hasGetData = NO;
        };
        
    } failed:^(NSError *error) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
    }];
}

- (NSMutableArray *)processData:(NSArray *)sender type:(NSString *)type{
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<sender.count; i++) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[sender objectAtIndex:i]];
        [nameArr addObject:[dic objectForKey:@"name"]];
    }
    
    return nameArr;
}

- (void)initTable{
    
    personalInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    personalInfoTable.delegate = self;
    personalInfoTable.dataSource = self;
    
    personalInfoTable.backgroundColor = backGroundColor;
    personalInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:personalInfoTable];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self getData];
}

-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {

        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        
        data = UIImageJPEGRepresentation(image, 0.5);
        
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //获取document路径,括号中属性为当前应用程序独享
        
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentDirectory = [directoryPaths objectAtIndex:0];
        NSString *loginAccount = [SCKeychain getUserNameWithService:Person_UserName];
        //定义记录文件全名以及路径的字符串filePath
        NSString *docImagePath = [documentDirectory stringByAppendingPathComponent:loginAccount];
        
        NSString *imagePath = [docImagePath stringByAppendingPathComponent:@"userImage.png"];
        
        //创建子文件夹
        BOOL isDir = NO;
        BOOL existed = [fileManager fileExistsAtPath:docImagePath isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:docImagePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [fileManager createFileAtPath:imagePath contents:data attributes:nil];
        
        RootHud.mode = MBProgressHUDModeIndeterminate;
        RootHud.labelText = @"上传中";
        [RootHud show:YES];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            [AppWebService modifyPhoto:data fileName:[NSString stringWithFormat:@"%@.png",userInfo.userid] success:^(id result)
             {
                 RootHud.mode = MBProgressHUDModeCustomView;
                 RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
                 
                 RootHud.labelText = @"上传成功";
                 [RootHud show:YES];
                 [RootHud hide:YES afterDelay:1.0];
                 
                 //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
                 dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
                 //推迟两纳秒执行
                 dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
                 
                 dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                     NSLog(@"Grand Center Dispatch!");
                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                     [personalInfoTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                 });
                 
                 
             } failed:^(NSError *error) {
                 
                 RootHud.mode = MBProgressHUDModeCustomView;
                 RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
                 
                 RootHud.labelText = @"上传失败";
                 
                 [RootHud show:YES];
                 [RootHud hide:YES afterDelay:1.0];
                 
             }];
            
        }];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0||indexPath.row == 4||indexPath.row == 8) {
        return 25;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"persenalInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, 100, 45)];
    titleLabel.text = [arr objectAtIndex:indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0||indexPath.row == 4||indexPath.row == 8) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 24, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
    }
    else if (indexPath.row == 5) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell.contentView addSubview:line];
        
        //用户头像
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30-45, 4, 42, 42)];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = img.bounds.size.height/2.0;
//        img.backgroundColor = [UIColor redColor];
        UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
        
        if ([_userLoginId isEqualToString:info.loginID]) {
            
            //没有重新登录就调用本地图片
            //获取document路径,括号中属性为当前应用程序独享
            
            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            
            NSString *loginAccount = [SCKeychain getUserNameWithService:Person_UserName];
            //定义记录文件全名以及路径的字符串filePath
            NSString *docImagePath = [documentDirectory stringByAppendingPathComponent:loginAccount];
            
            NSString *imagePath = [docImagePath stringByAppendingPathComponent:@"userImage.png"];
            
            if ([UIImage imageWithContentsOfFile:imagePath]) {
                img.image = [UIImage imageWithContentsOfFile:imagePath];
            }
            else{
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",info.userid]];
                [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"userDefulat.png"] options:SDWebImageRefreshCached];
            }
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.yuti.cc/app/user/photo/%@",info.userid]];
            [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"userDefulat.png"] options:SDWebImageRefreshCached];
            _userLoginId = info.loginID;
        }
        
        [cell.contentView addSubview:img];
        [cell.contentView addSubview:titleLabel];
    }
    else
    {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [cell.contentView addSubview:line];
        
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-200, 2.5, 180, 45)];
        contentLabel.textColor = [UIColor lightGrayColor];
        
        NSString *content = @"";
        if ([keyArr objectAtIndex:indexPath.row]) {
            content = [NSString stringWithFormat:@"%@",[keyArr objectAtIndex:indexPath.row]];
            content = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:content]];
        }
        
        if (indexPath.row == 6) {
            //性别
            if ([content isEqualToString:@"1"]) {
                content = @"男";
            }
            else if ([content isEqualToString:@"2"]){
                content = @"女";
            }
            else
            {
                content = @"";
            }
        }
        else if (indexPath.row == 7){
            //学校
            UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
            NSMutableArray *schoolArr = [[NSMutableArray alloc]initWithArray:info.schoolArr];
            if (![content isEqualToString:@"(null)"]) {
                if ([content isEqualToString:@"0"]) {
                    content = [NSString stringWithFormat:@"%lu",info.schoolArr.count-1];
                }
                else{
                    content = [NSString stringWithFormat:@"%d",[content intValue]-1];
                }
                if (schoolArr.count>0) {
                    content = [NSString stringWithFormat:@"%@",[schoolArr objectAtIndex:[content intValue]]];
                }
            }
        }
        
        if ([content isEqualToString:@"(null)"]) {
            content = @"";
        }
        contentLabel.text = content;
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:contentLabel];
        [cell.contentView addSubview:titleLabel];
    }
    
    return cell;
}

#pragma mark -uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *path = [tableView indexPathForSelectedRow];
    if (path) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if(indexPath.row == 1)
    {
        return;
    }
    
    if(indexPath.row == 5)
    {
        //更改头像
        [self openMenu];
    }
    else if (indexPath.row != 0&&indexPath.row != 4&& indexPath.row != 8){
        
        //push To moidfyVC
        ModifyInfoVC *modify = [[ModifyInfoVC alloc]init];
        
        modify.changeType = @"0";//input
        NSString *content = @"-1";
        if ([keyArr objectAtIndex:indexPath.row]) {
            content = [NSString stringWithFormat:@"%@",[keyArr objectAtIndex:indexPath.row]];
            content = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:content]];
            if([content isEqualToString:@"(null)"])
            {
                content = @"";
            }
        }
        modify.placeHolderStr = content;
        
        if (indexPath.row == 6||indexPath.row == 7) {
            modify.changeType = @"1";//table
        }
        else if (indexPath.row == 12)
        {
            modify.changeType = @"2";//picker
        }
        
        content = [NSString stringWithFormat:@"%@",[arr objectAtIndex:indexPath.row]];
        modify.titleStr = content;
        modify.changeKey = [keyArr objectAtIndex:indexPath.row];
        
        modify.delegate = self;
        
        [self.navigationController pushViewControllerAnimatedWithTransition:modify];
        
    }
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
