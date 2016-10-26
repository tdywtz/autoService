//
//  StarView.h
//  CustomCellDemo
//
//  Created by DuHaiFeng on 13-6-9.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StarViewStyle){
    StarViewStyleDefault,
    StarViewStyleBig
};
@interface StarView : UIView

@property (nonatomic,assign) StarViewStyle style;
//设置星级
-(void)setStar:(CGFloat)star;

@end
