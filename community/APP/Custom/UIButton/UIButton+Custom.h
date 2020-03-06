//
//  UIButton+Custom.h
//  WealthHo
//
//  Created by GF on 2019/3/22.
//  Copyright © 2019 GF. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Custom)
/**@paramter
 *title:名称
 *size:字体大小
 *titleColor:字体颜色
 *bgColor:背景颜色
 *radius:弧度
 */
+ (UIButton *)buttonWithTitle:(NSString *)title font:(CGFloat)size titleColor:(NSString *)titleColor backgroundColor:(NSString *)bgColor cornerRadius:(CGFloat)radius;

+ (UIButton *)buttonWithTitle:(NSString *)title font:(CGFloat)size titleColor:(NSString *)titleColor;

@end

NS_ASSUME_NONNULL_END
