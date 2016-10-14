//
//  PageViewcontroller.m
//  autoService
//
//  Created by bangong on 16/4/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHPageViewcontroller.h"
#import "LHShowViewController.h"

@interface LHPageViewcontroller ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) CGFloat space;
@property (nonatomic,assign) BOOL beginScrollProgress;
@property (nonatomic,assign) NSInteger toIndex;
@property (nonatomic,assign) NSInteger toLeftAndRgiht;
@property (nonatomic,assign) NSInteger current;

@end

@implementation LHPageViewcontroller

+(instancetype)initWithSpace:(CGFloat)space{
    LHPageViewcontroller *page = [[LHPageViewcontroller alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(space),NSBackgroundColorDocumentAttribute:[UIColor blackColor]}];
  
    page.space = space;
    return page;
}

-(instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options{
    if (self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options]) {
        _current = 0;
        _toLeftAndRgiht = 0;
        self.delegate =self;
        self.dataSource = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView *view in self.view.subviews) {
       // _UIQueuingScrollView
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
            ((UIScrollView *)view).scrollsToTop = NO;
        }
    }
}

#pragma mark - sets
-(void)setViewControllerWithCurrent:(NSInteger)current{
    UIPageViewControllerNavigationDirection Direction = UIPageViewControllerNavigationDirectionForward;
    if (current < self.current) {
        Direction = UIPageViewControllerNavigationDirectionReverse;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        LHShowViewController *vc = [[LHShowViewController alloc] init];
        vc.asset = self.assets[current];
        [weakSelf setViewControllers:@[vc] direction:Direction animated:YES completion:nil];
    });
    //赋值
     self.current = current;
}

-(void)setCurrent:(NSInteger)current{
    /**
     *  <#Description#>
     */
    _current = current;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = self.view.frame.size.width;
    CGFloat contentOffX = scrollView.contentOffset.x;
   
    //CGFloat mainProgress = contentOffX
    if (self.beginScrollProgress) {
        if (scrollView.contentOffset.x <= width) {
          
            if ([self.LHDelegate respondsToSelector:@selector(scrollViewDidScrollLeft:)]) {
                [self.LHDelegate scrollViewDidScrollLeft:(1-contentOffX/width)];
            }
        }else if (scrollView.contentOffset.x >= width+self.space*2){
           
            if ([self.LHDelegate respondsToSelector:@selector(scrollViewDidScrollRight:)]) {
                [self.LHDelegate scrollViewDidScrollRight:(contentOffX-width-self.space*2)/width];
            }
        }

    }
    
    if (scrollView.dragging) {
        
        if (scrollView.contentOffset.x < 0 ||  scrollView.contentOffset.x > (width+self.space)*2) {
            if ([self.LHDelegate respondsToSelector:@selector(didFinishAnimatingApper:)]) {
                [self.LHDelegate didFinishAnimatingApper:self.toIndex];
            }
     
             self.current = self.toIndex;
        }
    }
    
    if (scrollView.contentOffset.x < 10) {
        self.toLeftAndRgiht = -1;
    }else if ( scrollView.contentOffset.x > ((width+self.space)*2-10)){
        self.toLeftAndRgiht = 1;
    }else{
        self.toLeftAndRgiht = 0;
    }

}

#pragma mark - UIPageViewControllerDataSource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    LHShowViewController *show = (LHShowViewController *)viewController;
    NSInteger index = [self.assets indexOfObject:show.asset];

    if (index+1 < self.assets.count) {
        LHShowViewController *vc = [[LHShowViewController alloc] init];
        vc.asset = self.assets[index+1];
        return vc;
    }
     self.beginScrollProgress = NO;
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
   LHShowViewController *show = (LHShowViewController *)viewController;
    NSInteger index = [self.assets indexOfObject:show.asset];
    
    if (index-1 >= 0) {
        LHShowViewController *vc = [[LHShowViewController alloc] init];
        vc.asset = self.assets[index-1];
        return vc;

    }
     self.beginScrollProgress = NO;
    return nil;
}

//-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 10;
//}
//
//-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

#pragma mark - UIPageViewControllerDelegate
// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0){
    self.beginScrollProgress = YES;
    LHShowViewController *vc = (LHShowViewController *)pendingViewControllers[0];
    NSInteger index = [self.assets indexOfObject:vc.asset];
    self.toIndex = index;
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
   
    self.beginScrollProgress = NO;

    if (self.toLeftAndRgiht == 1 || self.toLeftAndRgiht == -1) {
        if ([self.LHDelegate respondsToSelector:@selector(didFinishAnimatingApper:)]) {
            [self.LHDelegate didFinishAnimatingApper:self.toIndex];
        }
         self.current = self.toIndex;
    }
}

// Delegate may specify a different spine location for after the interface orientation change. Only sent for transition style 'UIPageViewControllerTransitionStylePageCurl'.
// Delegate may set new view controllers or update double-sided state within this method's implementation as well.
//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
//    
//}
//
//- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController{
//    
//}
//- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController {
//     
//}



@end
