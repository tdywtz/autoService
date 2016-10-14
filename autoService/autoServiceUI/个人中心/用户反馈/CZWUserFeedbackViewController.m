//
//  CZWUserFeedbackViewController.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWUserFeedbackViewController.h"
#import "CZWIMInputTextView.h"
#import "LHAssetPickerController.h"
#import "CZWTextField.h"

@interface TempTextField : UITextField
@property (nonatomic, copy) NSString *placeHoldertext;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title Font:(CGFloat)font;
@end

@implementation TempTextField

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title Font:(CGFloat)font
{
    self = [super initWithFrame:frame];
    if (self) {
       
 
        UILabel *label = [LHController createLabelWithFrame:CGRectZero Font:font Bold:NO TextColor:colorBlack Text:title];
        label.textAlignment = NSTextAlignmentRight;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //设置显示左侧视图
        self.leftViewMode = UITextFieldViewModeAlways;
        [self setLeftView:label];
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.font = [UIFont systemFontOfSize:font];
        self.textColor = colorBlack;
    
        [self setup];
    }
    return self;
}


- (void)setPlaceHolder:(NSString *)placeHolder {
    if([placeHolder isEqualToString:_placeHoldertext]) {
        return;
    }
    
    _placeHoldertext = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    if([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }
    
    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

#pragma mark - Text view overrides

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
    
}


//- (void)setContentInset:(UIEdgeInsets)contentInset {
//    [super setContentInset:contentInset];
//    [self setNeedsDisplay];
//}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}


#pragma mark - Life cycle

- (void)setup {
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
    
    _placeHolderTextColor = colorLightGray;
   // self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.font = [UIFont systemFontOfSize:15.0f];
    self.textColor = colorBlack;
//    self.backgroundColor = [UIColor clearColor];
//    self.keyboardAppearance = UIKeyboardAppearanceDefault;
//    self.keyboardType = UIKeyboardTypeDefault;
//    self.returnKeyType = UIReturnKeyDefault;
//    self.textAlignment = NSTextAlignmentLeft;
}

- (void)dealloc {
    _placeHoldertext = nil;
    _placeHolderTextColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
    UILabel *label = (UILabel *)self.leftView;
    CGSize size = [NSString calculateTextSizeWithText:label.text Font:15 Size:CGSizeMake(100, 20)];
    label.frame = CGRectMake(0, 0, 15+size.width, self.frame.size.height);
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条底部线
    CGContextSetRGBStrokeColor(context, 229/255.0,  229/255.0, 229/255.0, 1);//线条颜色
    CGContextMoveToPoint(context, 0, rect.size.height-1);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height-1);
    CGContextStrokePath(context);
    
    if([self.text length] == 0 && self.placeHoldertext) {
        CGRect placeHolderRect = CGRectMake(self.leftView.bounds.size.width,
                                            0.0f,
                                            rect.size.width-self.leftView.bounds.size.width-self.rightView.bounds.size.width,
                                            rect.size.height);
        CGSize size = [self.placeHoldertext boundingRectWithSize:CGSizeMake(placeHolderRect.size.width, placeHolderRect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        placeHolderRect.origin.y = (rect.size.height-size.height)/2;
        placeHolderRect.size.height = size.height;

        
        [self.placeHolderTextColor set];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
    
        [self.placeHoldertext drawInRect:placeHolderRect
                          withAttributes:@{NSFontAttributeName : self.font,NSForegroundColorAttributeName : self.placeHolderTextColor,
                                           NSParagraphStyleAttributeName : paragraphStyle }];
    }
}

@end

///88888888

@interface CZWUserFeedbackViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CZWIMInputTextView  *_textView;
    UIButton            *addImageButton;
    UIView              *imageBackView;
    TempTextField         *nameTextField;
    TempTextField         *emailTextField;
    TempTextField         *phoneTextField;
    TempTextField         *QQTextField;
    UIButton              *submitButton;
    CGFloat textFont;
    CGRect  addStartFrame;
    
    NSMutableArray *imageArray;
}
@end

@implementation CZWUserFeedbackViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        textFont = [LHController setFont]-2;
        imageArray = [[NSMutableArray alloc] init];
        self.title = @"用户反馈";
    }
    return self;
}

-(void)loadData{
    if ([[CZWManager manager].RoleType isEqualToString:isUserLogin]) {
        [CZWHttpModelResults requestUserInfoWithUserId:[CZWManager manager].roleId result:^(CZWUserInfoUser *userInfo) {
            if (userInfo) {
                emailTextField.text = userInfo.email;
                phoneTextField.text = userInfo.mobile;
                QQTextField.text    = userInfo.qq;
            }
           
        }];
    }else{
        [CZWHttpModelResults requestExpertInfoWithExpertId:[CZWManager manager].roleId result:^(CZWUserInfoExpert *userInfo) {
            if (userInfo) {
                emailTextField.text = userInfo.email;
                phoneTextField.text = userInfo.mobile;
                //QQTextField.text    = userInfo.qq;
            }
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
   
    [self createLeftItemBack];
    [self createScrollView];
    [self createUI];
    [self loadData];

    self.automaticallyAdjustsScrollViewInsets = YES;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [submitButton layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, submitButton.frame.origin.y+submitButton.frame.size.height+40);
}


-(void)createUI{
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 15, 200, 20) Font:textFont Bold:NO TextColor:colorBlack Text:@"反馈内容："];
    [self.scrollView addSubview:label];
    
    [self.scrollView addSubview:[LHController createBackLineWithFrame:CGRectMake(0, 45, WIDTH, 1)]];
    
    _textView = [[CZWIMInputTextView alloc] initWithFrame:CGRectMake(10, 50, WIDTH-20, 100)];
    // _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:textFont];
    _textView.textColor = colorBlack;
    [self.scrollView addSubview:_textView];
    _textView.placeHolder = @"如果您对汽车三包申诉客户端有什么好的建议或者您在使用过程中遇到任何问题都可以告诉我们，我们会尽快改进";
    _textView.autoresizingMask = UIViewAutoresizingNone;
    
    [self.scrollView addSubview:[LHController createBackLineWithFrame:CGRectMake(0, _textView.frame.origin.y+_textView.frame.size.height+5, WIDTH, 1)]];
    
    CGFloat width = (WIDTH-100)/3-10;
    imageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.frame.origin.y+_textView.frame.size.height+25, WIDTH, width)];
    [self.scrollView addSubview:imageBackView];
    
    [imageBackView addSubview:[LHController createLabelWithFrame:CGRectMake(15, width/2-10, 100, 20) Font:textFont Bold:NO TextColor:colorBlack Text:@"上传图片："]];
  
    addImageButton = [LHController createButtnFram:CGRectMake(100, 0, width, width) Target:self Action:@selector(addImageClick) Text:nil];
    [addImageButton setImage:[UIImage imageNamed:@"auto_addImage"] forState:UIControlStateNormal];
    [imageBackView addSubview:addImageButton];
    
    addStartFrame = addImageButton.frame;
    
    
    UIView *line = [LHController createBackLineWithFrame:CGRectZero];
    [self.scrollView addSubview:line];
    
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageBackView]-20-[line(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageBackView,line)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line(imageBackView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageBackView,line)]];
    

    
    nameTextField = [[TempTextField alloc] initWithFrame:CGRectZero title:@"用户名：" Font:15];
    nameTextField.delegate = self;
    nameTextField.enabled = NO;
    nameTextField.text = [CZWManager manager].roleName;
    [self.scrollView addSubview:nameTextField];
    
    nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line]-0-[nameTextField(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line,nameTextField)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameTextField(line)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line,nameTextField)]];

    
//    NSArray* constrains2 = self.view.constraints;
//    [userButton layoutIfNeeded];
//    NSLog(@"%f",userButton.frame.origin.y);
//    for (NSLayoutConstraint* constraint in constrains2) {
//        NSLog(@"%@",constraint.firstItem);
//        NSLog(@"======%@",constraint.secondItem);
//        //        if (constraint.secondItem == self.tableView) {
//        //            //据底部0
//        //            if (constraint.firstAttribute == NSLayoutAttributeBottom) {
//        //                constraint.constant = 0.0;
//        //
//        //            }
//        //        }
//    }

    emailTextField = [[TempTextField alloc] initWithFrame:CGRectZero title:@"Email：" Font:15];
    emailTextField.placeHoldertext = @"我们会及时把处理结果发送到你的邮箱！请注意查收哦！";
    emailTextField.delegate = self;
    [self.scrollView addSubview:emailTextField];
    
    emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameTextField]-0-[emailTextField(nameTextField)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nameTextField,emailTextField)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emailTextField]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(emailTextField)]];

    phoneTextField = [[TempTextField alloc] initWithFrame:CGRectZero title:@"手机号：" Font:15];
    phoneTextField.placeHoldertext = @"方便的话请留下手机号码，我们会及时把处理结果反馈给您！";
    phoneTextField.delegate = self;
    [self.scrollView addSubview:phoneTextField];
    
    phoneTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailTextField]-0-[phoneTextField(emailTextField)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(emailTextField,phoneTextField)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[phoneTextField(emailTextField)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(emailTextField,phoneTextField)]];
    
    QQTextField = [[TempTextField alloc] initWithFrame:CGRectZero title:@"QQ号：" Font:15];
    QQTextField.placeHoldertext = @"方便的话请留下QQ号，我们会及时把处理结果反馈给您！";
    QQTextField.delegate = self;
    [self.scrollView addSubview:QQTextField];
    
    QQTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[phoneTextField]-0-[QQTextField(phoneTextField)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(phoneTextField,QQTextField)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[QQTextField]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(QQTextField)]];
    
    
     submitButton = [LHController createButtnFram:CGRectZero Target:self Action:@selector(submitClick) Font:[LHController setFont]-2 Text:@"提交反馈"];
    [self.scrollView addSubview:submitButton];
    
    submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[QQTextField]-20-[submitButton(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(QQTextField,submitButton)]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[submitButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(submitButton)]];
}



-(void)addImageClick{
    [self.view endEditing:NO];
    CZWActionSheet *sheet = [[CZWActionSheet alloc] initWithArray:@[@"拍照",@"从相册选择",@"取消"]];
    [sheet choose:^(CZWActionSheet *actionSheet, NSInteger selectedIndex) {
        actionSheet = nil;
        if (selectedIndex == 1) {
      
            [self LHPicker];
            
        }else if (selectedIndex == 0){

            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }];
    [sheet show];
}


//
-(void)LHPicker{
    LHAssetPickerController *picker = [[LHAssetPickerController alloc] init];
    picker.maxNumber = 6-imageArray.count;
    
    [picker getAssetArray:^(NSArray *assetArray) {
        for (ALAsset *asset in assetArray) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            image = [[UIImage alloc ] initWithData:UIImageJPEGRepresentation(image, 0.5)];
            [imageArray addObject:image];
        }
        assetArray = nil;
        [self showImage];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 改变图片尺寸
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
   
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    img = nil;
    return scaledImage;
}

-(void)showImage{
    for (UIView *view in imageBackView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
             [view removeFromSuperview];
        }
    }
    for (int i = 0; i < imageArray.count; i ++) {
        CGFloat oox = addStartFrame.origin.x+(i%3)*(addStartFrame.size.width+5);
        CGFloat ooy = addStartFrame.origin.y+(i/3)*(addStartFrame.size.height+5);
        UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(oox, ooy, addStartFrame.size.width, addStartFrame.size.height)];
        iamgeView.image = imageArray[i];
        iamgeView.userInteractionEnabled = YES;
        [imageBackView addSubview:iamgeView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(iamgeView.frame.size.width-19, 3, 16, 16);
        [btn setImage:[UIImage imageNamed:@"auto_redDeleteIamge"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [iamgeView addSubview:btn];
        
        if (i == imageArray.count-1) {
            NSInteger count = i+1;
            if (count == 6) {
                count--;
            }
            addImageButton.frame = CGRectMake(addStartFrame.origin.x+count%3*(addStartFrame.size.width+5), addStartFrame.origin.y+count/3*(addStartFrame.size.height+5), addStartFrame.size.width, addStartFrame.size.height);
            
            
            
            CGRect rect = imageBackView.frame;
            rect.size.height = addImageButton.frame.origin.y+addImageButton.frame.size.height;
            imageBackView.frame = rect;
         
        }
    }
    
    if (imageArray.count == 0) {
        addImageButton.frame = addStartFrame;
    }
    if (imageArray.count == 6) {
        addImageButton.hidden = YES;
    }else{
        addImageButton.hidden = NO;
    }
}

-(void)deleteImage:(UIButton *)btn{
    UIImageView *imageView = (UIImageView *)btn.superview;
    [imageArray removeObject:imageView.image];
    [self showImage];
}
-(void)submitClick{
    NSString *content = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0) {
        [CZWAlert alertDismiss:@"内容不能为空"];
        return;
    }
    if (![NSString isEmailTest:emailTextField.text]) {
        [CZWAlert alertDismiss:@"邮箱格式不正确"];
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[CZWManager manager].roleId forKey:@"uid"];
    [dict setObject:[CZWManager manager].userType forKey:@"type"];
    [dict setObject:[CZWManager manager].roleName forKey:@"username"];
   
    [dict setObject:content forKey:@"contents"];
    [dict setObject:emailTextField.text forKey:@"email"];
    
    NSString *phone = phoneTextField.text?phoneTextField.text:@"";
    NSString *QQ = QQTextField.text?QQTextField.text:@"";
    [dict setObject:phone forKey:@"telephone"];
    [dict setObject:QQ forKey:@"qq"];
    [dict setObject:appEntrance forKey:@"origin"];
    
   // NSLog(@"%@",dict);
    [self submitData:dict];
}

-(void)submitData:(NSDictionary *)dict{
    //加载提示
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CZWAFHttpRequest POST:auto_feedback parameters:dict images:imageArray success:^(id responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject count] == 0)return ;
        if (responseObject[0][@"error"]) {
            [CZWAlert alertDismiss:responseObject[0][@"error"]];
        }else{
            [CZWAlert alertDismiss:responseObject[0][@"scuess"]];
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
    }];
}

#pragma mark - 导航条代理
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

#pragma mark - imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.5)];
    [imageArray addObject:image];
    [self showImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.scrollContentY = textField.frame.origin.y+textField.frame.size.height;
  
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
