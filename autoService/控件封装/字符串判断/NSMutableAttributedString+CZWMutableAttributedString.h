//
//  NSMutableAttributedString+CZWMutableAttributedString.h
//  autoService
//
//  Created by bangong on 16/2/3.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributStage.h"

@interface NSMutableAttributedString (CZWMutableAttributedString)

//插入图片
-(NSMutableAttributedString *)insertImage:(UIImage *)image into:(NSInteger )index;

+(NSMutableAttributedString *)attributedStringWithStage:(AttributStage *)stage string:(NSString *)string;

//-(NSInteger)linesWith:(CGFloat)width;
@end
