//
//  EditCell.m
//  chezhiwang
//
//  Created by bangong on 15/11/5.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "EditImageCell.h"

@implementation EditImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        //imageView.backgroundColor = [UIColor whiteColor];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_imageView];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo((UIEdgeInsetsMake(5, 5, 5, 5)));
        }];
    }

    return self;
}

-(void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = nil;
        _image = image;
    }
    _imageView.image = _image;
}

@end
