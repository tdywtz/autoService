//
//  LHPickerView.h
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LHpickerStyleName,
    LHpickerStyleAbbreviation,//简称
    LHpickerStyleSex//性别
}LHpickerStyle;

typedef void(^returnResult)(NSString *title, NSString *ID);
@interface LHPickerView : UIView

@property (nonatomic,copy) returnResult block;

-(void)returnResult:(returnResult)block;
-(void)showPickerView;
-(void)dismissView;

- (instancetype)initWithStyle:(LHpickerStyle)style;
@end
