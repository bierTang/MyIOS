//
//  MyInfoModel.h
//  community
//
//  Created by 蔡文练 on 2019/10/29.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyInfoModel : NSObject

@property (nonatomic,copy)NSString *attention_num;  //" = 0;
@property (nonatomic,copy)NSString *expiration_time;  //" = "2020-3-3";
@property (nonatomic,copy)NSString *favorite_num;  //" = 0;
@property (nonatomic,copy)NSString *qq;  // = 123;
@property (nonatomic,copy)NSString *wx;  // = 2333;


@end

NS_ASSUME_NONNULL_END
