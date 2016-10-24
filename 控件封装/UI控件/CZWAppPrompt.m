//
//  CZWAppPrompt.m
//  autoService
//
//  Created by bangong on 16/4/7.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWAppPrompt.h"
#import <StoreKit/StoreKit.h>

NSString *CZWTemplateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
NSString *CZWTemplateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";
NSString *CZWTemplateReviewURLiOS8 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
NSString *LINE_VERSION_URL = @"https://itunes.apple.com/cn/lookup?id=APP_ID";


#define  auto_system_version  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define  auto_appstoreScore [NSString stringWithFormat:@"appstoreScore%@",auto_system_version]
#define  auto_numberOpenAPP [NSString stringWithFormat:@"auto_numberOpenAPP%@",auto_system_version]

@interface CZWAppPrompt ()<UIAlertViewDelegate>

@end

@implementation CZWAppPrompt

+ (CZWAppPrompt *)sharedInstance {
    static CZWAppPrompt *appirater = nil;
    if (appirater == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            appirater = [[CZWAppPrompt alloc] init];
            
        });
    }
    return appirater;
}

-(void)shouAlert:(AppPromptStyle)style{
  
    NSString *numberOpen = [[NSUserDefaults standardUserDefaults] valueForKey:auto_numberOpenAPP];
    NSInteger num = [numberOpen integerValue]+1;
    [[NSUserDefaults standardUserDefaults] setObject:@(num) forKey:auto_numberOpenAPP];
    if (style == AppPromptStyleScore) {
       
       
        if (![[NSUserDefaults standardUserDefaults] boolForKey:auto_appstoreScore]
            && (num%5) == 3){
            UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"亲，给个好评吧！"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"无情拒绝"
                                                       otherButtonTitles:@"现在就去", @"以后再说", nil];
            alertView.tag = 101;
            [alertView show];
        }
       
    }else{
        if(num%4 == 0){
              [self updataApp];
        }
    }
}

#pragma mark - 应用更新*****应用更新******应用更新**********应用更新********应用更新*****应用更新********应用更新*****应用更新
/**应用更新*/
-(void)updataApp{

    __weak __typeof(self)weakSelf = self;
    NSString *url = [LINE_VERSION_URL stringByReplacingOccurrencesOfString:@"APP_ID" withString:self.appId];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        NSArray *array = responseObject[@"results"];
        if(array.count == 0)return ;
        
        NSDictionary *dict = array[0];

        if ([dict[@"version"] compare:auto_system_version] == NSOrderedDescending) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@版本更新",dict[@"version"]]
                                                                message:dict[@"releaseNotes"]
                                                               delegate:weakSelf
                                                      cancelButtonTitle:@"下次再说"
                                                      otherButtonTitles:@"现在就去", nil];
            alertView.tag = 100;
            [alertView show];
        }

    } failure:^(NSError *error) {
       
    }];
}


/**打开应用*/
-(void)openStore{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 && NSStringFromClass([SKStoreProductViewController class]) != nil) {
        
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        NSNumber *appId = [NSNumber numberWithInteger:self.appId.integerValue];
        [storeViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:nil];
//        storeViewController.delegate = self.sharedInstance;
//        
//        id <AppiraterDelegate> delegate = self.sharedInstance.delegate;
//        if ([delegate respondsToSelector:@selector(appiraterWillPresentModalView:animated:)]) {
//            [delegate appiraterWillPresentModalView:self.sharedInstance animated:_usesAnimation];
//        }
       
        [[CZWAppPrompt getRootViewController] presentViewController:storeViewController animated:NO completion:^{
          //  [self setModalOpen:YES];
            //Temporarily use a black status bar to match the StoreKit view.
            //[CZWAppPrompt setStatusBarStyle:[UIApplication sharedApplication].statusBarStyle];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
#endif
        }];
        
        //Use the standard openUrl method if StoreKit is unavailable.
    } else {
        
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"APPIRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
#else
        NSString *reviewURL = [CZWTemplateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
        
        // iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
        // Fixes condition @see https://github.com/arashpayan/appirater/issues/205
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            reviewURL = [CZWTemplateReviewURLiOS7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
        }
        // iOS 8 needs a different templateReviewURL also @see https://github.com/arashpayan/appirater/issues/182
        else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            reviewURL = [CZWTemplateReviewURLiOS8 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
#endif
    }
}

+ (id)getRootViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    return [self iterateSubViewsForViewController:window]; // iOS 8+ deep traverse
}

+ (id)iterateSubViewsForViewController:(UIView *) parentView {
    for (UIView *subView in [parentView subviews]) {
        UIResponder *responder = [subView nextResponder];
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topMostViewController: (UIViewController *) responder];
        }
        id found = [self iterateSubViewsForViewController:subView];
        if( nil != found) {
            return found;
        }
    }
    return nil;
}

+ (UIViewController *) topMostViewController: (UIViewController *) controller {
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (buttonIndex == 1) {
       
        if (alertView.tag == 100) {
            
        }else if(alertView.tag == 101){
        
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:auto_appstoreScore];
        }
        
         [self openStore];
    }
}


@end
