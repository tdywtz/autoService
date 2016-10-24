//
//  CZWModifyAccountViewController.m
//  autoService
//
//  Created by bangong on 16/6/13.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWModifyAccountViewController.h"

#pragma mark - ModifyAccountTextField
@interface ModifyAccountTextField : UITextField

-(instancetype)initWithleftTitle:(NSString *)title placeholder:(NSString *)placeholder color:(UIColor *)color;

@end

@implementation ModifyAccountTextField

- (instancetype)initWithleftTitle:(NSString *)title placeholder:(NSString *)placeholder color:(UIColor *)color
{
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 80, 20)];
        label.font = [UIFont systemFontOfSize:15];

        NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:title];
        NSRange range = [title rangeOfString:@"账号"];
        [matt addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, matt.length)];
        if (range.length) {
            [matt addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:range];
        }
        label.attributedText = matt;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 22)];
        [view addSubview:label];
        
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.placeholder = placeholder;
        self.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条底部线
    CGContextSetRGBStrokeColor(context, 220/255.0,  220/255.0, 220/255.0, 1);//线条颜色
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}
@end

#pragma mark - CZWModifyAccountViewController
@interface CZWModifyAccountViewController ()
{
    ModifyAccountTextField *nameTextField;
    ModifyAccountTextField *accountTextField;
    
    UIButton *submitButton;
    
    UIView *contentView;
}
@end

@implementation CZWModifyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改账号";
    [self createLeftItemBack];
    [self createScrollView];
    
    contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    UIImageView *imageView = [LHController createImageViewWithFrame:CGRectZero ImageName:@"支付宝"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //显示当前账号
    UILabel *nowAccountLabel = [LHController createLabelFont:15 Text:@"当前账号" Number:0 TextColor:colorBlack];
    UIView *lineView1 = [LHController createBackLineWithFrame:CGRectZero];
    
    ModifyAccountTextField *nowNameTextField = [[ModifyAccountTextField alloc] initWithleftTitle:@"真实姓名：" placeholder:self.dictionary[@"realname"] color:colorLightGray];
    nowNameTextField.enabled = NO;
    ModifyAccountTextField *nowAccountTextField = [[ModifyAccountTextField alloc] initWithleftTitle:@"账账号号：" placeholder:self.dictionary[@"account"] color:colorLightGray];
    nowAccountTextField.enabled = NO;
    
    
    
    UILabel *newLabel = [LHController createLabelFont:15 Text:@"修改账号" Number:0 TextColor:colorBlack];
    UIView *lineView2 = [LHController createBackLineWithFrame:CGRectZero];
    
    nameTextField = [[ModifyAccountTextField alloc] initWithleftTitle:@"真实姓名：" placeholder:@"身份证姓名" color:colorBlack];
    nameTextField.delegate = self;
    
    accountTextField = [[ModifyAccountTextField alloc] initWithleftTitle:@"账账号号：" placeholder:@"与身份证姓名相符的支付宝账号" color:colorBlack];
    accountTextField.delegate = self;
    accountTextField.keyboardType = UIKeyboardTypeEmailAddress;

    submitButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(submitClick) Font:15 Text:@"提交"];
    
    UIButton *phoneButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(phoneButtonClick) Text:nil];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"如有疑问请联系客服：010-65993545"];
    [att addAttribute:NSForegroundColorAttributeName value:colorNavigationBarColor range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:colorLightGray range:NSMakeRange(0, @"如有疑问请联系客服：".length)];
    [phoneButton setAttributedTitle:att forState:UIControlStateNormal];
    
    
    
    [contentView addSubview:imageView];
    [contentView addSubview:nowAccountLabel];
    [contentView addSubview:lineView1];
    [contentView addSubview:nowNameTextField];
    [contentView addSubview:nowAccountTextField];
    
    [contentView addSubview:newLabel];
    [contentView addSubview:lineView2];
    [contentView addSubview:nameTextField];
    [contentView addSubview:accountTextField];
    [contentView addSubview:submitButton];
    
    [contentView addSubview:phoneButton];
    
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(phoneButton);
    }];
    
    
    CGSize size = CGSizeMake(imageView.image.size.width*(30.0f/imageView.image.size.height), 30);
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20).offset(20);
        make.left.equalTo(10);
        make.size.equalTo(size);
    }];
    
    
    [nowAccountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.bottom).offset(20);
        make.left.equalTo(imageView);
        make.right.lessThanOrEqualTo(-15);
    }];
    
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(nowAccountLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    
    [nowNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.bottom).offset(3);
        make.left.equalTo(0);
        make.size.equalTo(CGSizeMake(WIDTH, 40));
    }];
    
    
    [nowAccountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nowNameTextField.bottom).offset(3);
        make.left.equalTo(nowNameTextField);
        make.size.equalTo(nowNameTextField);
    }];
    
    
    [newLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nowAccountTextField.bottom).offset(40);
        make.left.equalTo(imageView);
        make.right.lessThanOrEqualTo(-15);
    }];
    
    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(newLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    
    [nameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.bottom).offset(3);
        make.left.equalTo(0);
        make.size.equalTo(CGSizeMake(WIDTH, 40));
    }];
    
    
    [accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.bottom).offset(3);
        make.left.equalTo(nameTextField);
        make.size.equalTo(nameTextField);
    }];
    
    
    [submitButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountTextField.bottom).offset(20);
        make.left.equalTo(10);
        make.width.equalTo(WIDTH-20);
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
   
        //收回键盘
        [self.view endEditing:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *dict = @{@"eid":[CZWManager manager].roleId,@"acid":self.dictionary[@"acid"],@"newAccount":accountTextField.text,@"newRealname":nameTextField.text};

        [CZWAFHttpRequest POST:expert_reAccount parameters:dict success:^(id responseObject) {
            [hud hideAnimated:YES];
            
            
            if (responseObject[@"scuess"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"scuess"]
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil, nil];
                alert.tag = 101;
                [alert show];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                });
                [self.navigationController popViewControllerAnimated:YES];
                //更新账户信息
                [DEFAULTS setObject:accountTextField.text forKey:ROLE_ACCOUNT];
                [DEFAULTS synchronize];
                [CZWManager manager].account = accountTextField.text;
                
            }else{
                [CZWAlert alertDismiss:responseObject[@"error"]];
            }
            
            
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
        }];

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
