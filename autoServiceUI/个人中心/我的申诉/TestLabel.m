//
//  TestLabel.m
//  autoService
//
//  Created by bangong on 16/4/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TestLabel.h"

@implementation TestLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
//"反馈"关心的功能，即放出你需要的功能，比如你要放出copy，你就返回YES，否则返回NO；
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
   
    if (action ==@selector(copy:)){
        return YES;
    }
//    else if (action ==@selector(paste:)){
//        return NO;
//    }
//    else if (action ==@selector(cut:)){
//        return NO;
//    }
//    else if(action ==@selector(select:)){
//        return YES;
//    }
//    else if (action ==@selector(delete:)){
//        return NO;
//    }
    return NO;
}
//OK，开放控件的剪贴板功能已经放出，剩下的就是实现了
//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler{
    self.userInteractionEnabled =YES;  //用户交互的总开关
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
   // touch.numberOfTapsRequired =1;
 
}
//响应点击事件
-(void)handleTap:(UIGestureRecognizer*) recognizer{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}
//OK，此处已经可以点击出COPY菜单了，下面就是对你copy和paste的实现了
//针对于copy的实现
-(void)copy:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}


//- (void)paste:(id)sender{
//    
//    self.textAlignment = UITextAlignmentRight;
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    self.text = [NSString stringWithFormat:@"粘贴内容：%@",pboard.string];
//    NSLog(@"pboard.string : %@",pboard.string);
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
