//
//  CZWLocationViewController.m
//  autoService
//
//  Created by bangong on 15/12/22.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWLocationViewController.h"

@implementation CZWLocationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setup];
    [self createLeftItemback];
}

-(void)setup{
    self.navigationController.navigationBar.tintColor = colorNavigationBarColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = colorNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)createLeftItemback{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 30);
    [button setImage:[UIImage imageNamed:@"bar_btn_returnt"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemBackClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

-(void)leftItemBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
