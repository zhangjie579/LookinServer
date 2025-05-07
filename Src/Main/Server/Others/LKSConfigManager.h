#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LKSConfigManager.h
//  LookinServer
//
//  Created by likai.123 on 2023/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKSConfigManager : NSObject

+ (NSArray<NSString *> *)collapsedClassList;

+ (NSDictionary<NSString *, UIColor *> *)colorAlias;

+ (BOOL)shouldCaptureScreenshotOfLayer:(CALayer *)layer;

/// 注入的方法
+ (NSArray<NSDictionary<NSString *, id> *> *)kc_injectMethods;
/// 注入执行keyPath的方法
+ (NSArray<NSDictionary<NSString *, id> *> *)kc_injectKeyPathMethods;

@end

NS_ASSUME_NONNULL_END

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
