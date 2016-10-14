//
//  CZWChatImageViewController.m
//  autoService
//
//  Created by bangong on 15/12/22.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWChatImageViewController.h"

@interface CZWChatImageViewController ()

@end

@implementation CZWChatImageViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setup];
}

-(void)setup{
    self.navigationController.navigationBar.tintColor = colorNavigationBarColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = colorNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
}
@end
