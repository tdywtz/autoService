//
//  CZWCityChooseView.h
//  autoService
//
//  Created by bangong on 15/11/30.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  选择地区block回调对象
 *
 *  @param pName 省份名
 *  @param pid   省份id
 *  @param cName 城市名
 *  @param cid   城市id
 */
typedef void(^returnResults)(NSString *pName, NSString *pid, NSString *cName, NSString *cid);

@interface CZWCityChooseView : UIView

@property (nonatomic,copy) returnResults block;
@property (nonatomic,assign) BOOL isshow;

-(void)returnRsults:(returnResults)block;

@end
