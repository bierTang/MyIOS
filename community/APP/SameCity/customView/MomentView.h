//
//  MomnetView.h
//  community
//
//  Created by 蔡文练 on 2019/9/19.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MomentView : UIView 

@property (nonatomic,strong)UIButton *addMoreBtn;

@property (nonatomic, strong) NSArray *picPathStringsArray;

@property (nonatomic,strong)NSMutableArray<UIImageView *> *cellImgArr;
@end

NS_ASSUME_NONNULL_END
