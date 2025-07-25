//
//  KcObjcMethodParser.m
//  LookinServer
//
//  Created by 张杰 on 2022/4/14.
//

#import "KcObjcMethodParser.h"
#import "KcObjcMethodInfo.h"

@interface KcObjcMethodParser ()

@end

@implementation KcObjcMethodParser

/*
 // 可以加+、- 也可以没有
 [ ViewController haha:abc i:12 j: NSObject age:14]
 
 对象: 0x1213 内存地址
 @class()
 @protocol()
 */

/// 解析方法参数
+ (nullable KcObjcMethodParamModel *)parserMethodParamsWithCodeStr:(NSString **)code {
    NSString *codeStr = (*code).copy;
    
    // 去掉头尾空格
    codeStr = [codeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 1.一段方法名
    NSRange range = [codeStr rangeOfString:@":"];
    if (range.location == NSNotFound) { // 没找到 -> 说明方法没参数
        range = [codeStr rangeOfString:@"]"];
        
        if (range.location == NSNotFound) { // 异常情况
            return nil;
        }
        
        KcObjcMethodParamModel *model = [[KcObjcMethodParamModel alloc] init];
        model.selectorName = [[codeStr substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        *code = @""; // 这种情况说明已经解析结束了
        
        return model;
    }
    
    KcObjcMethodParamModel *model = [[KcObjcMethodParamModel alloc] init];
    model.selectorName = [codeStr substringToIndex:range.location + range.length];
    
    codeStr = [codeStr substringFromIndex:range.location + range.length];
    
    // 2.参数
    codeStr = [codeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    range = [codeStr rangeOfString:@" "];
    
    if (range.location == NSNotFound) { // 没找到 -> 说明结束了
        range = [codeStr rangeOfString:@"]"];
        
        if (range.location == NSNotFound) { // 异常情况
            return nil;
        }
        
        model.param = [[codeStr substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        *code = @""; // 这种情况说明已经解析结束了
        
        return model;
    }
    
    model.param = [codeStr substringToIndex:range.location];
    
    // 3.继续下一个参数
    codeStr = [[codeStr substringFromIndex:range.location + range.length] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([codeStr hasPrefix:@"]"]) { // 说明结束了
        *code = @"";
    } else {
        *code = codeStr;
    }
    
    return model;
}

/// 执行方法
+ (KcObjcMethodResult *)eval:(NSString *)text {
    return [self eval:text selfObjc:nil];
}

+ (KcObjcMethodResult *)eval:(NSString *)text selfObjc:(nullable NSObject *)selfObjc {
    // [[[self x1] x2:[xx xx3] wew] sdasd]
    NSMutableArray<NSNumber *> *stack = [[NSMutableArray alloc] init];
    
    NSMutableArray<KcObjcMethodResult *> *methodResults = [[NSMutableArray alloc] init];
    NSMutableArray<NSString *> *methodNames = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < text.length; i++) {
        NSString *charStr = [text substringWithRange:NSMakeRange(i, 1)];
        
        if ([charStr isEqualToString:@"["]) {
            [stack addObject:@(i)];
        } else if ([charStr isEqualToString:@"]"]) {
            NSNumber *number = stack[stack.count - 1];
            NSInteger startIndex = number.integerValue;
            
            [stack removeLastObject];
            
            NSRange range = NSMakeRange(startIndex, i - startIndex + 1);
            
            // 2 3
            NSString *method = [text substringWithRange:range];
            
            
            // [[self x1: [x x1]]
            // [[[self x1] x2:[xx xx3]] sdasd] -> ] x2:
            /*
             [self x1]
             
             [xx xx3]
             
             [a x2: b]
             
             [d sdasd]
             */
            // 是不是单个方法, 比如: [self x1]
            BOOL isOneMethod = YES;
            NSInteger leftCount = 0;
            for (NSInteger k = 0; k < method.length; k++) {
                NSString *c = [method substringWithRange:NSMakeRange(k, 1)];
                
                if ([c isEqualToString:@"["]) {
                    leftCount += 1;
                }
                
                if (leftCount > 1) { // 说明不是单个方法
                    isOneMethod = NO;
                    break;
                }
            }
            
            // 不是单个方法 [[self x1] x2], 就需要一层一层的替换
            // 因为方法的执行肯定是先内层再外层, so替换的顺序也就先内层再外层
            if (!isOneMethod) {
                for (NSInteger j = 0; j < methodResults.count; j++) {
                    KcObjcMethodResult *subResult = methodResults[j];
                    
                    NSString *name = methodNames[j];
                    
                    NSRange r1 = [method rangeOfString:name];
                    
                    // 不能直接存 range来换，因为换了1次后，range就变了
                    if (r1.location != NSNotFound) {
                        // 这里替换成地址, 就算是str也不会有问题
                        // 因为内存没有free, KcObjcMethodResult中还存在
                        method = [method stringByReplacingCharactersInRange:r1 withString:[NSString stringWithFormat:@"%p", subResult.result]];
                    }
                }
            }
            
            KcObjcMethodResult *result = [self evalOnlyOneMethod:method selfObjc:selfObjc];
            
            if (result.error) {
                return result;
            }
            
            [methodResults addObject:result];
            [methodNames addObject:method];
            
            if (stack.count == 0) { // 说明完了
                return result;
            }
        }
    }
    
    return nil;
}

/// 执行一层方法, [xx xx], 不能执行 [[xx xx] xx1]
+ (KcObjcMethodResult *)evalOnlyOneMethod:(NSString *)text selfObjc:(nullable NSObject *)selfObjc {
    NSString *errorInfo = @"";
    KcEvalMethodError errorType;
    KcObjcMethodInfo *_Nullable methodInfo = [self parser:text errorType:&errorType errorInfo:&errorInfo selfObjc:selfObjc];
    
    if (!methodInfo) {
        KcObjcMethodResult *result = [[KcObjcMethodResult alloc] init];
        result.error = errorType;
        result.errorInfo = errorInfo;
        result.methodName = text;
        
        return result;
    }
    
    return [KcObjcInvokeEngine invokeWithMethodInfo:methodInfo selfObjc:selfObjc];
}

+ (nullable KcObjcMethodInfo *)parser:(NSString *)text
                            errorType:(KcEvalMethodError *)errorType
                            errorInfo:(NSString *_Nonnull *_Nullable)errorInfo
                             selfObjc:(nullable NSObject *)selfObjc {
    
    // 过滤前后空格
    NSString *codeStr = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (codeStr.length <= 0) {
        return nil;
    }
    
    NSRange range = [codeStr rangeOfString:@"["];
    
    if (range.location == NSNotFound) {
        *errorType = KcEvalMethodFormatError;
        *errorInfo = @"参考格式: [xxx name]";
        return nil;
    }
    
    codeStr = [codeStr substringFromIndex:range.location + range.length];
    
    KcObjcMethodInfo *info = [[KcObjcMethodInfo alloc] init];
    
    { // 查询target
        // 下一个为空格 - 直到不是空格开头
        codeStr = [codeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        range = [codeStr rangeOfString:@" "];
        
        if (range.location == NSNotFound) {
            *errorInfo = codeStr.copy;
            *errorType = KcEvalMethodParserTargetError;
            return nil;
        }
        
        NSString *targetStr = [codeStr substringToIndex:range.location];
        
        if ([KcObjcInvokeEngine isObjcAddessWithText:targetStr]) { // 说明失败
            info.instanceMethod = true;
            info.target = [KcObjcInvokeEngine objcFromText:targetStr selfObjc:selfObjc];
            
            if (!info.target) { // 解析target失败
                *errorType = KcEvalMethodParserTargetError;
                *errorInfo = [NSString stringWithFormat:@"内存地址->对象失败: %@", targetStr];
                return nil;
            }
            
        } else {
            info.instanceMethod = false;
            info.target = [self classFromString:targetStr];
            
            if (!info.target) { // 解析target失败
                *errorType = KcEvalMethodParserTargetError;
                *errorInfo = [NSString stringWithFormat:@"NSClassFromString创建class失败: %@(非objc class不支持⚠️)", targetStr];
                return nil;
            }
        }
        
        codeStr = [[codeStr substringFromIndex:range.location + range.length] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    // 方法参数
    NSMutableArray<KcObjcMethodParamModel *> *paramModels = [[NSMutableArray alloc] init];
    
    NSMutableString *mutableSelectorName = [[NSMutableString alloc] init];
    
    while (codeStr && codeStr.length > 0) {
        KcObjcMethodParamModel *_Nullable model = [self parserMethodParamsWithCodeStr:&codeStr];
        if (!model) {
            *errorInfo = codeStr.copy;
            *errorType = KcEvalMethodParserParamError;
            return nil;
        }
        
        [mutableSelectorName appendString:model.selectorName];
        
        [paramModels addObject:model];
    }
    
    info.selectorName = [mutableSelectorName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (info.selectorName.length <= 0) {
        *errorType = KcEvalMethodParserSelectorError;
        return nil;
    }
    
    info.params = paramModels;
    
    return info;
}

// MARK: - help

/// 生成class
+ (nullable Class)classFromString:(NSString *)className {
    // 16进制
    if ([className hasPrefix:@"0x"] || [className hasPrefix:@"0X"]) {
        unsigned long long value = strtoull([className UTF8String], NULL, 0);
        
        return (__bridge Class)((void *)value);
    }
    
    Class cls = NSClassFromString(className);
    if (cls) {
        return cls;
    }
    
    // swift class 需要加上命名空间
    NSString *bundleName = [self bundleName];
    if (bundleName.length > 0) {
        cls = NSClassFromString([NSString stringWithFormat:@"%@.%@", bundleName, className]);
    }
    
    return cls;
}

/// 获取bundleName
+ (nullable NSString *)bundleName {
    /// 命名空间
    static NSString *namespace = @"";
    
    if (namespace.length > 0) {
        return namespace;
    }
    
    NSString *_Nullable appName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
    if (appName.length <= 0) {
        return nil;
    }
    
    NSInteger index = 0;
    NSInteger length = appName.length;
    while (index < length) {
        NSString *subString = [appName substringWithRange:NSMakeRange(index, 1)];
        if ([subString isEqualToString:@" "] || [subString isEqualToString:@"-"]) {
            appName = [appName stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:@"_"];
        }
        index++;
    }
    
    namespace = appName;
    
    return appName;
}

@end


