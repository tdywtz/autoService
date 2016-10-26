
//
//  CZWAccountViewController.m
//  autoService
//
//  Created by bangong on 16/4/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWAccountViewController.h"
#import "CZWBillViewController.h"
#import "CZWWithdrawCashViewController.h"
#import "CZWMyAccountViewController.h"
#import "CZWModifyAccountViewController.h"

@interface CZWAccountViewController ()<UIAlertViewDelegate>
{
    UILabel *balanceLabel;
    NSDictionary *dictionary;
    UIButton *updateAccount;
    UIView *contentView;
}
@end


@implementation CZWAccountViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"我的账户";
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    
    [self createLeftItemBack];
    [self createRightItem];
    [self createUI];
    
    [[CZWManager manager] setUnreadMessageOfAccount:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self loadData];
}


-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:expert_e_integral,[CZWManager manager].roleId];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count]) {
            dictionary = [responseObject firstObject];
            balanceLabel.text = [responseObject firstObject][@"integral"];
            if ([responseObject firstObject][@"integral"] == nil) {
                balanceLabel.text = @"0.00";
            }
            if ([dictionary[@"account"] length] > 0) {
                [updateAccount updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(40);
                }];
            }
            //account
            //更新账户信息
            [DEFAULTS setObject:[responseObject firstObject][@"integral"] forKey:ROLE_ACCOUNT];
            [DEFAULTS synchronize];
            [CZWManager manager].account = [responseObject firstObject][@"integral"];
        }

    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
    }];
}

-(void)buttonClick:(UIButton *)btn{
    if (btn == updateAccount) {
        UIAlertView *aletView = [[UIAlertView alloc] initWithTitle:@"请输入登录密码"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        aletView.tag = 102;
        aletView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [aletView show];

    }else{
        if ([dictionary[@"account"] length]) {
            CZWWithdrawCashViewController *cash = [[CZWWithdrawCashViewController alloc] init];
            cash.dictionary = dictionary;
            [self.navigationController pushViewController:cash animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您未绑定支付宝账户"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            alert.tag = 100;
            [alert show];
        }
    }
}

-(void)createRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"账单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    CZWBillViewController *bill = [[CZWBillViewController alloc] init];
    bill.acid = dictionary[@"acid"];
    [self.navigationController pushViewController:bill animated:YES];
}

-(void)createUI{
    contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView.width);
    }];

    UIImageView *imageView = [LHController createImageViewWithFrame:CGRectZero ImageName:@"账户金额"];
   
    UILabel *label = [LHController createLabelFont:15 Text:@"账户余额" Number:1 TextColor:colorBlack];
   
    balanceLabel = [LHController createLabelFont:25 Text:@"00.00" Number:1 TextColor:colorBlack];
    UIButton *submitButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Font:15 Text:@"提现"];
    updateAccount = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Font:15 Text:@"修改账号"];

    
    UILabel *tishiLabel = [LHController createLabelFont:15 Text:nil Number:0 TextColor:colorLightGray];
    NSString *text = @"提示：\n1.每次提现额度不能小于100元\n2.每个自然月内只允许提现2次";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString addAttribute:NSForegroundColorAttributeName value:colorOrangeRed range:[text rangeOfString:@"提示："]];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing = 5;
    NSRange range = NSMakeRange(0, attString.length);
   [attString addAttribute:NSParagraphStyleAttributeName value:[paragraph mutableCopy] range:range];
    paragraph.paragraphSpacing = 10;
    range = [text rangeOfString:@"提示："];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
    tishiLabel.attributedText = attString;

    //电话
    UIButton *phoneButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(phoneButtonClick) Text:nil];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"如有疑问请联系客服：010-65993545"];
    [att addAttribute:NSForegroundColorAttributeName value:colorNavigationBarColor range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:colorLightGray range:NSMakeRange(0, @"如有疑问请联系客服：".length)];
    [phoneButton setAttributedTitle:att forState:UIControlStateNormal];
    
    [contentView addSubview:imageView];
    [contentView addSubview:label];
    [contentView addSubview:balanceLabel];
    [contentView addSubview:submitButton];
    [contentView addSubview:updateAccount];
    [contentView addSubview:tishiLabel];
    [contentView addSubview:phoneButton];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(25*factor_height);
    }];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.bottom).offset(10);
        
    }];
    
    [balanceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(label.bottom).offset(10);
    }];
    
    [submitButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceLabel.bottom).offset(25*factor_height);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(WIDTH-20, 40));
    }];
    
    [updateAccount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(submitButton.bottom).offset(10);
        make.left.equalTo(submitButton);
        make.width.equalTo(submitButton);
        make.height.equalTo(0);
    }];
    
    [phoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(submitButton);
        make.top.equalTo(updateAccount.bottom).equalTo(15*factor_height);
    
    }];
    
    [tishiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(10);
        make.top.equalTo(phoneButton.bottom).offset(15*factor_height);
        make.bottom.equalTo(-10);
    }];
    
}

-(void)phoneButtonClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"010-65993545"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"呼叫", nil];
    alert.tag  = 101;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        CZWMyAccountViewController *myaccount = [[CZWMyAccountViewController alloc] init];
        [self.navigationController pushViewController:myaccount animated:YES];
    }else if (alertView.tag == 101){
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"01065993545"]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if (alertView.tag == 102){
        if (buttonIndex == 0) {
            return;
        }
        NSString *password = [alertView textFieldAtIndex:0].text;
        if (![[DEFAULTS objectForKey:role_password] isEqualToString:password]) {
            [CZWAlert alertDismiss:@"登录密码错误"];
            return;
        }
        [[alertView textFieldAtIndex:0] endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CZWModifyAccountViewController *myaccount = [[CZWModifyAccountViewController alloc] init];
            myaccount.dictionary = dictionary;
            [self.navigationController pushViewController:myaccount animated:YES];
        });
      
    }
}
@end
