//
//  EditViewController.h
//  chezhiwang
//
//  Created by bangong on 15/11/5.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"

typedef void(^deleteImage)(NSInteger index);
/**
 *  查看大图
 */
@interface EditImageViewController : CZWBasicViewController

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) deleteImage block;

-(void)deleteImage:(deleteImage)block;

@end
