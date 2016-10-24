//
//  CZWInformationViewController.m
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserInformationViewController.h"
#import "CZWBasicPanNavigationController.h"
#import "CZWUserInformationCell.h"
#import "CZWInformationFootView.h"
#import "CZWTextMessage.h"
#import "CZWAddFriendViewController.h"
#import "CZWChatViewController.h"
#import "CZWAppealDetailsViewController.h"

@interface CZWUserInformationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIImageView *_imageView;
    
    UIImageView *iconImageView;
    UILabel *nameLabel;
    UILabel *carLabel;
    UILabel *areaLabel;
    
    CZWInformationFootView *footView;
    
    NSInteger _count;
    CZWUserInformationCell *tempCell;
}
@property (nonatomic,strong) NSDictionary *inforDict;
@end

@implementation CZWUserInformationViewController


-(void)loadHeaderData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
     NSString *url = [NSString stringWithFormat:user_information,self.userID];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
      
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) {
            return ;
        }
        self.inforDict = [responseObject firstObject];
        if (self.inforDict[@"error"]) {
            [CZWAlert alertDismiss:self.inforDict[@"error"]];
        }else{
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.inforDict[@"img"]] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
            nameLabel.text = self.inforDict[@"uname"];
            NSString *carString = [NSString stringWithFormat:@"爱车      %@",self.inforDict[@"modelName"]];
            NSString *areaString = [NSString stringWithFormat:@"地区      %@",self.inforDict[@"city"]];
            
            UIImage *iamge = [UIImage imageNamed:@"auto_userInformation"];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:carString];
            carLabel.attributedText = [att insertImage:iamge into:5];
            
            NSMutableAttributedString *areaAtt = [[NSMutableAttributedString alloc] initWithString:areaString];
            areaLabel.attributedText = [areaAtt insertImage:iamge into:5];
        }

    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
    }];
}

-(void)loadData{
   
    [CZWHttpModelResults requestAppealModelsWithUserId:self.userID count:_count result:^(NSArray *appealModels) {
        if (_count == 1) {
            [_dataArray removeAllObjects];
        }
        for (CZWAppealModel *model in appealModels) {
            tempCell.model =  model;
            model.cellHeight = [tempCell viewHeight];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _count = 1;
    tempCell = [[CZWUserInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    [self createLeftItemBack];
    [self createTableView];
    [self createTableHeaderView];
    [self createFootView];
    [self loadHeaderData];
    [self loadData];

    CZWBasicPanNavigationController *nvc = (CZWBasicPanNavigationController *)self.navigationController;
    [nvc setAlph];
}

-(void)createFootView{
    if ([self.userID isEqualToString:[CZWManager manager].roleId] && [[CZWManager manager].userType isEqualToString:USERTYPE_USER]) {
        _tableView.frame = self.view.frame;
        return;
    }

    footView = [[CZWInformationFootView alloc] initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    footView.ToUserId = self.userID;
    footView.ToUserType = USERTYPE_USER;
    [footView loadData];
    [self.view addSubview:footView];
    
    [footView choose:^(NSString *state ,NSString *targetId) {
        if ([state isEqualToString:@"加为好友"]) {
            CZWAddFriendViewController *add = [[CZWAddFriendViewController alloc] init];
            add.targetId = targetId;
            add.ToUserId = self.userID;
            add.ToUserType = USERTYPE_USER;
            add.ToUserName = self.inforDict[@"uname"];
            [add requestSuccess:^(BOOL success) {
                [footView loadData];
            }];
            [self.navigationController pushViewController:add animated:YES];
        }else if ([state isEqualToString:@"发起对话"]){
            CZWChatViewController *chat = [[CZWChatViewController alloc] init];
            chat.targetId = targetId;
            chat.conversationType = ConversationType_PRIVATE;
            chat.title = self.inforDict[@"uname"];
            [self.navigationController pushViewController:chat animated:YES];
        }
    }];
}


-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = colorLineGray;
    [self.view addSubview:_tableView];
}

-(void)createTableHeaderView{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, 264)];
    //_imageView.image = [UIImage imageNamed:@"rootViewBackImage"];
    _imageView.backgroundColor = colorNavigationBarColor;
    [_tableView insertSubview:_imageView atIndex:0];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    _tableView.tableHeaderView = header;
    
    iconImageView = [LHController createImageViewWithFrame:CGRectZero ImageName:@"userIconDefaultImage"];
    iconImageView.layer.cornerRadius = 3.0;
    iconImageView.layer.masksToBounds = YES;
     [header addSubview:iconImageView];

    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = RGB_color(255, 255, 255, 0.5);
    shadowView.layer.cornerRadius = 5.0;
    shadowView.layer.masksToBounds = YES;
    [header insertSubview:shadowView atIndex:0];
    
    
    nameLabel = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-2 Bold:NO TextColor:[UIColor whiteColor] Text:nil];
    [header addSubview:nameLabel];
    
    carLabel = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-4 Bold:NO TextColor:[UIColor whiteColor] Text:nil];
    [header addSubview:carLabel];
    
    areaLabel = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-4 Bold:NO TextColor:[UIColor whiteColor] Text: nil];
    [header addSubview:areaLabel];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.centerX.equalTo(iconImageView.superview);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    
    [shadowView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(iconImageView);
        make.size.equalTo(CGSizeMake(85, 85));
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.bottom).offset(10);
        make.centerX.equalTo(iconImageView);
        make.size.lessThanOrEqualTo(CGSizeMake(WIDTH, 20));
    }];
    
    [carLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.bottom).offset(15);
        make.centerX.equalTo(nameLabel);
        make.height.equalTo(20);
    }];
    
    [areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carLabel.bottom);
        make.left.equalTo(carLabel);
        make.size.equalTo(carLabel);
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
    
    CZWUserInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CZWUserInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealModel *model = _dataArray[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    CZWAppealModel *model = _dataArray[indexPath.row];
    details.cpid = model.cpid;
    details.targetUid = model.uid;
    details.targetUname = model.name;
    
    [self.navigationController pushViewController:details animated:YES];

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat yy = scrollView.contentOffset.y;

    if (yy > 60) {
        CZWBasicPanNavigationController *nvc = (CZWBasicPanNavigationController *)self.navigationController;
        [nvc endAlph];
    
    }else{
        if (yy < 0) {
            CZWBasicPanNavigationController *nvc = (CZWBasicPanNavigationController *)self.navigationController;
            [nvc bengingAlph];
    
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CZWBasicPanNavigationController *nvc = (CZWBasicPanNavigationController *)self.navigationController;
    [nvc endAlph];
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
