//
//  QDTraceRoute.h
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDNetServerProtocol.h"
#import "QDSimplePing.h"


@interface QDTraceroute : NSObject<QDNetServerProtocol>

@property(nonatomic, strong) NSString *hostName;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithHostName:(NSString *)hostName NS_DESIGNATED_INITIALIZER;

- (void)startNetServerAndCallback:(NetCallback) callback;
@end
