//
//  QDNetDeviceInfo.h
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 qd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QDNetDeviceInfo : NSObject

/// 根据域名获取IP地址
+ (NSString*)getIPWithHostName:(const NSString*)hostName;


/// 获取本机DNS服务器
+ (NSString *)outPutDNSServers;
@end
