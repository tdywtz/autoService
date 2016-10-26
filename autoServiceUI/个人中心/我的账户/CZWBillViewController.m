
//
//  CZWBillViewController.m
//  autoService
//
//  Created by bangong on 16/4/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBillViewController.h"

@interface BillCell : UITableViewCell

-(void)setDictionary:(NSDictionary *)dictionary;
@end

@implementation BillCell
{
    UILabel *titleLabel;
    UILabel *dateLabel;
    UILabel *moneyLabel;
    UIView  *lineView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:12];
        
        moneyLabel = [[UILabel alloc] init];
        moneyLabel.font = [UIFont systemFontOfSize:18];
        
        lineView = [LHController createBackLineWithFrame:CGRectZero];
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:moneyLabel];
        [self.contentView addSubview:lineView];
    
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
    
        }];
        
        [dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.bottom).offset(5);
        }];
        
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(dateLabel.bottom).offset(15);
            make.bottom.equalTo(0);
            make.size.equalTo(CGSizeMake(WIDTH, 1));
        }];
        
        [moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.centerY.equalTo(0);
        }];
    }
    
    return self;
}

-(void)setDictionary:(NSDictionary *)dictionary{
    titleLabel.text = dictionary[@"font"];
    dateLabel.text = dictionary[@"date"];
    moneyLabel.text = dictionary[@"money"];
   
    if ([moneyLabel.text hasPrefix:@"-"]) {
        moneyLabel.textColor = colorOrangeRed;
        titleLabel.textColor = colorOrangeRed;
    }else{
        moneyLabel.textColor = colorNavigationBarColor;
        titleLabel.textColor = colorNavigationBarColor;
    }
}

@end

#pragma mark - /////////////////////////////////////

@interface CZWBillViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
  
    NSInteger _count;
}
@end
@implementation CZWBillViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    self.title = @"账单";
    [self createLeftItemBack];
    [self createTableView];
    
    _count = 1;
    [self loadData];
}

-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:expert_billdetial,[CZWManager manager].roleId,self.acid,_count];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [hud hideAnimated:YES];
        [_tableView.mj_footer endRefreshing];
        if ([responseObject count] == 0) {
             [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        for (NSDictionary *dict in responseObject) {
            [_dataArray addObject:dict];
        }
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [_tableView.mj_footer endRefreshing];
    }];
}


-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
    if (!cell) {
        cell = [[BillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
      //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setDictionary:_dataArray[indexPath.row]];
    return cell;
    
}

@end
