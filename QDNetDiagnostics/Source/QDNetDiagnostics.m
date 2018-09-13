//
//  QDNetDiagnostics.m
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Suning. All rights reserved.
//

#import "QDNetDiagnostics.h"
#import "QDNetDeviceInfo.h"
#import "QDTraceroute.h"
#import "QDPing.h"

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface QDNetDiagnostics()

@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) QDPing *ping;
@property (nonatomic, strong) QDTraceroute *traceroute;
@property (nonatomic, copy) Callback callback;
@end

@implementation QDNetDiagnostics

- (instancetype)initWithHostName:(NSString *)hostName{
    self = [super init];
    if (self) {
        self.hostName = hostName;
    }
    return self;
}

- (void)startDiagnosticAndNetInfo:(Callback) callback {
    self.callback = callback;

    callback(@"开始网络诊断");
    
    NSDictionary *dicBundle = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [dicBundle objectForKey:@"CFBundleDisplayName"];
    callback([NSString stringWithFormat:@"应用名：%@",appName]);
    
    NSString *appVersion = [dicBundle objectForKey:@"CFBundleShortVersionString"];
    callback([NSString stringWithFormat:@"版本号：%@",appVersion]);
    
    UIDevice *device = [UIDevice currentDevice];
    callback([NSString stringWithFormat:@"机器类型: %@", [device systemName]]);
    callback([NSString stringWithFormat:@"系统版本: %@", [device systemVersion]]);
    
    NSString *carrierName;
    NSString *ISOCountryCode;
    NSString *MobileCountryCode;
    NSString *MobileNetCode;
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if (carrier != NULL) {
        carrierName = [carrier carrierName];
        ISOCountryCode = [carrier isoCountryCode];
        MobileCountryCode = [carrier mobileCountryCode];
        MobileNetCode = [carrier mobileNetworkCode];
    } else {
        carrierName = @"";
        ISOCountryCode = @"";
        MobileCountryCode = @"";
        MobileNetCode = @"";
    }
    callback([NSString stringWithFormat:@"运营商: %@", carrierName]);
    callback([NSString stringWithFormat:@"ISOCountryCode: %@", ISOCountryCode]);
    callback([NSString stringWithFormat:@"MobileCountryCode: %@", MobileCountryCode]);
    callback([NSString stringWithFormat:@"MobileNetCode: %@", MobileNetCode]);
    
    callback([NSString stringWithFormat:@"测试域名：%@",self.hostName]);
    
    NSString *ip = [QDNetDeviceInfo getIPWithHostName:self.hostName];
    callback([NSString stringWithFormat:@"ip地址：%@",ip]);
    
    NSString *dns = [QDNetDeviceInfo outPutDNSServers];
    callback([NSString stringWithFormat:@"dns地址：%@",dns]);
    
    self.ping = [[QDPing alloc] initWithHostName:self.hostName];
    self.traceroute = [[QDTraceroute alloc] initWithHostName:self.hostName];
    [self.ping pingAndCallback:^(NSString *info, NSInteger flag) {
        if (flag == -1) {
            [self.traceroute traceRouteAndCallback:^(NSString *info_also, NSInteger flag) {
                self.callback(info_also);
                if (flag == -1) {
                    [self stop];
                }
            }];
        }

        self.callback(info);

    }];
    
    
    
}

- (void)stop {
    self.ping = nil;
    self.traceroute = nil;
    self.callback = nil;
}
@end
