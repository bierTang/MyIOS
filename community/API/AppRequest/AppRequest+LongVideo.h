//
//  AppRequest+LongVideo.h
//  community
//
//  Created by MAC on 2020/1/13.
//  Copyright © 2020 cwl. All rights reserved.
//


#import "AppRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (LongVideo)

-(void)requestVideoTitleBlock:(void(^)(AppRequestState state,id result))callBack;

-(void)requestVideoListType:(NSString *)categoryId current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack;

///观看视频
-(void)requestMyseeingVideo:(NSString *)userId videoId:(NSString *)videoId Block:(void(^)(AppRequestState state,id result))callBack;

///请求视频历史记录
-(void)requestVideoHistory:(NSString *)userid current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack;
///搜索视频
-(void)requestVideoScan:(NSString *)userid current:(NSString *)current page:(NSString *)page keywords:(NSString *)keywords Block:(void(^)(AppRequestState state,id result))callBack;
@end

NS_ASSUME_NONNULL_END
