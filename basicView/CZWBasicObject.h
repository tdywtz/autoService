//
//  CZWBasicObject.h
//  autoService
//
//  Created by bangong on 16/3/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZWBasicObject : NSObject
/**
 *  数据字典转换数据模型
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  获取属性名数组
 */
-(NSArray *)getPropertyArray;

/**
 *  将属性转换成字典
 */
-(NSDictionary *)getDcitonary;
@end
