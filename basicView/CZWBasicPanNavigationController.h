//
//  CZWBasicPanNavigationController.h
//  autoService
//
//  Created by luhai on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, ani) <#new#>;
@interface CZWBasicPanNavigationController : UINavigationController
{
    BOOL _changing;
}
@property(nonatomic, strong)UIView *alphaView;
//@property (nonatomic,assign) BOOL canDragBack;

-(void)setAlph;
-(void)bengingAlph;
-(void)endAlph;

@end
