//
//  RCUserInfo+CZWUserInfo.h
//  autoService
//
//  Created by bangong on 15/12/29.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCUserInfo (CZWUserInfo)

@property(nonatomic, strong) NSString *userId;
/** 用户名*/
@property(nonatomic, strong) NSString *name;
/** 头像URL*/
@property(nonatomic, strong) NSString *portraitUri;
/** phone*/
@property(nonatomic, strong) NSString *phone;
/** addressInfo*/
@property(nonatomic, strong) NSString *addressInfo;
/** realName*/
@property(nonatomic, strong) NSString *realName;

- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait phone:(NSString *)phone addressInfo:(NSString *)addressInfo realName:(NSString *)realName;
@end
