//
//  LRSliderMenuItem.m
//  VerifyImage
//
//  Created by LR on 2017/12/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LRSliderMenuItem.h"

@interface LRSliderMenuItem()
@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,assign) CGFloat normalFontSize;
@property (nonatomic,assign) CGFloat selectedFontSize;

@end
@implementation LRSliderMenuItem
- (instancetype)initWithNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor {
    return [[LRSliderMenuItem alloc]initWithNormalColor:normalColor selectedColor:selectedColor normalFontSize:1.0 selectedFontSize:1.0];
}

- (instancetype)initWithNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize {
    
    if (self = [super init]) {
        self.normalColor = normalColor;
        self.selectedColor = selectedColor;
        
        self.normalFontSize = normalFontSize;
        self.selectedFontSize = selectedFontSize;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        //        self.font = [UIFont systemFontOfSize:18];
        
        self.normalFontSize = 1.0;
        self.selectedFontSize = 1.0;
        
        self.scale = 0.0;
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.frame = CGRectMake(0, CGRectGetMaxY(frame)-2, frame.size.width, 2);
        [self addSubview:bottomLine];
        _bottomLine = bottomLine;
        
        self.selected = NO;
        _bottomLine.hidden = YES;
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    //    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];
    
//    _bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.frame)-2, self.frame.size.width, 2);
//    if (_scale == 0) {
//        self.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//        _bottomLine.backgroundColor = [UIColor clearColor];
//    }else{
//        self.textColor = [UIColor colorWithRed:186/255.0 green:120/255.0 blue:254/255.0 alpha:1];
//        _bottomLine.backgroundColor = self.textColor;
//    }
    
    
    CGFloat minScale = 1.0;
//    CGFloat trueScale = minScale + (1-minScale)*scale;
    CGFloat trueScale = minScale + (self.selectedFontSize/self.normalFontSize-minScale)*scale;//放大   选中标题字体大小/正常标题字体大小
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (_selected) {
        self.textColor = self.selectedColor;
        self.scale = 1;
    }else{
        self.textColor = self.normalColor;
        self.scale = 0;
    }
    
}

@end
