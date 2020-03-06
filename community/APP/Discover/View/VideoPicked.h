//
//  VideoPicked.h
//  community
//
//  Created by 蔡文练 on 2019/10/21.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPicked : UIView

@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,strong)UIButton *playBtn;

@property (nonatomic,strong)UIButton *closeBtn;

@property (nonatomic,copy) void(^delBlock)(void);

@end

NS_ASSUME_NONNULL_END
