//
//  CZWBasicColor.h
//  autoService
//
//  Created by bangong on 15/11/26.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

// Color Scheme Creation Enum
typedef enum {
    ColorSchemeAnalagous = 0,
    ColorSchemeMonochromatic,
    ColorSchemeTriad,
    ColorSchemeComplementary
}ColorScheme;

@interface CZWBasicColor : NSObject

// Color Methods
+(UIColor *)colorFromHex:(NSString *)hexString;
+(UIColor *)colorFromHex:(NSString *)hexString andAlpa:(CGFloat)aAlpa;
+(NSString *)hexFromColor:(UIColor *)color;
+(NSArray *)rgbaArrayFromColor:(UIColor *)color;
+(NSArray *)hsbaArrayFromColor:(UIColor *)color;

// Generate Color Scheme
+(NSArray *)generateColorSchemeFromColor:(UIColor *)color ofType:(ColorScheme)type;

@end
