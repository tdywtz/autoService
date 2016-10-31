//
//  CZWChatUserCell.m
//  autoService
//
//  Created by bangong on 15/12/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWChatUserCell.h"

@implementation CZWChatUserCell
{
    UIImageView *iconImageView;
    UILabel     *nameLabel;
    UILabel     *dateLabel;
    UILabel     *messageLabel;
    UILabel     *numLabel;
    
    CGFloat textFont;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        textFont = [LHController setFont]-2;
        self.drawLine = YES;
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconImageView.image = [UIImage imageNamed:@"userIconDefaultImage"];
    iconImageView.layer.cornerRadius = 3;
    iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImageView];
    
    numLabel = [LHController createLabelWithFrame:CGRectZero Font:11 Bold:NO TextColor:[UIColor whiteColor] Text:nil];
    numLabel.layer.cornerRadius = 9;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.layer.masksToBounds = YES;
    numLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:numLabel];
    
    nameLabel = [LHController createLabelWithFrame:CGRectZero Font:16 Bold:NO TextColor:colorOrangeRed Text:nil];
    [self.contentView addSubview:nameLabel];
    
    dateLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:dateLabel];
    
    messageLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-1 Bold:NO TextColor:colorDeepGray Text:nil];
    [self.contentView addSubview:messageLabel];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [numLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.left.equalTo(iconImageView.right).offset(-10);
        make.size.greaterThanOrEqualTo(CGSizeMake(18, 18));
    }];
    
   [nameLabel makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(iconImageView.right).offset(10);
       make.top.equalTo(iconImageView).offset(5);
       make.right.lessThanOrEqualTo(dateLabel.left);
       make.height.equalTo(20);
   }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.right.equalTo(-10);
        make.size.greaterThanOrEqualTo(CGSizeMake(110, 20));
    }];
    
    [messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.right.equalTo(dateLabel);
        make.bottom.equalTo(iconImageView.bottom).offset(-3);
        make.height.equalTo(20);
    }];
}

-(void)setModel:(RCConversationModel *)model{
    
    if (_model != model) {
        _model = model;
        
        
        nameLabel.text = _model.conversationTitle;
        dateLabel.text =  [self setChatDate:_model.sentTime];
        [self name:model.targetId];
        
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]){
            RCTextMessage *message = (RCTextMessage *)model.lastestMessage;
            messageLabel.text = message.content;
        }else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
            messageLabel.text = @"(图片)";
        }else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
            messageLabel.text = @"(位置)";
        }else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
            messageLabel.text = @"(语音)";
        }
  
        if (_model.unreadMessageCount > 0) {
            numLabel.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"%ld",model.unreadMessageCount];
            numLabel.text = str;
            CGSize  size = [NSString calculateTextSizeWithText:str Font:11 Size:CGSizeMake(100, 20)];
            CGPoint center = numLabel.center;
            numLabel.bounds = CGRectMake(0, 0, size.width+8, 18);
            numLabel.center = center;
        }else{
            numLabel.hidden = YES;
        }
    }
}

-(void)name:(NSString *)targetId{
    [CZWHttpModelResults requestChatUserInfoWithUserId:targetId success:^(CZWChatUserInfo *userInfo) {
        if ([userInfo.type isEqualToString:USERTYPE_EXPERT]) {
            nameLabel.textColor = colorNavigationBarColor;
            nameLabel.attributedText = [NSAttributedString expertName:userInfo.userName];
            iconImageView.layer.cornerRadius = 25;
            iconImageView.layer.masksToBounds = YES;
        }else{
            nameLabel.textColor = colorOrangeRed;
            nameLabel.text = userInfo.userName;
            iconImageView.layer.cornerRadius = 3;
            iconImageView.layer.masksToBounds = YES;
        }

        [iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];

    }];
}

/**
 *  时间换算
 *
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)setChatDate:(long long)time{
    
    NSDate *fromdate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    if (!fromdate) {
        return @"";
    }

    NSDateFormatter *format=[[NSDateFormatter alloc] init];
   
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|
    NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSDateComponents *compsFrom = [calendar components:unitFlags fromDate:fromdate];

    NSString *ymdfrom = [NSString stringWithFormat:@"%ld%.2ld%.2ld",compsFrom.year,compsFrom.month,compsFrom.day];
    NSDateComponents *compsTo = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *ymdto = [NSString stringWithFormat:@"%ld%.2ld%.2ld",compsTo.year,compsTo.month,compsTo.day];

   
    NSInteger ace = [ymdto integerValue]-[ymdfrom integerValue];
    if (ace == 0) {
        [format setDateFormat:@"HH:mm"];
        return [format stringFromDate:fromdate];
    }else if (ace == 1){
        return @"昨天";
    }
//    else if (days > 1 && days <= 4){
//        unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|
//        NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
//        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//        [calendar setTimeZone: timeZone];
//        NSDateComponents *comps = [calendar components:unitFlags fromDate:fromdate];
//            NSLog(@"year=%ld,month=%ld,day=%ld,hour=%ld,minute=%ld,second=%ld,weekday=%@",
//                  comps.year,comps.month,comps.day,comps.hour,comps.minute,comps.second,weekDays[comps.weekday]);
//        return weekDays[comps.weekday];
//    }
    else{
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [format stringFromDate:fromdate];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
