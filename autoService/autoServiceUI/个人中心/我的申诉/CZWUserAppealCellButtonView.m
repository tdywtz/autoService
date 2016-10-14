//
//  CZWUserAppealCellButtonView.m
//  autoService
//
//  Created by bangong on 15/12/24.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserAppealCellButtonView.h"

@interface CZWUserAppealCellButtonView ()
{
    UIButton *leftBtn;
    UIButton *rightBtn;
    NSTimer *_timer;
}
@end

@implementation CZWUserAppealCellButtonView

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isdate = NO;
        leftBtn = [LHController createButtnFram:CGRectMake(0, 0, 60, frame.size.height) Target:self Action:@selector(btnClick:) Font:14 Text:@"满意"];
        [self addSubview:leftBtn];
        
        rightBtn = [LHController createButtnFram:CGRectMake(100, 0, 100, frame.size.height) Target:self Action:@selector(btnClick:) Font:14 Text:nil];
        [self addSubview:rightBtn];
        
        [leftBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.centerX.equalTo(WIDTH/2);
            make.height.equalTo(frame.size.height);
        }];
        
        [rightBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
             make.centerX.equalTo(WIDTH/2+1);
            make.height.equalTo(frame.size.height);
        }];

    }
    return self;
}

-(void)btnClick:(UIButton *)btn{

    [self.delegate selectButton:btn.titleLabel.text];
}

-(void)setButtonTitle:(NSString *)buttonTitle{
    if ([_buttonTitle isEqualToString:buttonTitle]) {
        return;
    }
    
    _buttonTitle = buttonTitle;
  
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [rightBtn setTitle:_buttonTitle forState:UIControlStateNormal];
    
    if ([_buttonTitle isEqualToString:@"不满意，申请咨询专家"] ||
        [_buttonTitle isEqualToString:@"不满意，下载专家意见报告"]) {
        if (WIDTH < 380) {
            leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        
        leftBtn.hidden = NO;
        [leftBtn setTitle:@"满意并对厂家评价" forState:UIControlStateNormal];

        [leftBtn layoutIfNeeded];
        [rightBtn layoutIfNeeded];
         CGSize sizeLeft = [leftBtn.titleLabel.text calculateTextSizeWithFont:leftBtn.titleLabel.font Size:CGSizeMake(200, 20)];
          CGSize sizeRight = [rightBtn.titleLabel.text calculateTextSizeWithFont:rightBtn.titleLabel.font Size:CGSizeMake(200, 20)];
        [leftBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@(-WIDTH/4-10));
             make.width.equalTo(sizeLeft.width+20);
        }];
        [rightBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@(WIDTH/4-10));
             make.width.equalTo(sizeRight.width+20);
        }];
    }else if ([buttonTitle isEqualToString:@"删除"]){
        leftBtn.hidden = NO;
        [leftBtn setTitle:@"修改" forState:UIControlStateNormal];

        [leftBtn layoutIfNeeded];
        [rightBtn layoutIfNeeded];
        CGSize sizeLeft = [leftBtn.titleLabel.text calculateTextSizeWithFont:leftBtn.titleLabel.font Size:CGSizeMake(200, 20)];
        CGSize sizeRight = [rightBtn.titleLabel.text calculateTextSizeWithFont:rightBtn.titleLabel.font Size:CGSizeMake(200, 20)];
        [leftBtn updateConstraints:^(MASConstraintMaker *make) {
             make.centerX.equalTo(-WIDTH/4+20);
             make.width.equalTo(sizeLeft.width+40);
        }];
        [rightBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(WIDTH/4-20);
             make.width.equalTo(sizeRight.width+40);
        }];
    }
    else{
        leftBtn.hidden = YES;
        [rightBtn layoutIfNeeded];
        CGSize sizeRight = [rightBtn.titleLabel.text calculateTextSizeWithFont:rightBtn.titleLabel.font Size:CGSizeMake(200, 20)];
        [rightBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.equalTo(sizeRight.width+20);
        }];
    }

    if (_buttonTitle.length == 0) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    if ([_buttonTitle isEqualToString:@"等待网站二次审核"]
        || [_buttonTitle isEqualToString:@"等待厂家二次受理"]
        || [_buttonTitle isEqualToString:@"等待专家建议"]) {
       // rightBtn.enabled = NO;
        rightBtn.backgroundColor = colorDeepGray;
    }else{
        rightBtn.enabled = YES;
        rightBtn.backgroundColor = colorNavigationBarColor;
    }
}

-(void)setIsdate:(BOOL)isdate{

    _isdate = isdate;
    if (_isdate){
        rightBtn.bounds = CGRectMake(0, 0, 110, self.bounds.size.height);
        [rightBtn setImage:[UIImage imageNamed:@"center_user_time@2x"] forState:UIControlStateNormal];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
         rightBtn.backgroundColor = colorDeepGray;
        [self setdate];
        if (!_timer) {
        
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setdate) userInfo:nil repeats:YES];
        }
       // [_timer setFireDate:[NSDate distantPast]];
   
    }else{
        [rightBtn setImage:[UIImage new] forState:UIControlStateNormal];
        //[_timer setFireDate:[NSDate distantFuture]];
        [self deleteTimer];
    }
}
-(void)setdate{
   // NSLog(@"%@",_buttonTitle);
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:_buttonTitle];
    if (!fromdate) {
        return;
    }
    
    NSCalendar *gregorian;
    unsigned int unitFlags;
    
    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        unitFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    }else{
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    }
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[NSDate date]  toDate:fromdate  options:0];
    NSInteger hour          = [comps hour];
    NSInteger minute        = [comps minute];
    NSInteger second        = [comps second];
    NSString *timeSting     = [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",hour,minute,second];
    
    [rightBtn setTitle:timeSting forState:UIControlStateNormal];
    if (hour == 0 && minute == 0 && second == 0) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
}

-(void)deleteTimer{
    [_timer invalidate];
    _timer = nil;
    
}


@end
