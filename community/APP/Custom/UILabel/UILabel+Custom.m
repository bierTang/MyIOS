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

- (void)setColumnSpace:(CGFloat)columnSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
}

- (void)setRowSpace:(CGFloat)rowSpace
{
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}
   


@end
