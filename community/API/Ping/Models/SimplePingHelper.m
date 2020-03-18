//
//  SimplePingHelper.m
//  iOSObjCPing
//
//  Created by YukiOkudera on 2019/07/10.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

#import "SimplePingHelper.h"

@interface SimplePingHelper()
@property(nonatomic,retain) SimplePing* simplePing;
@property(nonatomic,retain) id target;
@property(nonatomic,assign) SEL sel;
- (id)initWithAddress:(NSString*)address target:(id)_target sel:(SEL)_sel;
- (void)go;
@end

@implementation SimplePingHelper
@synthesize simplePing, target, sel;

#pragma mark - Run it

// Pings the address, and calls the selector when done. Selector must take a NSnumber which is a bool for success
+ (void)ping:(NSString*)address target:(id)target sel:(SEL)sel {
    // The helper retains itself through the timeout function
    [[[SimplePingHelper alloc] initWithAddress:address target:target sel:sel] go];
}

#pragma mark - Init

- (id)initWithAddress:(NSString*)address target:(id)_target sel:(SEL)_sel {
    if (self = [self init]) {
        self.simplePing = [SimplePing simplePingWithHostName:address];
        self.simplePing.delegate = self;
        self.target = _target;
        self.sel = _sel;
    }
    return self;
}

#pragma mark - Go

- (void)go {
    [self.simplePing start];
    [self performSelector:@selector(endTime) withObject:nil afterDelay:1]; // This timeout is what retains the ping helper
}

#pragma mark - Finishing and timing out

// Called on success or failure to clean up
- (void)killPing {
    [self.simplePing stop];
    self.simplePing = nil;
}

- (void)successPing {
    [self killPing];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:sel withObject:[NSNumber numberWithBool:YES]];
#pragma clang diagnostic pop
}

- (void)failPing:(NSString*)reason {
    [self killPing];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:sel withObject:[NSNumber numberWithBool:NO]];
#pragma clang diagnostic pop
}

// Called 1s after ping start, to check if it timed out
- (void)endTime {
    if (self.simplePing) { // If it hasn't already been killed, then it's timed out
        [self failPing:@"timeout"];
    }
}

#pragma mark - Pinger delegate

// When the pinger starts, send the ping immediately
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    [self.simplePing sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    [self failPing:@"didFailWithError"];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error {
    // Eg they're not connected to any network
    [self failPing:@"didFailToSendPacket"];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
    [self successPing];
}

@end
