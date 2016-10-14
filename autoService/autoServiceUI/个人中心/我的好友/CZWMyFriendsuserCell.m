//
//  CZWMyFriendsuserCell.m
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWMyFriendsuserCell.h"

@implementation CZWMyFriendsuserCell
{
    UIImageView *iconImageView;
    UILabel *nameLabel;
    UILabel *modelLabel;
    UILabel *areaLabel;
    
    CGFloat textFont;
    CGFloat leftSpace;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        textFont = [LHController setFont]-2;
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImageView.layer.cornerRadius = 3;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"userIconDefaultImage"];
    [self.contentView addSubview:iconImageView];
    
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    
    leftSpace = iconImageView.frame.origin.x+iconImageView.frame.size.width+10;
    nameLabel = [LHController createLabelWithFrame:CGRectMake(leftSpace, 10, WIDTH-leftSpace-110, 20) Font:textFont Bold:NO TextColor:colorOrangeRed Text:nil];
    [self.contentView addSubview:nameLabel];
    
    
    modelLabel = [LHController createLabelWithFrame:CGRectMake(leftSpace, nameLabel.frame.origin.y+nameLabel.frame.size.height, WIDTH-leftSpace-15, 20) Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    [self.contentView addSubview:modelLabel];
    
    areaLabel = [LHController createLabelWithFrame:CGRectMake(WIDTH-105, nameLabel.frame.origin.y, 90, 20) Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    areaLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:areaLabel];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(45, 45));
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(iconImageView);
        make.height.equalTo(20);
    }];
    
    [modelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(iconImageView);
        make.height.equalTo(20);
    }];
    
    [areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(nameLabel);
        make.left.lessThanOrEqualTo(nameLabel.right);
    }];
}

//头像手势
-(void)tapClick{
    if (self.clickImage) {
        self.clickImage(self.userInfo.seviceId,self.userInfo.userId);
    }
}

-(void)clickImage:(void (^)(NSString * , NSString *))block{
    self.clickImage = block;
}

-(void)setUserInfo:(CZWChatUserInfo *)userInfo{
    if (_userInfo == userInfo) {
        return;
    }
    _userInfo = userInfo;
    nameLabel.text = _userInfo.userName;
    modelLabel.text = _userInfo.modelName;
    areaLabel.text = _userInfo.area;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
}

@end
