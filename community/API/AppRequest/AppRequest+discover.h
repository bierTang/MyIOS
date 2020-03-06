//
//  AppRequest+discover.h
//  community
//
//  Created by 蔡文练 on 2019/10/18.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (discover)

-(void)requestdiscoverCurrent:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack;

@end

NS_ASSUME_NONNULL_END
