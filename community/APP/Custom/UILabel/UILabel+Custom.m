//
//  UILabel+Custom.m
//  WeathComeProject
//
//  Created by GF on 2019/3/7.
//  Copyright © 2019 GF. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)
/**
 *param
 *title:标题
 *sizeL:字体大小
 *color:字体颜色 十六进制
 *alignment:对齐方式
 */
+ (UILabel *)labelWithTitle:(NSString *)title font:(CGFloat)size textColor:(NSString *)color textAlignment:(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = alignment;
    [label setTextColor:[UIColor colorWithHexString:color]];
    return label;
}
@end
