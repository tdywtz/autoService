//
//  CZWMyFriendsToolbar.m
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWMyFriendsToolbar.h"

@implementation CZWMyFriendsToolbar
{
    UIButton *leftButton;
    UIButton *rightButton;
    UIView *moveLine;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    leftButton = [LHController createButtnFram:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2) Target:self Action:@selector(buttonClick:) Text:@"专家"];
    [leftButton setTitleColor:colorNavigationBarColor forState:UIControlStateSelected];
    [leftButton setTitleColor:colorBlack forState:UIControlStateNormal];
    leftButton.selected = YES;
    [self addSubview:leftButton];
    
    rightButton = [LHController createButtnFram:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height/2) Target:self Action:@selector(buttonClick:) Text:@"用户"];
    [rightButton setTitleColor:colorNavigationBarColor forState:UIControlStateSelected];
    [rightButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [self addSubview:rightButton];
    
    UIView *line = [LHController createBackLineWithFrame:CGRectMake(0, leftButton.frame.size.height, WIDTH, 1)];
    [self addSubview:line];
    
    moveLine = [[UIView alloc] initWithFrame:CGRectMake(0, line.frame.origin.y-1, WIDTH/2, 2)];
    moveLine.backgroundColor = colorNavigationBarColor;
    [self addSubview:moveLine];
    
    
    UIButton *addButton = [LHController createButtnFram:CGRectMake(10, self.frame.size.height/2, 120, self.frame.size.height/2) Target:self Action:@selector(addClick:) Text:@"我的新朋友"];
    [addButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"auto_addFriends"] forState:UIControlStateNormal];
    [addButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self addSubview:addButton];
    
    UIView *lineView = [LHController createBackLineWithFrame:CGRectMake(0, self.frame.size.height-1, WIDTH, 1)];
    [self addSubview:lineView];
    
    _unMessageView = [[UIView alloc] init];
    _unMessageView.backgroundColor = [UIColor redColor];
    _unMessageView.layer.cornerRadius = 3;
    _unMessageView.layer.masksToBounds = YES;
    [self addSubview:_unMessageView];
    
    [_unMessageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addButton.right);
        make.centerY.equalTo(addButton);
        make.size.equalTo(CGSizeMake(6, 6));
    }];
}

-(void)buttonClick:(UIButton *)button{
    if (button.selected) return;
    
    button.selected = YES;
    NSInteger index = 0;
    if (button == leftButton) {
        index = 0;
        rightButton.selected = NO;
    }else{
        index = 1;
        leftButton.selected = NO;
    }
    if (self.block) {
        self.block(index);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        moveLine.center = CGPointMake(button.center.x, moveLine.center.y);
    }];
    
}

-(void)addClick:(UIButton *)btn{
    if (self.addBlock) {
        self.addBlock();
    }
}

-(void)whenCut:(cutButton)block{
    self.block = block;
}

-(void)addFriends:(addButton)block{
    self.addBlock = block;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
