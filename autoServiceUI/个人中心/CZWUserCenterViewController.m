//
//  CZWUserCenterViewController.m
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserCenterViewController.h"
#import "CZWSettingViewController.h"
#import "CZWBasicTableViewCell.h"

@interface CZWUserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CZWUserCenterViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我";
    _dataArray = @[
                   @[
                       @{@"class":@"CZWUserCardViewController",@"imageName":@"",@"title":@""}
                       ],
                   @[
                       @{@"class":@"CZWUserMyAppealViewController",@"imageName":@"center_appeals",@"title":@"我的申诉"},
                       @{@"class":@"CZWUserExpertAnswerViewController",@"imageName":@"center_answer",@"title":@"专家回复"}
                       ],
                   @[
                       @{@"class":@"CZWMyFriendsViewController",@"imageName":@"center_friends",@"title":@"我的好友"},
                       @{@"class":@"CZWChatRecordViewController",@"imageName":@"center_chat",@"title":@"聊天记录"},
                       @{@"class":@"CZWCollectViewController",@"imageName":@"center_collects",@"title":@"我的收藏"}
                       ],
                   @[
                       @{@"class":@"CZWSearchEnterpriseViewController",@"imageName":@"center_enterprise",@"title":@"企业列表"},
                       @{@"class":@"CZWUserFeedbackViewController",@"imageName":@"center_feedback",@"title":@"用户反馈"}
                       ]
                   ];
    [self createLeftItemBack];
    [self createRightItem];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMessageCount) name:NOTIFICATIONMESSAGE object:nil];
}
#pragma mark - 消息通知
-(void)unreadMessageCount{

    [CZWManager After:0.1 perform:^{
        [_tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self.tableView reloadData];
}

-(void)leftItemBackClick{


    [self.navigationController popViewControllerAnimated:NO];

}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 15, 30) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"center_setting"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    
    CZWSettingViewController *setting = [[CZWSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)createTableView{

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = colorLineGray;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 47, 0, 0);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *iconImgeView = [LHController createImageViewWithFrame:CGRectMake(10, 10, 70, 70) ImageName:@"userIconDefaultImage"];
            iconImgeView.layer.cornerRadius = 3;
            iconImgeView.layer.masksToBounds = YES;
            iconImgeView.tag = 100;
            [cell.contentView addSubview:iconImgeView];
           
            UILabel *nameLabel = [LHController createLabelWithFrame:CGRectMake(90, 15, WIDTH-100, 20) Font:[LHController setFont]-2 Bold:NO TextColor:RGB_color(254, 115, 22, 1) Text:nil];
            nameLabel.tag = 101;
            [cell.contentView addSubview:nameLabel];
           
            UILabel *modelLabel = [LHController createLabelWithFrame:CGRectMake(90, 50, WIDTH-100, 20) Font:[LHController setFont]-4 Bold:NO TextColor:colorLightGray Text:nil];
            modelLabel.tag = 102;
            [cell.contentView addSubview:modelLabel];
        }
       
        UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *model = (UILabel *)[cell.contentView viewWithTag:102];
        [icon sd_setImageWithURL:[NSURL URLWithString:[CZWManager manager].roleIconImage] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
        name.text = [CZWManager manager].roleName;
        model.text = [CZWManager manager].modelName;
        
        return cell;
    }
    
    CZWBasicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CZWBasicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
        cell.textLabel.textColor = colorBlack;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.drawLine = NO;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(28, 10, 6, 6)];
        view.layer.cornerRadius = 3;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor redColor];
        view.tag = 100;
        [cell.contentView addSubview:view];
    }
    
    UIView *view = (UIView *)[cell.contentView viewWithTag:100];
    view.hidden = YES;
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    cell.textLabel.text = dict[@"title"];
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //设置小红点隐藏属性
            view.hidden = ![[CZWManager manager] unreadMessageOfAppeal];
            
        }else if (indexPath.row == 1){
            //设置小红点隐藏属性
            view.hidden = ![[CZWManager manager] unreadMessageOfReply];
           
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {

            view.hidden = !([[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_USER] ||
                            [[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_EXPERT]);
         
        }else if (indexPath.row == 1){
            //设置小红点隐藏属性
            view.hidden = [[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0?NO:YES;
           
        }
    }
    return cell;
}



#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 90;
    return 44;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cls = NSClassFromString(_dataArray[indexPath.section][indexPath.row][@"class"]);
    [self.navigationController pushViewController:[[cls alloc] init] animated:YES];
}
/*
#pragma mark - Navigation/Users/luhai/Desktop/项目组/StarRatingView-master.zip

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
