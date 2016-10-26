//
//  CZWAppealModel.h
//  autoService
//
//  Created by bangong on 16/1/4.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  申诉模型
 */
@interface CZWAppealModel : NSObject
/**用户编号 */
@property (nonatomic,copy) NSString *uid;
/**申诉编号 */
@property (nonatomic,copy) NSString *cpid;
/**用户名*/
@property (nonatomic,copy) NSString *name;
/**头像链接*/
@property (nonatomic,copy) NSString *headpic;
/**城市id*/
@property (nonatomic,copy) NSString *cid;
/**城市名称*/
@property (nonatomic,copy) NSString *cname;
/**品牌名*/
@property (nonatomic,copy) NSString *brandname;
/**车系名*/
@property (nonatomic,copy) NSString *seriesname;
/**车型名*/
@property (nonatomic,copy) NSString *modelname;
/**状态名称*/
@property (nonatomic,copy) NSString *steps;

/**标题*/
@property (nonatomic,copy) NSString *title;
/**所有图片链接（用户“，”号隔开的字符串） 取3张显示*/
@property (nonatomic,copy) NSString *image;
/**日期*/
@property (nonatomic,copy) NSString *date;
/**专家申请数量*/
@property (nonatomic,copy) NSString *applynum;
/**保存cell高度*/
@property (nonatomic,assign) CGFloat cellHeight;

/**是否展开cell*/
@property (nonatomic,assign) BOOL cellOpen;
/**内容,专家查看我的建议时用当前字段存放建议内容*/
@property (nonatomic,copy) NSString *content;
/**专家查看我的建议时用当前字段存放是否建议已别采纳*/
@property (nonatomic,copy) NSString *show;

/**评分(专家信息-协助列表)*/
@property (nonatomic,copy) NSString *score;
/**评论内容(专家信息-协助列表)*/
@property (nonatomic,copy) NSString *comment;


/**电话号码*/
@property (nonatomic,copy) NSString *mobile;


@end
