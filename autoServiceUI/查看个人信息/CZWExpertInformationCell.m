//
//  CZWExpertInformationCell.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertInformationCell.h"
#import "StarView.h"

@interface CZWExpertInformationCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *userStateLabel;
@property (nonatomic,strong) UILabel *fromName;
@property (nonatomic,strong) StarView *starView;
/**用户评论内容*/
@property (nonatomic,strong) UILabel *commentLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *cityLabel;

@end

@implementation CZWExpertInformationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setUI];
    }
    return  self;
}


-(void)setUI{
    
    UIView *line      = [LHController createBackLineWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    self.titleLabel = [LHController createLabelFont:15 Text:nil Number:1 TextColor:colorBlack];
    self.userStateLabel = [LHController createLabelFont:12 Text:nil Number:1 TextColor:nil];
    self.userStateLabel.textAlignment = NSTextAlignmentCenter;
    self.userStateLabel.layer.cornerRadius = 2;
    self.userStateLabel.layer.masksToBounds = YES;
    self.userStateLabel.layer.borderWidth = 0.5;
    
    self.fromName = [LHController createLabelFont:14 Text:nil Number:0 TextColor:colorDeepGray];
    self.starView          = [[StarView alloc] initWithFrame:CGRectZero];
    self.commentLabel     = [LHController createLabelWithFrame:CGRectZero Font:13 Bold:NO TextColor:colorLightGray Text:nil];
    self.dateLabel = [LHController createLabelFont:12 Text:nil Number:1 TextColor:colorLightGray];
    self.cityLabel = [LHController createLabelFont:12 Text:nil Number:1 TextColor:colorLightGray];
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.userStateLabel];
    [self.contentView addSubview:self.fromName];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.cityLabel];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(0);
        make.height.equalTo(10);
    }];
    
    [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).with.offset(10);
        make.left.equalTo(15);
        make.right.lessThanOrEqualTo(self.userStateLabel.left);
    }];
    
    
    [self.userStateLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(self.titleLabel);
        make.height.equalTo(18);
    }];
    
   
    [self.fromName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
    }];
    
    [self.starView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fromName.right);
        make.centerY.equalTo(self.fromName);
        make.size.equalTo(CGSizeMake(75, 23));
    }];
    
    self.commentLabel.preferredMaxLayoutWidth = WIDTH-30;
    [self.commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.fromName.bottom).offset(8);
        make.width.equalTo(WIDTH-30);
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.commentLabel.bottom).offset(5);
        make.bottom.equalTo(-10);
    }];
    
    [self.cityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userStateLabel);
        make.bottom.equalTo(self.dateLabel);
    }];
}

-(void)setModel:(CZWAppealModel *)model{
    
    _model = model;
    
    
    self.titleLabel.text = _model.title;
    self.userStateLabel.text = _model.steps;//_model.steps;
    self.fromName.attributedText = [self fromName:_model.name];
 
    [self.starView setStar:[_model.score floatValue]];
    self.commentLabel.attributedText = [self comment:_model.comment];
    self.dateLabel.text = _model.date;
    self.cityLabel.text = _model.cname;
    
 
    CGFloat width = [_model.steps calculateTextSizeWithFont:self.userStateLabel.font Size:CGSizeMake(100, 18)].width;
    [self.userStateLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width+6);
    }];
    

    [self setStateLabelSate];
}

-(void)setStateLabelSate{
    if ([_model.steps isEqualToString:@"厂家受理"]) {
        
        self.userStateLabel.textColor = colorYellow;
        
    }else if ([_model.steps isEqualToString:@"咨询专家"]){
        
        self.userStateLabel.textColor = colorOrangeRed;
    }else if ([_model.steps isEqualToString:@"未完成"]){
        
        self.userStateLabel.textColor = colorNavigationBarColor;
    }else if ([_model.steps isEqualToString:@"已完成"]){
        
        self.userStateLabel.textColor = RGB_color(82, 187, 77, 1);
    }
    else if ([_model.steps isEqualToString:@"未采纳专家建议"]) {
        
        self.userStateLabel.textColor = colorYellow;
    }else if([_model.steps isEqualToString:@"已采纳专家建议"]){
        
        self.userStateLabel.textColor = colorNavigationBarColor;
    }else if ([self.model.steps isEqualToString:@"网站审核"]) {
        
        self.userStateLabel.textColor = RGB_color(100, 198, 255, 1);
    }else{
        self.userStateLabel.textColor = colorBlack;
    }
    self.userStateLabel.layer.borderColor = self.userStateLabel.textColor.CGColor;
}


-(NSAttributedString *)fromName:(NSString *)name{
    NSString *text = [NSString stringWithFormat:@"%@的评价：",name];
    NSRange range = [text rangeOfString:name];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    [att addAttribute:NSForegroundColorAttributeName value:colorYellow range:range];
    return att;
}

-(NSAttributedString *)comment:(NSString *)comment{
   
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    parag.lineSpacing = 4;
    [att addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, att.length)];
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
