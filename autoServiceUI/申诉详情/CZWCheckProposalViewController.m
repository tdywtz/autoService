//
//  CZWCheckProposalViewController.m
//  autoService
//
//  Created by bangong on 16/3/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWCheckProposalViewController.h"
#import "StarView.h"
#import "CZWEvaluateViewController.h"

#pragma mark - model
/**
 *  数据模型
 */
@interface ChechModel : NSObject
/**
 *  头像
 */
@property (nonatomic,copy) NSString *headpic;
/**
 *  名字
 */
@property (nonatomic,copy) NSString *name;
/**
 *  时间
 */
@property (nonatomic,copy) NSString *date;
/**
 *  评分数
 */
@property (nonatomic,copy) NSString *score;
/**
 *  解决单数
 */
@property (nonatomic,copy) NSString *complete_num;
/**
 *  城市
 */
@property (nonatomic,copy) NSString *city;
/**
 *  专家处理建议
 */
@property (nonatomic,copy) NSString *reason;
/**
 *  是否被采纳；1-采纳，0-未采纳
 */
@property (nonatomic,copy) NSString *selected;
/**
 *  采纳按钮是否可点击
 */
@property (nonatomic,copy) NSString *show;
/**
 *  专家id
 */
@property (nonatomic,copy) NSString *eid;
/**
 *  申诉id
 */
@property (nonatomic,copy) NSString *cpid;
/**
 *  cell高度
 */
@property (nonatomic,assign) CGFloat cellheight;


@end

@implementation ChechModel

@end

#pragma mark - cell
/**
 *  cell
 */
@interface ChechCell : UITableViewCell

@property (nonatomic,strong) ChechModel *model;
@property (nonatomic,copy) void(^block)(NSString *eid ,NSString *cpid);

-(void)clickButton:(void(^)(NSString *eid ,NSString *cpid))block;
@end

@implementation ChechCell
{
    /**头像*/
    UIImageView      *iconImageView;
    /**皇冠图*/
    UIImageView      *selectedIamgeView;
    /**用户名*/
    UILabel          *nameLabel;
    /** 日期*/
    UILabel          *dateLabel;
    /**星星*/
    StarView         *starIamgeView;
    /** 解决单数*/
    UILabel          *resolveLabel;
    /**  城市*/
    UILabel          *cityLabel;
    /**处理建议*/
    UILabel          *contentLabel;
    /** 采纳并评价*/
    UIButton         *button;
    
    UIView           *lineView;
    
    CGFloat           textFont;//字体
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        textFont = 15;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    
    return self;
}

-(void)makeUI{
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImageView.layer.cornerRadius = 25;
    iconImageView.layer.masksToBounds = YES;
    
    selectedIamgeView = [[UIImageView alloc] init];
    selectedIamgeView.image = [UIImage imageNamed:@"auto_huangguan"];
    selectedIamgeView.hidden = YES;
    
    nameLabel     = [LHController createLabelFont:textFont Text:nil Number:1 TextColor:colorNavigationBarColor];
    dateLabel     = [LHController createLabelFont:textFont-3 Text:nil Number:1 TextColor:colorLightGray];
    starIamgeView = [[StarView alloc] initWithFrame:CGRectZero];
    resolveLabel  = [LHController createLabelFont:textFont-3 Text:nil Number:1 TextColor:colorLightGray];
    cityLabel     = [LHController createLabelFont:textFont-3 Text:nil Number:1 TextColor:colorLightGray];
    contentLabel  = [LHController createLabelFont:textFont Text:nil Number:0 TextColor:colorDeepGray];
    
    button        = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick) Text:@"  采纳并评价"];
    button.titleLabel.font = [UIFont systemFontOfSize:textFont-3];
    UIImage *image = [UIImage imageNamed:@"auto_adviceProposal"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateNormal];
   
    button.layer.cornerRadius = 12;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth  = 1;
    button.layer.borderColor = colorLineGray.CGColor;
    
    lineView = [LHController createBackLineWithFrame:CGRectZero];
    
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:selectedIamgeView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:starIamgeView];
    [self.contentView addSubview:resolveLabel];
    [self.contentView addSubview:cityLabel];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:button];
    [self.contentView addSubview:lineView];

    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(15);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [selectedIamgeView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(iconImageView);
        make.size.equalTo(CGSizeMake(66, 66));
    }];

    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(iconImageView);
        make.right.lessThanOrEqualTo(dateLabel.left);
    }];
    
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel);
        make.right.equalTo(-15);
    }];
    
    [starIamgeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom);
        make.size.equalTo(CGSizeMake(75, 23));
    }];
    
    [resolveLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starIamgeView.right).offset(10);
        make.centerY.equalTo(starIamgeView);
        make.right.lessThanOrEqualTo(cityLabel.left);
    }];
    
    [cityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dateLabel);
        make.top.equalTo(resolveLabel);
    }];
    
    contentLabel.preferredMaxLayoutWidth = WIDTH-30;
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView);
        make.top.equalTo(iconImageView.bottom).offset(20);
        make.right.equalTo(dateLabel);
    }];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.bottom).offset(10);
        make.right.equalTo(dateLabel);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.bottom).offset(10);
        make.left.equalTo(0);
        make.size.equalTo(CGSizeMake(WIDTH, 1)); 
    }];
}

-(void)buttonClick{
    if (self.block) {
        self.block(_model.eid,_model.cpid);
    }
}

-(void)clickButton:(void (^)(NSString * , NSString *))block{
    self.block = block;
}
-(void)setModel:(ChechModel *)model{
    if (_model == model) return;
    _model = model;
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.headpic] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage@2x"]];
    nameLabel.attributedText = [NSAttributedString expertName:_model.name];
    dateLabel.text = _model.date;
     resolveLabel.attributedText = [NSAttributedString numberColorAttributeSting:[NSString stringWithFormat:@"已解决%@单",_model.complete_num] color:colorNavigationBarColor];
    cityLabel.text =_model.city;
    contentLabel.text = _model.reason;
    [starIamgeView setStar:[_model.score floatValue]];
    AttributStage *stage = [[AttributStage alloc] init];
    stage.textColor = colorDeepGray;
    stage.textFont = contentLabel.font;


   contentLabel.attributedText = [NSMutableAttributedString attributedStringWithStage:stage string:_model.reason];

   

    if ([_model.show intValue] == 1) {
        button.tintColor = colorNavigationBarColor;
        [button setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
        button.enabled = YES;
    }else{
        button.tintColor = colorLightGray;
        [button setTitleColor:colorLineGray forState:UIControlStateNormal];
        button.enabled = NO;
    }
    if ([_model.selected intValue] == 1) {
        selectedIamgeView.hidden = NO;
    }else{
        selectedIamgeView.hidden = YES;
    }
    if ([_model.show integerValue] == 2) {
        button.hidden = YES;
        [lineView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.bottom).offset(10);
            make.left.equalTo(0);
            make.size.equalTo(CGSizeMake(WIDTH, 1));
            make.bottom.equalTo(0);
        }];
    }else{
        button.hidden = NO;
        [lineView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button .bottom).offset(10);
            make.left.equalTo(0);
            make.size.equalTo(CGSizeMake(WIDTH, 1));
            make.bottom.equalTo(0);
        }];
    }
}

@end



#pragma mark - viewController
/**
 *  视图控制器
 */
@interface CZWCheckProposalViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    ChechCell *selfCell;
}
@end

@implementation CZWCheckProposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家建议";
    _dataArray = [[NSMutableArray alloc] init];
    selfCell = [ChechCell new];
    
    [self createLeftItemBack];
    [self createTableView];
    
    [self loadData];
}

-(void)loadData{
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    [CZWAFHttpRequest requestAdviceListWithUid:[CZWManager manager].roleId type:[CZWManager manager].userType cpid:self.cpid eid:self.eid success:^(id responseObject) {
      //  NSLog(@"%ld",[responseObject count]);
        [_dataArray removeAllObjects];
        [hud hideAnimated:YES];
        for (NSDictionary *dict in responseObject) {
            
            ChechModel *model = [[ChechModel alloc] init];
          
            model.headpic      = dict[@"headpic"];
            model.name         = dict[@"name"];
            model.score        = dict[@"score"];
            model.complete_num = dict[@"complete_num"];
            model.city         = dict[@"city"];
            model.reason       = dict[@"reason"];
            model.selected     = dict[@"selected"];
            model.show         = dict[@"show"];
            model.eid          = dict[@"eid"];
            model.cpid         = dict[@"cpid"];
            model.date         = dict[@"date"];
            
            selfCell.model = model;
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 100;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChechCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChechCell"];
    if (!cell) {
        cell = [[ChechCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChechCell"];
        __weak __typeof(&*self)weakSelf = self;
        [cell clickButton:^(NSString *eid , NSString *cpid) {
            CZWEvaluateViewController *evaluate = [[CZWEvaluateViewController alloc] init];
            evaluate.cpid = cpid;
            evaluate.eid = eid;
            
            [evaluate success:^(NSString *cpid) {
                [weakSelf loadData];
            }];
            [weakSelf.navigationController pushViewController:evaluate animated:YES];
        }];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

@end




