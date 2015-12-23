//
//  UIImage+Scale.m
//  FeinnoShareLibrary
//
//  Created by Tank on 12-12-6.
//  Copyright (c) 2012年 Feinno. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (UIImage_Scale)

-(UIImage *)scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
	[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

@end
