//
//  LHDatePickView.h
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnDate)(NSString *date);
@interface LHDatePickView : UIView

@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) NSString  *minimumDate;
@property (nonatomic,copy) NSString *maximumDate;
@property (nonatomic,copy) returnDate block;

-(void)returnDate:(returnDate)block;

-(void)showDatePicerView;
-(void)hiddenDatePicerView;
@end
