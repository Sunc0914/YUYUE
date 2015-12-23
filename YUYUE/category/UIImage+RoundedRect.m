//
//  UIImage+RoundedRect.m
//  YUYUE
//
//  Created by Sunc on 15/12/1.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "UIImage+RoundedRect.h"

@implementation UIImage (RoundedRect)

-(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

- (UIImage *)makeStretchImage:(UIImage *)image{
    UIEdgeInsets edge=UIEdgeInsetsMake(0, 10, 0,10);
    //UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
    //UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图
    image= [image resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    return image;
}

- (UIImage *)makeAnotherStretchImage:(UIImage *)image{
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    return image;
}

@end
