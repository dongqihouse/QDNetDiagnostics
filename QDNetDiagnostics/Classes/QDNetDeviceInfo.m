//
//  QDNetDeviceInfo.m
//  QD
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 qd. All rights reserved.
//

#import "QDNetDeviceInfo.h"
#include <resolv.h>
#include <arpa/inet.h>
#include <netdb.h>



@implementation QDNetDeviceInfo

/// 获取本机DNS服务器
+ (NSString *)outPutDNSServers
{
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    
    NSMutableArray *dnsArray = @[].mutableCopy;
    
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            
            [dnsArray addObject:s];
        }
    }
    else{
        NSLog(@"%@",@" res_init result != 0");
    }
    
    res_nclose(res);
    
    return dnsArray.firstObject;
}

/// 根据域名获取IP地址
+ (NSString*)getIPWithHostName:(const NSString*)hostName
{
    const char *hostN= [hostName UTF8String];
    
    // 记录主机的信息，包括主机名、别名、地址类型、地址长度和地址列表 结构体
    struct hostent *phot;
    
    @try {
        // 返回对应于给定主机名的包含主机名字和地址信息的hostent结构指针
        phot = gethostbyname(hostN);
        
        struct in_addr ip_addr;
        
        memcpy(&ip_addr, phot->h_addr_list[0], 4);
        
        char ip[20] = {0};
        
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        
        NSString* strIPAddress = [NSString stringWithUTF8String:ip];
        
        return strIPAddress;
        
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
