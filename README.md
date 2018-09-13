# QDNetDiagnostics

[![CI Status](https://img.shields.io/travis/244514311@qq.com/QDNetDiagnostics.svg?style=flat)](https://travis-ci.org/244514311@qq.com/QDNetDiagnostics)
[![Version](https://img.shields.io/cocoapods/v/QDNetDiagnostics.svg?style=flat)](https://cocoapods.org/pods/QDNetDiagnostics)
[![License](https://img.shields.io/cocoapods/l/QDNetDiagnostics.svg?style=flat)](https://cocoapods.org/pods/QDNetDiagnostics)
[![Platform](https://img.shields.io/cocoapods/p/QDNetDiagnostics.svg?style=flat)](https://cocoapods.org/pods/QDNetDiagnostics)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

QDNetDiagnostics is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QDNetDiagnostics'
```

## Installation manual
依赖
```swift
CoreTelephony.framework
libresolv.tbd
```

## Usage

```swift
self.netDiagnostics = [[QDNetDiagnostics alloc] initWithHostName:@"wwww.baidu.com"];
[self.netDiagnostics startDiagnosticAndNetInfo:^(NSString *info) {
NSLog(@"%@",info);
}];
```

## Result
![结果](result.png)

## Author

244514311@qq.com, 244514311@qq.com

## License

QDNetDiagnostics is available under the MIT license. See the LICENSE file for more info.
