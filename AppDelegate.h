//
//  AppDelegate.h
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

