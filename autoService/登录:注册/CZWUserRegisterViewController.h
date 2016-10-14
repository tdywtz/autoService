//
//  CZWUserRegisterViewController.h
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
/**
 *  注册成功block回调对象
 *
 *  @param name     用户名
 *  @param password 密码
 */
typedef void(^success)(NSString *name, NSString *password);
/**
 *  注册--用户
 */
@interface CZWUserRegisterViewController : CZWBasicViewController

@property (nonatomic,copy) success block;
/**
 *  注册成功回调
 *
 *  @param block <#block description#>
 */
-(void)success:(success)block;

@end
