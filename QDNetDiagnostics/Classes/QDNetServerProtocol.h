//
//  QDNetServerProtocol.h
//  Pods
//
//  Created by apple on 2018/9/17.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, InfoFlag) {
    InfoFlagOn,
    InfoFlagEnd
};

typedef void(^NetCallback)(NSString *info, NSInteger flag);

@protocol QDNetServerProtocol<NSObject>

- (instancetype)initWithHostName:(NSString *)hostName;

- (void)startNetServerAndCallback:(NetCallback) callback;
@end
