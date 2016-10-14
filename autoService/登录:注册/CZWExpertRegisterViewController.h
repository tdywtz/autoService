//
//  CZWExpertRegisterViewController.h
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
#import "CZWShowImageView.h"
/**
 *  注册成功block回调对象
 *
 *  @param name     用户名
 *  @param password 密码
 */
typedef void(^success)(NSString *name, NSString *password);
/**
 *  注册专家
 */
@interface CZWExpertRegisterViewController : CZWBasicViewController
{
    CZWTextField *_userName;
    CZWTextField *_password;
    CZWTextField *_repeatedPassword;
    CZWTextField *_trueName;
    CZWTextField *_cardID;//身份证
    CZWShowImageView *cardIDImageView;//身份证正面照片
    CZWShowImageView *cardBackIDImageView;//身份证反面照片
    CZWTextField *_phoneNumber;
    CZWTextField *_area;//城市
    CZWTextField *_eamil;
    CZWTextField *_company;//公司
    CZWTextField *_professional;//职业
    CZWTextField *_technologyGroup;//技术组别
    CZWTextField *_certificate;//证明材料
    CZWShowImageView *proveImageView;//证明材料图片
    CZWIMInputTextView *_beGoodAt;//擅长

    NSString *provinceId;
    NSString *cityId;

}

@property (nonatomic,copy) success block;
/**
 *  注册成功回调
 *
 *  @param block block description
 */
-(void)success:(success)block;
@end

