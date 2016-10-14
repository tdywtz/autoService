//
//  CZWExpertRegisterViewController.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertRegisterViewController.h"
#import "CityChooseViewController.h"
#import "NSString-Helper.h"
#import "CZWServiceViewController.h"
#import "CZWTechnologyGroupViewController.h"
#import "CZWBasicPanNavigationController.h"

@interface CZWExpertRegisterViewController ()<UITextViewDelegate>
{
    
    CGRect benginRect;
    CGFloat textFont;
    NSArray *propotyArray;
}

@property (nonatomic,strong) UIView *contentView;
@end

@implementation CZWExpertRegisterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
         self.title = @"注册";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    propotyArray = @[@"_userName",@"_password",@"_repeatedPassword",@"_trueName",@"_cardID",@"_phoneNumber",@"_area",@"_eamil",@"_company",@"_professional",@"_technologyGroup",@"_certificate",@"_beGoodAt"];
    textFont = [LHController setFont]-2;

    [self createLeftItemBack];
    [self createScrollView];
   
    self.contentView  = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    
    [self createTextField];
    [self createSubmitButton];
   
    _password.secureTextEntry = YES;
    _repeatedPassword.secureTextEntry = YES;
}

-(void)createTextField{
    NSArray *nameArray = @[@"用户名",@"密码",@"确认密码",@"真实姓名",@"身份证号",@"手机号",
                           @"地区",@"电子邮箱",@"公司",@"职业",@"技术组别",@"证明材料"
                           ];
    
    NSArray *placehoderArray = @[@"4~20位，可由汉字、数字、字母、下划线组成，注册成功后用户名不可修改",
                                 @"6~16位字母、数字、和符号组成，区分大小写",@"再次输入密码",
                                 @"请输入真实姓名",@"正确填写身份证号",@"请填写联系方式",
                                 @"请选择您所在的城市",@"正确填写邮箱地址",
                                 @"正确填写您所在公司名称",@"请输入您的职业",@"请选择技术组别",
                                 @"请上传2种以上证明材料，如：职称证书、国家职业资格证书、汽车维修技能认证证书、名片、工作证等"
                                 ];

    UIView *tempView = nil;
    for (int i = 0; i < nameArray.count; i ++) {
        
        CZWTextField *textField = [[CZWTextField alloc] initWithFrame:CGRectZero];
        textField.placeHoldertext = placehoderArray[i];
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:textFont];
        [self.contentView addSubview:textField];
        
        UIView *lineView = [LHController createBackLineWithFrame:CGRectZero];
        lineView.tag = 100+i;//修改信息页面删除使用
        [self.contentView addSubview:lineView];
        
        UILabel *nameLabel = [LHController createLabelWithFrame:CGRectMake(10, 0, 80, 20) Font:textFont Bold:NO TextColor:colorBlack Text:nameArray[i]];
        textField.leftView = nameLabel;
        
        [self setValue:textField forKey:propotyArray[i]];
        if (tempView == nil) {
            [textField makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.top.equalTo(0);
                make.size.equalTo(CGSizeMake(WIDTH-20, 60));
            }];
         
        }else{
            [textField makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.top.equalTo(tempView.bottom);
                make.size.equalTo(CGSizeMake(WIDTH-20, 40));
            }];
            if (i == 1 ) {
                [textField updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(60);
                }];
            }
        }
        
        if (i == 4) {
            UIView *line = [LHController createBackLineWithFrame:CGRectZero];
            UILabel *label = [LHController createLabelFont:textFont Text:@"上传身份证正、反两面" Number:1 TextColor:  [UIColor lightGrayColor]];
            cardIDImageView = [[CZWShowImageView alloc] initWithWidth:WIDTH-100 ViewController:self];
            cardIDImageView.maxNumber = 1;
            //添加进数组就上传图片
            __weak __typeof(self)weakSelf = self;
            [cardIDImageView addImage:^(UIImage *image) {
                [weakSelf postImage:image fileName:@"IDCardImage"];
            }];

            cardBackIDImageView = [[CZWShowImageView alloc] initWithWidth:WIDTH-100 ViewController:self];
            cardBackIDImageView.maxNumber = 1;
            [cardBackIDImageView addImage:^(UIImage *image) {
                [weakSelf postImage:image fileName:@"backIDCardImage"];
            }];

            UILabel *labelCard1 = [[UILabel alloc] init];
            labelCard1.font = [UIFont systemFontOfSize:14];
            labelCard1.textColor = [UIColor lightGrayColor];
            labelCard1.text = @"正面";

            UILabel *labelCard2 = [[UILabel alloc] init];
            labelCard2.font = [UIFont systemFontOfSize:14];
            labelCard2.textColor = [UIColor lightGrayColor];
            labelCard2.text = @"反面";

            [self.contentView addSubview:line];
            [self.contentView addSubview:label];
            [self.contentView addSubview:cardIDImageView];
            [self.contentView addSubview:cardBackIDImageView];
            [self.contentView addSubview:labelCard1];
            [self.contentView addSubview:labelCard2];
            
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(95);
                make.top.equalTo(textField.bottom);
                make.right.equalTo(0);
                make.height.equalTo(1);
            }];
            
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(line);
                make.top.equalTo(line.bottom);
                make.height.equalTo(textField);
            }];
            
            [cardIDImageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(line);
                make.top.equalTo(label.bottom);
                make.size.equalTo(CGSizeMake((WIDTH-100)/3-5,  (WIDTH-100)/3-5));
            }];

            [cardBackIDImageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardIDImageView.right).offset(10);
                make.top.equalTo(cardIDImageView);
                make.size.equalTo(cardIDImageView);
            }];

            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(cardIDImageView.bottom).offset(40);
                make.size.equalTo(CGSizeMake(WIDTH, 1));
            }];

            [labelCard1 makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cardIDImageView);
                make.top.equalTo(cardIDImageView.bottom).offset(5);
            }];

            [labelCard2 makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cardBackIDImageView);
                make.top.equalTo(cardBackIDImageView.bottom).offset(5);
            }];
        }
        else if (i == 11){
            [textField updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(80);
            }];
            proveImageView = [[CZWShowImageView alloc] initWithWidth:WIDTH-100 ViewController:self];
            proveImageView.maxNumber = 6;
            //添加到数组时就上传图片
            __weak __typeof(self)weakSelf = self;
            [proveImageView addImage:^(UIImage *image) {
                [weakSelf postImage:image fileName:@"ProofImage"];
            }];
            [self.contentView addSubview:proveImageView];
            
            [proveImageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardIDImageView);
                make.top.equalTo(textField.bottom);
                 make.size.equalTo(CGSizeMake(WIDTH-100,  (WIDTH-100)/3-5));
            }];
            
            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(proveImageView.bottom).offset(10);
                make.size.equalTo(CGSizeMake(WIDTH, 1));
            }];
        }
        else{
            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(textField.bottom);
                make.size.equalTo(CGSizeMake(WIDTH, 1));
            }];
        }
        
        tempView = lineView;
    }


    _technologyGroup.delegate = self;

    UIView *lineView = [LHController createBackLineWithFrame:CGRectZero];
    [self.contentView addSubview:lineView];
    
    UILabel *nameLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorBlack Text: @"擅长领域"];
    _beGoodAt = [[CZWIMInputTextView alloc ] initWithFrame:CGRectZero];
    _beGoodAt.font = [UIFont systemFontOfSize:15];
    _beGoodAt.delegate = self;
    _beGoodAt.placeHolder = @"请输入您所擅长的车型品牌,方便用户更好的对您了解";
    
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:_beGoodAt];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(tempView.bottom).offset(14);
        make.width.equalTo(80);
    }];
    
    [_beGoodAt makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tempView.bottom).offset(5);
        make.left.equalTo(nameLabel.right);
        make.right.equalTo(-10);
        make.height.equalTo(55);
    }];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beGoodAt.bottom).offset(5);
        make.left.equalTo(0);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
}

//提交图片
-(void)postImage:(UIImage *)image fileName:(NSString *)name{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    [CZWAFHttpRequest POSTImage:image url:auto_ULbackUrl fileName:name parameters:nil success:^(id responseObject) {
        [hud hideAnimated:YES];
     
        image.urlString = responseObject[@"imgUrl"];
        if (image.urlString.length == 0) {
            [CZWAlert alertDismiss:@"图片上传失败"];
            if ([name isEqualToString:@"ProofImage"]) {
                [proveImageView.imageArray removeObject:image];
                [proveImageView showImage];
            }else if ([name isEqualToString:@"backIDCardImage"]){
                [cardBackIDImageView.imageArray removeObject:image];
                [cardBackIDImageView showImage];
            }
            else if ([name isEqualToString:@"IDCardImage"]){
                [cardIDImageView.imageArray removeObject:image];
                [cardIDImageView showImage];
            }
        }

    } failure:^(NSError *error) {
        [CZWAlert alertDismiss:@"图片上传失败"];
        if ([name isEqualToString:@"ProofImage"]) {
            [proveImageView.imageArray removeObject:image];
            [proveImageView showImage];
        }else if ([name isEqualToString:@"backIDCardImage"]){
            [cardBackIDImageView.imageArray removeObject:image];
            [cardBackIDImageView showImage];
        }
        else if ([name isEqualToString:@"IDCardImage"]){
            [cardIDImageView.imageArray removeObject:image];
            [cardIDImageView showImage];
        }

        [hud hideAnimated:YES];
    }];
}

#pragma mark - 注册按钮
-(void)createSubmitButton{
    UIButton *registerButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(submitClick) Font:textFont+2 Text:@"提  交"];
    [self.contentView addSubview:registerButton];
    
    UIButton *agreement = [LHController createButtnFram:CGRectZero Target:self Action:@selector(agreementClick) Text:@"点击注册即表示已阅读并同意《专家注册协议》"];
    [agreement setTitleColor:colorYellow forState:UIControlStateNormal];
    [self.contentView addSubview:agreement];
    
    [registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beGoodAt.bottom).offset(40);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(WIDTH-20, 40));
    }];
    
    [agreement makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerButton);
        make.top.equalTo(registerButton.bottom).offset(10);
        make.right.lessThanOrEqualTo(-15);
        make.height.equalTo(20);
    }];
    
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(agreement.bottom).offset(40);
    }];
}

#pragma mark - 注册按钮
-(void)submitClick{
    if (_userName.text.length == 0) {
        [CZWAlert customAlert:@"用户名不能为空"];
        return;
    }
    if (_userName.text.length < 4 || _userName.text.length > 20) {
        [CZWAlert customAlert:@"用户名长度需在4~20位之间"];
        return;
    }
    if (![NSString isUserName:_userName.text]) {
        [CZWAlert customAlert:@"用户名可由4~20位汉字、数字、字母、下划线组成"];
        return;
    }
    if (_password.text.length == 0) {
        [CZWAlert customAlert:@"密码不能为空"];
        return;
    }
    if (_password.text.length < 6 || _password.text.length > 16) {
        [CZWAlert customAlert:@"密码长度需在6~16位之间"];
        return;
    }
    if (![NSString isSixToThTwelvePassword:_password.text]){
        [CZWAlert customAlert:@"密码不能包含非法字符，密码可由6~16位字母、数字和符号组成，区分大小写"];
        return;
    }
    if (![_repeatedPassword.text isEqualToString:_password.text]){
        [CZWAlert customAlert:@"两次输入密码不匹配"];
        return;
    }
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
        [dict setObject:_userName.text forKey:@"uname"];//用户名
        [dict setObject:_password.text forKey:@"pwd"];//密码
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
            if (jobProofImg.length) {
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

#pragma mark - 提交注册信息
-(void)submitData:(NSDictionary *)dict{

     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CZWAFHttpRequest registerWithParameters:dict type:CCUserType_Expert images:nil success:^(id responseObject) {
        [hud hideAnimated:YES];
        
        if ([responseObject count] == 0) {
            return ;
        }
        NSDictionary *dict = [responseObject firstObject];
     
        if (dict[@"error"]) {
            [CZWAlert customAlert:dict[@"error"]];
        }else{
            if (self.block) {
                self.block(_userName.text,_password.text);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }

    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

-(void)agreementClick{
    CZWServiceViewController *service = [[CZWServiceViewController alloc] init];
    service.urlString = auto_expertsAgree;
    [self.navigationController pushViewController:service animated:YES];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.scrollContentY = textField.frame.origin.y+textField.frame.size.height;
    if (textField == _area) {
        CityChooseViewController *city = [[CityChooseViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:city];
        [city returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
            _area.text = [NSString stringWithFormat:@"%@%@",pName,cName];
            provinceId = pid;
            cityId     = cid;
        }];
        [self presentViewController:nvc animated:YES completion:nil];
        return NO;
    }else if (textField == _certificate){
        return NO;
    }else if (textField == _technologyGroup){

        CZWTechnologyGroupViewController *vc = [[CZWTechnologyGroupViewController alloc] init];
        CZWBasicPanNavigationController *nvc = [[CZWBasicPanNavigationController alloc] initWithRootViewController:vc];
        vc.clickBlock = ^(NSString *value, NSString * title){
            _technologyGroup.text = title;
            _technologyGroup.tag = [value integerValue];
        };
        [self presentViewController:nvc animated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(void)success:(success)block{
    self.block = block;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.scrollContentY = textView.frame.origin.y+textView.frame.size.height;
    return YES;
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
