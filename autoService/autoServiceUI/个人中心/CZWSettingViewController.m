//
//  CZWSettingViewController.m
//  autoService
//
//  Created by luhai on 15/11/29.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWSettingViewController.h"
#import "CZWOriginalViewController.h"
#import "AppDelegate.h"
#import "CZWServiceViewController.h"
#import "CZWAboutViewController.h"
#import "CZWNewsMessageNotificationViewController.h"

@interface CZWSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,NSFileManagerDelegate>
{
    CGFloat textFont;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CZWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    textFont = [LHController setFont]-1;
    self.title = @"设置";
    [self createLeftItemBack];
    [self createTableView];
    [self createLogOut];
}

-(void)createLogOut{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2)];
    self.tableView.tableFooterView = view;
    UIButton *btn = [LHController createButtnFram:CGRectMake(10, 100, WIDTH-20, 40) Target:self Action:@selector(btnCLick) Font:[LHController setFont]-2 Text:@"退出登录"];
    [view addSubview:btn];
}

-(void)btnCLick{
   
     AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __block UIViewController *control = app.window.rootViewController;
    CZWOriginalViewController *orighinal = [[CZWOriginalViewController alloc] init];
  
    
    [UIView animateWithDuration:0.3 animations:^{
        app.window.rootViewController = orighinal;
    }completion:^(BOOL finished){
        control = nil;
        [[CZWManager manager] logout];
    }];
}

-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
 
    [self.view addSubview:self.tableView];
}

-(NSString *)getStore{
    
  //  long long a = [self fileSizeAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"]];
    NSInteger m =  [[SDImageCache sharedImageCache] getSize];
  
    NSString *pathString = pathString= [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/threeService/RCloudCache"];
    NSInteger k =  [[CZWManager manager] sizeWithFilePath:pathString];
   
    pathString = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/RongCloud"];
    k += [[CZWManager manager] sizeWithFilePath:pathString];
    
    pathString = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/com.12365auto.threeService"];
    k += [[CZWManager manager] sizeWithFilePath:pathString];
    
    
    CGFloat n = k+m/(1024*1024.0);
    if (n < 0) {
        n = 0;
    }
 
    return  [NSString stringWithFormat:@"%0.1f MB",n];
    //NSLog(@"%llu",a)
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    //NSLog(@"%@",filePath);
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 清除缓存
- (void)deleteDatabse
{
    //清除sdimage缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    NSString *pathString = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/threeService/RCloudCache"];
    [self clearCachesFromDirectoryPath:pathString];
    pathString = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/RongCloud"];
     [self clearCachesFromDirectoryPath:pathString];
    pathString = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/com.12365auto.threeService"];
    [self clearCachesFromDirectoryPath:pathString];
     pathString = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
    [self clearCachesWithFilePath:pathString];
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    double time = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((double)time * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [hud hideAnimated:YES];
       
    });
}

#pragma mark - 得到指定目录下的所有文件
- (NSArray *)getAllFileNames:(NSString *)dirPath{
    [NSFileManager defaultManager].delegate = self;
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath error:nil];
    return files;
}
#pragma mark - 删除指定目录或文件
- (BOOL)clearCachesWithFilePath:(NSString *)path{
    NSFileManager *mgr = [NSFileManager defaultManager];
    return [mgr removeItemAtPath:path error:nil];
}

#pragma mark - 清空指定目录下文件
- (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath{
    //获得全部文件数组
    NSArray *fileAry =  [self getAllFileNames:dirPath];
    //遍历数组
    BOOL flag = NO;
    for (NSString *fileName in fileAry) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        flag = [self clearCachesWithFilePath:filePath];
        if (!flag)
            break;
    }
    return flag;
}

#pragma mark - NSFileManagerDelegate
- (BOOL)fileManager:(NSFileManager *)fileManager shouldRemoveItemAtPath:(NSString *)path{
    NSIndexPath *indexpath  = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) return 1;
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingOnecell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingOnecell"];
            cell.textLabel.font = [UIFont systemFontOfSize:textFont];
            cell.textLabel.textColor = colorBlack;
            

            UILabel *label = [LHController createLabelWithFrame:CGRectMake(WIDTH-100, 12, 80, 20) Font:textFont-2 Bold:NO TextColor:colorDeepGray Text:nil];
            label.textAlignment = NSTextAlignmentRight;
            label.tag = 100;
            [cell.contentView addSubview:label];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"清除缓存";
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
        label.text = [self getStore];
        return cell;
    }
   
    /////
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingTwocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingTwocell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:textFont];
        cell.textLabel.textColor = colorBlack;

        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *versionNow = [info objectForKey:@"CFBundleShortVersionString"];
        
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(WIDTH-100, 12, 80, 20) Font:14 Bold:NO TextColor:colorDeepGray Text:versionNow];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = 200;
        [cell.contentView addSubview:label];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:200];
    label.hidden = YES;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"用户服务使用协议";
        }else if (indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryNone;
            label.hidden = NO;
            cell.textLabel.text = @"版本号";
        }else{
            cell.textLabel.text = @"关于我们";
        }

    }else{
         cell.textLabel.text = @"新消息通知";
    }
       return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
  
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要清除缓存吗？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            CZWServiceViewController *sevice = [[CZWServiceViewController alloc] init];
            sevice.urlString = @"http://m.12365auto.com/user/agreeForIOS.shtml";
            [self.navigationController pushViewController:sevice animated:YES];
        }else if (indexPath.row == 2){
            CZWAboutViewController *about = [[CZWAboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
    }else{
        CZWNewsMessageNotificationViewController *notification = [[CZWNewsMessageNotificationViewController alloc] initWithStyle:UITableViewStyleGrouped];
        notification.title = @"新消息通知";
        [self.navigationController pushViewController:notification animated:YES];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteDatabse];
    }
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
