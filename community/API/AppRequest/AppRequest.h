//
//  AppRequest.h
//  WealthHo
//
//  Created by GF on 2019/3/19.
//  Copyright © 2019 GF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN


@interface AppRequest : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;
/**
 *单例
 */
+ (AppRequest*)sharedInstance;

/**
 *  请求数据
 *  @param url     请求的URL
 *  @param params  请求参数
 *  @param callback 回调方法
 *  @param method  请求方法参数 post get upload等
 */

- (void)doRequestWithUrl:(NSString *)url Params:(id)params Callback:(HttpCallBack)callback HttpMethod:(AppRequestHttpMethod)method isAni:(BOOL) ani;


/**获取请求状态
 *  @param requestState     请求状态
 */
- (AppRequestState)requestStateFromStatusCode:(id)requestState;
/**
 *转路径参数
 */
//-(NSString *)getUrlFromDic:(NSDictionary *)dic;
/**
 *设置 header
 */
//-(void)setHeadSignUrl:(NSString *)urlPath DataDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
