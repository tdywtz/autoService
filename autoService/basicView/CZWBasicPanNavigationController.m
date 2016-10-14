//
//  CZWBasicPanNavigationController.m
//  autoService
//
//  Created by luhai on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicPanNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]


@interface CZWBasicPanNavigationController ()<UIGestureRecognizerDelegate>
{
    CGPoint startTouch;
    
  //  UIImageView *lastScreenShotView;
   // UIView *blackMask;
}
//@property (nonatomic,retain) UIView *backgroundView;
//@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;
@end

@implementation CZWBasicPanNavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
//        _screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
//       _canDragBack = YES;
        
       
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        CGRect frame = self.navigationBar.frame;
        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        self.alphaView.backgroundColor = colorNavigationBarColor;
        [self.view insertSubview:self.alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
       // [UIImage imageNamed:@"bigShadow.png"]
        self.navigationBar.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setAlph{
    if (_changing == NO) {
        _changing = YES;
        if (self.alphaView.alpha == 0.0 ) {
            [UIView animateWithDuration:0.5 animations:^{
                self.alphaView.alpha = 1.0;
            } completion:^(BOOL finished) {
                _changing = NO;
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.alphaView.alpha = 0.0;
            } completion:^(BOOL finished) {
                _changing = NO;
                
            }];
        }
    }
}

-(void)endAlph{
    if (self.alphaView.alpha == 1.0) {
        return;
    }
   [UIView animateWithDuration:0.5 animations:^{
        self.alphaView.alpha = 1.0;
    }];
}

-(void)bengingAlph{
    if (self.alphaView.alpha == 0.0) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
         self.alphaView.alpha = 0.0;
    }];
}
- (void)dealloc
{
//    self.screenShotsList = nil;
//    
//    [self.backgroundView removeFromSuperview];
//    self.backgroundView = nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;    // Do any additional setup after loading the view.
    
    // draw a shadow for navigation view to differ the layers obviously.
    // using this way to draw shadow will lead to the low performace
    // the best alternative way is making a shadow image.
    //
    //self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    //self.view.layer.shadowOffset = CGSizeMake(5, 5);
    //self.view.layer.shadowRadius = 5;
    //self.view.layer.shadowOpacity = 1;
    
   // [self setUp];
    [self setNagitionBar];
}

-(void)setNagitionBar{
    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        self.navigationController.hidesBarsOnTap = NO;
    }
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.barTintColor = colorNavigationBarColor;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
}

//-(void)setUp{
//    //屏蔽掉iOS7以后自带的滑动返回手势 否则有BUG
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
//    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
//    [self.view addSubview:shadowImageView];
//    
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
//                                                                                action:@selector(paningGestureReceive:)];
//    [recognizer delaysTouchesBegan];
//    [self.view addGestureRecognizer:recognizer];
//}
//
//
//// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  //  [self.screenShotsList addObject:[self capture]];
    if (!animated) {
        CATransition *animation = [self addCubeAnimationWithAnimationSubType:@"push"];
        [self.view.layer addAnimation:animation forKey:@"push"];

    }
        [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (!animated) {
        CATransition *animation = [self addCubeAnimationWithAnimationSubType:@"pop"];
        [self.view.layer addAnimation:animation forKey:@"pop"];
    }
   return [super popViewControllerAnimated:animated];
}



-(CATransition*)addCubeAnimationWithAnimationSubType:(NSString*)subType
{
    CATransition*animation=[CATransition animation];
    //设置动画效果
    [animation setType:@"cube"];
    if ([subType isEqualToString:@"push"]) {
        //设置动画方向
        [animation setSubtype:kCATransitionFromLeft];

    }else{
        //设置动画方向
        [animation setSubtype:kCATransitionFromRight];

    }
        //设置动画播放时间
    [animation setDuration:0.5f];
    //设置动画作用范围
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    return animation;
}

//
//// override the pop method
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    [self.screenShotsList removeLastObject];
//    
//    return [super popViewControllerAnimated:animated];
//}
//
//#pragma mark - Utility Methods -
//
//// get the current view screen shot
//- (UIImage *)capture
//{
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return img;
//}
//
//// set lastScreenShotView 's position and alpha when paning
//- (void)moveViewWithX:(float)x
//{
//    
//  //  NSLog(@"Move to:%f",x);
//    x = x>
//    WIDTH?WIDTH:x;
//    x = x<0?0:x;
//    
//    CGRect frame = self.view.frame;
//    frame.origin.x = x;
//    self.view.frame = frame;
//    
//    float scale = (x/6400)+0.95;
//    float alpha = 0.4 - (x/800);
//    
//    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
//    blackMask.alpha = alpha;
//    
//}
//
//#pragma mark - Gesture Recognizer -
//
//- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
//{
//    // If the viewControllers has only one vc or disable the interaction, then return.
//    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
//    
//    // we get the touch position by the window's coordinate
//    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
//    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
//    if (recoginzer.state == UIGestureRecognizerStateBegan) {
//        
//        _isMoving = YES;
//        startTouch = touchPoint;
//        
//        if (!self.backgroundView)
//        {
//            CGRect frame = self.view.frame;
//            
//            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
//            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
//            
//            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
//            blackMask.backgroundColor = [UIColor blackColor];
//            [self.backgroundView addSubview:blackMask];
//        }
//        
//        self.backgroundView.hidden = NO;
//        
//        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
//        
//        UIImage *lastScreenShot = [self.screenShotsList lastObject];
//        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
//        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
//        
//        //End paning, always check that if it should move right or move left automatically
//    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
//        
//        if (touchPoint.x - startTouch.x > 50)
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self moveViewWithX:375];
//            } completion:^(BOOL finished) {
//                
//                [self popViewControllerAnimated:NO];
//                CGRect frame = self.view.frame;
//                frame.origin.x = 0;
//                self.view.frame = frame;
//                
//                _isMoving = NO;
//            }];
//        }
//        else
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                [self moveViewWithX:0];
//            } completion:^(BOOL finished) {
//                _isMoving = NO;
//                self.backgroundView.hidden = YES;
//            }];
//            
//        }
//        return;
//        
//        // cancal panning, alway move to left side automatically
//    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            [self moveViewWithX:0];
//        } completion:^(BOOL finished) {
//            _isMoving = NO;
//            self.backgroundView.hidden = YES;
//        }];
//        
//        return;
//    }
//    
//    // it keeps move with touch
//    if (_isMoving) {
//        [self moveViewWithX:touchPoint.x - startTouch.x];
//    }
//}
//
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
