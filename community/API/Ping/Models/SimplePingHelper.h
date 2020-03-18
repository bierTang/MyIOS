//
//  SimplePingHelper.h
//  iOSObjCPing
//
//  Created by YukiOkudera on 2019/07/10.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

@interface SimplePingHelper : NSObject <SimplePingDelegate>

+ (void)ping:(NSString*)address target:(id)target sel:(SEL)sel;

@end
