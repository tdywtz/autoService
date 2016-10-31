//
//  LHController.m
//  auto
//
//  Created by bangong on 15/7/3.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "LHController.h"

@implementation LHController

+(CGFloat)setFont{

    return 17;
}

+(UITextField *)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder Font:(CGFloat)font Delegate:(id)delegate{

    
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.placeholder = placeholder;
    field.font = [UIFont systemFontOfSize:font];
    //清除按钮
    field.clearButtonMode = YES;
    //关闭首字母大写
    field.autocapitalizationType=NO;
    //键盘类型
    field.keyboardType=UIKeyboardTypeEmailAddress;
    //编辑状态下一直存在
    field.rightViewMode=UITextFieldViewModeWhileEditing;
    field.delegate = delegate;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.textColor = colorBlack;
    return field;
}


#pragma mark - 创建圆心选择按钮
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:@"circlekong.jpg"] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"circleshi.jpg"] forState:UIControlStateSelected];
   // [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGPoint point = CGPointMake(btn.center.x, btn.center.y);
    btn.frame = CGRectMake(0, 0, frame.size.height/1.7, frame.size.height/1.7);
    btn.center = point;
   
//    //设置圆角
//    btn.layer.cornerRadius = 2;
//    btn.layer.masksToBounds = YES;
//    
    return btn;
}

#pragma mark - 黄色背景圆角按钮
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Font:(CGFloat)font Text:(NSString *)text{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
   // btn.backgroundColor = [UIColor colorWithRed:254/255.0 green:153/255.0 blue:23/255.0 alpha:1];
    btn.backgroundColor = colorNavigationBarColor;
    btn.layer.cornerRadius = 3;
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    btn.layer.masksToBounds = YES;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - 自定义按钮
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Text:(NSString *)text{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn setTitleColor:colorBlack forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Bold:(BOOL)bold TextColor:(UIColor *)color Text:(NSString*)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    if (color) {
        label.textColor = color;
    }
    if (bold == YES) {
        label.font = [UIFont boldSystemFontOfSize:font];
    }
    label.numberOfLines = 0;
    return label;
}

#define mark - 创建图片控制器
+(UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString *)name{
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:frame];
    [iamgeView setContentMode:UIViewContentModeScaleAspectFit];
    iamgeView.image = [UIImage imageNamed:name];
    return iamgeView;
}


//我要投诉按钮
+(UIBarButtonItem *)createComplainItemWthFrame:(CGRect)frame Target:(id)target Action:(SEL)action{
    UIButton *btn = [self createButtnFram:frame Target:target Action:action Text:@"我要投诉"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 16, 14)];
    imageView.image = [UIImage imageNamed:@"complain_complain"];
    [btn addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

//背景线
+(UIView *)createBackLineWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = RGB_color(238, 238, 238, 1);
    return view;
}


/*
 自动布控件
 */
+(UILabel *)createLabelFont:(CGFloat)font Text:(NSString *)text Number:(NSInteger)number TextColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color?color:[UIColor blackColor];
    label.numberOfLines = number;
    label.text = text;
    return label;
}

#pragma mark - 验证码生成
+ (NSString *)onTapToGenerateCode:(UIView *)testLabel{
    for (UIView *view in testLabel.subviews) {
        [view removeFromSuperview];
    }
    // @{
    // @name 生成背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    // NSLog(@"%f=%f=%f",red,green,blue);
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [testLabel setBackgroundColor:color];
    
    const int count = 4;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
        if (j >= '0' && j <= '0'+9) {
            data[x] = (char)j;
        }else{
            --x;
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data
                                              length:count encoding:NSUTF8StringEncoding];
    // self.code = text;
    // @} end 生成文字
    
    CGSize cSize = CGSizeMake(10.0, 17.0);
    int width = testLabel.frame.size.width / text.length - cSize.width;
    int gao = testLabel.frame.size.height - cSize.height;
    // CGPoint point;
    float pX, pY;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0, count = (int)text.length; i < count; i++) {
        pX = arc4random() % width + testLabel.frame.size.width / text.length * i - 1;
        //pX = testLabel.frame.size.width/5 * i;
        //  pY = arc4random() % gao-5;
        // point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, 0,
                                                       testLabel.frame.size.width / 4,
                                                       testLabel.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        [testLabel addSubview:tempLabel];
        [str appendFormat:@"%C",c];
    }
    
    return  str;
}

@end
