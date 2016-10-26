//
//  CZWPromoteListViewController.m
//  autoService
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWPromoteListViewController.h"
#import "CZWPromoteWebViewController.h"

@interface PoromoteListCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@end

@implementation PoromoteListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = colorBlack;
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textColor = colorDeepGray;
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_dateLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
            make.right.equalTo(-15);
        }];
        
        [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.bottom).offset(10);
            make.bottom.equalTo(-15);
        }];
    }
    return self;
}

@end

#pragma nark -///
@interface CZWPromoteListViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_talbleView;
    NSMutableArray *_dataArray;
}

@end

@implementation CZWPromoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"促销信息";
    
    [self createLeftItemBack];
    
    [self createTableView];
    [self loadListData];
}

-(void)loadListData{
    MBProgressHUD *  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:auto_fac_prolist,self.fid,1];
    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        [hud hideAnimated:YES];
        _dataArray = responseObject[@"rel"];
        [_talbleView reloadData];
        
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}


-(void)createTableView{
    _talbleView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _talbleView.delegate = self;
    _talbleView.dataSource = self;
    _talbleView.estimatedRowHeight = 60;
    _talbleView.tableFooterView = [UIView new];
    [self.view addSubview:_talbleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PoromoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
    if (!cell) {
        cell = [[PoromoteListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.titleLabel.text  = dict[@"title"];
    cell.dateLabel.text = dict[@"date"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWPromoteWebViewController *web = [[CZWPromoteWebViewController alloc] init];
    web.ID = _dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:web animated:YES];
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
