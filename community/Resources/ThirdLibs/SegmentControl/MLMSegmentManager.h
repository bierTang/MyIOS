

#import <Foundation/Foundation.h>
#import "MLMSegmentHead.h"
#import "MLMSegmentScroll.h"


@interface MLMSegmentManager : NSObject

/**
 * 绑定两个view
 */
+ (void)associateHead:(MLMSegmentHead *)head withScroll:(MLMSegmentScroll *)scroll completion:(void(^)(void))completion;


+ (void)associateHead:(MLMSegmentHead *)head  withScroll:(MLMSegmentScroll *)scroll completion:(void(^)(void))completion  selectBegin:(void(^)(void))selectbegin selectEnd:(void(^)(NSInteger index))selectEnd selectScale:(void(^)(CGFloat scale))selectScale;
@end
