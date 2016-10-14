//
//  CZWCollectCell.m
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWCollectCell.h"

@implementation CZWCollectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.collectButotn.hidden = YES;
        self.iconImageView.userInteractionEnabled = NO;
        self.nameLabel.userInteractionEnabled = NO;
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureChange:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)gestureChange:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.block) {
            self.block(self);
        }
    }
}

-(void)gestureBlock:(myBlock)block{
    self.block = block;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
