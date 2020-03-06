//
//  UIColor+RCColor.h
//  RCloudMessage
//
//  Created by Liv on 15/4/3.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RCColor)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+(UIColor *) colorWithHexString: (NSString *)color;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
