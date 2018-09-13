//
//  QDPing.m
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Suning. All rights reserved.
//

#import "QDPing.h"
@interface QDPing()<QDSimplePingDelegate>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSInteger sequenceNumber;

@property (nonatomic, copy) PingCallback callback;
@property (nonatomic, strong) QDSimplePing *pinger;
@property (nonatomic, strong) NSTimer *timeoutTimer;
@end

@implementation QDPing

- (instancetype)initWithHostName:(NSString *)hostName {
    self = [super init];
    if (self) {
        self.hostName = hostName;
    }
    return self;
}

- (void)pingAndCallback:(PingCallback) callback {
    self.callback = callback;
    self.pinger = [[QDSimplePing alloc] initWithHostName:self.hostName];
    self.pinger.delegate = self;
    [self.pinger start];
   
}
- (void)startPing {
    if (self.timeoutTimer != nil) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
    
    [self.pinger sendPingWithData:nil];
    self.startDate = [NSDate date];
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSString *info = [NSString stringWithFormat:@"#%ld Request timeout for icmp_seq ",(long)self.sequenceNumber];
        if (self.sequenceNumber < 10) {
            self.callback(info, 1);
            [self startPing];
        }else {
            NSString *endInfo = [NSString stringWithFormat:@"end ping %@ =====",self.hostName];
            self.callback(endInfo, -1);
            [self stopPing];
        }
        
    }];
}
- (void)stopPing {
    [self.pinger stop];
    self.pinger = nil;
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
//    self.callback = nil;
}

#pragma mark -- simplePing delegate
- (void)simplePing:(QDSimplePing *)pinger didStartWithAddress:(NSData *)address {
    NSString *info = [NSString stringWithFormat:@"begin ping %@ =====",self.hostName];
    self.callback(info, 1);
    [self startPing];
}

- (void)simplePing:(QDSimplePing *)pinger didFailWithError:(NSError *)error {
    NSString *errorInfo = [NSString stringWithFormat:@"error: %@",error.description];
    self.callback(errorInfo, -1);
    [self stopPing];
}

- (void)simplePing:(QDSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    NSTimeInterval diffTime = [[NSDate date] timeIntervalSinceDate:self.startDate];
    self.sequenceNumber = sequenceNumber;
    NSString *info = [NSString stringWithFormat:@"#%u received, size=%zu time=%fms", sequenceNumber, packet.length, diffTime*1000];
    
    if (sequenceNumber < 9) {
        self.callback(info, 1);
        [self startPing];
    } else {
        self.callback(info, 1);
        NSString *endInfo = [NSString stringWithFormat:@"end ping %@ =====",self.hostName];
        self.callback(endInfo, -1);
        [self stopPing];
    }
}

- (void)simplePing:(QDSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    
}
@end
