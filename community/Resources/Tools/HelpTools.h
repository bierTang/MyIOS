//
//  HelpTools.h
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpTools : NSObject

///获取APP版本号
+(NSString *)getAPPVersion;

/*获取当前App的包名信息*/
+ (NSString *)getAppBundleId;

///获取UDID
+(NSString *)getDeviceIDInKeychain;

///MD5
+ (NSString *)md5String:(NSString *)str;

///剩余时间转 时 分
+(NSString *)getLeftTime:(NSInteger)totalSeconds;
///获取农历 月 日
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;

///获取星期几
+ (NSString *)getWeekDayByDate:(NSDate *)date;

+(NSString *)getCurrentStringTime;

///时间戳转字符串
+(NSString *)dateStampWithTime:(NSInteger)time andFormat:(NSString *)format;

///时间判断是不是会员
+(BOOL)isMemberShip;

///距离现在的时间差
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

+(void)mustBeMemberShip:(UIViewController *)svc;

+(BOOL)jianquan:(UIViewController *)svc;

+(void)jumpToQQ:(NSString *)qqNumber;


/// 缓存大小
+(NSString *)getCachesSize;
/// 清除缓存
+ (void)clearAppCaches;


@end

NS_ASSUME_NONNULL_END
