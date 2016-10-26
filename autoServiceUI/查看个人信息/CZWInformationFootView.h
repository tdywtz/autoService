//
//  CZWInformationFootView.h
//  autoService
//
//  Created by bangong on 15/12/23.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  查看个人信息底部按钮视图
 */
@interface CZWInformationFootView : UIView

@property (nonatomic,copy) NSString *ToUserId;
@property (nonatomic,copy) NSString *ToUserType;
@property (nonatomic,copy) void(^block)(NSString *state ,NSString *targetId);

-(void)choose:(void(^)(NSString *state ,NSString *targetId))block;
-(void)loadData;
@end
