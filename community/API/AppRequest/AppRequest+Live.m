//
//  AppRequest+Live.m
//  community
//
//  Created by MAC on 2020/2/15.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "AppRequest+Live.h"

@implementation AppRequest (Live)


//直播请求地址
-(void)requestLiveAddressListBlock:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/live/info" Params:nil Callback:^(BOOL isSuccess, id result) {
        NSLog(@"直播地址：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:NO];
}

//直播频道标题列表
-(void)requestLiveTitle:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
//    NSString *liveURL0 = name;
//    if (liveURL0.length < 8) {
//        liveURL0 = @"http://112.5.37.244:81/cs.php";
//    }
//    NSLog(@"直播频道发送：：%@",liveURL0);
  
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index/live/live_category" Params:nil Callback:^(BOOL isSuccess, id result) {
        NSLog(@"直播频道标题：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = AppRequestState_Fail;
            if (result[@"data"]) {
                state = AppRequestState_Success;
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}


//直播频道列表
-(void)requestLiveChannelList:(NSString *)name pass:(NSString *)pass Block:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
//    NSString *liveURL0 = name;
//    if (liveURL0.length < 8) {
//        liveURL0 = @"http://112.5.37.244:81/cs.php";
//    }
    if ([pass  isEqual: @"0"]) {
            NSDictionary *param = @{@"url":name ? name:@""};
            [[AppRequest sharedInstance]doRequestWithUrl:@"/index/live/sp" Params:param Callback:^(BOOL isSuccess, id result) {
                NSLog(@"直播频道：：%@--%@",result,result[@"msg"]);
                if (isSuccess) {
                    AppRequestState state = AppRequestState_Fail;
                    if (result[@"data"]) {
                        state = AppRequestState_Success;
                    }
                    callBack(state,result);
                }else{
                    callBack(AppRequestState_Fail,result);
                }
        
        
            } HttpMethod:AppRequestPost isAni:NO];
    }else{
        [[AppRequest sharedInstance]doRequestWithUrl:name Params:nil Callback:^(BOOL isSuccess, id result) {
            NSLog(@"直播频道：：%@--%@",result,result[@"msg"]);
            if (isSuccess) {
                AppRequestState state = AppRequestState_Fail;
                if (result[@"data"] || result[@"pingtai"]) {
                    state = AppRequestState_Success;
                }
               
                callBack(state,result);
            }else{
                callBack(AppRequestState_Fail,result);
            }
            
            
        } HttpMethod:AppRequestGet isAni:NO];
    }
    
    
//    NSLog(@"直播频道发送：：%@",liveURL0);

    
    
    
    
    
    
    
    
}

//直播频道列表
-(void)requestLiveChannelListDa:(NSString *)name Block:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
//    NSString *liveURL0 = name;
//    if (liveURL0.length < 8) {
//        liveURL0 = @"http://112.5.37.244:81/cs.php";
//    }
//    NSLog(@"直播频道发送：：%@",liveURL0);
    NSDictionary *param = @{@"url":name};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index/live/sp" Params:param Callback:^(BOOL isSuccess, id result) {
        NSLog(@"直播频道：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = AppRequestState_Fail;
            if (result[@"pingtai"]) {
                state = AppRequestState_Success;
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:NO];
}



///http://112.5.37.244:81/cs.php?name=youlemei
///直播列表
-(void)requestLiveList:(NSString *)name Block:(void(^)(AppRequestState state,id result))callBack{
    NSDictionary *param = @{@"url":name};
//    @"http://112.5.37.244:81/cs.php?name=youlemei
//    NSString *url = name;
//    if (![name hasPrefix:@"http"]) {
//        NSString *liveURL0 = [CSCaches shareInstance].live_url;
//        if (liveURL0.length < 8) {
//            liveURL0 = @"http://112.5.37.244:81/cs.php";
//        }
//        url = [NSString stringWithFormat:@"%@?name=%@",liveURL0,name];
//    }
//    NSString *na = [NSString stringWithFormat:@"%@%@",@"url='",name];
//    NSString *url = [NSString stringWithFormat:@"%@%@",na,@"'"];
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index/live/sp" Params:param Callback:^(BOOL isSuccess, id result)  {
//        NSLog(@"直播列表：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = AppRequestState_Fail;
            if (result[@"list"]) {
                state = AppRequestState_Success;
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:NO];
}


-(void)requestLiveListPingdao:(NSString *)name pass:(NSString *)pass Block:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
//    @"http://112.5.37.244:81/cs.php?name=youlemei
    
     if ([pass  isEqual: @"0"]) {

         NSDictionary *param = @{@"url":name};
             [[AppRequest sharedInstance]doRequestWithUrl:@"/index/live/sp" Params:param Callback:^(BOOL isSuccess, id result)  {
                 NSLog(@"直播列表：：%@--%@",result,result[@"msg"]);
                 if (isSuccess) {
                     AppRequestState state = AppRequestState_Fail;
                     if (result[@"data"]) {
                         state = AppRequestState_Success;
                     }
                     if (result[@"zhubo"]) {
                         state = AppRequestState_Success;
                     }
                     callBack(state,result);
                 }else{
                     callBack(AppRequestState_Fail,result);
                 }


             } HttpMethod:AppRequestPost isAni:NO];
     }else{
         [[AppRequest sharedInstance]doRequestWithUrl:name Params:nil Callback:^(BOOL isSuccess, id result)  {
             NSLog(@"直播列表：：%@--%@",result,result[@"msg"]);
             if (isSuccess) {
                 AppRequestState state = AppRequestState_Fail;
                 if (result[@"data"] || result[@"zhubo"]) {
                     state = AppRequestState_Success;
                 }
             
                 callBack(state,result);
             }else{
                 callBack(AppRequestState_Fail,result);
             }
                     
         } HttpMethod:AppRequestGet isAni:NO];
     }
    
    

    
    
}


@end
