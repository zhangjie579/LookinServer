//
//  NSObject+KcAdd.h
//  LookinServer
//
//  Created by 张杰 on 2022/4/14.
//  来源于YYKit

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KcAdd)

- (id)kc_performSelectorWithArgs:(SEL)sel, ...;

+ (id)kc_performSelectorWithArgs:(SEL)sel, ...;

/// 如果返回值为void, 返回nil
+ (nullable id)kc_getReturnFromInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig;

@end

NS_ASSUME_NONNULL_END
