//
//  CZWAppealDetailsViewController.m
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWAppealDetailsViewController.h"
#import "CZWExpertInformationViewController.h"
#import "CZWUserInformationViewController.h"
#import "CZWIMInputBar.h"
#import "CZWEvaluateViewController.h"
#import "CZWProposalViewController.h"
#import "CZWCheckProposalViewController.h"
#import "CZWDetailsButtonView.h"
#import "CZWWordViewController.h"

@interface CZWAppealDetailsViewController ()<UIWebViewDelegate,UIScrollViewDelegate,CZWIMInputBarDelegate,UIAlertViewDelegate>
{
    UIWebView *_webView;
    CGFloat textFont;
    CZWIMInputBar *_inputBar;
    
    NSString *targetId;
    NSString *targetName;
    NSString *targetType;
    NSString *serviceEid;
    CGFloat _topHeight;
    
    UIButton *aginButton;//重新加载
}
@end

@implementation CZWAppealDetailsViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _scrollSting = @"";
    }
    return self;
}

-(void)loadData{
    NSString *string = [NSString stringWithFormat:auto_webAppealDetails,self.cpid,[CZWManager manager].roleId,[CZWManager manager].userType];
    string = [NSString stringWithFormat:@"%@&a=%d%@",string,arc4random()%100,self.scrollSting];
    NSURL *url = [NSURL URLWithString:string];
  //  NSLog(@"%@",url);
    
    NSURLRequest *request;
    if ([CZWAFHttpRequest connectedToNetwork]) {
     //   NSURLCache * cache = [NSURLCache sharedURLCache];

        request = [NSURLRequest requestWithURL:url];
        request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1];
    }else{
        //没有网络，从缓存获取数据
        [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
    }
    [_webView loadRequest:request];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


    //请求完成将滑动参数置空
     _scrollSting = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@的申诉",self.targetUname];
    
    textFont = [LHController setFont]-2;
    [self createLeftItemBack];
    if ([[CZWManager manager].RoleType isEqualToString:isExpertLogin]) {
        [self createRightItem];
    }
    
    [self createWebView];

    aginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [aginButton setTitle:@"点击重新加载" forState:UIControlStateNormal];
    [aginButton setTitleColor:colorLightGray forState:UIControlStateNormal];
    aginButton.layer.borderColor = colorLightGray.CGColor;
    aginButton.layer.borderWidth = 1;
    aginButton.layer.cornerRadius = 3;
    aginButton.hidden = YES;

    [aginButton addTarget:self action:@selector(aginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aginButton];

    [aginButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(HEIGHT/3);
        make.size.equalTo(CGSizeMake(100, 30));
    }];
}

- (void)aginButtonClick{
    aginButton.hidden = YES;
    [self loadData];
}

- (void)createRightItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 55, 20);
    [button addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, 40, 20) Font:15 Bold:NO TextColor:[UIColor whiteColor] Text:@"询问"];
    label.textAlignment = NSTextAlignmentRight;
    [button addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webAsk"]];
    imageView.frame = CGRectMake(40, (20-label.font.pointSize)/2, 20, label.font.pointSize);
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button addSubview:imageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)rightItemClick{
    if (!_inputBar) {
        _inputBar = [[CZWIMInputBar alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 36)];
        _inputBar.delegate = self;
        [self.view addSubview:_inputBar];
    }
     _inputBar.textView.placeHolder = @"询问";
    _inputBar.hidden = NO;
}

-(void)keyboardShow:(NSNotification *)notification{
   
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
   [_footView updateConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(-height );
   }];
    [_footView layoutIfNeeded];
}

-(void)keyboardHide:(NSNotification *)notification{
    [_footView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [_footView loadData];
    
}


-(void)createWebView{

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50)];
    _webView.scrollView.delegate = self;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    _footView = [[CZWAppealDetailsFootView alloc] initWithFrame:CGRectMake(10, HEIGHT-45, WIDTH-20, 40) type:CZWAppealDetailsFootViewTypeExpert];
    [self.view addSubview:_footView];
   
    

    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(_footView.top);
    }];
    
   
    [_footView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(0);
    }];

    __weak __typeof(self)weakSelf = self;
    if ([[CZWManager manager].RoleType isEqualToString:isExpertLogin]){
        [_footView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(45);
        }];
        _footView.type = CZWAppealDetailsFootViewTypeExpert;
        [_footView choose:^(NSString *state, NSString *eid, NSString *stepid) {
            
            [weakSelf caseStateExpert:state controller:weakSelf];
            
        }];
        
    }else if ([[CZWManager manager].roleId isEqualToString:self.targetUid]){
        [_footView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(45);
        }];
        _footView.type = CZWAppealDetailsFootViewTypeUser;
        [_footView choose:^(NSString *state, NSString *eid, NSString *stepid) {
            
            [weakSelf caseStateUser:state eid:eid stepid:stepid controller:weakSelf];
            
        }];
    }

    [_footView hiddenSelf:^(BOOL hidden) {
        [_footView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    }];
    _footView.cpid = self.cpid;
     [_footView loadData];
}


#pragma mark - 用户状态响应方法
-(void)caseStateUser:(NSString *)state eid:(NSString *)eid stepid:(NSString *)stepid controller:(CZWAppealDetailsViewController *)weakSelf{
   
    if ([state isEqualToString:@"对厂家受理结果评价"]){
        CZWDetailsButtonView *bv   = [[CZWDetailsButtonView alloc] initWith:@"不满意，申请咨询专家"];
     
        [bv show];
        
        [bv click:^(NSInteger index) {
            
            if (index == 0) {
                CZWEvaluateViewController *evalute = [[CZWEvaluateViewController alloc] init];
                evalute.cpid = weakSelf.cpid;
                evalute.tostyle = EvaluateToManufactor;
                [weakSelf.navigationController pushViewController:evalute animated:YES];
            }else{
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
               
                [CZWAFHttpRequest requestFacsolvedNotWithUid:[CZWManager manager].roleId cpid:self.cpid state:@"2" success:^(id responseObject) {
                    [hud hideAnimated:YES];
                    if ([responseObject count] == 0) return;
                    
                    if (responseObject[0][@"error"]) {
                        [CZWAlert alertDismiss:responseObject[0][@"error"]];
                    }else{
                        [CZWAlert alertDismiss:responseObject[0][@"scuess"]];
                        [_footView loadData];
                        //步骤为6时--下载专家意见报告
                        if ([stepid integerValue] == 6) {
                            CZWWordViewController *word = [[CZWWordViewController alloc] init];
                            word.cpid = weakSelf.cpid;
                            word.eid = eid;
                            [weakSelf.navigationController pushViewController:word animated:YES];
                        }
                    }
                    
                } failure:^(NSError *error) {
                    [hud hideAnimated:YES];
                }];
            }
        }];
    }
    else if ([state isEqualToString:@"厂家未受理，查看专家意见报告"]){
        CZWWordViewController *word = [[CZWWordViewController alloc] init];
        word.cpid = self.cpid;
        word.eid = eid;
        [weakSelf.navigationController pushViewController:word animated:YES];
    }else if ([state isEqualToString:@"对厂家进行评价"]){
        CZWEvaluateViewController *evalue = [[CZWEvaluateViewController alloc] init];
        evalue.tostyle = EvaluateToManufactorResult;
        evalue.cpid = self.cpid;
        [evalue success:^(NSString *cpid) {
            [_footView loadData];
        }];
        [self.navigationController pushViewController:evalue animated:YES];
    }else if ([state isEqualToString:@"采纳最佳建议并对专家评价"]){
        CZWCheckProposalViewController *check = [[CZWCheckProposalViewController alloc] init];
        check.cpid = self.cpid;
        check.eid = @"";
        [self.navigationController pushViewController:check animated:YES];
    }
}

#pragma mark - 专家状态响应方法
-(void)caseStateExpert:(NSString *)state controller:(CZWAppealDetailsViewController *)weakSelf{
    if ([state isEqualToString:@"我来回答"]) {
        if (!_inputBar) {
            _inputBar = [[CZWIMInputBar alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 36)];
            _inputBar.delegate = self;
            [weakSelf.view addSubview:_inputBar];
        }
        _inputBar.textView.placeHolder = [[CZWManager manager].userType isEqualToString:@"1"]?@"咨询":@"回复";
        _inputBar.hidden = NO;
    }else if ([state isEqualToString:@"填写处理建议"]){
        CZWProposalViewController *proposal = [[CZWProposalViewController alloc] init];
        proposal.cpid = weakSelf.cpid;
        proposal.eid = [CZWManager manager].roleId;
        [weakSelf.navigationController pushViewController:proposal animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    aginButton.hidden = NO;

    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [DEFAULTS setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [DEFAULTS setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [DEFAULTS setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [DEFAULTS synchronize];

    //设置不可粘贴复制
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
     _topHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('cen').offsetHeight;"] floatValue];
  
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
       
        NSString *string = request.URL.absoluteString;
         NSInteger integer = [string rangeOfString:@"?"].location+1;
      //  NSLog(@"%@",string);
      //转换编码
       // string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (string.length > integer) {
            NSString *str = [string substringFromIndex:integer];

            if ([str hasPrefix:@"type=mobile&tel="]) {
                //电话
                NSString *sub = [str substringFromIndex:@"type=mobile&tel=".length];
                NSRange range = [sub rangeOfString:@"&name="];
                NSString *tel = [sub substringToIndex:range.location];
                NSString *name = [sub substringFromIndex:range.location+range.length];
               // name = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self telephone:tel Name:name];
                
            }else if ([str hasPrefix:@"type=chat&tid="]){
               //咨询
            
                NSRange range1 = [str rangeOfString:@"type=chat&tid="];
                NSRange range2 = [str rangeOfString:@"&ttype="];
                NSRange range3 = [str rangeOfString:@"&tname="];
               
                targetId = [str substringWithRange:NSMakeRange(range1.length, range2.location-range1.length)];
                targetType = [str substringWithRange:NSMakeRange(range2.location+range2.length, range3.location-range2.length-range2.location)];
                targetName = [str substringFromIndex:range3.location+range3.length];
               
                if (!_inputBar) {
                    _inputBar = [[CZWIMInputBar alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 36)];
                    _inputBar.delegate = self;
                    _inputBar.textView.placeHolder = [[CZWManager manager].userType isEqualToString:@"1"]?@"咨询":@"回复";
                    [self.view addSubview:_inputBar];
                }
                _inputBar.hidden = NO;
                
            }else if ([str hasPrefix:@"type=info&eid="]){
                //专家个人信息
                NSString *eid = [str substringFromIndex:@"type=info&eid=".length];
                 CZWExpertInformationViewController *infomation = [[CZWExpertInformationViewController alloc] init];
                infomation.eid = eid;
                [self.navigationController pushViewController:infomation animated:YES];
                
            }
            else if ([str hasPrefix:@"type=info&uid="]){
                //用户个人信息
                NSString *uid = [str substringFromIndex:@"type=info&uid=".length];
                CZWUserInformationViewController *infomation = [[CZWUserInformationViewController alloc] init];
                infomation.userID = uid;
                [self.navigationController pushViewController:infomation animated:YES];
                
            }
            else if ([str hasPrefix:@"type=select&eid="]){
                //采纳建议
                serviceEid = [str substringFromIndex:@"type=select&eid=".length];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定采纳此专家建议"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                [alert show];
                
            }else if ([str hasPrefix:@"type=pf&cpid="]){
                //评分
                 NSRange range = [str rangeOfString:@"&eid="];
                CZWEvaluateViewController *evaluate = [[CZWEvaluateViewController alloc] init];
                evaluate.cpid = self.cpid;
                evaluate.eid = [str substringFromIndex:range.length+range.location];
                evaluate.tostyle = EvaluateToExpert;
                [self.navigationController pushViewController:evaluate animated:YES];
                
            }else if ([str hasPrefix:@"type=selectview"]){
                //查看专家建议
                NSRange range = [str rangeOfString:@"&eid="];
                CZWCheckProposalViewController *check = [[CZWCheckProposalViewController alloc] init];
                check.cpid = self.cpid;
                check.eid = [str substringFromIndex:range.length+range.location];
                self.scrollSting = [NSString stringWithFormat:@"#%@",check.eid];
                [self.navigationController pushViewController:check animated:YES];
            }
        }
        return NO;
    }
    return YES;
}


-(void)telephone:(NSString *)telephone Name:(NSString *)name{
   // NSString *phone = [NSString stringWithFormat:@"%@的电话：%@",name,telephone];
     NSMutableString *string = [[NSMutableString alloc] initWithString:telephone];
    if (telephone.length == 11) {
        [string insertString:@"-" atIndex:7];
        [string insertString:@"-" atIndex:3];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"呼叫", nil];
    alert.tag = 100;
    [alert show];

//    CZWActionSheet *sheet = [[CZWActionSheet alloc] initWithArray:@[phone,@"取消"]];
//    sheet.telephone = YES;
//    [sheet choose:^(CZWActionSheet *actionSheet, NSInteger selectedIndex) {
//        if (selectedIndex == 0) {
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telephone]];
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }];
//    [sheet show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[alertView.title stringByReplacingOccurrencesOfString:@"-" withString:@""]]];
            [[UIApplication sharedApplication] openURL:url];
        }

    }else{
        if (buttonIndex == 1) {
            __weak __typeof(self)weakSelf = self;
            [CZWAFHttpRequest requesSelectExpertHelpWithUid:[CZWManager manager].roleId cpid:self.cpid eid:serviceEid success:^(id responseObject) {
                if ([responseObject firstObject][@"error"]) {
                    
                }else{
                    [weakSelf loadData];
                    [_footView loadData];
                }
            } failure:^(NSError *error) {
                
            }];
        }

    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_inputBar.textView resignFirstResponder];
}

#pragma mark - CZWIMInputBarDelegate
- (void)CZWIMInputBarDidSendTextAction:(NSString *)aText
{

    NSString* text = [aText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"不能发送空白消息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    //判断是否点击回复按钮
     __weak __typeof(self)weakSelf = self;
    NSString *url = nil;
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (targetId && targetName) {
        //回复按钮
        url = auto_appealDetailsReply;
        [dict setObject:self.cpid forKey:@"cpid"];
        [dict setObject:[CZWManager manager].roleId forKey:@"pid"];
        [dict setObject:[CZWManager manager].userType forKey:@"ptype"];
        [dict setObject:[CZWManager manager].roleName forKey:@"pname"];
        [dict setObject:targetId forKey:@"tid"];
        [dict setObject:targetType forKey:@"ttype"];
        [dict setObject:targetName forKey:@"tname"];
        [dict setObject:aText  forKey:@"content"];
    }else{
        //询问按钮
        [dict setObject:self.cpid forKey:@"cpid"];
        [dict setObject:[CZWManager manager].roleId forKey:@"eid"];
        [dict setObject:[CZWManager manager].roleName forKey:@"ename"];
        [dict setObject:self.targetUid forKey:@"uid"];
        [dict setObject:self.targetUname forKey:@"uname"];
        [dict setObject:aText forKey:@"reason"];
        
        url = auto_wlxz;
    }
    
        [CZWAFHttpRequest POST:url parameters:dict success:^(id responseObject) {
          
            if (!targetId) {
                [_footView loadData];
            }
           if ([responseObject count] == 0) {
               return ;
           }
           NSDictionary *dict = [responseObject firstObject];
           if (dict[@"error"]) {
               [CZWAlert alertDismiss:dict[@"error"]];
           }else{
               if ([[CZWManager manager].RoleType isEqualToString:isExpertLogin]) {
                   weakSelf.scrollSting = [NSString stringWithFormat:@"#%@",[CZWManager manager].roleId];
                   
               }else{
                   weakSelf.scrollSting = [NSString stringWithFormat:@"#%@",targetId];
               }
              [weakSelf loadData];
           }
            
           _inputBar.textView.text = @"";
           
       } failure:^(NSError *error) {
           
       }];
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
