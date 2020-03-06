//
//  AppRequest+discover.m
//  community
//
//  Created by 蔡文练 on 2019/10/18.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest+discover.h"

@implementation AppRequest (discover)



-(void)requestdiscoverCurrent:(NSString *)current page:(NSString *)page Block:(void(^)(AppRequestState state,id result))callBack{
    
    NSDictionary *param = @{@"page":page,@"current":current};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/discover/lists" Params:param Callback:^(BOOL isSuccess, id result) {
        NSLog(@"发现：：%@--%@",result,result[@"msg"]);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            callBack(state,result);
        }else{
            callBack(AppRequestState_Fail,result);
        }
        
        
    } HttpMethod:AppRequestPost];
}


@end
