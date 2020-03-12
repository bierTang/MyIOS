//
//  AppRequest+LongVideo.m
//  community
//
//  Created by MAC on 2020/1/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "AppRequest+LongVideo.h"


@implementation AppRequest (LongVideo)


///请求分类
-(void)requestVideoTitleBlock:(void(^)(AppRequestState state,id result))callBack{
   
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/cate/category" Params:nil Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                NSLog(@"视频分类：%@",result);
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///请求视频数据
-(void)requestVideoListType:(NSString *)categoryId current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack{
   
    NSDictionary *params = @{@"category_id":categoryId,@"current":current,@"page":page};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/cate/videos" Params:params Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                NSLog(@"视频分类：%@",result);
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}

///观看视频
-(void)requestMyseeingVideo:(NSString *)userId videoId:(NSString *)videoId Block:(void(^)(AppRequestState state,id result))callBack{
   
    NSDictionary *params = @{@"user_id":userId,@"video_id":videoId};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/history/add_history" Params:params Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                NSLog(@"视频看过了：%@",result);
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}


///请求视频历史记录
-(void)requestVideoHistory:(NSString *)userid current:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack{
   
    NSDictionary *params = @{@"user_id":userid,@"current":current,@"page":page};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/history/lists" Params:params Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            if (state == AppRequestState_Success) {
                NSLog(@"视频历史记录：%@",result);
            }
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}

@end
