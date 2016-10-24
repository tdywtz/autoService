//
//  LHDatePickView.m
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "LHDatePickView.h"

@interface LHDatePickView ()
{
    UIDatePicker *_datePicker;
    UIView *_dateSuperView;
    UILabel *_titleLabel;
}

@end

@implementation LHDatePickView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self createDatePicker];
}

#pragma mark - 时间选择
-(void)createDatePicker{
        
    _dateSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH,240)];
    _dateSuperView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_dateSuperView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 180)];
    //最小时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _datePicker.minimumDate = [formatter dateFromString:@"1919-10-10"];
    //最大时间
    _datePicker.maximumDate = [NSDate date];
    //设置时间模式为中文显示
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [_datePicker setLocale:locale];
    
    //添加事件
    [_datePicker addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventValueChanged];
    [_dateSuperView addSubview:_datePicker];
    
    
    UIButton *quxiao = [LHController createButtnFram:CGRectMake(20, 10, 40, 20) Target:self Action:@selector(datePickerClick:) Text:@"取消"];
    [quxiao setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [_dateSuperView addSubview:quxiao];
    
    UIButton *queding = [LHController createButtnFram:CGRectMake(WIDTH-60, 10, 40, 20) Target:self Action:@selector(datePickerClick:) Text:@"确定"];
    [queding setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [_dateSuperView addSubview:queding];
    
    _titleLabel = [LHController createLabelWithFrame:CGRectMake(60, 10, WIDTH-120, 20) Font:17 Bold:NO TextColor:colorBlack Text:nil];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_dateSuperView addSubview:_titleLabel];
}

-(void)dateClick
{
    
//    //转换
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    //
//    NSString *str = [formatter stringFromDate:_datePicker.date];
//    //刷新日期
}


-(void)datePickerClick:(UIButton *)btn{
    [self hiddenDatePicerView];
    
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
        //转换
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //
        NSString *str = [formatter stringFromDate:_datePicker.date];
        //刷新日期
        if (self.block) {
            self.block(str);
        }
    }
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.hidden = YES;
       // [self removeFromSuperview];
    });

}

-(void)showDatePicerView{
    
    CGRect frame = _dateSuperView.frame;
    frame.origin.y = HEIGHT-240;
    [UIView animateWithDuration:0.2 animations:^{
        _dateSuperView.frame = frame;
        
    }];
}

-(void)hiddenDatePicerView{
    CGRect frame = _dateSuperView.frame;
    frame.origin.y = HEIGHT;
    [UIView animateWithDuration:0.2 animations:^{
        _dateSuperView.frame = frame;
        
    }];
}

-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    _titleLabel.text = _titleText;
}

-(void) setMinimumDate:(NSString *)minimumDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _datePicker.minimumDate = [formatter dateFromString:minimumDate];
}

-(void)setMaximumDate:(NSString *)maximumDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _datePicker.maximumDate = [formatter dateFromString:maximumDate];
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
