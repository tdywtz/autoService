//
//  CZWSearchTwoView.m
//  autoService
//
//  Created by bangong on 16/8/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWSearchTwoView.h"
#import "CZWComprehensiveInformationViewController.h"
#import "CZWSearchEnterpriseCell.h"

@interface CZWSearchTwoView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CZWSearchTwoView
{
    UITableView *_tabelView;
    NSArray     *_dataArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    _tabelView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    _tabelView.tableFooterView = [UIView new];
    [self addSubview:_tabelView];
}

- (void)loadData{
    [MBProgressHUD hideHUDForView:self animated:YES];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@&bid=%@",auto_fac_list,self.bid];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {

        [MBProgressHUD hideHUDForView:self animated:YES];
        _dataArray = [responseObject[@"rel"] copy];
        [_tabelView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    CZWSearchEnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
    if (!cell) {
        cell = [[CZWSearchEnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    cell.titleLabel.text = _dataArray[indexPath.row][@"minBrandName"];

    return cell;

}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        CZWComprehensiveInformationViewController *comprehensive = [[CZWComprehensiveInformationViewController alloc] init];
        NSDictionary *dict = _dataArray[indexPath.row];
        comprehensive.fid = dict[@"fid"];
        [self.parentViewController.navigationController pushViewController:comprehensive animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
