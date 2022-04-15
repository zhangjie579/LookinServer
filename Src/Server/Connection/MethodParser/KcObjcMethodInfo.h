//
//  KcObjcMethodInfo.h
//  LookinServer
//
//  Created by 张杰 on 2022/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// eval执行string方法的错误
typedef NS_ENUM(NSUInteger, KcEvalMethodError) {
    KcEvalMethodNoError, // 没有错误
    KcEvalMethodParserTargetError, // 解析target错误
    KcEvalMethodFormatError, // 方法格式错误
    KcEvalMethodParserParamError, // 解析参数错误
    KcEvalMethodParserSelectorError, // 解析selector错误
    KcEvalMethodNotRecognizeSelectorError, // 未找到方法
    KcEvalMethodNotFindInvocationError, // 未找到invocation
};

/// 整个方法参数中的一小段
@interface KcObjcMethodParamModel : NSObject

/// 方法名
@property (nonatomic, copy) NSString *selectorName;

/// 参数
@property (nonatomic, copy, nullable) NSString *param;

/// 解析字符串 -> 参数
- (nullable id)parserParam;

@end

/// objc方法的信息
@interface KcObjcMethodInfo : NSObject

/// 是否是对象方法
@property (nonatomic, assign, getter=isInstanceMethod) BOOL instanceMethod;

@property (nonatomic, strong) id target;

@property (nonatomic, copy) NSString *selectorName;

@property (nonatomic, copy) NSArray<KcObjcMethodParamModel *> *params;

@end

/// 方法的结果
@interface KcObjcMethodResult : NSObject

/// 执行方法的结果
/// 如果结果为nil, 说明没有返回值, 前提KcEvalMethodError为no
@property (nonatomic, nullable) id result;

/// 错误
@property (nonatomic) KcEvalMethodError error;

/// 错误的信息
@property (nonatomic, copy, nullable) NSString *errorInfo;

- (nullable NSString *)errorLog;

@end

/// 执行方法
@interface KcObjcInvokeEngine : NSObject

+ (KcObjcMethodResult *)invokeWithMethodInfo:(KcObjcMethodInfo *)methodInfo;

/// 是否是对象地址
+ (BOOL)isObjcAddessWithText:(NSString *)text;

/// 16进制对象地址 -> 对象
+ (id)objcFromHexAddress:(NSString *)hexAddress;

@end

NS_ASSUME_NONNULL_END
