//
//  LHCoreTextView.h
//  autoService
//
//  Created by bangong on 16/3/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCoreTextView : UIView

@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,assign) NSInteger numberOfLines;

-(void)sizeToFit;
@end
