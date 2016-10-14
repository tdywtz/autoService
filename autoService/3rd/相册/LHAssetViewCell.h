//
//  LHAssetViewCell.h
//  imagePicker
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 luhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LHAssetViewCell : UICollectionViewCell

@property (nonatomic,weak) ALAsset *asset;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger maxNum;

@property (nonatomic,copy) void(^myBlock)(ALAsset *result,BOOL add,NSInteger num);
@property (nonatomic,copy) void(^isMax)(ALAsset *iconAsset,NSInteger num);

-(void)getResult:(void(^)(ALAsset *result,BOOL add,NSInteger num))block;
-(void)isMax:(void(^)(ALAsset *iconAsset,NSInteger num))block;
@end
