//
//  CZWFlowChartViewController.m
//  autoService
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWFlowChartViewController.h"

@interface CZWFlowChartViewController ()

@end

@implementation CZWFlowChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"处理流程";
    [self createLeftItemBack];


    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(15, 0, 0, 0));
    }];

    UIImage *image = [UIImage imageNamed:@"三包-640-960-改-1.jpg"];
    imageView.image = image;

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
