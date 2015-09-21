//
//  ViewController.m
//  FMDBDemo
//
//  Created by wanshaofa on 15/6/4.
//  Copyright (c) 2015年 enuke. All rights reserved.
//

#import "ViewController.h"
#import "THDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self plist2Sqlite];
//    [self sqlite2Plist];
}

-(void)sqlite2Plist{
    [ActionModel create];
    
    // 美容养颜  促进睡眠 抑制痘痘 护目 养肝  健胃 提神 果腹
    NSArray *array = @[@"%美容%", @"%睡眠%", @"%痘痘%", @"%护目%", @"%养肝%", @"%胃%", @"%提神%", @"%果腹%"];
    
    for (NSString *key in array) {
        [[THDataManager shareDataManager] queryVegetableWithModules:EffectModules text:key FinishBlock:^(NSMutableArray *result) {
            NSLog(@"%@", result);
        }];
    }
    
    [[THDataManager shareDataManager] queryVegetableFinishBlock:^(NSMutableArray *result) {
        
        NSMutableArray *models = [NSMutableArray array];
        for (CategoryModel *model in result) {
            
            NSMutableDictionary *attr = model.attributeProrertyDic;
            [attr setObject:@"" forKey:@"_nutrition"];
            [attr setObject:@"" forKey:@"_quarter"];
            [models addObject:attr];
        }
        
        //        [models writeToFile:@"/Users/sfwan/Desktop/fruits.plist" atomically:YES];
        
//        [models writeToFile:@"/Users/sfwan/Desktop/vegetable.plist" atomically:YES];
        
    }];
}

-(void)plist2Sqlite{
    
    [CategoryModel create];
    
    NSString *filaPath = [[NSBundle mainBundle] pathForResource:@"fruits.plist" ofType:nil];
    NSArray *models = [[NSArray alloc] initWithContentsOfFile:filaPath];
    
    NSMutableArray *newModels = [NSMutableArray array];
    
    NSMutableArray *names1 = [NSMutableArray array];
    NSMutableArray *names2 = [NSMutableArray array];
    for (int i = 0; i < models.count; i++) {
        NSDictionary *dic = models[i];
        CategoryModel *model = [[CategoryModel alloc] initWithDataDic:dic];
        [newModels addObject:model];
        if (i < 60) {
            [names1 addObject:model.title];
        } else {
            [names2 addObject:model.title];
        }
    }
    
//    filaPath = @"/Users/sfwan/Desktop/names1.txt";
//    [names1 writeToFile:filaPath atomically:YES];
//    filaPath = @"/Users/sfwan/Desktop/names2.txt";
//    [names2 writeToFile:filaPath atomically:YES];
    
    for (CategoryModel *model in newModels) {
        [model insert];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}




@end
