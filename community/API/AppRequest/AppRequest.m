//
//  AppRequest.m
//  WealthHo
//
//  Created by GF on 2019/3/19.
//  Copyright © 2019 GF. All rights reserved.
//

#import "AppRequest.h"
#import "WHNetWork.h"
#import "XXTEA.h"
#import "微群社区-Swift.h"
static float const TIMEOUT = 8;


@interface AppRequest()



@end

static AppRequest *appRequestInstance = nil;

@implementation AppRequest
/**
 *单例
 */
+ (AppRequest*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!appRequestInstance) {
            appRequestInstance = [[[self class] alloc] init];
        }
    });
    return appRequestInstance;
}
/**
 *初始化
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.removesKeysWithNullValues = YES;
        [serializer setRemovesKeysWithNullValues:YES];
        [_manager setResponseSerializer:serializer];
        
        _manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        
//        [_manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/jpg", @"image/png", @"application/octet-stream", @"text/json", nil];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [_manager.reachabilityManager startMonitoring];
//        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = TIMEOUT;
        if ([UserTools isLogin]) {
            NSLog(@"装入的请求头",[UserTools token]);
            [_manager.requestSerializer setValue:[UserTools token] forHTTPHeaderField:@"accessToken"];
        }
//        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//        [_manager.requestSerializer setValue:[DeviceInfo appVersion] forHTTPHeaderField:@"g-ver"];
//        [_manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"g-clientOs"];
//        [_manager.requestSerializer setValue:[DeviceInfo getDeviceInfo] forHTTPHeaderField:@"g-device"];
//        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

///**
// *设置 header
// */
//-(void)setHeadSignUrl:(NSString *)urlPath DataDic:(NSDictionary *)dic{
//    if ([WHUserTool isLogin]) {
//        [_manager.requestSerializer setValue:[WHUserTool getToken] forHTTPHeaderField:@"g-token"];
//    }
//    NSString *time = [CustomTimeTools getCurrentTimestamp];
//    [_manager.requestSerializer setValue:time forHTTPHeaderField:@"g-time"];
//    NSString *signValue = [SortTools getSign:urlPath Data:dic Time:time];
//    [_manager.requestSerializer setValue:signValue forHTTPHeaderField:@"g-sign"];
//}

#pragma mark request
/**
 *取消所有请求
 */
- (void)cancelRequest {
    for (NSURLSessionDataTask *task in _manager.tasks) {
        [task cancel];
    }
}






/**
 *  请求数据
 *  @param url     请求的URL
 *  @param params  请求参数
 *  @param callback 回调方法
 *  @param method  请求方法参数 post get upload等
 */
- (void)doRequestWithUrl:(NSString *)url Params:(id)params  Callback:(HttpCallBack)callback HttpMethod:(AppRequestHttpMethod)method isAni:(BOOL) ani{
    
  
    
    
    
    NSString *weburl = [CSCaches shareInstance].webUrl;
    if (weburl.length < 5) {
        weburl = mainHost;
    }
    if ([url containsString:@"http://"]||[url containsString:@"https://"]) {
        url = url;
    }else{
        url = [NSString stringWithFormat:@"%@%@",weburl,url];
    }
    if (![WHNetWork networkEnable]) {
        [[MYToast makeText:@"请求失败,请检查网络连接"] show];
        callback(NO,nil);
        
        
            dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
            });

        
        return;
    }
    
    if (ani) {
    // 3.GCD
         dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
             hud.userInteractionEnabled = NO;
         });
      }
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    if (method == AppRequestGet) {
        [self AFGetRequestWithUrl:url params:(NSString *)params callback:^(BOOL isSuccessed, NSDictionary *result) {
            callback(isSuccessed, result);
//            if (ani) {
            // 3.GCD
                  dispatch_async(dispatch_get_main_queue(), ^{
                   [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
                  });
                
//            }
            
            
            
        }];
    } else if(method == AppRequestPost) {
        [self AFPostRequestWithUrl:url params:(NSDictionary *)params callback:^(BOOL isSuccessed, NSDictionary *result) {
            callback(isSuccessed, result);
//            if (ani) {
// 3.GCD
                 dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
                 });
//            }
        }];
    }else if(method == AppRequestPUT) {
        [self AFPUTRequestWithUrl:url params:(NSDictionary *)params callback:^(BOOL isSuccessed, NSDictionary *result) {
            callback(isSuccessed, result);
//            if (ani) {
            // 3.GCD
                             dispatch_async(dispatch_get_main_queue(), ^{
                              [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
                             });
//            }
//             [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
        }];
    }else if(method == AppRequestDELETE) {
        [self AFDELETERequestWithUrl:url params:(id)params callback:^(BOOL isSuccessed, NSDictionary *result) {
            callback(isSuccessed, result);
//            if (ani) {
            // 3.GCD
                             dispatch_async(dispatch_get_main_queue(), ^{
                              [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
                             });
//            }
//             [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
        }];
    }else{
        
    }
}


/**
 *  @param url     请求的URL
 *  @param params  请求参数
 *  @param callback   回调方法
 */
- (void)AFGetRequestWithUrl:(NSString *)url params:(NSString *)params callback:(HttpCallBack)callback {
    @weakity(self);
    
    NSString *encrypt_data;
       if (params.length > 0) {
           
           NSString *text = params;
                  NSString *key = @"weichats";
                  encrypt_data = [XXTEA encryptStringToBase64String:text stringKey:key];
 
       }

    
    if (params.length > 0) {
        url = [NSString stringWithFormat:@"%@?params=%@",url,encrypt_data];
    }
    NSLog(@"geturl=%@",url);
    [_manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        @strongity(self);
        [self dataResponseObject:responseObject callback:^(BOOL isSuccessed, NSDictionary *result) {
            if( [result[@"code"] integerValue] == 10019){
                
                           [[MYToast makeText:result[@"msg"]]show];
//                [UserTools loginOut];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOT_TOKENWRONG object:nil];
                // 前提当前控制器在一个navigationController中
                               // 取nav的栈顶控制器
//               if (![self.getCurrentVC.navigationController.viewControllers.lastObject isKindOfClass:[@"CSMyverifyVC" class]]){
//                   CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];
//
//                                  [self.getCurrentVC.navigationController pushViewController:vc animated:NO];
//               }
//
                if ([self.getCurrentVC.navigationController.viewControllers.lastObject isKindOfClass:[CSMyverifyVC class]]){
//                                       [self.getCurrentVC.navigationController pushViewController:self.getCurrentVC.navigationController.viewControllers.lastObject animated:NO];
                                   }else{
                                       UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
                                       self.getCurrentVC.navigationItem.backBarButtonItem = barItem;
                                       barItem.title = @"注册";
                                       CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];

                                       [self.getCurrentVC.navigationController pushViewController:vc animated:YES];
                                   }
               
                
                
                      }
            callback(isSuccessed, result);
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongity(self);
        [self dataError:error callback:^(BOOL isSuccessed, NSDictionary *result) {
            callback(isSuccessed, result);
        }];
    }];
}




/**
 *  @param url     请求的URL
 *  @param params  请求参数
 *  @param callback   回调方法
 */
- (void)AFPostRequestWithUrl:(NSString *)url params:(NSDictionary *)params callback:(HttpCallBack)callback {
    if ([UserTools isLogin]) {
               NSLog(@"装入的请求头",[UserTools token]);
               [_manager.requestSerializer setValue:[UserTools token] forHTTPHeaderField:@"accessToken"];
           }
    @weakity(self);
    

    NSString *encrypt_data;
    NSDictionary * dic;
    if (params) {
        NSString *str =  params.mj_JSONString;
        NSString *text = str;
               NSString *key = @"weichats";
               encrypt_data = [XXTEA encryptStringToBase64String:text stringKey:key];
        dic = @{@"params":encrypt_data};
       
//           encrypt_data = [@"params=" stringByAppendingString: encrypt_data];
    }
    

//    NSLog(@"posturl=%@---:%@",url,encrypt_data);
    
    
    
    
    
    [_manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        
        
        @strongity(self);
        [self dataResponseObject:responseObject callback:^(BOOL isSuccessed, NSDictionary *result) {
            if( [result[@"code"] integerValue] == 10019){
                 [[MYToast makeText:result[@"msg"]]show];
//                [UserTools loginOut];
               [[NSNotificationCenter defaultCenter]postNotificationName:NOT_TOKENWRONG object:nil];
                           // 前提当前控制器在一个navigationController中
                                    // 取nav的栈顶控制器
                    if ([self.getCurrentVC.navigationController.viewControllers.lastObject isKindOfClass:[CSMyverifyVC class]]){
//                        [self.getCurrentVC.navigationController pushViewController:self.getCurrentVC.navigationController.viewControllers.lastObject animated:NO];
                    }else{
                        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
                        self.getCurrentVC.navigationItem.backBarButtonItem = barItem;
                        barItem.title = @"注册";
                        CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];

                        [self.getCurrentVC.navigationController pushViewController:vc animated:YES];
                    }
            }
         
            callback(isSuccessed, result);
            
            
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongity(self);
        
        [self dataError:error SessionDataTask:task callback:^(BOOL isSucess, NSDictionary *result) {
            callback(isSucess, result);
            
        }];
    }];
}


/////put请求
- (void)AFPUTRequestWithUrl:(NSString *)url params:(NSDictionary *)params callback:(HttpCallBack)callback {
    
    @weakity(self);
      NSLog(@"puturl=%@",url);
    [_manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongity(self);
        [self dataResponseObject:responseObject callback:^(BOOL isSuccessed, NSDictionary *result) {
            callback(isSuccessed, result);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongity(self);
        
        [self dataError:error SessionDataTask:task callback:^(BOOL isSucess, NSDictionary *result) {
            callback(isSucess, result);
            
        }];
    }];
    
}

///delete请求
- (void)AFDELETERequestWithUrl:(NSString *)url params:(id)params callback:(HttpCallBack)callback {
    
    @weakity(self);
    [_manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongity(self);
        [self dataResponseObject:responseObject callback:^(BOOL isSuccessed, NSDictionary *result) {
            callback(isSuccessed, result);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongity(self);
        
        [self dataError:error SessionDataTask:task callback:^(BOOL isSucess, NSDictionary *result) {
            callback(isSucess, result);
            
        }];
    }];
    
}

/**
 *  @param callback   回调方法
 */
- (void)dataError:(NSError *)error SessionDataTask:(NSURLSessionDataTask*)task callback:(HttpCallBack)callback {
    
    NSDictionary *errorDic = [NSDictionary dictionaryWithObjectsAndKeys:error.userInfo,AppResponeErrorInfo, nil];
    callback(NO, errorDic);
}

/**
 *  @param callback   回调方法
 */
- (void)dataResponseObject:(NSData *)responseJSON callback:(HttpCallBack)callback {
    
    NSString *result =[[ NSString alloc] initWithData:responseJSON encoding:NSUTF8StringEncoding];
//    NSString *text = responseJSON.mj_JSONString;
        NSString *key = @"weichats";
//       NSString *encrypt_data = [XXTEA encryptStringToBase64String:text stringKey:key];
       NSString *decrypt_data = [XXTEA decryptBase64StringToString:result stringKey:key];
       
//NSLog(@"返回的数据: %@", result);
    if (decrypt_data) {
          AppRequestState state = [self requestStateFromStatusCode:[decrypt_data.mj_JSONObject objectForKey:AppRequestStateName]];
//          NSLog(@"返回解密数据: %@", decrypt_data.mj_JSONObject);
          if (state == AppRequestState_Success ) {
              callback(YES, decrypt_data.mj_JSONObject);
          }else if(state == AppRequestState_TokenInvalid){
            
              callback(YES, decrypt_data.mj_JSONObject);    //回调提示token过期，或者不做回调  直接处理
          }else{
              callback(YES, decrypt_data.mj_JSONObject);
          }
    }else{
        AppRequestState state = [self requestStateFromStatusCode:[result.mj_JSONObject objectForKey:AppRequestStateName]];
          NSLog(@"返回原始数据: %@", result.mj_JSONObject);
          if (state == AppRequestState_Success ) {
              callback(YES, result.mj_JSONObject);
          }else if(state == AppRequestState_TokenInvalid){
            
              callback(YES, result.mj_JSONObject);    //回调提示token过期，或者不做回调  直接处理
          }else{
              callback(YES, result.mj_JSONObject);
          }
    }

    
}


/**
 *  @param callback   回调方法
 */
- (void)dataError:(NSError *)error callback:(HttpCallBack)callback {
    NSDictionary *errorDic = [NSDictionary dictionaryWithObjectsAndKeys:error.userInfo,AppResponeErrorInfo, nil];
    callback(NO, errorDic);
#if 0
    NSInteger code = -1;
    NSString * message;
    if (error) {
        
    
        
        code = error.code;
        switch (code) {
            case NSURLErrorNotConnectedToInternet:
                message = @"请检查网络连接是否正常";
                break;
            case NSURLErrorTimedOut:
                message = @"请求超时";
                break;
            case NSURLErrorBadURL:
                message = @"错误的请求";
                break;
            case NSURLErrorUnknown:
                message = @"服务器异常,请稍后再试";
                break;
            case 404:
                message = @"无法找到服务器，请稍后重试";
                break;
            case 3840:
                message = @"数据格式不正确，请稍后重试";
                break;
            case 400:
                message = @"错误的请求";
                break;
            case 503:
                message = @"服务不可用, 请稍后重试";
                break;
            case NSURLErrorCannotConnectToHost:
                message = @"不能连接到服务器";
                break;
            case NSURLErrorBadServerResponse:
                message = @"服务器错误";
                break;
            case kCFErrorHTTPConnectionLost:
                break;
            default:
                message = @"服务器异常,请稍后再试";
                break;
        }
    }
#endif
}

/**获取请求状态
 *  @param requestState     请求状态
 */
- (AppRequestState)requestStateFromStatusCode:(id)requestState {
    if (requestState) {
        requestState = [NSString stringWithFormat:@"%@",requestState];
        if ([requestState isEqualToString:@"200"]) {
            return AppRequestState_Success;
        } else if ([requestState isEqualToString:@"-1"]) {
            return AppRequestState_Fail;
        }else if ([requestState isEqualToString:@"10003"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOT_TOKENWRONG object:nil];
            return AppRequestState_TokenInvalid;
        }else{
            return AppRequestState_Fail;
        }
    }else{
        return AppRequestState_ServeFail;
    }
    
}

//获取当前视图
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    //取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    //如果为UITabBarController：取选中控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    //如果为UINavigationController：取可视控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

@end
