//
//  CZWExpertMyAssistViewController.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertMyAssistViewController.h"
#import "CZWExpertMyAssistCell.h"
#import "CZWAppealDetailsViewController.h"

@interface CZWExpertMyAssistViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _count;
}

@end

@implementation CZWExpertMyAssistViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"我的建议";
        _count = 1;
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadData:(BOOL)prograss{
    //加载提示框
    MBProgressHUD *hud;
    if (prograss) {
      hud =  [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    [CZWHttpModelResults requestHelpModelsWithExpertId:[CZWManager manager].roleId  count:_count result:^(NSArray *appealModels) {
        [hud hideAnimated:YES];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        if (appealModels.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_count == 1) {
            [_dataArray removeAllObjects];
           
        }
        for (CZWAppealModel *model in appealModels) {
         
            [_dataArray addObject:model];
        }
   
        [_tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self createLeftItemBack];
    [self createTableView];
   [[CZWManager manager] setUnreadMessageOfAppeal:NO];
    [self loadData:YES];
    
}
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData:NO];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData:NO];
    }];
}

#pragma mark - 呼叫等待
-(void)callDivertPhoneNumber:(NSString *)phoneNumber Name:(NSString *)name{

    NSMutableString *string = [[NSMutableString alloc] initWithString:phoneNumber];
    if (phoneNumber.length == 11) {
        [string insertString:@"-" atIndex:7];
        [string insertString:@"-" atIndex:3];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"呼叫", nil];
    alert.tag = 100;
    [alert show];
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
    
    CZWExpertMyAssistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpcell"];
    if (!cell) {
        cell = [[CZWExpertMyAssistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"helpcell"];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak __typeof(self)weakSelf = self;
        [cell callDivert:^(NSString *phoneNumber, NSString *name) {
            [weakSelf callDivertPhoneNumber:phoneNumber Name:name];
        }];
        
        [cell openCell:^(CZWExpertMyAssistCell *theCell) {
              NSIndexPath *path =   [_tableView indexPathForCell:theCell];
            theCell.model.cellOpen = !theCell.model.cellOpen;
            [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }

    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealModel *model = _dataArray[indexPath.row];
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    details.targetUname = model.name;
    details.targetUid = model.uid;
    details.cpid = model.cpid;
    [self.navigationController pushViewController:details animated:YES];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[alertView.title stringByReplacingOccurrencesOfString:@"-" withString:@""]]];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
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
