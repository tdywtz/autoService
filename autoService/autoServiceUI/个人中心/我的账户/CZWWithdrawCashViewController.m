
//
//  CZWWithdrawCashViewController.m
//  autoService
//
//  Created by bangong on 16/4/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWWithdrawCashViewController.h"

@interface CZWWithdrawCashViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{   //账号
    UITextField *accountTextField;
    //金额
    UITextField *balanceTextField;
    //余额
    UILabel *balanceLabel;
    //按钮
    UIButton *button;
}
@end

@implementation CZWWithdrawCashViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"提现";
    [self createLeftItemBack];
    [self createScrollView];

    accountTextField = [LHController createTextFieldWithFrame:CGRectZero Placeholder:nil Font:15 Delegate:nil];
    accountTextField.textColor = colorNavigationBarColor;
    accountTextField.enabled = NO;
    

    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, 90, 20) Font:15 Bold:NO TextColor:colorBlack Text:@"支付宝账号"];
    accountTextField.leftView = label;
    balanceTextField = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"输入金额" Font:15 Delegate:self];
    balanceTextField.keyboardType = UIKeyboardTypeNumberPad;

    UILabel *balance = [LHController createLabelWithFrame:CGRectMake(0, 0, 90, 20) Font:15 Bold:NO TextColor:colorBlack Text:@"提现金额"];
    UILabel *qian = [LHController createLabelWithFrame:CGRectMake(90, 0, 20, 20) Font:15 Bold:NO TextColor:colorBlack Text:@"¥"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 20)];
    [view addSubview:balance];
    [view addSubview:qian];
    balanceTextField.leftView = view;
    
    balanceLabel = [LHController createLabelFont:15 Text:nil Number:1 TextColor:colorLightGray];
    
    button = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick) Font:15 Text:@"提现"];
    button.backgroundColor =colorLineGray;
    button.enabled = NO;
    
    UIView *lineView1 = [LHController createBackLineWithFrame:CGRectZero];
    UIView *lineView2 = [LHController createBackLineWithFrame:CGRectZero];
    
    UILabel *tishi = [LHController createLabelFont:15 Text:@"三个工作日内到账" Number:0 TextColor:colorDeepGray];
    
    [self.scrollView addSubview:accountTextField];
    [self.scrollView addSubview:balanceTextField];
    [self.scrollView addSubview:balanceLabel];
    [self.scrollView addSubview:button];
    [self.scrollView addSubview:lineView1];
    [self.scrollView addSubview:lineView2];
    [self.scrollView addSubview:tishi];
    
    [accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(25);
        make.right.equalTo(-15);
        make.height.equalTo(accountTextField.font.lineHeight);
    }];
    
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(accountTextField.bottom).offset(20);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    [balanceTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountTextField);
        make.top.equalTo(lineView1.bottom).offset(10);
        make.width.equalTo(WIDTH-30
                           );
        make.height.equalTo(40);
    }];
    
    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(balanceTextField.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    [balanceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountTextField);
        make.top.equalTo(lineView2.bottom).offset(20);
        make.right.equalTo(-15);
    }];
 
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountTextField);
        make.top.equalTo(balanceLabel.bottom).offset(20);
        make.width.equalTo(WIDTH-30);
        make.height.equalTo(40);
    }];

 
    [tishi makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button);
        make.top.equalTo(button.bottom).offset(20);
        make.right.equalTo(button);
    }];
    
    accountTextField.text = self.dictionary[@"account"];
    balanceLabel.text = [NSString stringWithFormat:@"当前账户余额%@元",self.dictionary[@"integral"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self loadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(0, button.frame.origin.y+button.frame.size.height+100);
}
//提现成功后刷新数据
-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:expert_e_integral,[CZWManager manager].roleId];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count]) {
            weakSelf.dictionary = [responseObject firstObject];
            balanceLabel.text = [NSString stringWithFormat:@"当前账户余额%@元",[responseObject firstObject][@"integral"]];
        //account
        }
        

    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
    }];
}

//提交提现数据
-(void)buttonClick{
   // NSLog(@"%@",self.dictionary);
    if ([balanceTextField.text integerValue] < 100) {
        [CZWAlert alertDismiss:@"单次提现金额不能小于100"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *dict = @{@"eid":[CZWManager manager].roleId,@"wdmoney":balanceTextField.text,@"acid":self.dictionary[@"acid"]};
     __weak __typeof(self)weakSelf = self;
    [CZWAFHttpRequest POST:expert_withdraw parameters:dict success:^(id responseObject) {
       
        [hud hideAnimated:YES];
        if ([responseObject count]) {
            NSDictionary *dictionary = [responseObject firstObject];
            if (dictionary[@"error"]) {
                [CZWAlert alertDismiss:dictionary[@"error"]];
            }else{
                balanceTextField.text = @"";
                [weakSelf loadData];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:dictionary[@"scuess"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"完成"
                                                      otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
        }

    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
    }];
}

-(void)didChange:(NSNotification *)notification{
    balanceTextField.text = [balanceTextField.text floatValue]<=[self.dictionary[@"integral"] floatValue]?balanceTextField.text:self.dictionary[@"integral"];
    
    button.enabled = [balanceTextField.text floatValue]>= 100?YES:NO;
    if (button.enabled) {
        button.backgroundColor = colorNavigationBarColor;
    }else{
        button.backgroundColor = colorLineGray;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }else if ([NSString isDigital:string]) {
        //控制只能输入小数点后两位
        NSRange Arange = [textField.text rangeOfString:@"."];
        if (Arange.length) {
            NSString *sub = [textField.text substringFromIndex:Arange.location+1];
            if (sub.length == 2) {
                return NO;
            }
        }
        return YES;
    }else{
        
        return NO;
    }
}


#pragma makr - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    [self.navigationController popViewControllerAnimated:YES];
}


@end
