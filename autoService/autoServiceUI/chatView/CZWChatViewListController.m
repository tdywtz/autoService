//
//  CZWChatViewListController.m
//  autoService
//
//  Created by bangong on 15/12/16.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWChatViewListController.h"
#import "CZWChatViewController.h"
#import "CZWChatListCell.h"
#import "CZWBasicPanNavigationController.h"


@interface CZWChatViewListController ()

//@property (nonatomic,strong) RCConversationModel *tempModel;

@end

@implementation CZWChatViewListController

-(void)viewDidLoad{
    
    [super viewDidLoad];
 
    self.title = @"聊天记录";
   // [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    [self createLeftItem];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    
    //聚合会话类型
    [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
    //设置tableView样式;]
    self.conversationListTableView.tableFooterView = [UIView new];
    
   // [self refreshConversationTableViewIfNeeded];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)createLeftItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 30);
    [button setImage:[UIImage imageNamed:@"bar_btn_returnt"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemBackClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)leftItemBackClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)didTapCellPortrait:(RCConversationModel *)model
{
    
}
//会话有新消息通知的时候显示数字提醒，设置为NO,不显示数字只显示红点
//-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    RCConversationModel *model= self.conversationListDataSource[indexPath.row];
//
//    if (model.conversationType == ConversationType_PRIVATE) {
//        ((RCConversationCell *)cell).isShowNotificationNumber = NO;
//    }
//
//}


- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__blockSelf.displayConversationTypeArray.count == 1 && [self.displayConversationTypeArray[0] integerValue]== ConversationType_DISCUSSION) {
            [__blockSelf refreshConversationTableViewIfNeeded];
        }
        
    });
}


- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    CZWChatViewController *conversationVC = [[CZWChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle
    ;

    [self.navigationController pushViewController:conversationVC animated:YES];
}

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
  
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if(model.conversationType == ConversationType_SYSTEM)
        {
            NSLog(@"custom");
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }

    return dataSource;
}

#pragma mark override
/**
 *  重写方法，点击tableView删除按钮触发事件
 *
 *  @param tableView    表格
 *  @param editingStyle 编辑样式
 *  @param indexPath    索引
 */
- (void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}


/**
 *  将要显示会话列表单元，可以有限的设置cell的属性或者修改cell, 子类重写该方法后可以实现在cell加载之前将修改的属性加载到tableView. 例如：setHeaderImagePortraitStyle
 *
 *  @param cell      cell
 *  @param indexPath 索引
 */
-(void)willDisplayConversationTableCell:(RCConversationBaseCell*)cell atIndexPath:(NSIndexPath *)indexPath{
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    RCConversationCell *cc = (RCConversationCell *)cell;
    cc.conversationTitle.textColor = colorOrangeRed;
    cc.conversationTitle.text = model.conversationTitle;//[NSAttributedString expertName:model.conversationTitle];
    UIImageView *imageview = (UIImageView * )cc.headerImageView;

    cc.conversationTitle.font = [UIFont systemFontOfSize:15];
    cc.messageCreatedTimeLabel.font = [UIFont systemFontOfSize:12];
    [CZWHttpModelResults requestChatUserInfoWithUserId:model.targetId success:^(CZWChatUserInfo *userInfo) {
        [CZWManager After:0.1 perform:^{

            if ([userInfo.type isEqualToString:USERTYPE_EXPERT]) {
                cc.conversationTitle.textColor = colorNavigationBarColor;
                cc.conversationTitle.attributedText = [NSAttributedString expertName:userInfo.userName];

                [imageview sd_setImageWithURL:[NSURL URLWithString:userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@""]];

                imageview.layer.cornerRadius = 22.5;
                imageview.layer.masksToBounds = YES;

            }else{

                [imageview sd_setImageWithURL:[NSURL URLWithString:userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@""]];

                cc.conversationTitle.text = userInfo.userName;
                cc.conversationTitle.textColor = colorYellow;
                imageview.layer.cornerRadius = 3;
                imageview.layer.masksToBounds = YES;
            }
        }];

    }];
}

//自定义cell
//-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//    
//    __block NSString *userName    = nil;
//    __block NSString *portraitUri = nil;
//    
//    __weak CZWChatViewListController *weakSelf = self;
//    此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
//    if (nil == model.extend) {
//        // Not finished yet, To Be Continue...
//        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
//        {
//            RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
//            if (_contactNotificationMsg.sourceUserId == nil) {
//                CZWChatListCell *cell = [[CZWChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
//                cell.lblDetail.text = @"好友请求";
//                [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
//                return cell;
//                
//            }
//            NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
//            if (_cache_userinfo) {
//                userName = _cache_userinfo[@"username"];
//                portraitUri = _cache_userinfo[@"portraitUri"];
//            } else {
//                NSDictionary *emptyDic = @{};
//                [[NSUserDefaults standardUserDefaults]setObject:emptyDic forKey:_contactNotificationMsg.sourceUserId];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
//                                      completion:^(RCUserInfo *user) {
//                                          if (user == nil) {
//                                              return;
//                                          }
//                                          RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
//                                          rcduserinfo_.name = user.name;
//                                          rcduserinfo_.userId = user.userId;
//                                          rcduserinfo_.portraitUri = user.portraitUri;
//                                          
//                                          model.extend = rcduserinfo_;
//                                          
//                                          //local cache for userInfo
//                                          NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
//                                                                        @"portraitUri":rcduserinfo_.portraitUri
//                                                                        };
//                                          [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
//                                          [[NSUserDefaults standardUserDefaults]synchronize];
//                                          
//                                          [weakSelf.conversationListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                                      }];
//            }
//        }
//        
//    }else{
//        RCDUserInfo *user = (RCDUserInfo *)model.extend;
//        userName    = user.name;
//        portraitUri = user.portraitUri;
//    }
//    
//        CZWChatListCell *cell = [[CZWChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"133"];
//        cell.lblDetail.text =[NSString stringWithFormat:@"来自%@的好友请求",userName];
//        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
//        cell.labelTime.text = [self ConvertMessageTime:model.sentTime / 1000];
//        return cell;
// 
//}

#pragma mark - 收到消息监听
//-(void)didReceiveMessageNotification:(NSNotification *)notification
//{
//    __weak typeof(&*self) blockSelf_ = self;
//    //处理好友请求
//    RCMessage *message = notification.object;
//    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
//        
//        if (message.conversationType != ConversationType_SYSTEM) {
//            NSLog(@"好友消息要发系统消息！！！");
//#if DEBUG
//            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
//#endif
//        }
//        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
//        if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId .length ==0) {
//            return;
//        }
//        //该接口需要替换为从消息体获取好友请求的用户信息
////        [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
////                              completion:^(RCUserInfo *user) {
////                                  RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
////                                  rcduserinfo_.name = user.name;
////                                  rcduserinfo_.userId = user.userId;
////                                  rcduserinfo_.portraitUri = user.portraitUri;
////                                  
////                                  RCConversationModel *customModel = [RCConversationModel new];
////                                  customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
////                                  customModel.extend = rcduserinfo_;
////                                  customModel.senderUserId = message.senderUserId;
////                                  customModel.lastestMessage = _contactNotificationMsg;
////                                  //[_myDataSource insertObject:customModel atIndex:0];
////                                  
////                                  //local cache for userInfo
////                                  NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
////                                                                @"portraitUri":rcduserinfo_.portraitUri
////                                                                };
////                                  [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
////                                  [[NSUserDefaults standardUserDefaults]synchronize];
////                                  
////                                  dispatch_async(dispatch_get_main_queue(), ^{
////                                      //调用父类刷新未读消息数
////                                      [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
////                                      //[super didReceiveMessageNotification:notification];
////                                      //              [blockSelf_ resetConversationListBackgroundViewIfNeeded];
////                                      [self notifyUpdateUnreadMessageCount];
////                                      
////                                      //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
////                                      //原因请查看super didReceiveMessageNotification的注释。
////                                      NSNumber *left = [notification.userInfo objectForKey:@"left"];
////                                      if (0 == left.integerValue) {
////                                          [super refreshConversationTableViewIfNeeded];
////                                      }
////                                  });
//                             // }];
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //调用父类刷新未读消息数
//            [super didReceiveMessageNotification:notification];
//            //            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
//            //            [self notifyUpdateUnreadMessageCount]; super会调用notifyUpdateUnreadMessageCount
//        });
//    }
//}




//- (void)notifyUpdateUnreadMessageCount
//{
//    [self updateBadgeValueForTabBarItem];
//}
//
//- (void)receiveNeedRefreshNotification:(NSNotification *)status {
//    __weak typeof(&*self) __blockSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (__blockSelf.displayConversationTypeArray.count == 1 && [self.displayConversationTypeArray[0] integerValue]== ConversationType_DISCUSSION) {
//            [__blockSelf refreshConversationTableViewIfNeeded];
//        }
//        
//    });
//}

@end
