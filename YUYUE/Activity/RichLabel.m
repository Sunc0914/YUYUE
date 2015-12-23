//
//  RichLabel.m
//  YUYUE
//
//  Created by Sunc on 15/11/14.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RichLabel.h"

@implementation RichLabel
{
    NSMutableArray *imageUrlArr;
}

- (TYAttributedLabel *)setRichLabelWithContent:(NSArray *)detailArr{
    
    _richLabel = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 20)];
    
    
    
    if (detailArr.count == 1) {
        NSString *temStr = [NSString stringWithFormat:@"%@",[detailArr objectAtIndex:0]];
        if (temStr.length == 0) {
            NSString *string = @"这家伙很懒，什么都没留下 ^_^";
            [_richLabel appendText:string];
            _richLabel.textColor = tipColor;
            return _richLabel;
        }
    }
    
    imageUrlArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<detailArr.count; i++) {
        NSString *temStr = [NSString stringWithFormat:@"%@",[detailArr objectAtIndex:i]];
        if ([self isImageStr:temStr]) {
            // 追加 图片Url
            [self addImage:temStr];
        }
        else{
            [self addText:temStr];
        }
    }
    
    [_richLabel sizeToFit];

    return _richLabel;
}

- (void)addText:(NSString *)text{
    text = [text stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    text = [text stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    text = [text stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    [_richLabel appendText:text];
}

- (void)addImage:(NSString *)imageUrlStr{
    
    TYImageStorage *imageUrlStorage = [[TYImageStorage alloc]init];
    imageUrlStorage.imageURL = [NSURL URLWithString:[imageUrlStr substringFromIndex:5]];
    imageUrlStorage.size = CGSizeMake(CGRectGetWidth(_richLabel.frame), 343*CGRectGetWidth(_richLabel.frame)/600);
    [_richLabel appendTextStorage:imageUrlStorage];
    
    [imageUrlArr addObject:imageUrlStorage.imageURL];
}

- (BOOL)isImageStr:(NSString *)sender{
    
    if (sender.length<6) {
        return NO;
    }
    
    NSString *headerStr = [sender substringToIndex:5];
    
    if ([headerStr isEqualToString:@"[img]"]) {
        return YES;
    }
    
    return NO;
}

- (NSMutableArray *)getImageUrlArr{
    return imageUrlArr;
}

@end
