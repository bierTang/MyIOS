//
//  UserModel.h
//  community
//
//  Created by 蔡文练 on 2019/9/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property (nonatomic,strong)NSString *access_token;
@property (nonatomic,strong)NSString *activated;
@property (nonatomic,strong)NSString *agent;
@property (nonatomic,strong)NSString *attention_num;
@property (nonatomic,strong)NSString *avatar;
@property (nonatomic,strong)NSString *card_number;
@property (nonatomic,strong)NSString *coin;
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSString *favorite_num;
@property (nonatomic,strong)NSString *idss;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *nickname;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *update_time;
@property (nonatomic,strong)NSString *uuid;

@property (nonatomic,strong)NSString *qq;
@property (nonatomic,strong)NSString *wx;
@property (nonatomic,strong)NSString *expiration_time;

@property (nonatomic,strong)NSString *discover_num;

@property (nonatomic,strong)NSString *agent_code;

@property (nonatomic,strong)NSString *is_vip;
@end

NS_ASSUME_NONNULL_END
