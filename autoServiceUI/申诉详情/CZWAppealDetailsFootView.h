//
//  CZWAppealDetailsFootView.h
//  autoService
//
//  Created by bangong on 15/12/16.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
//**用户类型*/
typedef NS_ENUM(NSInteger, CZWAppealDetailsFootViewType){
    CZWAppealDetailsFootViewTypeUser,
    CZWAppealDetailsFootViewTypeExpert
};
@interface CZWAppealDetailsFootView : UIView
//**申诉id*/
@property (nonatomic,strong) NSString *cpid;
//**用户类型*/
@property (nonatomic,assign) CZWAppealDetailsFootViewType type;
@property (nonatomic,copy) void(^block)(NSString *state, NSString *eid, NSString *stepid);
@property (nonatomic,copy) void(^hiddenSelf)(BOOL hidden);

- (instancetype)initWithFrame:(CGRect)frame type:(CZWAppealDetailsFootViewType)type;
//**点击按钮*/
-(void)choose:(void(^)(NSString *state, NSString *eid, NSString *stepid))block;
//**隐藏*/
-(void)hiddenSelf:(void(^)(BOOL hidden))block;
//**下载数据*/
-(void)loadData;
@end
