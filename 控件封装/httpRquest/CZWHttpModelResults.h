//
//  CZWHttpModel.h
//  autoService
//
//  Created by bangong on 15/12/31.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZWAFHttpRequest.h"
#import "CZWAppealModel.h"
#import "CZWUserInfoUser.h"
#import "CZWUserInfoExpert.h"
#import "CZWReplyModel.h"

/**
 *  数据请求类--数据建模
 */
@interface CZWHttpModelResults : NSObject

/**
 *  主界面申诉列表
 *
 *  @param type    用户类型
 *  @param step    申诉状态
 *  @param cid     城市id
 *  @param sid     车系id
 *  @param count   获取数量
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestAppealModelsWithType:(NSString *)type
                            step:(NSString *)step
                             cid:(NSString *)cid
                             sid:(NSString *)sid
                           count:(NSInteger )count
                         success:(void (^)(NSArray *appealModels))success
                         failure:(void (^)(NSError *errot))failure;
/**
 *  获取指定用户申述列表
 *
 *  @param userId 用户id
 *  @param count  获取数量
 *  @param result 回调
 */
+(void)requestAppealModelsWithUserId:(NSString *)userId
                               count:(NSInteger)count
                              result:(void (^)(NSArray *appealModels))result;

/**
 *  获取指定专家协助列表
 *
 *  @param expertId 专家id
 *  @param state    协助状态
 *  @param count    获取数量
 *  @param result   回调
 */
+(void)requestHelpModelsWithExpertId:(NSString *)expertId
                               count:(NSInteger)count
                              result:(void (^)(NSArray *appealModels))result;


/**
 *  获取普通用户信息
 *
 *  @param userId 用户id
 *  @param result 回调
 */
+(void)requestUserInfoWithUserId:(NSString *)userId
                          result:(void (^)(CZWUserInfoUser *userInfo))result;


/**
 *  获取专家用户信息
 *
 *  @param expertId 专家id
 *  @param result   回调
 */
+(void)requestExpertInfoWithExpertId:(NSString *)expertId
                              result:(void (^)(CZWUserInfoExpert *userInfo))result;


/**
 *  好友列表
 *
 *  @param userId      当前用户id
 *  @param type        当前用户类型（2-专家；1-用户）
 *  @param friendsType 好友类型
 *  @param success     成功回调
 *  @param failure     失败回调 NSError
 */
+(void)requestFriendsListWithUserId:(NSString *)userId
                               type:(NSString *)type
                        friendsType:(NSString *)friendsType
                            success:(void (^)(NSArray<__kindof CZWChatUserInfo *> *infos))success
                            failure:(void (^)(NSError *errot))failure;

/**
 *  获取聊天用户信息
 *
 *  @param userId   融云id
 *  @param success 回调信息
 */
+(void)requestChatUserInfoWithUserId:(NSString *)userId
                             success:(void(^)(CZWChatUserInfo *userInfo))success;
@end
