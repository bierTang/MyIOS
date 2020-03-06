//
//  CTBTabItem.m
//  CoinToBe
//
//  Created by 高峰 on 2018/2/5.
//  Copyright © 2018年 GF. All rights reserved.
//

#import "CustomTabItem.h"

@implementation CustomTabItem
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if([_fillColor isKindOfClass:[UIColor class]]) {
        [_fillColor setFill];
        UIRectFillUsingBlendMode(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*_process, rect.size.height), kCGBlendModeSourceIn);
    }
}

- (void)setProcess:(CGFloat)process {
    _process = process;
    [self setNeedsDisplay];
}
@end
