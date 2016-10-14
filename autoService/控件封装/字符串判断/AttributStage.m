//
//  AttributStage.m
//  autoService
//
//  Created by bangong on 16/3/14.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "AttributStage.h"

@implementation AttributStage
- (instancetype)init
{
    self = [super init];
    if (self) {
        _textColor = [UIColor blackColor];
        _textFont = [UIFont systemFontOfSize:15];
        
        _lineBreakMode = NSLineBreakByTruncatingTail;
        _lineSpacing = 4;
        _alignment = NSTextAlignmentJustified;
         //_hyphenationFactor = 8;
        _firstLineHeadIndent = _textFont.pointSize*2;
        _paragraphSpacing = _textFont.pointSize;
    }
    return self;
}

@end
