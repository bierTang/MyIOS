//
//  LRSliderMenuView.h
//  VerifyImage
//
//  Created by LR on 2017/12/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRSliderMenuView;
@protocol LRSliderMenuViewDelegate <NSObject>

@optional
- (void)sliderMenuView:(LRSliderMenuView *)sliderMenuView didClickMenuItemAtIndex:(NSInteger)index;
@end

@interface LRSliderMenuView : UIView

@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) UIColor *titleViewBackgroundColor;
@property (nonatomic,weak) id<LRSliderMenuViewDelegate> delegate;

@property (nonatomic,assign) NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray *)titleArray
                  titleHeight:(CGFloat)titleHeight
                  normalColor:(UIColor *)normalColor
                selectedColor:(UIColor *)selectedColor
                   normalFont:(UIFont *)normalFont
                 selectedFont:(UIFont *)selectedFont
               normalFontSize:(CGFloat)normalFontSize
             selectedFontSize:(CGFloat)selectedFontSize;
@end
