//
//  NSString+CZWNSString.m
//  autoService
//
//  Created by bangong on 15/12/14.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "NSString+CZWNSString.h"

@implementation NSString (CZWNSString)
//计算字符串size
+(CGSize)calculateTextSizeWithText:(NSString *)text Font:(CGFloat)font Size:(CGSize)size{
    return   [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
}


-(CGSize)calculateTextSizeWithFont:(UIFont *)font Size:(CGSize)size{
    return   [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}


@end
