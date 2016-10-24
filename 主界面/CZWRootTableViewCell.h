//
//  CZWRootTableViewCell.h
//  autoService
//
//  Created by luhai on 15/11/29.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicTableViewCell.h"

/**点击查看个人信息*/
typedef void(^information)(CZWAppealModel *model);
/**收藏按钮*/
typedef void(^collect)(CZWAppealModel *model, UIButton *button);

@interface CZWRootTableViewCell : CZWBasicTableViewCell

/**头像*/
@property (nonatomic,strong) UIImageView *iconImageView;
/**用户名*/
@property (nonatomic,strong) UILabel     *nameLabel;
/**品牌-车系*/
@property (nonatomic,strong) UILabel     *brandSeriesLabel;
/**车型*/
@property (nonatomic,strong) UILabel     *modelLabel;
/**用户看协助、专家看协助时的处理申诉状态 */
@property (nonatomic,strong) UILabel    *userStateLabel;
/**城市*/
@property (nonatomic,strong) UILabel     *cityLabel;
/**标题*/
@property (nonatomic,strong) UILabel     *titelLabel;
/**内容*/
//@property (nonatomic,strong) UILabel     *contentLabel;

/**图片*/
@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *imageView3;
/**时间*/
@property (nonatomic,strong) UILabel     *timeLabel;
/**收藏按钮*/
@property (nonatomic,strong) UIButton    *collectButotn;
/**专家协助数*/
@property (nonatomic,strong) UILabel     *applearNumberLabel;

/**字体大小*/
@property (nonatomic,assign) CGFloat     textFont;
/**左侧距离*/
@property (nonatomic,assign) CGFloat     leftSpace;



@property (nonatomic,strong) CZWAppealModel *model;
//**查看信息*/
@property (nonatomic,copy) information informationBlock;
//**收藏*/
@property (nonatomic,copy) collect collectBlock;
/**
 *  点击头像或用户名时回调查看个人信息
 *
 *  @param block block
 */
-(void)individualInformation:(information)block;
/**
 *  点击收藏按钮时回调
 *
 *  @param block <#block description#>
 */
-(void)oneselfcollect:(collect)block;


- (CGFloat)viewHeight;
@end
