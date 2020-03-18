//
//  AppRequest+Chat.m
//  community
//
//  Created by 蔡文练 on 2019/9/3.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "AppRequest+Chat.h"

@implementation AppRequest (Chat)


///请求公共通知
-(void)requestBoardBlock:(void(^)(AppRequestState state,id result))callBack{
    
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/board" Params:nil Callback:^(BOOL isSuccess, id result) {
        NSLog(@"公告：：%@",result);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            
            
                callBack(state,result);
            
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}


-(void)requestChatList:(NSString *)current Page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"current":current,@"page":page};
    if ([UserTools userID]) {
        param = @{@"current":current,@"page":page,@"user_id":[UserTools userID]};
    }
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/group/all_group" Params:param Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
                callBack(state,result);
            
        }else{
            callBack(AppRequestState_ServeFail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}



//-(void)requestSessionID:(NSString *)roomId current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack{
//
//    NSDictionary *param = @{@"group_id":roomId,@"page":page,@"current":current};
//    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/chitchat/all_chitchat" Params:param Callback:^(BOOL isSuccess, id result) {
//        NSLog(@"详情页：：%@",result[@"code"]);
//        if (isSuccess) {
//            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
//            callBack(state,result);
//        }else {
//            callBack(AppRequestState_Fail,result);
//        }
//
//
//    } HttpMethod:AppRequestPost isAni:YES];
//}

-(void)requestSessionID:(NSString *)roomId messId:(NSString *)messId current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"group_id":roomId,@"message_id":messId,@"chitchat_operating":page,@"chitchat_number":current};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/chitchat/chitchat_message" Params:param Callback:^(BOOL isSuccess, id result) {
        NSLog(@"详情页：：%@",result[@"code"]);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else {
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///
-(void)requestADSforType:(NSString *)type Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"type_id":type};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/advert/advert_list" Params:param Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else {
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:NO];
}

///单次金币进群
-(void)requestEnterGroupByCoinID:(NSString *)groupId Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"group_id":groupId,@"user_id":[UserTools userID]};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/group/buy" Params:param Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else {
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///群成员请求
-(void)requestGroupMemBer:(NSString *)groupId Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"group_id":groupId};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/group/group_member" Params:param Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else {
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///版本更新
-(void)requestUpdateBlock:(void(^)(AppRequestState state,id result))callBack{
    
//    NSDictionary *param = @{@"group_id":groupId};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/common/version" Params:nil Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else {
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}


@end
