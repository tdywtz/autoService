//
//  CZWChooseCarModelViewController.h
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "ChooseViewController.h"

typedef void(^results)(NSString *brandName, NSString *brandId, NSString *seriesNmae, NSString *seriesId, NSString *modelName,NSString *modelId);
@interface CZWChooseCarModelViewController : ChooseViewController

@property (nonatomic,assign) BOOL root;
@property (nonatomic,copy) results resultsBlock;

@property (nonatomic,copy) NSString *brandName;
@property (nonatomic,copy) NSString *brandId;
@property (nonatomic,copy) NSString *seriesNmae;


-(void)results:(results)block;
@end
