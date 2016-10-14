//
//  CZWExpertUpdateRegisterInfoViewController.m
//  autoService
//
//  Created by bangong on 16/8/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWExpertUpdateRegisterInfoViewController.h"

@interface CZWExpertUpdateRegisterInfoViewController ()

@end

@implementation CZWExpertUpdateRegisterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [_userName removeFromSuperview];
    [_password removeFromSuperview];
    [_repeatedPassword removeFromSuperview];
    for (int i = 0; i < 3; i ++) {
        UIView *view = [self.scrollView viewWithTag:100+i];
        [view removeFromSuperview];
    }

    [_trueName updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
    }];

    [self loadData];
}

- (void)loadData{
    __weak __typeof(self)weakSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [NSString stringWithFormat:expert_information,self.eid];
    //修改时取全部参数“all=1”
    url = [NSString stringWithFormat:@"%@%@",url,@"&all=1"];

    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject count] == 0) {
            return ;
        }
        [weakSelf setInfomation:responseObject[0]];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)setInfomation:(NSDictionary *)dict{

    _trueName.text = dict[@"realname"];
    _cardID.text = dict[@"idcard"];
    NSArray *arr = [dict[@"idCardImg"] componentsSeparatedByString:@"||"];
    if (arr.count > 1) {
        cardIDImageView.imageUrlArray = @[arr[0]];
        cardBackIDImageView.imageUrlArray = @[arr[1]];
    }

    _phoneNumber.text = dict[@"mobile"];
    _area.text = dict[@"city"];
    _eamil.text = dict[@"email"];
    _company.text = dict[@"company"];//公司
    _professional.text = dict[@"job"];//职业
    _technologyGroup.text = dict[@"techGroup"];//技术组别
    _technologyGroup.tag = [dict[@"groupid"] integerValue];
   // _certificate.text = dict[@""];//证明材料
    proveImageView.imageUrlArray = [dict[@"jobProofImg"] componentsSeparatedByString:@"||"];//证明材料图片
    _beGoodAt.text = dict[@"goodatarea"];//擅长

    provinceId = dict[@"pid"]?dict[@"pid"]:@"0";
    cityId = dict[@"cid"]?dict[@"cid"]:@"0";
}

#pragma mark - 注册按钮
-(void)submitClick{
    if (_trueName.text.length == 0){
        [CZWAlert customAlert:@"真实姓名不能为空"];
        return;
    }
   
    if (![NSString isName:_trueName.text]){
        [CZWAlert customAlert:@"真实姓名格式不正确，只能包含英文字母和汉字"];
        return;
    }
    if (![NSString isIDNumber:_cardID.text]){
        [CZWAlert customAlert:@"身份证号须是15或18位数字"];
        return;
    }
    if (cardIDImageView.imageArray.count == 0){
        [CZWAlert customAlert:@"请上传身份证正面照片"];
        return;
    }
    if (cardBackIDImageView.imageArray.count == 0){
        [CZWAlert customAlert:@"请上传身份证反面照片"];
        return;
    }

    if (_phoneNumber.text.length != 11 || ![NSString isNumber:_phoneNumber.text]){
        [CZWAlert customAlert:@"手机号须是11位数字"];
        return;
    }
    if (_area.text.length == 0){
        [CZWAlert customAlert:@"请选择城市"];
        return;
    }
    if (![NSString isEmailTest:_eamil.text]){
        [CZWAlert customAlert:@"邮箱格式不正确"];
        return;
    }
    if (![NSString isNotNULL:_company.text]){
        [CZWAlert customAlert:@"请输入公司名称"];
        return;
    }
    if (![NSString isNotNULL:_professional.text]){
        [CZWAlert customAlert:@"请输入职业"];
        return;
    }
    if (![NSString isNotNULL:_technologyGroup.text]){
        [CZWAlert customAlert:@"请选择技术组别"];
        return;
    }
    if (proveImageView.imageArray.count < 2){
        [CZWAlert customAlert:@"请上传两种以上证明材料照片"];
        return;
    }
    if (![NSString isNotNULL:_beGoodAt.text]){
        [CZWAlert customAlert:@"请输入您擅长的品牌"];
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:_userName.text forKey:@"uname"];//用户名
//    [dict setObject:_password.text forKey:@"pwd"];//密码
    [dict setObject:self.eid forKey:@"eid"];//修改的信息专家的id
    [dict setObject:_trueName.text forKey:@"realname"];//真实姓名
    [dict setObject:_cardID.text forKey:@"idcard"];//身份证号
    [dict setObject:_phoneNumber.text forKey:@"mobile"];//手机号
    [dict setObject:provinceId forKey:@"pid"];//省份id
    [dict setObject:cityId forKey:@"cid"];//市id
    [dict setObject:_eamil.text forKey:@"email"];//邮箱
    [dict setObject:_company.text forKey:@"company"];//公司
    [dict setObject:_professional.text forKey:@"job"];//职业

    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_technologyGroup.tag] forKey:@"group"];//技术组别
    [dict setObject:_beGoodAt.text forKey:@"goodarea"];//擅长领域
    [dict setObject:appEntrance forKey:@"origin"];


    //身份证照片
    UIImage *image1 = cardIDImageView.imageArray[0];
    UIImage *image2 = cardBackIDImageView.imageArray[0];
    NSString *idCardImg = [NSString stringWithFormat:@"%@||%@",image1.urlString,image2.urlString];

    //证明材料照片
    NSString *jobProofImg = @"";
    for (UIImage *image in proveImageView.imageArray) {
        if (jobProofImg.length > 0) {
            jobProofImg = [NSString stringWithFormat:@"%@||%@",jobProofImg,image.urlString];
        }else{
            jobProofImg = image.urlString;
        }
    }
    if (idCardImg) {
        [dict setObject:idCardImg forKey:@"idCardImg"];
    }
    if (jobProofImg) {
        [dict setObject:jobProofImg forKey:@"jobProofImg"];
    }

    [self submitData:dict];
}

#pragma mark - 提交修改信息
-(void)submitData:(NSDictionary *)dict{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在提交...";

    __weak __typeof(self)weakSelf = self;
    [CZWAFHttpRequest POST:expert_e_update parameters:dict success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) {
            return ;
        }
        NSDictionary *dict = [responseObject firstObject];

        if (dict[@"error"]) {
            [CZWAlert customAlert:dict[@"error"]];
        }else{
            [CZWAlert customAlert:@"信息已提交，请耐心等待网站审核"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError *error) {
            [hud hideAnimated:YES];
    }];
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
