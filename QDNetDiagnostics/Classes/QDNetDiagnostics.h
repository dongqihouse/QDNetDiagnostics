//
//  QDNetDiagnostics.h
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Callback)(NSString *);


@interface QDNetDiagnostics : NSObject


- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithHostName:(NSString *)hostName NS_DESIGNATED_INITIALIZER;

- (void)startDiagnosticAndNetInfo:(Callback) callback;

- (void)startPingAndCallback:(Callback) callback;

- (void)startTracerouteAndCallback:(Callback) callback;
@end
