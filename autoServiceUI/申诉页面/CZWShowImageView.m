//
//  CZWShowImageView.m
//  autoService
//
//  Created by bangong on 16/3/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWShowImageView.h"
#import "LHAssetPickerController.h"
#import "EditImageViewController.h"
#import <objc/runtime.h>

@implementation UIImage (Custom)

-(void)setUrlString:(NSString *)urlString{
     objc_setAssociatedObject(self,@"urlString",urlString,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)urlString{
      return objc_getAssociatedObject(self,@"urlString");
}

@end

@interface CZWShowImageView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *addButton;
    UIImagePickerController *myPicker;
}
@property (nonatomic,weak) UIViewController *myVC;
@property (nonatomic,assign) CGFloat maxWidth;
@end

@implementation CZWShowImageView

- (instancetype)initWithFrame:(CGRect)frame ViewController:(UIViewController *)ViewController
{
    self = [super initWithFrame:frame];
    if (self) {
         _myVC = ViewController;
    
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(0, 0, CGRectGetWidth(frame)/3-5, CGRectGetWidth(frame)/3-5);
        [addButton setImage:[UIImage imageNamed:@"auto_addImage"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        
        _imageArray = [[NSMutableArray alloc] init];
       
    }
    return self;
}

- (instancetype)initWithWidth:(CGFloat)width ViewController:(UIViewController *)ViewController{
    if (self = [super init]) {
        _myVC = ViewController;
        _maxWidth = width;
        
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(0, 0, width/3-5, width/3-5);
        [addButton setImage:[UIImage imageNamed:@"auto_addImage"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        
        _imageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _maxWidth = frame.size.width;
}

-(void)buttonClick{

    [self.myVC.view endEditing:YES];
    __weak __typeof(self)weakSelf = self;
    CZWActionSheet *actionSheet = [[CZWActionSheet alloc] initWithArray:@[@"拍照",@"从相册选择",@"取消"]];
    [actionSheet choose:^(CZWActionSheet *actionSheet, NSInteger selectedIndex) {
        if (selectedIndex == 0) {
            if (myPicker == nil) {
                myPicker = [[UIImagePickerController alloc] init];
                myPicker.delegate = weakSelf;
            }
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [weakSelf.myVC presentViewController:myPicker animated:YES completion:nil];
            }
            
        }else if (selectedIndex == 1){
            LHAssetPickerController *picker = [[LHAssetPickerController alloc] init];
            picker.maxNumber = weakSelf.maxNumber - weakSelf.imageArray.count;
            [picker getAssetArray:^(NSArray *assetArray) {
                
                for (int i = 0; i < assetArray.count; i ++) {
                    ALAsset *asset = assetArray[i];
                    if (weakSelf.imageArray.count < weakSelf.maxNumber) {
                        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                        //增加图片---回调
                        image = [self scaleToSize:image size:image.size];
                        //延迟执行
                       
                        if (self.addImage) {
                           
                            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, i*0.25*NSEC_PER_SEC);
                            dispatch_after(time, dispatch_get_main_queue(), ^{
                                weakSelf.addImage(image);
                               
                            });
                        }
                        [weakSelf.imageArray addObject:image];
                    }
                }
                [weakSelf showImage:weakSelf];
            }];
            picker.maxNumber = weakSelf.maxNumber - weakSelf.imageArray.count;
            [weakSelf.myVC presentViewController:picker animated:YES completion:NULL];
        }
    }];
    [actionSheet show];
}


//**显示图片*/
-(void)showImage{
     __weak __typeof(self)weakSelf = self;
    [self showImage:weakSelf];
}

#pragma mark -  显示图片
-(void)showImage:(CZWShowImageView *)weakSelf{
    
    for (UIView *view in weakSelf.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    if (self.imageArray.count == 0) {
        addButton.hidden = NO;
        addButton.frame = CGRectMake(0, 0, CGRectGetWidth(addButton.frame), CGRectGetHeight(addButton.frame));
    }
    for (int i = 0; i < _imageArray.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.maxWidth/3*(i%3), self.maxWidth/3*(i/3), addButton.frame.size.width, addButton.frame.size.height)];
        UIImage *image = weakSelf.imageArray[i];
        CGFloat distance = MIN(image.size.height, image.size.width);
        imageView.image = [self getSubImage:image mCGRect:CGRectMake(0, 0, distance, distance) centerBool:YES];
        imageView.tag = 200+i;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageView addGestureRecognizer:tap];
        
        if (i == weakSelf.imageArray.count-1) {
         
            if (weakSelf.imageArray.count == weakSelf.maxNumber) {
                addButton.hidden = YES;
                addButton.frame = imageView.frame;
            }else{
                addButton.hidden = NO;
                int k = i+1;
                addButton.frame = CGRectMake(self.maxWidth/3*(k%3), self.maxWidth/3*(k/3), addButton.frame.size.width, addButton.frame.size.height);
            }
        }
        CGRect frame = weakSelf.frame;
        frame.size.height = addButton.frame.size.height+addButton.frame.origin.y;
        weakSelf.height = addButton.frame.size.height+addButton.frame.origin.y;
        weakSelf.frame = frame;
        if (weakSelf.updateFrame) {
            weakSelf.updateFrame(frame);
        }
    }
  
    if (weakSelf.translatesAutoresizingMaskIntoConstraints == NO) {
        [weakSelf updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakSelf.height);
        }];
    }
}

#pragma mark - 图片手势响应方法
-(void)imageTap:(UITapGestureRecognizer *)tap {
    
    EditImageViewController *editor = [[EditImageViewController alloc] init];
    editor.imageArray = self.imageArray;
    editor.index = tap.view.tag - 200;
    __weak __typeof(self)weakSelf = self;
    [editor deleteImage:^(NSInteger index) {
        [weakSelf showImage:weakSelf];
    }];
    [self.myVC.navigationController pushViewController:editor animated:YES];

}


/**
 *  修改申诉图片链接下载
 *
 *  @param imageUrlArray <#imageUrlArray description#>
 */
-(void)setImageUrlArray:(NSArray<__kindof NSString *> *)imageUrlArray{
    _imageUrlArray = imageUrlArray;
   
    __weak __typeof(self)weakSelf = self;
    for (int i = 0; i < _imageUrlArray.count; i ++) {
        NSString *url = _imageUrlArray[i];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                image.urlString = url;
                [weakSelf.imageArray addObject:image];
                [weakSelf showImage:weakSelf];
            }
        }];
    }
    
}
#pragma mark - 改变图片尺寸
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
   
    if (img.size.width <= size.width && img.size.height <= size.height){
        return img;
    }
    CGFloat maxXY = MAX(size.width, size.height);
    CGFloat xs = maxXY>700?700.0/maxXY:1;
    size = CGSizeMake(size.width*xs, size.height*xs);
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

- (UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
        
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

-(void)updateFrame:(void (^)(CGRect))block{
    self.updateFrame = block;
}

-(void)addImage:(void (^)(UIImage *))block{
    self.addImage = block;
}

#pragma mark - ###########################################################################
#pragma mark - 选择照片代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (_imageArray.count < self.maxNumber) {
    
        image = [self scaleToSize:image size:image.size];
        [_imageArray addObject:image];
        //增加图片---回调
        if (self.addImage) {
            self.addImage(image);
        }
        __weak __typeof(self)weakSelf = self;
        [self showImage:weakSelf];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.myVC dismissViewControllerAnimated:YES completion:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
