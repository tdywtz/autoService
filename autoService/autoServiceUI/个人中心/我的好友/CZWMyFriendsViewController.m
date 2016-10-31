//
//  CZWMyFriendsViewController.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWMyFriendsViewController.h"
#import "CZWMyFriendsExpertCell.h"
#import "CZWMyFriendsuserCell.h"
#import "CZWMyFriendsToolbar.h"
#import "CZWUserInformationViewController.h"
#import "CZWExpertInformationViewController.h"
#import "CZWNewsFriendsViewController.h"
#import "CZWChatViewController.h"


@interface CZWMyFriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_expertArray;
    NSMutableArray *_userArray;
    CZWMyFriendsToolbar *_toolbar;
    UIRefreshControl *refresh;
}
@property (nonatomic,assign) friendsStyle style;
@end

@implementation CZWMyFriendsViewController

-(void)free{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadData:(BOOL)prograss friendsStyle:(friendsStyle)style{

    MBProgressHUD *hud;
    if (prograss) {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    if (style == friendsStyleExpert) {
        [CZWHttpModelResults requestFriendsListWithUserId:[CZWManager manager].roleId type:[CZWManager manager].userType friendsType:USERTYPE_EXPERT success:^(NSArray<__kindof CZWChatUserInfo *> *infos) {
            if (infos) {
                _expertArray = [NSMutableArray arrayWithArray:infos];
            }
            [hud hideAnimated:YES];
            [_tableView reloadData];
        } failure:^(NSError *errot) {
            
            [hud hideAnimated:YES];
        }];

    }else{
        
        [CZWHttpModelResults requestFriendsListWithUserId:[CZWManager manager].roleId type:[CZWManager manager].userType friendsType:USERTYPE_USER success:^(NSArray<__kindof CZWChatUserInfo *> *infos) {
            if (infos) {
                _userArray = [NSMutableArray arrayWithArray:infos];
            }
            [hud hideAnimated:YES];
            [_tableView reloadData];
        } failure:^(NSError *errot) {
            
            [hud hideAnimated:YES];
        }];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"我的好友";
    _expertArray = [[NSMutableArray alloc] init];
    _userArray = [[NSMutableArray alloc] init];
    self.style = friendsStyleExpert;
    
    [self createLeftItemBack];
    [self createTabelView];
    [self loadData:YES friendsStyle:friendsStyleExpert];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [refresh endRefreshing];
    _toolbar.unMessageView.hidden = !([[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_EXPERT] ||[[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_USER]);
}

-(void)createTabelView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refresh];
    
    
    _toolbar = [[CZWMyFriendsToolbar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    _tableView.tableHeaderView = _toolbar;
  
    __weak typeof(&*self) __blockSelf = self;
    [_toolbar whenCut:^(NSInteger index) {
        if (index == 0) {
            __blockSelf.style = friendsStyleExpert;
            
            [_tableView reloadData];
        }else{
            __blockSelf.style = friendsStyleUser;
            [_tableView reloadData];
        }
        [__blockSelf loadData:NO friendsStyle:self.style];
    }];
  

    [_toolbar addFriends:^{
         CZWNewsFriendsViewController *news = [[CZWNewsFriendsViewController alloc] init];
        news.addFriend = ^{
            [__blockSelf loadData:NO friendsStyle:__blockSelf.style];
        };
        [__blockSelf.navigationController pushViewController:news animated:YES];
    }];
}


#pragma mark - 刷新
- (void)refreshAction{
    
    __weak __typeof(self)weakSelf = self;
    if (self.style == friendsStyleExpert) {

            [refresh endRefreshing];
            [weakSelf loadData:NO friendsStyle:friendsStyleExpert];

    }else{

            [refresh endRefreshing];
            [weakSelf loadData:NO friendsStyle:friendsStyleUser];
    }
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
    if (self.style == friendsStyleExpert) {
       return  _expertArray.count;
    }else{
         return _userArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    if (self.style == friendsStyleExpert) {
        CZWMyFriendsExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expertcell"];
        if (!cell) {
            cell = [[CZWMyFriendsExpertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expertcell"];
            // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell clickImage:^(NSString *ID , NSString *RID) {
                
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (ID) {
                    CZWExpertInformationViewController *info = [[CZWExpertInformationViewController alloc] init];
                    info.eid = ID;
                    [strongSelf.navigationController pushViewController:info animated:YES];
                }else{
                    [CZWHttpModelResults requestChatUserInfoWithUserId:RID success:^(CZWChatUserInfo *userInfo) {
                        CZWExpertInformationViewController *info = [[CZWExpertInformationViewController alloc] init];
                        info.eid = userInfo.seviceId;
                        [strongSelf.navigationController pushViewController:info animated:YES];
                    }];
                }
                
            }];
        }
       
        cell.userInfo = _expertArray[indexPath.row];
        return cell;
    }
    
    CZWMyFriendsuserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"usercell"];
    if (!cell) {
        cell = [[CZWMyFriendsuserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"usercell"];
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell clickImage:^(NSString *ID , NSString *RID) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (ID) {
                CZWUserInformationViewController *info = [[CZWUserInformationViewController alloc] init];
                info.userID = ID;
                [strongSelf.navigationController pushViewController:info animated:YES];
            }else{
                [CZWHttpModelResults requestChatUserInfoWithUserId:RID success:^(CZWChatUserInfo *userInfo) {
                    CZWUserInformationViewController *info = [[CZWUserInformationViewController alloc] init];
                    info.userID = userInfo.seviceId;
                    [strongSelf.navigationController pushViewController:info animated:YES];
                }];
            }
            
        }];
    }
    cell.userInfo = _userArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == friendsStyleExpert) {
        CZWChatUserInfo *info = _expertArray[indexPath.row];
       //新建一个聊天会话View Controller对象
        CZWChatViewController *chat = [[CZWChatViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = info.userId;
        //设置聊天会话界面要显示的标题
        chat.title =info.userName;
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }else{
        CZWChatUserInfo *info = _userArray[indexPath.row];
        CZWChatViewController *chat = [[CZWChatViewController alloc]init];
        chat.conversationType = ConversationType_PRIVATE;
        chat.targetId = info.userId;
        chat.title =info.userName;
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZWChatUserInfo *info  = nil;
    NSString *type = nil;
    if (self.style == friendsStyleExpert) {
        info = _expertArray[indexPath.row];
        type = USERTYPE_EXPERT;
        [_expertArray removeObject:info];
    }else{
        info = _userArray[indexPath.row];
        type = USERTYPE_USER;
        [_userArray removeObject:info];
    }
    [[CZWFmdbManager manager] deleteFromFriendsWithUserId:info.userId];
    [_tableView reloadData];
 
    NSDictionary *dict = @{
                           @"mySelfId":[CZWManager manager].roleId,
                           @"mySelfType":[CZWManager manager].userType,
                           @"friendId":info.seviceId,
                           @"friendType":type
                           };

    [CZWAFHttpRequest POST:auto_delFriend parameters:dict success:^(id responseObject) {
        if (responseObject[@"scuess"]) {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    // [tableView setEditing:NO animated:YES];
    
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
