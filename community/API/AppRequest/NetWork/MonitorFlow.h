//
//  MonitorFlow.h
//  WealthHo
//
//  Created by gaofeng on 2019/5/9.
//  Copyright © 2019年 GF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorFlow : NSObject
+ (MonitorFlow *)sharedInstance;
//开始检测

- (void)startMonitor;

//停止检测

- (void)stopMonitor;

@property(nonatomic,copy)NSString *netSendSpeed;//上传速度

@end

NS_ASSUME_NONNULL_END
