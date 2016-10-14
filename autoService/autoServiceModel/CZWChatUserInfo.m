//
//  CZWChatUserInfo.m
//  autoService
//
//  Created by bangong on 16/1/14.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWChatUserInfo.h"
#import <objc/runtime.h>

@implementation CZWChatUserInfo

-(instancetype)initWithDictrionary:(NSDictionary *)dict{
    if (self = [super init]) {
        _userId       = dict[@"userId"];
        _userName     = dict[@"name"];
        _iconUrl      = dict[@"headpic"];
        _area         = dict[@"city"];
        _score        = dict[@"score"];
        _complete_num = dict[@"complete_num"];
        _modelName    = dict[@"modelname"];
        _type         = dict[@"type"];
        _seviceId     = dict[@"uid"];
        _isfriend     = FriendTypeNot;
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _isfriend = FriendTypeNot;
    }
    return self;
}


@end
