//
//  AppRequest+Search.m
//  community
//
//  Created by 蔡文练 on 2019/10/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest+Search.h"

@implementation AppRequest (Search)



-(void)requestSearchList:(NSString *)words showAll:(NSString *)isAll Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"hot_word":words,@"is_all":isAll};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/group/search_group" Params:param Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            
            if (state == AppRequestState_Success) {
                callBack(state,result);
            }
        }
        
        
    } HttpMethod:AppRequestPost isAni:NO];
}



-(void)requestHotWordsListBlock:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/hot/all_word" Params:nil Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            
            if (state == AppRequestState_Success) {
                callBack(state,result);
            }
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}


@end
