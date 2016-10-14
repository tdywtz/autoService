//
//  CZWUserAppealCellButtonView.h
//  autoService
//
//  Created by bangong on 15/12/24.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZWUserAppealCellButtonViewDelegate <NSObject>

@required
-(void)selectButton:(nullable NSString *)string;

@end

@interface CZWUserAppealCellButtonView : UIView

@property (nonatomic,weak,nullable) id<CZWUserAppealCellButtonViewDelegate>delegate;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,copy,nullable) NSString *buttonTitle;
@property (nonatomic,assign) BOOL isdate;

-(void)deleteTimer;

@end
