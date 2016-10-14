
//
//  CZWInformationFootView.m
//  autoService
//
//  Created by bangong on 15/12/23.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWInformationFootView.h"

@implementation CZWInformationFootView
{
    UIButton *_button;
    NSDictionary *_dictionary;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _button = [LHController createButtnFram:CGRectMake(10, 5, frame.size.width-20, frame.size.height-10) Target:self Action:@selector(btnClick) Font:15 Text:nil];
        self.backgroundColor = colorLineGray;
        _button.enabled = NO;
        [self addSubview:_button];
        
    }
    
    return self;
}

-(void)btnClick{
    if (self.block) {
        
        self.block(_button.titleLabel.text,_dictionary[@"userId"]);
    }
}

-(void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[CZWManager manager].roleId forKey:@"uid"];
    [dict setObject:[CZWManager manager].userType forKey:@"utype"];
    
    [dict setObject:self.ToUserId forKey:@"fid"];
    [dict setObject:self.ToUserType forKey:@"ftype"];
    
   [CZWAFHttpRequest POST:auto_firendState parameters:dict success:^(id responseObject) {
       if ([responseObject firstObject][@"step"]) {
           _dictionary = [responseObject firstObject];
           [self setButton];
       }
   } failure:^(NSError *error) {
       
   }];
}

-(void)setButton{
    
    NSString *step = _dictionary[@"step"];

    if ([step isEqualToString:@"加为好友"]) {
        [_button setImage:[UIImage imageNamed:@"auto_chatAddFriend"] forState:UIControlStateNormal];
        [_button setTitle:@"加为好友" forState:UIControlStateNormal];
        _button.enabled = YES;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];

    }else if ([step isEqualToString:@"等待验证"]){
        [_button setTitle:@"等待验证" forState:UIControlStateNormal];
        [_button setTitleColor:colorBlack forState:UIControlStateNormal];
        [_button setImage:[UIImage new] forState:UIControlStateNormal];
        _button.enabled = NO;
        _button.backgroundColor = colorLineGray;
        
    }else if ([step isEqualToString:@"发起对话"]){
        [_button setTitle:@"auto_chatWillChat" forState:UIControlStateNormal];
        [_button setTitle:@"发起对话" forState:UIControlStateNormal];
        _button.enabled = YES;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    }
}

-(void)choose:(void (^)(NSString * ,NSString *))block{
    self.block = block;
}

@end
