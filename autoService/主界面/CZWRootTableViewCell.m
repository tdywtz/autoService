//
//  CZWRootTableViewCell.m
//  autoService
//
//  Created by luhai on 15/11/29.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWRootTableViewCell.h"

@interface CZWRootTableViewCell ()

@end

@implementation CZWRootTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftSpace = 15;
        self.textFont  = [LHController setFont]-2;
        [self makeUI];
    }
   
    return self;
}

-(void)makeUI{
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.cornerRadius     = 4;
    self.iconImageView.layer.masksToBounds    = YES;
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.iconImageView addGestureRecognizer:iconTap];
    
    self.nameLabel         = [LHController createLabelWithFrame:CGRectZero Font:self.textFont Bold:NO TextColor:RGB_color(254, 115, 22, 1) Text:nil];
    self.nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *nameLableTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.nameLabel addGestureRecognizer:nameLableTap];

    self.brandSeriesLabel  = [LHController createLabelWithFrame:CGRectZero Font:self.textFont-3 Bold:NO TextColor:colorLightGray Text:nil];
    self.brandSeriesLabel.numberOfLines = 1;

    self.modelLabel        = [LHController createLabelWithFrame:CGRectZero Font:self.textFont-3 Bold:NO TextColor:colorLightGray Text:nil];
    self.modelLabel.numberOfLines = 1;
   
    self.userStateLabel    = [[UILabel alloc] initWithFrame:CGRectZero];
    self.userStateLabel.font          = [UIFont systemFontOfSize:self.textFont-3];
    self.userStateLabel.textAlignment = NSTextAlignmentCenter;
    self.userStateLabel.layer.cornerRadius = 2;
    self.userStateLabel.layer.borderWidth = 0.5;
    
    self.cityLabel         = [LHController createLabelWithFrame:CGRectZero Font:self.textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    
    self.titelLabel        = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(21) Bold:NO TextColor:colorBlack Text:nil];

    self.imageView1        = [[UIImageView alloc] init];
    self.imageView2        = [[UIImageView alloc] init];
    self.imageView3        = [[UIImageView alloc] init];
    
    self.timeLabel         = [LHController createLabelWithFrame:CGRectZero Font:self.textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
   
    self.collectButotn     = [LHController createButtnFram:CGRectZero Target:self Action:@selector(collectClick:) Text:@"收藏"];
    [self.collectButotn setImage:[UIImage imageNamed:@"auto_collectNormal"] forState:UIControlStateNormal];
    [self.collectButotn setImage:[UIImage imageNamed:@"auto_collectSelected"] forState:UIControlStateSelected];
    self.collectButotn.titleLabel.font = [UIFont systemFontOfSize:self.textFont-2];
    [self.collectButotn setTitleColor:RGB_color(1, 184, 198, 1) forState:UIControlStateNormal];
    [self.collectButotn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    
    self.applearNumberLabel = [LHController createLabelWithFrame:CGRectZero Font:self.textFont-2 Bold:NO TextColor:colorDeepGray Text:nil];

//    [CZWManager asynchronouslySetFontName:@"STXingkai-SC-Bold" success:^(NSString *name) {
//        self.nameLabel.font = [UIFont fontWithName:name size:18];
//    }];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.brandSeriesLabel];
    [self.contentView addSubview:self.modelLabel];
    [self.contentView addSubview:self.userStateLabel];
    [self.contentView addSubview:self.cityLabel];
    [self.contentView addSubview:self.titelLabel];

    [self.contentView addSubview:self.imageView1];
    [self.contentView addSubview:self.imageView2];
    [self.contentView addSubview:self.imageView3];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.collectButotn];
    [self.contentView addSubview:self.applearNumberLabel];
  
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftSpace);
        make.top.equalTo(15);
        make.size.equalTo(CGSizeMake(55, 55));
        
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.top.equalTo(15);
        make.right.lessThanOrEqualTo(self.userStateLabel.left);
    }];
    
    [self.userStateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView.right).with.offset(-self.leftSpace);
        make.size.equalTo(CGSizeMake(60, 18));
    }];
    
    [self.cityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelLabel);
        make.right.equalTo(self.userStateLabel);
         //make.left.greaterThanOrEqualTo(80);
        make.height.equalTo(18);
    }];
    

    [self.brandSeriesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.centerY.equalTo(self.iconImageView).offset(1);
        make.right.lessThanOrEqualTo(self.cityLabel.left).offset(-5);
    }];

    [self.modelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.iconImageView);
        make.right.lessThanOrEqualTo(self.cityLabel.left).offset(-5);
    }];

    [self.titelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.top.equalTo(self.iconImageView.bottom).with.offset(5);
        make.right.equalTo(-self.leftSpace);
        make.height.equalTo(20);
    }];
    
    CGFloat width = (WIDTH-self.leftSpace*2-10)/3*factor_width;
    [self.imageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLabel);
        make.top.equalTo(self.titelLabel.bottom).with.offset(5);
        make.size.equalTo(CGSizeMake(width, width*(6.5/11.0)));
    }];
    
    
    [self.imageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView1.right).with.offset(5);
        make.top.equalTo(self.imageView1.top);
        make.size.equalTo(self.imageView1);
    }];
    [self.imageView3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView2.right).with.offset(5);
        make.top.equalTo(self.imageView2.top);
        make.size.equalTo(self.imageView2);
    }];
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.top.equalTo(self.imageView1.bottom).with.offset(5);
        make.size.equalTo(CGSizeMake(200, 20));
    }];
    
    [self.collectButotn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userStateLabel);
        make.top.equalTo(self.applearNumberLabel);
       
    }];

    [self.applearNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.top.equalTo(self.timeLabel.bottom).offset(2);
    }];
    
}
/**
 *  点击头像和用户名响应方法
 */
-(void)tapClick{
    if (self.informationBlock) {
        self.informationBlock(self.model);
    }
}

-(void)collectClick:(UIButton *)button{
    button.selected = !button.selected;
    if (self.collectBlock) {
        self.collectBlock(self.model, button);
    }
   
    if (button.selected) {
        [[CZWFmdbManager manager] insertIntoCollect:_model.cpid];
    }else{
        [[CZWFmdbManager manager] deleteFromCollectWith:_model.cpid];
    }
}

//个人信息
-(void)individualInformation:(information)block{
 
        self.informationBlock = block;
}
/**收藏*/
-(void)oneselfcollect:(collect)block{
    self.collectBlock = block;
}


-(void)setModel:(CZWAppealModel *)model{

    _model = model;
    
    [self setData];
    [self setStateLabelSate];
}

-(void)setData{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.headpic] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
 
    self.nameLabel.text        = _model.name;
    self.brandSeriesLabel.text = [NSString stringWithFormat:@"%@   %@",_model.brandname,_model.seriesname];
    self.modelLabel.text       = _model.modelname;
    self.cityLabel.text        = _model.cname;
    self.titelLabel.text       = _model.title;
    self.timeLabel.text        = _model.date;
    self.applearNumberLabel.attributedText = [self attributeSize:[NSString stringWithFormat:@"已有%@位专家回答",_model.applynum]];
    
    CGSize size = [self.cityLabel.text calculateTextSizeWithFont:self.cityLabel.font Size:CGSizeMake(1000, 20)];
    [self.cityLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(size.width);
    }];
    
    CZWFmdbManager *manager = [CZWFmdbManager manager];
    NSArray *array = [manager selectAllFromCollect];
    self.collectButotn.selected = NO;
    for (NSString *string in array) {
        if ([string isEqualToString:_model.cpid]) {
            self.collectButotn.selected = YES;
            break;
        }
    }
    
    
    self.userStateLabel.text = _model.steps;//_model.steps;
    CGFloat width = [_model.steps calculateTextSizeWithFont:self.userStateLabel.font Size:CGSizeMake(100, 16)].width;
    [self.userStateLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width+6);
    }];
    
    self.imageView1.image = self.imageView2.image = self.imageView3.image = nil;
    
    if (_model.image.length > 0) {
        [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftSpace);
            make.top.equalTo(self.imageView1.bottom).with.offset(5);
            //make.size.equalTo(CGSizeMake(200, 20));
            
        }];
        NSArray *array = [_model.image componentsSeparatedByString:@"||"];
        if (array) {
            NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:array];
            [marray removeObject:@""];
            array = marray;
        }
      
        NSInteger max = array.count >3? 3:array.count;
        for (int i = 0; i < max; i ++) {
            if (i == 0)
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@""]];
            else if(i == 1)
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:array[1]] placeholderImage:[UIImage imageNamed:@""]];
            else if (i == 2)
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:array[2]] placeholderImage:[UIImage imageNamed:@""]];
            
        }
        
    }else{
        [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftSpace);
            make.top.equalTo(self.titelLabel.bottom).with.offset(5);
        }];
    }

    if ([_model.applynum integerValue] == 0) {
        self.applearNumberLabel.hidden = YES;
        [self.collectButotn remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.timeLabel);
            make.right.equalTo(-self.leftSpace);
            make.width.equalTo(52);
        }];
    }else{
        self.applearNumberLabel.hidden = NO;

        [self.collectButotn remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.applearNumberLabel);
            make.right.equalTo(-self.leftSpace);
            make.width.equalTo(52);
        }];
    }
}

- (CGFloat)viewHeight{

    CGFloat height = 15+55+5+20;
    if (self.model.image.length>0) {
        height += (5+(WIDTH-self.leftSpace*2-10)/3*factor_width*6.5/11);
    }
    if (!self.applearNumberLabel.hidden) {
        height += (20);
    }
    height += 20+10;

    return height;
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
    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    [style setLineSpacing:5];
 //   [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];
    return att;
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
