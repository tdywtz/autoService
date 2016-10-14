//
//  CZWShowImageView.h
//  autoService
//
//  Created by bangong on 16/3/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 图片类别*/
@interface UIImage (Custom)

@property (nonatomic,copy) NSString *urlString;

@end

#pragma mark - ////////////////////////////////////////
@interface CZWShowImageView : UIView
/**图片数组*/
@property (nonatomic,strong) NSMutableArray<__kindof UIImage *> *imageArray;
/**运行选择最大照片数量*/
@property (nonatomic,assign) NSInteger maxNumber;
/**非layout时使用的自身高度*/
@property (nonatomic,assign) CGFloat height;
/**修改申诉是图片链接数组*/
@property (nonatomic,strong) NSArray<__kindof NSString *> *imageUrlArray;

/**非layout时frame改变回调*/
@property (nonatomic,copy) void(^updateFrame)(CGRect frame);
/**增加图片*/
@property (nonatomic,copy) void(^addImage)(UIImage *image);

/**构造方法*/
- (instancetype)initWithFrame:(CGRect)frame ViewController:(UIViewController *)ViewController;
- (instancetype)initWithWidth:(CGFloat)width ViewController:(UIViewController *)ViewController;


/**显示图片*/
-(void)showImage;


/**非layout时frame改变回调*/
-(void)updateFrame:(void(^)(CGRect frame))block;
/**增加图片*/
-(void)addImage:(void(^)(UIImage *image))block;

@end

