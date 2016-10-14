//
//  CZWManager.m
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//


#import "CZWManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>

/**用户登陆*/
NSString *const isUserLogin = @"isUserLogin";
/**专家登陆*/
NSString *const isExpertLogin = @"isExpertLogin";
/**判断普通用户登录还是专家登陆*/
NSString *const isUserOrExpertLogin = @"IsUserOrExpertLogin";

/**省份列表*/
NSString *const plistProviceList = @"proviceList.plist";



@interface CZWManager ()

@end
@implementation CZWManager


+(instancetype)manager{
    static CZWManager *myManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[CZWManager alloc] init];
        [myManager setUp];
        //更新好友列表
    });
   
    return myManager;
}

/**
 *  刷新属性
 */
-(void)updataManager{
    [self setUp];
}

-(void)setUp{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:isUserOrExpertLogin] isEqualToString:isUserLogin]) {
        _RoleType      = isUserLogin;
        _userType      = @"1";
        _CCtype        = CCUserType_User;
        _roleId        = [defaults objectForKey:ROLEID];
        _roleIconImage = [defaults objectForKey:ROLEIMAGEURL];
        _rongyunID     = [defaults objectForKey:RC_USERID];
        _roleName      = [defaults objectForKey:ROLENAME];
        _modelName     = [defaults objectForKey:USERMODEL];
        _account       = [defaults objectForKey:ROLE_ACCOUNT];
        [self updataUserInfo];
    }else{
        _RoleType      = isExpertLogin;
        _userType      = @"2";
        _CCtype        = CCUserType_Expert;
        _roleId        = [defaults objectForKey:ROLEID];
        _roleIconImage = [defaults objectForKey:ROLEIMAGEURL];
        _rongyunID     = [defaults objectForKey:RC_USERID];
        _roleName      = [defaults objectForKey:ROLENAME];
        _score         = [defaults objectForKey:EXPERTSCORE];
        _complete_num  = [defaults objectForKey:EXPERTCOMPLETE_NUM];
        _account       = [defaults objectForKey:ROLE_ACCOUNT];
        [self updataExpertInfo];
    }
    [self updateFriendsListWithType:CCUserType_Expert success:nil];
    [self updateFriendsListWithType:CCUserType_User success:nil];
    
    _systemShakeState = [DEFAULTS boolForKey:@"kSystemSoundID_Vibrate"];

//    SystemSoundID shake_sound_male_id = 0;//声音
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"wav"];
//    if (path) {
//        //注册声音到系统
//       // AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
//    }
//   // AudioServicesPlayAlertSound(shake_sound_male_id);
//    AudioServices
    
}

/**
 *  更新专家个人信息
 */
-(void)updataExpertInfo{

        [CZWAFHttpRequest requestInfoWithId:_roleId type:CCUserType_Expert success:^(id responseObject) {
     
            if ([responseObject count] == 0) {
                return ;
            }
            NSDictionary *dict = responseObject[0];
            if (!dict[@"error"]) {
                _complete_num = dict[@"complete_num"];
                _score = dict[@"score"];
                _roleName = dict[@"realname"];
                _roleIconImage = dict[@"headpic"];
                
            
                [DEFAULTS setObject:dict[@"complete_num"] forKey:EXPERTCOMPLETE_NUM];
                [DEFAULTS setObject:dict[@"score"] forKey:EXPERTSCORE];
                [DEFAULTS setObject:dict[@"realname"] forKey:ROLENAME];
                [DEFAULTS setObject:dict[@"headpic"] forKey:ROLEIMAGEURL];
                [DEFAULTS synchronize];
            }
            
        } failure:^(NSError *error) {
            
        }];
}

/**
 *  更新用户个人信息
 */
-(void)updataUserInfo{
    [CZWAFHttpRequest requestInfoWithId:_roleId type:CCUserType_User success:^(id responseObject) {
        NSDictionary *dict = responseObject[0];
      
        if (!dict[@"error"]) {
            _modelName = dict[@"modelName"];
            _roleIconImage = dict[@"img"];
     
            [DEFAULTS setObject:dict[@"modelName"] forKey:USERMODEL];
            [DEFAULTS setObject:dict[@"img"] forKey:ROLEIMAGEURL];
            [DEFAULTS synchronize];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//退出登录
-(void)logout{

    [DEFAULTS removeObjectForKey:ROLEID];
    [DEFAULTS removeObjectForKey:ROLEIMAGEURL];
    [DEFAULTS removeObjectForKey:ROLENAME];
    [DEFAULTS removeObjectForKey:RC_USERID];
    //用户
    [DEFAULTS removeObjectForKey:USERMODEL];
    //专家
    [DEFAULTS removeObjectForKey:EXPERTSCORE];
    [DEFAULTS removeObjectForKey:EXPERTCOMPLETE_NUM];
    [DEFAULTS removeObjectForKey:ROLE_ACCOUNT];
    
    [DEFAULTS removeObjectForKey:isUserOrExpertLogin];
    [DEFAULTS synchronize];
    /*
     清除头像缓存
     */
    [[SDImageCache sharedImageCache] removeImageForKey:[CZWManager manager].roleIconImage];
    //断开连接
    [[RCIM sharedRCIM] disconnect:NO];
    
}

//登录
-(void)login{
    [self setUp];
     [[SDImageCache sharedImageCache] removeImageForKey:[CZWManager manager].roleIconImage];
}

//延迟执行
+(void)After:(double)delayInSeconds perform:(void(^)())perform{
  
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        perform();
    });
}


//判断摄像头是否可用
+(BOOL)imagePickerEnable{
    BOOL isEnable;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized){
        isEnable = YES;
        
    }else{
        isEnable = NO;
    }
    
    return isEnable;
}

//系统震动4
-(void)setSystemShakeState:(BOOL)systemShakeState{

    [DEFAULTS setBool:systemShakeState forKey:@"kSystemSoundID_Vibrate"];
    _systemShakeState = systemShakeState;
    
}
-(void)playSystemShake{
    if (self.systemShakeState) {
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}


//删除文件
+(void)deletePlist{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath = [documentPath  objectAtIndex:0];
    NSString *filename=[filePath stringByAppendingPathComponent:plistProviceList];
   
    [fileManager removeItemAtPath:filename error:nil];
}

#pragma mark****************************************************************************

#pragma mark - 好友
//获取好友信息
-(void)getChatUserInfoWithId:(NSString *)userId
                     success:(void(^)(CZWChatUserInfo *info))success;{
    CZWChatUserInfo *user = [[CZWFmdbManager manager] selectFromeFriendsWithUserId:userId];
    if (user) {
        return success(user);
    }else{
       [CZWHttpModelResults requestChatUserInfoWithUserId:userId success:^(CZWChatUserInfo *userInfo) {
           success(userInfo);
       }];
    }
}


/**
 *  更新头像
 *
 *  @param userInfo 聊天用户信息
 */
-(void)updataChatInfoImageWithUserInfo:(CZWChatUserInfo *)userInfo{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:userInfo.iconUrl] options:0
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         //处理下载进度
        // NSLog(@"%@==%@",@(receivedSize),@(expectedSize));
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
         
         if (error) {
             NSLog(@"error is %@",error);
         }
         if (image) {
             //图片下载完成  在这里进行相关操作，如加到数组里 或者显示在imageView上
           [[CZWFmdbManager manager] updataImageIntoFriendsWithUserId:userInfo.userId image:image];
         }
     }];
}


/**
 *  添加好友
 *
 *  @param userId 融云id
 */
-(void)addFriendsWithId:(NSString *)userId type:(FriendType)type{
 
    [CZWHttpModelResults requestChatUserInfoWithUserId:userId success:^(CZWChatUserInfo *userInfo) {
        if(userInfo){
            userInfo.isfriend = type;
            [[CZWFmdbManager manager] insertIntoFriends:userInfo];
            
        }
    }];
}



//更新好友列表
- (void)refreshFriendsList{
   
    [self updateFriendsListWithType:CCUserType_Expert success:^{
        
    }];
    [self updateFriendsListWithType:CCUserType_User success:^{
        
    }];
}

/**
 *  更新好友列表
 *
 *  @param type    好友类型（专家，用户）
 *  @param success <#success description#>
 */
-(void)updateFriendsListWithType:(CCUserType)type
                         success:(void (^)())success{
    if (type == CCUserType_Expert) {
        [CZWHttpModelResults requestFriendsListWithUserId:self.roleId type:self.userType friendsType:USERTYPE_EXPERT success:^(NSArray<__kindof CZWChatUserInfo *> *infos) {
            /**
             *  清除数据
             */
            [[CZWFmdbManager manager] deleteFromFriendsWithType:USERTYPE_EXPERT];
        
            /**
             *  插入数据
             */
            [[CZWFmdbManager manager] insertListIntoFriends:infos];
            //block回调
            if (success) {
                success();
            }
          return ;
            
        } failure:^(NSError *errot) {
            //block回调
            if (success) {
                success();
            }
           return ;
        }];

    }else{
        [CZWHttpModelResults requestFriendsListWithUserId:self.roleId type:self.userType friendsType:USERTYPE_USER success:^(NSArray<__kindof CZWChatUserInfo *> *infos) {
            /**
             *  清除数据
             */
            [[CZWFmdbManager manager] deleteFromFriendsWithType:USERTYPE_USER];
            /**
             *  插入数据
             */
            [[CZWFmdbManager manager] insertListIntoFriends:infos];

            //block回调
            if (success) {
                success();
            }
           return ;
            
        } failure:^(NSError *errot) {
            //block回调

            if (success) {
                success();
            }
           return ;
        }];
    }
}

#pragma mark - 未读好友消息
/**
 *  是否有未读好友添加信息
 *
 *  @param type 好友类型
 *
 *  @return bool
 */
-(BOOL)unreadMessageOfAddFriendsWithType:(NSString *)type{
    NSString *key = [NSString stringWithFormat:@"setUnreadMessageOfAddFriends%@%@",type,self.rongyunID];
    return [DEFAULTS boolForKey:key];
}

/**
 *  设置是否有未读好友添加信息
 *
 *  @param boll bool
 *  @param type 好友类型
 */
-(void)setUnreadMessageOfAddFriends:(BOOL)boll type:(NSString *)type{
    NSString *key = [NSString stringWithFormat:@"setUnreadMessageOfAddFriends%@%@",type,self.rongyunID];
    [DEFAULTS setBool:boll forKey:key];
    [DEFAULTS synchronize];
}

#pragma 未读回复
/**
 *  判断是否有未读回复
 *
 *  @return bool
 */
-(BOOL)unreadMessageOfReply{
    NSString *key = [NSString stringWithFormat:@"unreadMessageOfReply%@",self.rongyunID];
    return [DEFAULTS boolForKey:key];
}

/**
 *  设置是否有未读回复
 *
 *  @param boll bool
 */
-(void)setUnreadMessageOfReply:(BOOL)boll{
    NSString *key = [NSString stringWithFormat:@"unreadMessageOfReply%@",self.rongyunID];
    [DEFAULTS setBool:boll forKey:key];
    [DEFAULTS synchronize];
}

#pragma 申诉与协助
/**
 *  返回我的协助、申诉是否有动态
 */
-(BOOL)unreadMessageOfAppeal{
    NSString *key = [NSString stringWithFormat:@"unreadMessageOfAppeal%@",self.rongyunID];
    return [DEFAULTS boolForKey:key];
}

/**
 *  设置我的协助、申诉是否有动态
 */
-(void)setUnreadMessageOfAppeal:(BOOL)boll{
    NSString *key = [NSString stringWithFormat:@"unreadMessageOfAppeal%@",self.rongyunID];
    [DEFAULTS setBool:boll forKey:key];
    [DEFAULTS synchronize];
}

#pragma mark- 我的账户
-(BOOL)unreadMessageOfAccount{
    NSString *key = [NSString stringWithFormat:@"unreadMessageOfAccount%@",self.rongyunID];
    return [DEFAULTS boolForKey:key];
}

-(void)setUnreadMessageOfAccount:(BOOL)boll{
    NSString *key = [NSString stringWithFormat:@"unreadMessageOfAccount%@",self.rongyunID];
    [DEFAULTS setBool:boll forKey:key];
    [DEFAULTS synchronize];
}



/**
 *  清空融云用户头像缓存
 */
-(void)clearImageForchat{
    NSString *pathString = pathString= [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/threeService/RCloudCache"];
    [self clearCachesFromDirectoryPath:pathString];
//    pathString= [NSHomeDirectory() stringByAppendingString:@"/Documents"];
//    [self clearCachesFromDirectoryPath:pathString];
}


#pragma mark - 根据路径返回目录或文件的大小
- (double)sizeWithFilePath:(NSString *)path{
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [manger subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            BOOL dir = NO;
            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1024 * 1024.0);
    } else { // 文件
        NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1024.0 * 1024.0);
    }
}
#pragma mark - 得到指定目录下的所有文件
- (NSArray *)getAllFileNames:(NSString *)dirPath{
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath error:nil];
    return files;
}
#pragma mark - 删除指定目录或文件
- (BOOL)clearCachesWithFilePath:(NSString *)path{
    NSFileManager *mgr = [NSFileManager defaultManager];
    return [mgr removeItemAtPath:path error:nil];
}
#pragma mark - 清空指定目录下文件
- (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath{
    //获得全部文件数组
    NSArray *fileAry =  [self getAllFileNames:dirPath];
    //遍历数组
    BOOL flag = NO;
    for (NSString *fileName in fileAry) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        flag = [self clearCachesWithFilePath:filePath];
        if (!flag)
            break;
    }
    return flag;
}

/**
 *  清除缓存
 */
-(void)clearCache{
    
}

+ (void)asynchronouslySetFontName:(NSString *)fontName success:(void(^)(NSString *name))success
{
    
    UIFont* aFont = [UIFont fontWithName:fontName size:24];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // Go ahead and display the sample text.
        success(fontName);
        return;
    }
    
    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show an activity indicator
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the activity indicator
                
                // Display the sample text for the newly downloaded font
               
                success(fontName);
                
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                // NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Show a progress bar
                
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
                
                NSLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Use the progress bar to indicate the progress of the downloading
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSString *_errorMessage = nil;
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                _errorMessage = [error description];
            } else {
                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Download error: %@", _errorMessage);
            });
        }
        return (bool)YES;
    });   
}

@end
