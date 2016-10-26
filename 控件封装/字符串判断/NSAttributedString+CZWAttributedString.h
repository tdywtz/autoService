//
//  NSAttributedString+CZWAttributedString.h
//  autoService
//
//  Created by bangong on 15/12/14.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSAttributedString (CZWAttributedString)

//计算属性化字符串size
+(CGSize)calculateAttributedString:(NSAttributedString *)attibuted Size:(CGSize)size;

//富文本
+ (NSAttributedString *)expertName:(NSString *)name;
//设置数字颜色
+(NSAttributedString *)numberColorAttributeSting:(NSString *)str color:(UIColor *)color;



@end
