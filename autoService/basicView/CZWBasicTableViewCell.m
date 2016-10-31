//
//  CZWBasicTableViewCell.m
//  autoService
//
//  Created by bangong on 16/1/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicTableViewCell.h"

@implementation CZWBasicTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _drawLine = YES;
    }
    
    return self;
}


-(void)setDrawLine:(BOOL)drawLine{
    if (_drawLine != drawLine) {
         _drawLine = drawLine;
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    if (_drawLine) {
        [self drawUI:rect];
    }
}

-(void)drawUI:(CGRect)rect{
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条底部线
    CGContextSetRGBStrokeColor(context, 220/255.0,  220/255.0, 220/255.0, 1);//线条颜色
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.bounds =CGRectMake(0,0,44,44);
    
    self.imageView.frame = CGRectMake(0,0,44,44);
    
    self.imageView.contentMode = UIViewContentModeCenter;
    

    
    CGRect tmpFrame = self.textLabel.frame;
    
    tmpFrame.origin.x = 46;
    
    self.textLabel.frame = tmpFrame;
    
   // self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = colorBlack;
    
    tmpFrame = self.detailTextLabel.frame;
    
    tmpFrame.origin.x = 46;
    
    self.detailTextLabel.frame = tmpFrame;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
