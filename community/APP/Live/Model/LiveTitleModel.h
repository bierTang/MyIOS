//
//  PingdaoModel.h
//  community
//
//  Created by MAC on 2020/3/7.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveTitleModel : NSObject
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *sort;
@property (nonatomic,strong)NSString *update_time;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *is_diff;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *need_pass;

@end

NS_ASSUME_NONNULL_END
