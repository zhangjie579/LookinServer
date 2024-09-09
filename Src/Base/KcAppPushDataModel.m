//
//  KcAppPushDataModel.m
//  LookinShared
//
//  Created by 张杰 on 2024/9/8.
//

#import "KcAppPushDataModel.h"

@implementation KcAppPushDataModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.jsonString = [aDecoder decodeObjectForKey:@"jsonString"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.jsonString forKey:@"jsonString"];
}

- (NSDictionary<NSString *,id> *)dict {
    if (!_dict) {
        NSData *_Nullable data = [self.jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            _dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
    }
    
    return _dict;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    KcAppPushDataModel *model = [[KcAppPushDataModel allocWithZone:zone] init];
    
    model.type = self.type;
    model.jsonString = self.jsonString;
    
    return model;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (NSInteger)pushFrameType {
    return 9130;
}

#pragma mark - 解析 JSON String 到对应的数据类型

- (nullable KcAppPushConsoleLog *)decodeToConsoleLogModel {
    if (self.type != KcAppPushDataTypeConsoleLog) {
        return nil;
    }
    
    if (!self.dict) {
        return nil;
    }
    
    return [[KcAppPushConsoleLog alloc] initWithDict:self.dict];
}

@end

#pragma mark - JSON String 具体类型

@implementation KcAppPushConsoleLog

- (nullable instancetype)initWithDict:(NSDictionary<NSString *, id> *)dict {
    if (!dict[@"consoleLog"]) {
        return nil;
    }
    
    if (self = [super init]) {
        self.consoleLog = dict[@"consoleLog"];
    }
    
    return self;
}

- (NSDictionary<NSString *, id> *)makeJSON {
    return @{
        @"consoleLog": self.consoleLog,
    };
}

@end
