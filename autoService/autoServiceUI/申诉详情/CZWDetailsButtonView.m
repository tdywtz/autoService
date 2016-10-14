//
//  CZWDetailsButtonView.m
//  autoService
//
//  Created by bangong on 16/3/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWDetailsButtonView.h"

@implementation CZWDetailsButtonView
{
    UIView *backView;

}

- (instancetype)initWith:(NSString *)buttonSting;
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self setup:buttonSting];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecogniaer)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)tapRecogniaer{
    [self dismiss];
}

-(void)setup:(NSString *)butotonString{
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(160);
        make.centerY.equalTo(HEIGHT);
    }];
    
    UIButton *button1 = [LHController createButtnFram:CGRectZero Target:self Action:@selector(topButton) Text:@"满意并对厂家评价"];
   [button1 setTitleColor:colorDeepGray forState:UIControlStateNormal];
    button1.layer.borderWidth = 1;
    button1.layer.borderColor = colorLineGray.CGColor;
    button1.layer.cornerRadius = 3;
    button1.layer.masksToBounds = YES;
    
    UIButton *button2 = [LHController createButtnFram:CGRectZero Target:self Action:@selector(bottomButton) Text:butotonString];
    [button2 setTitleColor:colorDeepGray forState:UIControlStateNormal];
    button2.layer.borderWidth = 1;
    button2.layer.borderColor = colorLineGray.CGColor;
    button2.layer.cornerRadius = 3;
    button2.layer.masksToBounds = YES;
    
    [backView addSubview:button1];
    [backView addSubview:button2];
    
    [button1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(-30);
        make.width.equalTo(280);
    }];
    
    [button2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
       make.centerY.equalTo(30);
        make.width.equalTo(280);
    }];
}

-(void)topButton{
    if (self.block) {
        self.block(0);
    }
    [self dismiss];
}

-(void)bottomButton{
    if (self.block) {
        self.block(1);
    }
    [self dismiss];
}

-(void)click:(void (^)(NSInteger))block{
    self.block = block;
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [backView updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];}

-(void)dismiss{
    [backView removeFromSuperview];
    backView = nil;
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
