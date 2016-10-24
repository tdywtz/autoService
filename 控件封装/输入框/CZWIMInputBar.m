//
//  CZWIMInputBar.m
//  autoService
//
//  Created by bangong on 16/1/4.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWIMInputBar.h"

@interface CZWIMInputBar ()<UITextViewDelegate>
{
    CGRect _startFrame;
}
@end

@implementation CZWIMInputBar
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height = 36+10;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1.0];
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin);
        self.opaque = YES;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self addSubview:line];
        
        
        _startFrame = frame;
        _allowsSendVoice = NO;
        _allowsSendFace = NO;
        _allowsSendMore = NO;
        self.hideKeyboardWhenSend = YES;
        
        [self constructUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(void)keyboardWillShow:(NSNotification *)notification{
   
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect frame = self.frame;
    frame.origin.y = HEIGHT-height-self.frame.size.height;
    
    self.frame = frame;
  //改变高度回调
    
    [self changeFrame:frame];
    
   
}

-(void)keyboardWillHide:(NSNotification *)notification{
    self.hidden = YES;
    _textView.text = @"";
    self.frame = _startFrame;
    //改变高度回调
     [self changeFrame:_startFrame];
}

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (hidden) {
        [_textView resignFirstResponder];
    }else{
        [_textView becomeFirstResponder];
    }
}

- (void)updateUI{

}

- (void)constructUI{
    self.textView = [[CZWIMInputTextView alloc] initWithFrame:CGRectMake(2, 5, self.frame.size.width-4, self.frame.size.height-10)];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    self.textView.placeHolder = @"咨询";
    self.textView.delegate = self;
    self.textView.scrollEnabled = YES;
    self.textView.layer.cornerRadius = 5;
    [self.textView.layer setCornerRadius:5.];
    [self.textView.layer setBorderWidth:0.5];
    [self.textView.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.textView.layer setShadowRadius:4.];
    [self.textView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [self.textView.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor];
    [self addSubview:self.textView];
}

+ (CGFloat)maxLines {
    
    return 4;
}

- (CGFloat)boradHeight
{
    if (!self.expand)
        return 0.;
    if (self.type == CZWIMInputBarTypeText)
        return self.keyboradHeight;
    return 226.f;
}

-(void)changeFrame:(CGRect)frame{
    if ([self.delegate respondsToSelector:@selector(CZWIMInputBarFrameChangeValue:)]) {
        [self.delegate CZWIMInputBarFrameChangeValue:frame];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(CZWIMInputBarTextViewWillBeginEditing:)]) {
         [self.delegate CZWIMInputBarTextViewWillBeginEditing:self.textView];
    }
   
//    
//    self.faceBtn.selected = NO;
//    self.moreBtn.selected = NO;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(CZWIMInputBarTextViewDidBeginEditing:)]) {
         [self.delegate CZWIMInputBarTextViewDidBeginEditing:self.textView];
    }
   
    self.expand = YES;
    self.type = CZWIMInputBarTypeText;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.contentSize.height < 90) {
       // self.bounds = CGRectMake(0, 0, self.frame.size.width, textView.contentSize.height);
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y-(textView.contentSize.height-self.frame.size.height+10);
        frame.size.height = textView.contentSize.height+10;
        self.frame = frame;
        if (frame.size.height != self.frame.size.height) {
            //改变高度回调
            [self changeFrame:frame];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(CZWIMInputBarTextViewDidEndEditing:)]) {
        [self.delegate CZWIMInputBarTextViewDidEndEditing:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"])
    {
        if ([self.delegate respondsToSelector:@selector(CZWIMInputBarDidSendTextAction:)]) {
            [self.delegate CZWIMInputBarDidSendTextAction:textView.text];
        }

        
        if (self.hideKeyboardWhenSend)
        {
            [_textView resignFirstResponder];
            self.expand = NO;
        }
        return NO;
    }
    
    if ([text isEqualToString:@""] && range.length > 0)
    {
//        NSString* text = [[CZWIMEmotionManager shared] handleDel:self.textView.text range:range];
//        if (!text)
//        {
//            return YES;
//        }
//        else
//        {
//            textView.text = text;
//            return NO;
//        }
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
