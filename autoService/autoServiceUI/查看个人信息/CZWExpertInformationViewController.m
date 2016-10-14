//
//  CZWExpertInformationViewController.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertInformationViewController.h"
#import "CZWExpertInformationCell.h"
#import "CZWBasicPanNavigationController.h"
#import "StarView.h"
#import  <CoreText/CoreText.h>
#import "CZWInformationFootView.h"
#import "CZWAddFriendViewController.h"
#import "CZWChatViewController.h"
#import "CZWAppealDetailsViewController.h"
//CGFloat ascentCallback(void* refCon) {
//    return 20;
//}
//
//CGFloat descentCallback(void* refCon) {
//    return 50;
//}
//
//CGFloat widthCallback(void* refCon) {
//    return 100;
//}

@interface CZWExpertInformationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
    UIImageView     *_imageView;
    UILabel         *_nameLabel;
    StarView        *_starView;
    UILabel         *_numberLabel;
    UIImageView     *_iconImageView;
    UILabel         *_areaLabel;
    TTTAttributedLabel         *_shanTextView;
    
    CZWInformationFootView *footView;
}
@property (nonatomic,strong) CZWUserInfoExpert *userInfo;
@end

@implementation CZWExpertInformationViewController

-(void)loadTableHeaderData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWHttpModelResults requestExpertInfoWithExpertId:_eid result:^(CZWUserInfoExpert *userInfo) {
      
        [hud hideAnimated:YES];
        
        self.userInfo = userInfo;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.headpic] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
        NSString *name = [NSString stringWithFormat:@"    %@",userInfo.realname];
        _nameLabel.attributedText = [NSAttributedString expertName:name];
        [_starView setStar:[userInfo.score floatValue]];

        _numberLabel.text = [NSString stringWithFormat:@"已解决%@单",userInfo.complete_num];
        _areaLabel.text = userInfo.city;
        _shanTextView.text = userInfo.goodatarea;


        CGSize size = [userInfo.goodatarea calculateTextSizeWithFont:_shanTextView.font Size:CGSizeMake(WIDTH-100, 1000)];
        [_shanTextView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(size.height);
        }];

        _tableView.tableHeaderView = _shanTextView.superview;

    }];
}

-(void)loadData{
    [CZWAFHttpRequest requestHelpListForInfoWithEid:self.eid success:^(id responseObject) {
        if ([responseObject count] == 0) {
            return ;
        }
        if ([responseObject firstObject][@"error"]) {
            //[CZWAlert alertDismiss:[responseObject firstObject][@"error"]];
            
        }else{
          // NSLog(@"%@",responseObject);
            for (NSDictionary *dict in responseObject) {
                CZWAppealModel *model = [[CZWAppealModel alloc] init];
                model.uid       = dict[@"uid"];
                model.cpid      = dict[@"cpid"];
                model.name      = dict[@"name"];
                model.headpic   = dict[@"headpic"];
                model.cname     = dict[@"cname"];
                model.modelname = dict[@"modelname"];
                model.steps     = dict[@"steps"];
                model.title     = dict[@"title"];
                model.content   = dict[@"content"];
                model.image     = dict[@"image"];
                model.date      = dict[@"date"];
                model.applynum  = dict[@"applynum"];
                model.score     = dict[@"score"];
                model.comment   = dict[@"comment"];
                
        
                [_dataArray addObject:model];
            }
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
   // tempCell = [[CZWExpertInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    [self createLeftItemBack];
    [self createTableView];
    [self createTableHeaderView];
    [self createFootView];
    CZWBasicPanNavigationController *nvc = (CZWBasicPanNavigationController *)self.navigationController;
    [nvc setAlph];

    [self loadTableHeaderData];
    [self loadData];
   
    
}

-(void)createFootView{
    if ([self.eid isEqualToString:[CZWManager manager].roleId] && [[CZWManager manager].userType isEqualToString:USERTYPE_EXPERT]) {
        CGRect rect = _tableView.frame;
        rect.size.height = HEIGHT+64;
        _tableView.frame = rect;
        return;
    }
    footView = [[CZWInformationFootView alloc] initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    footView.ToUserId = self.eid;
    footView.ToUserType = USERTYPE_EXPERT;
    [footView loadData];
    [self.view addSubview:footView];
    
  [footView choose:^(NSString *state, NSString *targetId) {
      if ([state isEqualToString:@"加为好友"]) {
          CZWAddFriendViewController *add = [[CZWAddFriendViewController alloc] init];
          add.targetId = targetId;
          add.ToUserId = self.eid;
          add.ToUserType = USERTYPE_EXPERT;
          add.ToUserName = self.userInfo.realname;
          [add requestSuccess:^(BOOL success) {
              [footView loadData];
          }];
          [self.navigationController pushViewController:add animated:YES];
      }else if ([state isEqualToString:@"发起对话"]){
          CZWChatViewController *chat = [[CZWChatViewController alloc] init];
          chat.targetId = targetId;
          chat.conversationType = ConversationType_PRIVATE;
          chat.title = self.userInfo.realname;
          [self.navigationController pushViewController:chat animated:YES];
      }

  }];
    
}


-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT-49+64)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = colorLineGray;
    _tableView.estimatedRowHeight = 200;
    [self.view addSubview:_tableView];
}

-(void)createTableHeaderView{

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
    header.backgroundColor = colorNavigationBarColor;
    _tableView.tableHeaderView = header;
    
    _iconImageView = [LHController createImageViewWithFrame:CGRectZero ImageName:@"expertIconDefaultImage"];
    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.masksToBounds = YES;
    [header addSubview:_iconImageView];
    
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = RGB_color(255, 255, 255, 0.5);
    shadowView.layer.cornerRadius = 42.5;
    shadowView.layer.masksToBounds = YES;
    [header insertSubview:shadowView atIndex:0];

    _nameLabel = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont] Bold:NO TextColor:[UIColor whiteColor] Text:nil];
    [header addSubview:_nameLabel];
    
    _starView = [[StarView alloc] initWithFrame:CGRectZero];
    _starView.style = StarViewStyleBig;
    [header addSubview:_starView];
    
    _numberLabel = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-4 Bold:NO TextColor:[UIColor whiteColor] Text:nil];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:_numberLabel];
    
    UIView *fgview1 = [LHController createBackLineWithFrame:CGRectZero];
    [header addSubview:fgview1];

    UILabel *areaLeft = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-4 Bold:NO TextColor:colorLightGray Text:@"所在地:"];
    [header addSubview:areaLeft];
    
    _areaLabel = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-4 Bold:NO TextColor:colorDeepGray Text:nil];
    [header addSubview:_areaLabel];
    
    UIView *fgView2 = [LHController createBackLineWithFrame:CGRectZero];
    [header addSubview:fgView2];
    
    UILabel *shanchang = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-4 Bold:NO TextColor:colorLightGray Text:@"擅长领域:"];
    [header addSubview:shanchang];
    
    _shanTextView = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _shanTextView.font = [UIFont systemFontOfSize:[LHController setFont]-4];
    _shanTextView.numberOfLines = 0;
    _shanTextView.textColor = colorDeepGray;
    _shanTextView.preferredMaxLayoutWidth = WIDTH-100;
    [header addSubview:_shanTextView];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(60);
        make.centerX.equalTo(_iconImageView.superview);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    
    [shadowView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_iconImageView);
        make.size.equalTo(CGSizeMake(85, 85));
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.bottom).offset(10);
        make.centerX.equalTo(_iconImageView);
    }];
    
    [_starView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.bottom).offset(15);
        make.centerX.equalTo(_iconImageView);
        make.size.equalTo(CGSizeMake(91, 17));
    }];
    
    [_numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_starView.bottom).offset(10);
        make.centerX.equalTo(_iconImageView);
    }];

    [fgview1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_starView.bottom).offset(40);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(10);
    }];
    
    [areaLeft makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fgview1.bottom);
        make.left.equalTo(15);
        make.height.equalTo(30);
    }];
    
    [_areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fgview1.bottom);
        make.left.equalTo(85);
        make.right.equalTo(0);
        make.height.equalTo(30);
    }];
    
    [fgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(_areaLabel.bottom);
        make.right.equalTo(0);
        make.height.equalTo(1);
    }];
    
    [shanchang makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fgView2.bottom).offset(8);
        make.left.equalTo(15);
    }];
    
    [_shanTextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_areaLabel);
        make.top.equalTo(fgView2.bottom).offset(8);
        make.right.equalTo(-15);
        make.height.greaterThanOrEqualTo(20);
        make.bottom.equalTo(-15);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [header insertSubview:view atIndex:0];
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(fgview1);
        make.bottom.equalTo(0);
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
    
    CZWExpertInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CZWExpertInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CZWAppealModel *model = _dataArray[indexPath.row];
//
//    return model.cellHeight;
//}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    CZWAppealModel *model = _dataArray[indexPath.row];
    details.cpid = model.cpid;
    details.targetUid = model.uid;
    details.targetUname = model.name;
    
    [self.navigationController pushViewController:details animated:YES];
    
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
