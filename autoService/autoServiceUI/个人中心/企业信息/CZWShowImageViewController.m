//
//  CZWShowImageViewController.m
//  autoService
//
//  Created by bangong on 16/7/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWShowImageViewController.h"

@interface CZWShowImageViewController ()
{
}
@end

@implementation CZWShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *url = [self.urlString stringByReplacingOccurrencesOfString:@"_avatar.jpg" withString:@"_sst.jpg"];

    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    [self.view addSubview:imageView];
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
