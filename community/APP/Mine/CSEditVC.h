//
//  CSEditVC.h
//  community
//
//  Created by 蔡文练 on 2019/10/28.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSEditVC : UIViewController

@property(nonatomic,copy) void(^block)(NSString *name);

@end

NS_ASSUME_NONNULL_END
