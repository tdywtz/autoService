//
//  CZWMyFriendsExpertCell.h
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicTableViewCell.h"

@interface CZWMyFriendsExpertCell : CZWBasicTableViewCell

@property (nonatomic,strong) CZWChatUserInfo *userInfo;

@property (nonatomic,copy) void (^clickImage)(NSString *ID ,NSString *RID);

-(void)clickImage:(void(^)(NSString *ID , NSString *RID))block;

@end
