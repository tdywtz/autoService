//
//  CZWExpertCenterViewController.m
//  autoService
//
//  Created by luhai on 15/11/28.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertCenterViewController.h"
#import "CZWSettingViewController.h"
#import "StarView.h"
#import "CZWBasicTableViewCell.h"

@interface CZWExpertCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation CZWExpertCenterViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我";
   
    [self createLeftItemBack];
    [self createRightItem];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMessageCount) name:NOTIFICATIONMESSAGE object:nil];
    
    [self createData];
    [_tableView reloadData];
}

-(void)createData{
    _dataArray = @[
                   @[
                       @{@"class":@"CZWExpertCardViewController",@"imageName":@"",@"title":@""}
                       ],
                   @[
                       @{@"class":@"CZWExpertMyAssistViewController",@"imageName":@"expert_Assist",@"title":@"我的建议"},
                       @{@"class":@"CZWExpertUserAnswerViewController",@"imageName":@"center_answer",@"title":@"用户回复"}
                       ],
                   @[
                       @{@"class":@"CZWMyFriendsViewController",@"imageName":@"center_friends",@"title":@"我的好友"},
                       @{@"class":@"CZWChatRecordViewController",@"imageName":@"center_chat",@"title":@"聊天记录"},
                       @{@"class":@"CZWCollectViewController",@"imageName":@"center_collects",@"title":@"我的收藏"}
                       ],
                   @[

                       @{@"class":@"CZWFlowChartViewController",@"imageName":@"center_flowChart",@"title":@"处理流程"},
                       @{@"class":@"CZWAccountViewController",@"imageName":@"center_account",@"title":@"我的账户"},
                       @{@"class":@"CZWSearchEnterpriseViewController",@"imageName":@"center_enterprise",@"title":@"企业列表"},
                       @{@"class":@"CZWUserFeedbackViewController",@"imageName":@"center_feedback",@"title":@"用户反馈"},
                       ]
                   ];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

-(void)leftItemBackClick{


    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)unreadMessageCount{
    [CZWManager After:0.1 perform:^{
        [_tableView reloadData];
    }];
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
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
   _tableView.delegate = self;
   _tableView.dataSource = self;
    _tableView.separatorColor = colorLineGray;
   _tableView.separatorInset = UIEdgeInsetsMake(0, 47, 0, 0);
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];

    for (int i = 0; i < str.length; i ++) {
        unichar C = [str characterAtIndex:i];
        if (isnumber(C)) {
            [att addAttribute:NSForegroundColorAttributeName value:colorNavigationBarColor range:NSMakeRange(i, 1)];
        }
    }
    
    return att;
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experticonCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"experticonCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *iconImgeView = [LHController createImageViewWithFrame:CGRectMake(10, 10, 70, 70) ImageName:@"expertIconDefaultImage"];
            iconImgeView.layer.cornerRadius = 35;
            iconImgeView.layer.masksToBounds = YES;
            iconImgeView.tag = 100;
            [cell.contentView addSubview:iconImgeView];
            
            UILabel *nameLabel = [LHController createLabelWithFrame:CGRectMake(90, 10, WIDTH-100, 20) Font:[LHController setFont]-2 Bold:NO TextColor:colorOrangeRed Text:nil];
            nameLabel.tag = 101;
            [cell.contentView addSubview:nameLabel];
            
            StarView *star = [[StarView alloc] initWithFrame:CGRectMake(90, 30, 100, 20)];
            star.tag = 102;
            [cell.contentView addSubview:star];
            
            UILabel *modelLabel = [LHController createLabelWithFrame:CGRectMake(90, 55, WIDTH-100, 20) Font:[LHController setFont]-4 Bold:NO TextColor:colorLightGray Text:nil];
            modelLabel.tag = 103;
            [cell.contentView addSubview:modelLabel];
        }
     
        UIImageView *iconIamge = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:101];
        StarView *star = (StarView *)[cell.contentView viewWithTag:102];
        UILabel *model = (UILabel *)[cell.contentView viewWithTag:103];
       
        [iconIamge sd_setImageWithURL:[NSURL URLWithString: [CZWManager manager].roleIconImage] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
        name.attributedText =  [NSAttributedString expertName:[CZWManager manager].roleName];
        model.attributedText =  [self attributeSize:[NSString stringWithFormat:@"已解决%@单",[CZWManager manager].complete_num]];
        [star setStar:[[CZWManager manager].score integerValue]];
        
        return cell;
    }
    
    CZWBasicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expertcell"];
    if (!cell) {
        cell = [[CZWBasicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expertcell"];
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
    
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    
    UIView *view = (UIView *)[cell.contentView viewWithTag:100];
    view.hidden = YES;
    if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //设置小红点隐藏属性
            view.hidden = ![[CZWManager manager] unreadMessageOfAppeal];
            
        }else{
            //设置小红点隐藏属性
            view.hidden = ![[CZWManager manager] unreadMessageOfReply];
            
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //设置小红点隐藏属性
            view.hidden = !([[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_USER] ||
                            [[CZWManager manager] unreadMessageOfAddFriendsWithType:USERTYPE_EXPERT]);
          
           
        }else if (indexPath.row == 1){
            //设置小红点隐藏属性
            view.hidden = [[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0?NO:YES;
            
        }
 
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            view.hidden = ![[CZWManager manager] unreadMessageOfAccount];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 90;
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cls = NSClassFromString(_dataArray[indexPath.section][indexPath.row][@"class"]);
    [self.navigationController pushViewController:[[cls alloc] init] animated:YES];
}

@end
