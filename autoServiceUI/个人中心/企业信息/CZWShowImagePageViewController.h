//
//  CZWShowImagePageViewController.h
//  autoService
//
//  Created by bangong on 16/7/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"

@interface CZWShowImagePageViewController : CZWBasicViewController

@property (nonatomic,strong) NSArray *imageUrlArray;//存放图片URL数组
@property (nonatomic,assign) NSInteger pageIndex;//展示第几张图

@end
