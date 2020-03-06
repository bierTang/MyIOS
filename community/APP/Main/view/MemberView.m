//
//  MemberView.m
//  community
//
//  Created by 蔡文练 on 2019/10/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "MemberView.h"

@implementation MemberView

- (instancetype)initWithArray:(NSArray *)arr
{
    self = [super init];
    if (self) {
        [self initUI:arr];
    }
    return self;
}

-(void)initUI:(NSArray *)arr{
    
//    __block UIView *lastView = nil;
    
    NSMutableArray *masonryArr = [NSMutableArray new];

    for (int i=0; i<arr.count; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor redColor];
        [self addSubview:view];
        
        [masonryArr addObject:view];
        
//        lastView = view;
    }
    
    [masonryArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:27 leadSpacing:35 tailSpacing:35];
    
    // 设置array的垂直方向的约束
    [masonryArr makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(10);
        make.height.equalTo(50);
    }];
}



//- (NSMutableArray *)masonryViewArray {
//
//    if (!_masonryViewArray) {
//
//        _masonryViewArray = [NSMutableArray array];
//        for (int i = 0; i < 4; i ++) {
//
//            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor redColor];
//            [self.view addSubview:view];
//            [_masonryViewArray addObject:view];
//        }
//    }
//
//    return _masonryViewArray;
//}

@end
