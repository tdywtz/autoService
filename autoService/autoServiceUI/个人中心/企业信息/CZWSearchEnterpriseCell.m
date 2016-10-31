


//
//  CZWSearchEnterpriseCell.m
//  autoService
//
//  Created by bangong on 16/8/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWSearchEnterpriseCell.h"

@implementation CZWSearchEnterpriseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = colorBlack;

        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_titleLabel];

        [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(60, 50));
        }];

        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.right).offset(15);
            make.centerY.equalTo(0);
        }];

    }

    return self;
}
- (void)awakeFromNib {
     [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
