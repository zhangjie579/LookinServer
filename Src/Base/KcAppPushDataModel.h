//
//  KcAppPushDataModel.h
//  LookinShared
//
//  Created by 张杰 on 2024/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KcAppPushDataTypeConsoleLog,
} KcAppPushDataType;

#pragma mark - JSON String 具体类型

@interface KcAppPushConsoleLog : NSObject

@property (nonatomic, copy) NSString *consoleLog;

- (nullable instancetype)initWithDict:(NSDictionary<NSString *, id> *)dict;

- (NSDictionary<NSString *, id> *)makeJSON;

@end

#pragma mark - app 推送过来的数据

/// app 推送过来的数据
@interface KcAppPushDataModel : NSObject <NSSecureCoding, NSCopying>

@property (nonatomic, assign) KcAppPushDataType type;

@property (nonatomic, copy) NSString *jsonString;

/// 解析json string得到的数据
@property (nonatomic, nullable, copy) NSDictionary<NSString *, id> *dict;

+ (NSInteger)pushFrameType;

#pragma mark - 解析 JSON String 到对应的数据类型

- (nullable KcAppPushConsoleLog *)decodeToConsoleLogModel;

@end

/* 推送的例子
 LKS_ConnectionManager *manager = [LKS_ConnectionManager sharedInstance];
 
 KcAppPushDataModel *model = [[KcAppPushDataModel alloc] init];
 model.type = KcAppPushDataTypeConsoleLog;
 
 KcAppPushConsoleLog *logModel = [[KcAppPushConsoleLog alloc] init];
 logModel.consoleLog = @"测试log";
 
 model.jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:logModel.makeJSON options:0 error:nil] encoding:NSUTF8StringEncoding];
 
 [manager pushData:model type:9130];
 */

NS_ASSUME_NONNULL_END
