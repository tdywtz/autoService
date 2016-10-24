//
//  CZWBrandChooseView.h
//  autoService
//
//  Created by bangong on 15/11/30.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  选择车系block回调对象
 *
 *  @param text 车系名
 *  @param ID   车系id
 */
typedef void(^chooseResult)(NSString *text, NSString *ID);
@interface CZWBrandChooseView : UIView

@property (nonatomic,copy) chooseResult block;
@property (nonatomic,assign) BOOL isshow;

-(void)chooseResult:(chooseResult)block;

@end
