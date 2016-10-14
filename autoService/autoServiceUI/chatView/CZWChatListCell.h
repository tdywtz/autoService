//
//  CZWChatListCell.h
//  autoService
//
//  Created by bangong on 15/12/17.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface CZWChatListCell : RCConversationBaseCell

@property (nonatomic,strong) UIImageView *ivAva;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblDetail;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) UILabel *labelTime;

@end
