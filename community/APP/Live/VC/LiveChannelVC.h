//
//  LiveChannelVC.h
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveChannelVC : UIViewController

@property (nonatomic,copy) void(^backBlock)(NSString *str);

@end

NS_ASSUME_NONNULL_END
