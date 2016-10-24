//
//  CZWMyAccountViewController.m
//  autoService
//
//  Created by bangong on 16/4/6.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWMyAccountViewController.h"
#import "CZWAccountViewController.h"

@interface CZWMyAccountViewController ()<UIAlertViewDelegate>

@end
@implementation CZWMyAccountViewController
{
    UITextField *nameTextField;
    UITextField *accountTextField;

    UIButton *submitButton;
    
    UIView *contentView;
}
-(void)free{
   
}


-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"绑定账号";
   
    [self createLeftItemBack];
    [self createScrollView];

    contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    
    
    UILabel *label = [LHController createLabelFont:13 Text:@"首次登陆请绑定提现账号" Number:1 TextColor:colorDeepGray];
    
    UIImageView *imageView = [LHController createImageViewWithFrame:CGRectZero ImageName:@"支付宝"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //显示当前账号
    UILabel *showLabel = [LHController createLabelFont:15 Text:nil Number:0 TextColor:colorBlack];
    showLabel.text = [NSString stringWithFormat:@"当前账号：%@",self.account];

    nameTextField = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"身份证姓名" Font:15 Delegate:nil];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.rightViewMode = UITextFieldViewModeAlways;
    nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UILabel *nameLabel = [LHController createLabelWithFrame:CGRectMake(0, 0, 80, 40) Font:15 Bold:NO TextColor:colorBlack Text:@"真实姓名："];
    nameTextField.leftView = nameLabel;
    
    accountTextField = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"与身份证姓名相符的支付宝账号" Font:15 Delegate:self];
    accountTextField.backgroundColor = [UIColor whiteColor];
    accountTextField.rightViewMode = UITextFieldViewModeAlways;
    accountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UILabel * accountLabel = [LHController createLabelWithFrame:CGRectMake(0, 0, 80, 40) Font:15 Bold:NO TextColor:colorBlack Text:@"账       号："];
    accountTextField.leftView = accountLabel;
    

   submitButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(submitClick) Font:15 Text:@"提交"];
    
    UIButton *phoneButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(phoneButtonClick) Text:nil];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"如有疑问请联系客服：010-65993545"];
    [att addAttribute:NSForegroundColorAttributeName value:colorNavigationBarColor range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:colorLightGray range:NSMakeRange(0, @"如有疑问请联系客服：".length)];
    [phoneButton setAttributedTitle:att forState:UIControlStateNormal];
    
    UIView *lineView1 = [LHController createBackLineWithFrame:CGRectZero];
    UIView *lineView2 = [LHController createBackLineWithFrame:CGRectZero];
    UIView *lineView3 = [LHController createBackLineWithFrame:CGRectZero];
   
    [contentView addSubview:label];
    [contentView addSubview:imageView];
    [contentView addSubview:showLabel];
    [contentView addSubview:nameTextField];
    [contentView addSubview:accountTextField];
    [contentView addSubview:submitButton];
    [contentView addSubview:phoneButton];
    [contentView addSubview:lineView1];
    [contentView addSubview:lineView2];
    [contentView addSubview:lineView3];
   
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(phoneButton);
    }];

  
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.equalTo(10);
        }];
    
   
    CGSize size = CGSizeMake(imageView.image.size.width*(30.0f/imageView.image.size.height), 30);
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.bottom).offset(20);
        make.left.equalTo(label);
        make.size.equalTo(size);
    }];
    
   
    [showLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.bottom).offset(20);
        make.left.equalTo(imageView);
        make.right.lessThanOrEqualTo(-15);
    }];

        [lineView1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(imageView.bottom).offset(20);
            make.size.equalTo(CGSizeMake(WIDTH, 1));
        }];
    
    
    [nameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.bottom);
        make.left.equalTo(label);
        make.size.equalTo(CGSizeMake(WIDTH-20, 40));
    }];
    
    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(nameTextField.bottom);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];

    [accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.bottom);
        make.left.equalTo(nameTextField);
        make.size.equalTo(nameTextField);
    }];
    
    [lineView3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(accountTextField.bottom);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];

    [submitButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView3.bottom).offset(20);
        make.left.equalTo(accountTextField);
        make.width.equalTo(accountTextField);
        make.height.equalTo(40);
    }];
    
    [phoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(submitButton.bottom).offset(10);
        make.left.equalTo(submitButton);
    }];
}


-(void)phoneButtonClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"010-65993545"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"呼叫", nil];
    alert.tag = 100;
    [alert show];
}

-(void)submitClick{
   
    if ([NSString isName:nameTextField.text] == NO) {
        [CZWAlert alertDismiss:@"请输入正确的姓名"];
        return;
    }
    if ([NSString isNotNULL:accountTextField.text] == NO) {
        [CZWAlert alertDismiss:@"请输入账号"];
        return;
    }
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *dict = @{@"eid":[CZWManager manager].roleId,@"account":accountTextField.text,@"realname":nameTextField.text};
        [CZWAFHttpRequest POST:expert_bindAccount parameters:dict success:^(id responseObject) {
            [hud hideAnimated:YES];
            if ([responseObject count]) {
               
                if ([responseObject firstObject][@"scuess"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[responseObject firstObject][@"scuess"]
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil, nil];
                    alert.tag = 101;
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                    });
                    //更新账户信息
                    [DEFAULTS setObject:accountTextField.text forKey:ROLE_ACCOUNT];
                    [DEFAULTS synchronize];
                    [CZWManager manager].account = accountTextField.text;
                    
                }else{
                    [CZWAlert alertDismiss:[responseObject firstObject][@"error"]];
                }
            }
            
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
        }];

}

-(void)success:(void (^)())block{
    self.success = block;
}

#pragma makr - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
       
    
    }else if (alertView.tag == 100){
        if (buttonIndex == 0) {
            return;
        }
        //拨打电话
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"01065993545"]];
        [[UIApplication sharedApplication] openURL:url];

    }
}

//#pragma mark - UITextFieldDelegate
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if ([string isEqualToString:@""]) {
//        return YES;
//    }else if ([NSString isDigital:string] || [string isEqualToString:@"@"] ) {
//  
//        return YES;
//    }else{
//
//        return NO;
//    }
//}

@end
