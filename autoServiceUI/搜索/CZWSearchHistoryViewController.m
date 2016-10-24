//
//  CZWSearchHistoryViewController.m
//  autoService
//
//  Created by bangong on 15/12/9.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWSearchHistoryViewController.h"
#import "CZWSearchResultsViewController.h"

@interface CZWSearchHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    NSUserDefaults *_userDefaults;
    UIView *tableHeaderView;
    UIView *tableFootView;
    NSString *history;
}
@property (nonatomic,strong)   UISearchBar *searchBar;
@end

@implementation CZWSearchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    history = @"historydataarray";
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _dataArray = [[NSMutableArray alloc] init];
   
    [self createLeftItemBack];
    [self createTitleView];
    [self createTabelView];
    [self createTabelHeaderView];
    [self createTabelFootView];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar endEditing:YES];
}

-(void)createTitleView{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH-60, 45)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入关键字";
    self.searchBar.tintColor = RGB_color(43, 75, 249, 1);
}


-(void)createTabelHeaderView{
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    //tableHeaderView.backgroundColor = colorLineGray;
   
   
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 0, 80, 40) Font:15 Bold:NO TextColor:colorDeepGray Text:@"历史搜索"];
    UIView *line = [LHController createBackLineWithFrame:CGRectMake(-15, 39, WIDTH, 1)];
    [label addSubview:line];
    
    [tableHeaderView addSubview:label];
}

-(void)createTabelFootView{
    tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
    //  _tabelView.tableFooterView = tableFootView;
    
    UIButton *button = [LHController createButtnFram:CGRectMake((WIDTH-100)/2, 20, 100, 25) Target:self Action:@selector(cleanClick) Font:15 Text:@"清空搜索历史"];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"auto_cleanSearchHistory"];
    image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:9];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [tableFootView  addSubview:button];
}

-(void)cleanClick{
    [_userDefaults setObject:[[NSMutableArray alloc] init] forKey:history];
    [_userDefaults synchronize];
    
    _tabelView.tableHeaderView = nil;
    _tabelView.tableFooterView = nil;
    [_dataArray removeAllObjects];
    [_tabelView reloadData];
}

-(void)createTabelView{
    _tabelView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
}

//刷新列表
-(void)reloadDataOFtableview:(NSString *)string{
    NSArray *array = [_userDefaults objectForKey:history];
    [_dataArray removeAllObjects];
    if (string.length == 0) {
        for (NSString *str in array) {
            [_dataArray addObject:str];
        }
    }else{
        for (NSString *str in array) {
            if ([str rangeOfString:string].length > 0) {
                [_dataArray addObject:str];
            }
        }
    }
    
    if (_dataArray.count > 0) {
        _tabelView.tableHeaderView = tableHeaderView;
        _tabelView.tableFooterView = tableFootView;
    }else{
        _tabelView.tableHeaderView = nil;
        _tabelView.tableFooterView = nil;
    }
    [_tabelView reloadData];
}

//保存搜索字符串
-(void)updataOFhistory:(NSString *)string{
    
    if (string.length == 0) {
        return;
    }
    NSArray *array = [_userDefaults objectForKey:history];
    if (array == nil) {
        array = [[NSArray alloc] init];
    }
    NSMutableArray *mArary = [[NSMutableArray alloc] initWithArray:array];
    [mArary removeObject:string];
    [mArary addObject:string];
    if (mArary.count > 15) {
        [mArary removeObjectAtIndex:0];
    }
    [_userDefaults setObject:mArary forKey:history];
    [_userDefaults synchronize];
}

#pragma mark - pushToController
-(void)pushController:(NSString *)searchString{
    [self.searchBar resignFirstResponder];
    
    CZWSearchResultsViewController *results = [[CZWSearchResultsViewController alloc] init];
    results.searchString = searchString;
    [self.navigationController pushViewController:results animated:YES];
}

#pragma mark - UITableViewDeleate/datasouch
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 39, WIDTH-30, 1)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1];
        [cell.contentView addSubview:view];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = colorBlack;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self pushController:_dataArray[indexPath.row]];
}

#pragma mark - UISearchResultsDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
//    [self setUrlWith:self.searchBar.text andP:_count andS:_number];
   // [self.searchBar resignFirstResponder];
    [self updataOFhistory:self.searchBar.text];
  
    [self pushController:self.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self reloadDataOFtableview:self.searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [self reloadDataOFtableview:self.searchBar.text];
    return YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
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
