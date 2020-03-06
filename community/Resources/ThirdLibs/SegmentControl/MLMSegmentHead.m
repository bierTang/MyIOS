

#import "MLMSegmentHead.h"


#define SCROLL_WIDTH (self.frame.size.width )
#define SCROLL_HEIGHT (self.frame.size.height - _bottomLineHeight)

#define CURRENT_WIDTH(s) [titleWidthArray[s] floatValue]


static CGFloat animation_time = 0.3;

@interface MLMSegmentHead ()
/**
 *  MLMSegmentHeadStyle
 */
@property (nonatomic, assign) MLMSegmentHeadStyle headStyle;

/**
 *  MLMSegmentHeadStyle
 */
@property (nonatomic, assign) MLMSegmentLayoutStyle layoutStyle;

@end

@implementation MLMSegmentHead
{
    NSMutableArray *titlesArray;///标题数组
    UIScrollView *titlesScroll;

    NSMutableArray *buttonArray;//按钮数组

    
    UIView *lineView;//下划线view
    CAShapeLayer *arrow_layer;//箭头layer
    
    UIButton *slideView;//滑块btn

    UIScrollView *slideScroll;
    
    UIView *bottomLineView;//分割线
    
    NSInteger currentIndex;//当前选中的按钮
    
    NSInteger isSelected;//区分点击还是滑动
    
    NSMutableArray *titleWidthArray; //button宽度的数组，总宽度
    CGFloat sum_width;
    //用来判断向左向右
    CGFloat endScale;
}


#pragma mark - initMethod
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    return [self initWithFrame:frame titles:titles headStyle:SegmentHeadStyleSlide];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles headStyle:(MLMSegmentHeadStyle)style {
    return [self initWithFrame:frame titles:titles headStyle:style layoutStyle:MLMSegmentLayoutCenter];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles headStyle:(MLMSegmentHeadStyle)style layoutStyle:(MLMSegmentLayoutStyle)layout {
    if (self = [super initWithFrame:frame]) {
        _headStyle = style;
        _layoutStyle = layout;
        titlesArray = [titles mutableCopy];
        [self initCustom];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SelectButtnNotificationValueChange:) name:@"SelectButtnNotification" object:nil];

    }
    return self;
}

#pragma mark  SelectButtnNotificationValueChange————>通知Action
-(void)SelectButtnNotificationValueChange:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    [self changeSelectIndexPage:[[nameDictionary objectForKey:@"selectButtn_index"] integerValue]];
}

#pragma mark - custom init
- (void)initCustom {
    _headColor = [UIColor colorWithHexString:@"f5f5f5"];
    _selectColor = [UIColor blackColor];
    _deSelectColor = [UIColor lightGrayColor];

    buttonArray = [NSMutableArray array];
    _showIndex = 0;
    
    _fontSize = 12;
    _fontScale = 1;
    
    _singleW_Add = 20;
    
    _lineColor = _selectColor;
    _lineHeight = 2.5;
    _lineScale = 1;
    
    _arrowColor = _selectColor;
    
    _slideHeight = 24;
    _slideColor = _deSelectColor;
    
    _slideCorner = _slideHeight/2;
    
    _slideScale = 1 ;
    _maxTitles = 5.0;

}

#pragma mark - layout
- (void)defaultAndCreateView {
    if (!titleWidthArray) {
        titleWidthArray = [NSMutableArray arrayWithCapacity:titlesArray.count];
    }
    [titleWidthArray removeAllObjects];
    
    _maxTitles = _maxTitles>titlesArray.count?titlesArray.count:_maxTitles;

    
    [self titlesWidth];

    if (_equalSize) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sum_width+_moreButton_width, self.frame.size.height) ;
        
        if (titlesScroll) {
            titlesScroll.frame = CGRectMake(titlesScroll.frame.origin.x, titlesScroll.frame.origin.y, SCREEN_WIDTH,titlesScroll.frame.size.height) ;
        }
        if (slideScroll) {
            slideScroll.frame =  CGRectMake(slideScroll.frame.origin.x, slideScroll.frame.origin.y, SCREEN_WIDTH,slideScroll.frame.size.height);
        }
    }
    
    //判断总宽度
    if (sum_width > SCROLL_WIDTH && _layoutStyle== MLMSegmentLayoutCenter) {
        _layoutStyle = MLMSegmentLayoutLeft;
    }
    
    _showIndex = MIN(titlesArray.count-1, MAX(0, _showIndex));
    currentIndex = _showIndex;
    [self createView];
    [self setSelectIndex:_showIndex];
}


#pragma mark - 根据文字计算宽度
- (void)titlesWidth {
    sum_width = 0;
    CGFloat width = SCROLL_WIDTH/_maxTitles;
    for (NSString *title in titlesArray) {
        if (_layoutStyle != MLMSegmentLayoutDefault) {
            width = [self titleWidth:title];
        }
        [titleWidthArray addObject:@(width)];
        sum_width += width;
    }
}

- (CGFloat)titleWidth:(NSString *)title {
    CGFloat sys_font = _fontScale>1?_fontSize*_fontScale:_fontSize;
    return [title boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:sys_font]} context:nil].size.width + _singleW_Add;
}


#pragma mark - create View
- (void)createView {
    
    _fontScale = _headStyle==SegmentHeadStyleSlide?1:_fontScale;
    titlesScroll = [self customScroll];
    [self scrollViewSubviews:titlesScroll];
    [self addSubview:titlesScroll];
    slideView = [self slideView];
    [titlesScroll addSubview:slideView];
}


#pragma mark - create customScroll
- (UIScrollView *)customScroll {
    if (!titlesArray) {
        return nil;
    }
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];
    scroll.contentSize = CGSizeMake(MAX(SCROLL_WIDTH, sum_width), SCROLL_HEIGHT);
    scroll.backgroundColor = _headColor;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator  = NO;
    scroll.bounces = NO;
    return scroll;
}


#pragma mark - titlesScroll subviews - yes or slideScroll subviews - no
- (void)scrollViewSubviews:(UIScrollView*)scroll {

    CGFloat start_x = 0;
    
    if (_layoutStyle == MLMSegmentLayoutCenter) {
        //计算布局的起点
        start_x = SCROLL_WIDTH/2;
        for (NSInteger i = 0; i < titleWidthArray.count/2; i ++) {
            start_x -= CURRENT_WIDTH(i);
        }
        if (titlesArray.count%2 != 0) {
            start_x -= CURRENT_WIDTH(titleWidthArray.count/2)/2;
        }
    }
    [self createBtn:titlesArray addScroll:scroll startX:start_x start_index:0];
    
}
#pragma mark - createBtn
- (void)createBtn:(NSArray *)titlesArr addScroll:(UIScrollView*)scroll startX:(CGFloat)start_x start_index:(NSInteger)start_index {
    BOOL titles = [scroll isEqual:titlesScroll];
    CGFloat width;
    for (NSInteger i = start_index; i < titlesArr.count; i ++) {
        width = (self.frame.size.width)/titlesArr.count;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titlesArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        button.frame = CGRectMake(start_x, 0, width, SCROLL_HEIGHT);
        start_x += width;
        if (titles) {
            [button setTitleColor:_deSelectColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectedHeadTitles:) forControlEvents:UIControlEventTouchUpInside];
            [buttonArray addObject:button];
        } else {
            [button setTitleColor:_selectColor forState:UIControlStateNormal];
        }
        [scroll addSubview:button];
    }
    scroll.contentSize = CGSizeMake(MAX(SCROLL_WIDTH, sum_width), SCROLL_HEIGHT);
}

#pragma mark - create slide
- (UIButton *)slideView {
    CGFloat slide_w = CURRENT_WIDTH(currentIndex);
    UIButton *slide = [[UIButton alloc] initWithFrame:CGRectMake(0, (SCROLL_HEIGHT-_slideHeight)/2, slide_w*_slideScale, _slideHeight)];
    UIButton *current_btn = buttonArray[currentIndex];
    slide.center = CGPointMake(current_btn.center.x, slide.center.y);
    slide.clipsToBounds = YES;
    slide.layer.cornerRadius = 12;
    slide.backgroundColor = _slideColor;
    slideScroll = [self customScroll];
    [self scrollViewSubviews:slideScroll];
    slideScroll.userInteractionEnabled = NO;
    slideScroll.backgroundColor = [UIColor clearColor];
    CGRect convertRect = [slide convertRect:titlesScroll.frame fromView:titlesScroll.superview];
    slideScroll.frame = CGRectMake(convertRect.origin.x, -(SCROLL_HEIGHT - _slideHeight)/2, SCROLL_WIDTH, SCROLL_HEIGHT);
    [slide addSubview:slideScroll];
    return slide;
}

#pragma mark - button Action
- (void)selectedHeadTitles:(UIButton *)button {
    [self changeSelectIndexPage:[buttonArray indexOfObject:button]];
}

- (void)changeSelectIndexPage:(NSInteger)index {
    {
        //before
        UIButton *before_btn = buttonArray[currentIndex];
        
        NSInteger selectIndex = index;
        
        //repeat click
        if (selectIndex == currentIndex) {
            return;
        }
        //select
        UIButton *select_btn = buttonArray[selectIndex];
        
        [UIView animateWithDuration:animation_time animations:^{
            if (self.headStyle != SegmentHeadStyleSlide) {
                [before_btn setTitleColor:self.deSelectColor forState:UIControlStateNormal];
                [select_btn setTitleColor:self.selectColor forState:UIControlStateNormal];
            }
            
            if (self.fontScale) {
                before_btn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
                select_btn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize*self.fontScale];
            }

            
            if (self->slideView) {
                //slide位置变化
                
                self->slideView.frame = CGRectMake(self->slideView.frame.origin.x, self->slideView.frame.origin.y, select_btn.frame.size.width*self->_slideScale, self->slideView.frame.size.height);
                self->slideView.center = CGPointMake(select_btn.center.x, self->slideView.center.y);
                //偏移
                CGRect convertRect = [self->slideView convertRect:self->titlesScroll.frame fromView:self->titlesScroll];
                self->slideScroll.frame = CGRectMake(convertRect.origin.x, convertRect.origin.y, self->slideScroll.contentSize.width, self->slideScroll.contentSize.height);
            }
        } completion:^(BOOL finished) {
            [self setSelectIndex:selectIndex];
        }];
        
        isSelected = YES;
        if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
            [self.delegate didSelectedIndex:selectIndex];
        } else if (self.selectedIndex) {
            self.selectedIndex(selectIndex);
        }
    }
}

#pragma mark - 点击结束
- (void)animationEnd {
    isSelected = NO;
}

#pragma mark - set index
- (void)setSelectIndex:(NSInteger)index {
    currentIndex = index;
    
    if (sum_width > SCROLL_WIDTH) {
        UIButton *currentBtn = buttonArray[index];
        if (currentBtn.center.x<SCROLL_WIDTH/2) {
            [titlesScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if (currentBtn.center.x > (sum_width-SCROLL_WIDTH/2)) {
            [titlesScroll setContentOffset:CGPointMake(sum_width-SCROLL_WIDTH, 0) animated:YES];
        } else {
            [titlesScroll setContentOffset:CGPointMake(currentBtn.center.x - SCROLL_WIDTH/2, 0) animated:YES];
        }
    }
}


#pragma mark - animation
//外部关联的scrollView变化
- (void)changePointScale:(CGFloat)scale {
    if (isSelected) {
        return;
    }
    if (scale<0) {
        return;
    }
    //区分向左 还是向右
    BOOL left = endScale > scale;
    endScale = scale;
    
    //1.将scale变为对应titleScroll的titleScale
    //每个view所占的百分比
    CGFloat per_view = 1.0/(CGFloat)titlesArray.count;
    //下标
    NSInteger changeIndex = scale/per_view + (left?1:0);
    NSInteger nextIndex = changeIndex + (left?-1:1);
    //超出范围
    if (nextIndex >= titlesArray.count || changeIndex >= titlesArray.count) {
        return;
    }
    //currentbtn
    UIButton *currentBtn = buttonArray[changeIndex];
    UIButton *nextBtn = buttonArray[nextIndex];
    //startscla
    CGFloat start_scale = 0;
    for (NSInteger i = 0; i < nextIndex; i++) {
        start_scale += CURRENT_WIDTH(i)/sum_width;
    }
    //滑动选中位置所占的相对百分比
    CGFloat current_title_Scale = CURRENT_WIDTH(changeIndex)/sum_width;
    //单个view偏移的百分比
    CGFloat single_offset_scale = (scale - per_view*changeIndex)/per_view;
    //转换成对应title的百分比
    CGFloat titleScale = single_offset_scale * current_title_Scale + start_scale;
    //变化的百分比
    CGFloat change_scale = (left?-1:1)*(titleScale - start_scale)/current_title_Scale;

    switch (_headStyle) {
        case SegmentHeadStyleSlide:
        {
            //slide位置变化
            
            float width = [self widthChangeCurWidth:CURRENT_WIDTH(changeIndex) nextWidth:CURRENT_WIDTH(nextIndex) changeScale:change_scale endScale:_slideScale];
            slideView.frame = CGRectMake(slideView.frame.origin.x, slideView.frame.origin.y, width, slideView.frame.size.height);
            CGFloat center_x = [self centerChanegCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
            slideView.center = CGPointMake(center_x, slideView.center.y);
            //偏移
            CGRect convertRect = [slideView convertRect:titlesScroll.frame fromView:titlesScroll];
            slideScroll.frame = CGRectMake(convertRect.origin.x, convertRect.origin.y, slideScroll.contentSize.width, slideScroll.contentSize.height);
        }
            break;
        default:
            break;
    }
}


#pragma mark - 长度变化
- (CGFloat)widthChangeCurWidth:(CGFloat)curWidth nextWidth:(CGFloat)nextWidth changeScale:(CGFloat)changeScale endScale:(CGFloat)endscale{
    //改变的宽度
    CGFloat change_width = curWidth - nextWidth;
    //宽度变化
    CGFloat width = curWidth*endscale - changeScale * change_width;
    return width;
}

#pragma mark - 中心位置的变化
- (CGFloat)centerChanegCurBtn:(UIButton *)curBtn nextBtn:(UIButton *)nextBtn changeScale:(CGFloat)changeScale {
    //lineView改变的中心
    CGFloat change_center = nextBtn.center.x - curBtn.center.x;
    //lineView位置变化
    CGFloat center_x = curBtn.center.x + changeScale * change_center;
    return center_x;
}




#pragma mark - get sumWidth
- (CGFloat)getSumWidth {
    return sum_width;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectButtnNotification" object:nil];

}

@end
