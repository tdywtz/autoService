//
//  CityChooseViewController.h
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"

typedef void(^returnResults)(NSString *pName, NSString *pid, NSString *cName, NSString *cid);
@interface CityChooseViewController : CZWBasicViewController

@property (nonatomic,copy) returnResults block;

-(void)returnRsults:(returnResults)block;

@end
