//
//  QDNetDiagnostics.m
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Suning. All rights reserved.
//

#import "QDNetDiagnostics.h"
#import "QDNetDeviceInfo.h"
#import "QDNetServerProtocol.h"

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface QDNetDiagnostics()

@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) id<QDNetServerProtocol> ping;
@property (nonatomic, strong) id<QDNetServerProtocol> traceroute;
@property (nonatomic, copy) Callback callback;
@property (nonatomic, copy) Callback pingCallback;
@property (nonatomic, copy) Callback tracerouteCallback;
@end

@implementation QDNetDiagnostics

- (instancetype)initWithHostName:(NSString *)hostName{
    self = [super init];
    if (self) {
        self.hostName = hostName;
        self.ping = [[NSClassFromString(@"QDPing") alloc] initWithHostName:hostName];
        self.traceroute = [[NSClassFromString(@"QDTraceroute") alloc] initWithHostName:hostName];
    }
    return self;
}

- (void)startDiagnosticAndNetInfo:(Callback) callback {
    self.callback = callback;

    callback(@"begin diagnostics");
    
    NSDictionary *dicBundle = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [dicBundle objectForKey:@"CFBundleDisplayName"];
    callback([NSString stringWithFormat:@"appName：%@",appName]);
    
    NSString *appVersion = [dicBundle objectForKey:@"CFBundleShortVersionString"];
    callback([NSString stringWithFormat:@"appVersion：%@",appVersion]);
    
    UIDevice *device = [UIDevice currentDevice];
    callback([NSString stringWithFormat:@"systemName: %@", [device systemName]]);
    callback([NSString stringWithFormat:@"systemVersion: %@", [device systemVersion]]);
    
    NSString *carrierName;
    NSString *isoCountryCode;
    NSString *mobileCountryCode;
    NSString *mobileNetworkCode;
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if (carrier != NULL) {
        carrierName = [carrier carrierName];
        isoCountryCode = [carrier isoCountryCode];
        mobileCountryCode = [carrier mobileCountryCode];
        mobileNetworkCode = [carrier mobileNetworkCode];
    } else {
        carrierName = @"";
        isoCountryCode = @"";
        mobileCountryCode = @"";
        mobileNetworkCode = @"";
    }
    callback([NSString stringWithFormat:@"carrierName: %@", carrierName]);
    callback([NSString stringWithFormat:@"isoCountryCode: %@", isoCountryCode]);
    callback([NSString stringWithFormat:@"mobileCountryCode: %@", mobileCountryCode]);
    callback([NSString stringWithFormat:@"mobileNetworkCode: %@", mobileNetworkCode]);
    
    callback([NSString stringWithFormat:@"hostName：%@",self.hostName]);
    
    NSString *ip = [QDNetDeviceInfo getIPWithHostName:self.hostName];
    callback([NSString stringWithFormat:@"ipAddress：%@",ip]);
    
    NSString *dns = [QDNetDeviceInfo outPutDNSServers];
    callback([NSString stringWithFormat:@"dnsAddress：%@",dns]);
    
    
    [self.ping startNetServerAndCallback:^(NSString *info, NSInteger flag) {
        if (flag == InfoFlagEnd) {
            [self.traceroute startNetServerAndCallback:^(NSString *info_also, NSInteger flag) {
                self.callback(info_also);
                if (flag == InfoFlagEnd) {
                    callback(@"end diagnostics");
                    [self stop];
                }
            }];
        }

        self.callback(info);

    }];
}

- (void)startPingAndCallback:(Callback) callback {
    self.pingCallback = callback;
    [self.ping startNetServerAndCallback:^(NSString *info, NSInteger flag) {
        if (flag == InfoFlagOn) {
            self.pingCallback(info);
        }else {
            self.pingCallback(info);
            [self stop];
        }
    }];
}

- (void)startTracerouteAndCallback:(Callback) callback {
    self.tracerouteCallback = callback;
    [self.traceroute startNetServerAndCallback:^(NSString *info, NSInteger flag) {
        if (flag == InfoFlagOn) {
            self.tracerouteCallback(info);
        }else {
            self.tracerouteCallback(info);
            [self stop];
        }
    }];
}

- (void)stop {
    self.ping = nil;
    self.traceroute = nil;
    self.callback = nil;
    self.pingCallback = nil;
    self.tracerouteCallback = nil;
}
@end
