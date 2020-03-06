//
//  YLCustomView.h
//  YLLoopScrollView
//
//  Created by weiyulong on 2018/7/29.
//  Copyright © 2018年 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLCustomViewModel;
@interface YLCustomView : UIView

@property (nonatomic, strong) YLCustomViewModel *model;

@end


@interface YLCustomViewModel : NSObject


@property (nonatomic, copy)   NSString *link;
@property (nonatomic, copy)   NSString *logo;

@end
