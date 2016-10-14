//
//  CZWUserAppealToStateView.m
//  autoService
//
//  Created by bangong on 15/12/24.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserAppealToStateView.h"

@implementation CZWUserAppealToStateView
- (instancetype)initWithText:(NSString *)text State:(CZWUserAppealToStateViewState)state last:(BOOL)last;
{
    self = [super init];
    if (self) {
        CGSize sise = [NSString calculateTextSizeWithText:text   Font:PT_FROM_PX(19) Size:CGSizeMake(300, 20)];
        CGRect frame = CGRectMake(0, 0, sise.width+10, 20);
        
        self.textLabel = [[UILabel alloc] initWithFrame:frame];
        self.textLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
        self.textLabel.text = text;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = colorNavigationBarColor;
        self.textLabel.layer.cornerRadius = 2;
        //self.textLabel.layer.masksToBounds = YES;
        self.textLabel.layer.borderWidth = 0.5;
        [self addSubview:self.textLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.textLabel.frame.size.width, 0, 20, 20)];
        [self.arrowImageView setContentMode:UIViewContentModeCenter];
        self.arrowImageView.image = [UIImage imageNamed:@"user_appealStateArrow"];
        [self addSubview:self.arrowImageView];
        
        self.frame = CGRectMake(0, 0, self.arrowImageView.frame.size.width+self.arrowImageView.frame.origin.x, 20);
        if (state == CZWUserAppealToStateViewStateNow) {
            self.textLabel.textColor = colorYellow;
        }else if (state == CZWUserAppealToStateViewStateFuture){
            self.textLabel.textColor = colorLightGray;
        }
       
        if (last) {
            [self.arrowImageView removeFromSuperview];
            self.arrowImageView = nil;
            self.frame = self.textLabel.bounds;
        }
        self.textLabel.layer.borderColor = self.textLabel.textColor.CGColor;
    }
    return self;
}


@end
