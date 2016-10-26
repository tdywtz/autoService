//
//  CZWRootToolBar.h
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 按钮是否是选中状态
 */
typedef enum {
    /**
     *  选中
     */
    buttonStyleSelected,
    /**
     *  未选中
     */
    buttonStyleNomal
}buttonStyle;

typedef void(^chooseClick)(UIButton *button, NSInteger index,buttonStyle style);

@interface CZWRootToolBar : UIView

@property (nonatomic,copy) chooseClick block;

/**
 *  点击按钮时回调
 *
 *  @param block <#block description#>
 */
-(void)chooseClickButton:(chooseClick)block;
/**
 *  设置被点击UIButton选中状态
 *
 *  @param button 被点击UIButton
 */
-(void)setButtonState:(UIButton *)button;
/**
 *  设置UIButton标题和背景图片
 *
 *  @param text   标题
 *  @param button UIButton
 */
-(void)setTitle:(NSString *)text andButton:(UIButton *)button;
@end
