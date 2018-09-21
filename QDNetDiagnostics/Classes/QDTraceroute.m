//
//  QDTraceRoute.m
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 qd. All rights reserved.
//

#import "QDTraceroute.h"

#define kHopsMax  64
#define kTracerouteTimeout 3

@interface QDTraceroute()<QDSimplePingDelegate>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSInteger hopNum;
@property (nonatomic, strong) NSString *nodeIp;
@property (nonatomic, assign) NSInteger sendIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timeoutTimer;
@property (nonatomic, strong) QDSimplePing *tracerouter;

@property (nonatomic, strong) NSString *info;
@property (nonatomic, copy) NetCallback callback;

@end

@implementation QDTraceroute

- (instancetype)initWithHostName:(NSString *)hostName {
    self = [super init];
    if (self) {
        self.hostName = hostName;
    }
    return self;
}

- (void)startNetServerAndCallback:(NetCallback) callback {
    self.callback = callback;
    self.tracerouter = [[QDSimplePing alloc] initWithHostName:self.hostName];
    self.tracerouter.delegate = self;
    [self.tracerouter start];
    
    
}

- (void)checkTimeout {
    if (self.sendIndex == 0) {
        self.info = [NSString stringWithFormat:@"#%ld * * *" , (long)self.hopNum];
    } else if (self.sendIndex == 1){
        self.info = [NSString stringWithFormat:@"%@ * *" , self.info];
    } else if (self.sendIndex == 2) {
        self.info = [NSString stringWithFormat:@"%@ * " , self.info];
    }
    
    self.callback(self.info, InfoFlagOn);
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    
    [self traceroute];
}
- (void)traceroute {
    if (self.hopNum == kHopsMax) {
        [self stopTraceroute];
        return ;
    }
    self.info = @"";
    self.sendIndex = 0;
    self.hopNum += 1;
    [self.tracerouter setTTL:(int)self.hopNum timeout:kTracerouteTimeout];
    [self.tracerouter traceroute];
    self.startDate = [NSDate date];
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kTracerouteTimeout target:self selector:@selector(checkTimeout) userInfo:nil repeats:YES];
}
- (void)stopTraceroute {
    [self.tracerouter stop];
    self.tracerouter = nil;
    
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    
    
    self.callback = nil;
}


#pragma mark -- simplePing delegate
- (void)simplePing:(QDSimplePing *)pinger didStartWithAddress:(NSData *)address {
    [self traceroute];
    NSString *info = @"begin traceroute ";
    self.callback(info, InfoFlagOn);

}

- (void)simplePing:(QDSimplePing *)pinger didFailWithError:(NSError *)error {
    NSString *errorInfo = [NSString stringWithFormat:@"error: %@",error.description];
    self.callback(errorInfo, InfoFlagEnd);
    [self stopTraceroute];
}

- (void)simplePing:(QDSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    NSString *info = @"reach the destination, traceroute finsih";
    self.callback(info, InfoFlagEnd);
    
    [self stopTraceroute];
}

- (void)simplePing:(QDSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    NSTimeInterval diffTime = [[NSDate date] timeIntervalSinceDate:self.startDate] * 1000;
    
    NSString *nodeIp = [self.tracerouter srcAddrInIPv4Packet:packet];
    if (self.sendIndex == 0) {
        self.info = [NSString stringWithFormat:@"#%ld %@ %0.2lfms", (long)self.hopNum, nodeIp, diffTime];
    } else {
        self.info = [NSString stringWithFormat:@"%@ %0.2lfms",self.info, diffTime];
    }
    
    if (self.sendIndex == 3) {
        self.callback(self.info, InfoFlagOn);
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
        
        [self traceroute];
    }
    
    self.sendIndex += 1;
}
@end
