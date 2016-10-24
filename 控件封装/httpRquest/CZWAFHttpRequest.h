//
//  CZWAFHttpRequest.h
//  autoService
//
//  Created by bangong on 15/12/31.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CachePolicy.h"

/**数据请求类*/
@interface CZWAFHttpRequest : NSObject

/**检测网络是否可用*/
+(BOOL) connectedToNetwork;

/**上传单单张图片*/
+ (NSURLSessionDataTask *)POSTImage:(UIImage *)image
                                url:(NSString *)URLString
                           fileName:(NSString *)name
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;

/**GET数据*/
+(NSURLSessionDataTask *)GET:(NSString *)URLString
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**附带请求策略GET*/
+(NSURLSessionDataTask *)GET:(NSString *)URLString
                 CachePolicy:(NSURLRequestCachePolicy)CachePolic
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**POST数据*/
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id  responseObject))success
                       failure:(void (^)(NSError *error))failure;


/**
 *  批量上传图片
 *
 *  @param URLString  网址
 *  @param parameters 数据字典
 *  @param images     图片数组
 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                        images:(NSArray <__kindof UIImage *> *)images
                       success:(void (^)(id  responseObject))success
                       failure:(void (^)(NSError *  error))failure;
/**
 *  用户对专家评价
 *
 *  @param uid      用户id
 *  @param cpid     申诉id
 *  @param score    评分数
 *  @param username 用户名
 *  @param content  评价内容
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)requestwithUid:(NSString *)uid
                 cpid:(NSString *)cpid
                score:(NSString *)score
             username:(NSString *)username
              content:(NSString *)content
                  eid:(NSString *)eid
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

/**
 *  用户对厂家评价
 *
 *  @param parameters 数据
 *  @param success    block
 *  @param failure    block
 */
+(void)requestCactoryEvaluate:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
/**
 *  获取申诉详情底部申诉状态
 *
 *  @param uid     用户id
 *  @param type    用户类型
 *  @param cpid    申诉id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestAPPealStateWithUid:(NSString *)uid
                            type:(NSString *)type
                            cpid:(NSString *)cpid
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  获取专家建议列表
 *
 *  @param uid     当前用户id
 *  @param type    用户类型(USERTYPE_EXPERT,USERTYPE_USER)
 *  @param cpid    申诉id
 *  @param eid     专家id
 *  @param success block
 *  @param failure block
 */
+(void)requestAdviceListWithUid:(NSString *)uid
                           type:(NSString *)type
                           cpid:(NSString *)cpid
                            eid:(NSString *)eid
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  获取用户信息
 *
 *  @param userId  用户id
 *  @param type    用户类型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestInfoWithId:(NSString *)userId
                    type:(CCUserType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/**
 *  上传头像
 *
 *  @param image      上传的图片
 *  @param parameters 附加数据
 *  @param type       用户类型枚举
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+(void)requestUpdataIconImage:(UIImage *)image
                   parameters:(NSDictionary *)parameters
                         type:(CCUserType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
/**
 *   查看专家信息、专家协助历史列表
 *
 *  @param eid     专家id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestHelpListForInfoWithEid:(NSString *)eid
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;


/**
 *  获取专家、用户回复列表
 *
 *  @param uid     用户id
 *  @param type    用户类型
 *  @param page    翻页页码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestReplyListWithUid:(NSString *)uid
                          type:(NSString *)type
                          page:(NSInteger)page
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  点击查看回复后回传状态
 *
 *  @param replyId 回复内容id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestShowReplyWithId:(NSString *)replyId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  清空回复列表
 *
 *  @param uid     用户id
 *  @param type    用户类型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestEmptyReplyWithUid:(NSString *)uid
                           type:(NSString *)type
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
/**
 *  用户-我-申诉状态(我的申诉)
 *
 *  @param uid     用户id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestMyAppealStateWithUid:(NSString *)uid
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  主界面申诉列表
 *
 *  @param type    用户类型
 *  @param step    申诉进度状态
 *  @param cid     城市id
 *  @param sid     车系id
 *  @param count   获取数量
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestAppealListWithType:(NSString *)type
                            step:(NSString *)step
                             cid:(NSString *)cid
                             sid:(NSString *)sid
                           count:(NSInteger )count
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  获取省份列表
 */
+(void)requestProvinceSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  获取市
 *
 *  @param pid     省份id
 */
+(void)requestCityWithPid:(NSString *)pid
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  获取品牌
 */
+(void)requestBrandSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

/**
 *  获取车系
 *
 *  @param brandId 品牌id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)requestSeriesWithBrandId:(NSString *)brandId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
/*
 申诉状态
 可处理步骤
 */
/**
 *  采纳此专家建议
 *
 *  @param uid     用户id
 *  @param cpid    申诉id
 *  @param eid     专家id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requesSelectExpertHelpWithUid:(NSString *)uid
                                cpid:(NSString *)cpid
                                 eid:(NSString *)eid
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;

/**
 *  厂家解决是否满意
 *
 *  @param uid     用户id
 *  @param cpid    申诉id
 *  @param state   。。。。申诉状态
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)requestFacsolvedNotWithUid:(NSString *)uid
                            cpid:(NSString *)cpid
                            state:(NSString *)state
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;


/**
 *  登录
 *
 *  @param parameters 登录数据
 *  @param type       用户类型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+(void)loginWithParameters:(NSDictionary *)parameters
                      type:(CCUserType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

/**
 *  注册
 *
 *  @param parameters 注册数据字典
 *  @param type       用户类型
 *  @param images     上传图片数组（可以为空）
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+(void)registerWithParameters:(NSDictionary *)parameters
                         type:(CCUserType)type
                       images:(NSArray *)images
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
@end
