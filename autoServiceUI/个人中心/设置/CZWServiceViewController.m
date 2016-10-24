//
//  CZWServiceViewController.m
//  autoService
//
//  Created by luhai on 15/11/29.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWServiceViewController.h"

@interface CZWServiceViewController ()

@end

@implementation CZWServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createLeftItemBack];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL *url = [NSURL URLWithString:self.urlString];
    [webView setScalesPageToFit:YES];
    webView.pageLength = 10;
//    
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (![CZWAFHttpRequest connectedToNetwork]) {
        request =   [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    }
  

    [webView loadRequest:request];
    [self.view addSubview:webView];
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
