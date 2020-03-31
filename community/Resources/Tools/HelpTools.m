//
//  HelpTools.m
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "HelpTools.h"
#import <CommonCrypto/CommonDigest.h>
//#import <CommonCrypto/CommonCryptor.h>
#import "微群社区-Swift.h"
#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@implementation HelpTools

+ (NSString *)getAPPVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return version;
}

/*获取当前App的包名信息*/
+ (NSString *)getAppBundleId
{
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
}

+(NSString *)getMobileUDID{
    return [[NSUUID UUID] UUIDString];
}
+ (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidRef);
    NSString *uuid = (__bridge NSString *)uuidString;
    CFRelease(uuidString);
    CFRelease(uuidRef);
    
    return uuid;
}
///MD5
+ (NSString *)md5String:(NSString *)str
{
    const char * cStr=[str UTF8String];
    unsigned char buff[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), buff);
    NSMutableString * result=[[NSMutableString alloc]init];
    for (int i =0; i<16; i++) {
        [result appendFormat:@"%02x",buff[i]];
    }
    return result;
}

+(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"农历%@%@",m_str,d_str];
    
    
    return chineseCal_str;
}


+(BOOL)isMemberShip{
//    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
//    NSInteger beTime = [[[CSCaches shareInstance]getUserModel:USERMODEL].expiration_time intValue];
//    double distanceTime = beTime - now;
//    return distanceTime > 0 ? YES : NO;
    NSLog(@"是否VIP%@",[[CSCaches shareInstance]getValueForKey:ISVIP]);
    if([[[CSCaches shareInstance]getValueForKey:ISVIP]  isEqual: @"1"]){
        return YES;
    }else{
        return NO;
    }
    
}

+ (NSString *)getWeekDayByDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekComp = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDayEnum = [weekComp weekday];
    NSString *weekDays = nil;
    switch (weekDayEnum) {
        case 1:
            weekDays = @"星期日";
            break;
        case 2:
            weekDays = @"星期一";
            break;
        case 3:
            weekDays = @"星期二";
            break;
        case 4:
            weekDays = @"星期三";
            break;
        case 5:
            weekDays = @"星期四";
            break;
        case 6:
            weekDays = @"星期五";
            break;
        case 7:
            weekDays = @"星期六";
            break;
        default:
            break;
    }
    return weekDays;
}

+(NSString *)getLeftTime:(NSInteger)totalSeconds{
    NSString *str = @"";
    
    NSInteger day =0;
    if (totalSeconds > 3600 * 24) {
        day = totalSeconds / (3600 * 24);
        totalSeconds = totalSeconds % (3600*24);
    }
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    if (totalSeconds<60) {
        str = @"1分钟";
    }else if(totalSeconds > 3600){
        if (day>0) {
            str = [NSString stringWithFormat:@"%ld天 %ld小时 %ld分钟",day,hours,minutes];
        }else{
            str = [NSString stringWithFormat:@"%ld小时 %ld分钟",hours,minutes];
        }
        
    }else{
        str = [NSString stringWithFormat:@"%ld分钟",minutes];
    }
    
    return str;
}

+(NSString *)getCurrentStringTime{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}
//  xffs9xx69

+(NSString *)dateStampWithTime:(NSInteger)time andFormat:(NSString *)format{
    if (time == 0) {
        time = [[NSDate date]timeIntervalSince1970];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:format];
    
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    
    return string;
}


+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
  
    if (beTime == 0) {
        return @"";
    }
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime <60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

+(void)mustBeMemberShip:(UIViewController *)svc{
    if (![UserTools isLogin]) {
        [self jianquan:svc];
        return;
    }
    NSString *str = @"请先开通会员";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的权限不足" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
//        CSMallVC *vc = [[CSMallVC alloc]init];
//        [svc.navigationController pushViewController:vc animated:YES];
        
        KamiPayController *vc = [[ KamiPayController alloc]init];
//        [svc presentViewController:vc  animated:YES completion:nil];
        [svc.navigationController pushViewController:vc animated:YES];
    }];
    [action1 setValue:RGBColor(9, 198, 106) forKey:@"_titleTextColor"];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    [action2 setValue:RGBColor(110, 110, 110) forKey:@"_titleTextColor"];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [svc presentViewController:alert animated:YES completion:nil];
}


+(BOOL)jianquan:(UIViewController *)svc{
    if(![UserTools isLogin]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录账号" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
            svc.navigationItem.backBarButtonItem = barItem;
            barItem.title = @"注册";
            CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];

            [svc.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];
        [alert addAction:action1];
        [alert addAction:action2];
    
        [svc presentViewController:alert animated:YES completion:nil];

        return NO;
    }else if ([[[CSCaches shareInstance]getValueForKey:ISVIP]  isEqual: @"1"]){
        return YES;
    }
//    else if ([UserTools userBlance] > 0){
//        return YES;
//    }
    else{
        NSString *warnStr = @"请联系代理购买激活码";
        if (![UserTools isAgentVersion]) {
            warnStr = @"请先开通会员";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的权限不足" message:warnStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (![UserTools isAgentVersion]) {
//                UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
//                svc.navigationItem.backBarButtonItem = barItem;
//                barItem.title = @"购买商城";
//
//                CSMallVC *vc = [[CSMallVC alloc]init];
//                [svc.navigationController pushViewController:vc animated:YES];
                
                KamiPayController *vc = [[ KamiPayController alloc]init];
                [svc.navigationController pushViewController:vc animated:YES];
//                [svc presentViewController:vc  animated:YES completion:nil];
            }else{
                svc.tabBarController.selectedIndex = 4;
            }
            
        }];
        [action1 setValue:RGBColor(9, 198, 106) forKey:@"_titleTextColor"];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];
        [action2 setValue:RGBColor(110, 110, 110) forKey:@"_titleTextColor"];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [svc presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
}

+(void)enterGroup:(UIViewController *)svc andPrice:(NSString *)price{
    if(![UserTools isLogin]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录账号" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
            svc.navigationItem.backBarButtonItem = barItem;
            barItem.title = @"注册";
            CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];

            [svc.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];
        [alert addAction:action1];
        [alert addAction:action2];
    
        [svc presentViewController:alert animated:YES completion:nil];

        return;
    }else if ([HelpTools isMemberShip]){
        
    }else if ([UserTools userBlance] > 0){
        
    }
}

+(void)jumpToQQ:(NSString *)qqNumber{
    NSString *openQQUrl = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber];
    NSURL *url = [NSURL URLWithString:openQQUrl];
    [[UIApplication sharedApplication] openURL:url];
}


///
+(NSString *)getDeviceIDInKeychain {
    NSString *getUDIDInKeychain = (NSString *)[HelpTools loadKeyChain:KEY_UDID_INSTEAD];
    NSLog(@"从keychain中获取到的 UDID_INSTEAD %@",getUDIDInKeychain);
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [HelpTools save:KEY_UDID_INSTEAD data:result];
        getUDIDInKeychain = (NSString *)[HelpTools loadKeyChain:KEY_UDID_INSTEAD];
    }
    NSLog(@"最终 ———— UDID_INSTEAD %@",getUDIDInKeychain);
    return getUDIDInKeychain;
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+ (id)loadKeyChain:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"UUID:Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}


/// 缓存大小
+(NSString *)getCachesSize{
    // 调试
#ifdef DEBUG
    
    // 如果文件夹不存在 or 不是一个文件夹, 那么就抛出一个异常
    // 抛出异常会导致程序闪退, 所以只在调试阶段抛出。发布阶段不要再抛了,--->影响用户体验
    
    BOOL isDirectory = NO;
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        
        NSException *exception = [NSException exceptionWithName:@"文件错误" reason:@"请检查你的文件路径!" userInfo:nil];
        
        [exception raise];
    }
    
    //发布
#else
    
#endif
    
    //1.获取“cachePath”文件夹下面的所有文件
    NSArray *subpathArray= [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSString *filePath = nil;
    long long totalSize = 0;
    
    for (NSString *subpath in subpathArray) {
        
        // 拼接每一个文件的全路径
        filePath =[cachePath stringByAppendingPathComponent:subpath];
        
        BOOL isDirectory = NO;   //是否文件夹，默认不是
        
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];   // 判断文件是否存在
        
        // 文件不存在,是文件夹,是隐藏文件都过滤
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) continue;
        
        // attributesOfItemAtPath 只可以获得文件属性，不可以获得文件夹属性，
        //这个也就是需要遍历文件夹里面每一个文件的原因
        
        long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        
        totalSize += fileSize;
        
    }
    
    // 2.将文件夹大小转换为 M/KB/B
    NSString *totalSizeString = nil;
    
    if (totalSize > 1024 * 1024) {
        
        totalSizeString = [NSString stringWithFormat:@"%.1fM",totalSize / 1024.0f /1024.0f];
        
    } else if (totalSize > 1024) {
        
        totalSizeString = [NSString stringWithFormat:@"%.1fKB",totalSize / 1024.0f ];
        
    } else {
        
        totalSizeString = [NSString stringWithFormat:@"%.1fB",totalSize / 1.0f];
        
    }
    
    return totalSizeString;
    
}

#pragma mark ---清理缓存
/// 清除缓存
+ (void)clearAppCaches{
    
    // 1.拿到cachePath路径的下一级目录的子文件夹
    // contentsOfDirectoryAtPath:error:递归
    // subpathsAtPath:不递归
    [KTVHTTPCache cacheDeleteAllCaches];
    
    NSDictionary *keyDic = [[CSCaches shareInstance].userDefault dictionaryRepresentation];
    for (NSString *key in keyDic.allKeys) {
        if ([key containsString:@"GIF_"]) {
            [[CSCaches shareInstance].userDefault removeObjectForKey:key];
            [[CSCaches shareInstance].userDefault synchronize];
        }
    }
    
    NSArray *subpathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:nil];
    
    // 2.如果数组为空，说明没有缓存或者用户已经清理过，此时直接return
    if (subpathArray.count == 0) {
        NSLog(@"缓存已清理");
        [[MYToast makeText:@"缓存已清理"]show];
//        [SVProgressHUD showNOmessage:@"缓存已清理"];
        return ;
    }

    NSError *error = nil;
    NSString *filePath = nil;
    BOOL flag = NO;
    
    NSString *size = [self getCachesSize];
    
    for (NSString *subpath in subpathArray) {
        
        filePath = [cachePath stringByAppendingPathComponent:subpath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            
            // 删除子文件夹
            BOOL isRemoveSuccessed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            
            if (isRemoveSuccessed) { // 删除成功
                
                flag = YES;
            }
        }
        
    }
    
    if (NO == flag){
        NSLog(@"缓存已清理2");
    [[MYToast makeText:@"缓存已清理"]show];
//        [SVProgressHUD showNOmessage:@"缓存已清理"];
    }else
        NSLog(@"缓存已清理::%@",size);
    NSString *cachesStr = [NSString stringWithFormat:@"为您腾出%@空间",size];
    [[MYToast makeText:cachesStr]show];
//        [SVProgressHUD showYESmessage:[NSString stringWithFormat:@"为您腾出%@空间",size]];
        
    return ;
    
}



@end
