//
//  RichLabel.h
//  YUYUE
//
//  Created by Sunc on 15/11/14.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYAttributedLabel.h"

@interface RichLabel : NSObject

- (TYAttributedLabel *)setRichLabelWithContent:(NSArray *)detailArr;

- (NSMutableArray *)getImageUrlArr;

@property (nonatomic, retain)TYAttributedLabel *richLabel;

@end
