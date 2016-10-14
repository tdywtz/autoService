//
//  LHAssetPickerController.h
//  imagePicker
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 luhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LHAssetPickerController : UINavigationController

@property (nonatomic,assign) NSInteger maxNumber;

@property (nonatomic,copy) void(^getAsset)(NSArray *assetArray);

-(void)getAssetArray:(void(^)(NSArray *assetArray))block;
@end
