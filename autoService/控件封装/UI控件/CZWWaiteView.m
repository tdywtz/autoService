//
//  CZWWaiteView.m
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWWaiteView.h"

@interface CZWWaiteView ()

@property (nonatomic , weak) UIImageView *imageView;
@property (nonatomic , weak) CAReplicatorLayer *replicatorLayer;

@end

@implementation CZWWaiteView

- (void)dealloc
{
    NSLog(@"deal");
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0, 0, 160, 100);
      
        [self addImageView];
        [self addReplicatorLayer];
       
    }
    return self;
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView = imageView;
}

- (void)addReplicatorLayer {
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    
    replicatorLayer.bounds = self.bounds;
    replicatorLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    replicatorLayer.preservesDepth = YES;
    
//    
//        replicatorLayer.instanceColor = [UIColor whiteColor].CGColor;
//        replicatorLayer.instanceRedOffset = 0.1;
//        replicatorLayer.instanceGreenOffset = 0.1;
//        replicatorLayer.instanceBlueOffset = 0.1;
//        replicatorLayer.instanceAlphaOffset = 0.1;
    
    [replicatorLayer addSublayer:_imageView.layer];
    [self.layer addSublayer:replicatorLayer];
    _replicatorLayer = replicatorLayer;
    
    //    [self animation3];
    
}

-(void)setImageAnima{
    _imageView.frame = CGRectMake(17.2, 20.0, 20, 20);
    
    _imageView.backgroundColor = colorLineGray;
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    
    CGFloat count = 15.0;
    _replicatorLayer.instanceDelay = 1.0 / count;
    _replicatorLayer.instanceCount = count;
    //相对于_replicatorLayer.position旋转
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / count, 0, 0, 1.0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    //    animation.autoreverses = YES;
    //从原大小变小时,动画 回到原状时不要动画
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [_imageView.layer addAnimation:animation forKey:nil];
}


-(void)startAnima{
    SEL method = NSSelectorFromString(@"setImageAnima");
    [self performSelector:method withObject:self];
}

-(void)stopAnima{
   [UIView animateWithDuration:1.0 animations:^{
       self.alpha = 0.0;
   } completion:^(BOOL finished) {
        [self removeFromSuperview];
   }];
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
   
    self.center = newSuperview.center;
}

@end
