//
//  CZWUserLoginViewController.h
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
/**
 *  登录--用户
 */
@interface CZWUserLoginViewController : CZWBasicViewController
/**
 *  用户名输入框
 */
@property (nonatomic,strong) UITextField *userNameTextField;
/**
 *  密码输入框
 */
@property (nonatomic,strong) UITextField *userPasswordTextField;

/**
 *  设置提交按钮是否可点击
 *
 *  @param b <#b description#>
 */
-(void)setButtonEnable:(BOOL)b;
@end
