//
//  LHAssetViewCell.m
//  imagePicker
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 luhai. All rights reserved.
//

#import "LHAssetViewCell.h"
#import <Photos/Photos.h>

@implementation LHAssetViewCell
{
    UIImageView *_showImageView;
    UIButton *selectButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:frame];
    }
    return self;
}

-(void)createUI:(CGRect)frame{
     _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _showImageView.userInteractionEnabled = YES;
   // [picImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:_showImageView];
    
        selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectButton.frame = CGRectMake(frame.size.width-40, 0, 40, 40);
        [selectButton setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon"] forState:UIControlStateNormal];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigYIcon"] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.layer.cornerRadius = 20;
        selectButton.layer.masksToBounds = YES;
        [self.contentView addSubview:selectButton];
}


-(void)buttonClick:(UIButton *)btn{
       if (self.myBlock) {
            self.myBlock(self.asset,!btn.selected,self.num);
        }
}


-(void)getResult:(void (^)(ALAsset *, BOOL,NSInteger))block{
    self.myBlock = block;
}



-(void)isMax:(void (^)(ALAsset *,NSInteger))block{
    self.isMax = block;
}

-(void)setAsset:(ALAsset *)asset{
    if (_asset != asset) {
        _asset = nil;
        _asset = asset;
    }
   [_showImageView setContentMode:UIViewContentModeRedraw];
    UIImage *image = [UIImage imageWithCGImage: self.asset.aspectRatioThumbnail];
//    _showImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, 200, 200))];
   
    CGFloat width = image.size.width>image.size.height?image.size.height:image.size.width;
    _showImageView.image = [self getSubImage:image mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];

    selectButton.selected = self.isSelect;
}



- (UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
   
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
   // UIGraphicsEndImageContext();
   CGImageRelease(subImageRef);
    return smallImage;
}

@end
