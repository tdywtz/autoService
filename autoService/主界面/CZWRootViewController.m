//
//  CZWRootViewController.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWRootViewController.h"
#import "CZWRootToolBar.h"
#import "CZWUserCenterViewController.h"
#import "CZWExpertCenterViewController.h"
#import "CZWRootTableViewCell.h"
#import "CZWCityChooseView.h"
#import "CZWAppealStateView.h"
#import "CZWBrandChooseView.h"
#import "CZWAppealViewController.h"
#import "CZWUserInformationViewController.h"
#import "CZWAppealDetailsViewController.h"
#import "CZWSearchHistoryViewController.h"
#import "AdvertisementView.h"

@interface CZWRootViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    CZWRootToolBar *_toolBar;
    UIButton *applearButton;
    
    CZWAppealStateView *stateView;
    CZWCityChooseView *cityView;
    CZWBrandChooseView *brandView;
    
    NSInteger _count;
    
    NSString *_type;//用户类型
    NSString *_step;//状态
    NSString *_cityId;//城市id
    NSString *_seriesId;//车系id
    
    UILabel *unreadLabel;//未读消息提示
    UIButton *leftItemButton;
    
    CZWRootTableViewCell *tempCell;
}
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) AdvertisementView *advertisement;
@end

@implementation CZWRootViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadData:(BOOL)prograss{
    MBProgressHUD *hud;
    if (prograss) {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    [CZWHttpModelResults requestAppealModelsWithType:_type step:_step cid:_cityId sid:_seriesId count:_count success:^(NSArray *appealModels) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [hud hideAnimated:YES];
        if (_count == 1) {
            [_dataArray removeAllObjects];
        }else{
            if (appealModels.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }

        for (CZWAppealModel *model in appealModels) {
            
            tempCell.model = model;
            model.cellHeight =  [tempCell viewHeight];
            [_dataArray addObject:model];
        }
        
        [_tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [hud hideAnimated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.advertisement = [[AdvertisementView alloc] init];
    self.advertisement.prasentViewController = self;
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.advertisement];
    [self.view addSubview:self.contentView];
    
    [self.advertisement makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.top.equalTo(64);
        make.height.equalTo(0);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(0);
        make.top.equalTo(self.advertisement.bottom);
    }];
    
    [self setting];
    [self createLeftItem];
    [self createRightItem];
    [self createToolBar];
    [self createTableView];
    [self createRefreshView];
    [self createApplearBurron];
    [self loadData:YES];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotification) name:NOTIFICATIONMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appForeground) name:AppWillEnterForeground object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self unreadMessageCount];
    [_advertisement loadGifImage];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [_advertisement loadGifImage];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


#pragma mark - 接收通知
-(void)appForeground{
     [_advertisement reloadData];
}

-(void)messageNotification{
    if (unreadLabel.hidden) {
        [self unreadMessageCount];
    }
}
/**
 *  未读消息提示
 */
-(void)unreadMessageCount{
   [CZWManager After:0.4 perform:^{
       int num = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
       if (num <= 0 && ![[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_USER]
           && ![[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_EXPERT]
           && ![[CZWManager manager] unreadMessageOfReply]
           && ![[CZWManager manager] unreadMessageOfAppeal]
           && ![[CZWManager manager] unreadMessageOfAccount]) {

           unreadLabel.hidden = YES;
       }else{
           unreadLabel.hidden = NO;
       }
   }];
}


-(void)createRefreshView{
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

-(void)setting{
    _dataArray = [[NSMutableArray alloc] init];
    _type = [CZWManager manager].userType;
    _count = 1;
    _step = @"99";
    _cityId = _seriesId = @"";
    self.title = @"用户申诉";
    tempCell = [[CZWRootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

-(void)createLeftItem{
 
    leftItemButton = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(leftItemClick) Text:nil];
    unreadLabel = [LHController createLabelWithFrame:CGRectZero Font:10 Bold:NO TextColor:[UIColor redColor] Text:nil];
    unreadLabel.layer.cornerRadius = 3;
    unreadLabel.layer.masksToBounds = YES;
    unreadLabel.hidden = YES;
    
    unreadLabel.backgroundColor = [UIColor redColor];
    [leftItemButton addSubview:unreadLabel];
    
    [unreadLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(6, 6));
    }];
    [leftItemButton setImage:[UIImage imageNamed:@"auto_userCenter"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
}

-(void)leftItemClick{
  //  [CZWAlert alertDismiss:@"asdf" controller:self];
    
    if ([[CZWManager manager].RoleType isEqualToString:isUserLogin]) {
        CZWUserCenterViewController *user = [[CZWUserCenterViewController alloc] init];
    
        [self.navigationController pushViewController:user animated:NO];
      
    }else{
       
        CZWExpertCenterViewController *expert = [[CZWExpertCenterViewController alloc] init];
      
        [self.navigationController pushViewController:expert animated:NO];
      
    }
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"auto_searchMirror"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    CZWSearchHistoryViewController *search = [[CZWSearchHistoryViewController alloc] init];
   
    [self.navigationController pushViewController:search animated:YES];
   
   
}

#pragma nark - toolbar
-(void)createToolBar{
 
    _toolBar = [[CZWRootToolBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
    [self.contentView addSubview:_toolBar];
    
    __weak __typeof(self)weakSelf = self;
    [_toolBar chooseClickButton:^(UIButton *button, NSInteger index, buttonStyle style) {
        if (style == buttonStyleNomal) {
            [weakSelf showChoooseView:button Index:index weakSelf:weakSelf];
         
        }else{
            switch (index) {
                case 1:
                {//全部
                    _step = @"99";
                    break;
                }
                  
                case 2:
                {
                    _cityId = @"";
                    break;
                }
  
                case 3:
                {
                    _seriesId = @"";
                    break;
                }
  
                default:
                    break;
            }
            _count = 1;
            [self loadData:NO];
        }
    }];
}

#pragma mark - 选择列表
-(void)showChoooseView:(UIButton *)button Index:(NSInteger)index weakSelf:(CZWRootViewController *)weakSelf{
    
    CGRect frame = _tableView.frame;
    frame.size.height = HEIGHT - _tableView.frame.origin.y-64-CGRectGetHeight(self.advertisement.frame);
    frame.origin.y = HEIGHT;
    if (index == 1) {
        //申述处理状态
        cityView.frame = frame;
        brandView.frame = frame;
        cityView.isshow = NO;
        brandView.isshow = NO;
        
        if (stateView == nil) {
            stateView = [[CZWAppealStateView alloc] initWithFrame:frame];
            [stateView chooseResult:^(NSString *text, NSString *ID) {
                
                [_toolBar setTitle:text andButton:button];
                _step = ID;
                _count = 1;
                [weakSelf loadData:NO];
                
                stateView.frame = frame;
                stateView.isshow = NO;
            }];
            [weakSelf.contentView addSubview:stateView];
        }
        if (stateView.isshow) {
             frame.origin.y = HEIGHT;
            [UIView animateWithDuration:0.2 animations:^{
               
                stateView.frame = frame;
            }];
        }else{
             frame.origin.y = _tableView.frame.origin.y;
            [UIView animateWithDuration:0.2 animations:^{
               
                stateView.frame = frame;
            }];
        }
        stateView.isshow = !stateView.isshow;
        
    }else if (index == 2){
        //城市选择
        stateView.frame = frame;
        brandView.frame = frame;
        stateView.isshow = NO;
        brandView.isshow = NO;
        
        if (cityView == nil) {
            
            cityView = [[CZWCityChooseView alloc] initWithFrame:frame];
            [cityView returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
                
                [_toolBar setTitle:cName andButton:button];
                _cityId = cid;
                _count = 1;
                [weakSelf loadData:NO];
                
                cityView.frame = frame;
                cityView.isshow = NO;
                
            }];
            [self.contentView addSubview:cityView];
        }
        if (cityView.isshow) {
              frame.origin.y = HEIGHT;
            [UIView animateWithDuration:0.2 animations:^{
                cityView.frame = frame;
            }];
        }else{
              frame.origin.y = _tableView.frame.origin.y;
            [UIView animateWithDuration:0.2 animations:^{
                cityView.frame = frame;
            }];
        }
        cityView.isshow = !cityView.isshow;
        
    }else{
        //车系选择
        stateView.frame = frame;
        cityView.frame = frame;
        stateView.isshow = NO;
        cityView.isshow = NO;
        
        if (brandView == nil) {
            brandView = [[CZWBrandChooseView alloc] initWithFrame:frame];
            [brandView chooseResult:^(NSString *text, NSString *ID) {
                
                [_toolBar setTitle:text andButton:button];
                _seriesId = ID;
                _count = 1;
                [weakSelf loadData:NO];
                
                brandView.frame =  frame;
                brandView.isshow = NO;

            }];
            [weakSelf.contentView addSubview:brandView];
        }
        if (brandView.isshow) {
              frame.origin.y = HEIGHT;
            [UIView animateWithDuration:0.2 animations:^{
                brandView.frame = frame;
            }];
        }else{
              frame.origin.y = _tableView.frame.origin.y;
            [UIView animateWithDuration:0.2 animations:^{
                brandView.frame = frame;
            }];
        }
        brandView.isshow = !brandView.isshow;
    }
}

#pragma mark - tableView
-(void)createTableView{
    CGFloat bottom = 0;
    if ([[CZWManager manager].RoleType isEqualToString:isUserLogin]) {
        bottom = 50;
    }
   // [self.view insertSubview:[[UIView alloc] initWithFrame:self.view.frame] atIndex:0];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 120;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableView];
 
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.top.equalTo(_toolBar.bottom);
        make.bottom.equalTo(-bottom);
    }];
}


#pragma mark - 申诉按钮
-(void)createApplearBurron{
    if ([[CZWManager manager].RoleType isEqualToString:isExpertLogin]) return;
    
    applearButton = [LHController createButtnFram:CGRectMake(10, HEIGHT-50, WIDTH-20, 40) Target:self Action:@selector(applearClick) Font:15 Text:@"我要申诉"];
    [applearButton setImage:[UIImage imageNamed:@"user_willApplear"] forState:UIControlStateNormal];
    [applearButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [applearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.contentView addSubview:applearButton];
    [applearButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-10);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(WIDTH-30, 40));
    }];
}


-(void)applearClick{
    CZWAppealViewController *complain = [[CZWAppealViewController alloc] init];
    [self.navigationController pushViewController:complain animated:YES];
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
    CZWRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rootcell"];
    if (!cell) {
        cell = [[CZWRootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        [cell oneselfcollect:^(CZWAppealModel *model, UIButton *button) {
            
        }];
        __weak __typeof(self)weakSelf = self;
        [cell individualInformation:^(CZWAppealModel *model) {
            CZWUserInformationViewController *infomation  = [[CZWUserInformationViewController alloc] init];
            infomation.userID = model.uid;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.navigationController pushViewController:infomation animated:YES];
          
        }];
    }

    cell.model = _dataArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealModel *model = _dataArray[indexPath.row];
    return model.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    CZWAppealModel *model = _dataArray[indexPath.row];
    details.cpid = model.cpid;
    details.targetUid = model.uid;
    details.targetUname = model.name;
  
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
