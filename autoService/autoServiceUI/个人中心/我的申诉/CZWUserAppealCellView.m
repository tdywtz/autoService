
//
//  CZWUserAppealCellView.m
//  autoService
//
//  Created by bangong on 15/12/24.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserAppealCellView.h"
#import "CZWUserAppealToStateView.h"

@implementation CZWUserAppealCellView
{
    CGRect   lastRect;
}

-(void)setSteps:(NSArray *)steps andIndex:(NSInteger)index{
    _steps = steps;
    
    lastRect = CGRectZero;
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    for (int i = 0; i < _steps.count; i ++) {
        CZWUserAppealToStateViewState state;
        if (i < index-1) {
            state = CZWUserAppealToStateViewStatePass;
        }else if (i == index-1){
             state = CZWUserAppealToStateViewStatePass;
        }
        else{
            state = CZWUserAppealToStateViewStateFuture;
        }
        BOOL last = NO;
        if (i == _steps.count-1) {
            last = YES;
        }
        CZWUserAppealToStateView *view = [[CZWUserAppealToStateView alloc] initWithText:_steps[i] State:state last:last];
        CGRect frame  = view.frame;
        frame.origin.x = lastRect.origin.x+lastRect.size.width;
        frame.origin.y = lastRect.origin.y;
        if (frame.origin.x+frame.size.width > self.drawWidth) {
            frame.origin.x = 0;
            frame.origin.y = lastRect.origin.y+lastRect.size.height+5;
        }
        view.frame = frame;
        [self addSubview:view];
        
        lastRect = frame;
    }
    CGRect rect = self.frame;
    rect.size.height = lastRect.origin.y+lastRect.size.height;
    self.frame = rect;
    self.changeFrameHeight = lastRect.origin.y+lastRect.size.height;
}

@end
