//
//  KcObjcMethodParser.h
//  LookinServer
//
//  Created by 张杰 on 2022/4/14.
//  objc方法简单语法解析器

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KcEvalMethodError);

@class KcObjcMethodInfo, KcObjcMethodResult;

NS_ASSUME_NONNULL_BEGIN

/// objc方法简单语法解析器
@interface KcObjcMethodParser : NSObject

/// 执行方法
/*
 格式
 * 类方法: [ ViewController haha: 31abc i: 12 j: 1.454 cls:NSObject  ]
 * 对象方法: [0x12434534 方法名:参数value]
 
 当前支持的参数类型: int等基本数据类型, string, 16进制address, 传递class直接用类名, id(类型) -> 内部会创建对应对象, id(地址) -> 内存会转objc对象
 */
+ (KcObjcMethodResult *)eval:(NSString *)text selfObjc:(nullable NSObject *)selfObjc;

+ (KcObjcMethodResult *)eval:(NSString *)text;

/// 解析方法
+ (nullable KcObjcMethodInfo *)parser:(NSString *)text
                            errorType:(KcEvalMethodError *)errorType
                            errorInfo:(NSString *_Nonnull *_Nullable)errorInfo
                             selfObjc:(nullable NSObject *)selfObjc;

/// 生成class
+ (nullable Class)classFromString:(NSString *)className;

/// 获取bundleName
+ (nullable NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
