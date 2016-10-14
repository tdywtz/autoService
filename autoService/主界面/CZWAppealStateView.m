//
//  CZWAppealStateView.m
//  autoService
//
//  Created by bangong on 15/11/30.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWAppealStateView.h"

@interface CZWAppealStateView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    NSString *_chooseText;
    NSString *_chooseId;
}
@end
@implementation CZWAppealStateView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB_color(240, 240, 240, 1);
        [self createTableView];
        
        self.backgroundColor = [UIColor clearColor];
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[
                                 (id)[[UIColor colorWithWhite:1 alpha:0.9] CGColor],
                                 (id)[[UIColor colorWithWhite:1 alpha:0.9] CGColor],
                                 ];
//        gradientLayer.locations = @[@(0.1),@(0.2),@(0.3),@(0.4),@(0.5)];
//        gradientLayer.type = kCAGradientLayerAxial;
    }
    return self;
}








-(void)createTableView{
    NSString *role = [[NSUserDefaults standardUserDefaults] objectForKey:isUserOrExpertLogin];
    if ([role isEqualToString:isUserLogin]) {
        _dataArray = @[@{@"title":@"全部",@"id":@"99"},@{@"title":@"厂家受理",@"id":@"2"},
                       @{@"title":@"咨询专家",@"id":@"4"}/*,@{@"title":@"已完成",@"id":@"7"}*/];
    }else{
        _dataArray = @[@{@"title":@"全部",@"id":@"99"},@{@"title":@"已采纳专家建议",@"id":@"5"},
                       @{@"title":@"未采纳专家建议",@"id":@"3"}];
    }
    CGRect frame = self.frame;
    frame.origin.y = 0.0;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollsToTop = NO;
    _tableView.backgroundColor = RGB_color(244, 244, 244, 1);

    [self addSubview:_tableView];
}

-(void)chooseResult:(chooseResult)block{
    self.block = block;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecell"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 43, WIDTH-30, 1)];
        view.backgroundColor = colorLineGray;
        [cell.contentView addSubview:view];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"title"];
    
    if ([cell.textLabel.text isEqualToString:_chooseText]) {
        cell.textLabel.textColor = colorNavigationBarColor;
        
    }else{
        cell.textLabel.textColor = colorBlack;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _dataArray[indexPath.row];
    _chooseText = dict[@"title"];
    _chooseId = dict[@"id"];
    [_tableView reloadData];
    if (self.block) {
        if ([[CZWManager  manager].RoleType isEqualToString:isExpertLogin] && _chooseText.length>3) {
            
            _chooseText = [NSString stringWithFormat:@"%@...",[_chooseText substringToIndex:3]];
        }
        self.block(_chooseText,_chooseId);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
