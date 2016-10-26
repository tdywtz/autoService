//
//  LHCoreTextView.m
//  autoService
//
//  Created by bangong on 16/3/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHCoreTextView.h"
#import <CoreText/CoreText.h>

@implementation LHCoreTextView
{
    NSMutableAttributedString *att;
    CGFloat height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.text = @"";
    self.font = [UIFont systemFontOfSize:17];
    self.textColor = [UIColor orangeColor];
    self.numberOfLines = 0;
}
-(void)setText:(NSString *)text{
    
    _text = text;
   
    att = [[NSMutableAttributedString alloc] initWithString:_text];
    NSTextAttachment *achment = [[NSTextAttachment alloc] init];
    achment.image = [UIImage imageNamed:@"rootViewUser"];
    achment.bounds = CGRectMake(0, 0, self.font.pointSize, self.font.pointSize);

    [att addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, att.length)];
    [att addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, att.length)];
   [att insertAttributedString:[NSAttributedString attributedStringWithAttachment:achment] atIndex:0];
    //[att addAttribute:NSTextLayoutSectionOrientation value:@(NSTextLayoutOrientationVertical) range:NSMakeRange(1, 1)];
   // CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)att);
   height = [NSAttributedString calculateAttributedString:att Size:CGSizeMake(100, 100000)].height;
    
    NSTextStorage *stogage = [[NSTextStorage alloc] initWithString:@"天涯"];
//    NSTextContainer *cont = [[NSTextContainer alloc] initWithSize:CGSizeMake(60, 20)];
//
//    NSLayoutManager *mm = [[NSLayoutManager alloc] init];
//    [mm invalidateDisplayForCharacterRange:NSMakeRange(0, 2)];
//
//    [mm addTextContainer:cont];
//    [stogage addLayoutManager:mm];
    [att insertAttributedString:stogage atIndex:0];
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

//static inline CGSize CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(CTFramesetterRef framesetter, NSAttributedString *attributedString, CGSize size, NSUInteger numberOfLines) {
//    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedString length]);
//    CGSize constraints = CGSizeMake(size.width, MAXFLOAT);
//    
//    if (numberOfLines > 0) {
//        // If the line count of the label more than 1, limit the range to size to the number of lines that have been set
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, constraints.width, MAXFLOAT));
//        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//        CFArrayRef lines = CTFrameGetLines(frame);
//        
//        if (CFArrayGetCount(lines) > 0) {
//            NSInteger lastVisibleLineIndex = MIN((CFIndex)numberOfLines, CFArrayGetCount(lines)) - 1;
//            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
//            
//            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
//            rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
//        }
//        
//        CFRelease(frame);
//        CFRelease(path);
//    }
//    
//    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);
//    
//    return CGSizeMake(ceil(suggestedSize.width), ceil(suggestedSize.height));
//}

-(CGSize)intrinsicContentSize{
    self.backgroundColor = [UIColor redColor];
    return CGSizeMake(100, [NSAttributedString calculateAttributedString:att Size:CGSizeMake(100, CGFLOAT_MAX)].height );
}
-(void)sizeToFit{
    [super sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat width = CGRectGetWidth(self.frame);

    return CGSizeMake(width, 60);
}

-(void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
   
   // [att appendAttributedString:[NSAttributedString attributedStringWithAttachment:achment]];
    [att drawInRect:rect];
    
}
@end
