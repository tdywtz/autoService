//
//  CZWInformationTableViewCell.m
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserInformationCell.h"

@interface CZWUserInformationCell ()

@end

@implementation CZWUserInformationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.iconImageView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.brandSeriesLabel.hidden = YES;
        [self.cityLabel removeFromSuperview];
        [self setUI];
    }
    return  self;
}

-(void)setUI{
   
    UIView *line = [LHController createBackLineWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    [self.contentView addSubview:line];
    self.modelLabel.numberOfLines = 1;
//    [self.brandSeriesLabel remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftSpace);
//        make.top.equalTo(20);
//        make.right.lessThanOrEqualTo(self.userStateLabel.left);
//    }];

    [self.modelLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftSpace);
        make.top.equalTo(20);
    }];
    
    [self.titelLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.modelLabel);
        make.top.equalTo(self.modelLabel.bottom).with.offset(5);
        make.right.equalTo(-self.leftSpace);
        make.height.equalTo(20);
    }];


    [self.userStateLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.right.equalTo(-self.leftSpace);
    }];
}

- (CGFloat)viewHeight{


     CGFloat height = 20+5+(self.brandSeriesLabel.font.pointSize+2)+5+20;
    if (self.model.image.length>0) {
        height += (5+(WIDTH-self.leftSpace*2-10)/3*factor_width*6.5/11);
    }
    if (!self.applearNumberLabel.hidden) {
        height += (20);
    }
    height += 20+10;

    return height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
