//
//  CZWDatePicker.m
//  autoService
//
//  Created by bangong on 15/12/7.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWDatePicker.h"

@implementation CZWDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setting];
    }
    return self;
}

-(void)setting{
    //最小时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [formatter dateFromString:@"1919-10-10"];
    //最大时间
    self.maximumDate = [NSDate date];
    //设置时间模式为中文显示
    self.datePickerMode = UIDatePickerModeDate;
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [self setLocale:locale];
    
    //添加事件
    [self addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventValueChanged];
}


-(void)dateClick
{
    //转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    NSString *str = [formatter stringFromDate:self.date];
    //刷新日期
    if (self.block) {
        self.block(str);
    }
}

-(void)returnDate:(returnDate)block{
    self.block = block;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
