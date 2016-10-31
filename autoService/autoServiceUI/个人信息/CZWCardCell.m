//
//  CZWExpertCardCell.m
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWCardCell.h"

@implementation CZWCardCell
{
    UILabel *backgroundLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    self.leftLabel = [LHController createLabelWithFrame:CGRectMake(15, 0, 80, 44) Font:[LHController setFont]-2 Bold:NO TextColor:colorBlack Text:nil];
    [self.contentView addSubview:self.leftLabel];
    
    self.rightLabel = [LHController createLabelWithFrame:CGRectMake(self.leftLabel.frame.size.width+15, 0, WIDTH-self.leftLabel.frame.size.width-45, 44) Font:[LHController setFont]-2 Bold:NO TextColor:colorBlack Text:nil];
    self.rightLabel.numberOfLines = 1;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    
    backgroundLabel = [LHController createLabelWithFrame:self.rightLabel.bounds Font:[LHController setFont]-2 Bold:NO TextColor:colorLightGray Text:nil];
    backgroundLabel.textAlignment = NSTextAlignmentRight;
    backgroundLabel.numberOfLines = 1;
    [self.rightLabel addSubview:backgroundLabel];
}

-(void)setRightText:(NSString *)rightText{
    _rightText = rightText;
    self.rightLabel.text = _rightText;
    if (_rightText.length == 0) {
        backgroundLabel.hidden = NO;
    }else{
        backgroundLabel.hidden = YES;
    }
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    backgroundLabel.text = placeholder;
}

- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
