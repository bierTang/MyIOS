

#import "MLMSegmentManager.h"
#import "UIView+ViewController.h"

@implementation MLMSegmentManager

+ (void)associateHead:(MLMSegmentHead *)head withScroll:(MLMSegmentScroll *)scroll completion:(void(^)(void))completion {
    [MLMSegmentManager associateHead:head withScroll:scroll completion:completion selectBegin:nil selectEnd:nil selectScale:nil];
//    [MLMSegmentManager associateHead:head withScroll:scroll completion:completion selectEnd:nil];
}

+ (void)associateHead:(MLMSegmentHead *)head  withScroll:(MLMSegmentScroll *)scroll completion:(void(^)(void))completion  selectBegin:(void(^)(void))selectbegin selectEnd:(void(^)(NSInteger index))selectEnd selectScale:(void(^)(CGFloat scale))selectScale {
    NSInteger showIndex;
    showIndex = head.showIndex?head.showIndex:scroll.showIndex;
    head.showIndex = scroll.showIndex = showIndex;
    head.selectedIndex = ^(NSInteger index) {
        if (selectbegin) {
            selectbegin();
        }
        [scroll setContentOffset:CGPointMake(index*SCREEN_WIDTH,0) animated:YES];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    [head defaultAndCreateView];
    scroll.scrollEnd = ^(NSInteger index){
        [head setSelectIndex:index];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.animationEnd = ^(NSInteger index) {
        [head animationEnd];
    };
    scroll.offsetScale = ^(CGFloat scale) {
        [head changePointScale:scale];
        if (selectScale) {
                   selectScale(scale);
               }
    };
    if (completion) {
        completion();
    }
    [scroll createView];
    UIView *view = head.nextResponder?head:scroll;
    UIViewController *currentVC = [view viewController];
    currentVC.automaticallyAdjustsScrollViewInsets = NO;
}

@end
