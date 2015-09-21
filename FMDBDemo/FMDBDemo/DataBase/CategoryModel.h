//
//  CategoryModel.h
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/28.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import "SFDataModel.h"

/*
    分类数据
     ID, 分类, 缩略图, 标题, 副标题, 功效, 禁忌人群, 适宜人群, 适宜体质, 禁忌体质, 介绍， 营养， 成熟期
 */
@interface CategoryModel : SFDataModel

@property (nonatomic, assign) int cId;
//@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *effect;
@property (nonatomic, strong) NSString *TabuPeople;
@property (nonatomic, strong) NSString *suitablePeople;
@property (nonatomic, strong) NSString *suitableBody;
@property (nonatomic, strong) NSString *TabuBody;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *nutrition;
@property (nonatomic, strong) NSString *quarter;

//-(NSMutableDictionary *)attributeProrertyDic;
//
//-(void)insert;
//+(void)create;
@end
