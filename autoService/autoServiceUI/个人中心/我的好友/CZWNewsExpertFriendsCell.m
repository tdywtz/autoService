//
//  CZWNewsExpertFriendsCell.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWNewsExpertFriendsCell.h"
#import "StarView.h"

@implementation CZWNewsExpertFriendsCell
{
    UIImageView *iconImageView;
    UILabel     *nameLabel;
    StarView    *starIamgeView;
    UILabel     *finishNumberLabel;
    UIButton    *agreementBtn;
    UILabel     *messageLabel;
    
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
    iconImageView.layer.cornerRadius = 25;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"expertIconDefaultImage"];
    [self.contentView addSubview:iconImageView];
    
    leftSpace = iconImageView.frame.origin.x+iconImageView.frame.size.width+10;
    nameLabel = [LHController createLabelWithFrame:CGRectMake(leftSpace, 10, 160, 20) Font:textFont Bold:NO TextColor:colorNavigationBarColor Text:nil];
    [self.contentView addSubview:nameLabel];
    
    starIamgeView = [[StarView alloc] initWithFrame:CGRectMake(leftSpace, nameLabel.frame.origin.y+nameLabel.frame.size.height, 80, 20)];
    [self.contentView addSubview:starIamgeView];
    
    finishNumberLabel = [LHController createLabelWithFrame:CGRectMake(leftSpace+starIamgeView.frame.size.width+10, starIamgeView.frame.origin.y, WIDTH-leftSpace-starIamgeView.frame.size.width-105, 20) Font:textFont-4 Bold:NO TextColor:colorLightGray Text:nil];
    [self.contentView addSubview:finishNumberLabel];
    
    agreementBtn = [LHController createButtnFram:CGRectMake(WIDTH-55, finishNumberLabel.frame.origin.y, 40, 20) Target:self Action:@selector(btnClick:) Text:@"同意"];
    [agreementBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [agreementBtn setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [self.contentView addSubview:agreementBtn];
    

    messageLabel = [LHController createLabelFont:textFont-2 Text:nil Number:1 TextColor:colorLightGray];
    [self.contentView addSubview:messageLabel];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(50, 50));
    }];

    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(10);
    }];
    
    [starIamgeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom).offset(-3);
        make.size.equalTo(CGSizeMake(75, 23));
    }];
    
    [finishNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starIamgeView.right).offset(10);
        make.centerY.equalTo(starIamgeView);
    }];
    
    [agreementBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(finishNumberLabel);
    }];
    
    [messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.right.equalTo(agreementBtn);
        make.top.equalTo(starIamgeView.bottom);
    }];
}

-(void)setModel:(CZWNewFriendsModel *)model{
    if (_model == model) {
        return;
    }
    _model = model;
    
    nameLabel.attributedText = [NSAttributedString expertName:_model.userInfo.userName];
    finishNumberLabel.attributedText = [self attributeSize:[NSString stringWithFormat:@"已解决%@单",_model.userInfo.complete_num]];
   
    [starIamgeView setStar:[_model.userInfo.score floatValue]];
    
    if ([model.operation isEqualToString:@"添加好友"]) {
        agreementBtn.hidden = NO;
        if (_model.content.length) {
            messageLabel.text = _model.content;
        }else{
            messageLabel.text = [NSString stringWithFormat:@"来自[%@]的好友请求",_model.userInfo.userName];
        }
        if (model.receivedStatus == ReceivedStatus_UNREAD) {
            [agreementBtn setTitle:@"同意" forState:UIControlStateNormal];
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
        self.block(btn.titleLabel.text,self.model);
    }
}

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

-(void)clickButton:(void (^)(NSString * ,CZWNewFriendsModel *))block{
    self.block = block;
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
