//
//  KcObjcMethodInfo.m
//  LookinServer
//
//  Created by 张杰 on 2022/4/14.
//

#import "KcObjcMethodInfo.h"
#import "NSObject+KcAdd.h"
#import "KcObjcMethodParser.h"

@implementation KcObjcMethodInfo

@end

@implementation KcObjcMethodResult

- (nullable NSString *)errorLog {
    if (self.error == KcEvalMethodNoError) {
        return nil;
    }
    
    
    NSString *desc = @"";
    switch (self.error) {
        case KcEvalMethodNoError: {
            desc = @"";
        }
            break;
        case KcEvalMethodParserTargetError: {
            desc = @"😭 解析target错误";
        }
            break;
        case KcEvalMethodFormatError: {
            desc = @"😭 方法格式错误";
        }
            break;
        case KcEvalMethodParserParamError: {
            desc = @"😭 解析参数错误";
        }
            break;
        case KcEvalMethodParserSelectorError: {
            desc = @"😭 解析selector错误";
        }
            break;
        case KcEvalMethodNotRecognizeSelectorError: {
            desc = @"😭 未找到方法";
        }
            break;
        case KcEvalMethodNotFindInvocationError: {
            desc = @"😭 未找到invocation";
        }
            break;
    }
    
    return [NSString stringWithFormat:@"%@: %@", desc, self.errorInfo ?: @""];
}

@end

@implementation KcObjcMethodParamModel

/// 解析字符串 -> 参数
- (nullable id)parserParam {
    if (!self.param) {
        return nil;
    }
    
    if ([self.param hasPrefix:@"@id("]) { // @id(UIView), @id(内存地址) -> 创建对象
        NSRange range = [self.param rangeOfString:@"@id("];
        NSString *content = [self.param substringFromIndex:range.location + range.length];
        range = [content rangeOfString:@")"];
        content = [content substringToIndex:range.location];
        
        Class cls = [KcObjcMethodParser classFromString:content];
        if (cls) {
            return [[cls alloc] init];
        }

        if (([content hasPrefix:@"0x"] || [content hasPrefix:@"0X"])) { // 16进制字符串, 直接str转int会为0
            return [KcObjcInvokeEngine objcFromHexAddress:content];
        } else {
            return (__bridge id)((void *)content.integerValue);
        }
    }
    else if ([self.param hasPrefix:@"@protocol("]) { // id(xxx)
        NSRange range = [self.param rangeOfString:@"@protocol("];
        NSString *protocolName = [self.param substringFromIndex:range.location + range.length];
        range = [protocolName rangeOfString:@")"];
        protocolName = [protocolName substringToIndex:range.location];
        
        return NSProtocolFromString(protocolName);
    }
    // 内存地址不能到这里解析, 因为不知道参数的类型, int、memory address、string
    
    return self.param;
}

@end

@implementation KcObjcInvokeEngine

+ (KcObjcMethodResult *)invokeWithMethodInfo:(KcObjcMethodInfo *)methodInfo {
    KcObjcMethodResult *result = [[KcObjcMethodResult alloc] init];
    
    SEL sel = NSSelectorFromString(methodInfo.selectorName);
    NSMethodSignature * sig = [methodInfo.target methodSignatureForSelector:sel];
    if (!sig) {
//        [methodInfo.target doesNotRecognizeSelector:sel];
        result.error = KcEvalMethodNotRecognizeSelectorError;
        result.errorInfo = methodInfo.selectorName;
        return result;
    }
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    if (!inv) {
//        [methodInfo.target doesNotRecognizeSelector:sel];
        result.error = KcEvalMethodNotFindInvocationError;
        result.errorInfo = methodInfo.selectorName;
        return result;
    }
    [inv setTarget:methodInfo.target];
    [inv setSelector:sel];
    
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        [self setInvocation:inv withSig:sig andArgs:methodInfo.params[index - 2].parserParam index:index];
    }
    
    [inv invoke];
    
    result.error = KcEvalMethodNoError;
    result.result = [NSObject kc_getReturnFromInv:inv withSig:sig];
    
    return result;
}

+ (void)setInvocation:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(NSString *)args index:(int)index {
//    NSUInteger count = [sig numberOfArguments];
//    for (int index = 2; index < count; index++) {
//
//    }
    
    char *type = (char *)[sig getArgumentTypeAtIndex:index];
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
    BOOL unsupportedType = NO;
    switch (*type) {
        case 'v': // 1: void
        case 'B': // 1: bool
        case 'c': // 1: char / BOOL
        case 'C': // 1: unsigned char
        case 's': // 2: short
        case 'S': // 2: unsigned short
        case 'i': // 4: int / NSInteger(32bit)
        case 'I': // 4: unsigned int / NSUInteger(32bit)
        case 'l': // 4: long(32bit)
        case 'L': // 4: unsigned long(32bit)
        { // 'char' and 'short' will be promoted to 'int'.
            int arg = args.intValue;
            [inv setArgument:&arg atIndex:index];
        } break;
            
        case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
        case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
        {
            long long arg = args.longLongValue;
            [inv setArgument:&arg atIndex:index];
        } break;
            
        case 'f': // 4: float / CGFloat(32bit)
        { // 'float' will be promoted to 'double'.
            double arg = args.doubleValue;
            float argf = arg;
            [inv setArgument:&argf atIndex:index];
        } break;
            
        case 'd': // 8: double / CGFloat(64bit)
        {
            double arg = args.doubleValue;
            [inv setArgument:&arg atIndex:index];
        } break;
            
        case 'D': // 16: long double
        {
            long double arg = args.doubleValue;
            [inv setArgument:&arg atIndex:index];
        } break;
            
//            case '*': // char *
//            case '^': // pointer
//            {
//                void *arg = va_arg(args, void *);
//                [inv setArgument:&arg atIndex:index];
//            } break;
            
        case ':': // SEL
        {
            SEL arg = NSSelectorFromString(args);
            [inv setArgument:&arg atIndex:index];
        } break;
            
        case '#': // Class
        {
            Class arg = NSClassFromString(args);
            [inv setArgument:&arg atIndex:index];
        } break;
            
        case '@': // id
        {
            id arg;
            if ([self isObjcAddessWithText:args]) { // 说明是address
                arg = [self objcFromHexAddress:args];
            } else {
                arg = args;
            }
            
            [inv setArgument:&arg atIndex:index];
        } break;
            
//            case '{': // struct
//            {
//                if (strcmp(type, @encode(CGPoint)) == 0) {
//                    CGPoint arg = va_arg(args, CGPoint);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(CGSize)) == 0) {
//                    CGSize arg = va_arg(args, CGSize);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(CGRect)) == 0) {
//                    CGRect arg = va_arg(args, CGRect);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(CGVector)) == 0) {
//                    CGVector arg = va_arg(args, CGVector);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
//                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(CATransform3D)) == 0) {
//                    CATransform3D arg = va_arg(args, CATransform3D);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(NSRange)) == 0) {
//                    NSRange arg = va_arg(args, NSRange);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(UIOffset)) == 0) {
//                    UIOffset arg = va_arg(args, UIOffset);
//                    [inv setArgument:&arg atIndex:index];
//                } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
//                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
//                    [inv setArgument:&arg atIndex:index];
//                } else {
//                    unsupportedType = YES;
//                }
//            } break;
            
        case '(': // union
        {
            unsupportedType = YES;
        } break;
            
        case '[': // array
        {
            unsupportedType = YES;
        } break;
            
        default: // what?!
        {
            unsupportedType = YES;
        } break;
    }
    
    if (unsupportedType) {
        // Try with some dummy type...
        
        NSLog(@"😭😭😭 不支持的参数类型");
        
//            NSUInteger size = 0;
//            NSGetSizeAndAlignment(type, &size, NULL);
//
//#define case_size(_size_) \
//else if (size <= 4 * _size_ ) { \
//    struct dummy { char tmp[4 * _size_]; }; \
//    struct dummy arg = va_arg(args, struct dummy); \
//    [inv setArgument:&arg atIndex:index]; \
//}
//            if (size == 0) { }
//            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
//            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
//            case_size( 9) case_size(10) case_size(11) case_size(12)
//            case_size(13) case_size(14) case_size(15) case_size(16)
//            case_size(17) case_size(18) case_size(19) case_size(20)
//            case_size(21) case_size(22) case_size(23) case_size(24)
//            case_size(25) case_size(26) case_size(27) case_size(28)
//            case_size(29) case_size(30) case_size(31) case_size(32)
//            case_size(33) case_size(34) case_size(35) case_size(36)
//            case_size(37) case_size(38) case_size(39) case_size(40)
//            case_size(41) case_size(42) case_size(43) case_size(44)
//            case_size(45) case_size(46) case_size(47) case_size(48)
//            case_size(49) case_size(50) case_size(51) case_size(52)
//            case_size(53) case_size(54) case_size(55) case_size(56)
//            case_size(57) case_size(58) case_size(59) case_size(60)
//            case_size(61) case_size(62) case_size(63) case_size(64)
//            else {
//                /*
//                 Larger than 256 byte?! I don't want to deal with this stuff up...
//                 Ignore this argument.
//                 */
//                struct dummy {char tmp;};
//                for (int i = 0; i < size; i++) va_arg(args, struct dummy);
//                NSLog(@"YYKit performSelectorWithArgs unsupported type:%s (%lu bytes)",
//                      [sig getArgumentTypeAtIndex:index],(unsigned long)size);
//            }
//#undef case_size

    }
}

/// 是否是对象地址 - 通过16进制判断
+ (BOOL)isObjcAddessWithText:(NSString *)text {
    if (text.length <= 0) {
        return false;
    }
    
    // 因为setInvocation设置参数时, 参数类型为@, 当为string时, 它也是可以数字开头的; 只有class name不能以数字开头
    // 单独处理0, 因为转intValue失败, 会为0
//    NSString *firstStr = [text substringToIndex:1];
//    if ([firstStr isEqualToString:@"0"]) {
//        return true;
//    }
//
//    // 以数字开头, 肯定不会是类名
//    int first = firstStr.intValue;
//    if (first != 0) {
//        return true;
//    }
    
    return ([text hasPrefix:@"0x"] || [text hasPrefix:@"0X"]) ? true : false;
}

/// 16进制对象地址 -> 对象
+ (id)objcFromHexAddress:(NSString *)hexAddress {
    uintptr_t address;
    sscanf(hexAddress.UTF8String, "%lx", &address);
    return (__bridge id)(void *)address;
}

@end
