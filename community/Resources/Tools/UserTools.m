//
//  UserTools.m
//  community
//
//  Created by 蔡文练 on 2019/9/29.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "UserTools.h"

@implementation UserTools

/**
 *获取用户 user ID
 */
+(NSString *)userID{
    return [[CSCaches shareInstance]getValueForKey:USERID];
}

+(BOOL)isAgentVersion{
    return [[[CSCaches shareInstance]getValueForKey:AGENTID] integerValue] > 0;
}

+(NSString *)AgentID{
    return [[CSCaches shareInstance]getValueForKey:AGENTID];
}
+(NSString *)token{
    return [[CSCaches shareInstance]getValueForKey:TOKEN];
}
+(NSString *)ShareUserId{
    return [[CSCaches shareInstance]getValueForKey:SHAREUSER];
}

+(NSInteger)userBlance{
    return [[[CSCaches shareInstance]getValueForKey:USERBLANCE] integerValue];
}

+(BOOL )isLogin{
    if ([[CSCaches shareInstance]getValueForKey:USERID].length > 0 && [[CSCaches shareInstance]getValueForKey:TOKEN].length > 0) {
        return YES;
    }else
    return NO;
}

+(void)loginOut{
    [[CSCaches shareInstance]removeDefaultValueKey:USERID];
    [[CSCaches shareInstance]removeDefaultValueKey:TOKEN];
    [[CSCaches shareInstance]removeDefaultValueKey:USERMODEL];
    [[CSCaches shareInstance]removeDefaultValueKey:USERBLANCE];

}

+(NSString *)nickName{
   return [[CSCaches shareInstance]getUserModel:USERMODEL].nickname;
}

+(NSString *)avatar{
    return [[CSCaches shareInstance]getUserModel:USERMODEL].avatar;
}

@end
