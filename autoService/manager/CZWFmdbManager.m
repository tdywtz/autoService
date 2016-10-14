//
//  CZWFmdbManager.m
//  autoService
//
//  Created by bangong on 15/12/8.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWFmdbManager.h"

static CZWFmdbManager *fmdbManager;
@implementation CZWFmdbManager
{
   
    FMDatabase *_dataBase;
    /**
     *  用户表名
     */
    NSString   *friendsTableName;
    /**
     *  收藏表名
     */
    NSString   *collectName;
}


+(CZWFmdbManager *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbManager = [[CZWFmdbManager alloc] init];
    });
    return fmdbManager;
}
/**
 *  刷新配置
 */
-(void)updataManager{
    [self setep];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
                [self setep];
    }
    return self;
}

-(void)setep{
    /**
     *  用户表名，使用融云id拼接确保表名唯一
     */
    friendsTableName = [NSString stringWithFormat:@"friends%@",[CZWManager manager].rongyunID];
    /**
     *  收藏表明，通过存储的用户id和类型判断数据属于哪个用户
     */
    collectName      = @"collectName";// = [NSString stringWithFormat:@"collect%@",[CZWManager manager].rongyunID];
    
    NSString *pathString = [NSHomeDirectory() stringByAppendingString:@"/Documents/userFMDB.db"];
    _dataBase = [FMDatabase databaseWithPath:pathString];
NSLog(@"%@",pathString);
    [self createTableCollect];
    [self createTableFriends];
    [self crateAddFriendSate];
}
#pragma mark - 收藏创建表
-(void)createTableCollect{
    if ([_dataBase open]) {
        //自增长
        NSString *collect =  @"create table if not exists %@(id integer primary key autoincrement,cpid varchar(256),role varchar(256),uid varchar(256))";
        NSString *sql = [NSString stringWithFormat:collect,collectName];
        //主键唯一
        //NSString *collect = @"create table if not exists collect(id varchar(256) primary key unique,role varchar(256),uid varchar(256))";
     [_dataBase executeUpdate:sql];

    }
}

//插入数据
-(void)insertIntoCollect:(NSString *)ID{
   
    [self deleteFromCollectWith:ID];
    CZWManager *manager = [CZWManager manager];
    NSString *sql = [NSString stringWithFormat:@"insert into %@(cpid,role,uid) values(?,?,?)",collectName];
    [_dataBase executeUpdate:sql,ID,manager.RoleType,manager.roleId];
}

////更新数据
//-(void)updateCollectSet:(NSString *)newsID Where:(NSString *)ID{
//    // 更新语句：update 表名 set 字段名=值 where 条件子句。如：update person set name=‘传智‘ where id=10
//    [_dataBase executeUpdate:@"update collect set id = ? where id = ?",newsID,ID];
//}
//删除数据
-(void)deleteFromCollectWith:(NSString *)ID{
     CZWManager *manager = [CZWManager manager];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where cpid = ? and role = ? and uid = ?",collectName];
    [_dataBase executeUpdate:sql,ID,manager.RoleType,manager.roleId];
}

//查询所有数据
-(NSArray *)selectAllFromCollect{
    
    CZWManager *manager = [CZWManager manager];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where role = ? and uid = ?",collectName];
    FMResultSet *set = [_dataBase executeQuery:sql,manager.RoleType,manager.roleId];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([set next]) {
        [array addObject:[set stringForColumn:@"cpid"]];
    }
    return array;
}


#pragma mark - 好友
/**
 *  创建用户表
 */
-(void)createTableFriends{
    if ([_dataBase open]) {
        //自增长
        NSString *friends =  @"create table if not exists %@(id integer primary key autoincrement,userId varchar(256),seviceId varchar(256),type varchar(256),userName varchar(256),iconUrl varchar(256),area varchar(256),modelName varchar(256),score varchar(256),complete_num varchar(256),iconImage blob,isfriend varchar(256))";
        friends = [NSString stringWithFormat:friends,friendsTableName];
     
        //主键唯一
        //NSString *collect = @"create table if not exists collect(id varchar(256) primary key unique,role varchar(256),uid varchar(256))";
        if ([_dataBase executeUpdate:friends]) {
            NSLog(@"创建成功");
        }else{
             NSLog(@"创建");
        }
    }
}
//新增好友
-(BOOL)insertIntoFriends:(CZWChatUserInfo *)userInfo{
  
    BOOL result = NO;
    if ([_dataBase open]) {
       
        //
        NSString *deletSql = [NSString stringWithFormat:@"delete from %@ where userId = ?",friendsTableName];
        [_dataBase executeUpdate:deletSql,userInfo.userId];
      
            NSString *sql =  @"insert into %@(userId,seviceId,type,userName,iconUrl,area,modelName,score,complete_num,iconImage,isfriend) values (?,?,?,?,?,?,?,?,?,?,?)";
            sql = [NSString stringWithFormat:sql,friendsTableName];
            result = [_dataBase executeUpdate:sql,userInfo.userId,userInfo.seviceId,userInfo.type,userInfo.userName,userInfo.iconUrl,userInfo.area,userInfo.modelName,userInfo.score,userInfo.complete_num,nil,[NSString stringWithFormat:@"%ld",userInfo.isfriend]];
        
    }

    return result;
}

/**
 *  批量插入用户数据
 *
 *  @param Infos 用户模型数组
 *
 *  @return 操作结果
 */
-(BOOL)insertListIntoFriends:(NSArray<__kindof CZWChatUserInfo *> *)Infos{
    
    /**
     *  事务处理
     */
    [_dataBase beginTransaction];
    BOOL isRollBack = NO;
    @try {
        for (CZWChatUserInfo *userInfo in Infos) {
            
            //  先执行删除
            NSString *deletSql = [NSString stringWithFormat:@"delete from %@ where userId = ?",friendsTableName];
            [_dataBase executeUpdate:deletSql,userInfo.userId];
            
            NSString *sql =  @"insert into %@(userId,seviceId,type,userName,iconUrl,area,modelName,score,complete_num,iconImage,isfriend) values (?,?,?,?,?,?,?,?,?,?,?)";
            sql = [NSString stringWithFormat:sql,friendsTableName];
            [_dataBase executeUpdate:sql,userInfo.userId,userInfo.seviceId,userInfo.type,userInfo.userName,userInfo.iconUrl,userInfo.area,userInfo.modelName,userInfo.score,userInfo.complete_num,nil,[NSString stringWithFormat:@"%ld",userInfo.isfriend]];
            
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [_dataBase rollback];
    }
    @finally {
        if (!isRollBack) {
            [_dataBase commit];
        }
    }
    
    return isRollBack;
}



//更新指定用户信息
-(BOOL)updataIntoFriends:(CZWChatUserInfo *)userInfo{
   BOOL result = NO;
    if ([_dataBase open]) {
         NSString *sql = @"update %@ set seviceId=?, type=?,userName=? ,iconUrl=?, area=?, modelName=?, score=?, complete_num=? where userId = ?";
        sql = [NSString stringWithFormat:sql,friendsTableName];
       result = [_dataBase executeUpdate:sql,userInfo.seviceId,userInfo.type,userInfo.userName,userInfo.iconUrl,userInfo.area,userInfo.modelName,userInfo.score,userInfo.complete_num,userInfo.userId];
    }
    return  result;
}
/**
 *  修改好友类型
 */
-(BOOL)updataFriendsTypeWithUserId:(NSString *)userId isFriends:(FriendType)isfriend{
    BOOL result = NO;
    if ([_dataBase open]) {
        NSString *sql = @"update %@ set isfriends=? where userId = ?";
        sql = [NSString stringWithFormat:sql,friendsTableName];
        result = [_dataBase executeUpdate:sql,[NSString stringWithFormat:@"%ld",isfriend]];
    }
    return  result;
}
                                                      
//更新头像
-(BOOL)updataImageIntoFriendsWithUserId:(NSString *)userId image:(UIImage *)image{
    BOOL result = NO;
    if ([_dataBase open]) {
        NSString *sql = @"update %@ set iconImage=? where userId = ?";
        sql = [NSString stringWithFormat:sql,friendsTableName];
       
       result = [_dataBase executeUpdate:sql,UIImageJPEGRepresentation(image, 1),userId];
    }
   
    return  result;
}

//查询指定用户信息
-(CZWChatUserInfo *)selectFromeFriendsWithUserId:(NSString *)userId{
     CZWChatUserInfo *userInfo = nil;
    if ([_dataBase open]) {
        NSString *sql = @"select * from %@ where userId = ?";
        sql = [NSString stringWithFormat:sql,friendsTableName];
        
        FMResultSet *set = [_dataBase executeQuery:sql,userId];
       
        while ([set next]) {
            userInfo = [[CZWChatUserInfo alloc] init];
            
            userInfo.userId       = [set stringForColumn:@"userId"];
            userInfo.seviceId     = [set stringForColumn:@"seviceId"];
            userInfo.type         = [set stringForColumn:@"type"];
            userInfo.userName     = [set stringForColumn:@"userName"];
            userInfo.iconUrl      = [set stringForColumn:@"iconUrl"];
            userInfo.area         = [set stringForColumn:@"area"];
            userInfo.isfriend     = (NSInteger)[set stringForColumn:@"isfriend"];
//            userInfo.image        = [UIImage imageWithData:[set dataForColumn:@"iconImage"]];
            //用户
            userInfo.modelName    = [set stringForColumn:@"modelName"];
            //专家
            userInfo.score        = [set stringForColumn:@"score"];
            userInfo.complete_num = [set stringForColumn:@"complete_num"];
           
        }
    }
    return userInfo;
}
//获取好友列表
-(NSArray<__kindof CZWChatUserInfo *> *)selectListFromFriends{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if ([_dataBase open]) {
        /**
         *  获取好友类型为FriendTypeYes
         */
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where isfriend = %ld",@"%@", FriendTypeYes];
        sql = [NSString stringWithFormat:sql,friendsTableName];
        FMResultSet *set = [_dataBase executeQuery:sql];
        
        while ([set next]) {
            CZWChatUserInfo *userInfo = [[CZWChatUserInfo alloc] init];
           
            userInfo.userId       = [set stringForColumn:@"userId"];
            userInfo.seviceId     = [set stringForColumn:@"seviceId"];
            userInfo.type         = [set stringForColumn:@"type"];
            userInfo.userName     = [set stringForColumn:@"userName"];
            userInfo.iconUrl      = [set stringForColumn:@"iconUrl"];
            userInfo.area         = [set stringForColumn:@"area"];
            userInfo.isfriend     = (NSInteger)[set intForColumn:@"isfriend"];
//            userInfo.image        = [UIImage imageWithData:[set dataForColumn:@"iconImage"]];
            //用户
            userInfo.modelName    = [set stringForColumn:@"modelName"];
            //专家
            userInfo.score        = [set stringForColumn:@"score"];
            userInfo.complete_num = [set stringForColumn:@"complete_num"];
            
           
            [arr addObject:userInfo];
        }
    }

    return arr;
}

//删除好友
-(BOOL)deleteFromFriendsWithUserId:(NSString *)userId{
    BOOL result = NO;
    if ([_dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where userId = ?",friendsTableName];
       result = [_dataBase executeUpdate:sql,userId];
    }
  
    return  result;
}

//清空表数据
-(BOOL)deleteDataFriendsTable{
//    /**
//     *  清空表
//     */
//    BOOL result = [_dataBase executeUpdate:@"delete from %@",friendsTableName];
//    
//    /**
//     *  自增归零
//     */
//    [_dataBase executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name=%@",friendsTableName];
//    
    return NO;
}

//清除某一用户类型数据
-(BOOL)deleteFromFriendsWithType:(NSString *)type{

    return [_dataBase executeUpdate:[NSString stringWithFormat:@"delete from %@ where type = ?",friendsTableName],type];
}

#pragma mark - 添加好友
-(void)crateAddFriendSate{
//    if ([_dataBase open]) {
//        //自增长
//        NSString *collect =  @"create table if not exists AddFriendSate (targetId,myId,)";
//        //主键唯一
//        //NSString *collect = @"create table if not exists collect(id varchar(256) primary key unique,role varchar(256),uid varchar(256))";
//        [_dataBase executeUpdate:collect];
//    
//    }
}
@end
