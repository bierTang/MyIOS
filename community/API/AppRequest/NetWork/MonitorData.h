//
//  MonitorData.h
//  WealthHo
//
//  Created by gaofeng on 2019/5/9.
//  Copyright © 2019年 GF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorData : NSObject

@property (assign, nonatomic) float wwanSend;
@property (assign, nonatomic) float wwanReceived;
@property (assign, nonatomic) float wifiSend;
@property (assign, nonatomic) float wifiReceived;

@end

NS_ASSUME_NONNULL_END
