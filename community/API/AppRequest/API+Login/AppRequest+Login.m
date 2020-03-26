//
//  AppRequest+Login.m
//  community
//
//  Created by 蔡文练 on 2019/9/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest+Login.h"

@implementation AppRequest (Login)


-(void)requestLogin:(NSString *)phoneNumber password:(NSString *)password Block:(void(^)(AppRequestState state,id result))callBack{//?a=1&b=2
    
    NSDictionary *param = @{@"mobile":phoneNumber,@"password":password};
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/login" Params:param Callback:^(BOOL isSuccess, id result) {
        NSLog(@"登录：：%@",result);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            
            if (state == AppRequestState_Success) {
                UserModel *user = [UserModel mj_objectWithKeyValues:result[@"data"]];
                [[CSCaches shareInstance]saveUserDefalt:TOKEN value:user.access_token];
                
                [[CSCaches shareInstance]saveUserDefalt:USERID value:user.idss];
                NSLog(@"登录的token：：%@",user.access_token);
                [[CSCaches shareInstance]saveModel:USERMODEL value:user];
                [[CSCaches shareInstance]saveUserDefalt:AGENTID value:user.agent_code];
                [[CSCaches shareInstance]saveUserDefalt:USERBLANCE value:user.coin];
                
//                if (user.agent.length > 0 && ![user.agent isEqualToString:@"0"]) {
//                    [[CSCaches shareInstance]saveUserDefalt:AGENTID value:user.agent];
//                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOT_LOGIN object:nil];
            }
            callBack(state,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}

-(void)requestRegister:(NSDictionary *)param Block:(void(^)(AppRequestState state,id result))callBack{
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/register" Params:param Callback:^(BOOL isSuccess, id result) {
        NSLog(@"注册：：%@",result);
        if (isSuccess) {
            AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
            UserModel *user = [UserModel mj_objectWithKeyValues:result[@"data"]];
            [[CSCaches shareInstance]saveUserDefalt:TOKEN value:user.access_token];
            
            [[CSCaches shareInstance]saveUserDefalt:USERID value:user.idss];
            
            [[CSCaches shareInstance]saveModel:USERMODEL value:user];
            [[CSCaches shareInstance]saveUserDefalt:USERBLANCE value:user.coin];
            callBack(state,result);
        }else{
            callBack(AppRequestState_ServeFail,result);
        }
        
        
    } HttpMethod:AppRequestPost isAni:YES];
}



@end
