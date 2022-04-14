//
//  ViewController.m
//  LookinServer
//
//  Created by 张杰 on 2022/4/13.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uintptr_t address = (uintptr_t)((__bridge void *)self.view);
    
    
    id objc = (__bridge id)((void *)address);
    
    NSLog(@"%@", objc);
}


@end
