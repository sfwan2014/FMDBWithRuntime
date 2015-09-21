//
//  EKDataManger.h
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/4.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^QueryFinishBlock) (FMResultSet *set);

@interface SFDataManager : NSObject

@property (nonatomic, copy) QueryFinishBlock block;

+(SFDataManager *)shareDataManager;
-(void)createTableWithSql:(NSString *)sql;
-(void)insertSql:(NSString *)sql;
-(void)querySql:(NSString *)sql finishBlock:(QueryFinishBlock)block;
-(void)deleteSql:(NSString *)sql;
@end
