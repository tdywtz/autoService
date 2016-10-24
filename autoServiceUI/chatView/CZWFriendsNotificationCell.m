//
//  CZWFriendsNotificationCell.m
//  autoService
//
//  Created by bangong on 16/2/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWFriendsNotificationCell.h"

@implementation CZWFriendsNotificationCell
{
    UILabel *contentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        contentLabel = [LHController createLabelWithFrame:CGRectZero Font:15 Bold:NO TextColor:[UIColor whiteColor] Text:nil];
        contentLabel.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:contentLabel];
        [contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(5);
        }];
    }
    return self;
}
-(void)setModel:(RCMessageModel *)model{
    [super setModel:model];
    self.messageTimeLabel.text = [NSString stringWithFormat:@"%lld",model.sentTime];
    RCContactNotificationMessage *message = (RCContactNotificationMessage *)model.content;
    if (message.extra) {
        NSData *data = [message.extra dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([message.operation isEqualToString:ContactNotificationMessage_ContactOperationRequest]) {
            contentLabel.text = [NSString stringWithFormat:@"来自“%@”的好友请求",dict[@"name"]];
        }else if ([message.operation isEqualToString:ContactNotificationMessage_ContactOperationAcceptResponse]){
            contentLabel.text = [NSString stringWithFormat:@"“%@”已同意您好友请求",dict[@"name"]];
        }
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
