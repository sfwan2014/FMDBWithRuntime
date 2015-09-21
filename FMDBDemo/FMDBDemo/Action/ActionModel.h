//
//  ActionModel.h
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/4.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QueryComplete) (NSArray *result);

@interface ActionModel : NSObject
@property (nonatomic, strong) NSString *action; // 行为
@property (nonatomic, strong) NSString *operation;//操作
@property (nonatomic, strong) NSString *meta;   // 附加信息  (电话, 订单id)
@property (nonatomic, strong) NSString *time;// 操作时间
@property (nonatomic, strong) NSString *acId; // 主键
+(void)create;
-(void)insert;
+(void)query:(QueryComplete)block;
-(void)delete;
@end
