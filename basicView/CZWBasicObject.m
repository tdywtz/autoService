//
//  CZWBasicObject.m
//  autoService
//
//  Created by bangong on 16/3/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicObject.h"
#import <objc/runtime.h>

@implementation CZWBasicObject
/**
 *  数据字典转换数据模型
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        NSArray *keys = [self getPropertyArray];
        for (NSString *key in keys) {
            
            if(dictionary[key]) [self setValue:dictionary[key] forKey:key];
        }
    }
    return self;
}


/**
 *  获取属性名数组
 */
-(NSArray *)getPropertyArray{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:[NSString defaultCStringEncoding]];
        
        if (propertyName) [array addObject:propertyName];
    
    }
    free(properties);
    return array;
}

/**
 *  将属性转换成字典
 */
-(NSDictionary *)getDcitonary{
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:[NSString defaultCStringEncoding]];
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

/**
 *  二进制数据转换字典
 *
 *  @param data 二进制数据
 *
 *  @return dictionary
 */
-(NSDictionary*)returnDictionaryWithData:(NSData *)data
{
    // NSData* data = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary* myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    //    NSLog(@"%@", myDictionary);
    
    return myDictionary;
}

/**
 *  字典转换二进制
 *
 *  @param dict 数据字典
 *
 *  @return data
 */
-(NSData*)returnDataWithDictionary:(NSDictionary*)dict
{
    NSMutableData* data = [[NSMutableData alloc]init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver  encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];
    
    return data;
}

@end
