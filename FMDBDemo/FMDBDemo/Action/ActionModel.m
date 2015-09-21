//
//  ActionModel.m
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/4.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import "ActionModel.h"
#import <objc/runtime.h>

#define TABLENAME    @"log"

@implementation ActionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        NSString *time = [NSString stringWithFormat:@"%f", timeInterval];
        NSString *acId = @"";
        self.acId = acId;
        self.time = time;
    }
    return self;
}

-(NSArray *)attributePropertyList{
    
    NSDictionary *dic = [self attributeProrertyDic];
    NSArray *array = [dic allKeys];
    return array;
}

-(NSDictionary *)attributeProrertyDic{
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

+(void)create{
    ActionModel *model = [[ActionModel alloc]init];
    NSArray *attributes = [model attributePropertyList];
    NSMutableString *mutSql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (",TABLENAME];
    for (int i = 0; i < attributes.count; i++) {
        NSString *key = attributes[i];
        
        if (i == attributes.count - 1) {
            if ([key hasSuffix:@"Id"]) {
                [mutSql appendFormat:@"'%@' TEXT PRIMARY KEY )", key];
                break;
            }
            [mutSql appendFormat:@"'%@' TEXT)", key];
            break;
        }
        
        if ([key hasSuffix:@"Id"]) {
            [mutSql appendFormat:@"'%@' TEXT PRIMARY KEY AUTOINCREMENT,", key];
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
        if (value == nil || value.length == 0) {
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
    
//    NSString *insertSql1= [NSString stringWithFormat:
//                           @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
//                           TABLENAME, NAME, AGE, ADDRESS, @"张三", @"13", @"济南"];
    NSLog(@"%@", sqlStr);
    
    [[SFDataManager shareDataManager] insertSql:sqlStr];
}


+(void)query:(QueryComplete)block{
    
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLENAME];
    [[SFDataManager shareDataManager] querySql:sql finishBlock:^(FMResultSet *rs) {
        
        NSMutableArray *allModels = [NSMutableArray array];
        while ([rs next]) {
            
            ActionModel *model = [[ActionModel alloc] init];
            
            NSArray *allKeys = [model attributePropertyList];
            for (int i = 0; i < allKeys.count; i++) {
                NSString *key = allKeys[i];
                
                id value = [rs stringForColumn:key];
                if (value == nil) {
                    value = @"";
                }
                key = [key substringFromIndex:1];
                SEL selector = [ActionModel getSetterSelWithAttibuteName:key];
                [model performSelector:selector withObject:value];
            }
            [allModels addObject:model];
        }
        if (block) {
            block(allModels);
        }
    }];
}

-(void)delete{
    
    NSString *sql = [NSString stringWithFormat:
                     @"delete from %@ where %@ = '%@'",
                     TABLENAME, @"_acId", _acId];
    [[SFDataManager shareDataManager] deleteSql:sql];
}

+(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}


@end
