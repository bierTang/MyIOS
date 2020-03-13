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
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}

//直播频道列表
-(void)requestLiveChannelListBlock:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
    NSString *liveURL0 = [CSCaches shareInstance].live_url;
    if (liveURL0.length < 8) {
        liveURL0 = @"http://112.5.37.244:81/cs.php";
    }
    NSLog(@"直播频道发送：：%@",liveURL0);
    [[AppRequest sharedInstance]doRequestWithUrl:liveURL0 Params:nil Callback:^(BOOL isSuccess, id result) {
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
        
        
    } HttpMethod:AppRequestGet isAni:NO];
}

///http://112.5.37.244:81/cs.php?name=youlemei
///直播列表
-(void)requestLiveList:(NSString *)name Block:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
//    @"http://112.5.37.244:81/cs.php?name=youlemei
    NSString *url = name;
    if (![name hasPrefix:@"http"]) {
        NSString *liveURL0 = [CSCaches shareInstance].live_url;
        if (liveURL0.length < 8) {
            liveURL0 = @"http://112.5.37.244:81/cs.php";
        }
        url = [NSString stringWithFormat:@"%@?name=%@",liveURL0,name];
    }
    [[AppRequest sharedInstance]doRequestWithUrl:url Params:nil Callback:^(BOOL isSuccess, id result)  {
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
        
        
    } HttpMethod:AppRequestGet isAni:NO];
}


-(void)requestLiveListPingdao:(NSString *)name Block:(void(^)(AppRequestState state,id result))callBack{
//    NSDictionary *param = @{@"user_id":userId};
//    @"http://112.5.37.244:81/cs.php?name=youlemei
    NSString *url = name;
    if (![name hasPrefix:@"http"]) {
        NSString *liveURL0 = [CSCaches shareInstance].live_url;
        if (liveURL0.length < 8) {
            liveURL0 = @"http://112.5.37.244:81/cs.php";
        }
        //替换某个字符
        url = [liveURL0 stringByReplacingOccurrencesOfString:@"/json" withString:[@"/" stringByAppendingString: name]];
//        url = [NSString stringWithFormat:@"%@?name=%@",liveURL0,name];
    }
    [[AppRequest sharedInstance]doRequestWithUrl:url Params:nil Callback:^(BOOL isSuccess, id result)  {
//        NSLog(@"直播列表：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = AppRequestState_Fail;
            if (result[@"data"]) {
                state = AppRequestState_Success;
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestGet isAni:NO];
}


@end
