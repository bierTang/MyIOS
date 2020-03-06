//
//  CSAlertView.h
//  community
//
//  Created by 蔡文练 on 2019/10/18.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSAlertView : UIView

@property (nonatomic,copy) void(^backBlock)(void);

@end

NS_ASSUME_NONNULL_END
