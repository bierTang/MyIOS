//
//  DownVideoTool.h
//  community
//
//  Created by 蔡文练 on 2019/11/20.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownVideoTool : NSObject

@property (nonatomic,copy)void (^progressBlock)(id progress);


@property (nonatomic,copy)void (^completBlock)(void);

- (void)downloadVideo:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
