//
//  GymCell.m
//  YUYUE
//
//  Created by Sunc on 15/8/20.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "GymCell.h"

@implementation GymCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 35)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 34, SCREEN_WIDTH-10, 1)];
        line.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [self addSubview:line];
        
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(5, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+5, 100, 80)];
        _image.layer.masksToBounds = YES;
        _image.layer.cornerRadius = 5;
        CGFloat height = 80/5;
        [self addSubview:_image];
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.origin.x+_image.frame.size.width+5, _image.frame.origin.y, SCREEN_WIDTH-100-15, height*2)];
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _addressLabel.numberOfLines = 2;
        _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_addressLabel];
        
        _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressLabel.frame.origin.x, _addressLabel.frame.origin.y+_addressLabel.frame.size.height, _addressLabel.frame.size.width, height)];
        _commentLabel.font = [UIFont systemFontOfSize:12];
        _commentLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        [self addSubview:_commentLabel];
        
        _projLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addressLabel.frame.origin.x, _commentLabel.frame.size.height+_commentLabel.frame.origin.y, _addressLabel.frame.size.width-40, height*2)];
        _projLabel.font = [UIFont systemFontOfSize:12];
        _projLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _projLabel.numberOfLines = 2;
        _projLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_projLabel];
        
        _districtLabel = [[UILabel alloc]initWithFrame:CGRectMake(_projLabel.frame.origin.x+_projLabel.frame.size.width, _projLabel.frame.origin.y, 40, height)];
        _districtLabel.font = [UIFont systemFontOfSize:12];
        _districtLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        [self addSubview:_districtLabel];
        
    }
    return self;
}

- (void)setCellDetail:(NSDictionary *)sender index:(NSInteger)index{
    
    _titleLabel.text = [sender objectForKey:@"title"];
    
    _addressLabel.text = [sender objectForKey:@"address"];
    
    _commentLabel.text = [sender objectForKey:@"comment"];
    
    _projLabel.text = [sender objectForKey:@"proj"];
    
    _districtLabel.text = [sender objectForKey:@"district"];
    
    _image.image = [UIImage imageNamed:[sender objectForKey:@"image"]];
    
    NSMutableArray *discountArr = [[NSMutableArray alloc]init];
    
    discountArr = [sender objectForKey:@"discount"];
    
    if (discountArr.count>0) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, _projLabel.frame.origin.y+_projLabel.frame.size.height+4, SCREEN_WIDTH-10, 1)];
        line.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
        [self addSubview:line];
        
        for (int i = 0; i<discountArr.count; i++) {
            
            NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[discountArr objectAtIndex:i]];
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,5+i*40+125, 60, 30)];
            priceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
            priceLabel.textColor = [UIColor colorWithRed:246/255.0 green:70/255.0 blue:0/255.0 alpha:1.0];
            priceLabel.userInteractionEnabled = YES;
            priceLabel.tag = i+index*100;
            [self addSubview:priceLabel];
            
            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 5+i*40+125, SCREEN_WIDTH-70, 30)];
            detailLabel.text = [dic objectForKey:@"detail"];
            detailLabel.userInteractionEnabled = YES;
            detailLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
            detailLabel.font = [UIFont systemFontOfSize:14];
            detailLabel.tag = i+index*100;
            [self addSubview:detailLabel];
            
            if (i<discountArr.count-1) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 39+i*40+125, SCREEN_WIDTH-10, 1)];
                line.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
                [self addSubview:line];
            }
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5+i*40+125, SCREEN_WIDTH, 40)];
            btn.tag = i+index*100;
            [btn addTarget:self action:@selector(onClickUILable:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    
    UIView *lineSeparteView = [[UIView alloc]initWithFrame:CGRectMake(0, 135+discountArr.count*40-10, SCREEN_WIDTH, 10)];
    lineSeparteView.backgroundColor = [UIColor colorWithRed:236/255.0 green:234/255.0 blue:232/255.0 alpha:1.0];
    [self addSubview:lineSeparteView];
}

- (void)onClickUILable:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if ([self.delegate respondsToSelector:@selector(subcommentbtnclicked:)]) {
        [_delegate subcommentbtnclicked:sender.tag];
    }
}

@end
