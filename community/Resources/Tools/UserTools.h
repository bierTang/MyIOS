//
//  UserTools.h
//  community
//
//  Created by 蔡文练 on 2019/9/29.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTools : NSObject

+(BOOL )isLogin;


+(void)loginOut;

+(NSString *)userID;

+(NSString *)isVip;

+(NSString *)token;

+(NSString *)nickName;

+(NSString *)avatar;

+(NSInteger)userBlance;

+(NSString *)AgentID;

+(NSString *)ShareUserId;

+(BOOL)isAgentVersion;

@end

NS_ASSUME_NONNULL_END
