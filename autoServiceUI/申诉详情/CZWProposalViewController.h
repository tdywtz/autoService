//
//  CZWProposalViewController.h
//  autoService
//
//  Created by bangong on 16/3/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
/**
 *  填写处理意见
 */
@interface CZWProposalViewController : CZWBasicViewController
/**
 *  申诉cpid
 */
@property (nonatomic,copy) NSString *cpid;
/**
 *  专家id
 */
@property (nonatomic,copy) NSString *eid;

@end
