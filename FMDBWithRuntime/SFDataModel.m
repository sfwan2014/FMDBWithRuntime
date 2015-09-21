//
//  SFDataModel.m
//  FMDBDemo
//
//  Created by 万绍发 on 15/9/21.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import "SFDataModel.h"
#import <objc/runtime.h>

// 表名
#define TABLENAME       @"Content"

// 主键名称
#define PRIMARY_KEY     @"Id"

@implementation SFDataModel

-(NSMutableDictionary *)attributeProrertyDic{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i<count; i++) {
        
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[NSNull class]] || value == nil) {
            value = @"";
        }
        [dic setObject:value forKey:key];
    }
    
    free(ivars);
    return dic;
}

-(NSArray *)attributePropertyList{
    
    NSDictionary *dic = [self attributeProrertyDic];
    NSArray *array = [dic allKeys];
    return array;
}

+(void)create{
    
    id model = [[self alloc] init];
    NSArray *attributes = [model attributePropertyList];
    NSMutableString *mutSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (",TABLENAME];
    for (int i = 0; i < attributes.count; i++) {
        NSString *key = attributes[i];
        
        if (i == attributes.count - 1) {
            if ([key hasSuffix:PRIMARY_KEY]) {
                [mutSql appendFormat:@"'%@' TEXT PRIMARY KEY )", key];
                break;
            }
            [mutSql appendFormat:@"'%@' TEXT)", key];
            break;
        }
        
        if ([key hasSuffix:PRIMARY_KEY]) {
            [mutSql appendFormat:@"'%@' INTEGER PRIMARY KEY AUTOINCREMENT,", key];
            continue;
        }
        
        [mutSql appendFormat:@"'%@' TEXT, ", key];
        
    }
    
    [[SFDataManager shareDataManager] createTableWithSql:mutSql];
}

-(void)insert{
    
    NSDictionary *attributeDic = [self attributeProrertyDic];
    NSArray *allKeys = [attributeDic allKeys];
    NSMutableString *sqlStr = [NSMutableString stringWithFormat:@"INSERT INTO '%@'", TABLENAME];
    NSMutableString *sqlKeyStr = [NSMutableString stringWithFormat:@"("];
    NSMutableString *sqlValueStr = [NSMutableString stringWithFormat:@") VALUES ("];
    
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < allKeys.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = attributeDic[key];
        if (value == nil || [value isKindOfClass:[NSNumber class]] || value.length == 0) {
            continue;
        }
        [newDic setObject:value forKey:key];
    }
    
    allKeys = [newDic allKeys];
    for (int i = 0; i < allKeys.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = newDic[key];
        
        if (i == allKeys.count - 1) {
            [sqlKeyStr appendFormat:@"'%@' ", key];
            [sqlValueStr appendFormat:@"'%@' ", value];
            break;
        }
        
        [sqlKeyStr appendFormat:@"'%@', ", key];
        [sqlValueStr appendFormat:@"'%@', ", value];
    }
    [sqlValueStr appendString:@")"];
    
    [sqlStr appendString:sqlKeyStr];
    [sqlStr appendString:sqlValueStr];
    
    [[SFDataManager shareDataManager] insertSql:sqlStr];
}

@end
