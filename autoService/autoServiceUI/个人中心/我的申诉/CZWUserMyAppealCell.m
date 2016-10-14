//
//  CZWUserMyAppealCell.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserMyAppealCell.h"
#import "CZWUserAppealCellView.h"
#import "CZWUserAppealCellButtonView.h"
#import "TTTAttributedLabel.h"

@implementation CZWMyAppealModel


@end

@interface CZWUserMyAppealCell ()<CZWUserAppealCellButtonViewDelegate,UIAlertViewDelegate>

@end
@implementation CZWUserMyAppealCell
{
    UILabel *titleLabel;
    UILabel *userStateLabel;//状态
    UILabel *dateLabel;//时间
    UILabel *applearNumberLabel;//申诉进度
    CZWUserAppealCellView *stepView;
    TTTAttributedLabel *factoryreplyLabel;//厂家回复
    CZWUserAppealCellButtonView *buttomView;

    UIView *lineView;

    CGFloat leftSpace;
    CGFloat textFont;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        leftSpace = 15;
        textFont = 15;
        self.drawLine = NO;

        [self newsUI];
        
    }
    return self;
}

-(void)newsUI{
    
    titleLabel = [LHController createLabelFont:PT_FROM_PX(21) Text:nil Number:1 TextColor:colorBlack];
    dateLabel = [LHController createLabelFont:textFont-2 Text:nil Number:1 TextColor:colorLightGray];
    userStateLabel = [LHController createLabelFont:textFont-3 Text:nil Number:1 TextColor:colorLineGray];
    userStateLabel.textAlignment = NSTextAlignmentCenter;
    userStateLabel.layer.cornerRadius = 2;
    userStateLabel.layer.masksToBounds = YES;
    userStateLabel.layer.borderWidth = 0.5;
    
    stepView = [[CZWUserAppealCellView alloc] init];
    stepView.drawWidth = WIDTH-leftSpace;
    
    
    buttomView = [[CZWUserAppealCellButtonView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    buttomView.delegate = self;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"小喇叭"];
    
    applearNumberLabel = [LHController createLabelFont:PT_FROM_PX(19) Text:nil Number:0 TextColor:colorDeepGray];
    
    factoryreplyLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    factoryreplyLabel.font = [UIFont systemFontOfSize:textFont-2];
    factoryreplyLabel.textColor = colorDeepGray;
    factoryreplyLabel.numberOfLines = 0;
    factoryreplyLabel.preferredMaxLayoutWidth = WIDTH-30;
    factoryreplyLabel.textInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    
    UILabel *label = [LHController createLabelFont:PT_FROM_PX(19) Text:@"厂家回复：" Number:1 TextColor:colorBlack];
    [factoryreplyLabel addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
    }];

    lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:userStateLabel];
    [self.contentView addSubview:stepView];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:applearNumberLabel];
    [self.contentView addSubview:factoryreplyLabel];
    [self.contentView addSubview:buttomView];
    [self.contentView addSubview:lineView];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(15);
        make.right.lessThanOrEqualTo(userStateLabel.left).offset(-10);
    }];
    
    [userStateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.height.equalTo(20);
        make.top.equalTo(titleLabel);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.bottom).offset(10);
    }];
    
    [stepView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftSpace);
        make.top.equalTo(dateLabel.bottom).offset(5);
        make.width.equalTo(stepView.drawWidth);
    }];
    
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(stepView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
    
    applearNumberLabel.preferredMaxLayoutWidth = WIDTH-leftSpace*2;
    [applearNumberLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.right).offset(5);
        make.right.equalTo(-leftSpace);
        make.top.equalTo(stepView.bottom).offset(10);
    }];
    
    
    [factoryreplyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applearNumberLabel.left);
        make.top.equalTo(applearNumberLabel.bottom).offset(10);
        make.right.equalTo(-15);
    }];
    
    [buttomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(factoryreplyLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 30));
        // make.bottom.equalTo(-15);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(1);
    }];
}


-(void)gestureBlock:(void (^)(CZWUserMyAppealCell *, NSString *))block{
    self.myBlock = block;
}

-(void)setModel:(CZWMyAppealModel *)model{
    
    _model = model;
    titleLabel.text = _model.title;
    dateLabel.text = _model.date;
    userStateLabel.text = _model.steps;
    CGFloat width = [_model.steps calculateTextSizeWithFont:userStateLabel.font Size:CGSizeMake(100, 20)].width;
    [userStateLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width+6);
    }];

    
    [stepView setSteps:_model.stepArray andIndex:[_model.num integerValue]];
    [stepView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(stepView.changeFrameHeight);
    }];
    
    applearNumberLabel.attributedText = [NSAttributedString numberColorAttributeSting:_model.prompt color:colorNavigationBarColor];
    
    if ([_model.stepid integerValue] == 0) {
        buttomView.buttonTitle = @"删除";
        buttomView.isdate = NO;
    }else{
        
        if (_model.waitdate.length > 0) {
            buttomView.buttonTitle = _model.waitdate;
            buttomView.isdate = YES;
        }else{
            buttomView.buttonTitle = _model.button;
            buttomView.isdate = NO;
        }
    }

    factoryreplyLabel.text = _model.factoryreply;

   CGSize  size = [factoryreplyLabel sizeThatFits:CGSizeMake(WIDTH, 1000)];
    [factoryreplyLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(size.height);
    }];

    if (_model.factoryreply.length > 0) {
        factoryreplyLabel.hidden = NO;

        [lineView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buttomView.bottom).offset(15);
        }];

    }else{

        factoryreplyLabel.hidden = YES;
        [factoryreplyLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];

        if (_model.button.length == 0) {
            
             [lineView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(buttomView.bottom).offset(-5);
            }];
        }else{

            [lineView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(buttomView.bottom).offset(15);
            }];
            
        }
        
    }

    [self setStateLabelSate];
}


-(void)setStateLabelSate{
    if ([_model.steps isEqualToString:@"厂家受理"]) {
        
        userStateLabel.textColor = colorYellow;
        
    }else if ([_model.steps isEqualToString:@"咨询专家"]){
        
        userStateLabel.textColor = colorOrangeRed;
    }else if ([_model.steps isEqualToString:@"未完成"]){
        
        userStateLabel.textColor = colorNavigationBarColor;
    }else if ([_model.steps isEqualToString:@"已完成"]){
        
        userStateLabel.textColor = RGB_color(82, 187, 77, 1);
    }
    else if ([_model.steps isEqualToString:@"未采纳专家建议"]) {
        
        userStateLabel.textColor = colorYellow;
    }else if([_model.steps isEqualToString:@"已采纳专家建议"]){
        
        userStateLabel.textColor = colorNavigationBarColor;
    }else if ([self.model.steps isEqualToString:@"网站审核"]) {
        
        userStateLabel.textColor = RGB_color(100, 198, 255, 1);
    }else{
        userStateLabel.textColor = colorBlack;
    }
    userStateLabel.layer.borderColor = userStateLabel.textColor.CGColor;
}



-(void)deleteTimer{
    [buttomView deleteTimer];
}

#pragma mark - CZWUserAppealCellButtonViewDelegate

-(void)selectButton:(nullable NSString *)string{
    
    if ([string isEqualToString:@"删除"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除此条申诉吗？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        if (self.myBlock) {
            self.myBlock(self,string);
        }
        
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.myBlock) {
            self.myBlock(self,@"删除");
        }
    }
}

@end
