//
//  FindVC.m
//  YUYUE
//
//  Created by Sunc on 15/8/10.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "FindVC.h"
#import "QuestionVC.h"

@interface FindVC ()

@end

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
}

- (void)initData{
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight+1);
    scroll.showsVerticalScrollIndicator = NO;
    scroll.backgroundColor = backGroundColor;
    [self.view addSubview:scroll];
    
    UILabel *questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 60)];
    questionLabel.backgroundColor = [UIColor whiteColor];
    questionLabel.layer.cornerRadius = 5;
    questionLabel.layer.masksToBounds = YES;
    questionLabel.tag = 1;
    questionLabel.numberOfLines = 0;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"   问一问\n   人气美女教练，在线答疑瑜伽新得"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0] range:NSMakeRange(7,string.length-7)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:72/255.0 green:166/255.0 blue:233/255.0 alpha:1.0] range:NSMakeRange(3,6)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12] range:NSMakeRange(7,string.length-7)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14] range:NSMakeRange(3,6)];
    questionLabel.attributedText = string;
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    questionLabel.userInteractionEnabled = YES;
    [questionLabel addGestureRecognizer:singleRecognizer];
    
    [scroll addSubview:questionLabel];
    
    UILabel *reportLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, questionLabel.frame.origin.y+questionLabel.frame.size.height+10, SCREEN_WIDTH-20, 60)];
    reportLabel.backgroundColor = [UIColor whiteColor];
    reportLabel.layer.cornerRadius = 5;
    reportLabel.layer.masksToBounds = YES;
    reportLabel.tag = 2;
    reportLabel.numberOfLines = 0;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"   吐槽喻体\n   您的意见是小体前进的方向"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0] range:NSMakeRange(8,str.length-8)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:72/255.0 green:166/255.0 blue:233/255.0 alpha:1.0] range:NSMakeRange(3,7)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12] range:NSMakeRange(8,str.length-8)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14] range:NSMakeRange(3,7)];
    reportLabel.attributedText = str;
    
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    reportLabel.userInteractionEnabled = YES;
    [reportLabel addGestureRecognizer:singleRecognizer];
    
    [scroll addSubview:reportLabel];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer *)sender{
    NSLog(@"%ld",(long)sender.view.tag);
    QuestionVC *question = [[QuestionVC alloc]init];
    question.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:question animated:YES];
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
