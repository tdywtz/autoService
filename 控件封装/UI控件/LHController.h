//
//  LHController.h
//  auto
//
//  Created by bangong on 15/7/3.
//  Copyright (c) 2015年 车质网. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LHController : NSObject

+(CGFloat)setFont;//设置字体
/**UITextField */
+(UITextField *)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder Font:(CGFloat)font  Delegate:(id)delegate;

//**创建圆心选择按钮*/
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action;
/** 黄色背景圆角按钮*/
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Font:(CGFloat)font Text:(NSString *)text;

/**自定义按钮*/
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Text:(NSString *)text;

/**创建Label*/
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Bold:(BOOL)bold TextColor:(UIColor *)color Text:(NSString*)text;
/** 创建图片控制器*/
+(UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString *)name;

//**投诉item*/
+(UIBarButtonItem *)createComplainItemWthFrame:(CGRect)frame Target:(id)target Action:(SEL)action;

//背景线
+(UIView *)createBackLineWithFrame:(CGRect)frame;

/**自动布控件*/
+(UILabel *)createLabelFont:(CGFloat)font Text:(NSString *)text Number:(NSInteger)number TextColor:(UIColor *)color;

/**验证码生成*/
+ (NSString *)onTapToGenerateCode:(UIView *)testLabel;
@end
