//
//  LiveChannelVC.h
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DaLiveChannelVC : UIViewController

@property (nonatomic,copy) void(^backBlock)(NSString *str);

@property (nonatomic, copy) NSString *name;
- (void)setName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
