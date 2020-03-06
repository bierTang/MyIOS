//
//  CSCellView.h
//  community
//
//  Created by 蔡文练 on 2019/9/12.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSCellView : UIView

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *subLab;
@property (nonatomic,strong)UIImageView *arrowImg;

@property (nonatomic,strong)UIView *lineView;

-(void)freshTitle:(NSString *)title andSubtitle:(NSString *)subTitle showLine:(BOOL)show;


@end

NS_ASSUME_NONNULL_END
