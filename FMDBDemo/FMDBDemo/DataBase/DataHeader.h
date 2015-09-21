//
//  DataHeader.h
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/28.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#ifndef FMDBDemo_DataHeader_h
#define FMDBDemo_DataHeader_h

// 大类分类  水果 蔬菜 豆类  全部
typedef enum : NSUInteger {
    FruitType,
    VegetableType,
    BeansType,
    All,
} CategoryType;

// 模块分类  季度  功能   禁忌 营养
typedef enum : NSUInteger {
    QuarterModules,
    EffectModules,
    TubeModules,
    NutritionModules,
} CategoryModules;

#endif
