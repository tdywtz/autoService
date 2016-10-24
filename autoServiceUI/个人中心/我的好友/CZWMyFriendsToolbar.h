//
//  CZWMyFriendsToolbar.h
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cutButton)(NSInteger index);
typedef void(^addButton)();
@interface CZWMyFriendsToolbar : UIView

@property (nonatomic,copy) cutButton block;
@property (nonatomic,copy) addButton addBlock;
/**
 *  未读消息提示view
 */
@property (nonatomic,strong) UIView *unMessageView;


/**
 *  切换好友类型回调
 *
 *  @param block
 */
-(void)whenCut:(cutButton)block;
/**
 *  点击我的新朋友回调
 *
 *  @param block
 */
-(void)addFriends:(addButton)block;

@end
