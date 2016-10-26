//
//  CZWBasicViewController.h
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZWManager.h"

@interface CZWBasicViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat scrollContentY;

/**
 * 释放
 */
- (void)free;
-(void)createLeftItemBack;
-(void)createScrollView;
-(void)createNotification;
@end
