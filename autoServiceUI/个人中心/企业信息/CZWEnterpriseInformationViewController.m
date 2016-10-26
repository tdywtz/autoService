//
//  CZWEnterpriseInformationViewController.m
//  autoService
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWEnterpriseInformationViewController.h"
#import "CZWShowImageCollectionView.h"

@interface CZWEnterpriseInformationViewController ()<UIWebViewDelegate>
{
    UILabel *titleLabel;//公司名
    UILabel *phoneLabel;
    UILabel *websiteLabel;
    UILabel *addressLabel;
    
    CZWShowImageCollectionView *showImageView;
    
    UIWebView *introductionWebView;
}
@property (nonatomic,strong) UIView *contentView;
@end

@implementation CZWEnterpriseInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业信息";
    [self createLeftItemBack];
    [self createScrollView];
    [self createInfo];
    [self loadInfoData];
}

-(void)loadInfoData{
    MBProgressHUD *  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *urlString = [NSString stringWithFormat:auto_fac_info,self.fid];
    [CZWAFHttpRequest GET:urlString success:^(id responseObject) {
        [hud hideAnimated:YES];
        titleLabel.text = responseObject[@"facName"];
        phoneLabel.text = responseObject[@"telePhone"];
        websiteLabel.text = responseObject[@"site"];
        addressLabel.text = responseObject[@"address"];
        NSArray *array = [responseObject[@"images"] componentsSeparatedByString:@"||"];
        NSMutableArray *marr;
        if (array) {
             marr = [NSMutableArray arrayWithArray:array];
            [marr removeObject:@""];
        }
        showImageView.dataArray = marr;
        
        NSMutableString *newsContentHTML = [NSMutableString stringWithFormat:@"<style>body{padding:0 10px;}</style>%@",responseObject[@"introduction"]];
        [introductionWebView loadHTMLString:newsContentHTML baseURL:nil];
        

    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}


-(void)createInfo{
    _contentView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    [self.scrollView addSubview:_contentView];
    NSArray *texts = @[@"公司名称：",@"联系电话：",@"公司网址：",@"公司地址："];
    NSArray *objs = @[@"titleLabel",@"phoneLabel",@"websiteLabel",@"addressLabel"];
    UILabel *temp = nil;
    for (int i = 0; i < 4; i ++) {
        UILabel *labelLeft = [[UILabel alloc] init];
        labelLeft.font = [UIFont systemFontOfSize:15];
        labelLeft.textColor = colorLightGray;
        labelLeft.text = texts[i];
        
        UILabel *labelRight = [[UILabel alloc] init];
        labelRight.numberOfLines = 0;
        labelRight.textColor = colorBlack;
        if (i == 0) {
            labelRight.font = [UIFont systemFontOfSize:17];
        }else{
            labelRight.font = [UIFont systemFontOfSize:15];
        }
        labelRight.text = objs[i];
        
        [self.contentView addSubview:labelLeft];
        [self.contentView addSubview:labelRight];
        if (!temp) {
            [labelLeft makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.top.equalTo(labelRight);
            }];
            [labelRight makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(labelLeft.right).offset(20);
                make.top.equalTo(15);
                make.right.lessThanOrEqualTo(-15);
            }];
        }else{
            [labelLeft makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.top.equalTo(labelRight);
            }];
            [labelRight makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(labelLeft.right).offset(20);
                make.top.equalTo(temp.bottom).offset(20);
                make.right.lessThanOrEqualTo(-15);
            }];
        }
        temp = labelRight;
        [self setValue:labelRight forKey:objs[i]];
    }
    
    UIView *lineFirst = [[UIView alloc] init];
    lineFirst.backgroundColor = colorLineGray;
   
    UILabel *imaegLabel = [[UILabel alloc] init];
    imaegLabel.font = [UIFont systemFontOfSize:15];
    imaegLabel.textColor = colorLightGray;
    imaegLabel.text = @"公司图片";
    
    showImageView = [CZWShowImageCollectionView initWithFrame:CGRectZero];
    showImageView.cellSize = CGSizeMake((WIDTH-30)/3-5, ((WIDTH-30)/3-5)*(9/16.0));
    showImageView.parentViewController = self;
    
    UIView *lineSecond = [[UIView alloc] init];
    lineSecond.backgroundColor = colorLineGray;
    
    UILabel *companyIntroductionLabel = [[UILabel alloc] init];
    companyIntroductionLabel.textColor = colorLightGray;
    companyIntroductionLabel.font = [UIFont systemFontOfSize:15];
    companyIntroductionLabel.text = @"公司简介";
    
    introductionWebView = [[UIWebView alloc] init];
    introductionWebView.delegate = self;
    
    [self.contentView addSubview:lineFirst];
    [self.contentView addSubview:imaegLabel];
    [self.contentView addSubview:showImageView];
    [self.contentView addSubview:lineSecond];
    [self.contentView addSubview:companyIntroductionLabel];
    [self.contentView addSubview:introductionWebView];
    
    [lineFirst makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(addressLabel.bottom).offset(20);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    [imaegLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(lineFirst.bottom).offset(20);
    }];
    
    [showImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(imaegLabel.bottom).offset(17);
        make.width.equalTo(WIDTH-30);
    }];
    
    [lineSecond makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(showImageView.bottom).offset(20);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    [companyIntroductionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(lineSecond.bottom).offset(20);
    }];
    
     [introductionWebView makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(0);
         make.top.equalTo(companyIntroductionLabel.bottom).offset(20);
         make.right.equalTo(0);
         make.height.equalTo(20);
     }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView.width);
        make.bottom.equalTo(introductionWebView.bottom);

    }];
}


#pragma makr - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [introductionWebView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(introductionWebView.scrollView.contentSize.height);
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
