//
//  ViewController.m
//  LookinServer
//
//  Created by 张杰 on 2022/4/13.
//

#import "ViewController.h"
#import "NSObject+KcAdd.h"
#import "OCEval.h"

#import "KcObjcMethodParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uintptr_t address = (uintptr_t)((__bridge void *)self);
    
    id objc = (__bridge id)((void *)address);
    
    NSLog(@"%@", objc);
    
//    uintptr_t address1;
//    sscanf(@"0x002342".UTF8String, "%lx", &address1);
    
//    id a = [self kc_performSelectorWithArgs:@selector(a:b:str:), 1, 13.15, @"str"];
//    NSLog(@"%@", a);
    
//    id b = [ViewController kc_performSelectorWithArgs:@selector(haha:i:j:), @"zz", 3.4, 5.12];
//    NSLog(@"%@", b);
    
//    NSString *a = [OCEval eval:@"return [ViewController haha:'abc' i:12 j: 1.42]"];
//    NSLog(@"%@", a);
    
    
    //  [ ViewController haha:abc i:12 j: @class(NSObject) age:14]
    
    
    
    [KcObjcMethodParser eval:@"[ ViewController haha: 31abc i: 12 j: 1.454 cls:NSObject  ]"];
    
    [KcObjcMethodParser eval:[NSString stringWithFormat:@" [ 0x%lx   test1   ] ", address]];
    
    
    NSLog(@"");
}

- (void)test1 {
    NSLog(@"");
}

- (int)a:(int)a b:(double)b str:(NSString *)str {
    NSLog(@"%d, %f, %@", a, b, str);
    
    return 1;
}

+ (NSString *)haha:(NSString *)str i:(int)i j:(float)j cls:(Class)cls {
    NSLog(@"%d, %f, %@", i, j, str);
    
    return @"3.1";
}


@end
