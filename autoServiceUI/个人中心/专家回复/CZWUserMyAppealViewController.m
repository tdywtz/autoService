//
//  CZWUserMyAppealViewController.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserMyAppealViewController.h"
#import "CZWUserMyAppealCell.h"
#import "CZWAppealViewController.h"
#import "CZWAppealDetailsViewController.h"
#import "CZWEvaluateViewController.h"
#import "CZWAppealViewController.h"
#import "CZWCheckProposalViewController.h"
#import "CZWWordViewController.h"

@interface CZWUserMyAppealViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    /**
     *  -->计算高度
     */
    CZWUserMyAppealCell *mycell;
    
    /**
     *   判断是否释放定时器
     */
    BOOL isdismiss;
    BOOL progress;
}
@end

@implementation CZWUserMyAppealViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        mycell = [[CZWUserMyAppealCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];

        self.title = @"我的申诉";
    }
    return self;
}
-(void)loadData{
    MBProgressHUD *hud = nil;
    if (progress) {
        progress = NO;
         hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
   
    
    [CZWAFHttpRequest requestMyAppealStateWithUid:[CZWManager manager].roleId success:^(id responseObject) {
       
        if (hud) {
            [hud hideAnimated:YES];
        }
        
        
        if ([responseObject count] == 0)return ;
        
        if (responseObject[0][@"error"]) {
            
        }else{
            [_dataArray removeAllObjects];
            for (NSDictionary *dict in responseObject) {
                CZWMyAppealModel *model = [[CZWMyAppealModel alloc] init];
               
                model.button        = dict[@"button"];
                model.cname         = dict[@"cname"];
                model.content       = dict[@"content"];
                model.cpid          = dict[@"cpid"];
                model.date          = dict[@"date"];
               
                model.eid           = dict[@"eid"];
                model.factoryreply  = dict[@"factoryreply"];
                model.modelname     = dict[@"modelname"];
                model.prompt        = dict[@"prompt"];
                model.stepArray     = [dict[@"step"] componentsSeparatedByString:@"-"];
               
                model.stepid        = dict[@"stepid"];
                model.steps         = dict[@"steps"];
                model.title         = dict[@"title"];
                model.waitdate      = dict[@"waitdate"];
                model.num           = dict[@"num"];
             
                mycell.model     = model;
                [mycell deleteTimer];
               
                [_dataArray addObject:model];
            }
            
            [_tableView reloadData];
        }
   
    } failure:^(NSError *error) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    progress = YES;
    [self createLeftItemBack];
    [self createTableView];
 
     [[CZWManager manager] setUnreadMessageOfAppeal:NO];
}

-(void)notificationLoadData{
    __weak __typeof(self)weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if ([[CZWManager manager] unreadMessageOfAppeal]) {
            [weakSelf loadData];
        }

    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    isdismiss = NO;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLoadData) name:NOTIFICATIONMESSAGE object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isdismiss = YES;
    [_tableView reloadData];
     [[NSNotificationCenter defaultCenter] removeObserver:self];     
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadData];
}


-(void)createTableView{
    
    CGRect frame = self.view.frame;
    //frame.size.height = frame.size.height-50;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
     [self.view addSubview:_tableView];
}

-(void)createFootView{
    UIButton *footButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(footButtonClick) Font:15 Text:@"我要申诉"];
    [footButton setImage:[UIImage imageNamed:@"user_willApplear"] forState:UIControlStateNormal];
    [footButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [footButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.view addSubview:footButton];
    [footButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(40);
    }];
}

-(void)footButtonClick{
    CZWAppealViewController *appeal = [[CZWAppealViewController alloc] init];
    [self.navigationController pushViewController:appeal animated:YES];
}

#pragma mark - 删除申诉
-(void)deleteAppeal:(CZWUserMyAppealCell *)cell{
    
    NSString *url = [NSString stringWithFormat:user_appealDelete,cell.model.cpid];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        if([responseObject count]==0) return;
        
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"scuess"]) {
            NSIndexPath *path = [_tableView indexPathForCell:cell];
            [_dataArray removeObjectAtIndex:path.row];
            [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [CZWAlert alertDismiss:dict[@"error"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
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
    
    CZWUserMyAppealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myappealcell"];
    if (!cell) {
        cell = [[CZWUserMyAppealCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myappealcell"];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        __weak __typeof(self)weakSelf = self;
        [cell gestureBlock:^(CZWUserMyAppealCell *theCell, NSString *title) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([title isEqualToString:@"删除"]) {
                [strongSelf deleteAppeal:cell];
            }else if ([title isEqualToString:@"修改"]){
                CZWAppealViewController *appeal = [[CZWAppealViewController alloc] init];
                appeal.revise = YES;
                appeal.cpid = theCell.model.cpid;
                [strongSelf.navigationController pushViewController:appeal animated:YES];
            }else{
                [strongSelf manageState:title model:(CZWMyAppealModel *)theCell.model controller:strongSelf];
            }
        }];
    }
 
    cell.model = _dataArray[indexPath.row];
    if (isdismiss) {
        [cell deleteTimer];
    }
    return cell;
}

-(void)manageState:(NSString *)string model:(CZWMyAppealModel *)model controller:(CZWUserMyAppealViewController *)weakSelf{
    if ([string isEqualToString:@"满意并对厂家评价"]) {
        
        CZWEvaluateViewController *evaluate = [[CZWEvaluateViewController alloc] init];
        evaluate.tostyle = EvaluateToManufactor;
        evaluate.cpid = model.cpid;
        [evaluate success:^(NSString *cpid) {
            [weakSelf loadData];
        }];
        [weakSelf.navigationController pushViewController:evaluate animated:YES];
    }else if ([string isEqualToString:@"不满意，申请咨询专家"]){
        [weakSelf facsolvedNot:model.cpid state:@"2"];
        
    }else if ([string isEqualToString:@"对厂家进行评价"]){
        
        CZWEvaluateViewController *evaluate = [[CZWEvaluateViewController alloc] init];
        evaluate.tostyle = EvaluateToManufactorResult;
        evaluate.cpid = model.cpid;
        [evaluate success:^(NSString *cpid) {
            [weakSelf loadData];
        }];
        [weakSelf.navigationController pushViewController:evaluate animated:YES];
    
        
    }else if ([string isEqualToString:@"采纳专家建议并对专家评价"]){
        
        CZWCheckProposalViewController *details = [[CZWCheckProposalViewController alloc] init];
        details.cpid = model.cpid;
        [weakSelf.navigationController pushViewController:details animated:YES];
        
    }else if ([string isEqualToString:@"查看专家意见报告"]){
     
        CZWWordViewController *word = [[CZWWordViewController alloc] init];
        word.eid = model.eid;
        word.cpid = model.cpid;
        [weakSelf.navigationController pushViewController:word animated:YES];
        
    }
}


//厂家解决是否满意
-(void)facsolvedNot:(NSString *)cpid state:(NSString *)state{
  
    [CZWAFHttpRequest requestFacsolvedNotWithUid:[CZWManager manager].roleId cpid:cpid state:state success:^(id responseObject) {
        if ([responseObject count] == 0) {
            return ;
        }
        if (responseObject[0][@"error"]) {
            [CZWAlert alertDismiss:responseObject[0][@"error"]];
        }else{
            [CZWAlert alertDismiss:responseObject[0][@"scuess"]];
            [self loadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CZWAppealModel *model = _dataArray[indexPath.row];
//   
//    return model.cellHeight;
//}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 200;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWUserMyAppealCell *CELL = (CZWUserMyAppealCell *)cell;
    [CELL deleteTimer];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    CZWAppealModel * model = _dataArray[indexPath.row];
    details.cpid = model.cpid;
    details.targetUid = [CZWManager manager].roleId;
    details.targetUname = [CZWManager manager].roleName;
    [self.navigationController pushViewController:details animated:YES];
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
