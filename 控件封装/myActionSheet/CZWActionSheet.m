//
//  CZWActionSheet.m
//  autoService
//
//  Created by bangong on 15/12/10.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWActionSheet.h"

@implementation CZWActionSheet

{
    UIView *whiteView;
    NSMutableArray *buttons;
}

- (void)dealloc
{
    whiteView = nil;
}
-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        buttons = [[NSMutableArray alloc] init];
        [self setGestureRecognizer];
        [self createButton:array];
    }
    
    return self;
}



//
//-(UIButton *)createButton:(CGRect)frame Title:(NSString *)title Targat:(id)targat Action:(SEL)action{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = frame;
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [button addTarget:targat action:action forControlEvents:UIControlEventTouchUpInside];
//    
//    return button;
//}


-(void)setGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer *)tap{
    [self dismiss];
}


-(void)createButton:(NSArray *)array{
   
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 50*array.count)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
   
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 50*i, self.frame.size.width, 49);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        
        if (i < array.count-1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.origin.y+button.frame.size.height, self.frame.size.width, 1)];
            line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
            [whiteView addSubview:line];
        }
        [buttons addObject:button];
    }
}

-(void)buttonClick:(UIButton *)button{

    if (self.block) {
        self.block(self, button.tag - 100);
    }
    [self dismiss];
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = whiteView.frame;
        frame.origin.y = self.frame.size.height - whiteView.frame.size.height;
        whiteView.frame = frame;
    }];
}

-(void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = whiteView.frame;
        frame.origin.y = self.frame.size.height;
        whiteView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)choose:(choose)block{
    self.block = block;
}

-(void)setTelephone:(BOOL)telephone{
    
    if (_telephone != telephone) {
        _telephone = telephone;
        if (!_telephone) return;
        
        for (int i = 0; i < buttons.count; i ++) {
            UIButton *btn = buttons[i];
            if (i < buttons.count-1) {
                [btn setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
            }
        }
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
