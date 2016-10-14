//
//  CZWEvaluateViewController.h
//  autoService
//
//  Created by bangong on 15/12/23.
//  Copyright © 2015年 车质网. All rights reserved.
//
#import "CZWBasicViewController.h"
/**对谁评价*/
typedef NS_ENUM(NSInteger,EvaluateToStyle) {
    /**对专家评价*/
    EvaluateToExpert,
    /**对厂商评价*/
    EvaluateToManufactor,
    /**对厂商处理结果评价*/
    EvaluateToManufactorResult
};
/**对（专家,厂商）评价*/
@interface CZWEvaluateViewController : CZWBasicViewController

@property (nonatomic,copy) NSString *cpid;
@property (nonatomic,copy) NSString *eid;
@property (nonatomic,assign) EvaluateToStyle tostyle;

@property (nonatomic,copy) void(^success)(NSString *cpid);

-(void)success:(void(^)(NSString *cpid))block;

@end
