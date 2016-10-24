//
//  CZWActionSheet.h
//  autoService
//
//  Created by bangong on 15/12/10.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZWActionSheet;
typedef void(^choose)(CZWActionSheet *actionSheet, NSInteger selectedIndex);
@interface CZWActionSheet : UIView

@property (nonatomic,copy) choose block;
@property (nonatomic,assign) BOOL telephone;

-(instancetype)initWithArray:(NSArray *)array;
-(void)choose:(choose)block;
-(void)show;


@end
