//
//  CZWTextField.m
//  autoService
//
//  Created by bangong on 16/1/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWTextField.h"

@implementation CZWTextField


- (void)setPlaceHolder:(NSString *)placeHolder {
    if([placeHolder isEqualToString:_placeHoldertext]) {
        return;
    }
    
    _placeHoldertext = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    if([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }
    
    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

#pragma mark - Text view overrides

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
    
}


//- (void)setContentInset:(UIEdgeInsets)contentInset {
//    [super setContentInset:contentInset];
//    [self setNeedsDisplay];
//}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}


#pragma mark - Life cycle

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
    
    _placeHolderTextColor = [UIColor lightGrayColor];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.font = [UIFont systemFontOfSize:15.0f];
    self.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
        [self setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    return self;
}

- (void)dealloc {
    _placeHoldertext = nil;
    _placeHolderTextColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
    
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if([self.text length] == 0 && self.placeHoldertext) {
        CGRect placeHolderRect = CGRectMake(self.leftView.bounds.size.width,
                                            0.0f,
                                            rect.size.width-self.leftView.bounds.size.width-self.rightView.bounds.size.width,
                                            rect.size.height);
        CGSize size = [self.placeHoldertext boundingRectWithSize:CGSizeMake(placeHolderRect.size.width, placeHolderRect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        placeHolderRect.origin.y = (rect.size.height-size.height)/2;
        placeHolderRect.size.height = size.height;
        
        [self.placeHolderTextColor set];
    
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
        [self.placeHoldertext drawInRect:placeHolderRect
                      withAttributes:@{ NSFontAttributeName : self.font,
                                        NSForegroundColorAttributeName : self.placeHolderTextColor,
                                        NSParagraphStyleAttributeName : paragraphStyle }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
