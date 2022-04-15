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
    NSString *errorInfo = @"";
    KcEvalMethodError errorType;
    KcObjcMethodInfo *_Nullable methodInfo = [self parser:text errorType:&errorType errorInfo:&errorInfo];
    
    if (!methodInfo) {
        KcObjcMethodResult *result = [[KcObjcMethodResult alloc] init];
        result.error = errorType;
        result.errorInfo = errorInfo;
        
        return result;
    }
    
    return [KcObjcInvokeEngine invokeWithMethodInfo:methodInfo];
}

+ (nullable KcObjcMethodInfo *)parser:(NSString *)text
                            errorType:(KcEvalMethodError *)errorType
                            errorInfo:(NSString *_Nonnull *_Nullable)errorInfo {
    
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
            info.target = [KcObjcInvokeEngine objcFromHexAddress:targetStr];
            
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


