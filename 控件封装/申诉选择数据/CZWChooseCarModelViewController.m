//
//  CZWChooseCarModelViewController.m
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWChooseCarModelViewController.h"

@interface CZWChooseCarModelViewController ()
{
//    NSString *barndID;
//    NSString *seriesID;
}
@end

@implementation CZWChooseCarModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.root) {
        [self createLefttItem];
    }
    [self createRightItem];
}

-(void)createLefttItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"关闭"];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
  
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)endChoose:(NSString *)title ID:(NSString *)ID{
    if (self.choosetype == chooseTypeModel) {
     
        if (self.resultsBlock) {
            
            self.resultsBlock(self.brandName,self.brandId,self.seriesNmae,self.seriesId,title,ID);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (self.choosetype == chooseTypeBrand){
        CZWChooseCarModelViewController *choose = [[CZWChooseCarModelViewController alloc] init];
        choose.ID = ID;
        choose.choosetype = chooseTypeSeries;
        choose.brandName = title;
        choose.brandId = ID;
        choose.resultsBlock = self.resultsBlock;
        [self.navigationController pushViewController:choose animated:YES];
    }else if (self.choosetype == chooseTypeSeries){
        CZWChooseCarModelViewController *choose = [[CZWChooseCarModelViewController alloc] init];
        choose.ID = ID;
        choose.choosetype = chooseTypeModel;
        choose.seriesNmae = title;
        choose.seriesId = ID;
        choose.brandName = self.brandName;
        choose.brandId = self.brandId;
        choose.resultsBlock = self.resultsBlock;
        [self.navigationController pushViewController:choose animated:YES];
    }
}

-(void)results:(results)block{
    self.resultsBlock = block;
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
