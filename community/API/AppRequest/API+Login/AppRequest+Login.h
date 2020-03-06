//
//  AppRequest+Login.h
//  community
//
//  Created by 蔡文练 on 2019/9/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (Login)

-(void)requestLogin:(NSString *)phoneNumber password:(NSString *)password Block:(void(^)(AppRequestState state,id result))callBack;

///注册
-(void)requestRegister:(NSDictionary *)param Block:(void(^)(AppRequestState state,id result))callBack;

@end

NS_ASSUME_NONNULL_END
