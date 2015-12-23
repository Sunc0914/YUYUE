//
//  UIImage+RoundedRect.h
//  YUYUE
//
//  Created by Sunc on 15/12/1.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRect)

- (UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;

- (UIImage *)makeStretchImage:(UIImage *)image;

- (UIImage *)makeAnotherStretchImage:(UIImage *)image;

@end
