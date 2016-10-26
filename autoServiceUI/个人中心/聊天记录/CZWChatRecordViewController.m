//
//  CZWChatRecordViewController.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWChatRecordViewController.h"
#import "CZWChatUserCell.h"
#import "CZWChatViewController.h"

@interface CZWChatRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UIView *spaceView;
    
    BOOL activity;
}
@end

@implementation CZWChatRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天记录";
    
    [self createLeftItemBack];
    [self createTabelView];
    [self createNotifaction];
    
    [self createSpaceVeiw];
}

-(void)createSpaceVeiw{
    spaceView = [[UIView alloc] initWithFrame:self.view.frame];
    spaceView.hidden = YES;
    [self.view addSubview:spaceView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    imageView.center = CGPointMake(WIDTH/2, HEIGHT/2-64);
    [spaceView addSubview:imageView];
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, WIDTH, 20) Font:15 Bold:NO TextColor:colorDeepGray Text:@"暂时没有消息"];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(WIDTH/2, imageView.center.y+imageView.frame.size.height);
    [spaceView addSubview:label];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    activity = YES;
    [self readData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
    activity = NO;
}

-(void)createNotifaction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:NOTIFICATIONMESSAGE object:nil];
}

-(void)notification:(NSNotification *)notifi{
   
    if (!activity)return;
    
    [self readData];
}

-(void)readData{
    
    _dataArray = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]];

    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [_tableView reloadData];
        if (_dataArray.count == 0) {
            spaceView.hidden = NO;
        }else{
            spaceView.hidden = YES;
        }
    });
     
}
-(void)createTabelView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    RCConversationModel *model = _dataArray[indexPath.row];

        CZWChatUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"usercell"];
        if (!cell) {
            cell = [[CZWChatUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"usercell"];
            // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.model = model;
        return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RCConversationModel *model = _dataArray[indexPath.row];
    CZWChatViewController *conversationVC = [[CZWChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle
    ;
    if (conversationVC.title.length == 0) {
        [[CZWManager manager] getChatUserInfoWithId:model.targetId success:^(CZWChatUserInfo *info) {
            conversationVC.title = info.userName;
        }];
    }
    [self.navigationController pushViewController:conversationVC animated:YES];

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
  
    result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    
    return result;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row < _dataArray.count) {
          
            RCConversationModel *model = _dataArray[indexPath.row];
            [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
            [self readData];
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
