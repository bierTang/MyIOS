//
//  UIButton+Custom.m
//  WealthHo
//
//  Created by GF on 2019/3/22.
//  Copyright © 2019 GF. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)
/**@paramter
 *title:名称
 *size:字体大小
 *titleColor:字体颜色
 *bgColor:背景颜色
 *radius:弧度
 */
+ (UIButton *)buttonWithTitle:(NSString *)title font:(CGFloat)size titleColor:(NSString *)titleColor backgroundColor:(NSString *)bgColor cornerRadius:(CGFloat)radius{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:titleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    button.layer.cornerRadius = radius;
    button.backgroundColor = [UIColor colorWithHexString:bgColor];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(CGFloat)size titleColor:(NSString *)titleColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:titleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    return button;
}


@end
