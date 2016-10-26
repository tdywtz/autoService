//
//  CZWExpertCardCell.h
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZWCardCell : UITableViewCell

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,copy) NSString *rightText;
@property (nonatomic,copy) NSString *placeholder;
@end
