#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "QDNetDeviceInfo.h"
#import "QDNetDiagnostics.h"
#import "QDPing.h"
#import "QDSimplePing.h"
#import "QDTraceroute.h"

FOUNDATION_EXPORT double QDNetDiagnosticsVersionNumber;
FOUNDATION_EXPORT const unsigned char QDNetDiagnosticsVersionString[];

