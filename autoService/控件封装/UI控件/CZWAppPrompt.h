//
//  CZWAppPrompt.h
//  autoService
//
//  Created by bangong on 16/4/7.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

/**弹出框类型*/
typedef NS_ENUM(NSInteger,AppPromptStyle) {
    /**评分*/
    AppPromptStyleScore,
    /**更新*/
    AppPromptStyleUpdate
};

@interface CZWAppPrompt : NSObject

/**应用ID*/
@property (nonatomic,copy) NSString *appId;

+ (CZWAppPrompt *)sharedInstance;

/**
 *  开始弹出提示框
 *
 *  @param style 评论还是更新
 */
-(void)shouAlert:(AppPromptStyle)style;
@end
