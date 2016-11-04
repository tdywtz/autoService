//
//  CZWAFHttpRequest.m
//  autoService
//
//  Created by bangong on 15/12/31.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWAFHttpRequest.h"
#import "AFNetworking.h"
#import <netinet/in.h>

@implementation CZWAFHttpRequest

+ (AFHTTPSessionManager *)sessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",@"text/plain",
                                                         @"text/html",@"application/x-javascript",@"text/javascript", nil];
    [manager.requestSerializer setTimeoutInterval:10];
    return manager;
}
/**
 *  检测网络是否可用
 */
+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        // printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

/**
 *  上传单单张图片
 */
+ (NSURLSessionDataTask *)POSTImage:(UIImage *)image
                                url:(NSString *)URLString
                           fileName:(NSString *)name
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    
    return  [[self sessionManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [formData appendPartWithFileData:data name:@"" fileName:name mimeType:@"image/jpg/file"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure (error);
    }];
}

//GET方法
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{

   //  NSLog(@"%@",URLString);
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /**
     默认的缓存策略， 如果缓存不存在，直接从服务端获取。
     如果缓存存在，会根据response中的Cache-Control字段判断下一步操作，
     如: Cache-Control字段为must-revalidata, 则询问服务端该数据是否有更新，
     无更新的话直接返回给用户缓存数据，若已更新，则请求服务端.
     */
    NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;
   //取本地缓存
    if (![self connectedToNetwork]) {
       
        policy =  NSURLRequestReturnCacheDataElseLoad;
    }
    return [self GET:URLString CachePolicy:policy success:success failure:failure];
}

/**附带请求策略GET*/
+(NSURLSessionDataTask *)GET:(NSString *)URLString
                 CachePolicy:(NSURLRequestCachePolicy)CachePolic
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [self sessionManager];
    manager.requestSerializer.cachePolicy = CachePolic;

    return [manager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        // NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//POST方法
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id  responseObject))success
                       failure:(void (^)(NSError *error))failure{
   
    return  [[self sessionManager] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
     //  NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

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
                       failure:(void (^)(NSError *  error))failure{
    
    NSURLSessionDataTask *task = [[self sessionManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0;i < images.count ; i++) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *name = [NSString stringWithFormat:@"%d",i];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,i];
            NSData *date = UIImageJPEGRepresentation(images[i], 1);
            [formData appendPartWithFileData:date name:name fileName:fileName mimeType:@"image/jpg/file"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    return task;
}

//用户对专家评价
+(void)requestwithUid:(NSString *)uid
                 cpid:(NSString *)cpid
                score:(NSString *)score
             username:(NSString *)username
              content:(NSString *)content
                  eid:(NSString *)eid
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:user_evaluate,uid,cpid,score,username,content,eid];
    
    [CZWAFHttpRequest GET:url success:success failure:failure];

}

/**
 *  用户对厂家评价
 *
 *  @param parameters 数据
 *  @param success    block
 *  @param failure    block
 */
+(void)requestCactoryEvaluate:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    
    [CZWAFHttpRequest POST:user_fceval parameters:parameters success:success failure:failure];
  
}

//获取申诉详情底部申诉状态
+(void)requestAPPealStateWithUid:(NSString *)uid
                            type:(NSString *)type
                            cpid:(NSString *)cpid
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:auto_appealState,uid,type,cpid];

    [CZWAFHttpRequest GET:url CachePolicy:NSURLRequestUseProtocolCachePolicy success:success failure:failure];
}

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
                        failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:auto_adviceList,uid,type,cpid,eid];
    [CZWAFHttpRequest GET:url success:success failure:failure];
}

//获取用户信息
+(void)requestInfoWithId:(NSString *)userId
                    type:(CCUserType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure{
    
    NSString *urlSting;
    if (type == CCUserType_User) {
       urlSting = [NSString stringWithFormat:user_information,userId];
    }else{
       urlSting = [NSString stringWithFormat:expert_information,userId];
    }
    
    [CZWAFHttpRequest GET:urlSting success:success failure:failure];
}
//上传头像
+(void)requestUpdataIconImage:(UIImage *)image
                   parameters:(NSDictionary *)parameters
                         type:(CCUserType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    if (type == CCUserType_User) {
        url = user_uploadAvatar;
    }else{
        url = expert_uploadAvatar;
    }
    [CZWAFHttpRequest POSTImage:image url:url fileName:@"touxiang" parameters:parameters success:success failure:failure];
}

/*
 查看专家信息
 专家协助历史列表
 */
+(void)requestHelpListForInfoWithEid:(NSString *)eid
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:expert_e_CompleteOrder,eid];
    [CZWAFHttpRequest GET:url success:success failure:failure];
}


//获取专家、用户回复列表
+(void)requestReplyListWithUid:(NSString *)uid
                          type:(NSString *)type
                          page:(NSInteger)page
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
   
    NSString *url = [NSString stringWithFormat:auto_centerAnswer,uid,type,page];
  
    [CZWAFHttpRequest GET:url success:success failure:failure];}

//点击查看回复后回传状态
+(void)requestShowReplyWithId:(NSString *)replyId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:auto_ShowReply,replyId];
    [CZWAFHttpRequest GET:url success:success failure:failure];
}
//清空回复列表
+(void)requestEmptyReplyWithUid:(NSString *)uid
                           type:(NSString *)type
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:auto_emptyreply,uid,type];
    [CZWAFHttpRequest GET:url success:success failure:failure];
}

//用户-我-申诉状态(我的申诉)
+(void)requestMyAppealStateWithUid:(NSString *)uid
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:user_appealStateList,uid];
   
    [CZWAFHttpRequest GET:url success:success failure:failure];
}

//申诉列表
+(void)requestAppealListWithType:(NSString *)type
                            step:(NSString *)step
                             cid:(NSString *)cid
                             sid:(NSString *)sid
                           count:(NSInteger )count
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:auto_appealList,type,step,cid,sid,count];
    [CZWAFHttpRequest GET:url success:success failure:failure];}

//获取身份列表
+(void)requestProvinceSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{

     [CZWAFHttpRequest GET:auto_province success:success failure:failure];
}

//获取市
+(void)requestCityWithPid:(NSString *)pid
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:auto_city,pid];
    [CZWAFHttpRequest GET:url success:success failure:failure];
}

//获取品牌
+(void)requestBrandSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
     [CZWAFHttpRequest GET:auto_car_brand success:success failure:failure];
}

/**
 *  获取车系
 */
+(void)requestSeriesWithBrandId:(NSString *)brandId
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    
    NSString *urlString = [NSString stringWithFormat:auto_car_series,brandId];
   [CZWAFHttpRequest GET:urlString success:success failure:failure];
}

//采纳此专家建议
+(void)requesSelectExpertHelpWithUid:(NSString *)uid
                                cpid:(NSString *)cpid
                                 eid:(NSString *)eid
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:user_selectExpertHelp,uid,cpid,eid];
  
    [CZWAFHttpRequest GET:url success:success failure:failure];
}

//厂家解决是否满意
+(void)requestFacsolvedNotWithUid:(NSString *)uid
                             cpid:(NSString *)cpid
                            state:(NSString *)state
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:user_facsolvedNot,uid,cpid,state];
    [CZWAFHttpRequest GET:url success:success failure:failure];
}


   
//登录
+(void)loginWithParameters:(NSDictionary *)parameters
                      type:(CCUserType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    if (type == CCUserType_User) {
        url = user_login;
    }else if (type == CCUserType_Expert){
        url = expert_login;
    }
    [CZWAFHttpRequest POST:url parameters:parameters success:success failure:failure];
}
//注册
+(void)registerWithParameters:(NSDictionary *)parameters
                         type:(CCUserType)type
                       images:(NSArray *)images
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    if (type == CCUserType_User) {
        url = user_register;
    }else if (type == CCUserType_Expert){
        url = expert_register;
    }
    
    [CZWAFHttpRequest POST:url parameters:parameters success:success failure:failure];
}

@end
