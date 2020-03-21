//
//  AppRequest+Chat.h
//  community
//
//  Created by 蔡文练 on 2019/9/3.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "AppRequest.h"
#import "ChatListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (Chat)


///请求公共通知
-(void)requestBoardBlock:(void(^)(AppRequestState state,id result))callBack;

-(void)requestChatList:(NSString *)current Page:(NSString *)page Block:(void(^)(AppRequestState state,id model))callBack;

-(void)requestSessionID:(NSString *)roomId messId:(NSString *)messId current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack;


///广告类型
-(void)requestADSforType:(NSString *)type Block:(void(^)(AppRequestState state,id result))callBack;

///单次金币进群
-(void)requestEnterGroupByCoinID:(NSString *)groupId Block:(void(^)(AppRequestState state,id result))callBack;

///
-(void)requestGroupMemBer:(NSString *)groupId Block:(void(^)(AppRequestState state,id result))callBack;

-(void)requestGroupTop:(NSString *)groupId userid:(NSString *)userid status:(NSString *)status Block:(void(^)(AppRequestState state,id result))callBack;
///版本更新
-(void)requestUpdateBlock:(void(^)(AppRequestState state,id result))callBack;

@end

NS_ASSUME_NONNULL_END
