//
//  CZWDatePicker.h
//  autoService
//
//  Created by bangong on 15/12/7.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnDate)(NSString *date);
@interface CZWDatePicker : UIDatePicker

@property (nonatomic,copy) returnDate block;

-(void)returnDate:(returnDate)block;

@end
