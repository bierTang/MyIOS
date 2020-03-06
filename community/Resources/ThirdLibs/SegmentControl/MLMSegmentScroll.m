

#import "MLMSegmentScroll.h"
#import "UIView+ViewController.h"
@interface MLMSegmentScroll () <NSCacheDelegate,UIScrollViewDelegate>
{
    NSMutableArray *viewsArray;
}
@property (nonatomic, strong) NSCache *viewsCache;//存储页面(使用计数功能)

@end

@implementation MLMSegmentScroll

#pragma mark - init Method
- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources {
    if (self = [super initWithFrame:frame]) {
        viewsArray = [sources mutableCopy];
        [self defaultSet];
    }
    return self;
}

#pragma mark - default setting
- (void)defaultSet {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    [self setContentSize:CGSizeMake(viewsArray.count *self.frame.size.width, self.frame.size.height)];
    
    _countLimit = viewsArray.count;
}

#pragma mark - viewsCache
- (NSCache *)viewsCache {
    if (!_viewsCache) {
        _viewsCache = [[NSCache alloc] init];
        _viewsCache.countLimit = _countLimit;
        _viewsCache.delegate = self;
        _viewsCache.evictsObjectsWithDiscardedContent = YES;
    }
    return _viewsCache;
}


#pragma mark - default add View 
- (void)createView {
    _showIndex = MIN(viewsArray.count-1, MAX(0, _showIndex));
    [self setContentOffset:CGPointMake(_showIndex * self.frame.size.width, 0)];
    
    if (_loadAll) {
        NSInteger startIndex;
        if (viewsArray.count-_showIndex > _countLimit) {
            startIndex = _showIndex;
        } else {
            startIndex = viewsArray.count - _countLimit;
        }
        for (NSInteger i = startIndex; i < startIndex + _countLimit; i ++) {
            [self addViewCacheIndex:i];
        }
    } else {
        [self addViewCacheIndex:_showIndex];
    }
}

#pragma mark - addView
- (void)addViewCacheIndex:(NSInteger)index {
    if (viewsArray.count < index) {
        return;
    }
    id object = viewsArray[index];
    if ([object isKindOfClass:[NSString class]]) {
        Class class = NSClassFromString(object);
        if ([class isSubclassOfClass:[UIViewController class]]) {//vc
            UIViewController *vc = [class new];
            [self addVC:vc atIndex:index];
        } else if ([class isSubclassOfClass:[UIView class]]){//view
            UIView *view = [class new];
            [self addView:view atIndex:index];
        } else {
            NSLog(@"please enter the correct name of class!");
        }
    } else {
        if ([object isKindOfClass:[UIViewController class]]) {
            [self addVC:object atIndex:index];
        } else if ([object isKindOfClass:[UIView class]]) {
            [self addView:object atIndex:index];
        } else {
            NSLog(@"this class was not found!");
        }
    }
    
}

#pragma mark - addvc
- (void)addVC:(UIViewController *)vc atIndex:(NSInteger)index {
    if (![self.viewsCache objectForKey:@(index)]) {
        [self.viewsCache setObject:vc forKey:@(index)];
    }
    
    vc.view.frame = CGRectMake(index*self.frame.size.width, 0, self.frame.size.width,self.frame.size.height);
    [self.viewController addChildViewController:vc];
    [self addSubview:vc.view];
}

#pragma mark - addview
- (void)addView:(UIView *)view atIndex:(NSInteger)index {
    if (![self.viewsCache objectForKey:@(index)]) {
        [self.viewsCache setObject:view forKey:@(index)];
    }
    view.frame = CGRectMake(index*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height-self.subtractHeight);
    [self addSubview:view];
}


#pragma mark - scrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self]) {
        CGFloat scale = scrollView.contentOffset.x/scrollView.contentSize.width;
        if ([self.segDelegate respondsToSelector:@selector(scrollOffsetScale:)]) {
            [self.segDelegate scrollOffsetScale:scale];
        } else if (self.offsetScale) {
            self.offsetScale(scale);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self]) {
        //滑动结束
        NSInteger currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
        if ([self.segDelegate respondsToSelector:@selector(scrollEndIndex:)]) {
            [self.segDelegate scrollEndIndex:currentIndex];
        } else if (self.scrollEnd) {
            self.scrollEnd(currentIndex);
        }
        if (![_viewsCache objectForKey:@(currentIndex)]) {
            [self addViewCacheIndex:currentIndex];
        }
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self]) {
        //动画结束
        NSInteger currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
        if ([self.segDelegate respondsToSelector:@selector(scrollEndIndex:)]) {
            [self.segDelegate animationEndIndex:currentIndex];
        } else if (self.animationEnd) {
            self.animationEnd(currentIndex);
        }
        if (![_viewsCache objectForKey:@(currentIndex)]) {
            [self addViewCacheIndex:currentIndex];
        }
    }
}



#pragma mark - NSCacheDelegate
-(void)cache:(NSCache *)cache willEvictObject:(id)obj {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //进入后台不清理
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            return;
        }
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = obj;
            [vc.view removeFromSuperview];
            vc.view = nil;
            [vc removeFromParentViewController];
        } else {
            UIView *vw = obj;
            [vw removeFromSuperview];
            vw = nil;
        }
       
    });
}

#pragma mark - dealloc
- (void)dealloc {
    self.delegate = nil;
    _viewsCache.delegate = nil;
    _viewsCache = nil;
}

@end
