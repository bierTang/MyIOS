//
//  SegHeadView.h
//  community
//
//  Created by MAC on 2020/1/5.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegHeadView : UIView

@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)UIButton *saveBtn;

@property (nonatomic,copy) void(^segBlock)(NSInteger type);


@property (nonatomic,strong)NSMutableArray *allBtnArr;

- (instancetype)initWithSegArray:(NSArray *)arr;
-(void)titleBtnSelected:(NSInteger)index;
-(void)titleBtnSelectedYi:(CGFloat)index;
@end

NS_ASSUME_NONNULL_END
