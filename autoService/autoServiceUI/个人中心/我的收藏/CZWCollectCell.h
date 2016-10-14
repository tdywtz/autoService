//
//  CZWCollectCell.h
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWRootTableViewCell.h"

@class CZWCollectCell;
typedef void(^myBlock)(CZWCollectCell *czwCell);

@interface CZWCollectCell : CZWRootTableViewCell


@property (nonatomic,copy) myBlock block;

-(void)gestureBlock:(myBlock)block;//长按手势

@end
