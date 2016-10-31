//
//  CZWExpertUserAnswerCell.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertUserAnswerCell.h"

@implementation CZWExpertUserAnswerCell
{
    /**头像*/
    UIImageView *iconImageView;
    UIImageView *newImageView;
    /**名*/
    UILabel *nameLabel;
    UIButton *telephoneButton;
    //
    UILabel *brandSeriesLabel;
     /**车型*/
    UILabel *modelLabel;
     /**内容*/
    UILabel *commentLabel;
     /**标题*/
    UILabel *titleLabel;
     /**时间*/
    UILabel *dateLabel;
     /**地区*/
    UILabel *areaLabel;
    
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
    iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = 2;
    iconImageView.layer.masksToBounds = YES;
   
    newImageView = [LHController createImageViewWithFrame:CGRectZero ImageName:@"auto_replyNewReply"];

    nameLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorOrangeRed Text:nil];
    
    telephoneButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(telephoneClick) Text:nil];
    [telephoneButton setImage:[UIImage imageNamed:@"auto_telephoneImage"] forState:UIControlStateNormal];

    
    titleLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-3 Bold:NO TextColor:colorBlack Text:@""];
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;

    brandSeriesLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-3 Bold:NO TextColor:colorLightGray Text:nil];

    modelLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-3 Bold:NO TextColor:colorLightGray Text:nil];
   
    commentLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorBlack Text:nil];
    
    dateLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
   
    areaLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    areaLabel.textAlignment = NSTextAlignmentRight;
  
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:newImageView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:telephoneButton];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:brandSeriesLabel];
    [self.contentView addSubview:modelLabel];
    [self.contentView addSubview:commentLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:areaLabel];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(55, 55));
        
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
    
    [telephoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView);
        make.left.equalTo(nameLabel.right).offset(10);
        make.size.equalTo(CGSizeMake(20, 20));
    }];

    [brandSeriesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.centerY.equalTo(iconImageView).offset(1);
    }];

    [modelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconImageView);
        make.left.equalTo(nameLabel);
        make.height.equalTo(20);
        make.right.equalTo(titleLabel.left).offset(-5);
    }];

    [commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(modelLabel.bottom).offset(5);
        make.left.equalTo(nameLabel);
        make.right.equalTo(-leftSpace);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentLabel.bottom).equalTo(8);
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
        make.left.equalTo(dateLabel.right).offset(5);
    }];

}

-(void)telephoneClick{
    if (self.block) {
        self.block(_model.mobile,_model.uname);
    }
}


-(void)setModel:(CZWReplyModel *)model{
    if (_model != model) {
        _model = model;
        
        nameLabel.text    = model.uname;
        modelLabel.text   = model.modelName;
        commentLabel.text = model.content;
        titleLabel.text   = model.title;
        dateLabel.text    = model.date;
        areaLabel.text    = model.city;
        brandSeriesLabel.text = [NSString stringWithFormat:@"%@   %@",model.brandname,model.seriesname];
        modelLabel.text   = model.modelName;
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
     
        if ([model.isshow boolValue]) {
            newImageView.hidden = YES;
        }else{
            newImageView.hidden = NO;
        }
        if ([model.mobile length]) {
            telephoneButton.hidden = NO;
        }else{
            telephoneButton.hidden = YES;
        }
    }
}

-(void)callDivert:(telephone)block{
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
