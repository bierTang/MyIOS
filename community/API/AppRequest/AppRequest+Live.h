//
//  AppRequest+Live.h
//  community
//
//  Created by MAC on 2020/2/15.
//  Copyright © 2020 cwl. All rights reserved.
//


#import "AppRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (Live)

///请求直播地址
-(void)requestLiveAddressListBlock:(void(^)(AppRequestState state,id result))callBack;

//直播频道列表
-(void)requestLiveChannelListBlock:(void(^)(AppRequestState state,id result))callBack;


-(void)requestLiveList:(NSString *)name Block:(void(^)(AppRequestState state,id result))callBack;


@end

NS_ASSUME_NONNULL_END
