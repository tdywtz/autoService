//
//  CZWCollectViewController.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWCollectViewController.h"
#import "CZWCollectCell.h"
#import "CZWUserInformationViewController.h"
#import "CZWAppealDetailsViewController.h"

@interface CZWCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIView *_spaceView;
    
    CZWCollectCell *tempCell;
}
@end

@implementation CZWCollectViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        self.title = @"我的收藏";
    }
    return self;
}

-(void)loadData:(NSString *)url{
    //加载提示框
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
      
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) return ;
        
        if ([responseObject firstObject][@"error"]) {
            [CZWAlert customAlert:[responseObject firstObject][@"error"]];
            
        }else{
            [_dataArray removeAllObjects];
            //  NSLog(@"%@",responseObject);
            for (NSDictionary *dict in responseObject) {
                CZWAppealModel *model = [[CZWAppealModel alloc] init];
                model.uid = dict[@"uid"];
                model.cpid = dict[@"cpid"];
                model.name = dict[@"name"];
                model.headpic = dict[@"headpic"];
                model.cname = dict[@"cname"];
                model.brandname = dict[@"brandname"];
                model.seriesname = dict[@"seriesname"];
                model.modelname = dict[@"modelname"];
                model.steps =dict[@"steps"];
                model.title = dict[@"title"];
                model.content = dict[@"content"];
                model.image = dict[@"image"];
                model.date = dict[@"date"];
                model.applynum = dict[@"applynum"];
                
                tempCell.model = model;
                model.cellHeight = [tempCell viewHeight];
                [_dataArray addObject:model];
            }
        }
      
        if (_dataArray.count == 0) _spaceView.hidden = NO;
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

-(void)readCollectData{
    CZWFmdbManager *md = [CZWFmdbManager manager];
    NSArray *array = [md selectAllFromCollect];
    if (array.count == 0) {
        _spaceView.hidden = NO;
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        return;
    }
    
    NSString *string = [array componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:auto_collect,string];
    
    [self loadData:url];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tempCell = [[CZWCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    [self createLeftItemBack];
    [self createTableView];
    [self createSpaceView];
    [self readCollectData];
}

-(void)createSpaceView{
    _spaceView = [[UIView alloc] initWithFrame:self.view.frame];
    _spaceView.hidden = YES;
    [self.view addSubview:_spaceView];
    
    UIImageView *iamgeView = [LHController createImageViewWithFrame:CGRectMake(0, 0, 80, 80) ImageName:@"auto_collectNullStar"];
    iamgeView.center = CGPointMake(WIDTH/2, self.view.frame.size.height/2-80);
    [_spaceView addSubview:iamgeView];
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, iamgeView.frame.origin.y+iamgeView.frame.size.height+20, WIDTH, 20) Font:[LHController setFont]-2 Bold:NO TextColor:colorBlack Text:@"暂无收藏内容"];
    label.textAlignment = NSTextAlignmentCenter;
    [_spaceView addSubview:label];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CZWCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CZWCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [cell individualInformation:^(CZWAppealModel *model) {
        //            CZWUserInformationViewController *infomation  = [[CZWUserInformationViewController alloc] init];
        //            infomation.userID = model.uid;
        //            [self.navigationController pushViewController:infomation animated:YES];
        //        }];
        
        [cell gestureBlock:^(CZWCollectCell *czwCell) {
            CZWActionSheet *sheet = [[CZWActionSheet alloc] initWithArray:@[@"删除",@"取消"]];
            [sheet choose:^(CZWActionSheet *actionSheet, NSInteger selectedIndex) {
                actionSheet = nil;
                if (selectedIndex == 0) {
                    CZWFmdbManager *manager = [CZWFmdbManager manager];
                    NSIndexPath *path = [_tableView indexPathForCell:czwCell];
                    CZWAppealModel *model = _dataArray[path.row];
                    [manager deleteFromCollectWith:model.cpid];
                    [_dataArray removeObjectAtIndex:path.row];
                    [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
                }
            }];
            [sheet show];
        }];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CZWAppealModel *model = _dataArray[indexPath.row];

    return model.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CZWAppealModel *model = _dataArray[indexPath.row];
    CZWAppealDetailsViewController *details = [[CZWAppealDetailsViewController alloc] init];
    details.cpid = model.cpid;
    details.targetUname = model.name;
    [self.navigationController pushViewController:details animated:YES];
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
