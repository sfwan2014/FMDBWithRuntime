//
//  SFDataModel.h
//  FMDBDemo
//
//  Created by 万绍发 on 15/9/21.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import "BaseModel.h"
#import "SFDataManager.h"

@interface SFDataModel : BaseModel
-(void)insert;
+(void)create;
-(NSMutableDictionary *)attributeProrertyDic;
@end
