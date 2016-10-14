//
//  CZWUserInfo.h
//  autoService
//
//  Created by bangong on 16/1/4.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户模型
 */
@interface CZWUserInfoUser : NSObject
/**
 *  用户名
 */
@property (nonatomic,copy) NSString *uname;
/**
 *  性别
 */
@property (nonatomic,copy) NSString *sex;
/**
 *  姓名
 */
@property (nonatomic,copy) NSString *rname;
/**
 *  生日
 */
@property (nonatomic,copy) NSString *birth;
/**
 *  邮箱
 */
@property (nonatomic,copy) NSString *email;
/**
 *  手机号码
 */
@property (nonatomic,copy) NSString *mobile;
/**
 *  座机号
 */
@property (nonatomic,copy) NSString *phone;
/**
 *  QQ
 */
@property (nonatomic,copy) NSString *qq;
/**
 *  车品牌id
 */
@property (nonatomic,copy) NSString *brand;
/**
 *  车品牌名
 */
@property (nonatomic,copy) NSString *brandName;
/**
 *  车系id
 */
@property (nonatomic,copy) NSString *series;
/**
 *  车系名
 */
@property (nonatomic,copy) NSString *seriesName;
/**
 *  车型id
 */
@property (nonatomic,copy) NSString *model;
/**
 *  车型名
 */
@property (nonatomic,copy) NSString *modelName;
/**
 *  头像链接
 */
@property (nonatomic,copy) NSString *img;
/**
 *  <#Description#>
 */
@property (nonatomic,copy) NSString *engineNumber;
@property (nonatomic,copy) NSString *carriageNumber;
@property (nonatomic,copy) NSString *autosign;
/**
 *  城市
 */
@property (nonatomic,copy) NSString *city;

@end
