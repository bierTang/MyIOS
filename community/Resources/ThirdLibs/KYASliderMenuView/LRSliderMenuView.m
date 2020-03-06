//
//  LRSliderMenuView.m
//  VerifyImage
//
//  Created by LR on 2017/12/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LRSliderMenuView.h"
#import "LRSliderMenuItem.h"

#define SCREEN_WIDTH2 CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT2 CGRectGetHeight([UIScreen mainScreen].bounds)

#define RESIZE(x) ((x)/375.f*CGRectGetWidth([UIScreen mainScreen].bounds))

#define is_iPHONE_X (SCREEN_HEIGHT == 812 || SCREEN_HEIGHT == 812.0)

//#define NAVIGATIONBAR_HEIGHT (is_iPHONE_X ? 88.0 : 64.0)
#define NAVIGATIONBAR_HEIGHT (is_iPHONE_X ? 88.0 : 64.0)

#define kSeparateViewHeight 1
#define kTitleWidth 64
#define kPadding  19*K_SCALE

//#define kPadding  RESIZE(19)

@interface LRSliderMenuView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *smallScrollView;
//@property (nonatomic,strong) UIScrollView *bigScrollView;
@property (nonatomic,strong) UIView *sliderView;
@property (nonatomic,strong) LRSliderMenuItem *selectedLabel;
@property (nonatomic,assign) CGFloat titleSpace;

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *titleLabelArray;
@property (nonatomic,strong) NSMutableArray *titleLabelWidthArray;
@property (nonatomic,assign) CGFloat titleViewHeight;

@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,strong) UIFont *normalFont;
@property (nonatomic,strong) UIFont *selectedFont;
@property (nonatomic,assign) CGFloat normalFontSize;
@property (nonatomic,assign) CGFloat selectedFontSize;
@end

@implementation LRSliderMenuView

- (NSMutableArray *)titleLabelWidthArray {
    if (!_titleLabelWidthArray) {
        _titleLabelWidthArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleLabelWidthArray;
}
- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleLabelArray;
}
- (void)setTitleViewBackgroundColor:(UIColor *)titleViewBackgroundColor {
    _titleViewBackgroundColor = titleViewBackgroundColor;
    self.smallScrollView.backgroundColor = _titleViewBackgroundColor;
}

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray *)titleArray
                  titleHeight:(CGFloat)titleHeight
                  normalColor:(UIColor *)normalColor
                selectedColor:(UIColor *)selectedColor
                   normalFont:(UIFont *)normalFont
                 selectedFont:(UIFont *)selectedFont
               normalFontSize:(CGFloat)normalFontSize
             selectedFontSize:(CGFloat)selectedFontSize {
    
    if (self = [super initWithFrame:frame]) {
        self.titleArray = [NSMutableArray arrayWithArray:titleArray];
        self.titleViewHeight = titleHeight;
        
        self.normalColor = normalColor;
        self.selectedColor = selectedColor;

        self.normalFont = normalFont;
        self.selectedFont = selectedFont;
        self.normalFontSize = normalFontSize;
        self.selectedFontSize = selectedFontSize;
        [self createContentView];
        [self addTitileLabel];
        
//        self.selectIndex = 0;
    }
    return self;
}

- (void)createContentView {
    _smallScrollView = [[UIScrollView alloc]init];
    _smallScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.titleViewHeight);
    _smallScrollView.showsHorizontalScrollIndicator = NO;
    _smallScrollView.showsVerticalScrollIndicator = NO;
    _smallScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_smallScrollView];
    
    UIView *separateView = [[UIView alloc]init];
    separateView.frame = CGRectMake(0, self.titleViewHeight, self.bounds.size.width, kSeparateViewHeight);
    separateView.backgroundColor = [UIColor clearColor];
    [self addSubview:separateView];
    
    _contentScrollView = [[UIScrollView alloc]init];
    _contentScrollView.frame = CGRectMake(0, self.titleViewHeight+kSeparateViewHeight, self.bounds.size.width, self.bounds.size.height-CGRectGetHeight(_smallScrollView.frame)-kSeparateViewHeight);
    _contentScrollView.delegate = self;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.backgroundColor = [UIColor clearColor];//[RGBColor(224, 224, 224) colorWithAlphaComponent:0.8];
    [self addSubview:_contentScrollView];
    
    _contentScrollView.bounces = NO;//不要弹簧效果
    
    //滑块
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(kPadding-4*K_SCALE, self.smallScrollView.frame.size.height-kSeparateViewHeight-2, kTitleWidth, 2)];
    sliderV.backgroundColor = [UIColor colorWithHexString:@"09c66a"];
    [self.smallScrollView addSubview:sliderV];
    [self.smallScrollView bringSubviewToFront:sliderV];
    _sliderView=sliderV;
}

- (void)addTitileLabel {
    
    CGFloat padding = kPadding;
//    CGFloat originY = NAVIGATIONBAR_HEIGHT-RESIZE(16)-RESIZE(11);
//    CGFloat totalTitleWidth = self.titleWidth * self.titleArray.count;
    CGFloat totalTitleWidth = 0;
    
    self.titleSpace = 20*K_SCALE; //RESIZE(35);//(SCREEN_WIDTH-2*padding-totalTitleWidth)/(self.titleArray.count-1);
    
    [self.titleLabelWidthArray removeAllObjects];
    
    for (int i = 0; i< self.titleArray.count; i++) {
        
        LRSliderMenuItem *label = [[LRSliderMenuItem alloc]initWithNormalColor:self.normalColor selectedColor:self.selectedColor normalFontSize:self.normalFontSize selectedFontSize:self.selectedFontSize];
        label.font = self.normalFont;
        
        label.textColor = [UIColor whiteColor];
        NSString *titleStr = self.titleArray[i];
        label.text = titleStr;
        label.tag = i;
        [label sizeToFit];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)]];
        label.backgroundColor = [UIColor clearColor];
        
        CGFloat lblW = 64;
        CGFloat lblH = 44*K_SCALE;//RESIZE(44);//CGRectGetHeight(self.smallScrollView.frame);
        CGFloat lblY = 2*K_SCALE;//NAVIGATIONBAR_HEIGHT-lblH;
        CGFloat lblX = _titleSpace;
        lblW = label.bounds.size.width;
        
        lblX = padding+_titleSpace*i+totalTitleWidth;
        
        totalTitleWidth += lblW;
        
        label.frame = CGRectMake(lblX, lblY, lblW, lblH);
        [self.smallScrollView addSubview:label];
        
        
        
        [self.titleLabelWidthArray addObject:[NSNumber numberWithFloat:lblW]];
        
        label.selected = NO;
        if (i == 0) {
            self.selectedLabel = label;
            self.selectedLabel.selected = YES;
            _sliderView.frame = CGRectMake(kPadding-4*K_SCALE, self.smallScrollView.frame.size.height-kSeparateViewHeight-2, self.selectedLabel.bounds.size.width*self.selectedFontSize/self.normalFontSize, 2);
        }
        [self.titleLabelArray addObject:label];
        
    }
    
    
    self.smallScrollView.contentSize = CGSizeMake(totalTitleWidth+_titleSpace*(self.titleArray.count-1)+2*padding, 0);
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*self.titleArray.count, 0);
}

CGFloat topScale = 0.0;
bool isClick = NO;
- (void)setSelectScale:(CGFloat)selectScale {
   _selectScale = selectScale * self.contentScrollView.contentSize.width;
//     LRSliderMenuItem *temlabel = self.smallScrollView.subviews[2];
//    temlabel.scale = selectScale;
    
     double indexRatio = self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width;
        NSUInteger index = self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width;
        
    //    NSNumber *widthNum = self.titleLabelWidthArray[index];
    //    _sliderView.frame = CGRectMake(kPadding+(_titleSpace+widthNum.floatValue)*indexRatio, self.smallScrollView.frame.size.height-kSeparateViewHeight-2, widthNum.floatValue, 2);
        
    //    [self scrollViewDidEndScrollingAnimation:scrollView];
        
        NSUInteger labelIndex = index+1;//滚动条加在smallScrollView上 要+1
        if (labelIndex +1 >= self.smallScrollView.subviews.count || indexRatio < 0) {
            return;
        }
        NSLog(@"\nindexRatio--- %f\nindex     --- %lu",indexRatio,(unsigned long)index);
    
    LRSliderMenuItem *temlabel = self.smallScrollView.subviews[labelIndex];
        LRSliderMenuItem *temlabelNext = self.smallScrollView.subviews[labelIndex +1];
   
        if ((selectScale-topScale) >= 0) {
            temlabelNext = self.smallScrollView.subviews[labelIndex +1];
            NSLog(@"滑动左","左");
            temlabel.scale = 1 - (selectScale - indexRatio/7)*5;
               temlabelNext.scale =0 + (selectScale - indexRatio/7)*5;
                   topScale = selectScale;
        }else{
            if (!isClick){
                temlabelNext = self.smallScrollView.subviews[labelIndex -1];
                NSLog(@"滑动点击%lu",index);
                if (index != 0) {
                    temlabelNext.scale = 0 - (selectScale - indexRatio/7)*5;
                    topScale = selectScale;
                }
                   
                
            }
            temlabel.scale = 1 + (selectScale - indexRatio/7)*5;
            
        }
//    if (selectScale * self.contentScrollView.contentSize.width > SCREEN_WIDTH){
//
////    }
//    int yidon = selectScale * self.contentScrollView.contentSize.width;
//    int kuan = SCREEN_WIDTH;
//
//    NSLog(@"当前也11 %f",yidon%kuan);
        NSLog(@"当前也 %f",selectScale - indexRatio/7);
    isClick = NO;
   
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    isClick = YES;
    [self selectTitleAtIndex:selectIndex];
//    [self selectTitle:selectIndex];
//    CGFloat offsetX = selectIndex * self.contentScrollView.frame.size.width;
//    CGFloat offsetY = self.contentScrollView.contentOffset.y;
//    CGPoint offset = CGPointMake(offsetX, offsetY);
//
//    [self.contentScrollView setContentOffset:offset animated:NO];
}
- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    UILabel *titleLabel = (UILabel *)recognizer.view;
    //    _titleSliderView.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetHeight(self.smallScrollView.frame)-2, CGRectGetWidth(titleLabel.frame), 2);
    [self selectTitleAtIndex:titleLabel.tag];
    
}
- (void)selectTitleAtIndex:(NSInteger)index {
    
//    UILabel *titleLabel = self.smallScrollView.subviews[index];
    
//    [self selectTitle:index];//滚动条加在smallScrollView上 要+1
    CGFloat offsetX = index * self.contentScrollView.frame.size.width;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.contentScrollView setContentOffset:offset animated:NO];
    
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    //    [self scrollViewWillBeginDragging:self.bigScrollView];
    
//    //smallScrollView
//    if (self.smallScrollView.contentSize.width > self.bounds.size.width) {
//        //    NSInteger yushu = (int)titleLabel.center.x % (int)self.smallScrollView.frame.size.width;
//        //    NSInteger quzheng = titleLabel.center.x / self.smallScrollView.frame.size.width;
//        CGFloat offsetx = titleLabel.center.x - self.smallScrollView.frame.size.width * 0.5;
//        CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
//        NSLog(@"offsetx %f, offsetMax %f",offsetx,offsetMax);
//        if (offsetx < 0) {
//            offsetx = 0;
//        }else if (offsetx > offsetMax) {
//            offsetx = offsetMax;
//        }
//        //    CGPoint offset1 = CGPointMake(titleLabel.center.x, self.smallScrollView.contentOffset.y);
//        CGPoint offset1 = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
//        [self.smallScrollView setContentOffset:offset1 animated:YES];
//    }
}
- (void)selectTitle:(NSInteger)index {
    if (index < 0) {
        index = 0;
    }
    LRSliderMenuItem *tempL = self.titleLabelArray[index];
    if (self.selectedLabel == tempL) {//防重复点击
        return;
    }
    self.selectedLabel.selected = NO;
    self.selectedLabel = self.titleLabelArray[index];
    self.selectedLabel.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(sliderMenuView:didClickMenuItemAtIndex:)]) {
        [self.delegate sliderMenuView:self didClickMenuItemAtIndex:index];
    }
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    double indexRatio = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    NSLog(@"从厕所ss--- %f",indexRatio);
//    NSNumber *widthNum = self.titleLabelWidthArray[index];
//    _sliderView.frame = CGRectMake(kPadding+(_titleSpace+widthNum.floatValue)*indexRatio, self.smallScrollView.frame.size.height-kSeparateViewHeight-2, widthNum.floatValue, 2);
    
//    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSUInteger labelIndex = index+1;//滚动条加在smallScrollView上 要+1
    if (labelIndex +1 >= self.smallScrollView.subviews.count || indexRatio < 0) {
        return;
    }
    NSLog(@"\nindexRatio--- %f\nindex     --- %lu",indexRatio,(unsigned long)index);
    LRSliderMenuItem *temlabel = self.smallScrollView.subviews[labelIndex];
    LRSliderMenuItem *temlabelNext = self.smallScrollView.subviews[labelIndex +1];
//    if ((indexRatio-index) <= 0) {
//        temlabelNext = self.smallScrollView.subviews[labelIndex -1];
//    }else{
//        temlabelNext = self.smallScrollView.subviews[labelIndex +1];
//    }
    CGPoint point = [scrollView.panGestureRecognizer translationInView:self];
    NSLog(@"point--- %@",NSStringFromCGPoint(point));
    if (point.x > 0) {//手指向右滑 滚动条向左
        temlabelNext = self.smallScrollView.subviews[labelIndex -1];
    }else{
        temlabelNext = self.smallScrollView.subviews[labelIndex +1];
    }
    
    CGRect frame = temlabel.frame;
    CGRect nextFrame = temlabelNext.frame;
    CGFloat x = CGRectGetMinX(frame)+(CGRectGetWidth(frame)+_titleSpace)*(indexRatio-index);
    CGFloat y = CGRectGetHeight(self.smallScrollView.frame)-2;
    CGFloat width = CGRectGetWidth(nextFrame);//CGRectGetWidth(nextFrame)-(CGRectGetWidth(nextFrame)-CGRectGetWidth(frame))*(indexRatio-index);
    CGFloat height = 2;
    _sliderView.frame = CGRectMake(x, y, width, height);
    
//    NSLog(@"\nframe--%@\nnextFrame---%@",NSStringFromCGRect(frame),NSStringFromCGRect(nextFrame));
//    NSLog(@"\n_sliderView.frame--%@",NSStringFromCGRect(_sliderView.frame));
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width +1;
    if (scrollView == _contentScrollView) {
        [self selectTitle:index -1];
    }

    //smallScrollView
    if (self.smallScrollView.contentSize.width > self.bounds.size.width) {
        UILabel *titleLabel = self.smallScrollView.subviews[index];

        CGFloat offsetx = titleLabel.center.x - self.smallScrollView.frame.size.width * 0.5;
        CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
        NSLog(@"offsetx %f, offsetMax %f",offsetx,offsetMax);
        if (offsetx < 0) {
            offsetx = 0;
        }else if (offsetx > offsetMax) {
            offsetx = offsetMax;
        }
        CGPoint offset1 = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);

        [self.smallScrollView setContentOffset:offset1 animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.smallScrollView setContentOffset:offset1 animated:YES];
//            [weakSelf.smallScrollView setContentOffset:offset1 animated:YES];
            
        });
        //    [self.smallScrollView setContentOffset:offset1 animated:YES];
    }


    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LRSliderMenuItem *temlabel = self.smallScrollView.subviews[idx];
        if (temlabel != _sliderView) {


            if (idx != index) {
//                temlabel.textColor = [UIColor grayColor];
    //            temlabel.scale = 0.0;//回到正常状态
           
                temlabel.selected = NO;
            }else{
                temlabel.selected = YES;
//                temlabel.textColor = [UIColor whiteColor];
    //            temlabel.scale = 1.0;
    //                CGRect frame = [self convertRect:temlabel.frame fromView:self.smallScrollView];//转换坐标
                CGRect frame = temlabel.frame;
                _sliderView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(self.smallScrollView.frame)-2, CGRectGetWidth(frame), 2);
            }
        }

    }];
    
}




/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end
