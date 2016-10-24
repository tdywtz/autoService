//
//  CZWUserAppealCellView.h
//  autoService
//
//  Created by bangong on 15/12/24.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CZWUserAppealCellView : UIView

@property (nonatomic,assign) CGFloat changeFrameHeight;
@property (nonatomic,assign) CGFloat drawWidth;
@property (nonatomic,strong) NSArray *steps;

-(void)setSteps:(NSArray *)steps andIndex:(NSInteger)index;

@end
