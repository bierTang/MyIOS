//
//  CTBSlideMenu.h
//  CoinToBe
//
//  Created by 高峰 on 2018/2/5.
//  Copyright © 2018年 GF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CustomPageTabTitleStyle) {
    CustomPageTabTitleStyleDefault, //正常
    CustomPageTabTitleStyleGradient, //渐变
    CustomPageTabTitleStyleBlend //填充
};

typedef NS_ENUM(NSInteger,CustomPageTabIndicatorStyle) {
    CustomPageTabIndicatorStyleDefault, //正常，自定义宽度
    CustomPageTabIndicatorStyleFollowText, //跟随文本长度变化
    CustomPageTabIndicatorStyleStretch //拉伸
};

@protocol CustomPageScrollViewDelegate <NSObject>
/*切换完成代理方法*/
- (void)pageTabViewDidEndChange:(NSInteger)selectedTabIndex;
@end

@interface CustomSlideMenu : UIView

@property(nonatomic,copy)void(^showPopViewBlock)(UITapGestureRecognizer *tap);

@property (nonatomic, weak) id<CustomPageScrollViewDelegate> customDelegate;

/*设置当前选择项（无动画效果）*/
@property (nonatomic, assign) NSInteger selectedTabIndex;
/*一页展示最多的item个数，如果比item总数少，按照item总数计算*/
@property (nonatomic, assign) NSInteger maxNumberOfPageItems;
/*tab size，默认(self.width, 38.0)*/
@property (nonatomic, assign) CGSize tabSize;
/*item的字体大小*/
@property (nonatomic, strong) UIFont *tabItemFont;
/*item的字体大小*/
@property (nonatomic, strong) UIFont *tabItemSelectFont;
/*未选择颜色*/
@property (nonatomic, strong) UIColor *unSelectedColor;
/*当前选中颜色*/
@property (nonatomic, strong) UIColor *selectedColor;
/*tab背景色，默认white*/
@property (nonatomic, strong) UIColor *tabBackgroundColor;
/*indicatorView 背景色*/
@property (nonatomic, strong) UIColor *indicatorViewColor;
/*body背景色，默认white*/
@property (nonatomic, strong) UIColor *bodyBackgroundColor;
/*是否打开body的边界弹动效果*/
@property (nonatomic, assign) BOOL bodyBounces;
/*Title效果设置*/
@property (nonatomic, assign)CustomPageTabTitleStyle titleStyle;
/*字体渐变，未选择的item的scale，默认是0.8（0~1）。仅XXPageTabTitleStyleScale生效*/
@property (nonatomic, assign) CGFloat minScale;
/*当前选择的标题*/
@property(nonatomic,copy)NSString *currentSelectTitle;

/*Indicator效果设置*/
@property (nonatomic, assign) CustomPageTabIndicatorStyle indicatorStyle;
/*下标高度，默认是2.0*/
@property (nonatomic, assign) CGFloat indicatorHeight;
/*下标宽度，默认是0。XXPageTabIndicatorStyleFollowText时无效*/
@property (nonatomic, assign) CGFloat indicatorWidth;
@property(assign)  BOOL notShowDown;//是否显示向下箭头
- (instancetype)initWithChildControllers:(NSArray<UIView*> *)childView childTitles:(NSArray<NSString *> *)childTitles tabItem:(NSUInteger )numItem DownSign:(BOOL)isShow;

@end
