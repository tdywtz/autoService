//
//  CZWWordViewController.m
//  autoService
//
//  Created by bangong on 16/3/14.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWWordViewController.h"
#import "StarView.h"
#import "TestLabel.h"

@interface CZWWordViewController ()
{
    UIImageView *iconIamgeView;
    UILabel     *labelName;
    UILabel     *labelDate;
    StarView    *starImageView;
    /**
     *  解决单数
     */
    UILabel     *labelResolve;
    UILabel     *labelCity;
    TestLabel     *labelContent;
    UIView      *lineview;
}
@end

@implementation CZWWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"专家意见报告";
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    [self createLeftItemBack];
    [self createUI];
    [self loadData];
}

-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *url = [NSString stringWithFormat:user_advice,self.eid,self.cpid];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject count]) {
            NSDictionary *dict = [responseObject firstObject];
            [iconIamgeView sd_setImageWithURL:[NSURL URLWithString:dict[@"headpic"]] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
            labelName.attributedText = [NSAttributedString expertName:dict[@"name"]];
            labelDate.text = dict[@"date"];
            [starImageView setStar:[dict[@"score"] floatValue]];
            NSString *num = [NSString stringWithFormat:@"已解决%@单",dict[@"complete_num"]];
            labelResolve.attributedText = [NSAttributedString numberColorAttributeSting:num color:colorNavigationBarColor];
            labelCity.text = dict[@"city"];
            
            AttributStage *stage = [[AttributStage alloc] init];
            stage.textColor = colorDeepGray;
            labelContent.text = dict[@"reason"];
            labelContent.attributedText = [NSMutableAttributedString attributedStringWithStage:stage string:dict[@"reason"]];
            
            [labelContent setNeedsLayout];
            [labelContent layoutIfNeeded];
            
            if (labelContent.frame.size.height > lineview.frame.size.height-10) {
                
                [lineview updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(labelContent.frame.size.height+10);
                }];
            }
        }

    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

-(void)createUI{
    UIView *contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];

    iconIamgeView = [[UIImageView alloc] init];
    iconIamgeView.layer.cornerRadius = 25;
    iconIamgeView.layer.masksToBounds = YES;
    
    CGFloat textFont = 15;
    labelName = [LHController createLabelFont:textFont Text:nil Number:1 TextColor:colorNavigationBarColor];
    labelDate = [LHController createLabelFont:textFont-3 Text:nil Number:1 TextColor:colorLightGray];
    starImageView = [[StarView alloc] initWithFrame:CGRectZero];
    labelResolve = [LHController createLabelFont:textFont-3 Text:nil Number:1 TextColor:colorLightGray];
    labelCity  = [LHController createLabelFont:textFont-3 Text:nil Number:1 TextColor:colorLightGray];
    labelContent  = [[TestLabel alloc] init];
    labelContent.font = [UIFont systemFontOfSize:textFont-2];
    labelContent.textColor = colorDeepGray;
    labelContent.numberOfLines = 0;
    
 
//    labelContent.layer.borderColor = colorLineGray.CGColor;
//    labelContent.layer.borderWidth = 1;
    
   lineview = [[UIView alloc] initWithFrame:CGRectZero];
    lineview.layer.borderColor = colorLineGray.CGColor;
    lineview.layer.borderWidth = 1;
    
    
    [contentView addSubview:iconIamgeView];
    [contentView addSubview:labelName];
    [contentView addSubview:labelDate];
    [contentView addSubview:starImageView];
    [contentView addSubview:labelResolve];
    [contentView addSubview:labelCity];
    [contentView addSubview:labelContent];
    [contentView insertSubview:lineview belowSubview:labelContent];
 
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(labelContent.bottom).offset(100);
    }];
    
    [iconIamgeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(15);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [labelName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIamgeView.right).offset(10);
        make.top.equalTo(18);
        make.right.lessThanOrEqualTo(labelDate.left);
    }];
    
    [labelDate makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(labelName);
    }];
    
    [starImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName);
        make.top.equalTo(labelName.bottom);
        make.size.equalTo(CGSizeMake(75, 23));
    }];
    
    [labelResolve makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starImageView);
        make.left.equalTo(starImageView.right).offset(10);
        make.right.lessThanOrEqualTo(labelCity.left);
    }];
    
    [labelCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelResolve);
        make.right.equalTo(-15);
    }];
    
    labelContent.preferredMaxLayoutWidth = WIDTH-30;
    [labelContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIamgeView.bottom).offset(30);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    [lineview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelContent).offset(-5);
        make.left.equalTo(labelContent).offset(-5);
        make.right.equalTo(labelContent).offset(5);
        make.height.equalTo(HEIGHT-220);
    }];
    
}

-(void)btnClick{
    UIImageWriteToSavedPhotosAlbum([self getImageFromView:self.scrollView], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"已存入手机相册"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"保存失败"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil ];
        [alert show];
    }
}

-(UIImage *)getImageFromView:(UIView *)theView
{
    theView.backgroundColor = [UIColor whiteColor];
    //UIGraphicsBeginImageContext(theView.bounds.size);
    self.view.backgroundColor = [UIColor redColor];
    CGSize size = theView.bounds.size;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scorll = (UIScrollView *)theView;
       
        size = CGSizeMake(theView.bounds.size.width, scorll.contentSize.height);
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
