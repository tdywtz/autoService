//
//  CZWAboutViewController.m
//  autoService
//
//  Created by luhai on 15/11/29.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWAboutViewController.h"

@interface CZWAboutViewController ()

@end

@implementation CZWAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"关于我们";
    [self createLeftItemBack];
    [self createUI];
}

-(void)createUI{
    
    UILabel *titleLable = [LHController createLabelWithFrame:CGRectMake(0, 114, WIDTH, 60) Font:30 Bold:YES TextColor:colorNavigationBarColor Text:@"汽车三包申诉"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    
    UILabel *contentLabel = [LHController createLabelWithFrame:CGRectMake(10, 300, WIDTH-20, 100) Font:14 Bold:NO TextColor:colorDeepGray Text:@"        汽车三包争议处理APP是由国内领先的缺陷汽车产品信息收集平台车质网出品，用互联网的方式，最大程度发挥专家在争议解决中的作用，提高处理效率，节约行政资源，建立起消费者、专家、厂家之间沟通的桥梁。"];
    [self.view addSubview:contentLabel];
    
    
    UILabel *ban = [LHController createLabelWithFrame:CGRectMake(0, HEIGHT-64, WIDTH, 20) Font:12 Bold:NO TextColor:colorDeepGray Text:@"© 车质网 版权所有"];
    ban.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ban];
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
