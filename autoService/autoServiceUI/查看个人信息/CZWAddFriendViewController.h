//
//  CZWAddFriendViewController.h
//  autoService
//
//  Created by bangong on 16/2/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
/**
 *  添加新朋友
 */
@interface CZWAddFriendViewController : CZWBasicViewController

@property (nonatomic,copy) NSString *targetId;
@property (nonatomic,copy) NSString *ToUserId;
@property (nonatomic,copy) NSString *ToUserType;
@property (nonatomic,copy) NSString *ToUserName;
@property (nonatomic,copy) void(^block)(BOOL success);

-(void)requestSuccess:(void(^)(BOOL success))block;
@end
