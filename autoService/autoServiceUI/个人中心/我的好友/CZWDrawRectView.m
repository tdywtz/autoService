//
//  CZWDrawRectView.m
//  autoService
//
//  Created by bangong on 16/2/1.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWDrawRectView.h"
#import "CZWBasicColor.h"
@implementation CZWDrawRectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.curedrs = 3;
        self.lineColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
  
    [self drawCustomWithRect:rect];
   // [self drawRectangleWithRect:rect];
}

- (void)drawCustomWithRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *color = RGB_color(240, 240, 240, 1);
    CGContextSetFillColorWithColor(context,color.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, color.CGColor);//线框颜色

    float fw = rect.size.width-1;
    float fh = rect.size.height-1;
    CGContextMoveToPoint(context, 20, 1+10);
    CGContextAddLineToPoint(context, 30, 1);
    CGContextAddLineToPoint(context, 40, 10);
    CGContextAddArcToPoint(context, fw, 1+10, fw, fh, self.curedrs);
    CGContextAddArcToPoint(context, fw, fh, 1, fh, self.curedrs);
    CGContextAddArcToPoint(context, 1, fh, 1, 0, self.curedrs);
    CGContextAddArcToPoint(context, 1, 1+10, self.curedrs, 1+10, self.curedrs);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

/**
 *  画矩形
 *
 *  @param rect <#rect description#>
 */
-(void)drawRectangleWithRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *array =[CZWBasicColor rgbaArrayFromColor:self.lineColor];
    //画一条底部线
    CGContextSetRGBStrokeColor(context, [array[0] floatValue],  [array[1] floatValue], [array[2] floatValue], 1);//线条颜色
    float fw = rect.size.width-1;
    float fh = rect.size.height-1;
    CGContextMoveToPoint(context, self.curedrs, 1);
    CGContextAddArcToPoint(context, fw, 1, fw, fh, self.curedrs);
    CGContextAddArcToPoint(context, fw, fh, 1, fh, self.curedrs);
    CGContextAddArcToPoint(context, 1, fh, 1, 0, self.curedrs);
    CGContextAddArcToPoint(context, 1, 1, self.curedrs, 1, self.curedrs);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
}

-(void)setCuredrs:(CGFloat)curedrs{
    _curedrs = curedrs;
    [self setNeedsDisplay];
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

@end
