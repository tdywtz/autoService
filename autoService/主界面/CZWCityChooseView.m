//
//  CZWCityChooseView.m
//  autoService
//
//  Created by bangong on 15/11/30.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWCityChooseView.h"

@interface CZWCityChooseView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_oneTableView;
    NSArray *_oneDataArray;
    
    UIView *_twoSuperView;
    UITableView *_twoTableView;
    NSArray *_twoDataArray;
    
    NSString *_pid;
    NSString *_pName;
    NSString *_cid;
    NSString *_cName;
}

@end

@implementation CZWCityChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB_color(240, 240, 240, 1);
        [self createTableView];
        [self loadDataOne];
    }
    return self;
}
-(void)loadDataOne{
    
    [CZWAFHttpRequest requestProvinceSuccess:^(id responseObject) {
        _oneDataArray = responseObject;
        [_oneTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadDataTwo:(NSString *)pid{
    
    [CZWAFHttpRequest requestCityWithPid:pid success:^(id responseObject) {
        _twoDataArray = responseObject;
        [_twoTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


-(void)createTableView{
    
    CGRect frame = self.frame;
    frame.origin.y = 0;
    _oneTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _oneTableView.delegate = self;
    _oneTableView.dataSource = self;
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _oneTableView.scrollsToTop = NO;
    _oneTableView.backgroundColor = RGB_color(244, 244, 244, 1);
    [self addSubview:_oneTableView];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(0, 0, WIDTH, 44) Target:self Action:@selector(buttonClick) Text:nil];
    _oneTableView.tableHeaderView = button;
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 0, 80, 44) Font:15 Bold:NO TextColor:colorBlack Text:@"全部"];
    [button addSubview:label];
    
    UIView *line = [LHController createBackLineWithFrame:CGRectMake(0, 43, WIDTH, 1)];
    line.backgroundColor = RGB_color(222, 222, 222, 1);
    [button addSubview:line];
    
    
    
    
    _twoSuperView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH+10, 0, WIDTH/3*2,self.frame.size.height)];
    _twoSuperView.layer.shadowColor = [UIColor blackColor].CGColor;
    _twoSuperView.layer.shadowOffset = CGSizeMake(-4, 4);
    _twoSuperView.layer.shadowOpacity = 0.5;
    [self addSubview:_twoSuperView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_twoSuperView addGestureRecognizer:pan];
    
    _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _twoSuperView.frame.size.width, _twoSuperView.frame.size.height) style:UITableViewStylePlain];
    _twoTableView.delegate = self;
    _twoTableView.dataSource = self;
    _twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _twoTableView.scrollsToTop = NO;
    _twoTableView.backgroundColor = RGB_color(244, 244, 244, 1);
    [_twoSuperView addSubview:_twoTableView];
}

-(void)buttonClick{
    _pid = _pName = _cid = _cName = @"";
    [_oneTableView reloadData];
    if (self.block) {
        self.block(_pName,_pid,@"全部",_cid);
    }
}

#pragma mark - 滑动
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self];
    
    if (point.x+pan.view.frame.origin.x > WIDTH/3) {
        pan.view.center = CGPointMake(point.x+pan.view.center.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:self];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.frame.origin.x< WIDTH/3+30) {
            [UIView animateWithDuration:0.3 animations:^{
                pan.view.frame = CGRectMake(WIDTH/3, 0, WIDTH/3*2, HEIGHT-64);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                pan.view.frame = CGRectMake(WIDTH+10, 0, WIDTH/3*2, HEIGHT-64);
            }];
        }
    }
}

-(void)returnRsults:(returnResults)block{
    self.block = block;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _oneTableView) return _oneDataArray.count;
    return _twoDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _oneTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecell"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(22, 43, WIDTH-40, 1)];
            view.backgroundColor = colorLineGray;
            [cell.contentView addSubview:view];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"  %@",_oneDataArray[indexPath.row][@"Name"]];
 
        if ([_oneDataArray[indexPath.row][@"Id"] isEqualToString:_pid]) {
            cell.textLabel.textColor = colorNavigationBarColor;
            
        }else{
            cell.textLabel.textColor = colorBlack;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twocell"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 43, WIDTH-30, 1)];
        view.backgroundColor = colorLineGray;
        [cell.contentView addSubview:view];
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = _twoDataArray[indexPath.row][@"name"];
    if ([cell.textLabel.text isEqualToString:_cName]) {
        cell.textLabel.textColor = colorDeepBlue;
        
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
    if (tableView == _oneTableView) {
        
        NSDictionary *dict = _oneDataArray[indexPath.row];
        if (![_pid isEqualToString:dict[@"Id"]]) {
            [self loadDataTwo:dict[@"Id"]];
            _twoSuperView.frame = CGRectMake(WIDTH+10, 0, WIDTH/3*2, HEIGHT-64);
            
            _pid = dict[@"Id"];
            _pName = dict[@"Name"];
            _cName = nil;
            _cid = nil;
            
            [_oneTableView reloadData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _twoSuperView.frame = CGRectMake(WIDTH/3, 0, WIDTH/3*2, HEIGHT-64);
        }];
    }else{
        NSDictionary *dict = _twoDataArray[indexPath.row];
        
        if (![_cName isEqualToString:dict[@"name"]]) {
            
            _cid = dict[@"id"];
            _cName = dict[@"name"];
            [_twoTableView reloadData];
        }
        if (self.block) {
            self.block(_pName,_pid,_cName,_cid);
        }
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
