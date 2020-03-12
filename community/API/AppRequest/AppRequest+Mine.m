//
//  AppRequest+Mine.m
//  community
//
//  Created by 蔡文练 on 2019/10/22.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest+Mine.h"

@implementation AppRequest (Mine)

//我的关注
-(void)requestMyAttentionId:(NSString *)userId Block:(void(^)(AppRequestState state,id result))callBack{
    NSDictionary *param = @{@"user_id":userId};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/post/user_attention_list" Params:param Callback:^(BOOL isSuccess, id result) {
        NSLog(@"我关注：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}
///我的收藏
-(void)requestMycollectId:(NSString *)userId page:(NSString *)page current:(NSString *)current Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"user_id":userId,@"page":page,@"current":current};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/Post/user_favorite_list" Params:param Callback:^(BOOL isSuccess, id result) {
        NSLog(@"我的收藏：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///修改头像
-(void)requestchangeMyinfo:(NSDictionary *)param Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/avatar" Params:param Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///个人信息查询
-(void)requestGetMyinfo:(NSString *)userId Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/receipt" Params:@{@"user_id":userId} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                UserModel *user = [UserModel mj_objectWithKeyValues:result[@"data"]];
                [[CSCaches shareInstance]saveModel:USERMODEL value:user];

                [[CSCaches shareInstance]saveUserDefalt:USERBLANCE value:user.coin];
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:NO];
}


///我的发布
-(void)requestMyPost:(NSString *)userId current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/lists" Params:@{@"user_id":userId,@"current":current,@"page":page} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                NSLog(@"我的发布:%@--%@",result,result[@"msg"]);
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///删除我的发布
-(void)requestDeleteMyPostdisId:(NSString *)disId Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/del_discover" Params:@{@"discover_id":disId,@"user_id":[UserTools userID]} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        NSLog(@"删除：：%@--%@",result,result[@"msg"]);
        
    } HttpMethod:AppRequestPost isAni:YES];
}
///删除我的收藏
-(void)requestDeleteMyCollectById:(NSString *)colId Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/Post/del_favorite" Params:@{@"favorite_id":colId,@"user_id":[UserTools userID]} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        NSLog(@"删除收藏：：%@--%@",result,result[@"msg"]);
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///激活码
-(void)requestActivateCard:(NSString *)userId card:(NSString *)card Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/card/activation" Params:@{@"user_id":userId,@"card_content":card} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                NSLog(@"我的激活:%@--%@",result,result[@"msg"]);
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///会员卡列表
-(void)requestMerBerCardListBlock:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/card/all_card_lists" Params:nil Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///卡密列表
-(void)requestMerBerCardBlock:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/card/link" Params:@{@"agent_id":[UserTools AgentID]} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///金币列表
-(void)requestMerBerCoinListBlock:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/card/all_card_lists" Params:nil Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///购买会员
-(void)requestMerBerShip:(NSString *)userId type:(NSString *)type number:(NSString *)number Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/card/buy_card" Params:@{@"user_id":userId,@"type_id":type,@"number":number} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                NSLog(@"购买会员:%@--%@",result,result[@"msg"]);
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///购买记录
-(void)requestShopRecord:(NSString *)userId curentpage:(NSString *)page counts:(NSString *)counts Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/expenditures" Params:@{@"user_id":userId,@"current":page,@"page":counts} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///邀请记录
-(void)requestShareRecord:(NSString *)userId page:(NSString *)page current:(NSString *)current Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/card/promotion_of_record" Params:@{@"user_id":userId,@"page":page,@"current":current} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///二维码请求
-(void)requestQRcode:(NSString *)userId Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/user_promote" Params:@{@"user_id":userId} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}


@end
