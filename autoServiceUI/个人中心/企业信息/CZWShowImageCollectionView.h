//
//  CZWShowImageCollectionView.h
//  autoService
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZWShowImageCollectionView : UICollectionView

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,assign) CGSize cellSize;
@property (nonatomic,assign) UIEdgeInsets cellInsets;
@property (nonatomic,strong) NSArray *dataArray;

+ (instancetype)initWithFrame:(CGRect)frame;

@end
