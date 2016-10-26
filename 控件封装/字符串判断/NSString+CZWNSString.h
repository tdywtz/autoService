//
//  NSString+CZWNSString.h
//  autoService
//
//  Created by bangong on 15/12/14.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CZWNSString)

//计算字符串size
+(CGSize)calculateTextSizeWithText:(NSString *)text Font:(CGFloat)font Size:(CGSize)size;
-(CGSize)calculateTextSizeWithFont:(UIFont *)font Size:(CGSize)size;

@end
