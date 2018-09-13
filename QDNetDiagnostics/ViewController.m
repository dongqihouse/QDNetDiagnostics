//
//  ViewController.m
//  QDNetDiagnostics
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 qd. All rights reserved.
//

#import "ViewController.h"
#import "QDNetDiagnostics.h"

@interface ViewController ()

@property (nonatomic, strong) QDNetDiagnostics *netDiagnostics;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.netDiagnostics = [[QDNetDiagnostics alloc] initWithHostName:@"wwww.baidu.com"];
    [self.netDiagnostics startDiagnosticAndNetInfo:^(NSString *info) {
        NSLog(@"%@",info);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
