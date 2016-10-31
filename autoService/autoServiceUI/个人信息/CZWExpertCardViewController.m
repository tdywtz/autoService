//
//  CZWExpertCardViewController.m
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertCardViewController.h"
#import "CZWCardCell.h"
#import "CZWCardChooseViewController.h"
#import "ChooseViewController.h"
#import "CityChooseViewController.h"
#import "CZWActionSheet.h"

@interface CZWExpertCardViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    UIImagePickerController *myPicker;
    NSString *_urlString;
}
@property (nonatomic,strong) NSDictionary *dictionary;
@end

@implementation CZWExpertCardViewController

-(void)loadData{
 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest requestInfoWithId:[CZWManager manager].roleId type:CCUserType_Expert success:^(id responseObject) {
       // NSLog(@"%@",responseObject);
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) {
            return ;
        }
        self.dictionary = [responseObject firstObject];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
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

#pragma mark - 选择上传头像
-(void)chooseIconIamge{
    
    CZWActionSheet *sheet = [[CZWActionSheet alloc] initWithArray:@[@"拍照",@"从相册选择",@"取消"]];
    [sheet choose:^(CZWActionSheet *actionSheet, NSInteger selectedIndex) {
        if (selectedIndex == 2) return;
        if (myPicker == nil) {
            myPicker = [[UIImagePickerController alloc] init];
            myPicker.navigationBar.tintColor = [UIColor whiteColor];
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
    
    [CZWAFHttpRequest requestUpdataIconImage:image parameters:@{@"eid":[CZWManager manager].roleId} type:CCUserType_Expert success:^(id responseObject) {
        
        [hud hideAnimated:YES];
      //  NSLog(@"%@",responseObject);
        if ([responseObject count] == 0) return;
        
        if (responseObject[0][@"error"]) {
            [CZWAlert alertDismiss:responseObject[0][@"error"]];
        }else{
            [CZWAlert alertDismiss:responseObject[0][@"scuess"]];
            [[CZWManager manager] updataExpertInfo];
            [[SDImageCache sharedImageCache] removeImageForKey:[CZWManager manager].roleIconImage];
            [self loadData];
        }
    } failure:^(NSError *error) {
        
        [hud hideAnimated:YES];
    }];
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
-(void)submitData:(NSString *)url{
  //  NSLog(@"===%@",url);
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) {
            return ;
        }
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"error"]) {
            [CZWAlert alertDismiss:dict[@"error"]];
        }else{
            [CZWAlert alertDismiss:dict[@"scuess"]];
            
            [[SDImageCache sharedImageCache] removeImageForKey:self.dictionary[@"headpic"]];
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
 //   NSData *data = UIImageJPEGRepresentation(image, 1);
    [self postImage:image];
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
    else if (section == 1) return 3;
    else if (section == 2) return 6;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardIcon"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardIcon"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *imageView = [LHController createImageViewWithFrame:CGRectMake(WIDTH-35-60, 10, 60, 60) ImageName:@"expertIconDefaultImage"];
            imageView.tag = 100;
            imageView.layer.cornerRadius = 30;
            imageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 30, 100, 20) Font:[LHController setFont]-2 Bold:NO TextColor:colorBlack Text:@"头像"];
            [cell.contentView addSubview:label];
        }
        UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:100];
        [icon sd_setImageWithURL:[NSURL URLWithString:self.dictionary[@"headpic"]] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
        return cell;
    }
    
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardFoot"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardFoot"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 30, 80, 20) Font:[LHController setFont]-2 Bold:NO TextColor:colorBlack Text:@"擅长领域"];
            [cell.contentView addSubview:label];
            
            UILabel *left = [LHController createLabelWithFrame:CGRectZero Font:[LHController setFont]-2 Bold:NO TextColor:colorBlack Text:nil];
            left.tag = 200;
            [cell.contentView addSubview:left];
            [left makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(0);
                make.centerY.equalTo(cell.contentView);
                make.size.lessThanOrEqualTo(CGSizeMake(WIDTH-95-30, 60));
            }];
        
        }
        UILabel *left = (UILabel *)[cell.contentView viewWithTag:200];
        left.text = self.dictionary[@"goodatarea"];
        return cell;
    }

    CZWCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardcell"];
    if (!cell) {
        cell = [[CZWCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardcell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 1) {
       if (indexPath.row == 0){
            cell.leftLabel.text = @"真实姓名";
            cell.placeholder = @"请输入真实姓名";
            cell.rightText = self.dictionary[@"realname"];
           cell.accessoryType = UITableViewCellAccessoryNone;
           
        }else if (indexPath.row == 1){
            cell.leftLabel.text = @"性别";
            cell.placeholder = @"请选择性别";
            cell.rightText = [self.dictionary[@"sex"] integerValue]==1? @"男":@"女";
            
        }else{
            cell.leftLabel.text = @"年龄";
            cell.placeholder = @"请输入年龄";
            cell.rightText = self.dictionary[@"age"];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"手机号";
            cell.placeholder = @"请输入手机号";
            cell.rightText = self.dictionary[@"mobile"];
            
        }else if (indexPath.row == 1){
            cell.leftLabel.text = @"地区";
            cell.placeholder = @"请选择地区";
            cell.rightText = [NSString stringWithFormat:@"%@%@",self.dictionary[@"pro"],self.dictionary[@"city"]];
            
        }else if (indexPath.row == 2){
            cell.leftLabel.text = @"电子邮箱";
            cell.placeholder = @"请输入电子邮箱";
            cell.rightText = self.dictionary[@"email"];
            
        }else if (indexPath.row == 3){
            cell.leftLabel.text = @"公司";
            cell.placeholder = @"请输入公司名称";
            cell.rightText = self.dictionary[@"company"];
            
        }else if (indexPath.row == 4){
            cell.leftLabel.text = @"职业";
            cell.placeholder = @"请输入职业";
            cell.rightText = self.dictionary[@"job"];
        }else{
            cell.leftLabel.text = @"技术组别";
            cell.placeholder = @"";
            cell.rightText = self.dictionary[@"techGroup"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else{
       
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 80;
    if (indexPath.section == 3) return 80;
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self chooseIconIamge];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
   
//            CZWCardChooseViewController *cardChoose = [[CZWCardChooseViewController alloc] init];
//            [cardChoose success:^(NSString *updateKey, NSString *value) {
//                [self loadData];
//            }];
//            cardChoose.choose = cardChooseTypeName;
//            cardChoose.textFieldText = self.dictionary[@"realname"];
//            cardChoose.updateKey = @"realname";
//            [self.navigationController pushViewController:cardChoose animated:YES];
            
        }else if (indexPath.row == 1){
            //性别
            ChooseViewController *chooseView =[[ChooseViewController alloc] init];
            [chooseView retrunResults:^(NSString *title, NSString *ID) {
                NSString *sex = [title isEqualToString:@"男"]?@"1":@"2";
                NSString *url = [NSString stringWithFormat:@"%@&gender=%@",_urlString,sex];
                [self submitData:url];
            }];
            chooseView.choosetype = chooseTypeSex;
            [self.navigationController pushViewController:chooseView animated:YES];
            
        }else{
            CZWCardChooseViewController *cardChoose = [[CZWCardChooseViewController alloc] init];
            [cardChoose success:^(NSString *updateKey, NSString *value) {
                [self loadData];
            }];
            cardChoose.choose = cardChooseTypeAge;
            cardChoose.textFieldText = self.dictionary[@"age"];
            cardChoose.updateKey = @"age";

            [self.navigationController pushViewController:cardChoose animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 5) {
            return;
        }
        CZWCardChooseViewController *cardChoose = [[CZWCardChooseViewController alloc] init];
        [cardChoose success:^(NSString *updateKey, NSString *value) {
            [self loadData];
        }];
        if (indexPath.row == 0) {
            cardChoose.choose = cardChooseTypePhoneNumber;
            cardChoose.textFieldText = self.dictionary[@"mobile"];
            cardChoose.updateKey = @"mobile";

        }else if (indexPath.row == 1){
            CityChooseViewController *city = [[CityChooseViewController alloc] init];
            [city createLeftItemBack];
            [city returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
                NSString *url = [NSString stringWithFormat:@"%@&pro=%@&pid=%@&city=%@&cid=%@",
                                 _urlString,pName,pid,cName,cid];
                [self submitData:url];
            }];
            [self.navigationController pushViewController:city animated:YES];
            cardChoose = nil;
            return;
            
        }else if (indexPath.row == 2){
            cardChoose.choose = cardChooseTypeEmail;
            cardChoose.textFieldText = self.dictionary[@"email"];
            cardChoose.updateKey = @"email";
            
        }else if (indexPath.row == 3){
            cardChoose.choose = cardChooseTypeCompany;
            cardChoose.textFieldText = self.dictionary[@"company"];
            cardChoose.updateKey = @"company";
            
        }else if (indexPath.row == 4){
            cardChoose.choose = cardChooseTypeProfessional;
            cardChoose.textFieldText = self.dictionary[@"job"];
            cardChoose.updateKey = @"job";
            
        }
        [self.navigationController pushViewController:cardChoose animated:YES];
        
    }else{
        CZWCardChooseViewController *cardChoose = [[CZWCardChooseViewController alloc] init];
        [cardChoose success:^(NSString *updateKey, NSString *value) {
            [self loadData];
        }];
        cardChoose.choose = cardChooseTypeBeGoodAt;
        cardChoose.textFieldText = self.dictionary[@"goodatarea"];
        cardChoose.updateKey = @"goodatarea";
        [self.navigationController pushViewController:cardChoose animated:YES];
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
