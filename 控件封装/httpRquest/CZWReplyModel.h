//
//  CZWReplyModel.h
//  autoService
//
//  Created by bangong on 16/1/7.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  回复模型
 */
@interface CZWReplyModel : NSObject
/**
 *  回复编号
 */
@property (nonatomic,copy) NSString *replyId;
/**
 *  申述id
 */
@property (nonatomic,copy) NSString *cpid;
/**
 *  回复人id
 */
@property (nonatomic,copy) NSString *uid;
/**
 *  回复人姓名
 */
@property (nonatomic,copy) NSString *uname;
/**
 *  手机号
 */
@property (nonatomic,copy) NSString *mobile;
/**
 *  回复人头像链接
 */
@property (nonatomic,copy) NSString *iconUrl;
/**
 *  城市名称
 */
@property (nonatomic,copy) NSString *city;
/**品牌名*/
@property (nonatomic,copy) NSString *brandname;
/**车系名*/
@property (nonatomic,copy) NSString *seriesname;
/**
 *  车型名
 */
@property (nonatomic,copy) NSString *modelName;
/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  内容
 */
@property (nonatomic,copy) NSString *content;
/**
 *  是否查看过
 */
@property (nonatomic,copy) NSString *isshow;
/**
 *  日期
 */
@property (nonatomic,copy) NSString *date;
/**
 *  评分
 */
@property (nonatomic,copy) NSString *score;
/**
 *  完成单数
 */
@property (nonatomic,copy) NSString *complete_num;
/**
 *  保存cell高度
 */
@property (nonatomic,assign) CGFloat *cellHeight;

@end
