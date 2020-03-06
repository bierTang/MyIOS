//
//  StaticDefine.h
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//

#ifndef StaticDefine_h
#define StaticDefine_h


/**
 *屏幕宽
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
/**
 *屏幕高
 */
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_X_All SCREEN_HEIGHT >=812 ? YES : NO
#define ISIOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 ? YES : NO)


/**
 *navigationBar顶部高度
 */
#define TopSpaceHigh  ((Device_Is_iPhoneX||IS_IPHONE_Xs||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?84:64)

#define ItemSpaceHight  ((Device_Is_iPhoneX||IS_IPHONE_Xs||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?44:24)
#define TopViewBottomSpace   -12

//X  机型 底部预留高度
#define BottomSpace  ((Device_Is_iPhoneX||IS_IPHONE_Xs||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?20:0)

#define TopLiuHai  ((Device_Is_iPhoneX||IS_IPHONE_Xs||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?44:0)

#define NoneTitleSpaceHight  ((Device_Is_iPhoneX||IS_IPHONE_Xs||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?44:24)

#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavHeight (KStatusBarHeight + 44.f)
#define KIsBangScreen (KStatusBarHeight > 20.1)  // 刘海屏，状态栏44pt，底部留功能区34pt
#define KTabBarHeight (KIsBangScreen ? 83.0f : 49.0f)
#define KBottomSafeArea (KIsBangScreen ? 34.0f : 0.0f)
/**
 *底部高度
 */
#define BottomSpaceHight ((Device_Is_iPhoneX||IS_IPHONE_Xs||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?24:0)

/**
 *用4.7尺寸为标准 比例伸缩
 **/
#define K_SCALE SCREEN_WIDTH / 375.0

///RGB颜色
#define  RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


/**
 *请求状态字段名
 */
#define AppRequestStateName             @"code"
/**
 *请求 错误
 */
#define AppResponeErrorInfo             @"errCode"
/**
 *请求 应答
 */
#define  AppResponeData                 @"content"
/**
 *请求方法
 */
typedef enum  _AppRequestHttpMethod{
    AppRequestPost,  //post请求
    AppRequestGet,   //get请求
    AppRequestUpload, //上传请求
    AppRequestPUT,     //put请求
    AppRequestDELETE    //delete
    
}AppRequestHttpMethod;
/**
 *请求状态
 */
typedef enum _AppRequestState{
    AppRequestState_WXLogin_NoBindMobile,//微信登录未绑定手机号
    AppRequestState_Unkown,      //不知道
    AppRequestState_Success,     //成功 0
    AppRequestState_Fail,        //失败 -1 --->
    AppRequestState_ServeFail ,//-1 认证失败 ---->服务器失败
    AppRequestState_TokenInvalid, //-2
    AppRequestState_TryAgain,
    
}AppRequestState;
/**
 *业务层数据block回调
 */
typedef void (^BLLCallBack)(AppRequestState state, id result);
/**
 *网络请求block回调
 */
typedef void (^HttpCallBack)(BOOL isSuccess,id result);

/**
 *网络类型
 */
typedef NS_ENUM(NSUInteger, NetWorkType) {
    NetWorkTypeNotReachable = 0,
    NetWorkTypeUnknown = 1,
    NetWorkTypeWAN2G = 2,
    NetWorkTypeWAN3G = 3,
    NetWorkTypeWAN4G = 4,
    NetWorkTypeWiFi = 9,
};

///////string    key


#endif /* StaticDefine_h */
