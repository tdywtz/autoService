//
//  CZWUserExpertAnswerCell.h
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicTableViewCell.h"

typedef void(^telephone)(NSString *phoneNumber, NSString *name);
@interface CZWUserExpertAnswerCell : CZWBasicTableViewCell

@property (nonatomic,strong) CZWReplyModel *model;
@property (nonatomic,copy) telephone block;
/**
 *  点击电话按钮回调方法
 *
 *  @param block block对象
 */
-(void)callDivert:(telephone)block;

@end
