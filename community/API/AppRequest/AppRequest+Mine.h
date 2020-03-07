//
//  AppRequest+Mine.h
//  community
//
//  Created by 蔡文练 on 2019/10/22.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (Mine)

///我的关注---暂时没用   用的同城列表
-(void)requestMyAttentionId:(NSString *)userId Block:(void(^)(AppRequestState state,id result))callBack;

///我的收藏
-(void)requestMycollectId:(NSString *)userId page:(NSString *)page current:(NSString *)current Block:(void(^)(AppRequestState state,id result))callBack;

///修改个人信息
-(void)requestchangeMyinfo:(NSDictionary *)param Block:(void(^)(AppRequestState state,id result))callBack;

///个人信息查询
-(void)requestGetMyinfo:(NSString *)userId Block:(void(^)(AppRequestState state,id result))callBack;

///我的发布
-(void)requestMyPost:(NSString *)userId current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack;

///删除我的发布
-(void)requestDeleteMyPostdisId:(NSString *)disId Block:(void(^)(AppRequestState state,id result))callBack;

///删除我的收藏
-(void)requestDeleteMyCollectById:(NSString *)colId Block:(void(^)(AppRequestState state,id result))callBack;

///激活码
-(void)requestActivateCard:(NSString *)userId card:(NSString *)card Block:(void(^)(AppRequestState state,id result))callBack;
///卡密列表
-(void)requestMerBerCardBlock:(void(^)(AppRequestState state,id result))callBack;
///会员卡列表
-(void)requestMerBerCardListBlock:(void(^)(AppRequestState state,id result))callBack;

///金币列表
-(void)requestMerBerCoinListBlock:(void(^)(AppRequestState state,id result))callBack;

///购买记录
-(void)requestShopRecord:(NSString *)userId curentpage:(NSString *)page counts:(NSString *)counts Block:(void(^)(AppRequestState state,id result))callBack;

///购买会员卡
-(void)requestMerBerShip:(NSString *)userId type:(NSString *)type number:(NSString *)number Block:(void(^)(AppRequestState state,id result))callBack;


///二维码请求
-(void)requestQRcode:(NSString *)userId Block:(void(^)(AppRequestState state,id result))callBack;

///邀请记录
-(void)requestShareRecord:(NSString *)userId page:(NSString *)page current:(NSString *)current Block:(void(^)(AppRequestState state,id result))callBack;

@end

NS_ASSUME_NONNULL_END
