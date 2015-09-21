//
//  BaseModel.h
//  FootballPlayer
//
//  Created by qqhe on 14-3-23.
//  Copyright (c) 2014年 qqhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary *)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串


@end
