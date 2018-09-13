//
//  QDTraceRoute.h
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDSimplePing.h"

typedef void(^TracerouteCallback)(NSString *info, NSInteger flag);

@interface QDTraceroute : NSObject

@property(nonatomic, strong) NSString *hostName;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithHostName:(NSString *)hostName NS_DESIGNATED_INITIALIZER;

- (void)traceRouteAndCallback:(TracerouteCallback) callback;
@end
