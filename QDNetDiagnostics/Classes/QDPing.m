//
//  QDPing.m
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Suning. All rights reserved.
//

#import "QDPing.h"

#define kSequenceNumberMax 9
#define kpingTimeout 1.5

@interface QDPing()<QDSimplePingDelegate>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSInteger sequenceNumber;

@property (nonatomic, copy) NetCallback callback;
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

- (void)startNetServerAndCallback:(NetCallback) callback; {
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
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kpingTimeout repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.sequenceNumber += 1;
        NSString *info = [NSString stringWithFormat:@"#%ld Request timeout for icmp_seq ",(long)self.sequenceNumber];
        if (self.sequenceNumber < kSequenceNumberMax) {
            self.callback(info, InfoFlagOn);
            [self startPing];
        }else {
            NSString *endInfo = [NSString stringWithFormat:@"end ping %@ ",self.hostName];
            self.callback(endInfo, InfoFlagEnd);
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
    NSString *info = [NSString stringWithFormat:@"begin ping %@ ",self.hostName];
    self.callback(info, InfoFlagOn);
    [self startPing];
}

- (void)simplePing:(QDSimplePing *)pinger didFailWithError:(NSError *)error {
    NSString *errorInfo = [NSString stringWithFormat:@"error: %@",error.description];
    self.callback(errorInfo, InfoFlagEnd);
    [self stopPing];
}

- (void)simplePing:(QDSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    NSTimeInterval diffTime = [[NSDate date] timeIntervalSinceDate:self.startDate];
    self.sequenceNumber = sequenceNumber;
    NSString *info = [NSString stringWithFormat:@"#%u received, size=%zu time=%fms", sequenceNumber, packet.length, diffTime*1000];
    
    if (sequenceNumber < kSequenceNumberMax) {
        self.callback(info, InfoFlagOn);
        [self startPing];
    } else {
        self.callback(info, InfoFlagOn);
        NSString *endInfo = [NSString stringWithFormat:@"end ping %@ ",self.hostName];
        self.callback(endInfo, InfoFlagEnd);
        [self stopPing];
    }
}

- (void)simplePing:(QDSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    
}
@end
