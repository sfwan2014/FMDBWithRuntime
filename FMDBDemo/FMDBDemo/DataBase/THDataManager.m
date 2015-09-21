//
//  THDataManager.m
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/28.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import "THDataManager.h"

#define TABLENAME   @"Content"

@implementation THDataManager{
    FMDatabase *db;
}

+(THDataManager *)shareDataManager{
    static THDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[THDataManager alloc] init];
    });
    
    return instance;
}

-(id)init{
    self = [super init];
    if (self) {
        db = [FMDatabase databaseWithPath:self.filePath];
    }
    return self;
}

/*
    ID, 分类, 缩略图, 标题, 副标题, 功效, 禁忌人群, 适宜人群, 适宜体质, 禁忌体质, 介绍
 */

-(void)queryVegetableWithSql:(NSString *)sql finishBlock:(THQueryFinishBlock)block{
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        
        NSMutableArray *result = [NSMutableArray array];
        while ([rs next]) {
//            int ID = [rs intForColumn:@"rowid"];
            NSString *suoluetu = [rs stringForColumn:@"_imageName"];
            NSString *title = [rs stringForColumn:@"_title"];
            NSString *subTitle = [rs stringForColumn:@"_subTitle"];
            NSString *gongxiao = [rs stringForColumn:@"_effect"];
            NSString *jinjirenqun = [rs stringForColumn:@"_tubePeople"];
            NSString *shiyirenqun = [rs stringForColumn:@"_suitPeople"];
            NSString *shiyitizhi = [rs stringForColumn:@"_suitBody"];
            NSString *jinjitizhi = [rs stringForColumn:@"_tubeBody"];
            NSString *introduce = [rs stringForColumn:@"_introduce"];
            NSString *nutrition = [rs stringForColumn:@"_nutrition"];
            NSString *quarter = [rs stringForColumn:@"_quarter"];
            
            CategoryModel *model = [[CategoryModel alloc] init];
            
//            model.ID = ID;
            model.imageName = suoluetu;
            model.title = title;
            model.subTitle = subTitle;
            model.effect = gongxiao;
            model.TabuPeople = jinjirenqun;
            model.suitablePeople = shiyirenqun;
            model.suitableBody = shiyitizhi;
            model.TabuBody = jinjitizhi;
            model.introduce = introduce;
            model.nutrition = nutrition;
            model.quarter = quarter;
            
            [result addObject:model];
        }
        if (block) {
            block(result);
        }
        [db close];
    }
}

-(void)queryVegetableWithModules:(CategoryModules)module text:(NSString *)text FinishBlock:(THQueryFinishBlock)block{
    
    NSString *modules = [self modules:module];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ where \"%@\" like \"%@\"",TABLENAME, modules, text];
    [self queryVegetableWithSql:sql finishBlock:block];
}

-(void)queryVegetableFinishBlock:(THQueryFinishBlock)block{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLENAME];
    [self queryVegetableWithSql:sql finishBlock:block];
}

#pragma mark - getter
-(NSString *)filePath{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.sqlite"];
//    
//    NSLog(@"path: %@", dbPath);

//    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"fruits.db3" ofType:nil];
//    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"vegetable.db3" ofType:nil];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"fruits.sqlite" ofType:nil];
    
    return dbPath;
}

-(NSString *)modules:(CategoryModules)module{
    
    NSString *modules = @"";
    switch (module) {
        case QuarterModules:
        {
            
        }
            break;
        case EffectModules:{
            modules = @"_effect";
        }
            break;
        case TubeModules: {
            modules = @"_tubePeople";
        }
            break;
            
        case NutritionModules: {
            
        }
            break;
            
        default:
            break;
    }
    return modules;
}

@end
