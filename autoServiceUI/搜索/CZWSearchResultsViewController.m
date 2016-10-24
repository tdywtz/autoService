//
//  CZWSearchResultsViewController.m
//  autoService
//
//  Created by bangong on 15/12/9.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWSearchResultsViewController.h"
#import "CZWAppealDetailsViewController.h"
#import "CZWBasicPanNavigationController.h"

@interface CZWSearchResultsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_urlString;
    NSInteger _number;
    CGFloat textFont;
    NSInteger _count;
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    
    BOOL isOne;
    UIView *noView;

}
@end

@implementation CZWSearchResultsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        _number = 15;
        if (HEIGHT == 480) {
            _number = 9;
        }
        if (HEIGHT == 568) {
            _number = 12;
        }
        if (HEIGHT > 680) {
            _number = 17;
        }
        textFont = [LHController setFont]-2;
        _count = 1;
    }
    return self;
}

#pragma mark 请求数据
-(void)loadData{
    NSString *url = [NSString stringWithFormat:auto_search,[CZWManager manager].userType,self.searchString,_count,_number];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [_tableView.mj_footer endRefreshing];
        if ([responseObject count] == 0) {
            return ;
        }
        NSString *error = [responseObject firstObject][@"error"];
        if (error) {
            [CZWAlert alertDismiss:error];
            
        }else{
            if (_count == 1) {
               
                [_dataArray removeAllObjects];
            }
            if ([responseObject count] == 0) {
              
            }
            for (NSDictionary *dict in responseObject) {
                
                [_dataArray addObject:dict];
            }
            [_tableView reloadData];
            
            if ([_dataArray count] == 0) {
                noView.hidden = NO;
            }else{
                noView.hidden = YES;
            }
        }
        if (_dataArray.count == 0) {
            noView.hidden = NO;
        }else{
            noView.hidden = YES;
        }
      
    } failure:^(NSError *error) {
        [_tableView.mj_footer endRefreshing];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"搜索结果";
    [self createLeftItemBack];
    [self createTabelView];
    [self createNoView];
    [self loadData];
}

#pragma mark 搜索不到数据
-(void)createNoView{
    noView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49)];
    noView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:noView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    imageView.image = [UIImage imageNamed:@"90"];
    imageView.center = CGPointMake(WIDTH/2, HEIGHT/2-150);
    [noView addSubview:imageView];
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, 180, 20) Font:textFont Bold:NO TextColor:[UIColor blackColor] Text:@"暂无相关数据"];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(WIDTH/2, imageView.frame.origin.y+imageView.frame.size.height+20);
    [noView addSubview:label];
    
    noView.hidden = YES;
}

#pragma mark uitabelView创建
-(void)createTabelView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];

}

//-(void)rightitemClick{
//    [self.searchBar endEditing:YES];
//
//    double delayInSeconds = 0.2;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//        [self.navigationController popViewControllerAnimated:YES];
//    });
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str searchStr:(NSString *)search{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:textFont] range:NSMakeRange(0, att.length)];
    for (int i = 0; i < search.length; i ++) {
        NSRange ran = {i,1};
        NSString *sub = [search substringWithRange:ran];
        NSRange range = [str rangeOfString:sub];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
    }
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    //[style setLineBreakMode:NSLineBreakByWordWrapping];
    // style.firstLineHeadIndent = 30;
    //style.paragraphSpacing = 20;
    [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];
    return att;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 39, WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1];
        [cell.contentView addSubview:view];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.textLabel.attributedText = [self attributeSize:dict[@"title"] searchStr:self.searchString];
    cell.textLabel.text = dict[@"title"];
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSDictionary *dict = _dataArray[indexPath.row];
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    details.cpid = dict[@"cpid"];
    details.targetUname = dict[@"name"];
    details.targetUid =  dict[@"uid"];
    [self.navigationController pushViewController:details animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    // [MobClick endLogPageView:@"PageOne"];
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
