//
//  CZWCheckProposalViewController.h
//  autoService
//
//  Created by bangong on 16/3/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
/**
 *  查看专家建议
 */
@interface CZWCheckProposalViewController : CZWBasicViewController
/**
 *  申诉id
 */
@property (nonatomic,copy) NSString *cpid;
/**
 *  专家id
 */
@property (nonatomic,copy) NSString *eid;
@end
