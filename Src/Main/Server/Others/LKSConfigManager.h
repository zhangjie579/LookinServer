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

/// 过滤显示的类名
+ (NSArray<NSString *> *)filterShowClassList;

+ (NSDictionary<NSString *, UIColor *> *)colorAlias;

+ (BOOL)shouldCaptureScreenshotOfLayer:(CALayer *)layer;

@end

NS_ASSUME_NONNULL_END

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
