//
//  CZWManager.h
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZWFmdbManager.h"

/**用户登陆*/
extern NSString *const isUserLogin;
/**专家登陆*/
extern NSString *const isExpertLogin;
/**判断普通用户登录还是专家登陆*/
extern NSString *const isUserOrExpertLogin;

/**用户类型*/
typedef NS_ENUM(NSInteger, CCUserType) {
    /**用户*/
    CCUserType_User = 1,
    /**专家*/
    CCUserType_Expert = 2
};

//用户密码
#define role_password       @"role_password"
//用户名（专家去真实姓名）
#define ROLENAME            @"ROLENAME"
//用户id
#define ROLEID              @"ROLEID"
//用户头像
#define ROLEIMAGEURL        @"ROLEIMAGEURL"
//融云id
#define RC_USERID           @"RC_USERID"
//车型（用户）
#define USERMODEL           @"USERMODEL"
//评分（专家）
#define EXPERTSCORE         @"EXPERTSCORE"
//解决单数（专家）
#define EXPERTCOMPLETE_NUM  @"EXPERTCOMPLETE_NUM"
//账户
#define ROLE_ACCOUNT        @"ROLE_ACCOUNT"

/**省份列表*/
extern NSString *const plistProviceList;

/**
 * 方法调用以及信息传递
 */
@interface CZWManager : NSObject

/**用户类型 (isUserLogin,isExpertLogin)*/
@property (nonatomic,copy,readonly) NSString *RoleType;
/**用户类型 (1--用户,2--专家)*/
@property (nonatomic,copy,readonly) NSString *userType;
/**用户id*/
@property (nonatomic,copy,readonly) NSString *roleId;
/**用户头像 */
@property (nonatomic,copy,readonly) NSString *roleIconImage;
/**融云id*/
@property (nonatomic,copy,readonly) NSString *rongyunID;
/**用户名*/
@property (nonatomic,copy,readonly) NSString *roleName;
/**用户--车型*/
@property (nonatomic,copy,readonly) NSString *modelName;
/**专家--评星*/
@property (nonatomic,copy,readonly) NSString *score;
/**专家--解决单数*/
@property (nonatomic,copy,readonly) NSString *complete_num;
/**登录用户类型 */
@property (nonatomic,assign,readonly) CCUserType CCtype;
/**账户 */
@property (nonatomic,copy) NSString *account;

/**
 *  开启单例
 */
+ (instancetype)manager;

/**
 *  刷新设置
 */
-(void)updataManager;

/**
 *  更新专家信息
 */
-(void)updataExpertInfo;

/**
 *  更新普通用户信息
 */
-(void)updataUserInfo;

/**
 *  退出登录
 */
-(void)logout;

/**
 *  登录
 */
-(void)login;


/**
 *  延迟执行
 *
 *  @param delayInSeconds 秒
 *  @param perform        回调
 */
+(void)After:(double)delayInSeconds perform:(void(^)())perform;

/**
 *  判断相机是否可用
 *
 *  @return bool
 */
+(BOOL)imagePickerEnable;

/**
 *  震动
 */
@property (nonatomic,assign) BOOL systemShakeState;
/**
 *  声音
 */
@property (nonatomic,assign) BOOL soundState;
/**
 *  系统震动
 */
-(void)playSystemShake;



#pragma mark - **************及时通讯******************************************
#pragma mark - 好友
/**
 *  获取好友信息
 *
 *  @param userId  融云id
 *  @param success 成功返回
 */
-(void)getChatUserInfoWithId:(NSString *)userId
                     success:(void(^)(CZWChatUserInfo *info))success;


/**
 *  更新头像
 *
 *  @param userInfo 聊天用户信息
 */
-(void)updataChatInfoImageWithUserInfo:(CZWChatUserInfo *)userInfo;

/**
 *  添加好友
 *
 *  @param userId 融云id
 */
-(void)addFriendsWithId:(NSString *)userId type:(FriendType)type;


/**
 *  更新新好友列表
 */
- (void)refreshFriendsList;


/**
 *  更新好友列表
 *
 *  @param type    好友类型（专家，用户）
 *  @param success block
 */
-(void)updateFriendsListWithType:(CCUserType)type
                         success:(void (^)())success;
/**
 *  返回是否有未读好友消息
 *
 *  @param type 好友类型（专家，用户）
 *
 *  @return bool
 */
-(BOOL)unreadMessageOfAddFriendsWithType:(NSString *)type;

/**
 *  设置是否有未读好友添加信息
 *
 *  @param boll bool
 *  @param type 好友类型
 */
-(void)setUnreadMessageOfAddFriends:(BOOL)boll type:(NSString *)type;

#pragma 未读回复
/**
 *  判断是否有未读回复
 *
 *  @return bool
 */
-(BOOL)unreadMessageOfReply;

/**
 *  设置是否有未读回复
 *
 *  @param boll bool
 */
-(void)setUnreadMessageOfReply:(BOOL)boll;

#pragma 申诉与协助
/**
 *  返回我的协助、申诉是否有动态
 */
-(BOOL)unreadMessageOfAppeal;

/**
 *  设置我的协助、申诉是否有动态
 */
-(void)setUnreadMessageOfAppeal:(BOOL)boll;

#pragma mark- 我的账户
-(BOOL)unreadMessageOfAccount;
-(void)setUnreadMessageOfAccount:(BOOL)boll;


/**
 *  清空融云用户头像缓存
 */
-(void)clearImageForchat;

#pragma mark - 根据路径返回目录或文件的大小
/**
 *  根据路径返回目录或文件的大小
 *
 *  @param path 路径名
 *
 *  @return 文件大小
 */
- (double)sizeWithFilePath:(NSString *)path;

#pragma mark - 得到指定目录下的所有文件
/**
 *  得到指定目录下的所有文件
 *
 *  @param dirPath 路径名
 *
 *  @return 文件名数组
 */
- (NSArray *)getAllFileNames:(NSString *)dirPath;

#pragma mark - 删除指定目录或文件
/**
 *  删除指定目录或文件
 *
 *  @param path 路径
 *
 *  @return 操作结果
 */
- (BOOL)clearCachesWithFilePath:(NSString *)path;

#pragma mark - 清空指定目录下文件
/**
 *  清空指定目录下文件
 *
 *  @param dirPath 路径名
 *
 *  @return 操作结果
 */
- (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath;

/**
 *  清除缓存
 */
-(void)clearCache;

//+ (void)asynchronouslySetFontName:(NSString *)fontName success:(void(^)(NSString *name))success;
@end
