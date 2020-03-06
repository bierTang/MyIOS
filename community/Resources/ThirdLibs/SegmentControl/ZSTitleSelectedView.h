

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSTitleSelectedView : UIView

@property (nonatomic, strong) NSMutableArray *arrayTitles;  

@property(nonatomic,copy)void(^selectCurrentIndex)(NSString *selectType);
- (void)updateArrayTitles:(NSMutableArray *)arrayTitles;
@property(nonatomic,copy)UIColor *normalColor;
@property(nonatomic,copy)UIColor *selectColor;
@property(nonatomic,assign)CGFloat normalfont;
@property(nonatomic,assign)CGFloat selectFont;
@property(nonatomic,copy)UIColor *slideColor;
@property(nonatomic,assign)NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
