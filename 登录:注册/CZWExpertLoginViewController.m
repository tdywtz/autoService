//
//  CZWExpertLoginViewController.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertLoginViewController.h"
#import "CZWExpertRegisterViewController.h"
#import "CZWRootViewController.h"
#import "AppDelegate.h"
#import "CZWBasicPanNavigationController.h"
#import "NSString-Helper.h"
#import "LookPasswordViewController.h"
#import "CZWExpertUpdateRegisterInfoViewController.h"

@interface CZWExpertLoginViewController ()<UIAlertViewDelegate>
{
    NSString *expert_id;//专家id
}
@end

@implementation CZWExpertLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.czw

}

- (void)createTiShi:(CGFloat)frameY{
   
}

- (void)passwordClick{
    LookPasswordViewController *vc = [[LookPasswordViewController alloc] init];
    [vc setExpertUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightItemClick{
    CZWExpertRegisterViewController *userRegister = [[CZWExpertRegisterViewController alloc] init];
    [userRegister success:^(NSString *name, NSString *password) {
        self.userNameTextField.text = name;
        self.userPasswordTextField.text = password;
      
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self submitClick];
        });
    }];
    [self.navigationController pushViewController:userRegister animated:YES];
}

-(void)submitClick{

    if ([NSString isNotNULL:self.userNameTextField.text] &&
        [NSString isNotNULL:self.userPasswordTextField.text]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:
                              @[self.userNameTextField.text,self.userPasswordTextField.text] forKeys:@[@"ename",@"pwd"]];

        [self setButtonEnable:NO];
        [self.view endEditing:YES];
        [self.userNameTextField resignFirstResponder];
        [self.userPasswordTextField resignFirstResponder];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self submitData:dict];
        });

    }else{
        [CZWAlert customAlert:@"用户名或密码为空"];
    }
}

-(void)submitData:(NSDictionary *)dict{


 

    
    __weak __typeof(self)weakSelf = self;
    [CZWAFHttpRequest loginWithParameters:dict type:CCUserType_Expert success:^(id responseObject) {

        [weakSelf setButtonEnable:YES];
        weakSelf.editing = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject count] == 0) {
            return ;
        }
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"error"]) {
             expert_id = dict[@"expert_id"];
            if ([expert_id integerValue] > 0) {
                //若有专家id,则为提示修改注册信息
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:dict[@"error"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即修改", nil];
                [alert show];

            }else{
                [CZWAlert customAlert:dict[@"error"]];
            }

        }else if ([dict[@"code"] integerValue] == 200){
            [weakSelf.navigationController.view removeFromSuperview];
            [weakSelf.view removeFromSuperview];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:isExpertLogin forKey:isUserOrExpertLogin];
            [user setObject:dict[@"expert_id"] forKey:ROLEID];
            [user setObject:dict[@"expert_headpic"] forKey:ROLEIMAGEURL];
            [user setObject:dict[@"expert_name"] forKey:ROLENAME];
            [user setObject:dict[@"token"] forKey:chatToken];
            [user setObject:dict[@"userId"] forKey:RC_USERID];
            [user setObject:dict[@"expert_account"] forKey:ROLE_ACCOUNT];
            [user setObject:weakSelf.userPasswordTextField.text forKey:role_password];
            
            [user synchronize];
            
            [[CZWManager manager] updataManager];
            [[CZWFmdbManager manager] updataManager];
            //更新好友列表
            [[CZWManager manager] refreshFriendsList];
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
            __weak AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [UIView animateWithDuration:0.3 animations:^{
                app.window.rootViewController = nvc;
            }completion:^(BOOL finished){
                [weakSelf removeFromParentViewController];
            }];
        }
        
    } failure:^(NSError *error) {
        [weakSelf setButtonEnable:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma  mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        CZWExpertUpdateRegisterInfoViewController *update = [[CZWExpertUpdateRegisterInfoViewController alloc] init];
        update.eid = expert_id;
        [self.navigationController pushViewController:update animated:YES];
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
