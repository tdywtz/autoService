//
//  CZWAppealDetailsViewController.h
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
#import "CZWAppealDetailsFootView.h"
/**
 *  申诉详情
 */
@interface CZWAppealDetailsViewController : CZWBasicViewController

@property (nonatomic,strong) NSString *cpid;
/**
 *  查看的申述发起人的用户名
 */
@property (nonatomic,strong) NSString *targetUname;
/**
 *  查看的申述发起人的id
 */
@property (nonatomic,strong) NSString *targetUid;

/**
 *  定位字符
 *  #+专家id
 */
@property (nonatomic,strong) NSString *scrollSting;

@property (nonatomic,strong) CZWAppealDetailsFootView *footView;

@end
