//
//  CZWBasicNavigationController.h
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define startX -200;

@interface CZWBasicNavigationController : UINavigationController
{
    CGFloat startBackViewX;
    BOOL firstTouch;
}

// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;
@property (nonatomic, assign) BOOL specialPop;
@end
