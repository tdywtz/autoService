//
//  CZWProposalViewController.m
//  autoService
//
//  Created by bangong on 16/3/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWProposalViewController.h"
#import "CZWIMInputTextView.h"


@interface CZWProposalViewController ()
{
    CZWIMInputTextView *_textView;
    NSString *state;
    UIButton *buttonLeft;
    UIButton *buttonRight;
}
@end

@implementation CZWProposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写处理意见报告";
    
    [self createLeftItemBack];
    [self createScrollView];
    self.scrollView.contentSize = CGSizeMake(0, HEIGHT);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:view];
    
    buttonLeft = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Font:16 Text:@"符合三包问题"];
    UIImage *image1 = [UIImage imageNamed:@"expert_prolosal"];
    image1 = [image1 stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [buttonLeft setBackgroundImage:image1 forState:UIControlStateSelected];
    buttonLeft.backgroundColor = [UIColor clearColor];
    [buttonLeft setTitleColor:colorBlack forState:UIControlStateNormal];
    [buttonLeft setTitleColor:colorNavigationBarColor forState:UIControlStateSelected];
    
    buttonRight = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Font:16 Text:@"不符合三包问题"];
    UIImage *image2 = [UIImage imageNamed:@"expert_prolosal"];
    image2 = [image2 stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [buttonRight setBackgroundImage:image2 forState:UIControlStateSelected];
    buttonRight.backgroundColor = [UIColor clearColor];
    [buttonRight setTitleColor:colorBlack forState:UIControlStateNormal];
    [buttonRight setTitleColor:colorNavigationBarColor forState:UIControlStateSelected];
    
    _textView = [[CZWIMInputTextView alloc] initWithFrame:CGRectZero];
    _textView.autoresizingMask = UIViewAutoresizingNone;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = colorLineGray.CGColor;
    _textView.placeHolder = @"请填写您对用户申诉问题的处理意见，我们将处理意见反馈给用户，作为解决问题的依据。";
    
    [view addSubview:buttonLeft];
    [view addSubview:buttonRight];
    [view addSubview:_textView];
    
    UIButton *btn = [LHController createButtnFram:CGRectZero Target:self Action:@selector(submitClick) Font:15 Text:@"提交报告"];
    [view addSubview:btn];
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [buttonLeft makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(15);
        make.size.equalTo(CGSizeMake(130, 32));
    }];
    
    [buttonRight makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonLeft.right).offset(20);
        make.top.equalTo(buttonLeft);
        make.size.equalTo(buttonLeft);
    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonLeft.bottom).offset(15);
        make.left.equalTo(15);
        make.width.equalTo(WIDTH-30);
        make.bottom.equalTo(btn.top).offset(-40);
    }];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HEIGHT-140);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(WIDTH-30, 40));
    }];
    
    [view updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn);
    }];
    
    
    [self buttonClick:buttonLeft];
}

-(void)buttonClick:(UIButton *)button{
    if (button == buttonLeft) {
        state = @"1";
        buttonLeft.selected = YES;
        buttonRight.selected = NO;
        buttonRight.layer.borderColor = colorBlack.CGColor;
        buttonRight.layer.borderWidth = 0.5;
        buttonLeft.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        buttonRight.selected = YES;
        buttonLeft.selected = NO;
        buttonLeft.layer.borderColor = colorBlack.CGColor;
        buttonLeft.layer.borderWidth = 0.5;
        buttonRight.layer.borderColor = [UIColor clearColor].CGColor;
        state = @"2";
    }
}

-(void)keyboardShow:(NSNotification *)notification{
    
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect = self.scrollView.frame;
    rect.size.height = HEIGHT - height;
    self.scrollView.frame = rect;
}

-(void)keyboardHide:(NSNotification *)notification{
    self.scrollView.frame = self.view.frame;
}
/**
 *  提交信息
 */
-(void)submitClick{
    if (![NSString isNotNULL:_textView.text]) {
        return [CZWAlert alertDismiss:@"内容不能为空"];
    }
    if (!self.cpid || !state) {
        return;
    }
    
    NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
    [dict setObject:[CZWManager manager].roleId forKey:@"eid"];
    [dict setObject:[CZWManager manager].roleName forKey:@"ename"];
    [dict setObject:self.cpid forKey:@"cpid"];
    [dict setObject:_textView.text forKey:@"comment"];
    [dict setObject:state forKey:@"state"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [CZWAFHttpRequest POST:expert_proposal parameters:dict success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count] > 0) {
            NSDictionary *dict = [responseObject firstObject];
            if (dict[@"error"]) {
                [CZWAlert alertDismiss:dict[@"error"]];
            }else if (dict[@"scuess"]){
                [CZWAlert alertDismiss:dict[@"scuess"]];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
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
