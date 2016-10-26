//
//  CZWComplainViewController.h
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"

/**
 *  申诉表单页面
 */
@interface CZWAppealViewController : CZWBasicViewController
/**
 *  申诉数据
 */
@property (nonatomic,strong) NSDictionary *dictionary;
/**
 *  是否修改
 */
@property (nonatomic,assign) BOOL revise;
/**
 *  修改申诉的cpid
 */
@property (nonatomic,copy) NSString *cpid;
@end
