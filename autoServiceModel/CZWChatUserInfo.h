//
//  CZWChatUserInfo.h
//  autoService
//
//  Created by bangong on 16/1/14.
//  Copyright © 2016年 车质网. All rights reserved.
//
/**
 *  是否好友
 */
typedef NS_ENUM(NSInteger,FriendType) {
    /**
     *  是好友
     */
    FriendTypeYes = 1,
    /**
     *  不是好友
     */
    FriendTypeNot = 2
};

#import <Foundation/Foundation.h>

/**
 *  通讯用户模型
 */
@interface CZWChatUserInfo : NSObject
/**
 *  融云id
 */
@property (nonatomic,copy) NSString *userId;
/**
 *  融云用户名
 */
@property (nonatomic,copy) NSString *userName;
/**
 *  头像链接
 */
@property (nonatomic,copy) NSString *iconUrl;
///**
// *  头像
// */
//@property (nonatomic,strong) UIImage *image;
/**
 *  地区
 */
@property (nonatomic,copy) NSString *area;
/**
 *  用户、专家id
 */
@property (nonatomic,copy) NSString *seviceId;
/**
 *  好友类型；1--用户，2--专家
 */
@property (nonatomic,copy) NSString *type;
/**
 *  车型（用户）
 */
@property (nonatomic,copy) NSString *modelName;
/**
 *  评分数（专家）
 */
@property (nonatomic,copy) NSString *score;
/**
 *  解决单数（专家）
 */
@property (nonatomic,copy) NSString *complete_num;
/**
 *  好友关系；1--好友，2或null--非好友
 */
@property (nonatomic,assign) FriendType isfriend;

/**
 *  使用聊天信息字典创建数据模型
 *
 *  @param dict 聊天用户个人信息
 *
 *  @return
 */
-(instancetype)initWithDictrionary:(NSDictionary *)dict;


@end
