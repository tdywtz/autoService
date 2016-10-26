//
//  CZWUserRegisterViewController.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserRegisterViewController.h"
#import "CityChooseViewController.h"
#import "NSString-Helper.h"
#import "CZWServiceViewController.h"


@interface CZWUserRegisterViewController ()<UITextFieldDelegate>
{
    CZWTextField *userNameTextField;
    CZWTextField *passwordTextField;
    CZWTextField *repeatedPasswordTextField;
    CZWTextField *cityTextField;
    CZWTextField *emailTextField;
    UIButton *submitButton;
    CGFloat textFont;
    
    NSString *provinceName;
    NSString *cityName;
    NSString *provinceId;
    NSString *cityId;
}
@end

@implementation CZWUserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    textFont = [LHController setFont]-2;
    self.title = @"注册";
    [self createScrollView];
    [self createLeftItemBack];
    [self createTextField];
    [self createSubmitButton];
  
}

-(void)createTextField{
    NSArray *array = @[@"用户名",@"密码",@"确认密码",@"地区",@"电子邮箱"];
    NSArray *placehoderArray = @[@"4~20位，可由汉字、数字、字母、下划线组成，注册成功后用户名不可修改",@"6~16位字母、数字、和符合组成，区分大小写",@"再次输入密码",@"请选择您所在城市",@"正确填写邮箱地址"];
    CGSize size = [NSString calculateTextSizeWithText:@"电子邮箱" Font:textFont Size:CGSizeMake(1000, 20)];
    for (int i = 0; i < array.count; i ++) {
        UIView *textLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20+size.width, 45
                                                                        )];
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(10, 0, size.width, 45) Font:textFont Bold:NO TextColor:colorBlack Text:array[i]];
        [textLeftView addSubview:label];
       
        
        CZWTextField *textField = [[CZWTextField alloc] initWithFrame:CGRectMake(0, i*46, WIDTH, 45)];
        textField.placeHoldertext = placehoderArray[i];
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:textFont];
        textField.leftView = textLeftView;
        [self.scrollView addSubview:textField];
        
        UIView *lineView = [LHController createBackLineWithFrame:CGRectMake(0, textField.frame.origin.y+textField.frame.size.height, WIDTH, 1)];
        [self.scrollView addSubview:lineView];
        
        

        if (i == 0) {
            userNameTextField = textField;
        }else if (i == 1){
            passwordTextField = textField;
            passwordTextField.secureTextEntry = YES;
        }else if (i == 2){
            repeatedPasswordTextField = textField;
            repeatedPasswordTextField.secureTextEntry = YES;
        }else if (i == 3){
            cityTextField = textField;
        }else{
            emailTextField = textField;
        }
    }
}

-(void)createSubmitButton{
    submitButton = [LHController createButtnFram:CGRectMake(10, emailTextField.frame.origin.y+emailTextField.frame.size.height+30, WIDTH-20, 40) Target:self Action:@selector(submitClick) Font:textFont+2 Text:@"点击注册"];
    [self.scrollView addSubview:submitButton];
    
    UIButton *agreement = [LHController createButtnFram:CGRectMake(10, submitButton.frame.origin.y+submitButton.frame.size.height+10, WIDTH-20, 20) Target:self Action:@selector(agreementClick) Text:nil];
    [self.scrollView addSubview:agreement];
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, agreement.frame.size.width, agreement.frame.size.height) Font:textFont-2 Bold:NO TextColor:colorOrangeRed Text:@"点击注册即表示已阅读并同意《网络服务协议》"];
    [agreement addSubview:label];
    
    self.scrollView.contentSize = CGSizeMake(0, submitButton.frame.origin.y+100);
}

-(void)submitClick{
    if (userNameTextField.text.length == 0) {
        [CZWAlert customAlert:@"用户名不能为空"];
        return;
    }
    if (userNameTextField.text.length < 4 || userNameTextField.text.length > 20) {
        [CZWAlert customAlert:@"用户名长度需在4~20位之间"];
        return;
    }
    if (![NSString isUserName:userNameTextField.text]) {
        [CZWAlert customAlert:@"用户名可由4~20位汉字、数字、字母、下划线组成"];
        return;
    }
    if (passwordTextField.text.length == 0) {
        [CZWAlert customAlert:@"密码不能为空"];
        return;
    }
    if (passwordTextField.text.length < 6 || passwordTextField.text.length > 16) {
        [CZWAlert customAlert:@"密码长度需在6~16位之间"];
        return;
    }
    if (![NSString isSixToThTwelvePassword:passwordTextField.text]){
        [CZWAlert customAlert:@"密码不能包含非法字符，密码可由6~16位字母、数字和符号组成，区分大小写"];
        return;
    }

    if (![passwordTextField.text isEqualToString:repeatedPasswordTextField.text]){
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"两次输入密码不匹配"
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [al show];
    }else if (cityTextField.text.length == 0){
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"请选择地区"
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [al show];
    }else if (![NSString isEmailTest:emailTextField.text]){
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"邮箱格式不正确"
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
        [al show];
    }else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:userNameTextField.text forKey:@"uname"];
        [dict setObject:passwordTextField.text forKey:@"pwd"];
        [dict setObject:emailTextField.text forKey:@"email"];
        [dict setObject:provinceName forKey:@"pname"];
        [dict setObject:provinceId forKey:@"pid"];
        [dict setObject:cityName forKey:@"cname"];
        [dict setObject:cityId forKey:@"cid"];
        [dict setObject:appEntrance forKey:@"origin"];
       
        [self submitData:dict];
       
        //[self rigester:dict];
    }
}


//-(void)rigester:(NSDictionary *)dict{
//    NSString * URLString = @"http://192.168.1.114:999/server/forThreeAppService.ashx?act=u_reg";
//    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSString * postString = @"theRegionCode=广东";
//    NSError *Jerror;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&Jerror];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSData * postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
//    
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
//    [request setHTTPMethod:@"post"]; //指定请求方式
//    [request setURL:URL]; //设置请求的地址
//    [request setHTTPBody:postData];  //设置请求的参数
//    
////    NSURLResponse * response;
////    NSError * error;
////    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
////    
////    if (error) {
////        NSLog(@"error : %@",[error localizedDescription]);
////    }else{
////        NSLog(@"response : %@",response);
////        NSLog(@"backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
////    }
////    
//
//    
//   NSURLConnection * _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//}
//
////<pre name="code" class="objc">//接受到respone,这里面包含了HTTP请求状态码和数据头信息，包括数据长度、编码格式等
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    
//    //NSLog(@"response = %@",response); _backData = [[NSMutableData alloc]init];
//}
//
////接受到数据时调用，完整的数据可能拆分为多个包发送，每次接受到数据片段都会调用这个方法，所以需要一个全局的NSData对象，用来把每次的数据拼接在一起
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//   // [_backData appendData:data];
//}
//
////数据接受结束时调用这个方法，这时的数据就是获得的完整数据了，可以使用数据做之后的处理了
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
//  //  NSLog(@"%@",[[NSString alloc]initWithData:_backData encoding:NSUTF8StringEncoding]);
//}
//
////这是请求出错是调用，错误处理不可忽视
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    if (error.code == NSURLErrorTimedOut) {
//        NSLog(@"请求超时");
//    }
//    NSLog(@"%@",[error localizedDescription]);
//}
////</pre><br>
////<pre class="brush:java;"></pre>
////<pre class="brush:java;"></pre>
////
////<p></p>
////<pre class="brush:java;"></pre>
////最后，请求可以设置超时时间：<pre class="brush:java;">NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL cachePolicy:0 timeoutInterval:8.0];</pre>或者：<pre class="brush:java;">NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:URL];
////[request setTimeoutInterval:8.0];</pre>请求时间超过所设置的超时时间，会自动调用<pre class="brush:java;">-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error</pre>但是有个问题是怎么把判断是超时导致的请求失败，上面的例子里已经写了，可以根据返回的error的code进行判断。了解不同情况的请求失败，可以更好的给用户提示。<br>
////<br>
////<p></p>
#pragma mark - 提交注册申请
-(void)submitData:(NSDictionary *)dict{
   
    submitButton.enabled = NO;
    submitButton.backgroundColor = [UIColor grayColor];
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [CZWAFHttpRequest registerWithParameters:dict type:CCUserType_User images:nil success:^(id responseObject) {
       
        //
        [hud hideAnimated:YES];
        submitButton.enabled = YES;
        submitButton.backgroundColor = colorNavigationBarColor;
        
        if ([responseObject count] == 0) {
            return ;
        }
         NSDictionary *dict = [responseObject firstObject];
               if (dict[@"error"]) {
                   [CZWAlert customAlert:dict[@"error"]];
               }else if(dict[@"scuess"]){
                   [CZWAlert alertDismiss:dict[@"scuess"]];
                   if (self.block) {
                       self.block(userNameTextField.text,passwordTextField.text);
                       [self.navigationController popViewControllerAnimated:YES];
                   }
               }else{
                   [CZWAlert alertDismiss:@"注册失败"];
               }
       
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        submitButton.enabled = YES;
        submitButton.backgroundColor = colorNavigationBarColor;
    }];
}

-(void)setButtonEnable:(BOOL)b{
    submitButton.enabled = b;
    if (b) {
        submitButton.backgroundColor = colorNavigationBarColor;
    }else{
        submitButton.backgroundColor = colorLineGray;
    }
}

-(void)agreementClick{
    CZWServiceViewController *service = [[CZWServiceViewController alloc] init];
    service.urlString = auto_agreeForIOS;
    [self.navigationController pushViewController:service animated:YES];
}

-(void)success:(success)block{
    self.block = block;
}

#pragma amrk - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == cityTextField) {
        CityChooseViewController *city = [[CityChooseViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:city];
        [self presentViewController:nvc animated:YES completion:nil];
        [city returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
            cityTextField.text = [NSString stringWithFormat:@"%@%@",pName,cName];
            provinceName = pName;
            provinceId   = pid;
            cityName     = cName;
            cityId       = cid;
        }];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (![NSString isNotNULL:string] || [NSString isContainsEmoji:string]) {
//        return NO;
//    }
//    return YES;
//}
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
