//
//  NSAttributedString+CZWAttributedString.m
//  autoService
//
//  Created by bangong on 15/12/14.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "NSAttributedString+CZWAttributedString.h"

@implementation NSAttributedString (CZWAttributedString)
//计算属性化字符串size
+(CGSize)calculateAttributedString:(NSAttributedString *)attibuted Size:(CGSize)size{
    return [attibuted boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine context:nil].size;
}

//富文本
+(NSAttributedString *)expertName:(NSString *)name{
    if (!name) name = @"";
    name = [NSString stringWithFormat:@"%@ ",name];
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:name];
    //[matt addAttribute:NSFontAttributeName value:colorNavigationBarColor range:NSMakeRange(0, matt.length)];
    
    NSTextAttachment *chment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"expertV@2x"];
    chment.image = image;
    chment.bounds = CGRectMake(0, -5, image.size.width, image.size.height);
    NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:chment];
    
    [matt insertAttributedString:att atIndex:matt.length];
    return matt;
}


#pragma mark - 属性化字符串
+(NSAttributedString *)numberColorAttributeSting:(NSString *)str color:(UIColor *)color{
    if (!str) str = @"";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    // [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:B] range:NSMakeRange(0, att.length)];
    for (int i = 0; i < str.length; i ++) {
        unichar C = [str characterAtIndex:i];
        if (isnumber(C)) {
            [att addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i, 1)];
        }
    }
    return att;
}


@end
