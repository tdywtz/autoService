//
//  CZWAppealDetailsFootView.m
//  autoService
//
//  Created by bangong on 15/12/16.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWAppealDetailsFootView.h"
#import "AFHTTPSessionManager+CachePolicy.h"

@implementation CZWAppealDetailsFootView
{
    UIButton *_button;
    NSDictionary *_dictionary;
    NSString *_eid;
}

- (instancetype)initWithFrame:(CGRect)frame type:(CZWAppealDetailsFootViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.bounds;
        rect.size.height = rect.size.height-5;
        _button = [LHController createButtnFram:rect Target:self Action:@selector(btnClick) Font:15 Text:nil];
        _button.enabled = NO;
        _button.backgroundColor = [UIColor clearColor];
        _button.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_button];
   
        _type = type;
    }
    
    return self;
}

-(void)btnClick{
    if (self.block) {
        
        self.block(_button.titleLabel.text,_eid,_dictionary[@"stepid"]);
    }
}

-(void)loadData{

    if (self.type == CZWAppealDetailsFootViewTypeUser){

        [CZWAFHttpRequest requestAPPealStateWithUid:[CZWManager manager].roleId type:[CZWManager manager].userType cpid:self.cpid success:^(id responseObject) {
    
            if ([responseObject count] == 0) {
                return ;
            }
            _dictionary = responseObject[0];
            [self setUserButton];
        } failure:^(NSError *error) {
       
        }];
        
    }else if (self.type == CZWAppealDetailsFootViewTypeExpert){
  
        [CZWAFHttpRequest requestAPPealStateWithUid:[CZWManager manager].roleId type:[CZWManager manager].userType cpid:self.cpid success:^(id responseObject) {
          
        
            if ([responseObject count] == 0) {
                return ;
            }
            _dictionary = responseObject[0];
            [self setCommontButton];
        } failure:^(NSError *error) {
           
        }];

    }
}


-(void)setUserButton{

    NSString *string = _dictionary[@"step"];
    _eid = _dictionary[@"eid"];
   [_button setTitle:string forState:UIControlStateNormal];
      [_button setTitleColor:colorBlack forState:UIControlStateNormal];
    _button.backgroundColor = colorLineGray;
    _button.enabled = NO;
    if ([string isEqualToString:@"申请咨询专家"]
        || [string isEqualToString:@"对厂家受理结果评价"]
        || [string isEqualToString:@"厂家未受理，查看专家意见报告"]
        || [string isEqualToString:@"对厂家进行评价"]
        || [string isEqualToString:@"采纳最佳建议并对专家评价"]){
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.backgroundColor = colorNavigationBarColor;
        _button.enabled = YES;

    }else if(string.length == 0){
        self.hidden = YES;
        if (self.hiddenSelf) {
            self.hiddenSelf(YES);
        }
    }
}

-(void)setCommontButton{
    NSString *string = _dictionary[@"step"];
    _eid = _dictionary[@"eid"];
  
     [_button setImage:[UIImage new] forState:UIControlStateNormal];
    [_button setTitle:string forState:UIControlStateNormal];
    [_button setTitleColor:colorBlack forState:UIControlStateNormal];
     _button.enabled = NO;
    _button.backgroundColor = colorLineGray;
    
    if ([string isEqualToString:@"我来回答"]) {
        [_button setImage:[UIImage imageNamed:@"expert_willAppeal"] forState:UIControlStateNormal];
        _button.enabled = YES;
        _button.backgroundColor = colorNavigationBarColor;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    }else if ([string isEqualToString:@"填写处理建议"]){
       
        _button.enabled = YES;
        _button.backgroundColor = colorNavigationBarColor;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if(string.length == 0){
        self.hidden = YES;
        if (self.hiddenSelf) {
            self.hiddenSelf(YES);
        }
    }
}



-(void)choose:(void (^)(NSString *, NSString *, NSString *))block{
    self.block = block;
}

-(void)hiddenSelf:(void (^)(BOOL))block{
    self.hiddenSelf = block;
}

@end
