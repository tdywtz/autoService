//
//  CZWEvaluateViewController.m
//  autoService
//
//  Created by bangong on 15/12/23.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWEvaluateViewController.h"
#import "StarView.h"
#import "CZWIMInputTextView.h"

@interface CZWEvaluateViewController ()<UITextViewDelegate>
{
    CGFloat      textFont;
    UIImageView *iconImageView;
    UILabel     *nameLabel;
    StarView    *starView;
    UILabel     *appealNumLabel;
    
    CZWIMInputTextView  *_textView;
    UILabel     *plealLabel;
    UILabel     *scoreLabel;//评分提示字
    NSInteger    starNum;
    //评价处理结果是否满意
    UIButton *leftButton;
    UIButton *rightButton;
    
    UIButton    *submitBtn;
}
@end

@implementation CZWEvaluateViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"评价";
        textFont = [LHController setFont]-2;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self createLeftItemBack];
    [self createScrollView];
    [self createNotification];
   
    if (self.tostyle == EvaluateToExpert) {
        [self createInfo];
        [self loadData];
    }else if (self.tostyle == EvaluateToManufactorResult){
        [self createHeader];
    }
    [self createStar];
}

-(void)viewDidLayoutSubviews{
    [submitBtn layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, submitBtn.frame.origin.y+60);
}

#pragma mark - 对专家评价
-(void)loadData{
  
    [CZWHttpModelResults requestExpertInfoWithExpertId:self.eid result:^(CZWUserInfoExpert *userInfo) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.headpic] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
        nameLabel.attributedText = [NSAttributedString expertName:userInfo.realname];
        [starView setStar:[userInfo.score floatValue]];
        appealNumLabel.attributedText = [NSAttributedString numberColorAttributeSting:[NSString stringWithFormat:@"已解决%@单",userInfo.complete_num] color:colorNavigationBarColor];
    }];
}

-(void)createInfo{
    iconImageView  = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = 20;
    iconImageView.layer.masksToBounds = YES;
    nameLabel      = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorNavigationBarColor Text:nil];
    starView       = [[StarView alloc] initWithFrame:CGRectZero];
    appealNumLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorLightGray Text:nil];
    
    [self.scrollView addSubview:iconImageView];
    [self.scrollView addSubview:nameLabel];
    [self.scrollView addSubview:starView];
    [self.scrollView addSubview:appealNumLabel];
    
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(15);
        make.size.equalTo(CGSizeMake(200, 20));
    }];
    
    [starView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom);
        make.size.equalTo(CGSizeMake(75, 23));
    }];
    
    [appealNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starView.right).offset(10);
        make.centerY.equalTo(starView);
    }];
}

#pragma Mark- 对厂家处理结果评价
-(void)createHeader{
    
    UIImage *image = [UIImage imageNamed:@"expert_prolosal"];
 
     leftButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Text:@"已解决"];
    [leftButton setTitleColor:colorNavigationBarColor forState:UIControlStateSelected];
     [leftButton setTitleColor:colorDeepGray forState:UIControlStateNormal];
    leftButton.layer.borderWidth = 0.6;
    leftButton.layer.cornerRadius = 3;
    leftButton.layer.masksToBounds = YES;
    [leftButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateSelected];
 
     rightButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Text:@"未解决"];
    [rightButton setTitleColor:colorNavigationBarColor forState:UIControlStateSelected];
    [rightButton setTitleColor:colorDeepGray forState:UIControlStateNormal];
    rightButton.layer.borderWidth = 0.6;
    rightButton.layer.cornerRadius = 3;
    rightButton.layer.masksToBounds = YES;
    [rightButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateSelected];
   
    [self.scrollView addSubview:leftButton];
    [self.scrollView addSubview:rightButton];

    
    [leftButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(20);
        make.size.equalTo(CGSizeMake((WIDTH-60)/2, 30));
    }];
    [rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(leftButton);
        make.size.equalTo(CGSizeMake((WIDTH-60)/2, 30));
    }];
    
    [self buttonClick:leftButton];
}


//
-(void)createStar{
    
    UILabel *label = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorBlack Text:@"综合评价"];
    UIView *lineA = [LHController createBackLineWithFrame:CGRectZero];
   
    _textView = [[CZWIMInputTextView alloc] initWithFrame:CGRectMake(10, lineA.frame.origin.y+10, WIDTH+10, 150)];
    _textView.delegate = self;
    _textView.placeHolder = @"请写下对专家此次服务的评价吧，对别人帮助很大哦！";
    if (self.tostyle != EvaluateToExpert) {
    _textView.placeHolder = @"请对厂家进行评价。";
    }
    _textView.font = [UIFont systemFontOfSize:14];

    plealLabel = [LHController createLabelWithFrame:CGRectZero Font:textFont Bold:NO TextColor:colorLightGray Text:@"还能输入200个字"];
    //评价厂家是隐藏可输入数量提示
    if (self.tostyle == EvaluateToManufactor) {
        plealLabel.hidden = YES;
    }
    UIView *lineB= [LHController createBackLineWithFrame:CGRectZero];
    
    submitBtn = [LHController createButtnFram:CGRectZero Target:self Action:@selector(btnClick) Font:14 Text:@"发表评价"];
    
    [self.scrollView addSubview:label];
    [self.scrollView addSubview:lineA];
    [self.scrollView addSubview:_textView];
    [self.scrollView addSubview:plealLabel];
    [self.scrollView addSubview:lineB];
    [self.scrollView addSubview:submitBtn];
    
    if (self.tostyle == EvaluateToExpert) {
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView);
            make.top.equalTo(iconImageView.bottom).offset(30);
            make.size.equalTo(CGSizeMake(70, 20));
        }];
    }else if (self.tostyle == EvaluateToManufactorResult){
    
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(leftButton.bottom).offset(20);
            make.size.equalTo(CGSizeMake(70, 20));
        }];
        
    }else{
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(30);
            make.size.equalTo(CGSizeMake(70, 20));
        }];
    }
    
    
    [lineA makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.bottom).offset(20);
        make.left.equalTo(self.scrollView.left);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineA.bottom).offset(10);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(WIDTH-20, 160));
    }];
    
    [plealLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_textView).offset(-5);
        make.bottom.equalTo(_textView);
    }];
 
    
    [lineB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.bottom).offset(15);
        make.left.equalTo(self.scrollView);
        make.size.equalTo(lineA);
    }];
                            
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineB.bottom).offset(30);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(WIDTH-20, 40));
    }];
    
    
    UIButton *temp;
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [LHController createButtnFram:CGRectZero Target:self Action:@selector(starClick:) Text:nil];
        [btn setBackgroundImage:[UIImage imageNamed:@"user_ evaluation"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"user_ evaluationSelected"] forState:UIControlStateSelected];
        btn.tag = 100+i;
        [self.scrollView addSubview:btn];
        if (i == 0) {
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.right);
                make.centerY.equalTo(label).offset(-2);
                make.size.equalTo(CGSizeMake(28, 28));
            }];
        }else{
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(temp.right).offset(5);
                make.centerY.equalTo(temp);
                make.size.equalTo(temp);
            }];
        }
        temp = btn;
    }
    
   scoreLabel = [LHController createLabelFont:12 Text:@"" Number:1 TextColor:colorYellow];
    [self.scrollView addSubview:scoreLabel];
    if (temp) {
        [scoreLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(temp.right).offset(10);
            make.centerY.equalTo(label);
        }];
    }
}


#pragma mark - SEL
-(void)buttonClick:(UIButton *)btn{
    if (btn == leftButton) {
        leftButton.selected = YES;
        rightButton.selected = NO;
        rightButton.layer.borderColor = colorLightGray.CGColor;
        leftButton.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        rightButton.selected = YES;
        leftButton.selected = NO;
        leftButton.layer.borderColor = colorLightGray.CGColor;
        rightButton.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

-(void)starClick:(UIButton *)btn{
    for (int i = 0; i < 5; i ++) {
        UIButton *button = (UIButton *)[self.scrollView viewWithTag:100+i];
        if (i <= btn.tag-100) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    starNum = btn.tag-99;
    NSArray *array = @[@"差",@"一般",@"满意",@"很满意",@"强烈推荐"];
    scoreLabel.text = array[starNum-1];
   // scoreLabel.text = [@(arc4random()) stringValue];
}

-(void)btnClick{
   
    if (starNum < 1) {
       return [CZWAlert alertDismiss:@"您还没有评分"];
    }else if ([NSString isNotNULL:_textView.text] == NO){
       
        return [CZWAlert alertDismiss:@"请输入内容"];
    }else{
        [_textView resignFirstResponder];
      //评价专家
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        __weak __typeof(self)weakSelf = self;
        if (self.tostyle == EvaluateToExpert) {
         //对专家评价
            [CZWAFHttpRequest requestwithUid:[CZWManager manager].roleId cpid:self.cpid score:[NSString stringWithFormat:@"%ld",starNum] username:[CZWManager manager].roleName content:_textView.text eid:self.eid success:^(id responseObject) {
                // NSLog(@"%@",responseObject);
                [hud hideAnimated:YES];
                if ([responseObject count] == 0) {
                    return ;
                }
                if ([responseObject firstObject][@"scuess"]) {
                    [CZWAlert alertDismiss:[responseObject firstObject][@"scuess"]];
                    if (weakSelf.success) {
                        weakSelf.success(weakSelf.cpid);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [CZWAlert alertDismiss:[responseObject firstObject][@"error"]];
                }
            } failure:^(NSError *error) {
                [hud hideAnimated:YES];
                NSLog(@"%@",error);
            }];

        }else{
        
          //评价厂家
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[CZWManager manager].roleId forKey:@"uid"];
            [dict setObject:self.cpid forKey:@"cpid"];
            [dict setObject:[@(starNum) stringValue] forKey:@"score"];
            [dict setObject:[CZWManager manager].roleName forKey:@"username"];
            [dict setObject:_textView.text forKey:@"content"];
            if (self.tostyle == EvaluateToManufactorResult) {
                NSString *state = leftButton.selected?@"1":@"2";
                [dict setObject:state forKey:@"state"];
            }
            [CZWAFHttpRequest requestCactoryEvaluate:dict success:^(id responseObject) {
                [hud hideAnimated:YES];
                if ([responseObject count]) {
                    if ([responseObject firstObject][@"scuess"]) {
                        [CZWAlert alertDismiss:[responseObject firstObject][@"scuess"]];
                        if (weakSelf.success) {
                            weakSelf.success(weakSelf.cpid);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }else if ([responseObject firstObject][@"error"]){
                        [CZWAlert alertDismiss:[responseObject firstObject][@"error"]];
                    }else{
                        [CZWAlert alertDismiss:@"提交失败"];
                    }
                }else{
                    [CZWAlert alertDismiss:@"提交失败"];
                }
                
            } failure:^(NSError *error) {
                [hud hideAnimated:YES];
            }];
        }
    }
}

/**
 *block
 */
-(void)success:(void (^)(NSString *))block{
    self.success = block;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView{

    if (_textView.text.length > 200) {
        _textView.text = [_textView.text substringToIndex:199];
    }
    plealLabel.text = [NSString stringWithFormat:@"还能输入%ld个字",200- _textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_textView.text.length > 200) {
        return NO;
    }
   
    return YES;
}
@end
