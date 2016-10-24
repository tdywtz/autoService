//
//  LHAssetPickerController.m
//  imagePicker
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 luhai. All rights reserved.
//

#import "LHAssetPickerController.h"
#import "LHAssetGroupViewController.h"

@interface LHAssetPickerController ()

@end

@implementation LHAssetPickerController

- (instancetype)init
{
    
    LHAssetGroupViewController *LHGroup = [[LHAssetGroupViewController alloc] init];
    if ( self = [super initWithRootViewController:LHGroup]) {
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.tintColor = [UIColor colorWithRed:51./255 green:51./255 blue:51./255 alpha:1];
        self.navigationBar.tintColor = [UIColor whiteColor];
    }

    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)getAssetArray:(void (^)(NSArray *))block{
    self.getAsset = block;
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
