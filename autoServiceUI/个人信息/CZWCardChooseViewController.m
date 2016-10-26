//
//  CZWCardChooseViewController.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWCardChooseViewController.h"
#import "CZWDatePicker.h"
#import "NSString-Helper.h"

@interface CZWCardChooseViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
}
@end

@implementation CZWCardChooseViewController
- (void)dealloc
{
    _textField = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createLeftItemBack];
    [self createRightItem];
    [self createScrollView];
    [self createTextField];
    self.scrollView.backgroundColor = RGB_color(244, 244, 244, 1);
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"保存"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    
        if (_choose == cardChooseTypeName) {
            if ([NSString isName:_textField.text]) {
                 [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"姓名只能包含汉子和字母"];
            }
        }else if (_choose == cardChooseTypeSex){
        
            
            
        }else if (_choose == cardChooseTypeBirth){
            if (_textField.text.length > 0) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"请选择生日"];
            }
            
        }else if (_choose == cardChooseTypeAge){
            if ([_textField.text integerValue] > 10) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"请输入大于10的数字"];
            }
            
        }else if (_choose == cardChooseTypePhoneNumber){
            if ([NSString isNumber:_textField.text] && _textField.text.length == 11) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"手机号码须为11位数字"];
            }
            
        }else if (_choose == cardChooseTypeEmail){
            if ([NSString isEmailTest:_textField.text] && _textField.text.length > 0) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"邮箱格式不正确"];
            }
            
        }else if (_choose == cardChooseTypeTelephone){
            if ([NSString isNotNULL:_textField.text]) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"您还没有输入内容"];
            }
            
        }else if (_choose == cardChooseTypeQQ){
            if ([NSString isNumber:_textField.text]) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"qq号只能输入数字"];
            }
            
        }else if (_choose == cardChooseTypeCompany){
            if ([NSString isNotNULL:_textField.text]) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"你还没有输入内容"];
            }
            
        }else if (_choose == cardChooseTypeProfessional){
            if ([NSString isNotNULL:_textField.text]) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"你还没有输入内容"];
            }
            
        }else if (_choose == cardChooseTypeBeGoodAt){
            if ([NSString isNotNULL:_textField.text]) {
                [self setGetUrlstring];
            }else{
                [CZWAlert customAlert:@"你还没有输入内容"];
            }
        }
}

-(void)setGetUrlstring{
    
    NSString *url;
    CZWManager *manager = [CZWManager manager];
    if ([manager.RoleType isEqualToString:isUserLogin]) {
        url = [NSString stringWithFormat:@"%@&uid=%@&%@=%@",user_updateInformation,manager.roleId,self.updateKey,_textField.text];
    
    }else{
        url = [NSString stringWithFormat:@"%@&eid=%@&%@=%@",expert_updateInformation,manager.roleId,self.updateKey,_textField.text];
    }
    [self.view endEditing:YES];
     self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((double)0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self submitData:url];
    });
}
//提交数据
-(void)submitData:(NSString *)url{

     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count] == 0) {
            return ;
        }
        NSDictionary *dict = [responseObject firstObject];
        if (dict[@"error"]) {
            [CZWAlert alertDismiss:dict[@"error"]];
        }else{
            [CZWAlert alertDismiss:dict[@"scuess"]];
            if (weakSelf.block) {
                weakSelf.block(weakSelf.updateKey,_textField.text);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

-(void)createTextField{
    
    _textField = [LHController createTextFieldWithFrame:CGRectMake(0, 20, WIDTH, 40) Placeholder:nil Font:15 Delegate:self];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.text = self.textFieldText;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    [self.scrollView addSubview:_textField];
    
    if (self.choose == cardChooseTypeBirth) {
        _textField.enabled = NO;
        [self createDatePicker];
    }else{
          [_textField becomeFirstResponder];
    }
    
    _textField.text = self.textFieldText;
}

-(void)createDatePicker{
    CZWDatePicker *picker = [[CZWDatePicker alloc] initWithFrame:CGRectMake(0, _textField.frame.origin.y+_textField.frame.size.height+10, WIDTH, 180)];
    picker.backgroundColor = [UIColor whiteColor];
    [picker returnDate:^(NSString *date) {
        _textField.text = date;
    }];
    [self.scrollView addSubview:picker];
}


-(void)createTextView{
    UITextView *_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 80)];
    _textView.backgroundColor = [UIColor whiteColor];
}

-(void)setChoose:(cardChooseType)choose{
    _choose = choose;
  
    if (_choose == cardChooseTypeName) {
        self.title  = @"真实姓名";
    }else if (_choose == cardChooseTypeSex){
        self.title  = @"性别";
    }else if (_choose == cardChooseTypeBirth){
        self.title  = @"生日";
    }else if (_choose == cardChooseTypeAge){
        self.title  = @"年龄";
    }else if (_choose == cardChooseTypePhoneNumber){
        self.title  = @"手机号";
    }else if (_choose == cardChooseTypeEmail){
        self.title  = @"邮箱地址";
    }else if (_choose == cardChooseTypeTelephone){
        self.title  = @"固定电话";
    }else if (_choose == cardChooseTypeQQ){
        self.title  = @"QQ";
    }else if (_choose == cardChooseTypeCompany){
        self.title  = @"公司";
    }else if (_choose == cardChooseTypeProfessional){
        self.title  = @"职业";
    }else if (_choose == cardChooseTypeBeGoodAt){
        self.title  = @"擅长领域";
    }
}

-(void)success:(success)block{
    self.block = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (self.se) {
//        <#statements#>
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
