//
//  CZWAlert.h
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZWAlert : NSObject

+ (void)customAlert:(NSString *)message;
+ (void)alertDismiss:(NSString *)message;

+ (void)customAlert:(NSString *)message controller:(UIViewController *)controller certain:(void(^)())certain;
+ (void)alertDismiss:(NSString *)message controller:(UIViewController *)controller;
@end
