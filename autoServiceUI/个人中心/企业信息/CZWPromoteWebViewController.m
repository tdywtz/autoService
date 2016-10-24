//
//  CZWPromoteWebViewController.m
//  autoService
//
//  Created by bangong on 16/6/17.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWPromoteWebViewController.h"

@interface CZWPromoteWebViewController ()
{
    UILabel *titleLabel;
    UILabel *dateLabel;
    UIWebView *_webView;
}
@end

@implementation CZWPromoteWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"促销信息";
    
   [self createLeftItemBack];
  //  [self drawpath];
    [self makeUI];
    [self loadData];
}

- (void)drawpath{
    [_webView layoutIfNeeded];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,74, WIDTH, _webView.frame.origin.y-74)cornerRadius:0];

//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 0, 0) cornerRadius:0];
//
//    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = RGB_color(240, 240, 240, 1).CGColor;
    fillLayer.opacity = 0.5;
    [self.view.layer insertSublayer:fillLayer atIndex:0];
}

- (void)makeUI{
    titleLabel  =  [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = colorBlack;
    titleLabel.font = [UIFont systemFontOfSize:17];

    dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = colorLightGray;
    dateLabel.font = [UIFont systemFontOfSize:12];

    [self.view addSubview:titleLabel];
    [self.view addSubview:dateLabel];

    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(84);
        make.width.lessThanOrEqualTo(WIDTH-30);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(titleLabel.bottom).offset(10);
    }];

    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(0);
        make.top.equalTo(dateLabel.bottom).offset(20);
    }];

}

- (void)loadData{

    __weak __typeof(self)weakSelf = self;
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:auto_fac_proinfo,self.ID];
    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        titleLabel.text = responseObject[@"title"];
         dateLabel.text = responseObject[@"date"];
        [weakSelf drawpath];
        NSMutableString *newsContentHTML = [NSMutableString stringWithFormat:@"<style>body{padding:0 10px;}</style>%@",responseObject[@"promotions"]];
        NSString *width = [[NSString alloc] initWithFormat:@" style='max-width:%fpx'",WIDTH-37];
        NSRange range = [newsContentHTML rangeOfString:@"<img"];
        while (range.length != 0) {
            [newsContentHTML insertString:width atIndex:range.location+range.length];
            range = [newsContentHTML rangeOfString:@"<img" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location+range.length, newsContentHTML.length-range.location-range.length)];
        }
        range = [newsContentHTML rangeOfString:@"<IMG"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"<IMG" atIndex:range.location+range.length];
            range = [newsContentHTML rangeOfString:@"<IMG" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location+range.length, newsContentHTML.length-range.location-range.length)];
        }
        
        [_webView loadHTMLString:newsContentHTML baseURL:nil];
        
        [hud hideAnimated:YES];
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
