//
//  CZWComplainViewController.m
//  autoService
//
//  Created by bangong on 15/12/1.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWAppealViewController.h"
#import "LHDatePickView.h"
#import "LHPickerView.h"
#import "CityChooseViewController.h"
#import "ChooseViewController.h"
#import "NSString-Helper.h"
#import "CZWShowImageView.h"

#define LEFT 15
#define SPACE 35

/**购车发票*/
NSString * const BuyCarBill = @"BuyCarBill";
/**行驶证*/
NSString * const DrivingLicense = @"DrivingLicense";
/**维修工单*/
NSString * const RepairOrder = @"RepairOrder";
/**申诉图片*/
NSString * const CarImage = @"CarImage";

@interface CZWAppealViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    CGFloat y;
    //一
    UITextField *nameTextField;//姓名
    UITextField *ageTextField;//年龄
    UITextField *phoneTextField;//手机号
    UITextField *emailTextField;//邮箱
    UITextField *callTextField;//手机号
    UITextField *addressTextField;//地址
    UITextField *occupationTextField;//职业车主
    UITextField *sexField;//性别
    
    //二
    UITextField *brandName;//品牌
    UITextField *series;//车系
    UITextField *model;//车型
    UITextField *engine;//发动机号
    UITextField *carNum;//车架号
    UITextField *numberPlate;//车牌号
    UITextField *province;//省份简称
    UITextField *dateBuy;//购车日期
    UITextField *dateBreakdown;//问题日期
    UITextField *mileage;//行驶里程
    UITextField *sheng_shi;
    CZWShowImageView *invoiceImageView;//发票
    CZWShowImageView *listImageView;//维修工单
    CZWShowImageView *drivingImageView;//行驶证
    CZWShowImageView *appealImageView;//申诉图片

    UIView *BusinessNameSuperView;
    UITextField *businessName;
    UITextField *hideBusinessName;
    
    //三
    LHDatePickView *_datePicer;
    UITextField *complainPart;//投诉部位
    UITextField *complainServer;//服务问题
    UITextField *describe;//问题描述
    CZWIMInputTextView  *details;
    //yanzheng
    UITextField *test;
    UILabel *testLabel;
    UIButton *next;
    
    //键盘高度
    CGFloat height;
    
    NSString *brandId;//大品牌
    NSString *seriesId;//车系
    NSString *modelId;//车型
    NSString *provinceId;//省份id
    NSString *_cityId;//市
    NSString *businessId;//经销商id
    
    //字体大小
    CGFloat textFont;
    BOOL first;
}
@property (nonatomic,copy) NSString *code;//验证码
@property (nonatomic,strong) UIView *contentView;

@end

@implementation CZWAppealViewController
- (void)dealloc
{
    [_datePicer removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createLeftItemBack];
    [self createScrollView];
   
    textFont = [LHController setFont]-2;
    first = YES;
    self.title = @"我要申诉";
    
    dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self createHeader];
        [self createUI];
        [self createTap];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.revise) {
            [self loadUserData];
        }else{
            [self loadCar];
        }
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldChange:(NSNotification *)notification{
    UITextField *textField = notification.object;

    if (textField == test) {
        if (test.text.length == 4) {
            if (![test.text isEqualToString:self.code]){
                [self alertView:@"验证码输入错误"];
            }else{
               
                [self.view endEditing:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nextClick];
                });
                
            }
        }
    }
}

-(void)viewDidLayoutSubviews{
    [next layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0,next.frame.origin.y+next.frame.size.height+60);
}

#pragma mark - 头部
-(void)createHeader{
    UILabel *leftLabel = [LHController createLabelWithFrame:CGRectMake(LEFT, 20, 10, 10) Font:textFont-2 Bold:NO TextColor:colorOrangeRed Text:@"*"];
    [self.scrollView addSubview:leftLabel];
    
    UILabel *label1 = [LHController createLabelWithFrame:CGRectMake(LEFT+20, 10, WIDTH-2*LEFT-20, 40) Font:textFont-2 Bold:NO TextColor:colorOrangeRed Text:@"号为必填选项，为了我们能及时与您取得联系，了解到更详细信息，请您认真填写以下内容。"];
    [self.scrollView addSubview:label1];
    y = label1.frame.origin.y+label1.frame.size.height+20;
}

#pragma mark - ui搭建
-(void)createUI{
    [self createHeaderWithY:y ImageName:@"appeal_uaerInformation" Title:@"车主信息" Content:@"您填写的信息我们会严格保密，敬请放心！" superView:self.scrollView];
    [self createOne];
    
    [self createHeaderWithY:y+20 ImageName:@"appeal_carInformation" Title:@"车辆信息" Content:@"请如实填写您要投诉的车辆信息。" superView:self.scrollView];
    [self createTwo];
    [self createThree];
}

#pragma mark - 计算字符串长度
-(CGFloat)getLenth:(NSString *)str andFont:(CGFloat)font{
    CGSize size =[str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

#pragma mark - 模块头部
-(void)createHeaderWithY:(CGFloat)frameY ImageName:(NSString *)imageName Title:(NSString *)title Content:(NSString *)content superView:(id)superView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, frameY, 20, 20)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = [UIImage imageNamed:imageName];
    [superView addSubview:imageView];
    
    CGFloat width = [self getLenth:title andFont:textFont+2];
    UILabel *label2 = [LHController createLabelWithFrame:CGRectMake(LEFT+25, frameY, width, 20) Font:textFont+2 Bold:NO TextColor:colorBlack Text:title];
    [superView addSubview:label2];
    
    UILabel *label3 = [LHController createLabelWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width, label2.frame.origin.y, WIDTH-label2.frame.origin.x-label2.frame.size.width-10, 20) Font:textFont-3 Bold:NO TextColor:colorOrangeRed Text:content];
    label3.textAlignment = NSTextAlignmentRight;
    [superView addSubview:label3];
    
    UILabel *fg = [[UILabel alloc] initWithFrame:CGRectMake(0, label2.frame.origin.y+label2.frame.size.height+10, WIDTH, 1)];
    fg.backgroundColor = colorLineGray;
    [superView addSubview:fg];
    if (superView == self.scrollView) {
        y = fg.frame.origin.y+fg.frame.size.height;
    }
}

#pragma mark - 第一部分
-(void)createOne{
    
    //姓名;
    NSArray *array1 = @[@"姓名:",@"年龄:",@"性别:",@"移动电话:",@"电子邮箱:",@"固定电话:",@"通讯地址:",@"车主职业:"];
    NSArray *array2 = @[@"请输入您的真实姓名，否则无法与厂家跟进协调",@"请输入您的真实年龄",@"选择性别",@"请输入您的手机号码",@"",@"",@"",@"",@""];
    for (int i = 0; i < array1.count; i ++) {
        UILabel *leftLabel = [LHController createLabelWithFrame:CGRectMake(LEFT, y+(SPACE+1)*i+3.5, WIDTH-LEFT*2, SPACE) Font:textFont Bold:NO TextColor:colorOrangeRed Text:@"*"];
        [self.scrollView addSubview:leftLabel];
        
        CGFloat width = [self getLenth:array1[i] andFont:textFont];
        
        UILabel *labelTile = [LHController createLabelWithFrame:CGRectMake(LEFT+20, y+(SPACE+1)*i, width, SPACE) Font:textFont Bold:NO TextColor:colorBlack Text:array1[i]];
        [self.scrollView addSubview:labelTile];
        
        UITextField *textField= [LHController createTextFieldWithFrame:CGRectMake(labelTile.frame.origin.x+labelTile.frame.size.width+10, labelTile.frame.origin.y, WIDTH-labelTile.frame.origin.x-width-LEFT, SPACE) Placeholder:array2[i] Font:textFont Delegate:self];
        [self.scrollView addSubview:textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelTile.frame.origin.y+labelTile.frame.size.height, WIDTH,1)];
        lineView.backgroundColor = colorLineGray;
        [self.scrollView addSubview:lineView];
        if (i > 3) {
            [leftLabel removeFromSuperview];
        }
        
        if (i == 0) {
            nameTextField = textField;
        }else if (i == 1){
            ageTextField = textField;
        }else if (i == 2){
            sexField = textField;
        }else if (i == 3){
            phoneTextField = textField;
        }else if (i == 4){
            emailTextField = textField;
        }else if (i == 5){
            callTextField = textField;
        }else if (i == 6){
            addressTextField = textField;
        }else{
            occupationTextField = textField;
            y = lineView.frame.origin.y;
        }
    }
}

#pragma mark - 第二部分
-(void)createTwo{
    
    NSArray *array1 = @[@"申诉车型:",@"发动机号:",@"车架号:",@"车牌号:",@"购车日期:",@"出现问题日期:",@"已行驶里程(km):",@"经销商名称:"];
    NSArray *array2 = @[@"",@"发动机号，可从您的行驶本上查找",@"车架号，可从您的行驶本上查找",@"请输入您的车牌号",@"选择购车日期",@"选择出问题日期",@"输入行驶里程",@""];
    
    for (int i = 0; i < array1.count; i ++) {
        UILabel *labelLeft = [LHController createLabelWithFrame:CGRectMake(LEFT, y+(SPACE+1)*i+3.5, 10, SPACE) Font:textFont Bold:NO TextColor:colorOrangeRed Text:@"*"];
        [self.scrollView addSubview:labelLeft];
        
        CGFloat width = [self getLenth:array1[i] andFont:textFont];
        UILabel *labelTitle = [LHController createLabelWithFrame:CGRectMake(LEFT+20, y, width, SPACE) Font:textFont Bold:NO TextColor:colorBlack Text:array1[i]];
        [self.scrollView addSubview:labelTitle];
        
        if (i == 0) {
            NSArray *arr1 = @[@"品牌：",@"车系：",@"车型："];
            NSArray *arr2 = @[@"选择品牌",@"选择车系",@"选择车型"];
            for (int j = 0; j < 3; j ++) {
                UILabel *starlabel = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, y+(SPACE-4)*j+SPACE+2.5, 10, SPACE-5) Font:textFont Bold:NO TextColor:colorOrangeRed Text:@"*"];
                [self.scrollView addSubview:starlabel];
                
                UILabel *labelName = [LHController createLabelWithFrame:CGRectMake(starlabel.frame.origin.x+10, y+(SPACE-4)*j+SPACE, 50, SPACE-5) Font:textFont Bold:NO TextColor:colorBlack Text:arr1[j]];
                [self.scrollView addSubview:labelName];
                
                UITextField *field = [LHController createTextFieldWithFrame:CGRectMake(labelName.frame.origin.x+labelName.frame.size.width, labelName.frame.origin.y, WIDTH-labelName.frame.origin.x-labelName.frame.size.width-LEFT-60,SPACE-5) Placeholder:arr2[j] Font:textFont Delegate:self];
                [self.scrollView addSubview:field];
                //自定义按钮
                UIButton *customBran = [LHController createButtnFram:CGRectMake(WIDTH-60-LEFT, labelName.frame.origin.y, 60, SPACE-5) Target:self Action:@selector(customClick:) Text:@"自定义"];
                customBran.titleLabel.font = [UIFont systemFontOfSize:textFont-3];
                [customBran setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
                [customBran setTitle:@"返回" forState:UIControlStateSelected];
                customBran.tag = 100+j;
                [self.scrollView addSubview:customBran];
               
                UIImageView *bgIg = [LHController createImageViewWithFrame:CGRectMake(0, 0, 50, 20) ImageName:@"appeal_customBtnBackImage"];
                [bgIg setContentMode:UIViewContentModeScaleAspectFill];
                bgIg.center = CGPointMake(customBran.frame.size.width/2, customBran.frame.size.height/2);
                [customBran addSubview:bgIg];
                //虚线
                UIView *lineA = [[UIView alloc] initWithFrame:CGRectMake(labelTitle.frame.origin.x, labelName.frame.origin.y+labelName.frame.size.height, WIDTH-labelName.frame.origin.x-LEFT, 1)];
                lineA.backgroundColor  = colorLineGray;
                [self.scrollView addSubview:lineA];
                
                if (j == 0) brandName = field;
                else if (j == 1) series = field;
                else {
                    model = field;
                    y += 12;
                }
            }
        }
        else if (i > 0 && i < 7) {
            
            labelLeft.frame = CGRectMake(LEFT,  y+(SPACE+1)*i+(SPACE-5)*3+3.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20,  y+(SPACE+1)*i+(SPACE-5)*3, width, SPACE);
            UITextField *textField = [LHController createTextFieldWithFrame:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10, labelTitle.frame.origin.y, WIDTH-labelTitle.frame.origin.x-labelTitle.frame.size.width-LEFT, SPACE) Placeholder:array2[i] Font:textFont Delegate:self];
            [self.scrollView addSubview:textField];
            if (i == 1) engine = textField;
            if (i == 2) carNum = textField;
            if (i == 3){
                province = [LHController createTextFieldWithFrame:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10,labelTitle.frame.origin.y, 40, SPACE) Placeholder:@"京" Font:textFont Delegate:self];
                province.text = @"京";
                province.rightViewMode = UITextFieldViewModeAlways;
                [self.scrollView addSubview:province];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 15, 15)];
                imageView.image = [UIImage imageNamed:@"appeal_triangle"];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
              //  [province addSubview:imageView];
                province.rightView = imageView;
                numberPlate = textField;
                numberPlate.frame = CGRectMake(province.frame.origin.x+province.frame.size.width+10, labelTitle.frame.origin.y, WIDTH-province.frame.origin.x-province.frame.size.width-LEFT, SPACE);
            }
            if (i == 4) dateBuy = textField;
            if (i == 5)dateBreakdown = textField;
            if (i == 6){
                mileage = textField;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            //虚线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelTitle.frame.origin.y+labelTitle.frame.size.height, WIDTH, 1)];
            lineView.backgroundColor = colorLineGray;
            [self.scrollView addSubview:lineView];
        }
        else {
            labelLeft.frame = CGRectMake(LEFT,  y+(SPACE+1)*i+(SPACE-5)*3+3.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20,  y+(SPACE+1)*i+(SPACE-5)*3, width, SPACE);
            //自定义按钮
            UIButton *customBran = [LHController createButtnFram:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10, labelTitle.frame.origin.y, 60, SPACE) Target:self Action:@selector(customClick:) Text:@"自定义"];
            
            UIImageView *bgIg = [LHController createImageViewWithFrame:CGRectMake(0, 0, 50, 20) ImageName:@"appeal_customBtnBackImage"];
            [bgIg setContentMode:UIViewContentModeScaleAspectFit];
            bgIg.center = CGPointMake(customBran.frame.size.width/2, customBran.frame.size.height/2);
            [customBran addSubview:bgIg];
            
            [customBran setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
            [customBran setTitle:@"返回" forState:UIControlStateSelected];
            customBran.titleLabel.font = [UIFont systemFontOfSize:textFont-3];
            customBran.tag = 103;
            [self.scrollView addSubview:customBran];
            
            CGFloat _yy = labelTitle.frame.origin.y+labelTitle.frame.size.height;
            UILabel *starhide = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, _yy+2.5, 10, SPACE) Font:textFont Bold:NO TextColor:colorOrangeRed Text:@"*"];
            [self.scrollView addSubview:starhide];
            
            hideBusinessName = [LHController createTextFieldWithFrame:CGRectMake(starhide.frame.origin.x+15, _yy, WIDTH-starhide.frame.origin.x-LEFT, SPACE) Placeholder:@"输入经销商名称" Font:textFont Delegate:self];
            [self.scrollView addSubview:hideBusinessName];
            
            UIView *hideLine = [[UIView alloc] initWithFrame:CGRectMake(starhide.frame.origin.x+10, hideBusinessName.frame.origin.y+hideBusinessName.frame.size.height+5, hideBusinessName.frame.size.width, 1)];
            hideLine.backgroundColor = colorLineGray;
            [self.scrollView addSubview:hideLine];
            
            BusinessNameSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, _yy, WIDTH, SPACE*2)];
            BusinessNameSuperView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:BusinessNameSuperView];
            
            UILabel *star1 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, 2.5, 10, SPACE-5) Font:textFont Bold:NO TextColor:colorOrangeRed Text:@"*"];
            [BusinessNameSuperView addSubview:star1];
            
            UILabel *starLabel1 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x+10, 0, 60, SPACE-5) Font:textFont Bold:NO TextColor:colorBlack Text:@"省、市:"];
            [BusinessNameSuperView addSubview:starLabel1];
            
            sheng_shi = [LHController createTextFieldWithFrame:CGRectMake(starLabel1.frame.origin.x+starLabel1.frame.size.width, starLabel1.frame.origin.y, WIDTH-starLabel1.frame.origin.x-starLabel1.frame.size.width-LEFT+10, SPACE-5) Placeholder:@"选择省份、市区" Font:textFont Delegate:self];
            [BusinessNameSuperView addSubview:sheng_shi];
            
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(labelTitle.frame.origin.x, starLabel1.frame.origin.y+starLabel1.frame.size.height, WIDTH-starLabel1.frame.origin.x-LEFT, 1)];
            line1.backgroundColor = colorLineGray;
            [BusinessNameSuperView addSubview:line1];
            
            UILabel *star2 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, SPACE-1.5, 10, SPACE-5) Font:textFont Bold:NO TextColor:colorOrangeRed Text:@"*"];
            [BusinessNameSuperView addSubview:star2];
            
            UILabel *starLabel2 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x+10, SPACE-4, 60, SPACE-5) Font:textFont Bold:NO TextColor:colorBlack Text:@"经销商:"];
            [BusinessNameSuperView addSubview:starLabel2];
            
            businessName = [LHController createTextFieldWithFrame:CGRectMake(starLabel2.frame.origin.x+starLabel2.frame.size.width, starLabel2.frame.origin.y, WIDTH-starLabel1.frame.origin.x-starLabel1.frame.size.width-LEFT+10, SPACE-5) Placeholder:@"选择经销商" Font:textFont Delegate:self];
            [BusinessNameSuperView addSubview:businessName];
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(labelTitle.frame.origin.x, starLabel2.frame.origin.y+starLabel2.frame.size.height, WIDTH-starLabel2.frame.origin.x-LEFT, 1)];
            line2.backgroundColor = colorLineGray;
            [BusinessNameSuperView addSubview:line2];
            
            y = BusinessNameSuperView.frame.origin.y+BusinessNameSuperView.frame.size.height;
        }
    }
     CGFloat imageShowWith = WIDTH-90-LEFT*2;
    UILabel *invoiceLabel = [self createLeftLabel:CGRectZero text:@"购车发票：" style:14];
    invoiceImageView = [[CZWShowImageView alloc] initWithFrame:CGRectMake(0, 0,imageShowWith, imageShowWith/3-5) ViewController:self];
    invoiceImageView.maxNumber = 1;
    UIView *invoiceLine = [UIView new];
    invoiceLine.backgroundColor = colorLineGray;
    __weak __typeof(self)weakSelf = self;
    __weak CZWShowImageView *weakShow = invoiceImageView;
    [invoiceImageView addImage:^(UIImage *image) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        __strong __typeof(weakShow) strongShow = weakShow;
        [strongSelf postImage:image fileName:BuyCarBill showView:strongShow];
    }];
    
    [self.scrollView addSubview:invoiceLabel];
    [self.scrollView addSubview:invoiceImageView];
    [self.scrollView addSubview:invoiceLine];
    
    [invoiceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LEFT);
       // make.top.equalTo(y+30);
        make.centerY.equalTo(invoiceImageView);
        make.width.equalTo(100);
    }];
    
    [invoiceImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(invoiceLabel.right);
        make.top.equalTo(y+10);
        make.size.equalTo(CGSizeMake(imageShowWith,  imageShowWith/3-5));
    }];
    [invoiceLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(invoiceImageView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    UILabel *drivingLabele = [self createLeftLabel:CGRectZero text:@"行驶证：" style:14];
    drivingImageView = [[CZWShowImageView alloc ]initWithFrame:CGRectMake(0, 0,imageShowWith, imageShowWith/3-5) ViewController:self];
    drivingImageView.maxNumber = 1;
    UIView *drivingLine = [UIView new];
    drivingLine.backgroundColor = colorLineGray;
 
    weakShow = drivingImageView;
    [drivingImageView addImage:^(UIImage *image) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        __strong __typeof(weakShow) strongShow = weakShow;
        [strongSelf postImage:image fileName:BuyCarBill showView:strongShow];

    }];
    
    [self.scrollView addSubview:drivingLabele];
    [self.scrollView addSubview:drivingImageView];
    [self.scrollView addSubview:drivingLine];
    
    [drivingLabele makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(invoiceLine.bottom).offset(40);
        make.centerY.equalTo(drivingImageView);
        make.left.equalTo(LEFT);
        make.width.equalTo(invoiceLabel);
    }];
    
    [drivingImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(invoiceLine.bottom).offset(10);
        make.left.equalTo(drivingLabele.right);
        make.size.equalTo(CGSizeMake(imageShowWith,  imageShowWith/3-5));
    }];
    
    [drivingLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(drivingImageView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];

    
    UILabel *listLabele = [self createLeftLabel:CGRectZero text:@"维修工单：" style:14];
    listImageView = [[CZWShowImageView alloc ]initWithFrame:CGRectMake(0, 0, imageShowWith,imageShowWith/3-5) ViewController:self];
    listImageView.maxNumber = 6;
    UIView *listLine = [UIView new];
    listLine.backgroundColor = colorLineGray;
    weakShow = listImageView;
    [listImageView addImage:^(UIImage *image) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        __strong __typeof(weakShow) strongShow = weakShow;
        [strongSelf postImage:image fileName:BuyCarBill showView:strongShow];

    }];
    
    [self.scrollView addSubview:listLabele];
    [self.scrollView addSubview:listImageView];
    [self.scrollView addSubview:listLine];
    
   [listLabele makeConstraints:^(MASConstraintMaker *make) {
//       make.top.equalTo(drivingLine.bottom).offset(40);
       make.centerY.equalTo(listImageView);
       make.left.equalTo(LEFT);
       make.width.equalTo(invoiceLabel);
   }];
    
    [listImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(drivingLine.bottom).offset(10);
        make.left.equalTo(listLabele.right);
        make.size.equalTo(CGSizeMake(imageShowWith,  imageShowWith/3-5));
    }];
    
    [listLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(listImageView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
}

#pragma mark - $$$$$$$$$
-(UILabel *)createLeftLabel:(CGRect)frame text:(NSString *)text style:(CGFloat)style{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:textFont];
    label.textColor = colorBlack;
    text = [NSString stringWithFormat:@"*%@",text];
    NSRange range = [text rangeOfString:@"*"];
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:text];
    [matt addAttribute:NSBaselineOffsetAttributeName value:@(-2) range:range];
    [matt addAttribute:NSForegroundColorAttributeName value:colorOrangeRed range:range];
    [matt addAttribute:NSKernAttributeName value:@(style) range:range];

    label.attributedText = matt;
    
    return label;
}

#pragma mark - 自定义点击按钮响应方法
-(void)customClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    btn.selected = !btn.selected;
    if (btn.tag == 100) {
        brandName.placeholder = @"请输入品牌";//品牌
        series.placeholder = @"请输入车系";//车系
        model.placeholder = @"请输入车型";//车型
        brandName.text = @"";//品牌
        series.text = @"";//车系1
        model.text = @"";//车型
        
        btn1.enabled = NO;
        btn2.enabled = NO;
        btn1.selected = NO;
        btn2.selected = NO;
        [btn1 setTitleColor:colorLightGray forState:UIControlStateNormal];
        [btn2 setTitleColor:colorLightGray forState:UIControlStateNormal];
        
        
        if (btn.selected == NO) {
            btn1.enabled = YES;
            btn2.enabled = YES;
            [btn1 setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
            [btn2 setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
            
            brandName.placeholder = @"选择品牌";//品牌
            series.placeholder = @"选择车系";//车系
            model.placeholder = @"选择型号";//车型
            
        }else{
            seriesId = @"";//车系
            modelId = @"";//车型
            brandId = @"";//大品牌
        }
        UIButton *customBtn = (UIButton *)[self.view viewWithTag:103];
        customBtn.selected = !btn.selected;
        [self customClick:customBtn];
        customBtn.enabled = !btn.selected;
        UIColor *color = customBtn.enabled?colorNavigationBarColor:colorLineGray;
        [customBtn setTitleColor:color forState:UIControlStateNormal];
        
    }else if (btn.tag == 101){
        series.placeholder = @"请输入车系";//车系
        model.placeholder = @"请输入车型";//车型
        series.text = @"";//车系
        model.text = @"";//车型
        
        btn2.enabled = NO;
        btn2.selected = NO;
        [btn2 setTitleColor:colorLightGray forState:UIControlStateNormal];
        
        if (btn.selected == NO) {
            btn2.enabled = YES;
            [btn2 setTitleColor:colorNavigationBarColor forState:UIControlStateNormal];
            
            // brandName.placeholder = @"请输入品牌";//品牌
            series.placeholder = @"选择车系";//车系
            model.placeholder = @"选择型号";//车型
        }
        if (btn.selected == YES) {
            seriesId = @"";//车系
            modelId = @"";//车型
        }
        
    }else if (btn.tag == 102){
        model.placeholder = @"请输入车型";//车型
        model.text = @"";//车型
        if (btn.selected == NO) {
            model.placeholder = @"选择车型";//车型
        }
        if (btn.selected == YES) {
            modelId = @"";//车型
        }
        
    }else{
        if (btn.selected == YES) {
            businessName.text = @"";
            sheng_shi.text = @"";
            provinceId = @"";//省份id
            _cityId = @"";//市
            businessId = @"";//经销商id
            BusinessNameSuperView.hidden = YES;
        }
        
        if (btn.selected == NO) {
            hideBusinessName.text = @"";
            BusinessNameSuperView.hidden = NO;
        }
    }
    
    if(btn.selected){
        businessId = @"";//经销商id
        businessName.text = @"";
    }
}

#pragma mark - 第三部分
-(void)createThree{
    
//    [self createHeaderWithY:y+20 ImageName:@"appeal_content" Title:@"投诉内容" Content:@"请务必如实、详细地描述完整的投诉信息。" superView:self.scrollView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = [UIImage imageNamed:@"appeal_content"];
    
    UILabel *label2 = [LHController createLabelWithFrame:CGRectZero Font:textFont+2 Bold:NO TextColor:colorBlack Text:@"申诉内容"];
   
    UILabel *label3 = [LHController createLabelWithFrame:CGRectZero Font:textFont-3 Bold:NO TextColor:colorOrangeRed Text:@"请务必如实、详细地描述完整的申诉信息。"];
   
    UIView *fg = [LHController createBackLineWithFrame:CGRectZero];
   
    [self.scrollView addSubview:imageView];
    [self.scrollView addSubview:label2];
    [self.scrollView addSubview:label3];
    [self.scrollView addSubview:fg];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listImageView.bottom).offset(30);
        make.left.equalTo(LEFT);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.right).offset(10);
        make.centerY.equalTo(imageView);
        
    }];
    
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.left.greaterThanOrEqualTo(label2.right);
        make.right.equalTo(self.view.right).offset(-10);
    }];
    
    [fg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(imageView.bottom).offset(10);
        make.size.equalTo(CGSizeMake(WIDTH, 1));
    }];
    
    
    NSArray *array1 = @[@"质量申诉部位:",@"问题描述:",@"申诉详情:"];
    UIView *tempView = nil;
    for (int i = 0; i < array1.count; i ++) {
        
        UILabel *labelTitle = labelTitle = [self createLeftLabel:CGRectZero text:array1[i] style:14];
        UIView *lineView = [LHController createBackLineWithFrame:CGRectZero];
        
        [self.scrollView addSubview:labelTitle];
        [self.scrollView addSubview:lineView];
        if (i == 0) {
            complainPart = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"请选择质量申诉部位" Font:textFont Delegate:self];
            [self.scrollView addSubview:complainPart];
            
            [labelTitle makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(LEFT);
                make.top.equalTo(fg.bottom);
                make.height.equalTo(SPACE);
            }];
            
            [complainPart makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(labelTitle.right).offset(5);
                make.top.equalTo(labelTitle);
                make.height.equalTo(SPACE);
                make.right.equalTo(self.view).offset(-10);
            }];

            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(complainPart.bottom);
                make.size.equalTo(CGSizeMake(WIDTH, 1));
            }];
            
        }else if (i == 1){

            describe = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"控制在24个汉字以内、仅限汉字、数字、字母" Font:textFont Delegate:self];
            [self.scrollView addSubview:describe];
         
            [labelTitle makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(LEFT);
                make.top.equalTo(tempView.bottom);
                make.height.equalTo(SPACE);
            }];
         
            [describe makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(LEFT+21.5);
                make.top.equalTo(labelTitle.bottom);
                make.height.equalTo(SPACE);
                make.right.equalTo(self.view).offset(-10);
             
            }];
            
            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(describe.bottom);
                make.size.equalTo(CGSizeMake(WIDTH, 1));
            }];
            
        }else{
           
            details = [[CZWIMInputTextView alloc] initWithFrame:CGRectZero];
            details.placeHolder = @"输入申诉详情";
            details.placeHolderTextColor = (UIColor *)[describe valueForKeyPath:@"_placeholderLabel.textColor"];
         
            details.delegate  = self;
            details.textColor = colorBlack;
            details.font = [UIFont systemFontOfSize:textFont];
            [self.scrollView addSubview:details];
            
            [labelTitle makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(LEFT);
                make.top.equalTo(tempView.bottom);
                make.height.equalTo(SPACE);
            }];
            
            [details makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(LEFT+17);
                make.top.equalTo(labelTitle.bottom);
                make.height.greaterThanOrEqualTo(details.font.lineHeight+details.font.pointSize);
                make.right.equalTo(self.view).offset(-10);
                
            }];
            
            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(details.bottom).offset(10);
                make.size.equalTo(CGSizeMake(WIDTH, 1));
            }];
        }
        
        tempView = lineView;
        
    }
    [self createFoot:tempView];
}

#pragma mark - 尾部视图创建
-(void)createFoot:(UIView *)tempview{
    
    //验证码
    test = [LHController createTextFieldWithFrame:CGRectZero Placeholder:@"输入验证码" Font:textFont Delegate:self];
    test.layer.borderColor = colorLineGray.CGColor;
    test.layer.borderWidth = 1;
    test.textAlignment = NSTextAlignmentCenter;
    test.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:test];
    
    testLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    testLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToGenerateCode:)];
    [testLabel addGestureRecognizer:tap];
    [self.scrollView addSubview:testLabel];
    
    UILabel *ts = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorDeepGray Text:@"看不清请点击验证码图片"];
    [self.scrollView addSubview:ts];
    
    //创建下一步按钮
    next = [LHController createButtnFram:CGRectZero Target:self Action:@selector(nextClick) Font:textFont+2 Text:@"提  交"];
    [self.scrollView addSubview:next];
    
    UILabel *labeltishi = [LHController createLabelWithFrame:CGRectZero Font:textFont-2 Bold:NO TextColor:colorOrangeRed Text:@"注：请认真填写，待网站审核后不能修改"];
    [self.scrollView addSubview:labeltishi];
    
    [listImageView layoutIfNeeded];
    UILabel *labelImage = [ LHController createLabelFont:textFont Text:@"车辆图片："  Number:1 TextColor:colorBlack];
    appealImageView = [[CZWShowImageView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(listImageView.frame),CGRectGetHeight(listImageView.frame)) ViewController:self];
    appealImageView.maxNumber = 6;
    __weak __typeof(self)weakSelf = self;
    __weak CZWShowImageView *weakShow = appealImageView;
    [appealImageView addImage:^(UIImage *image) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        __strong __typeof(weakShow) strongShow = weakShow;
        [strongSelf postImage:image fileName:CarImage showView:strongShow];

    }];

    [self.scrollView addSubview:labelImage];
    [self.scrollView addSubview:appealImageView];
    
    [labelImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LEFT+20);
        make.centerY.equalTo(appealImageView);
    }];
    
    [appealImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(drivingImageView);
        make.top.equalTo(tempview.bottom).offset(10);
        make.size.equalTo(CGSizeMake(CGRectGetWidth(listImageView.frame),CGRectGetHeight(listImageView.frame)));
    }];

    [test makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(appealImageView.bottom).offset(20);
        make.left.equalTo(details);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
    
    [testLabel makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(60, 30));
        make.left.equalTo(test.right).offset(10);
        make.top.equalTo(test);
    }];
    
    [ts makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(test);
        make.left.equalTo(testLabel.right).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [next makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(test.bottom).offset(20);
        make.size.equalTo(CGSizeMake(WIDTH-20, 40));
    }];
    
    [labeltishi makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(next.bottom).offset(5);
        make.left.equalTo(next);
        make.width.equalTo(next);
    }];
    
    [testLabel layoutIfNeeded];
   self.code = [LHController onTapToGenerateCode:testLabel];

}


-(void)onTapToGenerateCode:(UITapGestureRecognizer *)tap{
    self.code = [LHController onTapToGenerateCode:tap.view];
}

#pragma mark - 上传图片
//提交图片
-(void)postImage:(UIImage *)image fileName:(NSString *)name showView:(CZWShowImageView * )showView{
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        [CZWAFHttpRequest POSTImage:image url:auto_ULbackUrl fileName:name parameters:nil success:^(id responseObject) {
            [hud hideAnimated:YES];
           // NSLog(@"%@",responseObject);
            image.urlString = responseObject[@"imgUrl"];
            if (image.urlString.length == 0) {
                [CZWAlert alertDismiss:@"上传失败"];
                
                [showView.imageArray removeObject:image];
                [showView showImage];
            }
            
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            
        }];
}


#pragma mark - 提交按钮,点击发布
-(void)nextClick{
    
    if (![NSString isNotNULL:nameTextField.text]) {
        [self alertView:@"名字不能为空"];
        
    }else if ([ageTextField.text integerValue] < 10){
        [self alertView:@"年龄小于10岁"];
        
    }else if (sexField.text.length == 0){
        [self alertView:@"请选择性别"];
    }
    else if (![NSString isNumber:phoneTextField.text] || phoneTextField.text.length != 11 || ![NSString isNumber:phoneTextField.text]){
        [self alertView:@"手机号码输入不正确"];
        
    }else if (![NSString isNotNULL:brandName.text]){
        [self alertView:@"品牌不能为空"];
        
    }else if (![NSString isNotNULL:series.text]){
        [self alertView:@"车系不能为空"];
        
    }else if (![NSString isNotNULL:model.text]) {
        [self alertView:@"车型不能为空"];
        
    }else if ([NSString isNotNULL:engine.text] == NO){
        [self alertView:@"发动机号不能为空"];
        
    }else if ([NSString isNotNULL:carNum.text] == NO) {
        [self alertView:@"车架号不能为空"];
        
    }else if (![NSString isNotNULL:numberPlate.text] || numberPlate.text.length > 6 || ![NSString isPassword:numberPlate.text]) {
        [self alertView:@"车牌号只能是6位以内字母和数字组成的"];
        
    }
    else if (dateBuy.text.length == 0){
        [self alertView:@"请选择购车日期"];
        
    }else if (dateBreakdown.text.length == 0){
        [self alertView:@"请选择出现故障日期"];
        
    }else if (![NSString isDigital:mileage.text]){
        [self alertView:@"行驶里程只能为数字，请重新输入"];
    }
    else if (![NSString isNotNULL:businessName.text] && ![NSString isNotNULL:hideBusinessName.text]){
        [self alertView:@"经销商名称不能为空"];
    }
    else if (invoiceImageView.imageArray.count == 0){
        [self alertView:@"请上传购车发票照片"];
    }
    else if (drivingImageView.imageArray.count == 0){
        [self alertView:@"请上传你的行驶证"];
    }
    else if (listImageView.imageArray.count == 0){
         [self alertView:@"请上传至少一张维修工单"];
    }
    else if (![NSString isNotNULL:complainPart.text]){
        [self alertView:@"请选择申诉部位"];
    }
    else if(![NSString isNotNULL:describe.text] || describe.text.length > 20){
        [self alertView:@"问题描述不能为空并且不能大于20个汉字"];
        
    }else if (![NSString isNotNULL:details.text]){
        [self alertView:@"申诉详情不能为空"];
       
    }else if (![test.text isEqualToString:self.code]){
        [self alertView:@"验证码输入错误"];
    }
    else{
  
        [self createData];
    }
}

#pragma mark - 建立数据字典
-(void)createData{

    [self.view endEditing:YES];
    
    NSMutableDictionary *superDict = [[NSMutableDictionary alloc] init];
    [superDict setObject:@"0" forKey:@"Cpid"];
    if (self.dictionary[@"cpid"]) {
        [superDict setObject:self.dictionary[@"cpid"] forKey:@"Cpid"];
    }
    
    [superDict setObject:nameTextField.text forKey:@"Name"];//姓名
    [superDict setObject:ageTextField.text forKey:@"Age"];//年龄
    [superDict setObject:sexField.text forKey:@"Sex"];//性别
    [superDict setObject:phoneTextField.text forKey:@"Mobile"];//手机号
    [superDict setObject:emailTextField.text forKey:@"Email"];//邮箱
    [superDict setObject:callTextField.text forKey:@"Telephone"];//座机
    [superDict setObject:addressTextField.text forKey:@"Address"];//街道地址
    [superDict setObject:occupationTextField.text forKey:@"Occupation"];//职位
    
    if(brandId.length == 0)
         [superDict setObject:brandName.text forKey:@"Autoname"];//品牌
    else
        [superDict setObject:brandId forKey:@"BrandId"];
    
    if (seriesId.length == 0)
         [superDict setObject:series.text forKey:@"Autopart"];//车系
    else
        [superDict setObject:seriesId forKey:@"SeriesId"];
    
    if (modelId.length == 0)
        [superDict setObject:model.text forKey:@"Autostyle"];//车型
    else
        [superDict setObject:modelId forKey:@"ModelId"];
    
    [superDict setObject:engine.text forKey:@"Engine_Number"];//发动机号
    [superDict setObject:carNum.text forKey:@"Carriage_Number"];//车架号
    [superDict setObject:[NSString stringWithFormat:@"%@^%@",province.text,numberPlate.text] forKey:@"AutoSign"];//车牌号
    [superDict setObject:dateBuy.text forKey:@"Buyautotime"];//购车日期
    [superDict setObject:dateBreakdown.text forKey:@"Questiontime"];//出现故障日期
    [superDict setObject:mileage.text forKey:@"mileage"];//行驶里程
    
    [superDict setObject:hideBusinessName .text forKey:@"Buyname"];//自定义经销商名
    [superDict setObject:businessName.text forKey:@"Disname"];//经销商名
    [superDict setObject:businessId forKey:@"Disid"];//经销商id
    
    [superDict setObject:complainPart.text forKey:@"C_Tsbw"];//投诉部位
    [superDict setObject:describe.text forKey:@"Question"];//标题
    [superDict setObject:details.text forKey:@"Content"];//内容
    
    [superDict setObject:[CZWManager manager].roleId forKey:@"User_ID"];
    [superDict setObject:[CZWManager manager].roleName forKey:@"User_Name"];
    
    [superDict setObject:@"0" forKey:@"Complain_Mark"];
    [superDict setObject:@"0" forKey:@"Show"];
    [superDict setObject:@"0" forKey:@"IsIndex"];
    [superDict setObject:@"1" forKey:@"origin"];//入口标识

    //发票
    NSString *buycarbillString = @"";
    for (UIImage *image in invoiceImageView.imageArray) {
        if (buycarbillString.length) {
            buycarbillString = [NSString stringWithFormat:@"%@||%@",buycarbillString,image.urlString];
        }else{
            buycarbillString = image.urlString;
        }
    }
    //行驶证
    NSString *drivinglicenseString = @"";
    for (UIImage *image in drivingImageView.imageArray) {
        if (drivinglicenseString.length) {
            drivinglicenseString = [NSString stringWithFormat:@"%@||%@",drivinglicenseString,image.urlString];
        }else{
            drivinglicenseString = image.urlString;
        }
    }

    //维修工单
    NSString *repairorderString = @"";
    for (UIImage *image in listImageView.imageArray) {
        if (repairorderString.length) {
            repairorderString = [NSString stringWithFormat:@"%@||%@",repairorderString,image.urlString];
        }else{
            repairorderString = image.urlString;
        }
    }

    //申诉图片
    NSString * imageSting = @"";
    for (UIImage *image in appealImageView.imageArray) {
        if (imageSting.length) {
            imageSting = [NSString stringWithFormat:@"%@||%@",imageSting,image.urlString];
        }else{
            imageSting = image.urlString;
        }
    }

  
    if (buycarbillString) {
          [superDict setObject:buycarbillString forKey:@"buycarbill"];
    }
    if(drivinglicenseString){
        [superDict setObject:drivinglicenseString forKey:@"drivinglicense"];
    }
    if (repairorderString) {
         [superDict setObject:repairorderString forKey:@"repairorder"];
    }
    if (imageSting) {
        [superDict setObject:imageSting forKey:@"Image"];
    }
    
    
    next.enabled = NO;
    next.backgroundColor = colorLineGray;
    
   [self.view endEditing:YES];
    [self postData:superDict];
}

#pragma mark - 提交数据
-(void)postData:(NSDictionary *)dic{
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
   [CZWAFHttpRequest POST:user_appeal parameters:dic success:^(id responseObject) {
       [hud hideAnimated:YES];
       next.enabled = YES;
       next.backgroundColor = colorNavigationBarColor;
       
       if ([responseObject count] == 0) {
           return ;
       }
       NSDictionary *resultDict = [responseObject firstObject];
       
       if (resultDict[@"error"]) {
           [self alertView:resultDict[@"error"]];
       }else{
           
           [self alertView:resultDict[@"scuess"]];
           [self.navigationController popViewControllerAnimated:YES];
       }

   } failure:^(NSError *error) {
       [self alertView:@"申述提交失败"];
       next.enabled = YES;
       next.backgroundColor = colorNavigationBarColor;
       [hud hideAnimated:YES];

   }];
}

#pragma mark - alert信息提示语
-(void)alertView:(NSString *)str{
    
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [al dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITxetField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.scrollContentY = textField.frame.origin.y+textField.frame.size.height;
    
    if (textField == sexField) {
       
        LHPickerView *picker = [[LHPickerView alloc] initWithStyle:LHpickerStyleSex];
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
      
        [picker showPickerView];
        [picker returnResult:^(NSString *title, NSString *ID) {
            textField.text = title;
        }];
        [self.view endEditing:YES];
        return NO;
    }
    if (textField == ageTextField) {
        ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (textField == phoneTextField) {
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (textField == addressTextField) {
        emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    if (textField == test) {
        
    }
    
    //如果是车牌号
    if (textField == province) {
        LHPickerView *picker = [[LHPickerView alloc] initWithStyle:LHpickerStyleAbbreviation];
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        [picker showPickerView];
        [picker returnResult:^(NSString *title, NSString *ID) {
            textField.text = title;
        }];
        [self.view endEditing:YES];
        return NO;
    }
    //如果是投诉类型
    if (textField == brandName) {
        //是否自定义
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        if (btn.selected) {
            return YES;
        }
        [self.view endEditing:YES];
        [self chooseViewController:textField];
        return NO;
    }
    //投诉车系
    if (textField == series) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
        if (btn1.selected || btn2.selected) {
            return YES;
        }
        [self.view endEditing:YES];
        if (brandId.length > 0) {
            [self chooseViewController:textField];
        }else{
            [self alertView:@"还未选择品牌"];
        }
        
        return NO;
    }
    //车型
    if (textField == model) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
        UIButton *btn3 = (UIButton *)[self.view viewWithTag:102];
        if (btn1.selected || btn2.selected || btn3.selected) {
            return YES;
        }
        [self.view endEditing:YES];
        
        //       NSString *str = [NSString stringWithUTF8String:object_getClassName(seriesId)];
        if ([seriesId floatValue] > 0) {
            [self chooseViewController:textField];
        }else{
            [self alertView:@"还未选择车系"];
        }
        
        return NO;
    }
    //购买时间
    if (textField == dateBuy) {
        
        [self createDatePicerView:dateBuy];
        [self.view endEditing:YES];
        return NO;
    }else if(textField == dateBreakdown){
        [self createDatePicerView:dateBreakdown];
        [self.view endEditing:YES];
        return NO;
    }
    //省市选择
    if (textField == sheng_shi) {
        CityChooseViewController *city = [[CityChooseViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:city];
        [city returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
            if ([pName isEqualToString:cName]) {
                textField.text = pName;
            }else{
                textField.text = [NSString stringWithFormat:@"%@%@",pName,cName];
            }
            provinceId = pid;
            _cityId = cid;
        }];
        [self.view endEditing:YES];
        [self presentViewController:nvc animated:YES completion:nil];
        return NO;
    }
    //经销商
    if (textField == businessName) {
        [self.view endEditing:YES];
        if (_cityId.length) {
            [self chooseViewController:textField];
        }else{
            [self alertView:@"还未选择省、市"];
        }
        return NO;
    }
    //
    if (textField == complainPart || textField == complainServer) {
        [self.view endEditing:YES];
        [self chooseViewController:textField];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == describe) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (describe.text.length + string.length > 20) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"问题描述不能超过20个汉字"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
            [al show];
            return NO;
        }
    }
    return YES;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == details) {
        [details layoutIfNeeded];
        CGSize size = [textView.text calculateTextSizeWithFont:textView.font Size:CGSizeMake(details.frame.size.width, 200)];
        
        NSInteger lines = size.height/textView.font.lineHeight;
        lines = lines <= 3?lines:3;
        [details updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(lines*textView.font.lineHeight+textView.font.pointSize);
        }];
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //  doneBt.hidden = YES;
    self.scrollContentY = details.frame.origin.y+details.frame.size.height;
    return YES;
}



#pragma mark - 选择列表
-(void)chooseViewController:(UITextField *)field{
    ChooseViewController *choose = [[ChooseViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:choose];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    [choose retrunResults:^(NSString *title, NSString *ID) {
        field.text = title;
        
        if (field == brandName) {
            brandId = ID;
            seriesId = modelId =businessId = @"";
            series.text = model.text = businessName.text = @"";
        }else if (field == series){
            seriesId = ID;
            modelId =businessId = @"";
            model.text = businessName.text = @"";
        }else if (field == model){
            modelId = ID;
            businessId = @"";
            businessName.text = @"";
        }else if (field == complainPart){
            
        }else if (field == businessName){
            businessId = ID;
        }
    }];
    if (field == brandName) {
        choose.choosetype = chooseTypeBrand;
    }else if (field == series){
        choose.ID = brandId;
        choose.choosetype = chooseTypeSeries;
        
    }else if (field == model){
        choose.ID = seriesId;
        choose.choosetype = chooseTypeModel;
        
    }else if (field == complainPart){
        choose.choosetype = chooseTypeComplainQuality;
        
    }else if (field == complainServer){
        choose.choosetype = chooseTypeComplainService;
    }
    else if (field == businessName){
        choose.ID = provinceId;
        choose.cityId = _cityId;
        choose.seriesId = seriesId;
        choose.choosetype = chooseTypeBusiness;
    }
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - 创建时间选择控件
-(void)createDatePicerView:(UITextField *)field{
    if (_datePicer == nil) {
        _datePicer = [[LHDatePickView alloc] init];
        _datePicer.minimumDate = @"2005-01-01";
        [[UIApplication sharedApplication].keyWindow addSubview:_datePicer];
    }
    _datePicer.minimumDate = dateBuy.text.length>0?dateBuy.text:@"2005-01-01";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    if (field == dateBuy) {
        _datePicer.titleText = @"购车日期";
        _datePicer.minimumDate = @"2005-01-01";
        _datePicer.maximumDate = dateBreakdown.text.length > 0 ? dateBreakdown.text:dateString;
    }else if (field == dateBreakdown){
        _datePicer.titleText = @"出故障日期";
        _datePicer.maximumDate = dateBuy.text.length > 0 ? dateBuy.text:@"2005-01-01";
        _datePicer.maximumDate = dateString;
    }
    [_datePicer returnDate:^(NSString *date) {
        field.text = date;
    }];
    _datePicer.hidden = NO;
    [_datePicer showDatePicerView];
}

#pragma mark - 空白收回键盘/手势

-(void)createTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.scrollView addGestureRecognizer:tap];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    
    [self.view endEditing:YES];
}



#pragma mark - 获取用户信息
-(void)usercar:(NSDictionary *)dicCar{

    nameTextField.text = dicCar[@"rname"];
    sexField.text = [dicCar[@"sex"] isEqualToString:@"1"]?@"男":@"女";
  
    ageTextField.text = [self age:dicCar[@"birth"]];//年龄
    phoneTextField.text = dicCar[@"mobile"];//手
    emailTextField.text = dicCar[@"email"];//邮
    callTextField.text = dicCar[@"phone"];//手机
    
    brandName.text = dicCar[@"brandName"];//品牌
    brandId = dicCar[@"brand"];
    series.text = dicCar[@"seriesName"];//车系
    seriesId = dicCar[@"series"];
    model.text = dicCar[@"modelName"];//车型
    modelId = dicCar[@"model"];
    
    engine.text = dicCar[@"engineNumber"];//发动
    carNum.text = dicCar[@"carriageNumber"];//车架
    NSArray *arr = [dicCar[@"autosign"] componentsSeparatedByString:@"^"];
    if (arr.count == 2) {
        province.text = arr[0];
        numberPlate.text = arr[1];
    }
}

#pragma mark - 下载用户数据
-(void)loadCar{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest requestInfoWithId:[CZWManager manager].roleId type:CCUserType_User success:^(id responseObject) {
      
        [hud hideAnimated:YES];
        
        if ([responseObject count] == 0) {
            return ;
        }
        [self usercar:[responseObject firstObject]];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

//赋值
-(void)fuzhi{
    ageTextField.text = _dictionary[@"age"];
    nameTextField.text = _dictionary[@"uname"];
    sexField.text = _dictionary[@"sex"];
    
    phoneTextField.text = _dictionary[@"mobile"];//手
    emailTextField.text = _dictionary[@"email"];//邮
    callTextField.text = _dictionary[@"phone"];//
    addressTextField.text = _dictionary[@"address"];
    occupationTextField.text = _dictionary[@"occ"];
    
    brandName.text = self.dictionary[@"brand"];//品牌
    brandId = _dictionary[@"brandId"];
    series.text = self.dictionary[@"series"];//车系
    seriesId = _dictionary[@"seriesId"];
    model.text = self.dictionary[@"model"];//车型
    modelId = _dictionary[@"modelId"];
    engine.text = _dictionary[@"engine"];//发动
    carNum.text = _dictionary[@"carriage"];//车架
    
    if ([self.dictionary[@"sign"] length] > 0) {
        province.text = [self.dictionary[@"sign"] substringToIndex:1];//车牌省份
        numberPlate.text = [self.dictionary[@"sign"] substringFromIndex:1];//车牌省份
        
    }
    
    dateBuy.text = _dictionary[@"buytime"];//购车
    dateBreakdown.text = _dictionary[@"issuetime"];
    mileage.text = _dictionary[@"mileage"];
    
    if ([self.dictionary[@"lid"] length] > 0) {
        if ([_dictionary[@"pro"] isEqualToString:_dictionary[@"city"]]) {
            sheng_shi.text = _dictionary[@"city"];
        }else{
            sheng_shi.text = [NSString stringWithFormat:@"%@、%@",_dictionary[@"pro"],_dictionary[@"city"]];
        }
        provinceId = _dictionary[@"pid"];
        _cityId = _dictionary[@"cid"];
        businessId = _dictionary[@"lid"];
        businessName.text = _dictionary[@"lname"];
    }else{
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:103];
        [self customClick:btn];
        hideBusinessName.text = _dictionary[@"lname"];
    }
    
    complainPart.text = _dictionary[@"tsbw"];
  //  complainServer.text = _dictionary[@"tsfw"];
    describe.text = _dictionary[@"question"];
    details.text = _dictionary[@"content"];
    [self textViewDidChange:details];

    invoiceImageView.imageUrlArray = [self.dictionary[@"BuyImage"] componentsSeparatedByString:@"||"];//发票
    listImageView.imageUrlArray = [self.dictionary[@"RepairImage"] componentsSeparatedByString:@"||"];//维修工单
    drivingImageView.imageUrlArray = [self.dictionary[@"DrivingImage"] componentsSeparatedByString:@"||"];//行驶证
    appealImageView.imageUrlArray = [self.dictionary[@"image"] componentsSeparatedByString:@"||"];//申诉图片
}


-( NSString *)age:(NSString *)str{
    
    if (str.length == 0) {
        return @"";
    }
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:str];
    
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *Time = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: Time];
    NSDate *localeDate = [Time  dateByAddingTimeInterval: interval];
    
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    
    NSInteger iYears = intervalTime/60/60/24/365;
    
    return [NSString stringWithFormat:@"%ld",iYears];
}

#pragma mark - 修改投诉时加载数据
-(void)loadUserData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *url = [NSString stringWithFormat:user_appealDelails,self.cpid];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        [hud hideAnimated:YES];
        self.dictionary = responseObject;
        [self fuzhi];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
