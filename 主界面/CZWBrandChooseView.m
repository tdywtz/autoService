//
//  CZWBrandChooseView.m
//  autoService
//
//  Created by bangong on 15/11/30.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBrandChooseView.h"
#import <MJNIndexView.h>

@interface CZWBrandChooseView ()<UITableViewDataSource,UITableViewDelegate,MJNIndexViewDataSource>
{
    UITableView *_oneTableView;
    NSArray *_oneDataArray;
    NSMutableArray *indexArray;
    
    UIView *_twoSuperView;
    UITableView *_twoTableView;
    NSArray *_twoDataArray;
    
    NSString *_chooseOneText;
    NSString *_chooseOneId;
    NSString *_returnText;
    NSString *_returnID;
    
   
    NSInteger willDisplaySection;
    NSInteger didEndDisplayingSection;
}
@property (nonatomic, strong) MJNIndexView *indexView;
@end

@implementation CZWBrandChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
        [self downloadBrand];
    }
    return self;
}
-(void)downloadBrand{
    
    [CZWAFHttpRequest requestBrandSuccess:^(id responseObject) {
      
       if ([responseObject count] == 0) return ;
        if (indexArray == nil) {
            indexArray = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *dict in responseObject) {
            [indexArray addObject:dict[@"letter"]?dict[@"letter"]:@""];
        }
        _oneDataArray = responseObject;
        self.indexView = [[MJNIndexView alloc]initWithFrame:self.bounds];
        self.indexView.dataSource = self;
        [self firstAttributesForMJNIndexView];
        [self insertSubview:self.indexView belowSubview:_twoSuperView];
        [_oneTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark reading/writting attributes for MJNIndexItemsForTableView


- (void)firstAttributesForMJNIndexView
{
    
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 22.0;
    self.indexView.lowerMargin = 22.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.6 alpha:1.0];
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}

-(void)loadDataTwo:(NSString *)brandID{
    
    [CZWAFHttpRequest requestSeriesWithBrandId:brandID Success:^(id responseObject) {

        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"rel"]) {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setObject:dict[@"brands"] forKey:@"section"];

            NSMutableArray *marr = [[NSMutableArray alloc] init];
            for (NSDictionary *subDict in dict[@"series"]) {
                [marr addObject:subDict];
            }
            [mDict setObject:marr forKey:@"array"];
            [mArray addObject:mDict];
        }
      _twoDataArray = mArray;
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
    _oneTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _oneTableView.separatorColor = colorLineGray;
    _oneTableView.scrollsToTop = NO;
    _oneTableView.backgroundColor = [UIColor whiteColor];
    _oneTableView.tableFooterView = [UIView new];
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
    _twoTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _twoTableView.separatorColor = colorLineGray;
    _twoTableView.scrollsToTop = NO;
    _twoTableView.backgroundColor = [UIColor whiteColor];
    _twoTableView.tableFooterView = [UIView new];
    [_twoSuperView addSubview:_twoTableView];
}


-(void)buttonClick{
    _chooseOneText = _chooseOneId = _returnID = _returnText = @"";
    [_oneTableView reloadData];
    if (self.block) {
        self.block(@"全部",@"");
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

-(void)chooseResult:(chooseResult)block{
    self.block = block;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _oneTableView) return _oneDataArray.count;
    return _twoDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _oneTableView) return [_oneDataArray[section][@"brand"] count];
    return [_twoDataArray[section][@"array"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _oneTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 50)];
            imageView.tag = 100;
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [LHController createLabelWithFrame:CGRectZero Font:15 Bold:NO TextColor:colorBlack Text:nil];
            label.tag = 101;
            [cell.contentView addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.right).offset(10);
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(-15);
                make.height.equalTo(20);
            }];
        }
        
        NSDictionary *dict = _oneDataArray[indexPath.section][@"brand"][indexPath.row];
        UIImageView *iamgeView = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
        label.text = dict[@"name"];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:@""]];

        if ([label.text isEqualToString:_chooseOneText]) {
            label.textColor = colorNavigationBarColor;
            
        }else{
            label.textColor = colorBlack;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twocell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 50)];
        imageView.tag = 100;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [LHController createLabelWithFrame:CGRectZero Font:15 Bold:NO TextColor:colorBlack Text:nil];
        label.tag = 101;
        [cell.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.right).offset(10);
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(0);
            make.height.equalTo(20);
        }];
    }
   
    NSDictionary *dict = _twoDataArray[indexPath.section][@"array"][indexPath.row];
    UIImageView *iamgeView = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
    label.text = dict[@"name"];
    [iamgeView sd_setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:@""]];
    
    if ([cell.textLabel.text isEqualToString:_returnText]) {
        label.textColor = colorDeepBlue;
        
    }else{
       label.textColor = colorBlack;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _oneTableView) return [NSString stringWithFormat:@" %@",_oneDataArray[section][@"letter"]];
    return  [NSString stringWithFormat:@" %@",_twoDataArray[section][@"section"]];
  //  return _twoDataArray[section][@"section"];
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (tableView == _oneTableView) return nil;
//    NSString *str = [NSString stringWithFormat:@"    %@",_twoDataArray[section][@"section"]];
//    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, 200, 20) Font:15 Bold:NO TextColor:[UIColor blackColor] Text:str];
//    label.backgroundColor = RGB_color(245, 245, 245, 1);
//    return label;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _twoTableView) {
        return 40;
    }
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _oneTableView) {
        
        NSDictionary *dict = _oneDataArray[indexPath.section][@"brand"][indexPath.row];
        if (![_chooseOneId isEqualToString:dict[@"id"]]) {
            _twoDataArray = nil;
            [_twoTableView reloadData];
            
            [self loadDataTwo:dict[@"id"]];
            _twoSuperView.frame = CGRectMake(WIDTH+10, 0, WIDTH/3*2, HEIGHT-64);
            
            _chooseOneId = dict[@"id"];
            _chooseOneText = dict[@"name"];
            _returnText =  _returnID = @"";
            [_oneTableView reloadData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _twoSuperView.frame = CGRectMake(WIDTH/3, 0, WIDTH/3*2, HEIGHT-64);
        }];
    }else{
        NSDictionary *dict = _twoDataArray[indexPath.section][@"array"][indexPath.row];
        
        if (![_returnText isEqualToString:dict[@"name"]]) {
            
            _returnID = dict[@"id"];
            _returnText = dict[@"name"];
            [_twoTableView reloadData];
        }
        if (self.block) {
            self.block(_returnText,_returnID);
        }
    }
}


#pragma mark - MJNIndexViewDataSource
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return indexArray;
    
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
   
    [_oneTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

//- (void)tableViewIndexBar:(AIMTableViewIndexBar*)indexBar didSelectSectionAtIndex:(NSInteger)index{
//    
//    if ([_oneTableView numberOfSections] > index && index > -1){   // for safety, should always be YES
//        [_oneTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
//                          atScrollPosition:UITableViewScrollPositionTop
//                                  animated:YES];
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
