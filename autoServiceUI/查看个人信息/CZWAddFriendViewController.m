//
//  CZWAddFriendViewController.m
//  autoService
//
//  Created by bangong on 16/2/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWAddFriendViewController.h"

@interface CZWAddFriendViewController ()<UITextViewDelegate>
{
    CZWIMInputTextView *_textView;
}
@end

@implementation CZWAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftItemBack];
    [self createUI];
    [self createRightItem];
}

-(void)createRightItem{
   // UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"发送"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)rightItemClick{

    [self submitData];
}

-(void)submitData{

    NSDictionary *jsonDict;
    _textView.text = [_textView.text stringByTrimingWhitespace];
    
    if ([[CZWManager manager].RoleType isEqualToString:isExpertLogin]) {
        jsonDict = @{@"type":@"2",@"uid":[CZWManager manager].roleId,@"name":[CZWManager manager].roleName,
                     @"score":[CZWManager manager].score,@"complete_num":[CZWManager manager].complete_num,
                     @"content":_textView.text,@"iconUrl":[CZWManager manager].roleIconImage};
    }else{
        jsonDict = @{@"type":@"1",@"uid":[CZWManager manager].roleId,@"name":[CZWManager manager].roleName,
                     @"content":_textView.text,@"iconUrl":[CZWManager manager].roleIconImage};
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"|"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[CZWManager manager].roleId forKey:@"uid"];
    [dict setObject:[CZWManager manager].userType forKey:@"utype"];
    [dict setObject:[CZWManager manager].roleName forKey:@"name"];
    [dict setObject:[CZWManager manager].rongyunID forKey:@"fromUserId"];
    
    [dict setObject:self.ToUserId forKey:@"fid"];
    [dict setObject:self.ToUserType forKey:@"ftype"];
    [dict setObject:self.ToUserName forKey:@"friendname"];
    [dict setObject:self.targetId forKey:@"toUserId"];
    
    [dict setObject:_textView.text forKey:@"validate"];
    [dict setObject:jsonString forKey:@"extra"];
//加载提示框
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest POST:auto_requestAddFriends parameters:dict success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) {
            return  [CZWAlert alertDismiss:@"未知错误"];
        }
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"scuess"]) {
            [CZWAlert alertDismiss:dict[@"scuess"]];
            
            if (self.block) {
                self.block(YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [CZWAlert alertDismiss:dict[@"error"]];
        }

    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [CZWAlert alertDismiss:@"发送失败"];
    }];
}


-(void)createUI{
    
    UILabel *titleLabel = [LHController createLabelFont:15 Text:@"您需要发送验证申请，等待对方审核通过" Number:1 TextColor:colorBlack];
    _textView           = [[CZWIMInputTextView alloc] initWithFrame:CGRectZero];
    _textView.placeHolder = @"请输入验证信息";
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    UIView *line        = [LHController createBackLineWithFrame:CGRectZero];
    [self.view addSubview:titleLabel];
    [self.view addSubview:_textView];
    [self.view addSubview:line];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(90);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.bottom).offset(10);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.greaterThanOrEqualTo(35);
    }];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.bottom).offset(5);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(1);
    }];
}


-(void)requestSuccess:(void (^)(BOOL))block{
    self.block = block;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length > 15 && [text isEqualToString:@""]==NO) {
        return NO;
    }
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
