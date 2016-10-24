
//
//  CZWShowImagePageViewController.m
//  autoService
//
//  Created by bangong on 16/7/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWShowImagePageViewController.h"
#import "CZWShowImageViewController.h"
#import "CZWBasicPanNavigationController.h"

@interface CZWShowImagePageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>
{
    NSInteger _toIndex;
}
@property (nonatomic,assign) NSInteger toLeftAndRgiht;
@end

@implementation CZWShowImagePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createLeftItemBack];

    UIPageViewController *pageView = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(10)}];
    [self.view addSubview:pageView.view];
    [self addChildViewController:pageView];
    pageView.view.backgroundColor = [UIColor blackColor];
    pageView.delegate = self;
    pageView.dataSource = self;

    CZWShowImageViewController *VC = [[CZWShowImageViewController alloc] init];
    VC.urlString = _imageUrlArray[_pageIndex];
    [pageView setViewControllers:@[VC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.title = [NSString stringWithFormat:@"%ld/%ld",_pageIndex+1,_imageUrlArray.count];


    for (UIView *view in pageView.view.subviews) {
        // _UIQueuingScrollView
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
            ((UIScrollView *)view).scrollsToTop = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    CZWBasicPanNavigationController *nvc = (CZWBasicPanNavigationController *)self.navigationController;
    nvc.alphaView.backgroundColor =  RGB_color(46, 45, 46, 1);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CZWBasicPanNavigationController *nvc = (CZWBasicPanNavigationController *)self.navigationController;
    nvc.alphaView.backgroundColor =  colorNavigationBarColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x < 10) {
        self.toLeftAndRgiht = -1;
    }else if ( scrollView.contentOffset.x > ((WIDTH+10)*2-10)){
        self.toLeftAndRgiht = 1;
    }else{
        self.toLeftAndRgiht = 0;
    }
    
}


#pragma mark - UIPageViewControllerDataSource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    CZWShowImageViewController *vc = (CZWShowImageViewController *)viewController;

    NSInteger index = [self.imageUrlArray indexOfObject:vc.urlString];
    index ++;
    if (index < self.imageUrlArray.count) {
        CZWShowImageViewController *VC = [[CZWShowImageViewController alloc] init];
        VC.urlString = _imageUrlArray[index];

        return VC;
    }
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    CZWShowImageViewController *vc = (CZWShowImageViewController *)viewController;

    NSInteger index = [self.imageUrlArray indexOfObject:vc.urlString];
    index --;
    if (index > -1) {
        CZWShowImageViewController *VC = [[CZWShowImageViewController alloc] init];
        VC.urlString = _imageUrlArray[index];

        return VC;
    }
    return nil;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{

    CZWShowImageViewController *vc = (CZWShowImageViewController *)pendingViewControllers[0];
    _toIndex = [self.imageUrlArray indexOfObject:vc.urlString];

}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{

    if (self.toLeftAndRgiht == 1 || self.toLeftAndRgiht == -1) {
        self.title = [NSString stringWithFormat:@"%ld/%ld",_toIndex+1,_imageUrlArray.count];
        self.pageIndex = _toIndex;
    }
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
