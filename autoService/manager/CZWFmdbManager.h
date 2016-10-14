//
//  CZWFmdbManager.h
//  autoService
//
//  Created by bangong on 15/12/8.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "CZWChatUserInfo.h"
/**
 *  SQL操作
 */
@interface CZWFmdbManager : NSObject

/**
 *  开启单例
 */
+(CZWFmdbManager *)manager;
/**
 *  刷新配置
 */
-(void)updataManager;

#pragma mark - 收藏
/**
 *  插入收藏数据
 *
 *  @param ID 申诉cpid
 */
-(void)insertIntoCollect:(NSString *)ID;
//-(void)updateCollectSet:(NSString *)newsID Where:(NSString *)ID;

/**
 *  删除收藏数据
 *
 *  @param ID 申诉cpid
 */
-(void)deleteFromCollectWith:(NSString *)ID;

/**
 *  获取收藏列表
 *
 *  @return 收藏id集合
 */
-(NSArray *)selectAllFromCollect;



#pragma mark - 好友
/**
 *  新增用户
 *
 *  @param userInfo chat用户模型
 *
 *  @return 返回操作结果
 */
-(BOOL)insertIntoFriends:(CZWChatUserInfo *)userInfo;

/**
 *  批量插入好友用户数据
 *
 *  @param Infos 用户模型数组
 *
 *  @return 操作结果
 */
-(BOOL)insertListIntoFriends:(NSArray<__kindof CZWChatUserInfo *> *)Infos;

/**
 *  更新指定用户信息
 *
 *  @param userInfo chat用户模型
 *
 *  @return 返回操作结果
 */
-(BOOL)updataIntoFriends:(CZWChatUserInfo *)userInfo;

/**
 *  修改好友类型
 *
 *  @param userId    要修改的用户id
 *  @param isfriends 好友类型
 *
 *  @return bool
 */
-(BOOL)updataFriendsTypeWithUserId:(NSString *)userId isFriends:(FriendType)isfriend;

/**
 *  更新头像
 *
 *  @param userId 融云用户id
 *  @param image  图片
 *
 *  @return 返回操作结果
 */
-(BOOL)updataImageIntoFriendsWithUserId:(NSString *)userId image:(UIImage *)image;

/**
 *  查询指定用户信息
 *
 *  @param userId 融云用户id
 *
 *  @return 返回用户模型
 */
-(CZWChatUserInfo *)selectFromeFriendsWithUserId:(NSString *)userId;

/**
 *  获取好友列表
 *
 *  @return 好友数组
 */
-(NSArray<__kindof CZWChatUserInfo *> *)selectListFromFriends;

/**
 *  删除好友
 *
 *  @param userId 融云用户id
 *
 *  @return 操作结果
 */
-(BOOL)deleteFromFriendsWithUserId:(NSString *)userId;

/**
 *  清空表数据
 *
 *  @return bool
 */
-(BOOL)deleteDataFriendsTable;

/**
 *  清除某一类型用户数据
 *
 *  @param type USERTYPE_EXPERT,USERTYPE_USER
 *
 *  @return bool
 */

-(BOOL)deleteFromFriendsWithType:(NSString *)type;

#pragma mark - 好友申请

@end
