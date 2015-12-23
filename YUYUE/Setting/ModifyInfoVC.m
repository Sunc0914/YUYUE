//
//  ModifyInfoVC.m
//  YUYUE
//
//  Created by Sunc on 15/11/3.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ModifyInfoVC.h"
#import "UINavigationController+PushAnimation.h"
#import "SaveInfo.h"

@interface ModifyInfoVC ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *backScrollView;
    
    UITextView *inputTextView;
    
    UITableView *modifyTable;
    
    CGFloat keyboardheight;
    
    int selected;
    
    NSMutableDictionary *totalIdDic;
    
    NSMutableArray *placeArr;
    
    UIBarButtonItem *rightItem;
    
    UIBarButtonItem *leftItem;
    
    UIDatePicker *datePicker;
}

@end

@implementation ModifyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initScrollView];
    
    [self initBarItem];
    
    totalIdDic = [[NSMutableDictionary alloc]init];
    
    placeArr = [[NSMutableArray alloc]init];
    
    if ([_changeType isEqualToString:@"0"]) {
        //信息输入
        [self initInputView];
        
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            NSLog(@"Grand Center Dispatch!");
            [inputTextView becomeFirstResponder];
        });
    }
    else if ([_changeType isEqualToString:@"1"]){
        //选择
        [self initTable];
    }
    else if ([_changeType isEqualToString:@"2"]){
        [self initDatePicker];
    }
    
    self.title = _titleStr;
    
    if ([_titleStr isEqualToString:@"性别"]) {
        if (_placeHolderStr.length>0) {
            selected = [_placeHolderStr intValue]-1;
        }
        else
        {
            selected = -1;
        }
    }
    else
    {
        //学校
        if (_placeHolderStr.length>0) {
            selected = [_placeHolderStr intValue]-1;
        }
        else
        {
            
            selected = -1;
        }
    }
}

- (void)initBarItem{
    leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClicked)];
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClicked)];
    
    if ([_changeType isEqualToString:@"0"]||[_changeType isEqualToString:@"2"]) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)initScrollView{
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight+10);
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.backgroundColor = backGroundColor;
    [self.view addSubview:backScrollView];
    
}

- (void)initTable{
    
    if([_titleStr isEqualToString:@"性别"])
    {
        placeArr = [[NSMutableArray alloc]initWithObjects:@"男",@"女", nil];
    }
    else{
        
        [self getData];
    }
    backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight);
    
    modifyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    modifyTable.dataSource = self;
    modifyTable.delegate = self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, upsideheight)];
    headerView.backgroundColor = [UIColor clearColor];
    [modifyTable setTableHeaderView:headerView];
    modifyTable.backgroundColor = [UIColor clearColor];
    [backScrollView addSubview:modifyTable];
}

- (void)initDatePicker{
    
    [self initInputView];
    
    if (_placeHolderStr.length<=0) {
        inputTextView.text = @"选择您的生日吧！";
    }
    
    inputTextView.textColor = tipColor;
    inputTextView.userInteractionEnabled = NO;
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [datePicker setCalendar:[NSCalendar currentCalendar]];
    
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter_minDate dateFromString:@"1900-01-01"];
    NSDate *maxDate = [NSDate date];
    NSDate *nowDate = [formatter_minDate dateFromString:@"1991-08-21"];
    [datePicker setDate:nowDate];
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    datePicker.backgroundColor = backGroundColor;
    [backScrollView addSubview:datePicker];
    
    backScrollView.scrollEnabled = NO;
    
    [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [UIView animateWithDuration:0.3 animations:^{
        datePicker.frame = CGRectMake(0, SCREEN_HEIGHT-SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3);
    }];
}

- (void)dataValueChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    inputTextView.textColor = [UIColor darkGrayColor];
    inputTextView.text = [formatter stringFromDate:date_one];
}

- (void)initInputView{
    //输入框初始化
    inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 36)];
    inputTextView.delegate = self;
    inputTextView.font = [UIFont systemFontOfSize:16];
    inputTextView.layer.masksToBounds = YES;
    inputTextView.layer.borderWidth = 1;
    inputTextView.layer.cornerRadius = 5;
    inputTextView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    inputTextView.text = _placeHolderStr;
    
    [backScrollView addSubview:inputTextView];
}

- (void)getData{
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    [AppWebService getIdType:@"schoolid" success:^(id result) {
        userinfo.schoolArr = [NSArray arrayWithArray:result];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"其他",@"name", nil];
        [result addObject:dic];
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        placeArr = [self processData:result type:@"school"];
        
        if ([_placeHolderStr isEqualToString:@"0"]) {
            selected = (int)(placeArr.count-1);
        }
        
        [modifyTable reloadData];
    } failed:^(NSError *error) {

    }];
    
}

- (void)leftItemClicked{
    
    [self.navigationController popViewControllerAnimatedWithTransition];
}

- (void)rightItemClicked{
    //保存信息
    
    if ([_placeHolderStr isEqualToString:inputTextView.text]) {
        
        [self.navigationController popViewControllerAnimatedWithTransition];
        
        return;
    }
    
    if (inputTextView.text.length<=0) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = @"内容不能为空";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
    }
    
    [inputTextView resignFirstResponder];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:inputTextView.text forKey:_changeKey];
    
    [AppWebService modifyInfo:dic success:^(id result) {
        
        SaveInfo *save = [[SaveInfo alloc]init];
        [save saveUserInfo:inputTextView.text withKey:_changeKey];
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        
        RootHud.labelText = @"修改成功";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            NSLog(@"Grand Center Dispatch!");
            if ([self.delegate respondsToSelector:@selector(getData)]) {
                
                [self.delegate getData];
            }
            
            [self.navigationController popViewControllerAnimatedWithTransition];
        });
        
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

- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self initKeyboardNotification];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)initKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark -uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return placeArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    
    if (indexPath.row == selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, 200, 40)];
    titleLabel.text = [placeArr objectAtIndex:indexPath.row];
    [cell.contentView addSubview:titleLabel];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark -uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [tableView indexPathForSelectedRow];
    if (path) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    NSString *content = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if ([_changeKey isEqualToString:@"schoolId"]) {
        
        if (indexPath.row == placeArr.count-1) {
            content = @"0";
        }
    }
    
    if (indexPath.row == selected) {
        
        [self.navigationController popViewControllerAnimatedWithTransition];
        return;
    }
    
    //刷新选中cell
    selected = (int)indexPath.row;
    
    [modifyTable reloadData];
    
    [dic setObject:content forKey:_changeKey];
    
    [AppWebService modifyInfo:dic success:^(id result) {
        
        SaveInfo *save = [[SaveInfo alloc]init];
        [save saveUserInfo:content withKey:_changeKey];
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        
        RootHud.labelText = @"修改成功";
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1.0];
        
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            NSLog(@"Grand Center Dispatch!");
            [self.navigationController popViewControllerAnimatedWithTransition];
        });
        
        
        
    } failed:^(NSError *error) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
    }];
    
}

#pragma mark -uitextviewdelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    CGSize constraintSize;
    
    constraintSize.width = SCREEN_WIDTH-30;
    constraintSize.height = 120;
    CGSize sizeFrame =[textView.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (sizeFrame.height<36) {
        sizeFrame.height = 36;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        textView.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, sizeFrame.height);
        
    }];
    
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -KeyboardNotification
-(void) keyboardWillShow:(NSNotification *) note{
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hight_hitht:%f",kbSize.height);
    keyboardheight = kbSize.height;

}

-(void) keyboardWillHide:(NSNotification *) note{
    keyboardheight = 0;
    
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
