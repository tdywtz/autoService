//
//  AppDelegate.m
//  autoService
//
//  Created by bangong on 15/11/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "AppDelegate.h"
#import "CZWOriginalViewController.h"
#import "CZWRootViewController.h"
#import "CZWBasicPanNavigationController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CZWOriginalViewController.h"
#import "CZWUserCenterViewController.h"
#import "CZWChatRecordViewController.h"
#import "CZWChatViewController.h"

#import "CZWAppPrompt.h"

@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMConnectionStatusDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    CZWAppPrompt *prompt = [CZWAppPrompt sharedInstance];
    prompt.appId = @"1127223130";
    [prompt shouAlert:AppPromptStyleScore];
    [prompt shouAlert:AppPromptStyleUpdate];
//
    /**
     *  友盟
     */
    [MobClick startWithAppkey:@"56fb361667e58ecfaf001b30" reportPolicy:BATCH   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];

    //融云即时通讯
    //通知数据
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    /**
     *设置启动时隐藏状态栏
     *同时需设置info.plist文件 Status bar is initially hidden == YES
     */
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    /**
     *设置缓存
     */
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    /**
     初始化融云appkey
     */
    [[RCIM sharedRCIM] initWithAppKey:@"8luwapkvuqeql"];
    //    //注册自定义消息
    //    [[RCIMClient sharedRCIMClient] registerMessageType:[CZWTextMessage class]];
    //设置消息携带用户信息为no
    [RCIM sharedRCIM].enableMessageAttachUserInfo = NO;
    
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //代理设置
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    if (![DEFAULTS objectForKey:isUserOrExpertLogin]) {
        CZWOriginalViewController *original = [[CZWOriginalViewController alloc] init];
        _window.rootViewController = original;
    }else{
        CZWRootViewController *root = [[CZWRootViewController alloc] init];
        CZWBasicPanNavigationController *nvc = [[CZWBasicPanNavigationController alloc] initWithRootViewController:root];
        if (remoteNotification) {
            
            CZWUserCenterViewController *center = [[CZWUserCenterViewController alloc] init];
            CZWChatRecordViewController *record = [[CZWChatRecordViewController alloc] init];
            CZWChatViewController *chat = [[CZWChatViewController alloc] init];
            NSDictionary *rc = remoteNotification[@"rc"];
            NSDictionary *aps = remoteNotification[@"aps"];
            if(rc[@"fId"]){
                chat.targetId  = rc[@"fId"];
                
                chat.conversationType = ConversationType_PRIVATE;
                NSString *string = aps[@"alert"];
                NSRange range = [string rangeOfString:@":"];
                if (range.length > 0) {
                    chat.title = [string substringToIndex:range.location];
                }
                nvc.viewControllers = @[root,center,record,chat];
            }
        }
        _window.rootViewController = nvc;
        
        
        [[RCIM sharedRCIM] connectWithToken:[DEFAULTS objectForKey:chatToken] success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//            [[RCIMClient sharedRCIMClient] getUserInfo:userId success:^(RCUserInfo *userInfo) {
//                NSLog(@"====%@",userInfo.portraitUri);
//            } error:nil];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", status);
            //            __block UIViewController *control = _window.rootViewController;
            //            CZWOriginalViewController *original = [[CZWOriginalViewController alloc] init];
            //            [UIView animateWithDuration:0.3 animations:^{
            //                _window.rootViewController = original;
            //            }completion:^(BOOL finished){
            //                control = nil;
            //                [defaults removeObjectForKey:isUserOrExpertLogin];
            //                [defaults synchronize];
            //            }];
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
            //            __block UIViewController *control = _window.rootViewController;
            //            CZWOriginalViewController *original = [[CZWOriginalViewController alloc] init];
            //            [UIView animateWithDuration:0.3 animations:^{
            //                _window.rootViewController = original;
            //            }completion:^(BOOL finished){
            //                control = nil;
            //                [defaults removeObjectForKey:isUserOrExpertLogin];
            //                [defaults synchronize];
            //            }];
            //
        }];
    }
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
//    NSLog(@"11=%@",launchOptions);
//    NSLog(@"%@",[CZWManager manager].rongyunID);
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];

    
    [NSThread sleepForTimeInterval:2.0];
    [_window makeKeyAndVisible];
    return YES;
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
    
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
   // NSLog(@"33=%@",token);
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  //  NSLog(@"44=%@",userInfo);
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSLog(@"=========%@",userInfo);
    
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
   
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
}



-(void)applicationDidFinishLaunching:(UIApplication *)application{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP),
                                                                         @(ConversationType_SYSTEM)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSNotification *notification = [NSNotification notificationWithName:AppWillEnterForeground object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)redirectNSlogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath =
    [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
            stderr);
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;

}

- (void)application:(UIApplication *)application
handleWatchKitExtensionRequest:(NSDictionary *)userInfo
              reply:(void (^)(NSDictionary *))reply {
    //    RCWKRequestHandler *handler =
    //    [[RCWKRequestHandler alloc] initHelperWithUserInfo:userInfo
    //                                              provider:self
    //                                                 reply:reply];
    //    if (![handler handleWatchKitRequest]) {
    //        // can not handled!
    //        // app should handle it here
    //        NSLog(@"not handled the request: %@", userInfo);
    //    }
}
#pragma mark - RCWKAppInfoProvider
- (NSString *)getAppName {
    return @"汽车三包";
}

- (NSString *)getAppGroups {
    return @"group.com.RCloud.UIComponent.WKShare";
}


//- (void)openParentApp {
//    [[UIApplication sharedApplication]
//     openURL:[NSURL URLWithString:@"rongcloud://connect"]];
//}

- (BOOL)getNewMessageNotificationSound {
    return ![RCIM sharedRCIM].disableMessageAlertSound;
}
- (void)setNewMessageNotificationSound:(BOOL)on {
    [RCIM sharedRCIM].disableMessageAlertSound = !on;
}

- (BOOL)getLoginStatus {
    NSString *token = [DEFAULTS stringForKey:@"userToken"];
    if (token.length) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
   
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
     
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        
        UIViewController *control = (UIViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        CZWOriginalViewController *origin = [[CZWOriginalViewController alloc] init];
        self.window.rootViewController = origin;
        [[CZWManager manager] logout];
        control = nil;
        
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        __block UIViewController *control = (UIViewController *)[UIApplication sharedApplication].keyWindow;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CZWOriginalViewController *origin = [[CZWOriginalViewController alloc] init];
            self.window.rootViewController = origin;
            [[CZWManager manager] logout];
            control = nil;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Token已过期，请重新登录"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
}



/**
 *  接收消息
 */
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    
    [[CZWManager manager] playSystemShake];
    
    if ([message.content isKindOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *noti = (RCContactNotificationMessage *)message.content;
        /**
         *  设置是否有未读好友添加信息
         */
        
        NSString *jsonSring = [noti.extra stringByReplacingOccurrencesOfString:@"|" withString:@"\""];
        NSData *data = [jsonSring dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (dict) {
 
            NSString *userType = dict[@"type"];
            
            if ([userType isEqualToString:USERTYPE_USER]) {
                [[CZWManager manager] setUnreadMessageOfAddFriends:YES type:USERTYPE_USER];
            }else{
                [[CZWManager manager] setUnreadMessageOfAddFriends:YES type:USERTYPE_EXPERT];
            }
            if ([noti.operation isEqualToString:@"同意"]) {
                [[CZWManager manager] addFriendsWithId:noti.sourceUserId type:FriendTypeYes];
            }
            
        }
    }else if ([message.content isMemberOfClass:[RCCommandMessage class]]){
        // NSLog(@"融云消息类型=%@___%@",@(message.conversationType),message.content);
        RCCommandMessage *rccomand = (RCCommandMessage *)message.content;
        if ([rccomand.name isEqualToString:@"咨询与回复"]) {
            [[CZWManager manager] setUnreadMessageOfReply:YES];
            
        }else if ([rccomand.name isEqualToString:@"我的申诉"]
                  ||[rccomand.name isEqualToString:@"专家建议"]){
            //我的申述和专家建议共用
            [[CZWManager manager] setUnreadMessageOfAppeal:YES];
        }else if ([rccomand.name isEqualToString:@"我的账户"]){
            [[CZWManager manager] setUnreadMessageOfAccount:YES];
        }
    }
    
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATIONMESSAGE object:message];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:NOTIFICATIONMESSAGE];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

/*  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
       //更新好友列表数据

    if (![userId isEqualToString:[CZWManager manager].rongyunID]) {
         [[CZWManager manager] addFriendsWithId:userId type:FriendTypeYes];
    }
 
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        
        RCUserInfo *aUser = [[RCUserInfo alloc]initWithUserId:[CZWManager manager].rongyunID name:[CZWManager manager].roleName portrait:[CZWManager manager].roleIconImage];
      
        [[RCIM sharedRCIM] refreshUserInfoCache:aUser withUserId:aUser.userId];
       
        return completion(aUser);
        
    }else{
        
        [[CZWManager manager] getChatUserInfoWithId:userId success:^(CZWChatUserInfo *info) {
            RCUserInfo *aUser = [[RCUserInfo alloc] initWithUserId:info.userId name:info.userName portrait:info.iconUrl];
           [[RCIM sharedRCIM] refreshUserInfoCache:aUser withUserId:aUser.userId];
            
            return completion(aUser);
        }];
    }

}


@end
