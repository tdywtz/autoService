//
//  CZWExpertMyAssistCell.h
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWRootTableViewCell.h"

typedef void(^telephone)(NSString *phoneNumber, NSString *name);
@interface CZWExpertMyAssistCell : CZWRootTableViewCell

//@property (nonatomic,strong) CZWAppealModel *model;
@property (nonatomic,copy) telephone block;
@property (nonatomic,copy) void(^openCell)(CZWExpertMyAssistCell *theCell);

-(void)callDivert:(telephone)block;

-(void)openCell:(void(^)(CZWExpertMyAssistCell *theCell))block;

@end
