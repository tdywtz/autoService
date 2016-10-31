//
//  CZWNewsFriendsViewController.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWNewsFriendsViewController.h"
#import "CZWNewsExpertFriendsCell.h"
#import "CZWNewsUserFriendsCell.h"

@interface CZWNewsFriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation CZWNewsFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新的朋友";
    _dataArray = [[NSMutableArray alloc] init];
    [self createLeftItemBack];
    [self createTabelView];
    [self loadData];
   
    [[CZWManager manager] setUnreadMessageOfAddFriends:NO type:USERTYPE_USER];
    [[CZWManager manager] setUnreadMessageOfAddFriends:NO type:USERTYPE_EXPERT];

}

-(void)loadData{
    NSArray *array = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_SYSTEM)]];
    [_dataArray removeAllObjects];
   
    for (RCConversationModel *model in array) {
        if ([model.lastestMessage isKindOfClass:[RCContactNotificationMessage class]]) {
           
            RCContactNotificationMessage *message = (RCContactNotificationMessage *)model.lastestMessage;

            if (message.extra) {
          
                NSString *jsonSring = [message.extra stringByReplacingOccurrencesOfString:@"|" withString:@"\""];
                //jsonSring = [NSString stringWithFormat:@"{%@}",jsonSring];
                NSData *data = [jsonSring dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
               
            
                    if ([dict[@"type"] isEqualToString:USERTYPE_EXPERT]) {
                        CZWNewFriendsModel *friendsModel = [[CZWNewFriendsModel alloc] init];
                        CZWChatUserInfo *info = [[CZWChatUserInfo alloc] init];
                        info.userId = message.sourceUserId;
                        info.userName = dict[@"name"];
                        info.iconUrl = dict[@"iconUrl"];
                        info.score = dict[@"score"];
                        info.complete_num = dict[@"complete_num"];
                        info.type = USERTYPE_EXPERT;
                        info.seviceId = dict[@"uid"];
                        
                        friendsModel.userInfo = info;
                        friendsModel.operation = message.operation;
                        friendsModel.content = message.message;
                        friendsModel.targetId = model.targetId;
                        friendsModel.receivedStatus = model.receivedStatus;
                        [_dataArray addObject:friendsModel];
                    }else if ([dict[@"type"] isEqualToString:USERTYPE_USER]) {
                        CZWNewFriendsModel *friendsModel = [[CZWNewFriendsModel alloc] init];
                        CZWChatUserInfo *info = [[CZWChatUserInfo alloc] init];
                        info.userId = message.sourceUserId;
                        info.userName = dict[@"name"];
                        info.iconUrl = dict[@"iconUrl"];
                        info.type = USERTYPE_USER;
                        info.seviceId = dict[@"uid"];
                        
                        friendsModel.userInfo = info;
                        friendsModel.targetId = model.targetId;
                        friendsModel.operation = message.operation;
                        friendsModel.content = message.message;
                        friendsModel.receivedStatus = model.receivedStatus;
                        [_dataArray addObject:friendsModel];
                    }
                
            }
        }
    }
    
    [_tableView reloadData];
}


-(void)createTabelView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
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
   
    CZWNewFriendsModel *model = _dataArray[indexPath.row];
    if ([model.userInfo.type isEqualToString:USERTYPE_EXPERT]) {
        CZWNewsExpertFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expertcell"];
        if (!cell) {
            cell = [[CZWNewsExpertFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expertcell"];
            // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell clickButton:^(NSString *title, CZWNewFriendsModel *model) {
                [self func:title model:model];
            }];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;
    }else{
        CZWNewsUserFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"usercell"];
        if (!cell) {
            cell = [[CZWNewsUserFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"usercell"];
            // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell clickButton:^(NSString *title, CZWNewFriendsModel *model) {
                [self func:title model:model];
            }];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;

    }
}

-(void)func:(NSString *)state model:(CZWNewFriendsModel *)model{
  
    if ([state isEqualToString:@"同意"]) {
        NSDictionary *jsonDict;
        if ([[CZWManager manager].RoleType isEqualToString:isExpertLogin]) {
            jsonDict = @{@"type":@"2",@"uid":[CZWManager manager].roleId,@"name":[CZWManager manager].roleName,
                         @"score":[CZWManager manager].score,@"complete_num":[CZWManager manager].complete_num,
                         @"content":@"我通过了你的好友验证请求",@"iconUrl":[CZWManager manager].roleIconImage};
        }else{
            jsonDict = @{@"type":@"1",@"uid":[CZWManager manager].roleId,@"name":[CZWManager manager].roleName,
                         @"content":@"我通过了你的好友验证请求",@"iconUrl":[CZWManager manager].roleIconImage};
        }
    
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
 
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"|"];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
       // jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[CZWManager manager].roleId forKey:@"uid"];
        [dict setObject:[CZWManager manager].userType forKey:@"utype"];
        [dict setObject:[CZWManager manager].rongyunID forKey:@"fromUserId"];
        
        [dict setObject:model.userInfo.seviceId forKey:@"fid"];
        [dict setObject:model.userInfo.type forKey:@"ftype"];
        [dict setObject:model.targetId forKey:@"toUserId"];
    
        [dict setObject:jsonString forKey:@"extra"];
     
        __weak __typeof(self)weakSelf = self;
        [CZWAFHttpRequest POST:auto_agreeAddFriends parameters:dict success:^(id responseObject) {
            if ([responseObject  count] == 0) {
                return ;
            }
            NSDictionary *dict = [responseObject firstObject];
            if (dict[@"scuess"]) {
                [CZWAlert alertDismiss:dict[@"scuess"]];
                [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:model.targetId];
                [weakSelf loadData];
                if (weakSelf.addFriend) {
                    weakSelf.addFriend();
                }
            }else{
                [CZWAlert alertDismiss:dict[@"error"]];
            }

        } failure:^(NSError *error) {
             [CZWAlert alertDismiss:@"发送失败"];
        }];
    
        /**
         *  添加到好友列表
         */
      //  [[CZWManager manager] addFriendsWithId:model.userInfo.userId type:FriendTypeYes];
    }
}


//-(void)sendMessage:(CZWNewFriendsModel *)model{
//    NSDictionary *jsonDict;
//    if ([[CZWManager manager].RoleType isEqualToString:isExpertLogin]) {
//        jsonDict = @{@"type":@"2",@"name":[CZWManager manager].roleName,
//                     @"score":[CZWManager manager].score,@"complete_num":[CZWManager manager].complete_num,
//                     @"content":@"我已经添加你为好友",@"iconUrl":[CZWManager manager].roleIconImage};
//    }else{
//        jsonDict = @{@"type":@"1",@"name":[CZWManager manager].roleName,
//                     @"content":@"我已经添加你为好友",@"iconUrl":[CZWManager manager].roleIconImage};
//    }
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    RCContactNotificationMessage *mes = [RCContactNotificationMessage notificationWithOperation:ContactNotificationMessage_ContactOperationAcceptResponse sourceUserId:[CZWManager manager].rongyunID targetUserId:model.targetId message:@"我已经添加你为好友" extra:jsonString];
//    
//    [[RCIMClient sharedRCIMClient] sendStatusMessage:ConversationType_PRIVATE targetId:model.targetId content:mes success:^(long messageId) {
//       
//        [[RCIMClient sharedRCIMClient] deleteMessages:@[@(messageId)]];
//    } error:^(RCErrorCode nErrorCode, long messageId) {
//       [[RCIMClient sharedRCIMClient] deleteMessages:@[@(messageId)]];
//    }];
//}
//
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWNewFriendsModel *model = _dataArray[indexPath.row];
    if ([model.userInfo.type isEqualToString:USERTYPE_EXPERT]) return 80;
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
   // [tableView setEditing:NO animated:YES];
    CZWNewFriendsModel *model = _dataArray[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self loadData];
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
