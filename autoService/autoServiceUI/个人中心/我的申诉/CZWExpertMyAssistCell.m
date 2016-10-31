//
//  CZWExpertMyAssistCell.m
//  autoService
//
//  Created by bangong on 15/12/2.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWExpertMyAssistCell.h"
#import "CZWBasicPanNavigationController.h"
#import "TestLabel.h"
#import <CoreText/CoreText.h>


@interface CZWExpertMyAssistCell ()
{
    UIButton *telephoneButton;
    TestLabel *contentLabel;
    UIView  *backView;
    UIImageView *imageView;
    UIImageView *cainaImageView;
}

@end
@implementation CZWExpertMyAssistCell

- (void)dealloc
{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.nameLabel.userInteractionEnabled = NO;
        [self.collectButotn removeFromSuperview];
        [self.applearNumberLabel removeFromSuperview];
        [self.imageView1 removeFromSuperview];
        [self.imageView2 removeFromSuperview];
        [self.imageView3 removeFromSuperview];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    
    telephoneButton = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(telephoneClick) Text:nil];
        [telephoneButton setImage:[UIImage imageNamed:@"auto_telephoneImage"] forState:UIControlStateNormal];
    backView = [LHController createBackLineWithFrame:CGRectZero];
  
    contentLabel = [[TestLabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = colorDeepGray;

    imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"三角"];
    cainaImageView = [[UIImageView alloc] init];
    cainaImageView.image = [UIImage imageNamed:@"采纳图标"];

    
    
    [self.contentView addSubview:telephoneButton];
    [self.contentView addSubview:backView];
    [backView addSubview:contentLabel];
    [backView addSubview:imageView];
    [backView addSubview:cainaImageView];
    
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
    [self.nameLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.right).with.offset(10);
        make.right.lessThanOrEqualTo(self.userStateLabel.left).with.offset(-40);
        make.height.equalTo(20);
    }];
    
    [telephoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.nameLabel.right).with.offset(10);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftSpace);
        make.right.equalTo(-self.leftSpace);
        make.top.equalTo(self.titelLabel.bottom).offset(10);
    }];
    
    
    contentLabel.preferredMaxLayoutWidth = WIDTH-77;
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(15);
        make.right.equalTo(-32);
    }];
    
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.bottom);
        make.centerX.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    [cainaImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(0);

    }];
    
    
    [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.bottom).offset(5);
        make.left.equalTo(self.leftSpace);
        make.bottom.equalTo(-10);
    }];

}


-(void)telephoneClick{
    if (self.block) {
        self.block(self.model.mobile,self.model.name);
    }
}

-(void)tap:(UITapGestureRecognizer *)tap{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.model.content];
    NSMutableParagraphStyle *paragh = [[NSMutableParagraphStyle alloc] init];
    [att addAttribute:NSParagraphStyleAttributeName value:paragh range:NSMakeRange(0, att.length)];
    paragh.lineSpacing = 4;
    paragh.paragraphSpacing = 10;
    paragh.alignment = NSTextAlignmentJustified;
    paragh.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    // 创建CTFramesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)att);
    // 获得建议的frame
    CTFrameRef rect = [self createFrameRefWithFramesetter:framesetter textWidth:WIDTH-77 att:att];
    CFArrayRef lines = CTFrameGetLines(rect);
    CFIndex count =  CFArrayGetCount(lines);
    CFRelease(framesetter);
    CFRelease(rect);
    if (count > 2) {
        if (self.openCell) {
            self.openCell(self);
        }
    }
}


-(void)callDivert:(telephone)block{
    self.block = block;
}

-(void)openCell:(void (^)(CZWExpertMyAssistCell *))block{
    self.openCell = block;
}

-(void)setChanged:(BOOL)changed{
    telephoneButton.hidden = !changed;
}

-(void)setData{
    if (self.model.cellOpen) {
        contentLabel.numberOfLines = 0;
        
        [UIView animateWithDuration:0.1 animations:^{
            imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
         contentLabel.numberOfLines = 2;
        [UIView animateWithDuration:0.1 animations:^{
            imageView.transform = CGAffineTransformIdentity;
        }];
    }
    

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.headpic] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
    self.nameLabel.text = self.model.name;
    self.brandSeriesLabel.text = [NSString stringWithFormat:@"%@   %@",self.model.brandname,self.model.seriesname];
    self.modelLabel.text = self.model.modelname;
    self.cityLabel.text = self.model.cname;
    self.titelLabel.text = self.model.title;
    self.timeLabel.text = self.model.date;
    self.userStateLabel.text = self.model.steps;
     contentLabel.text = self.model.content;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.model.content];
    NSMutableParagraphStyle *paragh = [[NSMutableParagraphStyle alloc] init];
    [att addAttribute:NSParagraphStyleAttributeName value:paragh range:NSMakeRange(0, att.length)];
    paragh.lineSpacing = 4;
    paragh.paragraphSpacing = 10;
    paragh.alignment = NSTextAlignmentJustified;
    paragh.lineBreakMode = NSLineBreakByWordWrapping;
    

      // 创建CTFramesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)att);
    // 获得建议的frame
    CTFrameRef rect = [self createFrameRefWithFramesetter:framesetter textWidth:WIDTH-77 att:att];
    CFArrayRef lines = CTFrameGetLines(rect);
    CFIndex count =  CFArrayGetCount(lines);
    CFRelease(framesetter);
    CFRelease(rect);
  
    paragh.lineBreakMode = NSLineBreakByTruncatingTail;
    [att removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, att.length)];
    [att addAttribute:NSParagraphStyleAttributeName value:paragh range:NSMakeRange(0, att.length)];
    //
    contentLabel.attributedText = att;
   
    //内容是否超过两行
    if (count > 2) {
        imageView.hidden = NO;
        [imageView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20);
        }];
    }else{
        imageView.hidden = YES;
        [imageView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(12);
        }];
    }
    //是否采纳
    if ([self.model.show integerValue] == 1) {
        cainaImageView.hidden = NO;
    }else{
        cainaImageView.hidden = YES;
    }
    
    CGSize size = [self.cityLabel.text calculateTextSizeWithFont:self.cityLabel.font Size:CGSizeMake(1000, 20)];
    [self.cityLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(size.width);
    }];
    
    //_model.steps;
    CGFloat width = [self.model.steps calculateTextSizeWithFont:self.userStateLabel.font Size:CGSizeMake(100, 16)].width;
    [self.userStateLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width+6);
    }];
}

-  (CTFrameRef)createFrameRefWithFramesetter:(CTFramesetterRef)framesetter textWidth:(CGFloat)textWidth att:(NSMutableAttributedString *)_attString
{
    // 这里你需要创建一个用于绘制文本的路径区域,通过 self.bounds 使用整个视图矩形区域创建 CGPath 引用。
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, textWidth, CGFLOAT_MAX));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [_attString length]), path, NULL);
    CFRelease(path);
    return frameRef;
}


- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
