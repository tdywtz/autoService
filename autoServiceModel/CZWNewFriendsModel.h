//
//  CZWNewFriendsModel.h
//  autoService
//
//  Created by bangong on 16/2/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZWChatUserInfo.h"

@interface CZWNewFriendsModel : NSObject
/**
 *  用户信息
 */
@property (nonatomic,strong) CZWChatUserInfo *userInfo;
/**
 *  请求附加内容
 */
@property (nonatomic,copy) NSString *content;
/**
 *  会话id(当前为系统会话)
 */
@property (nonatomic,copy) NSString *targetId;
/**
 *操作类型名（同意、添加好友）
 */
@property (nonatomic,copy) NSString *operation;
/**
 *  消息阅读状态
 */
@property (nonatomic,assign) RCReceivedStatus receivedStatus;

@end
