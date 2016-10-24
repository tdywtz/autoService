//
//  CZWAlert.m
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWAlert.h"

@implementation CZWAlert

+ (void)customAlert:(NSString *)message{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
}

+ (void)alertDismiss:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [alert show];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

+ (void)customAlert:(NSString *)message controller:(UIViewController *)controller certain:(void(^)())certain{
    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        UIAlertController *ct = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller presentViewController:ct animated:YES completion:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            certain();
            [ct dismissViewControllerAnimated:YES completion:nil];
        }];
        [ct addAction:action];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];

    }
}

+ (void)alertDismiss:(NSString *)message controller:(UIViewController *)controller{
    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        UIAlertController *ct = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller presentViewController:ct animated:YES completion:nil];
      
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [ct dismissViewControllerAnimated:YES completion:nil];
        });

        
    }else{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [alert show];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}
@end
