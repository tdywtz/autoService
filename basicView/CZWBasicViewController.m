//
//  CZWBasicViewController.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"
#import "NSString-Helper.h"

@interface CZWBasicViewController ()

@end

@implementation CZWBasicViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self free];
}

- (void)free{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    [MobClick beginLogPageView:@"PageOne"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick endLogPageView:@"PageOne"];
}


-(void)createLeftItemBack{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"bar_btn_returnt"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemBackClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)leftItemBackClick{
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)createScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    
    [self createNotification];
}

-(void)createNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardShow:(NSNotification *)notification{
   
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-height);
    CGFloat _yy = self.scrollContentY - self.scrollView.contentOffset.y;
    CGFloat _keyyy = self.view.frame.size.height-height;
    CGFloat tempY =  self.scrollView.contentOffset.y+_yy-_keyyy;

    if (tempY > 0 && tempY < self.scrollView.contentSize.height) {
      
        [UIView animateWithDuration:0.2 animations:^{
             self.scrollView.contentOffset = CGPointMake(0, tempY);
        }];
    }
}

-(void)keyboardHide:(NSNotification *)notification{
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollContentY = 0;
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
