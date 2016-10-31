//
//  CZWUserExpertAnswerCell.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserExpertAnswerCell.h"
#import "StarView.h"

@implementation CZWUserExpertAnswerCell
{
    UIImageView *iconImageView;
    UIImageView *newImageView;
    UILabel     *nameLabel;
    StarView *starIamgeView;
    UILabel     *finishNumberLabel;
    UILabel     *commentLabel;
    UILabel     *titleLabel;
    UILabel     *dateLabel;
    UILabel     *areaLabel;
    
    CGFloat textFont;
    CGFloat leftSpace;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        textFont = [LHController setFont]-2;
        leftSpace = 15;
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    iconImageView     = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = 20;
    iconImageView.layer.masksToBounds = YES;
   
    newImageView      = [LHController createImageViewWithFrame:CGRectZero ImageName:@"auto_replyNewReply"];
   
    nameLabel         = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorNavigationBarColor Text:nil];
   
    titleLabel        = [LHController createLabelWithFrame:CGRectZero Font:textFont-3 Bold:NO TextColor:colorBlack Text:nil];
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
   
    starIamgeView     = [[StarView alloc] initWithFrame:CGRectZero];
   
    finishNumberLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-4 Bold:NO TextColor:colorLightGray Text:nil];
    
    commentLabel      = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorBlack Text:nil];
    
    dateLabel         = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
   
    areaLabel         = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    areaLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:newImageView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:starIamgeView];
    [self.contentView addSubview:finishNumberLabel];
    [self.contentView addSubview:commentLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:areaLabel];

    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(40, 40));
        
    }];
    
    [newImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(5);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView);
        make.left.equalTo(iconImageView.right).with.offset(10);
        make.right.lessThanOrEqualTo(titleLabel.left).offset(-20);
        make.height.equalTo(20);
    }];
    
    [starIamgeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.bottom);
        make.left.equalTo(nameLabel);
        make.size.equalTo(CGSizeMake(75, 23));
    }];
    
    [finishNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starIamgeView);
        make.left.equalTo(starIamgeView.right).with.offset(10);
    }];
    
    [commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starIamgeView.bottom).with.offset(5);
        make.left.equalTo(nameLabel);
        make.right.equalTo(-leftSpace);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentLabel.bottom).with.equalTo(8);
        make.left.equalTo(nameLabel);
    }];

    titleLabel.preferredMaxLayoutWidth = 85;
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView);
        make.right.equalTo(-leftSpace);
        make.size.lessThanOrEqualTo(CGSizeMake(85, 55));
  
    }];
   
    [areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel);
        make.right.equalTo(-leftSpace);
        make.left.equalTo(dateLabel.right).with.offset(5);
    }];
}

-(void)telephoneClick{
    if (self.block) {
        self.block(@"465",@"101");
    }
}

-(void)setModel:(CZWReplyModel *)model{
 
    if (_model != model) {
        _model = model;
        nameLabel.attributedText = [NSAttributedString expertName:model.uname];
        finishNumberLabel.attributedText = [self attributeSize:[NSString stringWithFormat:@"已解决%@单",model.complete_num]];
        commentLabel.text = model.content;
        titleLabel.text = model.title;
        dateLabel.text = model.date;
        areaLabel.text = model.city;
        [starIamgeView setStar:[model.score floatValue]];
        
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
        
        if ([model.isshow boolValue]) {
            newImageView.hidden = YES;
        }else{
            newImageView.hidden = NO;
        }
    }
}

-(void)callDivert:(telephone)block{
    self.block = block;
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

- (void)awakeFromNib {
     [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
