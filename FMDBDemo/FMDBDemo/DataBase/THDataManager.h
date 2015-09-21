//
//  THDataManager.h
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/28.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"
#import "DataHeader.h"



typedef void (^THQueryFinishBlock) (NSMutableArray *result);
@interface THDataManager : NSObject

-(void)queryVegetableFinishBlock:(THQueryFinishBlock)block;

-(void)queryVegetableWithModules:(CategoryModules)module text:(NSString *)text FinishBlock:(THQueryFinishBlock)block;

+(THDataManager *)shareDataManager;

@end
