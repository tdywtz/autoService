//
//  CZWOriginalViewController.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWOriginalViewController.h"
#import "CZWUserLoginViewController.h"
#import "CZWExpertLoginViewController.h"
#import "CZWBasicPanNavigationController.h"

@interface CZWOriginalViewController ()

@end

@implementation CZWOriginalViewController

- (void)viewDidLoad {
   [super viewDidLoad];
    
    UIImageView *imageView = [LHController createImageViewWithFrame:self.view.frame ImageName:@"rootViewBackImage"];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    imageView.userInteractionEnabled = YES;
    [self.view insertSubview:imageView atIndex:0];
    
    
    UIButton *userButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(userButtonClick) Text:nil];
    [userButton setImage:[UIImage imageNamed:@"rootViewUser"] forState:UIControlStateNormal];
    [self.view addSubview:userButton];
    
    UIButton *ExpertButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(ExpertButtonClick) Text:nil];
    [ExpertButton setImage:[UIImage imageNamed:@"rootViewExpert"] forState:UIControlStateNormal];
    [self.view addSubview:ExpertButton];
    
    userButton.translatesAutoresizingMaskIntoConstraints = NO;
    ExpertButton.translatesAutoresizingMaskIntoConstraints = NO;
  
    CGFloat height = 200*factor_height;
    NSString *ver = [NSString stringWithFormat:@"%f",60*factor_width];
    NSArray *verticalContrainsts1 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[userButton(90)]-%f-|",height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(userButton)];
    NSArray *verticalContrainsts2 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[ExpertButton(userButton)]-(<=%f)-|",height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(userButton,ExpertButton)];
    
    NSArray *horizontalCOntraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-width-[userButton(90)]" options:0 metrics:@{@"width":ver} views:NSDictionaryOfVariableBindings(userButton)];
    NSArray *horizontalCOntraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[ExpertButton(userButton)]-width-|" options:0 metrics:@{@"width":ver} views:NSDictionaryOfVariableBindings(userButton,ExpertButton)];
  

    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        [NSLayoutConstraint activateConstraints:verticalContrainsts1];
        [NSLayoutConstraint activateConstraints:verticalContrainsts2];
        [NSLayoutConstraint activateConstraints:horizontalCOntraints1];
        [NSLayoutConstraint activateConstraints:horizontalCOntraints2];
    } else {
        [self.view addConstraints:verticalContrainsts1];
        [self.view addConstraints:verticalContrainsts2];
        [self.view addConstraints:horizontalCOntraints1];
        [self.view addConstraints:horizontalCOntraints2];
    }
}


-(void)userButtonClick{
   
    CZWUserLoginViewController *userLofin = [[CZWUserLoginViewController alloc] init];
    CZWBasicPanNavigationController *nvc= [[CZWBasicPanNavigationController alloc] initWithRootViewController:userLofin];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)ExpertButtonClick{
    CZWExpertLoginViewController *expert = [[CZWExpertLoginViewController alloc] init];
    CZWBasicPanNavigationController *nvc = [[CZWBasicPanNavigationController alloc] initWithRootViewController:expert];
    [self presentViewController:nvc animated:YES completion:nil];
}


- (void) viewWillUnload
{
    [super viewWillUnload];
}

//
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIDeviceOrientationPortrait);
//}


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
