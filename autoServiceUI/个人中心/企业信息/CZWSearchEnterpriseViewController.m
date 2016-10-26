//
//  CZWSearchEnterpriseViewController.m
//  autoService
//
//  Created by bangong on 16/5/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWSearchEnterpriseViewController.h"
#import "MJNIndexView.h"
#import "CZWSearchEnterpriseCell.h"
#import "CZWSearchTwoView.h"

@interface CZWSearchEnterpriseViewController ()<MJNIndexViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_oneTableView;
    NSArray *_oneDataArray;
    NSMutableArray *indexArray;

    CZWSearchTwoView *_twoSuperView;
}

@property (nonatomic, strong) MJNIndexView *indexView;
@end

@implementation CZWSearchEnterpriseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"企业列表";
    [self createLeftItemBack];
    
    [self createTableView];
    [self downloadBrand];
    
}

-(void)downloadBrand{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CZWAFHttpRequest GET:auto_fac_list success:^(id responseObject) {
        NSArray *array = responseObject[@"rel"];
        [hud hideAnimated:YES];

        if (indexArray == nil) {
            indexArray = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *dict in array) {
            [indexArray addObject:dict[@"letter"]?dict[@"letter"]:@""];
        }
        _oneDataArray = array;
        self.indexView = [[MJNIndexView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        self.indexView.dataSource = self;
        [self firstAttributesForMJNIndexView];
        [self.view insertSubview:self.indexView belowSubview:_twoSuperView];
        [_oneTableView reloadData];

    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
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
  
    CGFloat height = self.indexView.frame.size.height-20;
    CGFloat a = height -indexArray.count*(height/26);
    a = a/2;
    if (a < 20) {
        a = 20;
    }
    
    self.indexView.upperMargin = a;
    self.indexView.lowerMargin = a;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.6 alpha:1.0];
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}


-(void)createTableView{
    
    _oneTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _oneTableView.delegate = self;
    _oneTableView.dataSource = self;
    _oneTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _oneTableView.separatorColor = colorLineGray;
    _oneTableView.scrollsToTop = NO;
    _oneTableView.backgroundColor = [UIColor whiteColor];
    _oneTableView.tableFooterView = [UIView new];
    [self.view addSubview:_oneTableView];

    _twoSuperView = [[CZWSearchTwoView alloc] initWithFrame:CGRectMake(WIDTH+10, 64, WIDTH/3*2,self.view.frame.size.height)];
    _twoSuperView.layer.shadowColor = [UIColor blackColor].CGColor;
    _twoSuperView.layer.shadowOffset = CGSizeMake(-4, 4);
    _twoSuperView.layer.shadowOpacity = 0.5;
    _twoSuperView.parentViewController = self;
    [self.view addSubview:_twoSuperView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_twoSuperView addGestureRecognizer:pan];

}


#pragma mark - 滑动
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.view];
    
    if (point.x+pan.view.frame.origin.x > WIDTH/3) {
        pan.view.center = CGPointMake(point.x+pan.view.center.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.frame.origin.x< WIDTH/3+30) {
            [self showTwoView];
        }else{
            [self hiddeTwoView];
        }
    }
}

- (void)showTwoView{
    CGRect rect = _twoSuperView.frame;
    rect.origin.x = WIDTH/3;
    [UIView animateWithDuration:0.3 animations:^{
        _twoSuperView.frame = rect;
    }];
}

- (void)hiddeTwoView{
    CGRect rect = _twoSuperView.frame;
    rect.origin.x = WIDTH+10;
    [UIView animateWithDuration:0.3 animations:^{
        _twoSuperView.frame = rect;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _oneDataArray.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_oneDataArray[section][@"brand"] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    CZWSearchEnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
    if (!cell) {
        cell = [[CZWSearchEnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSDictionary *dict = _oneDataArray[indexPath.section][@"brand"][indexPath.row];
    cell.titleLabel.text = dict[@"brandName"];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:@""]];
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   return [NSString stringWithFormat:@" %@",_oneDataArray[section][@"letter"]];

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dict = _oneDataArray[indexPath.section][@"brand"][indexPath.row];
    _twoSuperView.bid = dict[@"bid"];
    _twoSuperView.imageUrl = dict[@"logo"];
    [_twoSuperView loadData];
    CGRect rect = _twoSuperView.frame;
    rect.origin.x = WIDTH+10;
    _twoSuperView.frame = rect;
    
    [self showTwoView];
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

@end
