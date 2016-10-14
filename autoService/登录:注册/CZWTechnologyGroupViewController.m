//
//  CZWTechnologyGroupViewController.m
//  autoService
//
//  Created by bangong on 16/8/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWTechnologyGroupViewController.h"

@interface CZWTechnologyGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    UITableView *_tabelView;
    NSArray *_dataArray;
}
@end

@implementation CZWTechnologyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"技术组别";

    [self createLeftItemBack];

    _dataArray = @[@{@"value":@"1",@"title":@"发动机"},@{@"value":@"2",@"title":@"底盘"},
                   @{@"value":@"3",@"title":@"电气"},@{@"value":@"4",@"title":@"车身"},
                   @{@"value":@"5",@"title":@"政策法规"},
                   ];
    _tabelView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.tableFooterView = [UIView new];
    _tabelView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:_tabelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.textLabel.text = _dataArray[indexPath.row][@"title"];
    return cell;

}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _dataArray[indexPath.row];
    if (self.clickBlock) {
        self.clickBlock(dict[@"value"],dict[@"title"]);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
