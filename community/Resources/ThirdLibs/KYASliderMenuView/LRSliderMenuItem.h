//
//  LRSliderMenuItem.h
//  VerifyImage
//
//  Created by LR on 2017/12/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRSliderMenuItem : UILabel
@property (nonatomic,assign) CGFloat scale;
@property (nonatomic,assign) BOOL selected;

- (instancetype)initWithNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;
- (instancetype)initWithNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize;
@end
