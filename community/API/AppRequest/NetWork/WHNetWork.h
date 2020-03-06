//
//  WHNetWork.h
//  WealthHo
//
//  Created by GF on 2019/4/4.
//  Copyright © 2019 GF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHNetWork : NSObject
/**
 *当前网络 可用否
 */
+(BOOL)networkEnable;
/**
 *当前 网络类型
 */
+ (NetWorkType)checkCurrentNetType;

@end

NS_ASSUME_NONNULL_END
