//
//  CZWNewsUserFriendsCell.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWNewsUserFriendsCell.h"
#import "CZWDrawRectView.h"

@implementation CZWNewsUserFriendsCell
{
    UIImageView *iconImageView;
    UILabel *nameLabel;
    UILabel *messageLabel;
    UIButton *agreementBtn;
    //UIButton *overlookBtn;
    
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
    iconImageView.layer.cornerRadius = 2;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"userIconDefaultImage"];
    [self.contentView addSubview:iconImageView];
    
    nameLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorOrangeRed Text:nil];
    [self.contentView addSubview:nameLabel];
    
    
    messageLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    [self.contentView addSubview:messageLabel];
    
    agreementBtn = [LHController createButtnFram:CGRectZero Target:self Action:@selector(btnClick:) Text:@" 同意 "];
    [agreementBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [agreementBtn setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [self.contentView addSubview:agreementBtn];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView);
        make.left.equalTo(iconImageView.right).offset(10);
        make.size.equalTo(CGSizeMake(200, 20));
    }];
    
    [messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(iconImageView);
        make.right.lessThanOrEqualTo(-15);
        make.height.equalTo(20);
    }];
    
    [agreementBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(-15);
        make.height.equalTo(20);
    }];
}

-(void)setModel:(CZWNewFriendsModel *)model{
    if (_model == model) {
        return;
    }
    _model = model;
    
    nameLabel.text = _model.userInfo.userName;
    
    if ([model.operation isEqualToString:@"添加好友"]) {
        agreementBtn.hidden = NO;
        if (_model.content.length) {
            messageLabel.text = _model.content;
        }else{
            messageLabel.text = [NSString stringWithFormat:@"来自[%@]的好友请求",_model.userInfo.userName];
        }
        if (model.receivedStatus == ReceivedStatus_UNREAD) {
            [agreementBtn setTitle:@" 同意 " forState:UIControlStateNormal];
            agreementBtn.enabled = YES;
            [agreementBtn setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
        }else {
            [agreementBtn setTitle:@"已添加" forState:UIControlStateNormal];
            agreementBtn.enabled = NO;
            [agreementBtn setTitleColor:colorLightGray forState:UIControlStateNormal];
        }
    }else{
         agreementBtn.hidden = YES;
         messageLabel.text = @"我同意了你的好友请求，现在我们成为好友了";
    }
    
  
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
    
}

-(void)btnClick:(UIButton *)btn{
  
    if (self.block) {
        self.block(@"同意",self.model);
    }
}

-(void)clickButton:(void (^)(NSString * ,CZWNewFriendsModel *))block{
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
