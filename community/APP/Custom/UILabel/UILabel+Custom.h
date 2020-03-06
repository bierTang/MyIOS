//
//  UILabel+Custom.h
//  WeathComeProject
//
//  Created by GF on 2019/3/7.
//  Copyright © 2019 GF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Custom)
/****
 *param
 *title:标题
 *sizeL:字体大小
 *colorStr:字体颜色 十六进制
 *alignment:对齐方式
 */
+ (UILabel *)labelWithTitle:(NSString *)title font:(CGFloat)size textColor:(NSString *)color textAlignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
