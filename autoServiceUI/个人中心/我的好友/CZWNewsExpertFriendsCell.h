//
//  CZWNewsExpertFriendsCell.h
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CZWNewFriendsModel.h"

@interface CZWNewsExpertFriendsCell : UITableViewCell

@property (nonatomic,strong) CZWNewFriendsModel *model;
@property (nonatomic,copy) void(^block)(NSString *title , CZWNewFriendsModel *model);

-(void)clickButton:(void(^)(NSString *title ,CZWNewFriendsModel *model))block;
@end
