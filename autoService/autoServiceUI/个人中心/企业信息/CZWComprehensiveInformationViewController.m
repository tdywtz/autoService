//
//  CZWComprehensiveInformationViewController.m
//  autoService
//
//  Created by bangong on 16/5/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWComprehensiveInformationViewController.h"
#import "CZWPromoteWebViewController.h"
#import "CZWEnterpriseInformationViewController.h"
#import "CZWWrappedPolicyViewController.h"
#import "CZWPromoteListViewController.h"
#import "CZWShowImagePageViewController.h"

#pragma mark - class( 企业信息cell)
#pragma mark - subClass(显示图片)
@interface ShowImageLabel : UILabel

@property (nonatomic,strong) UIImageView *imageViewOne;
@property (nonatomic,strong) UIImageView *imageViewTwo;
@property (nonatomic,copy) void(^block)(NSInteger index);

@end

@implementation ShowImageLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageViewOne = [[UIImageView alloc] init];
        _imageViewTwo = [[UIImageView alloc] init];
        [self addSubview:_imageViewOne];
        [self addSubview:_imageViewTwo];
        
        [_imageViewOne makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.bottom.equalTo(0);
            make.width.equalTo(self.height).with.multipliedBy(16.0/9);
        }];
        [_imageViewTwo makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(_imageViewOne.right).offset(5);
            make.size.equalTo(_imageViewOne);
        }];
        self.userInteractionEnabled = YES;

        _imageViewOne.userInteractionEnabled = YES;
        _imageViewTwo.userInteractionEnabled = YES;
        [_imageViewOne addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapone:)]];
        [_imageViewTwo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptwo:)]];
    }
    return self;
}

- (void)tapone:(UITapGestureRecognizer *)tap{
    if ( _imageViewOne.image) {
        if (self.block) {
            self.block(0);
        }
    }
}

- (void)taptwo:(UITapGestureRecognizer *)tap{
    if ( _imageViewTwo.image) {
        if (self.block) {
            self.block(1);
        }
    }
}

@end

/**
 *  企业信息cell
 */
@interface ComprehensiveInformationCell : UITableViewCell
{
    UILabel *companyNameLabel;//公司名
    UILabel *phoneLabel;//电话
    UILabel *websiteLabel;//网址
    UILabel *addressLabel;//地址
    ShowImageLabel *showImageLabel;//显示图片
  //  UILabel *companyIntroductionLabel;//公司简介

}
@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) NSDictionary *companyInfo;
@property (nonatomic,strong) NSArray *urlArray;
@end

@implementation ComprehensiveInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    NSArray *objects = @[@"companyNameLabel",@"phoneLabel",@"websiteLabel",@"addressLabel",@"showImageLabel"];
    NSArray *titles = @[@"公司名称：",@"联系电话：",@"公司网址：",@"公司地址：",@"公司图片："];//,@"公司简介："
    UIView *temp = nil;
   
    for (int i = 0; i < titles.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.text = titles[i];
        label.textColor = colorLightGray;
        [self.contentView addSubview:label];
        
        
        
        UILabel *rightlabel = [[UILabel alloc] init];
        if (i == 4) {
            rightlabel = [[ShowImageLabel alloc] init];
        }
        rightlabel.font = [UIFont systemFontOfSize:15];
        rightlabel.textColor = colorBlack;
        rightlabel.numberOfLines = 0;
        [self.contentView addSubview:rightlabel];
       
        
        [self setValue:rightlabel forKey:objects[i]];
        
       
        
        if (!temp) {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.top.equalTo(15);
                make.width.equalTo(80);
            }];
            
            [rightlabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(15);
                make.left.equalTo(label.right).offset(10);
                make.right.equalTo(-15);
                make.height.greaterThanOrEqualTo(20);
            }];
        }else{
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(temp.bottom).offset(10);
                make.left.equalTo(15);
                make.width.equalTo(80);
            }];
            
            [rightlabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(temp.bottom).offset(10);
                make.left.equalTo(label.right).offset(10);
                make.right.equalTo(-15);
                make.height.greaterThanOrEqualTo(20);
            }];
        }
        if (i == 4) {
            [rightlabel updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(((WIDTH-30)/3-5)*(9/16.0));
            }];

        }
        temp = rightlabel;
    }

    [temp updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-15);
    }];

    __weak __typeof(self)weakSelf = self;
    showImageLabel.block = ^(NSInteger index){
        CZWShowImagePageViewController *show = [[CZWShowImagePageViewController alloc] init];
        show.imageUrlArray = weakSelf.urlArray;
        show.pageIndex = index;
        [weakSelf.parentViewController.navigationController pushViewController:show animated:YES];
    };
}

-(void)setCompanyInfo:(NSDictionary *)companyInfo{
    _companyInfo = companyInfo;

    companyNameLabel.text = _companyInfo[@"facName"];
    phoneLabel.text = _companyInfo[@"telePhone"];
    websiteLabel.text = _companyInfo[@"site"];
    addressLabel.text = _companyInfo[@"address"];
    _urlArray = [_companyInfo[@"images"] componentsSeparatedByString:@"||"];
    if (_urlArray) {
         NSMutableArray *marr = [NSMutableArray arrayWithArray:_urlArray];
        [marr removeObject:@""];
        _urlArray = [marr copy];
        if (marr.count > 0) {
            [showImageLabel.imageViewOne sd_setImageWithURL:[NSURL URLWithString:marr[0]] placeholderImage:[UIImage imageNamed:@""]];
        }
        if (marr.count > 1) {
            [showImageLabel.imageViewTwo sd_setImageWithURL:[NSURL URLWithString:marr[1]] placeholderImage:[UIImage imageNamed:@""]];
        }
    }
   
   // companyIntroductionLabel.text = _companyInfo[@"introduction"];
}

@end


#pragma mark - class( cell for  section)
/**
 *  cell for  section
 */
@interface ComprehensiveSectionCell : UITableViewCell
{
    UILabel *titleLabel;
}
@property (nonatomic,strong) NSDictionary *dictionary;
@property (nonatomic,weak) UIViewController *parentViewController;

@end

@implementation ComprehensiveSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        tap.numberOfTapsRequired = 1;
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

-(void)makeUI{
    titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(27);
        make.centerY.equalTo(0);
    }];
}

-(void)tapGesture{
    UIViewController *vc = [[NSClassFromString(_dictionary[@"class"]) alloc] init];
    if ([vc isKindOfClass:NSClassFromString(@"CZWEnterpriseInformationViewController")]) {
        ((CZWEnterpriseInformationViewController *)vc).fid = _dictionary[@"fid"];
    }else if ([vc isKindOfClass:NSClassFromString(@"CZWWrappedPolicyViewController")]){
        ((CZWWrappedPolicyViewController *)vc).fid = _dictionary[@"fid"];
    }else{
        ((CZWPromoteListViewController *)vc).fid = _dictionary[@"fid"];
    }
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)setDictionary:(NSDictionary *)dictionary{
    _dictionary = dictionary;
    
    titleLabel.text = dictionary[@"title"];
}



-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条左侧线
    CGContextSetRGBStrokeColor(context, 0/255.0,  220/255.0, 220/255.0, 1);//线条颜色
    CGContextSetLineWidth(context, 3);
    CGContextMoveToPoint(context, 15, 10);
    CGContextAddLineToPoint(context, 15,rect.size.height-10);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}
@end


#pragma mark - (促销信息cell)

@interface PromoteCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@end

@implementation PromoteCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = colorDeepGray;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = colorLightGray;
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textAlignment = NSTextAlignmentRight;


    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_dateLabel];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.lessThanOrEqualTo(_dateLabel.left).offset(-10);
        make.centerY.equalTo(0);
    }];
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(0);
        make.width.equalTo(48);
    }];
}


@end


#pragma mark - class(综合信息-CZWComprehensiveInformationViewController)

@interface CZWComprehensiveInformationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSDictionary *_companyInfo;//企业信息
}
@end

@implementation CZWComprehensiveInformationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _dataArray = @[
                       @{@"height":@(44)},
                       @{@"height":@(44)},
                       @{@"height":@(44)},
                       @{@"height":@(44)}
                   ];
    [self createLeftItemBack];
    [self creteTableView];
    
    [self loadInfoData];
    [self loadListData];
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)fid{
    if (!_fid) {
        _fid = @"";
    }
    return _fid;
}

-(void)loadInfoData{
   MBProgressHUD *  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:auto_fac_info,self.fid];

    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        _companyInfo = responseObject;
        self.title = responseObject[@"facName"];
        [hud hideAnimated:YES];
         [_tableView reloadData];
    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
    }];
}

-(void)loadListData{
     NSString *urlString = [NSString stringWithFormat:auto_fac_prolist,self.fid,1];
    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        
        _dataArray = responseObject[@"rel"];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)creteTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    if (section == 1) return 0;
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ComprehensiveInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"informationCell"];
        if (!cell) {
            cell = [[ComprehensiveInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"informationCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.parentViewController = self;
        }
        cell.companyInfo = _companyInfo;
        return cell;

    }else if (indexPath.section == 1){
        return nil;
    }else{
        PromoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
        if (!cell) {
            cell = [[PromoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dict = _dataArray[indexPath.row];

        NSString *date = dict[@"date"];
        if (date.length > 5) {
            date = [date substringFromIndex:5];
        }
        cell.dateLabel.text = date;
        cell.titleLabel.text = dict[@"title"];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ComprehensiveSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionCell"];
    if (!cell) {
        cell = [[ComprehensiveSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.parentViewController = self;
    }
    
    if (section == 0) {
        cell.dictionary = @{@"title":@"企业信息",@"class":@"CZWEnterpriseInformationViewController",@"fid":self.fid};
    }else if (section == 1){
        cell.dictionary = @{@"title":@"三包政策",@"class":@"CZWWrappedPolicyViewController",@"fid":self.fid};
    }else if (section == 2){
        cell.dictionary = @{@"title":@"促销信息",@"class":@"CZWPromoteListViewController",@"fid":self.fid};
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        CZWPromoteWebViewController *web = [[CZWPromoteWebViewController alloc] init];
        web.ID = _dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:web animated:YES];
    }
}

@end
