//
//  CZWMyFriendsExpertCell.m
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWMyFriendsExpertCell.h"
#import "StarView.h"

@implementation CZWMyFriendsExpertCell
{
    UIImageView *iconImageView;
    UILabel     *nameLabel;
    StarView *starIamgeView;
    UILabel     *finishNumberLabel;
    UILabel     *areaLabel;
    
    CGFloat textFont;
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
    iconImageView.layer.cornerRadius = 22.5;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"expertIconDefaultImage"];
    [self.contentView addSubview:iconImageView];
  
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    
    nameLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorNavigationBarColor Text:nil];
    starIamgeView = [[StarView alloc] initWithFrame:CGRectZero];
    finishNumberLabel = [LHController createLabelFont:textFont-4 Text:nil Number:1 TextColor:colorLightGray ];
    areaLabel = [LHController createLabelFont:textFont-2 Text:nil Number:1 TextColor:colorLightGray ];
    
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:starIamgeView];
    [self.contentView addSubview:finishNumberLabel];
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
   
    
    [starIamgeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom).offset(3);
        make.size.equalTo(CGSizeMake(75, 23));
    }];
    
    [finishNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starIamgeView.right).offset(10);
        make.centerY.equalTo(starIamgeView);
        make.right.lessThanOrEqualTo(areaLabel.left);
    }];
    
    [areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(nameLabel);
        make.width.lessThanOrEqualTo(100);
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

  //  iconImageView.image = userInfo.image;

    [iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
    [starIamgeView setStar:[userInfo.score floatValue]];
    finishNumberLabel.attributedText = [self attributeSize:[NSString stringWithFormat:@"已解决%@单",userInfo.complete_num]];
    areaLabel.text = userInfo.area;
    nameLabel.attributedText = [NSAttributedString expertName:userInfo.userName];
}

//-(void)callDivert:(telephone)block{
//    self.block = block;
//}

#pragma mark - 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    // [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:B] range:NSMakeRange(0, att.length)];
    for (int i = 0; i < str.length; i ++) {
        unichar C = [str characterAtIndex:i];
        if (isnumber(C)) {
            [att addAttribute:NSForegroundColorAttributeName value:colorNavigationBarColor range:NSMakeRange(i, 1)];
        }
    }
    return att;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
