//
//  CZWDetailsButtonView.h
//  autoService
//
//  Created by bangong on 16/3/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  按钮选择
 */
@interface CZWDetailsButtonView : UIView

@property (nonatomic,copy) void(^block)(NSInteger index);

- (instancetype)initWith:(NSString *)buttonSting;
-(void)click:(void(^)(NSInteger index))block;
-(void)show;

@end
