//
//  CityChooseViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CityChooseViewController.h"
#import "CZWManager.h"

@interface CityChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_oneTableView;
    NSArray *_oneDataArray;
    
    UIView *_twoSuperView;
    UITableView *_twoTableView;
    NSArray *_twoDataArray;
    
    NSString *_pid;
    NSString *_pName;
    NSString *_cid;
    NSString *_cName;
}

@end

@implementation CityChooseViewController
//+(void)downloadProviceList{
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html", nil];
//    
//    [manager GET:auto_province parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSArray *array = responseObject;
//        // 沙盒的目录
//        NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//        NSString *filePath = [documentPath  objectAtIndex:0];
//        //获取路径
//        NSString *filename=[filePath stringByAppendingPathComponent:plistProviceList];
//        //写入文件
//        BOOL yes = [array writeToFile:filename atomically:YES];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//读取省份列表
//+(NSArray *)readProviceList{
//    //    NSString *plistPath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:plistProviceList];
//    //    NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
//    //    NSLog(@"%@",data);
//    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *filePath = [documentPath  objectAtIndex:0];
//    NSString *filename=[filePath stringByAppendingPathComponent:plistProviceList];   //获取路径
//    // 读取文件
//    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filename];
//    return array;
//}

-(void)loadDataOne{
    [CZWAFHttpRequest GET:auto_province success:^(id responseObject) {
        _oneDataArray = responseObject;
        [_oneTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadDataTwo:(NSString *)pid{
    NSString *urlSting = [NSString stringWithFormat:auto_city,pid];
    [CZWAFHttpRequest GET:urlSting success:^(id responseObject) {
        _twoDataArray = responseObject;
        [_twoTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 

    self .title = @"省、市";
   // self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    [self RightItem];
    [self createTableView];
    [self loadDataOne];
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


-(void)RightItem{
    UIButton *rightItemButton = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"关闭"];
    [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
}

-(void)rightItemClick{
    if (self.navigationController.viewControllers.count==1) {
          [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)createTableView{

    _oneTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _oneTableView.delegate = self;
    _oneTableView.dataSource = self;
    _oneTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _oneTableView.separatorColor = colorLineGray;
    [self.view addSubview:_oneTableView];
    
    _twoSuperView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH+10, 64, WIDTH/3*2,HEIGHT-64)];
    _twoSuperView.layer.shadowColor = [UIColor blackColor].CGColor;
    _twoSuperView.layer.shadowOffset = CGSizeMake(-4, 0);
    _twoSuperView.layer.shadowOpacity = 0.5;
    [self.view addSubview:_twoSuperView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_twoSuperView addGestureRecognizer:pan];
    
    _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _twoSuperView.frame.size.width, _twoSuperView.frame.size.height) style:UITableViewStylePlain];
    _twoTableView.delegate = self;
    _twoTableView.dataSource = self;
    _twoTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _twoTableView.separatorColor = colorLineGray;
    [_twoSuperView addSubview:_twoTableView];
}

#pragma mark - 滑动
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.view];
    
    if (point.x+pan.view.frame.origin.x > WIDTH/3) {
        pan.view.center = CGPointMake(point.x+pan.view.center.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.frame.origin.x< WIDTH/3+30) {
            [UIView animateWithDuration:0.3 animations:^{
                pan.view.frame = CGRectMake(WIDTH/3, 64, WIDTH/3*2, HEIGHT-64);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                pan.view.frame = CGRectMake(WIDTH+10, 64, WIDTH/3*2, HEIGHT-64);
            }];
        }
    }
}

-(void)returnRsults:(returnResults)block{
    self.block = block;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _oneTableView) return _oneDataArray.count;
    return _twoDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _oneTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecell"];
   
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = _oneDataArray[indexPath.row][@"Name"];
     
        if ([cell.textLabel.text isEqualToString:_pName]) {
            cell.textLabel.textColor = colorNavigationBarColor;
 
        }else{
            cell.textLabel.textColor = colorBlack;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twocell"];

       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = _twoDataArray[indexPath.row][@"name"];
    if ([cell.textLabel.text isEqualToString:_cName]) {
        cell.textLabel.textColor = colorNavigationBarColor;

    }else{
        cell.textLabel.textColor = colorBlack;

    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _oneTableView) {
    
        NSDictionary *dict = _oneDataArray[indexPath.row];
        if (![_pid isEqualToString:dict[@"Id"]]) {
            [self loadDataTwo:dict[@"Id"]];
            _twoSuperView.frame = CGRectMake(WIDTH+10, 64, WIDTH/3*2, HEIGHT-64);
            
            _pid = dict[@"Id"];
            _pName = dict[@"Name"];
            _cName = @"";
            _cid = @"";
            
            [_oneTableView reloadData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _twoSuperView.frame = CGRectMake(WIDTH/3, 64, WIDTH/3*2, HEIGHT-64);
        }];
    }else{
        NSDictionary *dict = _twoDataArray[indexPath.row];

        if (![_cName isEqualToString:dict[@"name"]]) {
            
            _cid = dict[@"id"];
            _cName = dict[@"name"];
            [_twoTableView reloadData];
        }
        if (self.block) {
            self.block(_pName,_pid,_cName,_cid);
        }
        [self rightItemClick];
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
