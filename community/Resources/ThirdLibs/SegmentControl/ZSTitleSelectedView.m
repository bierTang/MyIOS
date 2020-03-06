

#import "ZSTitleSelectedView.h"

#define kTagBtnsBase  1903200929  //zs20190321 多个标题按钮 tag初值
#define kRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface ZSTitleSelectedView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *btnLastSelected;
@property (nonatomic, strong) UIView *indicatorView;
@property(nonatomic,strong)NSMutableArray *buttonArray;

@end

@implementation ZSTitleSelectedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addContentView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addContentView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}
-(UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.layer.cornerRadius = 1;
    }
    return _indicatorView;
}

- (void)updateArrayTitles:(NSMutableArray *)arrayTitles
{
    _arrayTitles = arrayTitles;
    [self reloadBtnsTitles];
}

-(void)setNormalfont:(CGFloat )normalfont{
    _normalfont = normalfont;
}
-(void)setSelectFont:(CGFloat )selectFont{
    _selectFont = selectFont;
}
-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
}
-(void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
    _slideColor = _selectColor;
}
-(void)setSlideColor:(UIColor *)slideColor{
    _slideColor = slideColor;
}
#pragma mark - private
- (void)addContentView{
    self.buttonArray = [NSMutableArray array];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.indicatorView];
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    [self onClickAllBtns:self.buttonArray[selectIndex]];
}

- (void)onClickAllBtns:(UIButton*)btn{
    if (btn.selected) {
        return;
    }
    _btnLastSelected.selected = NO;
    _btnLastSelected.titleLabel.font =[UIFont systemFontOfSize:_normalfont];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:_selectFont];
    btn.selected = YES;
    _btnLastSelected = btn;
    
    CGPoint pointCenter = CGPointMake( btn.center.x,btn.frame.size.height-8);
    self.indicatorView.frame = CGRectMake(pointCenter.x,pointCenter.y,23,2);
    self.indicatorView.center = pointCenter;
    if (self.selectCurrentIndex) {
        self.selectCurrentIndex(btn.titleLabel.text);
    }
    if (self.scrollView.contentSize.width < self.frame.size.width) {
        return;
    }
    if (btn.center.x > self.frame.size.width/2.0) {
        if (btn.center.x - self.frame.size.width/2.0 < (self.scrollView.contentSize.width - self.frame.size.width)) {
            [self.scrollView setContentOffset:CGPointMake(btn.center.x - self.frame.size.width/2.0, 0) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentSize.width - self.frame.size.width), 0) animated:YES];
        }
    } else {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)reloadBtnsTitles
{
    self.indicatorView.backgroundColor = _slideColor;
    [self.buttonArray removeAllObjects];
    for (int i = 0; i < self.arrayTitles.count ; i ++) {
        
        UIButton *btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTitle setTitle:_arrayTitles[i] forState:(UIControlStateNormal)];
        btnTitle.titleLabel.font = [UIFont systemFontOfSize:_normalfont];
        [btnTitle setTitleColor:_normalColor forState:(UIControlStateNormal)];
        [btnTitle setTitleColor:_selectColor forState:(UIControlStateSelected)];
        btnTitle.tag = i + kTagBtnsBase;
        [self.buttonArray addObject:btnTitle];
        if (i == 0) {
            _btnLastSelected = btnTitle;
            btnTitle.selected = YES;
            btnTitle.frame = CGRectMake(15, 0,[self getTextWidth:self.arrayTitles[i] font:_selectFont],self.frame.size.height);
            CGPoint pointCenter = CGPointMake( btnTitle.center.x,btnTitle.frame.size.height-8);
            self.indicatorView.frame = CGRectMake(pointCenter.x,pointCenter.y,23,2);
            self.indicatorView.center = pointCenter;
        } else {
            UIButton *btnLast = (UIButton*)[self.scrollView viewWithTag:i + kTagBtnsBase -1];
            btnTitle.frame = CGRectMake(btnLast.frame.origin.x + btnLast.frame.size.width + 20,0,[self getTextWidth:self.arrayTitles[i] font:_selectFont] ,self.frame.size.height);
        }
        [btnTitle addTarget:self action:@selector(onClickAllBtns:) forControlEvents:(UIControlEventTouchUpInside)];
        [_scrollView addSubview:btnTitle];
    }
    
    if (self.arrayTitles.count > 1) {
        
        UIButton *btnLast = [self.scrollView viewWithTag:self.arrayTitles.count - 1 + kTagBtnsBase];
        
        if (btnLast.frame.origin.x + btnLast.frame.size.width + 15 < self.frame.size.width) {
            
            CGFloat widthPara = self.frame.size.width - (btnLast.frame.origin.x + btnLast.frame.size.width + 15);
            CGFloat widthAdd = widthPara/(self.arrayTitles.count -1);
            for (int i = 1; i < self.arrayTitles.count; i ++) {
                UIButton *btn= (UIButton*)[self.scrollView viewWithTag:i + kTagBtnsBase];
                btn.frame = CGRectMake(btn.frame.origin.x + widthAdd, btn.frame.origin.y, btn.frame.size.width,btn.frame.size.height);
                if (i > 1) {
                    UIButton *btnFront = (UIButton*)[self.scrollView viewWithTag:i + kTagBtnsBase -1];
                    btn.frame = CGRectMake(btnFront.frame.origin.x + btnFront.frame.size.width + 10 + widthAdd, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
                }
            }
        } else {
            _scrollView.contentSize = CGSizeMake(btnLast.frame.origin.x + btnLast.frame.size.width  + 15, self.frame.size.height);
        }
    }
}

#pragma mark ------- 计算文本在对应字体下的长度
- (CGFloat)getTextWidth:(NSString*)text font:(CGFloat)fontPara
{
    if ([text isKindOfClass:[NSString class]]) {
        
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontPara]}];
        return size.width;
    } else {
        return 0;
    }
}
#pragma mark - getter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
