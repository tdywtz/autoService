
//
//  CZWWrappedPolicyViewController.m
//  autoService
//
//  Created by bangong on 16/5/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWWrappedPolicyViewController.h"


@interface CZWWrappedPolicyViewController ()
{
    UIWebView *_webView;
}
@end

@implementation CZWWrappedPolicyViewController

- (void)viewDidLoad{
    [super  viewDidLoad];
    
    self.title = @"三包政策";
    [self createLeftItemBack];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.scrollView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _webView.backgroundColor = [UIColor whiteColor];
   // [_webView setScalesPageToFit:YES];
   // _webView.scalesPageToFit = YES;

    [self.view addSubview:_webView];
    
    [self loadData];
}

- (void)loadData{
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:auto_fac_policy,self.fid];
    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        
        NSMutableString *newsContentHTML = [NSMutableString stringWithFormat:@"<style>body{padding:0 10px;}</style>%@",responseObject[@"policy"]];
       NSString *width = [[NSString alloc] initWithFormat:@" style='max-width:%fpx'",WIDTH-36];
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
@end
