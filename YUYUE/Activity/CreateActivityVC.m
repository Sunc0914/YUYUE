//
//  CreateActivityVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/12.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "CreateActivityVC.h"
#import "MBProgressHUD.h"

@interface CreateActivityVC ()<MBProgressHUDDelegate>
{
    UIView *inputBackView;
    
    NSInteger whichCellEdited;
    
    NSIndexPath *whichIndexPath;
    
    UIPickerView *otherPicker;
    
    UIDatePicker *datePicker;
    
    NSMutableArray *pickerDetailArray;
    
    UIView *pickerBackView;
    
    UIButton *pickerCompleteBtn;
    
    UIBarButtonItem *rightBarBtn;
    
    NSMutableDictionary *activityDic;
    
    NSArray *activityDetailStable;
    
    BOOL getSchoolIdSuccess;
    
    BOOL getDistrictIdSuccess;
    
    NSMutableDictionary *totalIdDic;
    
    NSString *startTime;
}

@end

@implementation CreateActivityVC
@synthesize createActivityTable;
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize titleArray;
@synthesize singleBtn;
@synthesize organizasionBtn;
@synthesize indicator;
@synthesize activityDetail;
@synthesize inputTextView;
@synthesize completeBtn;
@synthesize sportsArr;
@synthesize districtArr;
@synthesize placeArr;
@synthesize payWayArr;
@synthesize targetArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"创建活动";
    
    [self getid];
    
    [self initData];
    
    [self initSelectBtn];
    
    [self initTable];
    
    [self initHUD];
    
}

- (void)getid{
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    totalIdDic = [[NSMutableDictionary alloc]init];
    
    [AppWebService getIdType:nil success:^(id result) {
        getDistrictIdSuccess = YES;
        userinfo.districtArr = [NSArray arrayWithArray:result];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"其他",@"name", nil];
        [result addObject:dic];
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        districtArr = [self processData:result type:@"district"];
        
    } failed:^(NSError *error) {
        getDistrictIdSuccess = NO;
    }];
    
    [AppWebService getIdType:@"schoolid" success:^(id result) {
        getSchoolIdSuccess = YES;
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"其他",@"name", nil];
        [result addObject:dic];
        
        placeArr = [self processData:result type:@"school"];
        userinfo.schoolArr = [NSArray arrayWithArray:placeArr];
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        
    } failed:^(NSError *error) {
        getSchoolIdSuccess = NO;
    }];
    
    [AppWebService getIdType:@"sportid" success:^(id result) {
        getSchoolIdSuccess = YES;
        
//        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"id",@"其他",@"name", nil];
//        [result addObject:dic];
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        sportsArr = [self processData:result type:@"sport"];
    } failed:^(NSError *error) {
        getSchoolIdSuccess = NO;
    }];
}

- (NSMutableArray *)processData:(NSArray *)sender type:(NSString *)type{
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<sender.count; i++) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[sender objectAtIndex:i]];
        [totalIdDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] forKey:[dic objectForKey:@"name"]];
        [nameArr addObject:[dic objectForKey:@"name"]];
    }
    
    return nameArr;
}

- (void)initData{
    
    titleArray = [[NSArray alloc]initWithObjects:@"",@"项目类别",@"活动地点",@"活动时间",@"活动费用",@"活动对象",@"活动介绍", nil];
    activityDetail = [[NSMutableArray alloc]initWithObjects:@"活动标题",@"活动项目", @"选择区域",@"选择学校",@"自定义活动地点",@"开始时间",@"结束时间",@"AA制",@"平均费用",@"不限",@"活动描述",@"联系人姓名",@"联系人手机",@"最大参与人数（0或不填表示无限制）",nil];
    
    activityDetailStable = [[NSArray alloc]initWithObjects:@"name",@"sportId", @"districtId",@"schoolId",@"motionPlace",@"motionBeginTime",@"motionEndTime",@"payMode",@"costMin",@"motionTarget",@"description",@"contactPerson",@"contactMobile",@"maxSubscribers",nil];
    
    sportsArr = [[NSMutableArray alloc]initWithObjects:@"羽毛球",@"乒乓球",@"网球",@"台球",@"游泳",@"健身",@"跑步",@"足球",@"篮球",@"舞蹈",@"瑜伽",@"武术",@"其他", nil];
    
    payWayArr = [[NSMutableArray alloc]initWithObjects:@"其他",@"AA制",@"我来请客",@"免费参与",@"败者支付", nil];
    
    for (int i = 0; i<payWayArr.count; i++) {
        [totalIdDic setObject:[NSString stringWithFormat:@"%d",i] forKey:[payWayArr objectAtIndex:i]];
    }
    
    targetArr = [[NSMutableArray alloc]initWithObjects:@"不限",@"男生",@"女生",@"学生", nil];
    
    for (int i = 0; i<targetArr.count; i++) {
        [totalIdDic setObject:[NSString stringWithFormat:@"%d",i] forKey:[targetArr objectAtIndex:i]];
    }
    
    activityDic = [[NSMutableDictionary alloc]init];
    
    //输入框初始化
    inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 4, SCREEN_WIDTH-75, 36)];
    inputTextView.delegate = self;
    inputTextView.font = [UIFont systemFontOfSize:16];
    inputTextView.layer.masksToBounds = YES;
    inputTextView.layer.borderWidth = 1;
    inputTextView.layer.cornerRadius = 5;
    inputTextView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
    
    completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputTextView.frame.origin.x+inputTextView.frame.size.width+5, 4, 45, 36)];
    [completeBtn addTarget:self action:@selector(completeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.layer.masksToBounds = YES;
    completeBtn.layer.cornerRadius = 5;
    completeBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:152/255.0 blue:234/255.0 alpha:1.0];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    
    inputBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    
    inputBackView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    
    [inputBackView addSubview:inputTextView];
    [inputBackView addSubview:completeBtn];
    [inputBackView addSubview:line];
    
    //
    whichIndexPath = [[NSIndexPath alloc]init];
    
    
    //初始化picker
    otherPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    otherPicker.delegate = self;
    otherPicker.dataSource = self;
    otherPicker.backgroundColor = backGroundColor;
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [datePicker setCalendar:[NSCalendar currentCalendar]];
    [datePicker setDate:[NSDate date]];
    datePicker.backgroundColor = backGroundColor;
    
    pickerDetailArray = [[NSMutableArray alloc]init];
    
    pickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    pickerBackView.backgroundColor = [UIColor whiteColor];
    
    //picker完成btn
    pickerCompleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputTextView.frame.origin.x+inputTextView.frame.size.width+5, 4, 45, 36)];
    [pickerCompleteBtn addTarget:self action:@selector(completeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    pickerCompleteBtn.layer.masksToBounds = YES;
    pickerCompleteBtn.layer.borderWidth = 1;
    pickerCompleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    pickerCompleteBtn.layer.cornerRadius = 5;
    pickerCompleteBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:152/255.0 blue:234/255.0 alpha:1.0];

    [pickerCompleteBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [pickerBackView addSubview:pickerCompleteBtn];
    
    //初始化清空数据
    rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClicked)];
}

- (void)initSelectBtn{
    
     singleBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 55, SCREEN_WIDTH/2-15, 40)];
    [singleBtn setTitle:@"个人活动" forState:UIControlStateNormal];
    [singleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [singleBtn addTarget:self action:@selector(selectBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    singleBtn.selected = YES;
    singleBtn.backgroundColor = [UIColor clearColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:singleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = singleBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    
    singleBtn.layer.mask = maskLayer;
    
    organizasionBtn  = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 55, SCREEN_WIDTH/2-15, 40)];
    [organizasionBtn setTitle:@"团队活动" forState:UIControlStateNormal];
    [organizasionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [organizasionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [organizasionBtn addTarget:self action:@selector(selectBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    organizasionBtn.backgroundColor = [UIColor clearColor];
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:organizasionBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = organizasionBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    
    organizasionBtn.layer.mask = maskLayer;
    
    indicator = [[UIView alloc]initWithFrame:CGRectMake(15, 55, SCREEN_WIDTH/2-15, 40)];
    indicator.backgroundColor = [UIColor colorWithRed:41/255.0 green:152/255.0 blue:230/255.0 alpha:1.0];
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:indicator.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = indicator.bounds;
    maskLayer.path = maskPath.CGPath;
    indicator.layer.mask = maskLayer;
}

- (void)initTable{
    createActivityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight-40, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight+40)];
    createActivityTable.delegate = self;
    createActivityTable.dataSource = self;
    
    createActivityTable.backgroundColor = backGroundColor;
    createActivityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:createActivityTable];
    
    [self.view addSubview:inputBackView];
    [self.view addSubview:datePicker];
    [self.view addSubview:otherPicker];
    [self.view addSubview:pickerBackView];
}

- (void)initHUD{
    
    RootHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:RootHud];
    
    RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    
    // Set custom view mode
    RootHud.mode = MBProgressHUDModeCustomView;
    
    RootHud.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self initKeyboardNotification];
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    createActivityTable.userInteractionEnabled = YES;
    [inputTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.2f animations:^{
        datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
        otherPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
        pickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40);
    }];

}

- (void)didSelectRow:(NSString *)type isPickerView:(BOOL)isPickerView{
    
    [inputTextView resignFirstResponder];
    
    if (!isPickerView) {
        
        //显示通用picker
        [UIView animateWithDuration:0.2f animations:^{
            datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            otherPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            pickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2f animations:^{
                
                if (pickerDetailArray.count != 0) {
                    pickerDetailArray  = [[NSMutableArray alloc]init];
                }
                
                if ([type isEqualToString:@"sport"]) {
                    [pickerDetailArray addObjectsFromArray:sportsArr];
                }
                else if ([type isEqualToString:@"district"]){
                    [pickerDetailArray addObjectsFromArray:districtArr];
                }
                else if ([type isEqualToString:@"place"]){
                    [pickerDetailArray addObjectsFromArray:placeArr];
                }
                else if ([type isEqualToString:@"pay"])
                {
                    [pickerDetailArray addObjectsFromArray:payWayArr];
                }
                else if ([type isEqualToString:@"target"]){
                    
                    [pickerDetailArray addObjectsFromArray:targetArr];
                }
                
                [otherPicker reloadAllComponents];
                otherPicker.frame = CGRectMake(0, SCREEN_HEIGHT-otherPicker.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT/3);
                pickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT-otherPicker.frame.size.height, SCREEN_WIDTH, 44);
                
            }];
        }];
        
    }
    else{
        //显示时间picker
        [UIView animateWithDuration:0.2f animations:^{
            otherPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            pickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
            datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                datePicker.frame = CGRectMake(0, SCREEN_HEIGHT-otherPicker.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT/3);
                pickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT-otherPicker.frame.size.height, SCREEN_WIDTH, 44);
            }];
        }];
    }
    
    createActivityTable.userInteractionEnabled = YES;
}

#pragma mark -uitextviewdelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    CGSize constraintSize;
    
    constraintSize.width = SCREEN_WIDTH-75;
    constraintSize.height = 120;
    CGSize sizeFrame =[textView.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (sizeFrame.height<36) {
        inputBackView.frame = CGRectMake(0, inputBackView.frame.origin.y, SCREEN_WIDTH, 44);
        return;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - _keyboardheight - sizeFrame.height -4-4, SCREEN_WIDTH, sizeFrame.height+8);
        
        textView.frame = CGRectMake(15, 4, SCREEN_WIDTH-75, sizeFrame.height);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
        
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
-(void) keyboardWillShow:(NSNotification *) note
{
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"hight_hitht:%f",kbSize.height);
    _keyboardheight = kbSize.height;
    
    CGFloat textViewHeight = inputBackView.frame.size.height;
    
    datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);;
    otherPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - _keyboardheight - textViewHeight, SCREEN_WIDTH, 44);
        
        inputTextView.frame = CGRectMake(15, 4, SCREEN_WIDTH - 75, 36);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
        
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
    }];
    
    createActivityTable.userInteractionEnabled = NO;
    
}

-(void) keyboardWillHide:(NSNotification *) note
{
    _keyboardheight = 0;
    
    createActivityTable.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        //输入框增高
        
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
        
        inputTextView.frame = CGRectMake(15, 4, SCREEN_WIDTH - 75, 36);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }];
    
}

#pragma mark -BtnAction
- (void)selectBtnclicked:(UIButton *)sender{
    if (sender == organizasionBtn) {
        //点击右边btn
        organizasionBtn.selected = YES;
        singleBtn.selected = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:singleBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = singleBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            indicator.layer.mask = maskLayer;
            indicator.frame = CGRectMake(SCREEN_WIDTH/2, 55, SCREEN_WIDTH/2-15, 40);
        }];
    }
    else{
        //点击左边btn
        singleBtn.selected = YES;
        organizasionBtn.selected = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:singleBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = singleBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            indicator.layer.mask = maskLayer;
            indicator.frame = CGRectMake(15, 55, SCREEN_WIDTH/2-15, 40);
        }];
    }

}

- (void)completeBtnClicked:(UIButton *)sender{
    
    if (sender == completeBtn) {
        if (inputTextView.text.length > 0) {
            [activityDetail replaceObjectAtIndex:whichCellEdited withObject:inputTextView.text];
            [createActivityTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:whichIndexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
            [inputTextView resignFirstResponder];
            
            [activityDic setObject:inputTextView.text forKey:[NSString stringWithFormat:@"%@",[activityDetailStable objectAtIndex:whichCellEdited]]];
            
            inputTextView.text = @"";
            
        }
        else{
            
            [inputTextView resignFirstResponder];
        }
    }
    else
    {
        [UIView animateWithDuration:0.2f animations:^{
            pickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
        }];
        
        NSString *seleted = [[NSString alloc]init];
        
        if (otherPicker.frame.origin.y<SCREEN_HEIGHT) {
            
            //其他的选择器
            
            NSInteger index = [otherPicker selectedRowInComponent:0];
            
            seleted = [pickerDetailArray objectAtIndex:index];
            
            [activityDic setObject:[totalIdDic objectForKey:seleted] forKey:[NSString stringWithFormat:@"%@",[activityDetailStable objectAtIndex:whichCellEdited]]];
            
        }
        else{
            
            //时间选择器
            NSDate *selectedDate = [datePicker date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

            seleted = [dateFormatter stringFromDate:selectedDate];
            
            if (whichCellEdited == 5) {
                //判断开始时间
                startTime = seleted;
                if ([self checkTimeIsRightWithStartTime:startTime andEndTime:nil] == 1) {
                    RootHud.mode = MBProgressHUDModeCustomView;
                    RootHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
                    RootHud.labelText = @"开始日期不能早于当前时间";
                    [RootHud show:YES];
                    [RootHud hide:YES afterDelay:1.5];
                    seleted = @"开始时间";
                }
                else{
                    [activityDic setObject:seleted forKey:[NSString stringWithFormat:@"%@",[activityDetailStable objectAtIndex:whichCellEdited]]];
                }
            }
            else if (whichCellEdited == 6){
                //判断时间正确性
                if ([self checkTimeIsRightWithStartTime:startTime andEndTime:seleted] == 2){
                    RootHud.mode = MBProgressHUDModeCustomView;
                    RootHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"error"]];
                    RootHud.labelText = @"结束时间不能晚于开始时间";
                    [RootHud show:YES];
                    [RootHud hide:YES afterDelay:1.5];
                    seleted = @"结束时间";
                }
                else{
                    [activityDic setObject:seleted forKey:[NSString stringWithFormat:@"%@",[activityDetailStable objectAtIndex:whichCellEdited]]];
                }
                
            }
            
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            datePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
            otherPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3);
        }];
        
        [activityDetail replaceObjectAtIndex:whichCellEdited withObject:seleted];
        [createActivityTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:whichIndexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        
        [inputTextView resignFirstResponder];
    }
    
}

- (int)checkTimeIsRightWithStartTime:(NSString *)begin andEndTime:(NSString *)end{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    if (end == nil) {
        
        NSDate *dateBegin = [dateFormatter dateFromString:begin];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: dateBegin];
        dateBegin = [dateBegin dateByAddingTimeInterval:interval];
        
        //获取本机时间
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd HH:mm"];
        NSDate *date = [NSDate date];
        interval = [zone secondsFromGMTForDate: date];
        NSDate *nowDate = [date  dateByAddingTimeInterval: interval];
        
        if ([dateBegin earlierDate:nowDate] == dateBegin) {
            //开始时间晚于当前时间
            return 1;
        }
    }
    else{
        
        NSDate *dateBegin = [dateFormatter dateFromString:begin];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: dateBegin];
        dateBegin = [dateBegin dateByAddingTimeInterval:interval];
        
        NSDate *dateEnd = [dateFormatter dateFromString:end];
        interval = [zone secondsFromGMTForDate: dateEnd];
        dateEnd = [dateEnd  dateByAddingTimeInterval: interval];
        
        if ([dateBegin earlierDate:dateEnd] == dateEnd) {
            //开始时间晚于结束时间
            return 2;
        }
    }

    
    //正确时间
    return 3;
}

- (void)rightBarBtnClicked{
    
    inputTextView.text = @"";
    
    [UIView animateWithDuration:0.2f animations:^{
        inputBackView.frame = CGRectMake(0, SCREEN_HEIGHT - _keyboardheight-44, SCREEN_WIDTH, 44);
        
        inputTextView.frame = CGRectMake(15, 4, SCREEN_WIDTH - 75, 36);
        
        completeBtn.frame = CGRectMake(completeBtn.frame.origin.x, 4, completeBtn.frame.size.width, 36);
    }];

}

- (void)publishClicked{
    
    [self checkInfo];
    
    if (organizasionBtn.selected) {
        [activityDic setObject:@"2" forKey:@"motionType"];
    }
    else
    {
        [activityDic setObject:@"1" forKey:@"motionType"];
    }
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    [AppWebService createActivitySimple:activityDic loginId:userinfo.loginID success:^(id result) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        
        RootHud.labelText = @"发布成功";
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
//        if ( _isModelViewController) {
        
            //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
            dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
            //推迟两纳秒执行
            dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
            
            dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                NSLog(@"Grand Center Dispatch!");
                [self.navigationController popViewControllerAnimatedWithTransition];
                if ([_delegate respondsToSelector:@selector(refreshData)]) {
                    [_delegate refreshData];
                }
            });
//        }
        
    } failed:^(NSError *error) {
        
        RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        
        RootHud.labelText = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [RootHud show:YES];
        [RootHud hide:YES afterDelay:1];
        
    }];
}

- (void)checkInfo{
    
    for (int i = 0; i<activityDetail.count; i++) {
        
        if (i == 13) {
            return;
        }
        
        if ([activityDic objectForKey:[activityDetailStable objectAtIndex:i]] == nil) {
            
            RootHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            
            RootHud.labelText = [NSString stringWithFormat:@"%@不能为空",[activityDetail objectAtIndex:i]];
            [RootHud show:YES];
            [RootHud hide:YES afterDelay:1];
            
            break;
        }
    }
    
    return;
}

#pragma mark -uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.section == 0) {
        //活动标题
        [inputTextView becomeFirstResponder];
        whichCellEdited = 0;
        whichIndexPath = indexPath;
    }
    else if (indexPath.section == 1)
    {
        //项目类别
        [self didSelectRow:@"sport" isPickerView:NO];
        whichCellEdited = 1;
        whichIndexPath = indexPath;
    }
    else if (indexPath.section == 2){
        //活动地点
        if (indexPath.row == 0) {
            //区域
            [self didSelectRow:@"district" isPickerView:NO];
            whichCellEdited = 2;
            whichIndexPath = indexPath;

        }
        else if (indexPath.row == 1)
        {
            //学校
            [self didSelectRow:@"place" isPickerView:NO];
            whichCellEdited = 3;
            whichIndexPath = indexPath;

        }
        else{
            
            [inputTextView becomeFirstResponder];
            whichCellEdited = 4;
            whichIndexPath = indexPath;
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0) {
            //活动时间
            whichCellEdited = 5;
            whichIndexPath = indexPath;
            
            [self didSelectRow:@"time" isPickerView:YES];
        }
        else{
            //活动时间
            whichCellEdited = 6;
            whichIndexPath = indexPath;
            
            [self didSelectRow:@"time" isPickerView:YES];
        }
        
    }
    else if (indexPath.section == 4){
        //活动费用
        if (indexPath.row == 0) {
            
            [self didSelectRow:@"pay" isPickerView:NO];
            whichCellEdited = 7;
            whichIndexPath = indexPath;

        }
        else if (indexPath.row == 1)
        {
            [inputTextView becomeFirstResponder];
            whichCellEdited = 8;
            whichIndexPath = indexPath;
        }
    }
    else if (indexPath.section == 5){
        //活动对象
        [self didSelectRow:@"target" isPickerView:NO];
        whichCellEdited = 9;
        whichIndexPath = indexPath;

    }
    else if (indexPath.section == 6){
        //活动介绍
        if (indexPath.row == 0){
            //活动规则
            [inputTextView becomeFirstResponder];
            whichCellEdited = 10;
            whichIndexPath = indexPath;
        }
        else if (indexPath.row == 1){
            //联系人
            [inputTextView becomeFirstResponder];
            whichCellEdited = 11;
            whichIndexPath = indexPath;
        }
        else if (indexPath.row == 2){
            //手机号
            [inputTextView becomeFirstResponder];
            whichCellEdited = 12;
            whichIndexPath = indexPath;
        }
        else if (indexPath.row == 3){
            //最大参与人数
            [inputTextView becomeFirstResponder];
            whichCellEdited = 13;
            whichIndexPath = indexPath;
        }
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backview = [[UIView alloc]init];
    
    if (section == 0) {
        backview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
        
        UIView *boundView = [[UIView alloc]initWithFrame:CGRectMake(15, 55, SCREEN_WIDTH-30, 40)];
        boundView.layer.masksToBounds = YES;
        boundView.layer.borderWidth = 1;
        boundView.layer.cornerRadius = 5;
        boundView.layer.borderColor = [UIColor colorWithRed:41/255.0 green:152/255.0 blue:230/255.0 alpha:1.0].CGColor;
        
        [backview addSubview:boundView];
        
        [backview addSubview:indicator];
        
        [backview addSubview:singleBtn];
        [backview addSubview:organizasionBtn];
        
        backview.backgroundColor = backGroundColor;
        
        return backview;
    }
    else{
        backview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        backview.backgroundColor = backGroundColor;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 40)];
        titleLabel.text = [titleArray objectAtIndex:section];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [backview addSubview:titleLabel];
        return backview;
    }
    return backview;
}


#pragma mark -uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger index = section;
    
    switch (index) {
        case 0:
            //第一行
            return 1;
            break;
        case 1:
            //项目类别
            return 1;
            break;
        case 2:
            //活动地点
            return 3;
            break;
        case 3:
            //活动时间
            return 2;
            break;
        case 4:
            //活动费用
            return 2;
            break;
        case 5:
            //活动对象
            return 1;
            break;
        case 6:
            //活动介绍
            return 5;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 110;
    }
    else
    {
        return 40;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 6) {
        return 40;
    }
    else{
        if (indexPath.row == 4) {
            return 80;
        }
        else
        {
            return 40;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"create";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-25, 39)];
    titlelabel.backgroundColor = [UIColor whiteColor];
    titlelabel.font = [UIFont systemFontOfSize:14];
    
    [cell.contentView addSubview:titlelabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 39, SCREEN_WIDTH, 1)];
    line.backgroundColor = backGroundColor;
    
    if (indexPath.section == 0) {
        titlelabel.textColor = tipColor;
        titlelabel.text = [activityDetail objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.section == 1)
    {
        //项目类别
        titlelabel.textColor = [UIColor blackColor];
        titlelabel.text = [activityDetail objectAtIndex:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 2)
    {
        //活动地点
        if (indexPath.row == 0) {
            titlelabel.textColor = [UIColor blackColor];
            titlelabel.text = [activityDetail objectAtIndex:2];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:line];
        }
        else if (indexPath.row == 1)
        {
            titlelabel.textColor = [UIColor blackColor];
            titlelabel.text = [activityDetail objectAtIndex:3];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:line];
        }
        else
        {
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:4];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == 3)
    {
        //活动时间
        if (indexPath.row == 0) {
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:5];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:6];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else if (indexPath.section == 4){
        //活动费用
        if (indexPath.row == 0) {
            titlelabel.textColor = [UIColor blackColor];
            titlelabel.text = [activityDetail objectAtIndex:7];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:line];
        }
        else if (indexPath.row == 1)
        {
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:8];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == 5)
    {
        //活动对象
        titlelabel.textColor = [UIColor blackColor];
        titlelabel.text = [activityDetail objectAtIndex:9];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 6){
        //活动介绍
        if (indexPath.row == 0)
        {
            //活动规则
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:10];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:line];
        }
        else if (indexPath.row == 1){
            //联系人姓名
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:11];
            UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
            if (userInfo.nickname.length>0&&![userInfo.nickname isEqualToString:@"(null)"]) {
                titlelabel.text = userInfo.nickname;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:line];
        }
        else if (indexPath.row == 2){
            //联系人手机
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:12];
            UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
            if (userInfo.phone.length>0&&![userInfo.phone isEqualToString:@"(null)"]) {
                titlelabel.text = userInfo.nickname;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:line];
        }
        else if (indexPath.row == 3){
            //最大参与人数
            titlelabel.textColor = tipColor;
            titlelabel.text = [activityDetail objectAtIndex:13];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:line];
        }
        else{
            //预约按钮
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UIButton *publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH-40, 50)];
            publishBtn.layer.cornerRadius = 5;
            publishBtn.layer.masksToBounds = YES;
            publishBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:103/255.0 blue:19/255.0 alpha:1.0];
            [publishBtn setTitle:@"发  布  活  动" forState:UIControlStateNormal];
            [publishBtn addTarget:self action:@selector(publishClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:publishBtn];
        }
    }
    
    return cell;
}

#pragma mark - uipickerviewdatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerDetailArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row >= pickerDetailArray.count)
    {
        return nil;
    }
    return  [pickerDetailArray objectAtIndex:row];
}

#pragma mark - uipickerviewdelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
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
