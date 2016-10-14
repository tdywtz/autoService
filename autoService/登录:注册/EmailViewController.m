//
//  EmailViewController.m
//  auto
//
//  Created by bangong on 16/3/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "EmailViewController.h"

@interface EmailViewController ()

@property (nonatomic,strong) UILabel *promptLabel;

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftItemBack];
    
    if (self.email == nil) {
        self.email = @"";
    }
  
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:@"邮件已成功发送至邮箱：，请进入邮箱查收邮件"];
    
    [matt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, matt.length)];
    [matt addAttribute:NSForegroundColorAttributeName value:colorBlack range:NSMakeRange(0, matt.length)];
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self.email attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:colorDeepBlue}];
    [matt insertAttributedString:att atIndex:@"邮件已成功发送至邮箱：".length];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    parag.lineSpacing = 4;
    [matt addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, matt.length)];
    
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.numberOfLines = 0;
    self.promptLabel.attributedText = matt;
    
    UILabel *comLabel = [[UILabel alloc] init];
    comLabel.numberOfLines = 0;
    comLabel.font = [UIFont systemFontOfSize:13];
    comLabel.textColor = colorLightGray;
    comLabel.text = @"如果半小时内收不到邮件，建议您到您的邮箱的广告邮箱、垃圾邮件目录里找找。";
    
    UIButton *button = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick) Font:15 Text:@"重新发送邮件"];
    
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:comLabel];
    [self.view addSubview:button];
    
    [self.promptLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(94);
        make.left.equalTo(10);
        make.right.equalTo(-10);
    }];
    
    [comLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.bottom).offset(20);
        make.left.equalTo(self.promptLabel);
        make.right.equalTo(self.promptLabel);
    }];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(comLabel.bottom).offset(50);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(40);
    }];
    
}


-(void)buttonClick{
     [self.navigationController popViewControllerAnimated:YES];
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
