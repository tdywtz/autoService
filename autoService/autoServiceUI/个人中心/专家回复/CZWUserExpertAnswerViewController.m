//
//  CZWExpertAnswerViewController.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserExpertAnswerViewController.h"
#import "CZWUserExpertAnswerCell.h"
#import "CZWAppealDetailsViewController.h"

@interface CZWUserExpertAnswerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    NSInteger _count;
    BOOL openOne;
}
@end

@implementation CZWUserExpertAnswerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"专家回复";
        _count = 1;
        _dataArray = [[NSMutableArray alloc] init];
        openOne = YES;
    }
    return self;
}

-(void)loadData{
    MBProgressHUD *hud;
    if (openOne) {
         hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        openOne = NO;
    }
   
    [CZWAFHttpRequest requestReplyListWithUid:[CZWManager manager].roleId type:[CZWManager manager].userType  page:_count success:^(id responseObject) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [hud hideAnimated:YES];
 
        if ([responseObject count] == 0){
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        if ([responseObject firstObject][@"error"]) {
           // refreshFootView.noData = YES;
        }else{
            if (_count == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dict in responseObject) {
                CZWReplyModel *model = [[CZWReplyModel alloc] init];
           
                model.replyId       = dict[@"id"];
                model.uid           = dict[@"uid"];
                model.uname         = dict[@"uname"];
                model.mobile        = dict[@"mobile"];
                model.score         = dict[@"score"];
                model.complete_num  = dict[@"complete_num"];
                model.city          = dict[@"city"];
                model.title         = dict[@"title"];
                model.content       = dict[@"content"];
                model.isshow        = dict[@"isshow"];
                model.date          = dict[@"date"];
                model.iconUrl       = dict[@"headpic"];
                model.cpid          = dict[@"cpid"];
                model.modelName     = dict[@"models"];
                [_dataArray addObject:model];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
     
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        [hud hideAnimated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    [self createLeftItemBack];
    [self createRightItem];
    [self createTableView];
    
    [self loadData];
    
     [[CZWManager manager] setUnreadMessageOfReply:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"清空"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    [CZWAFHttpRequest requestEmptyReplyWithUid:[CZWManager manager].roleId type:[CZWManager manager].userType success:^(id responseObject) {
        if (responseObject[0][@"error"]) {
            [CZWAlert alertDismiss:responseObject[0][@"error"]];
        }else{
            [CZWAlert alertDismiss:responseObject[0][@"scuess"]];
            [_dataArray removeAllObjects];
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
}

#pragma mark - 呼叫等待
-(void)callDivertPhoneNumber:(NSString *)phoneNumber Name:(NSString *)name{
    CZWActionSheet *sheet = [[CZWActionSheet alloc] initWithArray:@[[NSString stringWithFormat:@"%@的电话：%@",name,phoneNumber],@"取消"]];
    sheet.telephone = YES;
    __weak UIApplication *app = [UIApplication sharedApplication];
    [sheet choose:^(CZWActionSheet *actionSheet, NSInteger selectedIndex) {
        __strong UIApplication *stongApp = app;
        if (selectedIndex == 0) {
            [stongApp openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
        }
    }];
    [sheet show];
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
    
    CZWUserExpertAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CZWUserExpertAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         __weak __typeof(self)weakSelf = self;
        [cell callDivert:^(NSString *phoneNumber, NSString *name) {
           
            [weakSelf callDivertPhoneNumber:phoneNumber Name:name];
        }];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWReplyModel *model = _dataArray[indexPath.row];
    return 100+[model.content calculateTextSizeWithFont:[UIFont systemFontOfSize:[LHController setFont]-4] Size:CGSizeMake(WIDTH-80, 100)].height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak __typeof(self)weakSelf = self;
    CZWReplyModel *model = _dataArray[indexPath.row];
    if (![model.isshow boolValue]) {
        [weakSelf showReply:model.replyId];
        model.isshow = @"1";
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    details.cpid = model.cpid;
    details.targetUid = [CZWManager manager].roleId;
    details.targetUname = [CZWManager manager].roleName;
  //  details.moveEdgeInsets = YES;
    details.scrollSting = [NSString stringWithFormat:@"#%@",model.uid];
    [self.navigationController pushViewController:details animated:YES];
}

-(void)showReply:(NSString *)replyId{
    [CZWAFHttpRequest requestShowReplyWithId:replyId success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
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
