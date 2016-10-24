//
//  ChooseViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "ChooseViewController.h"
#import "AIMTableViewIndexBar.h"

typedef enum {
    chooseNumberAlone,//单选
    chooseNumberMany//多选
}chooseNumber;

@interface ChooseViewController ()<UITableViewDataSource,UITableViewDelegate,AIMTableViewIndexBarDelegate>
{
    UIButton *rightItemButton;
    UITableView *_tableView;
    NSArray *_dataArray;
    
    NSString *_returnID;
    NSString *_returnTitle;
    UIActivityIndicatorView *_activity;
}
@property (nonatomic,assign) UITableViewStyle tabelViewStyle;
@property (nonatomic,assign) chooseNumber chooseNumbers;
@property (nonatomic,strong) NSMutableArray *titleArray;//存放多选时被选择的名称
@end

@implementation ChooseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)downloadBrand{
    _activity = [self createActivity];
    [CZWAFHttpRequest requestBrandSuccess:^(id responseObject) {
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        NSMutableArray *letterArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject) {
            [letterArray addObject:dict[@"letter"]];
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setObject:dict[@"letter"] forKey:@"section"];
            NSMutableArray *mArr = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in dict[@"brand"]) {
                [mArr addObject:@{@"id":subDic[@"id"],@"title":subDic[@"name"]}];
            }
            [mDict setObject:mArr forKey:@"array"];
            [mArray addObject:mDict];
        }
        _dataArray = mArray;
        [self createIndexView:letterArray];
        [_tableView reloadData];
        [_activity stopAnimating];

    } failure:^(NSError *error) {
         [_activity stopAnimating];
    }];
}

-(void)createIndexView:(NSArray *)array{
    AIMTableViewIndexBar *indexbar = [[AIMTableViewIndexBar alloc] initWithFrame:CGRectMake(WIDTH-30, 94, 30, HEIGHT-124) andArray:array];
    indexbar.indexes = array;
    indexbar.delegate = self;
    [self.view addSubview:indexbar];
}

-(void)downloadSeries:(NSString *)brandID{ 
    _activity = [self createActivity];
    NSString *urlString = [NSString stringWithFormat:auto_car_series,brandID];
    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"rel"]) {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setObject:dict[@"brands"] forKey:@"section"];

            NSMutableArray *marr = [[NSMutableArray alloc] init];
            for (NSDictionary *subDict in dict[@"series"]) {
                [marr addObject:@{@"id":subDict[@"id"],@"title":subDict[@"name"]}];
            }
            [mDict setObject:marr forKey:@"array"];
            [mArray addObject:mDict];
        }
        _dataArray = mArray;
        [_tableView reloadData];
        [_activity stopAnimating];

    } failure:^(NSError *error) {
          [_activity stopAnimating];
    }];
}

-(void)downloadModel:(NSString *)seriesID{

    _activity = [self createActivity];
    NSString *urlString = [NSString stringWithFormat:auto_car_model,seriesID];

    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject) {
            [array addObject:@{@"id":dict[@"Id"],@"title":dict[@"Model_Name"]}];
        }
        _dataArray = array;
        [_tableView reloadData];
        [_activity stopAnimating];
    } failure:^(NSError *error) {
        [_activity stopAnimating];
    }];
}

-(void)downloadBusiness:(NSString *)provinceId CityId:(NSString *)cityId SeriesId:(NSString *)seriesId{
    
    NSString *urlString = [NSString stringWithFormat:auto_business,provinceId,cityId,seriesId];
   
    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject) {
            [mArray addObject:@{@"id":dict[@"Id"],@"title":dict[@"Name"]}];
        }
        _dataArray = mArray;
        [_tableView reloadData];
    } failure:^(NSError *error) {
         NSLog(@"%@",error);
    }];
}

#pragma mark - 加载图
-(UIActivityIndicatorView *)createActivity{
    //加载等待提示控件，初始化的时候，设定风格样式
    //控件宽高固定
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //设置中心点为view的中心点
    activity.center = self.view.center;
    activity.color = [UIColor grayColor];
    [self.view addSubview:activity];
    //让控件开始转动
    [activity startAnimating];
    return activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self createLeftItemBack];
    if (self.chooseNumbers == chooseNumberMany) {
        [self createRightItem];
    }
    [self createTableView];
    [self setup];
}

-(void)setup{
    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        self.navigationController.hidesBarsOnTap = NO;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = colorNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
}



-(void)createRightItem{
    rightItemButton = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"完成"];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [self setRightItemButtonEnabled:NO];
}

-(void)rightItemClick{
    NSString *title = _returnTitle;
    NSString *ID = _returnID;
    if (self.chooseNumbers == chooseNumberMany) {
        ID = @"";
        title = [self.titleArray componentsJoinedByString:@","];
    }
    if (self.block) {
        self.block(title,ID);
    }
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//改变按钮状态
-(void)setRightItemButtonEnabled:(BOOL)b{
    
    self.navigationItem.rightBarButtonItem.enabled = b;
    if (b) {
       
        [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [rightItemButton setTitleColor:RGB_color(200, 200, 200, 1) forState:UIControlStateNormal];
       
    }
}

-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.separatorColor = colorLineGray;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

-(void)setChoosetype:(chooseType)choosetype{
    _choosetype = choosetype;
   
    self.tabelViewStyle = UITableViewStylePlain;
   
    if (_choosetype == chooseTypeBrand) {
        self.title = @"品牌";
        self.chooseNumbers = chooseNumberAlone;
        self.tabelViewStyle = UITableViewStyleGrouped;
        [self downloadBrand];

    }else if (_choosetype == chooseTypeSeries){
        self.title = @"车系";
        self.chooseNumbers = chooseNumberAlone;
        self.tabelViewStyle = UITableViewStyleGrouped;
        [self downloadSeries:self.ID];
        
    }else if (_choosetype == chooseTypeModel){
        self.title = @"车型";
        self.chooseNumbers = chooseNumberAlone;
        [self downloadModel:self.ID];
        
    }else if (_choosetype == chooseTypeComplainQuality){
        self.title = @"质量申诉部位";
        self.chooseNumbers = chooseNumberMany;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"complainQuality" ofType:@"plist"];
        _dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
    }else if (_choosetype == chooseTypeComplainService){
        self.title = @"服务投诉问题";
        self.chooseNumbers = chooseNumberMany;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"complainService" ofType:@"plist"];
        _dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
    }else if (_choosetype == chooseTypeComplainSumup){
        self.title = @"综合问题";
        self.chooseNumbers = chooseNumberMany;
        NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"complainQuality" ofType:@"plist"];
        NSArray *array1  = [[NSArray alloc] initWithContentsOfFile:plistPath1];
         NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"complainQuality" ofType:@"plist"];
        NSArray *array2 = [[NSArray alloc] initWithContentsOfFile:plistPath2];
        NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:array1];
        [marr addObjectsFromArray:array2];
        _dataArray = marr;
        
    }else if (_choosetype == chooseTypeBusiness){
        self.title = @"经销商";
        self.chooseNumbers = chooseNumberAlone;
        [self downloadBusiness:self.ID CityId:self.cityId SeriesId:self.seriesId];
        
    }else if (_choosetype == chooseTypeSex){
        self.title = @"性别";
        self.chooseNumbers = chooseNumberAlone;
        _dataArray = @[@{@"title":@"男",@"id":@"0"},@{@"title":@"女",@"id":@"1"}];
    }
}

-(void)retrunResults:(returnResult)block{
    self.block = block;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tabelViewStyle == UITableViewStyleGrouped) {
        return _dataArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tabelViewStyle == UITableViewStyleGrouped) {
        return [_dataArray[section][@"array"] count];
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCell"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-50, 15, 24, 17)];
        imageView.image = [UIImage imageNamed:@"chooseImage_check"];
        imageView.tag = 200;
        [cell.contentView addSubview:imageView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict;
    if (self.tabelViewStyle == UITableViewStyleGrouped) {
        dict = _dataArray[indexPath.section][@"array"][indexPath.row];
    }else{
        dict  = _dataArray[indexPath.row];
    }
    
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.textColor = colorBlack;
    UIImageView *cellImageView = (UIImageView *)[cell.contentView viewWithTag:200];
    cellImageView.hidden = YES;
    if (self.chooseNumbers == chooseNumberAlone) {
        if ([dict[@"title"] isEqualToString:_returnTitle]) {
            cell.textLabel.textColor = colorNavigationBarColor;
            cellImageView.hidden = NO;
        }
    }else if (self.chooseNumbers == chooseNumberMany){
        for (int i = 0; i < self.titleArray.count; i ++) {
            if ([dict[@"title"] isEqualToString:self.titleArray[i]]) {
                cell.textLabel.textColor = colorDeepBlue;
                cellImageView.hidden = NO;
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setRightItemButtonEnabled:YES];
   
    NSDictionary *dict;
    if (self.tabelViewStyle == UITableViewStyleGrouped) {
        dict = _dataArray[indexPath.section][@"array"][indexPath.row];
    }else{
        dict  = _dataArray[indexPath.row];
    }
    if (self.chooseNumbers == chooseNumberAlone) {
        if (![dict[@"title"] isEqualToString:_returnTitle]) {
            _returnTitle = dict[@"title"];
            _returnID = dict[@"id"];
            [_tableView reloadData];
        }
    
        [self endChoose:_returnTitle ID:_returnID];
    }else if (self.chooseNumbers == chooseNumberMany){
        NSInteger integer = [self.titleArray indexOfObject:dict[@"title"]];
        if (integer < 1000) {
            [self.titleArray removeObject:dict[@"title"]];
            if (self.titleArray.count == 0) {
                [self setRightItemButtonEnabled:NO];
            }
        }else{
            [self.titleArray addObject:dict[@"title"]];
        }
        [_tableView reloadData];
    }
}

-(void)endChoose:(NSString *)title ID:(NSString *)ID{
    [self rightItemClick];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.tabelViewStyle == UITableViewStyleGrouped) {
    
        return _dataArray[section][@"section"];
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tabelViewStyle == UITableViewStyleGrouped) {
         return 40;
    }
    return 0.0;
}

#pragma mark - AIMTableViewIndexBarDelegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar*)indexBar didSelectSectionAtIndex:(NSInteger)index{
    
    if ([_tableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
