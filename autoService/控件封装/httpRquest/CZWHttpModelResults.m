//
//  CZWHttpModel.m
//  autoService
//
//  Created by bangong on 15/12/31.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWHttpModelResults.h"

@implementation CZWHttpModelResults

//主界面申诉列表
+(void)requestAppealModelsWithType:(NSString *)type
                            step:(NSString *)step
                             cid:(NSString *)cid
                             sid:(NSString *)sid
                           count:(NSInteger )count
                         success:(void (^)(NSArray *appealModels))success
                         failure:(void (^)(NSError *error))failure{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [CZWAFHttpRequest requestAppealListWithType:type step:step cid:cid sid:sid count:count success:^(id responseObject) {
     
        //如果返回数组长度为零直接return
        if ([responseObject count] == 0) return success(array);
        
        if ([responseObject firstObject][@"error"]) {
            //[CZWAlert alertDismiss:[responseObject firstObject][@"error"]];
            
        }else{
        
            for (NSDictionary *dict in responseObject) {
                CZWAppealModel *model = [[CZWAppealModel alloc] init];
                model.uid       = dict[@"uid"];
                model.cpid      = dict[@"cpid"];
                model.name      = dict[@"name"];
                model.headpic   = dict[@"headpic"];
                model.cname     = dict[@"cname"];
                model.brandname = dict[@"brandname"];
                model.seriesname = dict[@"seriesname"];
                model.modelname = dict[@"modelname"];
                model.steps     = dict[@"steps"];
                model.title     = dict[@"title"];
                model.content   = dict[@"content"];
                model.image     = dict[@"image"];
                model.date      = dict[@"date"];
                model.applynum  = dict[@"applynum"];
                
                [array addObject:model];
            }
        }
        success(array);
    } failure:^(NSError *error) {
        failure(error);
    
    }];
}

//获取指定用户申述列表
+(void)requestAppealModelsWithUserId:(NSString *)userId
                               count:(NSInteger)count
                              result:(void (^)(NSArray *appealModels))result{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:user_appealList,userId,count];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        if([responseObject count] == 0) return result(array);
        
        if ([responseObject firstObject][@"error"]) {
            [CZWAlert alertDismiss:[responseObject firstObject][@"error"]];
            
        }else{
            for (NSDictionary *dict in responseObject) {
                CZWAppealModel *model = [[CZWAppealModel alloc] init];
                model.uid       = dict[@"uid"];
                model.cpid      = dict[@"cpid"];
                model.name      = dict[@"name"];
                model.headpic   = dict[@"headpic"];
                model.cname     = dict[@"cname"];
                model.brandname = dict[@"brandname"];
                model.seriesname = dict[@"seriesname"];
                model.modelname = dict[@"modelname"];
                model.steps     = dict[@"steps"];
                model.title     = dict[@"title"];
                model.content   = dict[@"content"];
                model.image     = dict[@"image"];
                model.date      = dict[@"date"];
                model.applynum  = dict[@"applynum"];
                
                [array addObject:model];
            }
        }
        result(array);

    } failure:^(NSError *error) {
         result(array);
    }];
}

//获取指定专家协助列表
+(void)requestHelpModelsWithExpertId:(NSString *)expertId
                               count:(NSInteger)count
                              result:(void (^)(NSArray *appealModels))result{
   
    NSMutableArray *array = [[NSMutableArray alloc] init];

    NSString *url = [NSString stringWithFormat:expert_helpList,expertId,count];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        NSArray *dataArray = responseObject[@"rel"];
        for (NSDictionary *dict in dataArray) {
            CZWAppealModel *model = [[CZWAppealModel alloc] init];
            model.uid       = dict[@"uid"];
            model.cpid      = dict[@"cpid"];
            model.name      = dict[@"name"];
            model.headpic   = dict[@"headpic"];
            model.cname     = dict[@"cname"];
            model.brandname = dict[@"brandname"];
            model.seriesname = dict[@"seriesname"];
            model.modelname = dict[@"modelname"];
            model.steps     = dict[@"steps"];
            model.title     = dict[@"title"];
            model.content   = dict[@"advice"];
            model.image     = dict[@"image"];
            model.date      = dict[@"date"];
            model.applynum  = dict[@"applynum"];
            model.mobile    = dict[@"mobile"];
            model.show      = dict[@"show"];
            [array addObject:model];
            
        }
        result(array);

    } failure:^(NSError *error) {
         result(array);
    }];
}


//获取用户信息
+(void)requestUserInfoWithUserId:(NSString *)userId
                          result:(void (^)(CZWUserInfoUser *userInfo))result{
  
   
   [CZWAFHttpRequest requestInfoWithId:userId type:CCUserType_User success:^(id responseObject) {
       if ([responseObject count] > 0) {
   // NSLog(@"%@",responseObject);
           NSDictionary *dict = [responseObject firstObject];
            CZWUserInfoUser *userInfo = [[CZWUserInfoUser alloc] init];
            userInfo.uname          = dict[@"uname"];
            userInfo.rname          = dict[@"rname"];
            userInfo.sex            = dict[@"sex"];
            userInfo.birth          = dict[@"birth"];
            userInfo.email          = dict[@"email"];
            userInfo.mobile         = dict[@"mobile"];
            userInfo.phone          = dict[@"phone"];
            userInfo.qq             = dict[@"qq"];
            userInfo.brand          = dict[@"brand"];
            userInfo.brandName      = dict[@"brandName"];
            userInfo.series         = dict[@"series"];
            userInfo.seriesName     = dict[@"seriesName"];
            userInfo.model          = dict[@"model"];
            userInfo.modelName      = dict[@"modelName"];
            userInfo.img            = dict[@"img"];
            userInfo.engineNumber   = dict[@"engineNumber"];
            userInfo.carriageNumber = dict[@"carriageNumber"];
            userInfo.autosign       = dict[@"autosign"];
            userInfo.city           = dict[@"city"];
           
          return  result(userInfo);
       }
       
        return   result(nil);
       
       
   } failure:^(NSError *error) {
      return result(nil);
   }];
}

//获取专家用户信息
+(void)requestExpertInfoWithExpertId:(NSString *)expertId
                            result:(void (^)(CZWUserInfoExpert *userInfo))result{
    
    [CZWAFHttpRequest requestInfoWithId:expertId type:CCUserType_Expert success:^(id responseObject) {
       
        if ([responseObject count] > 0) {
            NSDictionary *dict  = [responseObject firstObject];
            CZWUserInfoExpert *info = [[CZWUserInfoExpert alloc] init];
            info.age            = dict[@"age"];
            info.cid            = dict[@"cid"];
            info.city           = dict[@"city"];
            info.company        = dict[@"company"];
            info.eid            = dict[@"eid"];
            info.email          = dict[@"email"];
            info.goodatarea     = dict[@"goodatarea"];
            info.headpic        = dict[@"headpic"];
            info.job            = dict[@"job"];
            info.mobile         = dict[@"mobile"];
            info.pid            = dict[@"pid"];
            info.pro            = dict[@"pro"];
            info.realname       = dict[@"realname"];
            info.sex            = dict[@"sex"];
            info.score          = dict[@"score"];
            info.complete_num   = dict[@"complete_num"];
           
            result(info);
        }else{
            result(nil);
        }
       
    } failure:^(NSError *error) {
        result(nil);
    }];
}

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
                            failure:(void (^)(NSError *errot))failure{
    NSDictionary *dict = @{@"uid":userId,@"utype":type,@"ftype":friendsType};
   [CZWAFHttpRequest POST:auto_friendsList parameters:dict success:^(id responseObject) {
       NSMutableArray *arr = [[NSMutableArray alloc] init];
       if (!responseObject || [[responseObject firstObject] allKeys].count == 0) {
           return success(arr);
       }
       for (NSDictionary *dict in responseObject) {
           
           CZWChatUserInfo *info = [[CZWChatUserInfo alloc] initWithDictrionary:dict];
           info.isfriend     = FriendTypeYes;
           [arr addObject:info];
       }
       success(arr);

   } failure:^(NSError *error) {
        failure(error);
   }];
}

/**
 *  获取聊天用户信息
 *
 *  @param userId   融云id
 *  @param userInfo 回调信息
 */
+(void)requestChatUserInfoWithUserId:(NSString *)userId
                             success:(void(^)(CZWChatUserInfo *userInfo))success{
    NSString *url = [NSString stringWithFormat:auto_infoByRYID,userId];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        if (!responseObject || [responseObject count]==0) {
            return success(nil);
        }
        CZWChatUserInfo *info = [[CZWChatUserInfo alloc] init];
        NSDictionary *dict = [responseObject firstObject];
        info.userName     = dict[@"name"];
        info.seviceId     = dict[@"uid"];
        info.type         = dict[@"type"];
        info.userId       = userId;
        info.area         = dict[@"city"];
        info.modelName    = dict[@"modelname"];
        info.iconUrl      = dict[@"headpic"];
        info.score        = dict[@"score"];
        info.complete_num = dict[@"complete_num"];
        return success(info);

    } failure:^(NSError *error) {
         return success(nil);
    }];
}
@end
