//
//  CZWTechnologyGroupViewController.h
//  autoService
//
//  Created by bangong on 16/8/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"

@interface CZWTechnologyGroupViewController : CZWBasicViewController


@property (nonatomic,copy) void (^clickBlock)(NSString *value, NSString * title);
@end
