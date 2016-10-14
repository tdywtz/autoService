//
//  PageViewcontroller.h
//  autoService
//
//  Created by bangong on 16/4/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol LHPageViewcontrollerDelegate <NSObject>

@optional
//将要移动到的视图控制器
-(void)willTransitionToViewControllerLeft:(NSInteger)index;
-(void)willTransitionToViewControllerRight:(NSInteger)index;

//变化当前停留在窗口的视图
-(void)didFinishAnimatingApper:(NSInteger)current;
//滑动进度
-(void)scrollViewDidScrollLeft:(CGFloat)leftProgress;
-(void)scrollViewDidScrollRight:(CGFloat)rightProgress;


@end

@interface LHPageViewcontroller : UIPageViewController

@property (nonatomic,weak) id<LHPageViewcontrollerDelegate> LHDelegate;
@property (nonatomic,strong) NSArray <__kindof ALAsset *> *assets;




+(instancetype)initWithSpace:(CGFloat)space;

-(void)setViewControllerWithCurrent:(NSInteger)current;
@end
