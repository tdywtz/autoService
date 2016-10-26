//
//  LHPickerView.m
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "LHPickerView.h"

@interface LHPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    UIView *_pickerSuperView;
    UILabel *_titleLabel;
    NSString *_selectText;
    NSString *_selectID;
}
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation LHPickerView
- (instancetype)initWithStyle:(LHpickerStyle)style
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGB_color(0, 0, 0, 0.5);
        [self createUI];
        if (style == LHpickerStyleAbbreviation) {
            NSArray *array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"proviceList" ofType:@"plist"]];
            NSMutableArray *marr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in array) {
                [marr addObject:@{@"title":dict[@"License_plate"],@"id":dict[@"Id"]}];
            }
            self.dataArray = marr;
            _titleLabel.text = @"省份简称";
        }else if (style == LHpickerStyleSex){
            NSDictionary *dict1 = @{@"title":@"男",@"id":@"1"};
            NSDictionary *dict2 = @{@"title":@"女",@"id":@"2"};
            self.dataArray = @[dict1,dict2];
            _titleLabel.text = @"性别";
        }
        
    }
    return self;
}

-(void)createUI{
    [self createPickView];
}

#pragma  mark - 创建选择列表框pickView
-(void)createPickView{
    _pickerSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 240)];
    _pickerSuperView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerSuperView];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(WIDTH-60, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"完成"];
    
    [button setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [_pickerSuperView addSubview:button];
    
    UIButton *qx = [LHController createButtnFram:CGRectMake(20, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"取消"];
    [qx setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [_pickerSuperView addSubview:qx];
    
    _titleLabel = [LHController createLabelWithFrame:CGRectMake(60,10,  WIDTH-120, 20) Font:17 Bold:NO TextColor:colorBlack Text:nil];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_pickerSuperView addSubview:_titleLabel];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 180)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerSuperView addSubview:_pickerView];
}


-(void)pickViewClick:(UIButton *)btn{
   
    [self dismissView];
    
    if ([btn.titleLabel.text isEqualToString:@"完成"]) {
        if (self.block) {
            self.block(_selectText,_selectID);
        }
    }
}

-(void)setDataArray:(NSArray *)dataArray{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    
    [_pickerView reloadAllComponents];
}

-(void)returnResult:(returnResult)block{
    self.block = block;
}

-(void)showPickerView{
    [UIView animateWithDuration:0.2 animations:^{
        _pickerSuperView.frame = CGRectMake(0, HEIGHT-240, WIDTH, 240);
    }];
}

-(void)dismissView{
    [UIView animateWithDuration:0.2 animations:^{
        _pickerSuperView.frame = CGRectMake(0, HEIGHT, WIDTH, 240);
    }];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      
         [self removeFromSuperview];
    });
}

#pragma mark - 列表框pickerViewDataSource代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,_pickerView.frame.size.width,40.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _dataArray[row][@"title"];
    
    if (row == 0) {
        _selectText = label.text;
    }
    return label;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectText = _dataArray[row][@"title"];
    _selectID = _dataArray[row][@"id"];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
