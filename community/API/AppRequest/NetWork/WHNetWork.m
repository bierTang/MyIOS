//
//  WHNetWork.m
//  WealthHo
//
//  Created by GF on 2019/4/4.
//  Copyright © 2019 GF. All rights reserved.
//

#import "WHNetWork.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>


@implementation WHNetWork
/**
 *当前网络 可用否
 */
+(BOOL)networkEnable{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){//无网络
        return NO;
    }else if (status == ReachableViaWiFi){// wifi
        return YES;
    }
    else if (status == ReachableViaWWAN){// 3g 4g 2g 5g
        return YES;
    }
    return NO;
}

/**
 *当前 网络类型
 */
+ (NetWorkType)checkCurrentNetType{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        return NetWorkTypeNotReachable;
        
    }else if (status == ReachableViaWiFi){
        return NetWorkTypeWiFi;
    }
    else if (status == ReachableViaWWAN){
        
        CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *netType = netinfo.serviceCurrentRadioAccessTechnology.allValues.firstObject;
        
        if ([netType isEqualToString:CTRadioAccessTechnologyGPRS]) {
            return NetWorkTypeWAN2G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyEdge]) {
            return NetWorkTypeWAN2G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyWCDMA]) {
            return NetWorkTypeWAN3G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyHSDPA]) {
            return NetWorkTypeWAN3G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyHSUPA]) {
            return NetWorkTypeWAN3G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            return NetWorkTypeWAN2G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
            return NetWorkTypeWAN3G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
            return NetWorkTypeWAN3G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
            return NetWorkTypeWAN3G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            return NetWorkTypeWAN3G;
        } else if ([netType isEqualToString:CTRadioAccessTechnologyLTE]) {
            return NetWorkTypeWAN4G;
        }
    }
    return NetWorkTypeUnknown;
}
@end
