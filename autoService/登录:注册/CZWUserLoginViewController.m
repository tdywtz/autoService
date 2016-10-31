//
//  CZWUserLoginViewController.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserLoginViewController.h"
#import "CZWUserRegisterViewController.h"
#import "CZWRootViewController.h"
#import "CZWBasicNavigationController.h"
#import "AppDelegate.h"
#import "NSString-Helper.h"
#import "CZWBasicPanNavigationController.h"
#import "LookPasswordViewController.h"

@interface CZWUserLoginViewController ()
{
    UIButton *submitBtn;
}
@end

@implementation CZWUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    [self createScrollView];
    [self createLeftItemBack];
    [self createRightItem];
    [self createTextField];
    [self createSubmitButton];
    [_userNameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

-(void)leftItemBackClick{
    [self.view endEditing:YES];
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)createRightItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
}

-(void)rightItemClick{
    CZWUserRegisterViewController *userRegister = [[CZWUserRegisterViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    [userRegister success:^(NSString *name, NSString *password) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.userNameTextField.text = name;
        strongSelf.userPasswordTextField.text = password;
        
        [strongSelf submitClick];
        
    }];
    [self.navigationController pushViewController:userRegister animated:YES];
}

- (void)createTiShi:(CGFloat)frameY{
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(14, frameY, WIDTH-40, 20) Font:15 Bold:NO TextColor:colorNavigationBarColor Text:@"可用车质网账号直接登录"];
    [self.scrollView addSubview:label];
}

-(void)createTextField{
    
    CGFloat origin_y = 120*factor_height;
    [self createTiShi:origin_y-30];

    for (int i = 0; i < 3; i ++) {
        UIView *view = [LHController createBackLineWithFrame:CGRectMake(0, origin_y+i*50, WIDTH, 1)];
        [self.scrollView addSubview:view];
    }
    UIImageView *textLeftImageViewName = [LHController createImageViewWithFrame:CGRectMake(0, 0, 40, 50) ImageName:nil];
    UIImageView *leftImageViewName = [LHController createImageViewWithFrame:CGRectMake(10, 0, 15, 50) ImageName:@"loginUserName"];
    [textLeftImageViewName addSubview:leftImageViewName];
    _userNameTextField = [LHController createTextFieldWithFrame:CGRectMake(0, origin_y, WIDTH, 50) Placeholder:@"输入用户名" Font:[LHController setFont]-2 Delegate:self];
    
    
    _userNameTextField.leftView = textLeftImageViewName;
    [self.scrollView addSubview:_userNameTextField];
    
    UIImageView *textLeftImageViewPassword = [LHController createImageViewWithFrame:CGRectMake(0, 0, 40, 50) ImageName:nil];
    UIImageView *leftImageViewPassword = [LHController createImageViewWithFrame:CGRectMake(10, 0, 15, 50) ImageName:@"loginPassword"];
    [textLeftImageViewPassword addSubview:leftImageViewPassword];
    _userPasswordTextField = [LHController createTextFieldWithFrame:CGRectMake(0, origin_y+50, WIDTH, 50) Placeholder:@"输入密码" Font:[LHController setFont]-2 Delegate:self];
    _userPasswordTextField.leftView = textLeftImageViewPassword;
    //密码键盘
    _userPasswordTextField.secureTextEntry = YES;
    [self.scrollView addSubview:_userPasswordTextField];
    
}


-(void)createSubmitButton{
    submitBtn = [LHController createButtnFram:CGRectMake(10, _userPasswordTextField.frame.origin.y+_userPasswordTextField.frame.size.height+30, WIDTH-20, 40) Target:self Action:@selector(submitClick) Font:[LHController setFont] Text:@"点击登录"];
    [self.scrollView addSubview:submitBtn];

    //找回密码
    UIButton *password = [LHController createButtnFram:CGRectZero Target:self Action:@selector(passwordClick) Text:@"找回密码"];
    [password setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
    [self.scrollView addSubview:password];

    [password makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(submitBtn.right);
        make.top.equalTo(submitBtn.bottom).offset(20);
    }];

    self.scrollView.contentSize = CGSizeMake(0, submitBtn.frame.origin.y+120);
}

- (void)passwordClick{
    LookPasswordViewController *vc = [[LookPasswordViewController alloc] init];
    [vc setUserUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)submitClick{
 
    [UIView animateWithDuration:0.1 animations:^{
        submitBtn.transform = CGAffineTransformMakeScale(1.3, 1.1);
    }];
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        submitBtn.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];

    if ([NSString isNotNULL:_userNameTextField.text] &&
        [NSString isNotNULL:_userPasswordTextField.text]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:
                             @[_userNameTextField.text,_userPasswordTextField.text] forKeys:@[@"uname",@"pwd"]];
        [self submitData:dict];
    }else{
        [CZWAlert customAlert:@"用户名或密码为空"];
    }
}

//提交数据
-(void)submitData:(NSDictionary *)dict{
    [self setButtonEnable:NO];
    [self.view endEditing:YES];
    [self.userNameTextField resignFirstResponder];
    [self.userPasswordTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
     __weak __typeof(self)weakSelf = self;
    [CZWAFHttpRequest loginWithParameters:dict type:CCUserType_User success:^(id responseObject) {
        [weakSelf setButtonEnable:YES];
        [hud hideAnimated:YES];
        
        if ([responseObject count] == 0) {
            return ;
        }
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"error"]) {
            [CZWAlert customAlert:dict[@"error"]];
        }else if([dict[@"code"] integerValue] == 200){
            [weakSelf.navigationController.view removeFromSuperview];
            [weakSelf.view removeFromSuperview];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:isUserLogin forKey:isUserOrExpertLogin];
         
            [user setObject:dict[@"user_id"] forKey:ROLEID];
            [user setObject:dict[@"user_headpic"] forKey:ROLEIMAGEURL];
            [user setObject:dict[@"user_name"] forKey:ROLENAME];
            [user setObject:dict[@"model_name"] forKey:USERMODEL];
            [user setObject:dict[@"token"] forKey:chatToken];
            [user setObject:dict[@"userId"] forKey:RC_USERID];
            [user setObject:_userPasswordTextField.text forKey:role_password];
            
            [user synchronize];
           // NSLog(@"%@",responseObject);
            [[CZWManager manager] updataManager];
            [[CZWFmdbManager manager] updataManager];
            //更新好友列表
           // [[CZWManager manager] refreshFriendsList];
            
            [[RCIM sharedRCIM] connectWithToken:[user objectForKey:chatToken] success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
            }];
            //登录
            [[CZWManager manager] login];
            CZWRootViewController  *root = [[CZWRootViewController alloc] init];
            CZWBasicPanNavigationController *nvc = [[CZWBasicPanNavigationController alloc] initWithRootViewController:root];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [UIView animateWithDuration:0.3 animations:^{
                app.window.rootViewController = nvc;
            }completion:^(BOOL finished){
                [self removeFromParentViewController];
            }];
        }
       
        
    } failure:^(NSError *error) {
        [weakSelf setButtonEnable:YES];
        [hud hideAnimated:YES];
    }];
}

-(void)setButtonEnable:(BOOL)b{
    submitBtn.enabled = b;
    if (b) {
        submitBtn.backgroundColor = colorNavigationBarColor;
    }else{
        submitBtn.backgroundColor = colorLineGray;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
