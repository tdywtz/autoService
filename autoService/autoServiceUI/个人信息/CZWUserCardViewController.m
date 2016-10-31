//
//  CZWUserCardViewController.m
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserCardViewController.h"
//#import "CZWUserCardCell.h"
#import "CZWCardCell.h"
#import "CityChooseViewController.h"
#import "CZWBasicPanNavigationController.h"
#import "CZWChooseCarModelViewController.h"
#import "CZWCardChooseViewController.h"
#import "ChooseViewController.h"
#import "CZWActionSheet.h"
#import "CZWBasicPanNavigationController.h"

@interface CZWUserCardViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSString *_urlString;
    UIImagePickerController *myPicker;
}
@property (nonatomic,strong) CZWUserInfoUser *infoUser;
@end

@implementation CZWUserCardViewController

-(void)loadData{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWHttpModelResults requestUserInfoWithUserId:[CZWManager manager].roleId result:^(CZWUserInfoUser *userInfo) {
        [hud hideAnimated:YES];
        self.infoUser = userInfo;
        [_tableView reloadData];
    
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"个人中心";
    [self createLeftItemBack];
    [self createTableView];
    [self loadData];
    [self setGetUrlstring];
   
}


-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    [self.view addSubview:_tableView];
    
    self.scrollView = (UIScrollView *)_tableView;
    [self createNotification];
}

#pragma mark - 设置链接
-(void)setGetUrlstring{
    CZWManager *manager = [CZWManager manager];
    if ([manager.RoleType isEqualToString:isUserLogin]) {
       _urlString = [NSString stringWithFormat:@"%@&uid=%@",user_updateInformation,manager.roleId];
    
    }else{
       _urlString = [NSString stringWithFormat:@"%@&eid=%@",expert_updateInformation,manager.roleId];
    }
}

#pragma mark - 提交数据
-(void)submitData:(NSString *)url controller:(CZWUserCardViewController *)weakSelf{
 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) return ;
        
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"error"]) {
            [CZWAlert alertDismiss:dict[@"error"]];
        }else{
            [CZWAlert alertDismiss:dict[@"scuess"]];
            [[CZWManager manager] updataUserInfo];
            [weakSelf loadData];
        }

    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
    }];
}

#pragma mark - 选择上传头像
-(void)chooseIconIamge{
    CZWActionSheet *sheet = [[CZWActionSheet alloc] initWithArray:@[@"拍照",@"从相册选择",@"取消"]];
    [sheet choose:^(CZWActionSheet *actionSheet, NSInteger selectedIndex) {
        if (selectedIndex == 2) return;
        if (myPicker == nil) {
            myPicker = [[UIImagePickerController alloc] init];
            myPicker.navigationBar.tintColor = [UIColor whiteColor];
            myPicker.navigationBar.barTintColor = colorNavigationBarColor;
            myPicker.delegate = self;
            myPicker.allowsEditing = YES;
        }
        
        if (selectedIndex == 0) {
            
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:myPicker animated:YES completion:nil];
            }
        }else if(selectedIndex == 1){
            myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:myPicker animated:YES completion:NULL];
        }

    }];
    [sheet show];
}

#pragma mark - 上传头像
-(void)postImage:(UIImage *)image{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest requestUpdataIconImage:image parameters:@{@"uid":[CZWManager manager].roleId} type:CCUserType_User success:^(id responseObject) {
       
        [hud hideAnimated:YES];
        
        if (![responseObject count]) return ;
        
        if (responseObject[0][@"error"]) {
            [CZWAlert alertDismiss:responseObject[0][@"error"]];
        }else{
            [CZWAlert alertDismiss:responseObject[0][@"scuess"]];
            
            [[SDImageCache sharedImageCache] removeImageForKey:self.infoUser.img];
            [[CZWManager manager] updataUserInfo];
            [self loadData];
        }

    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 导航条代理
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (navigationController == myPicker) {
        myPicker.navigationBar.barStyle = UIBarStyleBlack;
    }
}

#pragma mark - imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self postImage:image];
     //保存照片
    // UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [myPicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"已存入手机相册"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"保存失败"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil ];
        [alert show];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)      return 1;
    else if (section == 1) return 4;
    else if (section == 2) return 4;
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"card"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *imageView = [LHController createImageViewWithFrame:CGRectMake(WIDTH-35-60, 10, 60, 60) ImageName:@"userIconDefaultImage"];
            imageView.tag = 100;
            imageView.layer.cornerRadius = 3;
            imageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 30, 100, 20)
                                                           Font:15 Bold:NO TextColor:colorBlack Text:@"头像"];
            [cell.contentView addSubview:label];
        }
        UIImageView *iconIamgeView = (UIImageView *)[cell.contentView viewWithTag:100];
        [iconIamgeView sd_setImageWithURL:[NSURL URLWithString:self.infoUser.img]
                         placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
        return cell;
    }
    
    CZWCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardcell"];
    if (!cell) {
        cell = [[CZWCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardcell"];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
             cell.accessoryType = UITableViewCellAccessoryNone;
            cell.leftLabel.text = @"用户名";
            cell.placeholder = @"";
            cell.rightText = self.infoUser.uname;
        }else if (indexPath.row == 1){
            cell.leftLabel.text = @"真实姓名";
            cell.placeholder = @"请输入您的真实姓名";
            cell.rightText = self.infoUser.rname;
        }else if (indexPath.row == 2){
            cell.leftLabel.text = @"性别";
            cell.placeholder = @"请选择您的性别";
            cell.rightText = [self.infoUser.sex integerValue] == 1?@"男":@"女";
        }else{
            cell.leftLabel.text = @"生日";
            cell.placeholder = @"请选择您的生日";
            cell.rightText = self.infoUser.birth;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"手机号";
            cell.placeholder = @"请输入您的手机号";
            cell.rightText = self.infoUser.mobile;
            
        }else if (indexPath.row == 1){
            cell.leftLabel.text = @"电子邮箱";
            cell.placeholder = @"请输入您的电子邮箱";
            cell.rightText = self.infoUser.email;
            
        }else if (indexPath.row == 2){
            cell.leftLabel.text = @"固定电话";
            cell.placeholder = @"请输入您的固定电话";
            cell.rightText = self.infoUser.phone;
            
        }else {
            cell.leftLabel.text = @"QQ";
            cell.placeholder = @"请输入您的QQ";
            cell.rightText = self.infoUser.qq;
        }

    }else{
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"爱车";
            cell.placeholder = @"请选择您的车型";
            cell.rightText = self.infoUser.modelName;
        }else{
            cell.leftLabel.text = @"地区";
            cell.placeholder = @"请选择您所在地区";
            cell.rightText = self.infoUser.city;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 80;
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CZWCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        [self chooseIconIamge];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return;
        }
      
        if (indexPath.row == 1) {
            CZWCardChooseViewController *choose = [[CZWCardChooseViewController alloc] init];
            [choose success:^(NSString *updateKey, NSString *value) {
                [self loadData];
            }];
            choose.choose = cardChooseTypeName;
            choose.updateKey = @"realname";
            choose.textFieldText = cell.rightText;
            [self.navigationController pushViewController:choose animated:YES];
            
        }else if (indexPath.row == 2){
            ChooseViewController *chooseView = [[ChooseViewController alloc] init];
            __weak __typeof(self)weakSelf = self;
            [chooseView retrunResults:^(NSString *title, NSString *ID) {
                NSString *sex = [title isEqualToString:@"男"]?@"1":@"2";
                NSString *url = [NSString stringWithFormat:@"%@&gender=%@",_urlString,sex];
                [self submitData:url controller:weakSelf];
              
            }];
            chooseView.choosetype = chooseTypeSex;
            [self.navigationController pushViewController:chooseView animated:YES];
            
        }else if (indexPath.row == 3){
            CZWCardChooseViewController *choose = [[CZWCardChooseViewController alloc] init];
            [choose success:^(NSString *updateKey, NSString *value) {
                [self loadData];
            }];
            choose.choose = cardChooseTypeBirth;
            choose.updateKey = @"birth";
            choose.textFieldText = cell.rightText;
            [self.navigationController pushViewController:choose animated:YES];
        }
        
        
    }else if (indexPath.section == 2){

        CZWCardChooseViewController *choose = [[CZWCardChooseViewController alloc] init];
        [choose success:^(NSString *updateKey, NSString *value) {
            [self loadData];
        }];
        choose.textFieldText = cell.rightText;
        if (indexPath.row == 0) {
            choose.choose = cardChooseTypePhoneNumber;
            choose.updateKey = @"mobile";
            
        }else if (indexPath.row == 1){
            choose.choose = cardChooseTypeEmail;
            choose.updateKey = @"email";
            
        }else if (indexPath.row == 2){
            choose.choose = cardChooseTypeTelephone;
            choose.updateKey = @"telephone";
            
        }else {
            choose.choose = cardChooseTypeQQ;
            choose.updateKey = @"qq";
            
        }
        [self.navigationController pushViewController:choose animated:YES];
        
    }else{
        if (indexPath.row == 0) {
           
            CZWChooseCarModelViewController *choose = [[CZWChooseCarModelViewController alloc] init];
            CZWBasicPanNavigationController *nvc = [[CZWBasicPanNavigationController alloc] initWithRootViewController:choose];
            __weak __typeof(self)weakSelf = self;
            [choose results:^(NSString *brandName, NSString *brandId, NSString *seriesNmae, NSString *seriesId, NSString *modelName, NSString *modelId) {
           
                NSString *url = [NSString stringWithFormat:@"%@&bname=%@&bid=%@&sname=%@&sid=%@&mname=%@&mid=%@",
                                 _urlString,brandName,brandId,seriesNmae,seriesId,modelName,modelId];
                [self submitData:url controller:weakSelf];
            }];
            choose.root = YES;
            choose.choosetype = chooseTypeBrand;
            [self presentViewController:nvc animated:YES completion:nil];
        }else {
            
            CityChooseViewController *city = [[CityChooseViewController alloc] init];
            [city createLeftItemBack];
           // CZWBasicPanNavigationController *nvc = [[CZWBasicPanNavigationController alloc] initWithRootViewController:city];
            __weak __typeof(self)weakSelf = self;
            [city returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
               NSString *url = [NSString stringWithFormat:@"%@&pro=%@&pid=%@&city=%@&cid=%@",
                                _urlString,pName,pid,cName,cid];
               [self submitData:url controller:weakSelf];
           }];
            //[self presentViewController:nvc animated:YES completion:nil];
            [self.navigationController pushViewController:city animated:YES];
        }
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
