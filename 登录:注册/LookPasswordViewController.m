//
//  LookPasswordViewController.m
//  auto
//
//  Created by bangong on 16/3/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LookPasswordViewController.h"
#import "EmailViewController.h"

@interface LookPasswordViewController ()
{
    NSString *_urlString;
}
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *textTextField;
@property (nonatomic,strong) UIView      *testView;
@property (nonatomic,strong) NSString    *testString;
@property (nonatomic,strong) UIButton    *submitButton;

@end

@implementation LookPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftItemBack];
    
    self.nameTextField = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"用户名" Font:15 Delegate:nil];
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.nameTextField.font = [UIFont systemFontOfSize:15];
    self.nameTextField.layer.borderColor = colorLineGray.CGColor;
    self.nameTextField.layer.borderWidth = 1;
    
    self.textTextField = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"验证码" Font:15 Delegate:nil];
    self.textTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.textTextField.font = [UIFont systemFontOfSize:15];
    self.textTextField.layer.borderColor = colorLineGray.CGColor;
    self.textTextField.layer.borderWidth = 1;
    
    self.testView = [[UILabel alloc] init];
    self.testView.userInteractionEnabled = YES;
    self.testView.layer.borderColor = colorLineGray.CGColor;
    self.testView.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToGenerateCode)];
    [self.testView addGestureRecognizer:tap];
    
    
    self.submitButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(submitClick) Font:15 Text:@"点击发送邮件"];
    
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.textTextField];
    [self.view addSubview:self.testView];
    [self.view addSubview:self.submitButton];
    
    [self.nameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(100);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(40);
    }];
    
    [self.textTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.bottom).offset(20);
        make.left.equalTo(self.nameTextField);
        make.height.equalTo(self.nameTextField);
        make.right.equalTo(self.testView.left).offset(-20);
    }];
    
    [self.testView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textTextField);
        make.height.equalTo(self.textTextField);
        make.right.equalTo(-10);
        make.width.equalTo(80);
    }];
    
    [self.submitButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textTextField.bottom).offset(30);
        make.left.equalTo(self.nameTextField);
        make.right.equalTo(self.nameTextField);
        make.height.equalTo(40);
    }];
    
    [self.testView layoutIfNeeded];
    [self onTapToGenerateCode];
    
    
    UITapGestureRecognizer *spaceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spaceTap)];
    [self.view addGestureRecognizer:spaceTap];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self onTapToGenerateCode];
    self.textTextField.text = @"";
}

-(void)spaceTap{
    [self.view endEditing:YES];
}


-(void)changeClick{
    
    [self onTapToGenerateCode];
}

- (void)setUserUrl{
    _urlString = user_sendemail;
}
- (void)setExpertUrl{
    _urlString = expert_sendemail;
}

-(void)submitClick{

    if (![NSString isNickName:self.nameTextField.text]
        || self.nameTextField.text.length < 4
        || self.nameTextField.text.length > 20) {

        return [CZWAlert alertDismiss:@"用户名只能为4-20个汉字、字母、数字组成"];
    }
    if (![self.testString isEqualToString:self.textTextField.text]) {
        return [CZWAlert alertDismiss:@"验证码输入错误"];
    }
    [self.view endEditing:YES];

    [self submitData];
}

- (void)submitData{
    self.submitButton.enabled = NO;
    self.submitButton.backgroundColor = [UIColor grayColor];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [NSString stringWithFormat:_urlString,self.nameTextField.text,appEntrance];

    __weak __typeof(self)weakSelf = self;
    [CZWAFHttpRequest GET:url success:^(id responseObject) {

        self.submitButton.enabled = YES;
        self.submitButton.backgroundColor = colorNavigationBarColor;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject count] == 0) {
            return ;
        }
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"error"]) {
            [CZWAlert alertDismiss:dict[@"error"]];
        }else if (dict[@"scuess"]){
            EmailViewController *email = [[EmailViewController alloc] init];
            email.email = dict[@"scuess"];
            [weakSelf.navigationController pushViewController:email animated:YES];
        }

    } failure:^(NSError *error) {

        self.submitButton.enabled = YES;
        self.submitButton.backgroundColor = colorNavigationBarColor;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - 验证码生成
- (void)onTapToGenerateCode{
    
    for (UIView *sub in self.testView.subviews) {
        [sub removeFromSuperview];
    }
    // @{
    // @name 生成背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    // NSLog(@"%f=%f=%f",red,green,blue);
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [self.testView setBackgroundColor:color];
    
    const int count = 4;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
        if (j >= '0' && j <= '0'+9) {
            data[x] = (char)j;
        }else{
            --x;
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data
                                              length:count encoding:NSUTF8StringEncoding];
    // self.code = text;
    // @} end 生成文字
    
    CGSize cSize = CGSizeMake(10.0, 17.0);
    int width = self.testView.frame.size.width / text.length - cSize.width;
    int gao = self.testView.frame.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0, count = (int)text.length; i < count; i++) {
        pX = arc4random() % width + self.testView.frame.size.width / text.length * i - 1;
        //pX = testLabel.frame.size.width/5 * i;
        pY = arc4random() % gao-5;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, 0,
                                                       self.testView.frame.size.width / 4,
                                                       self.testView.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        [self.testView addSubview:tempLabel];
        [str appendFormat:@"%C",c];
    }
    self.testString = str;
    str = nil;
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
