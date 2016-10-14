//
//  CZWUserMyAppealCell.h
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicTableViewCell.h"

@interface CZWMyAppealModel : CZWAppealModel
/**网站反馈建议给厂家提示内容*/
@property (nonatomic,copy) NSString *prompt;
/**按钮标题*/
@property (nonatomic,copy) NSString *button;
/**转态数组 */
@property (nonatomic,strong) NSArray *stepArray;
/**专家id */
@property (nonatomic,copy) NSString *eid;
/**对专家的评论*/
@property (nonatomic,copy) NSString *factoryreply;
/**等待时间*/
@property (nonatomic,copy) NSString *waitdate;
/**(可操作状态)我的申诉-判断是否可操作--大于0不能修改、删除 */
@property (nonatomic,copy) NSString *stepid;
/**当前进度*/
@property (nonatomic,copy) NSString *num;

@end


@interface CZWUserMyAppealCell : CZWBasicTableViewCell

@property (nonatomic,copy) void(^myBlock)(CZWUserMyAppealCell *theCell,NSString *title);

@property (nonatomic,strong) CZWMyAppealModel *model;

-(void)gestureBlock:(void(^)(CZWUserMyAppealCell *theCell,NSString *title))block;
-(void)deleteTimer;

@end
